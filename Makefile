# inject the variables required to deploy, if available (but don't track them in git)
-include ./config.mk

.PHONY: prepare build run watch deploy

prepare:
	cat config.common.toml configs/config.en.toml configs/config.fr.toml > config.toml

build: prepare
	# pass arguments <arg1> and <arg2> to the 'hugo' binary by running: make -- build <arg1> <arg2>
	# EG: make -- build --buildDrafts --baseURL http://rebrand.cloud.ca
	rm -rf public
	./hugow --theme cca-general $(filter-out $@,$(MAKECMDGOALS))

run: prepare
	# pass arguments <arg1> and <arg2> to the 'hugo' binary by running: make -- run <arg1> <arg2>
	# EG: make -- run --buildDrafts --baseURL http://rebrand.cloud.ca
	./hugow server --disableFastRender --theme cca-general $(filter-out $@,$(MAKECMDGOALS))

watch:
	# watch the configs directory
	if [ "`uname -s`" = "Darwin" ]; then \
		fswatch -0 \
			configs \
			config.common.toml \
		| xargs -0 -n 1 -I {} $(MAKE) prepare; \
	else \
		while true; do \
			inotifywait --recursive -e modify,create,delete \
				configs \
				config.common.toml \
			&& $(MAKE) prepare; \
		done \
	fi

deploy:
	swiftly -dir=public -identity=$(IDENTITY) -password=$(PASSWORD) -domain=$(DOMAIN)

%:
	@:
