#!/usr/bin/env bash
set -euo pipefail

scriptdir=$(dirname "$0")

SOURCE="$scriptdir/pages"
TEMPLATE="$scriptdir/template.html"

error() {
	echo "$1"
	exit 1
}

[ "$#" = "1" ] || error "Incorrect number of arguments"
mdfile="$1"
[[ "$mdfile" =~ ^.*\.md$ ]] || error "Is \"$mdfile\" a Markdown file?"
[ -e "$mdfile" ] || error "Couldn't find file \"$mdfile\""

htmlfile="${mdfile%.md}.html"
htmlfile_old="$htmlfile.bak"
[ -e "$htmlfile" ] && mv -f "$htmlfile" "$htmlfile_old"
# TODO check if file is in *correct* place

pandoc --to html \
   	-V "date:$(date +"%H:%M") on $(date +"%m/%d/%Y")" \
	--template "$TEMPLATE" \
	"$mdfile" \
	-o "$htmlfile"

chmod a-w "$htmlfile"
[ -e "$htmlfile_old" ] && rm -f "$htmlfile_old"
echo "Created \"$htmlfile\""
