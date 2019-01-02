# Cromwell task monitor

This repo contains code for monitoring resource utilization in
[Cromwell](https://github.com/broadinstitute/cromwell)
tasks running on
[Google Genomics Pipelines API v2alpha1](https://cloud.google.com/genomics/reference/rest/v2alpha1/pipelines).

The [monitoring script](monitor.py)
is indended to be used through a Docker image (as part of an associated "monitoring action"), currently built as
[quay.io/broadinstitute/cromwell-monitor](https://quay.io/repository/broadinstitute/cromwell-monitor).

It uses [psutil](https://psutil.readthedocs.io) to
continuously measure CPU, memory and disk utilization
and disk IOPS, and periodically report them
as distinct metrics to Stackdriver Monitoring API.

The labels for each time point contain
- Cromwell-specific values, such as workflow ID, task call name, index and attempt.
- GCP instance values such as instance name, zone, number of CPU cores, total memory and disk size.

This approach enables:

1)  Users to easily plot real-time resource usage statistics across all tasks in
    a workflow, or for a single task call across many workflow runs,
    etc.

    This can be very powerful to quickly determine the outlier tasks
    that could use optimization, without the need for any configuration
    or code.

2)  Scripts to easily get aggregate statistics
    on resource utilization and to produce suggestions
    based on those.

[TestMonitoring.wdl](TestMonitoring.wdl) can be used to
verify that the monitoring action/container is
working as intended.
