#!/bin/bash

set -e

# skip if no /build
echo "Checking if contains '/build' command..."
(jq -r ".comment.body" "$GITHUB_EVENT_PATH" | grep -E "/build") || exit 78

# skip if not a PR
echo "Checking if a PR command..."
(jq -r ".issue.pull_request.url" "$GITHUB_EVENT_PATH") || exit 78

# get the SHA to build
COMMIT_TO_BUILD=$(jq -r ".comment.body" "$GITHUB_EVENT_PATH" | cut -c 9-)

if [[ "$(jq -r ".action" "$GITHUB_EVENT_PATH")" != "created" ]]; then
	echo "This is not a new comment event!"
	exit 78
fi

PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")
REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")
echo "Collecting information about PR #$PR_NUMBER of $REPO_FULLNAME..."

jq --raw-output . "$GITHUB_EVENT_PATH"

if [[ -z "$CIRCLE_TOKEN" ]]; then
	echo "Set the CIRCLE_TOKEN env variable."
	exit 1
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" \
          "${URI}/repos/$REPO_FULLNAME/pulls/$PR_NUMBER")

BRANCH=$(echo "$pr_resp" | jq -r .head.ref)

curl -u $CIRCLE_TOKEN: -X POST --header "Content-Type: application/json" -d '{
  "branch": "$BRANCH"
}' https://circleci.com/api/v2/project/gh/$REPO_FULLNAME/pipeline
