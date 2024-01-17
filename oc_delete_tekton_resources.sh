#!/bin/bash

# Delete all pipelineruns
oc delete pipelineruns --all

# Delete all pipelines
oc delete pipelines --all

# Delete all taskruns
oc delete taskruns --all

# Delete all tasks
oc delete tasks --all
