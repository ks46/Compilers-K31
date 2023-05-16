#!/usr/bin/env bash

TEST_FOLDER="./tests/student/tests/minijava"
RESULT="$TEST_FOLDER/result.txt"
EXPECTED="$TEST_FOLDER/expected.txt"
filenames_all="$TEST_FOLDER/*.java"

java Main $filenames_all;   # generate code for each filename

for filename in $filenames_all; do
    f="$(basename -- $filename)";
    echo "Testing $f...";
    javac $filename;
    java -cp $TEST_FOLDER ${f/".java"/""} > $EXPECTED;
    clang -o out1 "$TEST_FOLDER/${f/".java"/".ll"}";
    ./out1 > $RESULT;
    diff $RESULT $EXPECTED | less;
done
