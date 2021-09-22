#!/usr/bin/env bash

for i in exampl*.txt
    do 
    echo
    echo ".$i"
    echo "[source,txt]"
    echo "-----"
    echo "include::${i}[]"
    echo "-----"

done > Includeme.adoc
