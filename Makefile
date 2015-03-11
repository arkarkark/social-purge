SRC_ICON = shredder_icon_by_deviaanimus-d340bus.png
CSON_FILES = $(wildcard *.cson)
COFFEE_FILES = $(wildcard *.coffee)
ICONS=icon128.png icon48.png icon38.png icon19.png icon16.png
ZIP_EXCLUDE= $(CSON_FILES) $(COFFEE_FILES) .git* $(SRC_ICON) screenshot*.png Makefile README.md \
	bower_components/* bower.json node_modules/* package.json


JSON_FILES = $(CSON_FILES:.cson=.json)
JS_FILES = $(COFFEE_FILES:.coffee=.js)

space :=
space +=
ZIP_EXCLUDE_FLAGS = --exclude=$(subst $(space),$(space)--exclude=,$(ZIP_EXCLUDE))

build: setup $(wildcard **/*) $(ICONS) $(JSON_FILES) $(JS_FILES) vendor
	dirname=$(shell basename $(PWD)); zip -r $(ZIP_EXCLUDE_FLAGS) ../$$dirname.zip . $(ZIP_INCLUDES)

clean:
	rm -fv $(JSON_FILES) $(JS_FILES) $(ICONS)
	rm -rf bower_components/ node_modules/ vendor/

%.json : %.cson
	./node_modules/cson-cli/bin/cson2json $< > $@

%.js : %.coffee
	./node_modules/coffee-script/bin/coffee -p $< > $@

icon%.png: $(SRC_ICON)
	convert $(SRC_ICON) -resize $* $@

vendor: vendor/jquery.js

vendor/jquery.js: bower_components/jquery/dist/jquery.min.js
	mkdir -p vendor
	cp $< $@
	cp bower_components/jquery/dist/jquery.min.map vendor/

setup: package.json
	npm install
