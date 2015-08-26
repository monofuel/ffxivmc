all: models util

core: ./*.coffee
	coffee -cb ./*.coffee

models: models/*.coffee
	coffee -cb models/*.coffee

util: util/*.coffee
	coffee -cb util/*.coffee
