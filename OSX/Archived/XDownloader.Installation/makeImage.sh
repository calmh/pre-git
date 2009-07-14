#!/bin/sh

VERSION=1.0
BUILD=`date +%Y%m%d`
REV=$VERSION-$BUILD

mkdir XDownloader-$REV
cp -rp ../XDownloader/Build/Deployment/XDownloader.app XDownloader-$REV
hdiutil create xdownloader-$REV.dmg -srcfolder XDownloader-$REV
hdiutil internet-enable -yes xdownloader-$REV.dmg
rm -rf XDownloader-$REV

