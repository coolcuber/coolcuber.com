#!/usr/bin/bash
set -euo pipefail

# page source directory
PAGE_FILE_DIR=page_files/
# page output directory
PAGE_DIR=pages/

# make sure we are in the right directory
cd "$(dirname $0)"

# check for directory
[ -e "$PAGE_DIR" ] && rm -r "$PAGE_DIR"* || mkdir "$PAGE_DIR"

# replace date on each page
datestr="This page was last updated at $(date +"%H:%M") on $(date +"%m\/%d\/%Y")."
cd "$PAGE_FILE_DIR"
for page in *; do
	sed "s/<!--DATE-->/$datestr/g" "$page" > "../$PAGE_DIR$page"
done
