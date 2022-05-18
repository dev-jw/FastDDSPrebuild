#!/bin/bash

set -e
#set -x

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
FWNAME="FastDDS"
BUILD_DIR="${BASE_PWD}/build"
FRAMEWORKS="${BASE_PWD}/Frameworks"



function mergeArch() {
	
	if [ "$1" == "iphoneos" ]; then
		
		# 合并 iphoneos 架构
		iphoneos=(
			"iphoneos_arm64"
			"iphoneos_armv7"
			"iphoneos_armv7s"
		)
		
		for element in ${iphoneos[@]}
		do
			rm -rf $BUILD_DIR/$element/lib/libfastdds.a
			xcrun libtool -no_warning_for_no_symbols \
			-static -o $BUILD_DIR/$element/lib/libfastdds.a \
			$BUILD_DIR/$element/lib/*.a
		done
		
		rm -rf $FRAMEWORKS/iphoneos/libfastdds.a
		
		xcrun libtool -no_warning_for_no_symbols \
		-static -o $FRAMEWORKS/iphoneos/libfastdds.a \
		$BUILD_DIR/${iphoneos[0]}/lib/libfastdds.a \
		$BUILD_DIR/${iphoneos[1]}/lib/libfastdds.a \
		$BUILD_DIR/${iphoneos[2]}/lib/libfastdds.a

	fi
	
	if [ "$1" == "iphonesimulator" ]; then
		
		# 合并 iphonesimulator 架构
		iphonesimulator=(
			"iphoneos_arm64"
			"iphonesimulator_x86_64"
		)
		
		for element in ${iphonesimulator[@]}
		do
			rm -rf $BUILD_DIR/$element/lib/libfastdds.a
			xcrun libtool -no_warning_for_no_symbols \
			-static -o $BUILD_DIR/$element/lib/libfastdds.a \
			$BUILD_DIR/$element/lib/*.a
		done
		
		rm -rf $FRAMEWORKS/iphonesimulator/libfastdds.a
		
		xcrun libtool -no_warning_for_no_symbols \
		-static -o $FRAMEWORKS/iphonesimulator/libfastdds.a \
		$BUILD_DIR/${iphonesimulator[0]}/lib/libfastdds.a \
		$BUILD_DIR/${iphonesimulator[1]}/lib/libfastdds.a
		
	fi
	
	if [ "$1" == "macosx" ]; then
		
		# 合并 MacOS 架构
		macosx=(
			"macosx_arm64"
			"iphonesimulator_x86_64"
		)
		
		for element in ${macosx[@]}
		do
			rm -rf $BUILD_DIR/$element/lib/libfastdds.a
			xcrun libtool -no_warning_for_no_symbols \
			-static -o $BUILD_DIR/$element/lib/libfastdds.a \
			$BUILD_DIR/$element/lib/*.a
		done
		
		rm -rf $FRAMEWORKS/macosx/libfastdds.a
		
		xcrun libtool -no_warning_for_no_symbols \
		-static -o $FRAMEWORKS/macosx/libfastdds.a \
		$BUILD_DIR/${macosx[0]}/lib/libfastdds.a \
		$BUILD_DIR/${macosx[1]}/lib/libfastdds.a
	fi
}

mergeArch "iphoneos"
mergeArch "iphonesimulator"
mergeArch "macosx"


# XCFramework
rm -rf "${BASE_PWD}/Frameworks/${FWNAME}.xcframework"

xcrun xcodebuild -create-xcframework \
-library "$FRAMEWORKS/iphoneos/libfastdds.a" \
-library "$FRAMEWORKS/iphonesimulator/libfastdds.a" \
-library "$FRAMEWORKS/macosx/libfastdds.a" \
-output "${BASE_PWD}/Frameworks/${FWNAME}.xcframework"

rm -rf ${OUTPUT_DIR}