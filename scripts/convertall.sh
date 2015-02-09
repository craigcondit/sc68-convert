#!/bin/bash

usage() {
  echo "Usage: $0 <input-dir> <output-dir>" >&2
  exit 1
}

print_info() {
  while [ ! -z "$1" ]; do
    file=$1
    shift
    file=$(echo "${file}" | sed 's_^\./__')
    tracks=$(info68 "${file}" "-#" 2>/dev/null)
    RESULT=$?
    if [ ! ${RESULT} -eq 0 ]; then
      continue
    fi
    for track in $(seq 1 ${tracks}); do
      framerate=$(info68 "${file}" -${track} -f 2>/dev/null)
      tracktype=$(info68 "${file}" -${track} -h 2>/dev/null)
      RESULT=$?
      if [ ! ${RESULT} -eq 0 ]; then
        continue
      fi
      if [ ! "${tracktype}" == "Ysa" ]; then
        continue
      fi      
      outfile=$(echo "${file}" | sed 's/\.sndh$//')"-${track}".ymz
      outdir="${OUTPUT_DIR}/$(dirname "${file}")"
      if [ -e "${OUTPUT_DIR}/${outfile}" ]; then
      echo "Skipping ${file} track ${track} as ${OUTPUT_DIR}/${outfile} exists..."
        continue
      fi
      echo "Writing ${file} track ${track} to ${OUTPUT_DIR}/${outfile}..."
      mkdir -p "${outdir}"
      sc68 "${file}" --quiet --ymz_output="${OUTPUT_DIR}/${outfile}" >/dev/null
    done
  done
}

INPUT_DIR=$1
if [ -z "${INPUT_DIR}" ]; then
  usage
fi

OUTPUT_DIR=$2
if [ -z "${OUTPUT_DIR}" ]; then
  usage
fi

cd "${INPUT_DIR}" 
export -f print_info
export OUTPUT_DIR
find . -name "*.sndh" -exec bash -c 'print_info "$OUTPUT_DIR " "$@"' bash {} +
