#!/usr/bin/bash
set -feuo pipefail

# page source directory
PAGE_FILE_DIR=page_files/
# page output directory
PAGE_DIR=pages/

# make sure we are in the right directory
cd "$(dirname $0)"

# check for directory
[ -e "$PAGE_DIR" ] || mkdir "$PAGE_DIR"

# generate pages that need to be generated
datestr="<em>This page was last updated at $(date +"%H:%M") on $(date +"%m\/%d\/%Y").<\/em>"
for page in $(find "$PAGE_FILE_DIR" -type f -printf "%P\n"); do
	[ -e "$PAGE_DIR$page" ] && continue
	page_dir=$(dirname "$page")
	[ -d "$PAGE_DIR$page_dir" ] || { mkdir -p "$PAGE_DIR$page_dir"; echo Created \"$PAGE_DIR$page_dir\"; }
	if [ "${page##*.}" = "html" ]; then
		# transformation for HTML files
		sed "s/<!--DATE-->/$datestr/g" "$PAGE_FILE_DIR$page" > "$PAGE_DIR$page"
	else
		# copy other files
		# TODO make this a hard link instead of a copy to save space
		#      (need to make sure this works well enough first)
		cp "$PAGE_FILE_DIR$page" "$PAGE_DIR$page"
	fi
	echo Generated \"$PAGE_DIR$page\"
done

empty_dirs=$(find "$PAGE_DIR" -type d -empty)
for empty_dir in $empty_dirs; do
	rmdir "$empty_dir"
	echo Removed \"$empty_dir\"
done
