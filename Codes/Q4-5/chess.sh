#!/bin/bash

n=8

for ((i = 0; i < n; i++));
do
    for ((j = 0; j < n; j++));
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
