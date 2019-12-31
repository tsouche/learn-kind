#!/bin/bash

# Cleanup the various directories after deleting a kind cluster, and before 
# setting up a new one.

# Remove the old config file
rm -rf ~/.kube/*
mkdir ~/.kube
