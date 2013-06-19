#!/usr/bin/sh

variable=Printers
#Clone the github repo
#git clone git@github.com:bmschmidt/Presidio.git

mkdir -p Presidio/files
mkdir -p Presidio/files/metadata
mkdir -p Presidio/files/texts

ln -s `pwd`/texts Presidio/files/texts/raw

#R CMD BATCH updateMetadata.R
cp /tmp/jsoncatalog.txt Presidio/files/metadata
cp etc/field_descriptions_default.json Presidio/files/metadata/field_descriptions.json

cd Presidio

python OneClick.py $variable



