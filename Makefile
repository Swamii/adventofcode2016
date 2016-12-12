.PHONY: build run

build:
	swift build

run: build
	./.build/debug/AdventOfCode2016 day$(DAY)
