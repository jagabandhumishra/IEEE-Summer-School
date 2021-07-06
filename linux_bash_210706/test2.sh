#!/bin/bash
# This is a test bash script: 06-JUL-2021
# Change directory
date
cd ~/Desktop/linux_bash_210706
pwd

# if a file named wav.scp exists, remove it
### [ -f wav.scp ] && rm wav.scp
if [ -f wav.scp ]; then
  rm wav.scp;
fi
echo ""; ls

# Create a file containing a list of wave files with absolute path
wav_dir="~/wav/hindiDigits"
cat numbers5_HN.txt | awk '{printf "%s\t%s/%s.wav\n", $1, "'$wav_dir'", $1}' > wav.scp

echo ""; ls
echo ""; cat wav.scp

exit
