# inject the variables required to deploy, if available (but don't track them in git)
-include ./config.mk

# tmp build directory
TMP_DIR = /tmp

# LESS params
LESS_DIR = ./static/less
LESS_FILE = main.less

# CSS params
CSS_DIR = ./static/css
CSS_FILE = main.min.css
CSS_TMP_FILE = tmp.css

# JS params
JS_DIR = ./static/js
JS_SRC_FILE = main.js
JS_MIN_FILE = main.min.js

.PHONY: clean-css clean-js build build-css build-js build-conf run

clean-css:
	rm -f $(CSS_DIR)/$(CSS_FILE)

clean-js:
	rm -f $(JS_DIR)/$(JS_MIN_FILE)

prepare: prepare-css prepare-js prepare-conf
	cd themes/cca-general && $(MAKE) prepare

prepare-css: clean-css
	if [ -d "$(LESS_DIR)" ]; then \
		lessc $(LESS_DIR)/$(1) > $(TMP_DIR)/$(CSS_TMP_FILE); \
		uglifycss $(TMP_DIR)/$(CSS_TMP_FILE) > $(CSS_DIR)/$(2); \
		rm -f $(TMP_DIR)/$(CSS_TMP_FILE); \
	fi

prepare-js: clean-js
	if [ -d "$(JS_DIR)" ]; then \
		uglifyjs $(JS_DIR)/$(JS_SRC_FILE) > $(JS_DIR)/$(JS_MIN_FILE); \
	fi

prepare-conf:
	cat config.common.toml configs/config.en.toml configs/config.fr.toml > config.toml

build: prepare
	# pass arguments <arg1> and <arg2> to the 'hugo' binary by running: make -- build <arg1> <arg2>
	# EG: make -- build --buildDrafts -b http://rebrand.cloud.ca
	./hugow --theme cca-general $(filter-out $@,$(MAKECMDGOALS))

run: prepare
	# pass arguments <arg1> and <arg2> to the 'hugo' binary by running: make -- run <arg1> <arg2>
	# EG: make -- run --buildDrafts -b http://rebrand.cloud.ca
	./hugow server --disableFastRender --theme cca-general $(filter-out $@,$(MAKECMDGOALS))

watch:
	# watch the static-src directory and prepare css and js on demand
	fswatch -0 themes/cca-general/static-src configs config.common.toml | xargs -0 -n 1 -I {} make prepare

deploy:
	swiftly -dir=public -identity=$(IDENTITY) -password=$(PASSWORD) -domain=$(DOMAIN)
