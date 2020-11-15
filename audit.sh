#!/bin/bash

usage() { echo "Usage: $0 [-u <string>] [-p <string>] [-o <string>] [-n <string>]" 1>&2; exit 1; }
defaultOptions='--chrome-flags="--headless --no-sandbox" --no-enable-error-reporting'

while getopts ":u:p:o:n:" o; do
case "${o}" in
  u)
    url=${OPTARG}
    ;;
  p)
    IFS=',' read -r -a paths <<< "${OPTARG}"
    ;;
  o)
    defaultOptions=${OPTARG}
    ;;
  n)
    name=${OPTARG}
    ;;
  *)
    usage
    exit 1
    ;;
esac
done
shift $((OPTIND-1))

if [ -n "$url" ]; then
  outputPath=""
  if [ -n "$name" ];then
    outputPath=" --output-path ./${name}.report.html"
  fi
  eval lighthouse "$url" "$defaultOptions" "$outputPath"
  if [ -n "$url" ]; then
    for path in "${paths[@]}"; do
      if [ -n "$name" ];then
        filename=$(echo "$name""$path" | tr / _)
        outputPath=" --output-path ./${filename}.report.html"
      fi
      eval lighthouse "$url""$path" "$defaultOptions" "$outputPath"
    done
  fi
fi



