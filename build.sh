#!/bin/sh

SHORT_HASH=$(git rev-parse --short=7 HEAD)
OUTPUT_ZIP="Surfing_windows-amd64_${SHORT_HASH}.zip"

[ -f "$OUTPUT_ZIP" ] && rm -f "$OUTPUT_ZIP"

zip -r -q -X "$OUTPUT_ZIP" ./ \
    -x 'build.sh' \
    -x 'LICENSE' \
    -x '.git/*' \
    -x '.github/*'