FROM alpine:latest

LABEL repository="http://github.com/henrich-m/trigger-ci"
LABEL homepage="http://github.com/henrich-m/trigger-ci"
LABEL "com.github.actions.name"="Trigger CI Build"
LABEL "com.github.actions.description"="Automatically trigger a build on '/build' comment"
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="red"

RUN apk --no-cache add jq bash curl

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
