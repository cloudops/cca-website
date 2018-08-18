# inject the variables required to deploy, if available (but don't track them in git)
-include ./config.mk

# tmp build directory
TMP_DIR = /tmp
TMP_CSS_FILE = tmp.css

# LESS params
LESS_DIR = ./resources/less
LESS_FILE = main.less

# CSS params
CSS_DIR = ./static/css
CSS_FILE = main.min.css

# JS params
JS_SRC_DIR = ./resources/js
JS_SRC_FILE = main.js
JS_DEST_DIR = ./static/js
JS_DEST_FILE = main.min.js

.PHONY: prepare prepare-css prepare-js prepare-conf prepare-themes build run watch deploy

define clean_css
	rm -f $(CSS_DIR)/$(CSS_FILE)
endef

define clean_js
	rm -f $(JS_DEST_DIR)/$(JS_DEST_FILE)
endef

prepare: prepare-css prepare-js prepare-conf prepare-themes

prepare-css:
	if [ -d "$(LESS_DIR)" ]; then \
		$(call clean_css); \
		lessc $(LESS_DIR)/$(LESS_FILE) > $(TMP_DIR)/$(TMP_CSS_FILE); \
		uglifycss $(TMP_DIR)/$(TMP_CSS_FILE) > $(CSS_DIR)/$(CSS_FILE); \
		rm -f $(TMP_DIR)/$(TMP_CSS_FILE); \
	fi

prepare-js:
	if [ -d "$(JS_SRC_DIR)" ]; then \
		$(call clean_js); \
		uglifyjs $(JS_SRC_DIR)/$(JS_SRC_FILE) > $(JS_DEST_DIR)/$(JS_DEST_FILE); \
	fi

prepare-conf:
	cat config.common.toml configs/config.en.toml configs/config.fr.toml > config.toml

prepare-themes:
	cd themes/cca-general && $(MAKE) prepare

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
	# watch the resources directory and prepare css and js on demand
	if [ "`uname -s`" = "Darwin" ]; then \
		fswatch -0 \
			resources \
			configs \
			config.common.toml \
			themes/cca-general/resources \
		| xargs -0 -n 1 -I {} make prepare; \
	else \
		while true; do \
			inotifywait --recursive -e modify,create,delete \
				resources \
				configs \
				config.common.toml \
				themes/cca-general/resources \
			&& $(MAKE) build; \
		done \
	fi

deploy:
	swiftly -dir=public -identity=$(IDENTITY) -password=$(PASSWORD) -domain=$(DOMAIN)

%:
	@:
