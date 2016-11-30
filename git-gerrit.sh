#!/bin/bash

set -e

error() {
    echo "Error:" "$@" >&2
    exit 1
}

print_usage() {
    cat <<EOF
  $0 CHANGE_NR PATCH_SET_NR
or
  $0 CHANGE_NR/PATCH_SET_NR
EOF
    exit 1
}

REMOTE=origin

if [ $# -ne 2 -a $# -ne 1 ]
then
    print_usage
fi

CHANGE_NUMBER="$1"
PATCH_SET_NUMBER="$2"

if [ -z "$PATCH_SET_NUMBER" ]
then
    PATCH_SET_NUMBER="${CHANGE_NUMBER#*/}"
    if [ "$PATCH_SET_NUMBER" = "$CHANGE_NUMBER" ]
    then
        PATCH_SET_NUMBER=
    else
        CHANGE_NUMBER="${CHANGE_NUMBER%%/*}"
    fi
fi

if [ -z "$PATCH_SET_NUMBER" ]
then
    REMOTE_URL="$(git config --get 'remote.origin.url')"
    REMOTE_PROTOCOL="$(cut -f 1 -d : <<<"$REMOTE_URL")"
    REMOTE_HOST="$(cut -f 3 -d / <<<"$REMOTE_URL" | cut -f 1 -d : )"
    case "$REMOTE_PROTOCOL" in
        "ssh" )
            PATCH_SET_NUMBER="$(
                ssh "$REMOTE_URL" gerrit query --current-patch-set "$CHANGE_NUMBER" \
                    | grep '^[[:space:]]*currentPatchSet:' -A 1 \
                    | grep number: | sed -e 's/^[[:space:]]*number:[[:space:]]*//'
            )"
            ;;
        "http" | "https" )
            API_URL=
            case "$REMOTE_HOST" in
                "gerrit.googlesource.com" )
                    API_URL="https://gerrit-review.googlesource.com/"
                    ;;
                * )
                    error "Do not know how to arrive at api url for '$REMOTE_HOST'"
                    ;;
            esac
            PATCH_SET_NUMBER="$(
                curl "$API_URL/changes/?q=change:$CHANGE_NUMBER&n=1&o=CURRENT_REVISION" \
                    | grep "/$CHANGE_NUMBER/" \
                    | head -n 1 \
                    | sed -e 's@.*/'"$CHANGE_NUMBER"'/\([0-9]*\)[^0-9].*@\1@'
                )"
            ;;
        * )
            error "Unknown remote protocol '$REMOTE_PROTOCOL'"
    esac
fi

if [ -z "$PATCH_SET_NUMBER" ]
then
    error "No PATCH_SET_NR: $PATCH_SET_NUMBER"
fi

LOCAL_BRANCH="c${CHANGE_NUMBER}_${PATCH_SET_NUMBER}"
git fetch "$REMOTE" refs/changes/${CHANGE_NUMBER: -2}/$CHANGE_NUMBER/$PATCH_SET_NUMBER
git branch "$LOCAL_BRANCH" FETCH_HEAD
git checkout "$LOCAL_BRANCH"

