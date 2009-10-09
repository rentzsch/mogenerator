#!/bin/sh
cd "`dirname \"$0\"`"

sudo echo

sudo rm -rf 'build'
mkdir -p 'build/root/Library/Application Support/mogenerator'

cd ..
xcodebuild -configuration Release CONFIGURATION_BUILD_DIR="$PWD/installer/build/root/usr/bin/"
cp templates/*.motemplate "$PWD/installer/build/root/Library/Application Support/mogenerator/"
cd installer

VERSION=`build/root/usr/bin/mogenerator --version|head -n 1|sed -E 's/mogenerator ([0-9]+\.[0-9]+(\.[0-9]+)?).+/\1/g'`
MAJOR_VERSION=`echo $VERSION|sed -E 's/([0-9]+).+/\1/g'`
MINOR_VERSION=`echo $VERSION|sed -E 's/[0-9]+\.([0-9]+).*/\1/g'`

sed -E "s/VERSION/$VERSION/g" < Description.plist > 'build/Description.plist'
sed -e "s/MAJOR_VERSION/$MAJOR_VERSION/g" -e "s/MINOR_VERSION/$MINOR_VERSION/g" -e "s/VERSION/$VERSION/g" < Info.plist > 'build/Info.plist'

cd ../Xmod
xcodebuild -configuration Release CONFIGURATION_BUILD_DIR="`dirname $PWD`/installer/build/root/Developer/Library/Xcode/Plug-ins/"
cd ../installer

sudo chown -R root 'build/root'
sudo chgrp -R admin 'build/root'
/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -p "build/mogenerator-$VERSION.pkg" -f 'build/root' -i 'build/Info.plist' -d 'build/Description.plist' -ds
hdiutil create -srcfolder "build/mogenerator-$VERSION.pkg" -volname "mogenerator $VERSION" "build/mogenerator-$VERSION.dmg"
