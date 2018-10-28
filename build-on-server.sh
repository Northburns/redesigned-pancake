#!/usr/bin/env bash

# https://github.com/godotengine/godot/issues/18057
mkdir -p ~/.cache
mkdir -p ~/.config/godot

mkdir -p /build/output

ls /home

whoami

ls /home/$(whoami)


# ..\..\godot\Godot_v3.0.6-stable_win64.exe --export "HTML5" --path . output/index.html

godot \
    --export "HTML5" \
    --path /build/src \
    /build/output/index.html
