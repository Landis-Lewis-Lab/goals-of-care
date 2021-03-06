#!/usr/bin/env bash

# Check if R is installed
command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

# Usage message
read -r -d '' USE_MSG <<'HEREDOC'
Usage:
  gocc.sh -h
  gocc.sh [options] -c config_file.yml --clc clc_file.csv
  gocc.sh [options] -c config_file.yml --hbpc hbpc_file.csv
  gocc.sh [options] -c config_file.yml --dementia dementia_file.csv

Multiple inputs input files to be run. E.g.:
  gocc.sh -c config.yml --clc clc.csv --hbpc hbpc.csv --demential dementia.csv

Options:
  -h | --help   print help and exit
  -c | --config path to configuration file
  -o | --output path to output directory
  -e | --exp    generate additional experimental reports
  --version     print package version
  --clc         path to clc report input csv file
  --hbpc        path to hbpc report input csv file
  --dementia    path to dementia report input csv file
HEREDOC

# Parse args
PARAMS=()
while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo "${USE_MSG}"
      exit 0
      ;;
    -c|--config)
      CONFIG_FILE=$2
      shift 2
      ;;
    -o|--output)
      OUTPUT_DIR=$2
      shift 2
      ;;
    -e|--exp)
      GENERATE_EXP="T"
      shift
      ;;
    --clc)
      CLC_INPUT=$2
      shift 2
      ;;
    --hbpc)
      HBPC_INPUT=$2
      shift 2
      ;;
    --dementia)
      DEMENTIA_INPUT=$2
      shift 2
      ;;
    --version)
      VER_EXPR='cat(as.character(packageVersion("gocc")))'
      VER_STRING=$(Rscript --vanilla --default-packages=utils -e "${VER_EXPR}")
      echo "gocc package version: ${VER_STRING}"
      exit 0
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Aborting: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS+=("${1}")
      shift
      ;;
  esac
done

# Check for input options
if [[ -z ${CLC_INPUT} ]] && [[ -z ${HBPC_INPUT} ]] && [[ -z ${DEMENTIA_INPUT} ]]; then
  echo "Aborting: Report input file required. See -h for input options."
  exit 1
fi

# Sort out config file. 
# Check 2nd param (unshifted case) then 1st param (shifted case)
if [[ -z $CONFIG_FILE ]]; then
  if [[ ${PARAMS[0]} ]]; then
    CONFIG_FILE="${PARAMS[0]}"
  else
    echo "Aborting: Config file required."
    exit 1
  fi
fi

if [[ -z $OUTPUT_DIR ]]; then
    OUTPUT_DIR="${PWD}/build"
fi

if [[ -z $GENERATE_EXP ]]; then
    GENERATE_EXP="F"
fi

echo "Creating ${OUTPUT_DIR} if it doesn't exist"
mkdir -p "${OUTPUT_DIR}"

INPUT_ARGS="clc='${CLC_INPUT}', hbpc='${HBPC_INPUT}', dementia='${DEMENTIA_INPUT}'"
CFG_ARGS="config_path='${CONFIG_FILE}', output_dir='${OUTPUT_DIR}'"
FLAG_ARGS="experimental=${GENERATE_EXP}"

echo "Running GoCC R Package."
EXPR="gocc::main(${CFG_ARGS}, ${FLAG_ARGS}, ${INPUT_ARGS})"

#Rscript --vanilla --default-packages=gocc -e "${EXPR}"
# DEBUG
#Rscript --default-packages=gocc,utils -e "packageVersion('gocc')"
echo "${EXPR}"
Rscript --default-packages=gocc -e "${EXPR}"

echo "Cleaning up: framed.sty, *.tex, *.log, figure/"
rm -f "framed.sty"
rm -f "*.tex"
rm -f "*.log"
rm -rf "figure"
