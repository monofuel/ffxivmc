all: core_js models_js routes_js util_js

start: all
	npm start

core_js:
	coffee -cb ./*.coffee

models_js:
	coffee -cb models/*.coffee

routes_js:
		coffee -cb routes/*.coffee

util_js:
	coffee -cb util/*.coffee
