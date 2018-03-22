#!/bin/sh

mkdir -p xmrig/build

cd xmrig/build

cmake ..

make

cd ../..
