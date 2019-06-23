#!/bin/sh

DESTINATION=../Bridge

cd $(dirname $0)/tetris_core
cargo lipo --release
rm -rf $DESTINATION/Headers
mkdir $DESTINATION/Headers
rm -rf $DESTINATION/Libraries
mkdir $DESTINATION/Libraries

cp target/universal/release/libtetris.a $DESTINATION/Libraries/libtetris.a
cbindgen . -o $DESTINATION/Headers/libtetris.h -l c
