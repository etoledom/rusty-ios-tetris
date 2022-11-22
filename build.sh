#!/bin/sh

DESTINATION=../Bridge

cd $(dirname $0)/tetris_core
# Set up for M1 macs. Change target for intel processor.
cargo lipo --targets aarch64-apple-ios-sim --release
rm -rf $DESTINATION/Headers
mkdir $DESTINATION/Headers
rm -rf $DESTINATION/Libraries
mkdir $DESTINATION/Libraries

cp target/universal/release/libtetris.a $DESTINATION/Libraries/libtetris.a
cbindgen . -o $DESTINATION/Headers/libtetris.h -l c
