# Makefile for Flutter project with code generation

# Define variables
FLUTTER = flutter
GEN_CMD = flutter pub run build_runner build --delete-conflicting-outputs

# Default target
all: get_deps generate build

# Get dependencies
get_deps:
	$(FLUTTER) pub get

# Generate code
gen:
	$(FLUTTER) pub get
	flutter pub run build_runner build --delete-conflicting-outputs

# Build the project
build:
	$(FLUTTER) build apk

# Clean the project
clean:
	$(FLUTTER) clean

# Run the project
run:
	$(FLUTTER) run

# Format the code
format:
	$(FLUTTER) format .

# Analyze the code
analyze:
	$(FLUTTER) analyze

.PHONY: all get_deps generate build clean run format analyze