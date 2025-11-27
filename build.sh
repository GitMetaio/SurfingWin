#!/bin/sh
OUTPUT_ZIP="Surfing_windows-amd64.zip"

[ -f "$OUTPUT_ZIP" ] && rm -f "$OUTPUT_ZIP"

zip -r -q -X "$OUTPUT_ZIP" ./ \
    -x 'build.sh' \
    -x 'LICENSE' \
    -x '.git/*' \
    -x '.github/*'