#!/bin/bash

# Apply configurations from 'task' directory
oc apply -f task/

# Apply configurations from 'pipelines' directory
oc apply -f pipelines/

# Apply configurations from 'pipeline_runs' directory
oc create -f pipeline_runs/
