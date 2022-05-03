RELEASE_VERSION ?= 0.0.1
STEMCELL_VERSION ?= 621.64
MINIMUM_VERSION ?= 0.0.0

project_dir=$(CURDIR)
build_dir=/tmp
tile_dir=${project_dir}/tile
release_dir=release-tarballs
TILE_FILE=${build_dir}/example-tile-${RELEASE_VERSION}.pivotal

.PHONY:tile
tile: ${release_dir}/example-bosh-release.tgz ${release_dir}/bpm-release-1.1.15.tar.gz
	kiln bake \
	  --icon ${tile_dir}/wavefront.png \
	  --instance-groups-directory ${tile_dir}/instance_groups \
	  --forms-directory ${tile_dir}/forms \
	  --jobs-directory ${tile_dir}/jobs \
	  --metadata ${tile_dir}/tile.yml \
	  --output-file ${TILE_FILE} \
	  --properties-directory ${tile_dir}/properties \
	  --releases-directory ${release_dir} \
	  --runtime-configs-directory ${tile_dir}/runtime_configs \
	  --variable="stemcell_version=${STEMCELL_VERSION}" \
	  --variable="minimum_version=${MINIMUM_VERSION}" \
	  --version "${RELEASE_VERSION}"
	 @echo "${TILE_FILE} is done baking"

.PHONY: clean
clean: clean-release-tarballs

.PHONY: clean-release-tarballs
clean-release-tarballs:
	-rm -r ${release_dir}/*

${release_dir}/example-bosh-release.tgz:
	cd releases/example-release && \
	bosh create-release ${BOSH_OPTS} \
		--name example \
		--tarball ../../${release_dir}/example-bosh-release.tgz --force

${release_dir}/bpm-release-1.1.15.tar.gz:
	curl -L --output $@ https://bosh.io/d/github.com/cloudfoundry/bpm-release?v=1.1.15

${release_dir}/syslog-release-11.tgz:
	curl -L --output $@ https://bosh.io/d/github.com/cloudfoundry/syslog-release?v=11

