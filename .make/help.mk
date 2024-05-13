# Make all command targets non-file targets
.PHONY: ⚙️

# regex patterns for command targets and variables
⚙️_name := [a-zA-Z][a-zA-Z0-9_-]*
⚙️←info := :[^\#]*\#\# *
⚙️←val  := [:?]*= *
⚙️_fmt  := "  \033[1m%-10s\033[0m %s\n"

all: ⚙️  # make 'all' the default target

help: usage vars  ## Show usage message and variables

# Auto generate usage info for Makefile
usage: ⚙️  ## Show this help message
	@echo "Usage: make [target]\n\nTargets:"
	@awk 'BEGIN {FS = "$(⚙️←info)"} /^$(⚙️_name)$(⚙️←info)/ {printf $(⚙️_fmt), $$1, $$2}' $(MAKEFILE_LIST)

# Auto generate variables names hard-coded values
vars: ⚙️  ## Show all variables
	@echo "\nVariables:"
	@awk 'BEGIN {FS = " *$(⚙️←val)"} /^$(⚙️_name) *$(⚙️←val)/ {if (!seen[$$1]++) printf $(⚙️_fmt), $$1, $$2}' $(MAKEFILE_LIST)

unexport ⚙️_name ⚙️_fmt ⚙️←info ⚙️←val
