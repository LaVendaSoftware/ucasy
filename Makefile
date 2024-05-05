GEM_TO_PUSH = `ls ucasy*.gem | tail -n 1`

build:
	gem build ucasy.gemspec

publish:
	@echo "gem push ${GEM_TO_PUSH}"
	@gem push ${GEM_TO_PUSH}
