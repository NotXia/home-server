#! /bin/bash

#
# $1: restic repository path
#

restic --repo $1 backup --tag actual ./data