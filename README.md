# tekton-poc#

Tekton is a powerful and flexible open-source framework for creating CI/CD systems, allowing developers to build, test, and deploy across cloud providers and on-premise systems. It provides Kubernetes-style resources for declaring CI/CD-style pipelines.

When creating tekton pipelines, we need to create the following resources:
- tasks (These are the modular units of work in a pipeline)
- pipelines (These are a collection of tasks that are executed sequentially)
- pipelineRuns (These are the execution of a pipeline)

TODO:
Add Tekton install instructions
Add repo bootstrap instructions

## First iteration learning tekton(Always Fail)
In this first iteration, I will be learning tekton by creating a simple pipeline that will execute two tasks. The first task will pass and the second task will fail. The pipeline will be executed by a pipelineRun. This pipeline will always fail.

To run the first example in this repo you will need to apply the following resources:

Tasks:
```
kubectl(or oc) apply -f tekton-poc/task/sample_pass_task.yml
kubectl(or oc) apply -f tekton-poc/task/sample_fail_task.yml
```

Pipelines:
```
kubectl(or oc) apply -f tekton-poc/pipelines/sample_pipeline.yml
```

PipelineRuns:
```
kubectl(or oc) apply -f tekton-poc/pipelineruns/sample_pipelinerun.yml
```

## Second iteration learning tekton(Passing Params)
In this second iteration, I will be learning tekton by creating a simple pipeline that will execute two tasks. The first task will echo out results from a parameter passed in. The second task will echo out results from a parameter passed in. The pipeline will be executed by a pipelineRun. This pipeline will always pass.

To run the second example in this repo you will need to apply the following resources:

Tasks:
```
kubectl(or oc) apply -f tekton-poc/task/sample_first_task_param_output.yml
kubectl(or oc) apply -f tekton-poc/task/sample_second_task_param_consumer.yml
```

Pipelines:
```
kubectl(or oc) apply -f tekton-poc/pipelines/sample_passing_params_through_task.yml
```

PipelineRuns:
```
kubectl(or oc) apply -f tekton-poc/pipelineruns/sample_passing_params_through_task.yml
```

## Third iteration learning tekton(PoC of a pipeline that will promote operator SSS)
In this third iteration, I will be putting together a lightweight PoC of a pipeline that will assume a few things:
1. The integration environment is already deployed.
2. The First task this pipeline will run an acceptance test
    a. This will make sure that the csv for the operators have been deployed successfully.
3. The Second task will create a PR that promotes an operator hash unto the next sector-region combo.
4. The Third task will watch this PR to a max of 3 days. If the PR is not merged within 3 days, the pipeline will fail.
5. Once the PR is merged, the task will pass.
6. It will rinse and repeat for the next sector-region combo.


## Useful commands for tekton
```
kubectl(oc) get taskruns
kubectl(oc) get pipelineruns
```

## Troubleshooting Tekton
When I ran 'oc get pods' I didn't see any pods created.
In this case running 'oc describe pipelinerun.tekton.dev/example-pipeline-passing-params-through-task-run-wdrvt created' will give you more information on why the pipeline failed.
In this case I had to see the individual taskruns to see why the pipeline failed. The taskruns could not create pods due to securityContext constraints. These have been updated in the taskruns in this repo.

## Troubleshooting Openshift

Spoke with @\mshen on this since he was around.
So I'm creating a pod like this
    - name: run-container
      image: quay.io/dsantama/acceptance_test:latest
      securityContext:
        allowPrivilegeEscalation: false
        runAsNonRoot: true
        runAsUser: 1001
        capabilities:
          drop:
            - ALL
        seccompProfile:
          type: RuntimeDefault
Now I did the runAsuser:1001 on purpose to match my docker file over here.
https://github.com/MrSantamaria/acceptance_test/blob/main/Dockerfile#L51
The problem I'm getting is that my pod needs to create a file inside of /app
Which when I run docker run -it --name test-container myapp:latest /bin/sh it can.
So I'm wondering if this could be an openshift restriction I don't know about.
Maybe it is as simple as swapping the acceptance user to be in the range of?
Invalid value: 1001: must be in the ranges: [1001030000, 1001039999],
But I can't seem to understand why that matters inside of the pod environment.
I think I have it troubleshooted to be part of
seccompProfile:
          type: RuntimeDefault
but do we restrict pods from creating files like this?

It sounds like you’re running into a security context constraint: https://docs.openshift.com/container-platform/4.14/authentication/managing-security-context-constraints.html#authorization-SCC-[…]ing-internal-oauth
They can be configured with UID ranges at least^
