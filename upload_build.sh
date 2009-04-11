#!/bin/bash

rm -rf build/Debug-iphoneos/LatestChatty.app.zip
cd build/Debug-iphoneos && zip -r LatestChatty.app.zip LatestChatty.app
cd ../..
scp build/Debug-iphoneos/LatestChatty.app.zip squeegy@beautifulpixel.com:/home/squeegy/sites/blog/public/assets/LatestChatty.app.zip
growlnotify -m "LatestChatty: build upload complete"