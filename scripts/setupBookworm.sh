#!/usr/bin/sh

variable=Printers
#Clone the github repo
git clone git@github.com:bmschmidt/Presidio.git

mkdir -p Presidio/files
mkdir -p Presidio/files/metadata
mkdir -p Presidio/files/texts

ln -s texts Presidio/files/raw

R CMD BATCH updateMetadata.R

mv /tmp/jsoncatalog.txt Presidio/metadata
cp field_descriptions.json Presidio/metadata

cd Presidio

python OneClick.py $variable



