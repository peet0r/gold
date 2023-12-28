#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform sampler2D image;
uniform vec2 iResolution;
out vec4 fragColor;


void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord/ iResolution.xy;
    vec3 col = texture(image, uv).xyz;
    fragColor = vec4(col, 1.0);
} 
