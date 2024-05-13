include .make/help.mk

RELEASE ?= debug
APP_NAME = $(shell basename $(CURDIR))
RUN_ARGS =

all: ⚙️ build

clean: ⚙️  ## Clean the project
	@echo "Cleaning..."
	swift package clean
	rm -rf .build

build: ⚙️  ## Build the project
	@echo "Building..."
	swift build -c $(RELEASE)

run: ⚙️  ## Run the project
	@echo "Running $(APP_NAME)..."
	swift run -c $(RELEASE) $(APP_NAME) $(RUN_ARGS)
