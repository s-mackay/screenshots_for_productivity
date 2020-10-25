#!/bin/bash
#title           :bigbrother.sh
#description     :This script will take a number of screenshots (15 by default) in jittered intervals within the specified time period (default 60min) and zip them
#usage		     :bigbrother.sh outputBaseName durationMinutes nScreenshots
#author          :Sina Mackay
#==============================================================================
RANDOM=$$
BASENAME=$1
MAXLENGTH=$2
NSCRSHOTS=$3

if [ "$BASENAME" == "" ]; then
  BASENAME="screenshot_"
fi
if [ "$MAXLENGTH" == "" ]; then
  echo "usage: bigbrother.sh outputBaseName runtimeMinutes nScreenshots"
  echo "e.g. ./bigbrother.sh screenshot_ 60 15"
  echo "will run for 60min and take 15 screenshots by default"
  MAXLENGTH=60
fi
if [ "$NSCRSHOTS" == "" ]; then
  NSCRSHOTS=15
fi

endtime=$((60*$MAXLENGTH))

n_screenshots=$NSCRSHOTS
jitter=200
# 
mean_dist=$(($endtime / $n_screenshots - $jitter / 2)) #baseline time interval
if [ $mean_dist -le 0 ]; then
  mean_dist=1
fi
img_counter=0
while [ $SECONDS -lt $endtime ]; do
  R=$(($mean_dist+$RANDOM % $jitter )) #0 - $add a few seconds of jitter
  FILENAME=${BASENAME}${img_counter}.jpg
  echo $FILENAME
  sleep $R
  import -window root -silent $FILENAME
  mogrify -resize 50% $FILENAME
  img_counter=$[ $img_counter + 1 ]
done

datestr=$(date '+%Y-%m-%d_%H-%M-%S_')
zip ${datestr}${BASENAME}.zip ${BASENAME}*.jpg
rm ${BASENAME}*.jpg
