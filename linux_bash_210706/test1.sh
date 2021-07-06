#!/bin/bash
# This is a test bash script: 06-JUL-2021
# Accept user input from terminal
echo -n "Please enter the fees that you paid: "
read fees
if [ $fees -gt 2000 ]; then
   echo "$fees is high"
else
   echo "$fees is reasonable"
fi

exit

if [ -f wav.scp ]; then
  rm wav.scp;
fi
echo ""; ls
