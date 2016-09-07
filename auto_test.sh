#!/bin/bash

watchman-make --make='bundle exec rake' -p spec/* lib/* lib/**/* -t test
