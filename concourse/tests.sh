#!/usr/bin/env bash

# Ensure we exit with failure if anything here fails
set -e

INITIAL_FOLDER=`pwd`

# cd into the codebase, as per CI source
cd code
mkdir reports

# Install xdebug & disable
PHP_VERSION=$(php -r "echo preg_replace('/.[0-9]+(-.*)?$/', '', phpversion());")
apt-get update
apt-get install -y php${PHP_VERSION}-xdebug make
phpdismod xdebug

composer -o install

# Static analysis, unit tests
make all -e XDEBUG_MODE=coverage

# Go back to initial working dir to allow outputs to function
cd ${INITIAL_FOLDER}

# Copy reports to output (only of output is defined)
[ -d "coverage-reports"  ] && cp code/reports/* coverage-reports/ -Rf || exit 0
