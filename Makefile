all: models util

core: ./*.coffee
	coffee -cb ./*.coffee

models: models/*
	coffee -cb models/*

util: util/*
	coffee -cb util/*
