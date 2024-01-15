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
