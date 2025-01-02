#! /bin/bash

#
# $1: backup path
#

rsync -azv --progress ./library/library $1/immich
rsync -azv --progress ./library/upload $1/immich
rsync -azv --progress ./library/profile $1/immich