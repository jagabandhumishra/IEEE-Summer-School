#!/bin/bash
# Goal : Create wav.scp files for train and test data.
# Input : "data/train/utt" and "data/test/utt"
#	The utt contains the names of train/test wave files [without extension].
#	The following is an examplar line of utt 
#	AS001M0001
# Output : "wav.scp" files in data/train and data/test directories.
#	wav.scp contains a list of name of wav file and its full name with absolute path.
#	The following is an examplar line of wav.scp
#	AS001M0001	/home/samudravijaya/kaldi/assamese17/wav/AS001M0001.wav
# Author : Abhishek Dey
# Revised on 09-JUN-2019, 07-OCT-2018 by Samudravijaya K

# train data
wav_path=$PWD/wav
data_path=$PWD/data/train
cat $data_path/utt | awk '{printf "%s\t%s%s%s\n",$1,"'$wav_path'/",$1,".wav"}' > $data_path/wav.scp

# test data
wav_path=$PWD/wav
data_path=$PWD/data/test
cat $data_path/utt | awk '{printf "%s\t%s%s%s\n",$1,"'$wav_path'/",$1,".wav"}' > $data_path/wav.scp
