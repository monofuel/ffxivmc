all: core_js models_js routes_js util_js public_js

start: all
	supervisor -w .,./models/,./routes/,./util/ node app.js

watch: watch_core_js watch_routes_js watch_models_js watch_util_js watch_public_js

core_js:
	coffee -cb ./*.coffee

models_js:
	coffee -cb models/*.coffee

routes_js:
		coffee -cb routes/*.coffee

util_js:
	coffee -cb util/*.coffee

public_js:
	coffee -cb ./public/js/*.coffee
	coffee -cb ./public/market/*.coffee
	coffee -cb ./public/admin/*/*.coffee

watch_public_js:
	coffee -wcb ./public/js/*.coffee &
	coffee -wcb ./public/market/*.coffee &
	coffee -wcb ./public/admin/*/*.coffee &

watch_core_js:
	coffee -wcb ./*.coffee &

watch_routes_js:
	coffee -wcb ./routes/*.coffee &

watch_util_js:
	coffee -wcb ./util/*.coffee &

watch_models_js:
	coffee -wcb ./models/*.coffee &
