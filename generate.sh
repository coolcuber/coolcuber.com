#!/usr/bin/env bash

SOURCE="pages"
TEMPLATE="template.html"

error() {
	echo "$1"
	exit 1
}

mdfile="$1"
[[ "$mdfile" =~ ^.*\.md$ ]] || error "Is \"$mdfile\" a Markdown file?"
[ -e "$mdfile" ] || error "Couldn't find file \"$mdfile\""
htmlfile="$SOURCE/$(basename "$mdfile" ".md").html"
pandoc --to html \
   	-V "date:$(date +"%H:%M") on $(date +"%m/%d/%Y")" \
	--template "$TEMPLATE" \
	"$mdfile" \
	-o "$htmlfile"
chmod a-w "$htmlfile"
echo "Created \"$htmlfile\""
