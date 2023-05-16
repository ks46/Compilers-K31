#!/usr/bin/env bash

TEST_FOLDER="./tests/minijava-examples-new"
OFFSET_FOLDER="$TEST_FOLDER/offset-examples"
OUTPUT_FOLDER="./tests/output_files"

filenames="$TEST_FOLDER/*.java"
filenames_extra="$TEST_FOLDER/minijava-extra/*.java"
filenames_error_extra="$TEST_FOLDER/minijava-error-extra/*.java"
filenames_all="$filenames $filenames_extra $filenames_error_extra"

for filename in $filenames_all; do
  f="$(basename -- $filename)";
  echo "Testing $f ...";
  if [[ "$filename" == *"-error"* ]]; then
    # do not write ouput to file, ensure that it exits with error 
    java Main $filename;
    # if [[ ${?} -eq 0 ]]; then
    #   echo "Should have thrown an error!";
    # fi
    read varname;  # wait for user to continue to next program execution
  else
    # write output to file
    offset=${f/java/"txt"};
    java Main $filename > "$OUTPUT_FOLDER/$offset";
    if [[ ${?} -ne 0 ]]; then
      echo "No error expected!";
      read varname;  # wait for user to continue to next program execution
    fi
  fi
done
