.PHONY: ⚙️

RELEASE ?= debug

all: ⚙️ build

build: ⚙️
	@echo "Building..."
	swift build -c $(RELEASE)

run: ⚙️
	@echo "Running..."
	swift run -c $(RELEASE)
