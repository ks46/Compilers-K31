#!/usr/bin/env bash

TEST_FOLDER="./tests/minijava-examples-new"
OFFSET_FOLDER="$TEST_FOLDER/offset-examples"
OUTPUT_FOLDER="./tests/output_files"

filenames="$OFFSET_FOLDER/*.txt"
filenames_extra="$OFFSET_FOLDER/Extra/*.txt"
filenames_all="$filenames $filenames_extra"

for filename in $filenames_all; do
  f="$(basename -- $filename)";
  echo "Offsets for file ${f/txt/"java"} ...";

  diff "$OUTPUT_FOLDER/$f" "$filename";
  if [[ $? -ne 0 ]]; then 
    read varname;   # wait for user to continue to next program execution
  fi
done
