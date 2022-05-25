#define NUM_OCTAVES 5
#include "noise123.cginc"

float fbm(float x) {
    float v = 0.0;
    float a = 0.5;
    float shift = float(100);
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}


float fbm(float2 x) {
    float v = 0.0;
    float a = 0.5;
    float2 shift = float2(100, 100);
    // Rotate to reduce axial bias
    float2x2 rot = float2x2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(x);
        x = rot * x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}


float fbm(float3 x) {
    float v = 0.0;
    float a = 0.5;
    float3 shift = float3(100, 100, 100);
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

//
// 	https://www.shadertoy.com/view/MdX3Rr
//
const float2x2 m2 = float2x2(0.8,-0.6,0.6,0.8);
float fbm( in float2 p ){
    float f = 0.0;
    f += 0.5000*noise( p ); p = m2*p*2.02;
    f += 0.2500*noise( p ); p = m2*p*2.03;
    f += 0.1250*noise( p ); p = m2*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}