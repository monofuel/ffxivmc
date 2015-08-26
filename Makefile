all: core_js models_js util_js

start: all
	npm start

core_js: ./*.coffee
	coffee -cb ./*.coffee

models_js: models/*.coffee
	coffee -cb models/*.coffee

util_js: util/*.coffee
	coffee -cb util/*.coffee
