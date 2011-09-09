#!/bin/bash

echo "starting run at $(date -R)"

pads=$(cat <<'EOF'
ovc2011
ovc11-alternative-copyright-education
ovc11-alternative-currencies
ovc11-connected-documentary
ovc11-database-driven-narratives
ovc11-defensive-patent-license
ovc11-designing-a-next-generation-tv-interface
ovc11-designing-storyworlds
ovc11-device-inputs-av-in-the-browser
ovc11-dmca-automation
ovc11-fun-with-webgl
ovc11-intro-to-popcorn-js-and-pitch-session
ovc11-is-the-web-safe-for-expression
ovc11-making-remix-maker
ovc11-making-the-map
ovc11-many-faces-of-open
ovc11-mobile-content-neutrality
ovc11-oer-video
ovc11-open-media-developers-plenary
ovc11-open-video-editors
ovc11-oral-history-best-practices
ovc11-popcorn-js-plugin-sprint
ovc11-roll-your-own-video-cms
ovc11-scalable-html5-players
ovc11-securesmartcam
ovc11-standards-for-browser-video-statistics
ovc11-standards-for-http-adaptive-streaming
ovc11-standards-for-video-accessibility
ovc11-the-missing-link-flash-html5
ovc11-the-rebecca-black-story
ovc11-using-open-source-in-commercial-context
ovc11-validating-verifying-citizen-video
ovc11-video-archives
ovc11-vimeo-rights
ovc11-visual-privacy-visual-anonymity
ovc11-webm-testing-metrics-and-new-features
ovc11-webRTC
EOF
)

set -x

EXPORT_URL_TEMPLATE="http://openetherpad.org/ep/pad/export/%s/latest?format="
REPO_BASE_PATH="$HOME/ovc11-etherpadbackup"

mkdir -p "$REPO_BASE_PATH/pads"
pushd "$REPO_BASE_PATH/pads" >/dev/null

#echo "$pads"
#
#for pad in $pads; do
#    echo "x$pad"
#done

for pad in $pads; do
    url="$(printf "$EXPORT_URL_TEMPLATE" $pad)"
    for format in txt html; do
        wget -q -O - "$url$format" > "$REPO_BASE_PATH/pads/$pad.$format" || \
            echo FAILED: pad from \'"$url$format"\' >&2
    done
done

git add .

git commit -a -m 'cron: automated etherpad backup' || \
	echo FAILED: git commit >&2
git push || \
	echo FAILED: git push >&2
