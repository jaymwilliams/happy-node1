#!/bin/bash

WORKSPACE="${WORKSPACE:-../..}"
PARAMETERS="$@"

function render_curly() {
  for var in $PARAMETERS; do
    key=$(echo "${var/=/ }" | awk '{print $1}')
    val=$(echo "${var/=/ }" | awk '{print $2}')
    local result="${result} -e \"s|\\\${$key}|${val}|\" "
  done
  eval "sed ${result} $1"
}
export render_curly

render_curly "${WORKSPACE}/.hub/templates/package.json.template" > "${WORKSPACE}/package.json"
