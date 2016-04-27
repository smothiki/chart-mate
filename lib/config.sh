PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# helm configuration
export HELM_ARTIFACT_REPO="${HELM_ARTIFACT_REPO:-helm}"
export HELM_REMOTE_NAME="${HELM_REMOTE_NAME:-deis}"
export HELM_REMOTE_REPO="${HELM_REMOTE_REPO:-https://github.com/deis/charts.git}"
export HELM_REMOTE_BRANCH="${HELM_REMOTE_BRANCH:-master}"
export WORKFLOW_CHART="${WORKFLOW_CHART:-workflow-dev}"
export WORKFLOW_E2E_CHART="${WORKFLOW_E2E_CHART:-workflow-dev-e2e}"

if [ -n "${JOB_NAME}" ]; then
  export HELM_HOME="${HOME}/.helm/${JOB_NAME}/${BUILD_NUMBER}"
else
  export HELM_HOME="${HOME}/.helm"
fi
echo "Setting HELM_HOME to ${HELM_HOME}"

# cluster defaults
GOOGLE_SDK_DIR="${HOME}/google-cloud-sdk"
CLUSTER_NAME="${CLUSTER_NAME:-helm-testing}"
GCLOUD_PROJECT_ID="${GCLOUD_PROJECT_ID:-${CLUSTER_NAME}}"
K8S_ZONE="${K8S_ZONE:-us-central1-b}"
K8S_CLUSTER_NAME="${K8S_CLUSTER_NAME:-${GCLOUD_PROJECT_ID}-$(openssl rand -hex 2)}"

# chart mate defaults
CHART_MATE_ENV_ROOT="${CHART_MATE_HOME}/${K8S_CLUSTER_NAME}"
BIN_DIR="${CHART_MATE_ENV_ROOT}/.bin"
export SECRETS_DIR="${CHART_MATE_ENV_ROOT}"

# timing defaults
export HEALTHCHECK_TIMEOUT_SEC=120

# credentials
export GCLOUD_CREDENTIALS_FILE="${GCLOUD_CREDENTIALS_FILE:-${HOME}/.secrets/helm-testing-creds.json}"
if [ ! -z "${JENKINS_URL}" ]; then
  # Running in Jenkins
  mkdir -p "${HOME}/.secrets/"
  echo ${GCLOUD_CREDENTIALS} > "${GCLOUD_CREDENTIALS_FILE}"
  export DEIS_LOG_DIR="${WORKSPACE}/logs/${BUILD_NUMBER}"
else
  # Not running in Jenkins
  export DEIS_LOG_DIR="${CHART_MATE_HOME}/logs"
fi
mkdir -p "${DEIS_LOG_DIR}"

export K8S_EVENT_LOG="${DEIS_LOG_DIR}/k8s-events.log"
export DEIS_DESCRIBE="${DEIS_LOG_DIR}/deis-describe.txt"

# path setup
export PATH="${CHART_MATE_ENV_ROOT}/.bin:${GOOGLE_SDK_DIR}/bin:$PATH"

if [ -n "${BUILDER_SHA}" ]; then
  export "BUILDER_GIT_TAG"="git-${BUILDER_SHA:0:7}"
  echo "Setting BUILDER_GIT_TAG to ${BUILDER_GIT_TAG}"
fi

if [ -n "${CONTROLLER_SHA}" ]; then
  export "CONTROLLER_GIT_TAG"="git-${CONTROLLER_SHA:0:7}"
  echo "Setting CONTROLLER_GIT_TAG to ${CONTROLLER_GIT_TAG}"
fi

if [ -n "${DOCKERBUILDER_SHA}" ]; then
  export "DOCKERBUILDER_GIT_TAG"="git-${DOCKERBUILDER_SHA:0:7}"
  echo "Setting DOCKERBUILDER_GIT_TAG to ${DOCKERBUILDER_GIT_TAG}"
fi

if [ -n "${FLUENTD_SHA}" ]; then
  export "FLUENTD_GIT_TAG"="git-${FLUENTD_SHA:0:7}"
  echo "Setting FLUENTD_GIT_TAG to ${FLUENTD_GIT_TAG}"
fi

if [ -n "${LOGGER_SHA}" ]; then
  export "LOGGER_GIT_TAG"="git-${LOGGER_SHA:0:7}"
  echo "Setting LOGGER_GIT_TAG to ${LOGGER_GIT_TAG}"
fi

if [ -n "${MINIO_SHA}" ]; then
  export "MINIO_GIT_TAG"="git-${MINIO_SHA:0:7}"
  echo "Setting MINIO_GIT_TAG to ${MINIO_GIT_TAG}"
fi

if [ -n "${POSTGRES_SHA}" ]; then
  export "POSTGRES_GIT_TAG"="git-${POSTGRES_SHA:0:7}"
  echo "Setting POSTGRES_GIT_TAG to ${POSTGRES_GIT_TAG}"
fi

if [ -n "${REGISTRY_SHA}" ]; then
  export "REGISTRY_GIT_TAG"="git-${REGISTRY_SHA:0:7}"
  echo "Setting REGISTRY_GIT_TAG to ${REGISTRY_GIT_TAG}"
fi

if [ -n "$ROUTER_SHA" ]; then
  export "ROUTER_GIT_TAG"="git-${ROUTER_SHA:0:7}"
  echo "Setting ROUTER_GIT_TAG to ${ROUTER_GIT_TAG}"
fi

if [ -n "${SLUGBUILDER_SHA}" ]; then
  export "SLUGBUILDER_GIT_TAG"="git-${SLUGBUILDER_SHA:0:7}"
  echo "Setting SLUGBUILDER_GIT_TAG to ${SLUGBUILDER_GIT_TAG}"
fi

if [ -n "${SLUGRUNNER_SHA}" ]; then
  export "SLUGRUNNER_GIT_TAG"="git-${SLUGRUNNER_SHA:0:7}"
  echo "Setting SLUGRUNNER_GIT_TAG to ${SLUGRUNNER_GIT_TAG}"
fi

if [ -n "${WORKFLOW_E2E_SHA}" ]; then
  export "WORKFLOW_E2E_GIT_TAG"="git-${WORKFLOW_E2E_SHA:0:7}"
  echo "Setting WORKFLOW_E2E_GIT_TAG to ${WORKFLOW_E2E_GIT_TAG}"
fi

# color variables
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset

pass="${bldblu}-->${txtrst}"
warn="${bldred}-->${txtrst}"
ques="${bldblu}???${txtrst}"
