#!/bin/bash

PROGRAM=
SLEEP=5

while echo > /dev/null;do
    $PROGRAM
    sleep $SLEEP
done
