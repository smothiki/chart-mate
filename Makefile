# makeup-managed:begin
include makeup.mk
# makeup-managed:end

SHORT_NAME := rerun

include $(MAKEUP_DIR)/makeup-bag-deis/info.mk

export VERSION := $(shell git describe --tags --always)

.PHONY: build
build:
	@_scripts/build.sh

.PHONY: prep-bintray-json
prep-bintray-json:
# TRAVIS_TAG is set to the tag name if the build is a tag
ifdef TRAVIS_TAG
	@jq '.version.name |= "$(VERSION)"' _scripts/ci/bintray-template.json | \
		jq '.package.repo |= "deis"' > _scripts/ci/bintray-ci.json
else
	@jq '.version.name |= "$(VERSION)"' _scripts/ci/bintray-template.json \
		> _scripts/ci/bintray-ci.json
endif

test:
	rerun stubbs:test --module chart-mate

docker-build:
	docker build -t "${SHORT_NAME}:${VERSION}" .

gen-build:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags '-s' -o bin/generator generate.go || exit 1
