#!/bin/sh

mkdir -p cspa surfy
curl -o cspa/S2_File.xlsx https://wlab.ethz.ch/cspa/data/S2_File.xlsx
curl -o surfy/table_S3_surfaceome.xlsx http://wlab.ethz.ch/surfaceome/table_S3_surfaceome.xlsx
