#!/bin/sh
#this script calls sakit espeak on freeBSD64
#
#change the values below for other archs, the paths are relative to the
#position of this script
LIBPORTAUDIO=libportaudio.so.2  #portaudio library
ESPEAKBIN=speak_x64               #espeak binary
DATADIRECTORY=../                 #directory of espeak-data
#
CALLDIR=${0%/*}/
export LD_PRELOAD=$CALLDIR$LIBPORTAUDIO
$CALLDIR/$EPEAKBIN --path=$CALLDIR/$DATADIRECTORY "$@"
