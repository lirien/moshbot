#!/bin/bash

watchman-make --make='bundle exec rake' -p spec/* -t test
