#!/usr/bin/env bash

TEST_FOLDER="./test_files"
OUTPUT_FOLDER="./output_files"
MAIN_JAVA="$OUTPUT_FOLDER/Main.java"
RESULT="$OUTPUT_FOLDER/result.txt"

# choose whether to check provided input test files, if any, or all test files, if available
if [[ $# -eq 0 ]]; then
  filenames="$TEST_FOLDER/*.txt"
else
  filenames="$@"
fi

for filename in $filenames; do
  f="$(basename -- $filename)";
  echo "Testing $f ...";
  make execute -s < $filename > $MAIN_JAVA;
  javac $MAIN_JAVA;
  java -cp $OUTPUT_FOLDER Main > $RESULT;
  diff $RESULT "$TEST_FOLDER/results/$f";
done