#!/usr/bin/sh

mkdir -p ../models

cd models

~/mallet-2.0.7/bin/mallet import-dir --input ../texts --output journalRun.mallet --keep-sequence --remove-stopwords --token-regex  '[\p{L}]{3,}'

#small as 32 topics

~/mallet-2.0.7/bin/mallet train-topics --input journalRun.mallet --num-topics 16 --output-state small-state.gz --output-topic-keys small_keys.txt --output-doc-topics small_compostion.txt --optimize-interval 10  --num-threads 6

#large as 128 topics.
~/mallet-2.0.7/bin/mallet train-topics --input journalRun.mallet --num-topics 128 --output-state large-state.gz --output-topic-keys large_keys.txt --output-doc-topics large_compostion.txt --optimize-interval 10 --num-threads 6

cd ..