function helm::setup {
  # Uses HELM_ARTIFACT_REPO to determine which repository to grab helm from

  if ! command -v helm &> /dev/null; then
    log-lifecycle "Installing helm into ${BIN_DIR}"

    mkdir -p ${BIN_DIR}
    (
      cd ${BIN_DIR}
      curl -s https://get.helm.sh | bash
    )
  fi
}
