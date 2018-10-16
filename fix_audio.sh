#!/bin/bash

killall -9 pulseaudio
rm -r ~/.config/pulse/*      
sudo alsa force-reload                                                                                          

