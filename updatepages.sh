#!/usr/bin/bash
set -feuo pipefail

PAGES=pages
SOURCE=page_files

datestr="<em>This page was last updated at $(date +"%H:%M") on $(date +"%m\/%d\/%Y").<\/em>"

readarray < <(git  diff-tree -r --name-only HEAD^..HEAD | grep -oP "(?<=^$SOURCE/).*\.html$") changes

# delete files to be regenerated
for file in "${changes[@]}"; do
	file=${file%$'\n'}
	echo "Removing \"$PAGES/$file\""
	[ -f "$PAGES/$file" ] && rm -f "$PAGES/$file"
done

# regenerate missing files
for file in $(find "$SOURCE" -type f -name "*.html" -printf "%P\n"); do
	[ -e "$PAGES/$file" ] && continue
	dir=$(dirname $file)
	[ -e "$PAGES/$dir" ] || mkdir -p "$dir"
	echo "Generating \"$PAGES/$file\""
	sed "s/<!--DATE-->/$datestr/g" "$SOURCE/$file" > "$PAGES/$file"
	chmod a-w "$PAGES/$file"
done

# remove empty directories
for dir in $(find "$PAGES" -type d -empty); do
	echo "Removing empty directory \"$dir\""
	rmdir "$dir"
done
