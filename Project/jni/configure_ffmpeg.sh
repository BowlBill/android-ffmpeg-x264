#!/bin/bash
pushd `dirname $0`
. settings.sh

if [[ $minimal_featureset == 1 ]]; then
  echo "Using minimal featureset"
  featureflags=" \
--enable-decoder=mjpeg --enable-demuxer=mjpeg --enable-parser=mjpeg \
--enable-demuxer=image2 --enable-muxer=mp4 --enable-encoder=libx264 --enable-libx264 \
--enable-decoder=rawvideo \
--enable-protocol=file \
--enable-protocol=rtp
--enable-muxer=rtp \
--enable-hwaccels"
fi

if [[ $DEBUG == 1 ]]; then
  echo "DEBUG = 1"
  DEBUG_FLAG="--disable-stripping"
fi

pushd ffmpeg

RANLIB="arm-linux-androideabi-ranlib" ./configure --enable-cross-compile \
--arch=arm5te \
--enable-armv5te \
--target-os=linux \
--disable-stripping \
--cross-prefix=arm-linux-androideabi- \
--prefix=../output \
--disable-asm \
--enable-version3 \
--disable-shared \
--enable-static \
--enable-gpl \
--enable-memalign-hack \
--extra-cflags="-fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -I../x264" \
--enable-decoder=h264 \
--enable-demuxer=mov \
--enable-muxer=mp4 \
--enable-encoder=libx264 \
--enable-libx264 \
--enable-protocol=file \
--enable-decoder=aac \
--enable-encoder=aac \
$featureflags \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-indev=v4l2 \
--extra-ldflags="-L../x264" \
--extra-libs="-lgcc"


# ./configure $DEBUG_FLAG --enable-cross-compile \
# --arch=arm5te \
# --enable-armv5te \
# --target-os=linux \
# --disable-stripping \
# --prefix=../output \
# --disable-neon \
# --enable-version3 \
# --disable-shared \
# --enable-static \
# --enable-gpl \
# --enable-memalign-hack \
# --cc=arm-linux-androideabi-gcc \
# --ld=arm-linux-androideabi-ld \
# --ar=arm-linux-androideabi-ar \
# --extra-cflags="-fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated" \
# $featureflags \
# --disable-ffmpeg \
# --disable-ffplay \
# --disable-ffprobe \
# --disable-ffserver \
# --disable-network \
# --enable-filter=buffer \
# --enable-filter=buffersink \
# --disable-demuxer=v4l \
# --disable-demuxer=v4l2 \
# --disable-indev=v4l \
# --disable-indev=v4l2 \
# --extra-cflags="-I../x264 -Ivideokit" \
# --extra-ldflags="-L../x264" \
# --extra-libs="-lgcc"

popd; popd