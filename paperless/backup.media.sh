#! /bin/bash

#
# $1: backup path
#

rsync -azv --progress ./export/backup/ $1/paperless