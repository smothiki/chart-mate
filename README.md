chart-mate
======

[![Build Status](https://travis-ci.org/sgoings/chart-mate.svg?branch=master)](https://travis-ci.org/sgoings/chart-mate)

chart-mate is a [rerun][rerun] module that can be run on OSX or Linux in order
to help run e2e tests of [helm][helm] charts on a real [kubernetes][kubernetes]
cluster.

Purpose
-------

chart-mate's single purpose in life is to fill some gaps in our existing tooling.
**Therefore, this project should be treated as a dwindling set of shims and glue.**
If you happen to create functionality in Deis, Helm, or another tool altogether
that does one of chart-mate's actions and associated anti-actions (such as up/down)
then please feel free to have either chart-mate or [deis charts' ci process](https://github.com/deis/charts/blob/master/ci.sh)
benefit from those improvements. Also, give yourself a gold star.

Actions (and why they need to exist)
-------

### bumpver

Change the versions of components. In the beginning, helm didn't have an easy
automated way to change versions or references to variable items in a chart.

### check

Run a few healthchecks of the deis platform before kicking off the tests. This
is a stopgap until we have a way of verifying Deis (or any other complicated
application stack) using Helm.

### down

Tear down the kubernetes cluster you've been operating on this whole time. This
is just a thin wrapper around a `gcloud container clusters delete <cluster name>`
Soon this action will be superceded or bolstered by [k8s-claimer].

### init

Creates a cluster name and saves to chart-mate's default environment file. This
file determines what cluster is acted upon by other actions.

### install

Installs deis with helm (ensures that the repo exists and is installable as much
as possible). There's just enough madness when it comes to installing charts
(especially in tandem with the bumpver command) that this wraps some of the
associated helm commands such as:

  ```
  helm repo add ...
  helm fetch ...
  helm update ...
  helm generate ...
  helm install ...
  ```

### test

Run the e2e test suite for deis workflow.

### uninstall

Uninstall the deis platform (don't tear down the underlying kubernetes cluster)
Soon this action will be superceded or bolstered by [k8s-claimer].

### up

Create a kubernetes cluster (currently only supports Google Container Engine).
Soon this action will be superceded or bolstered by [k8s-claimer].

Why Create A Separate Project?
----------

The only place where chart-mate is (and should be) used is when trying to test
Deis Workflow in an end to end fashion. That process is nicely explained in code
within the [deis/charts](https://github.com/deis/charts/blob/master/ci.sh)'s ci script.

The reasoning behind why chart-mate became a separate project
held within deis/charts was because of its similar purpose in the helm/charts
project and a desire to allow engineers to easily run individual CI actions on their
own machines without being bound to the CI system. I see less value in trying
to use chart-mate for helm/charts now and instead focusing more effort on providing
the functionality described above in smaller, more focused, and more maintainable tools.

Hacking Setup
----------

1. Get `chart-mate`

  ```
  git clone https://github.com/sgoings/chart-mate.git
  cd chart-mate
  ```

2. Run the `hacking.sh` script

  ```
  ./hacking.sh
  ```

3. Source the `hacking.sh` script

  ```
  source hacking.sh
  ```

4. Run `rerun chart-mate`!

  ```
  rerun chart-mate
  ```

[helm]: http://helm.sh
[k8s-claimer]: https://github.com/deis/k8s-claimer
[kubernetes]: http://kubernetes.io
[rerun]: http://rerun.github.io/rerun/
