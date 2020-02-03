# GitHub Action to trigger a CircleCI build via a comment

After installation, comment `/build` to trigger the action.


## Installation

```
name: Trigger CI Build

on:
  issue_comment:
    types: [created]

jobs:
  build-branch:

    runs-on: ubuntu-latest

    if: contains(github.event.comment.body, '/build')

    steps:
      - name: Trigger CI Build
        uses: henrichm/trigger-ci@v0.0.1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          CIRCLE_TOKEN: ${{ secrets.CIRCLE_TOKEN }}
 ```

This Action is heavily inspired by [revert](https://github.com/srt32/revert).
