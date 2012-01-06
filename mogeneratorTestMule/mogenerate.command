#!/bin/sh
cd "`dirname \"$0\"`"
cd MOs
mogenerator --model ../mogeneratorTestMule_DataModel.xcdatamodel --baseClass MyBaseClass --includem include.m
