#!/bin/bash

size=8

for ((i = 0; i < size; i++));
do
    for ((j = 0; j < size; j++));
    do
        if (((i + j) % 2 == 0)); 
        then
            echo -n "##"
        else
            echo -n "  "
        fi
    done
    echo
done