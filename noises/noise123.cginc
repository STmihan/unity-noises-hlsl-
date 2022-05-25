#include "../math/noise_math.cginc"

float hash(float n) { return fract(sin(n) * 1e4); }
float hash(float2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

//	 
//	123 noise 1D
//
float noise(float x)
{
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), u);
}

//	 
//	123 noise 2D
//
float noise(float2 x)
{
    float2 i = floor(x);
    float2 f = fract(x);

    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + float2(1.0, 0.0));
    float c = hash(i + float2(0.0, 1.0));
    float d = hash(i + float2(1.0, 1.0));

    // Simple 2D lerp using smoothstep envelope between the values.
    // return vec3(mix(mix(a, b, smoothstep(0.0, 1.0, f.x)),
    //			mix(c, d, smoothstep(0.0, 1.0, f.x)),
    //			smoothstep(0.0, 1.0, f.y)));

    // Same code, with the clamps in smoothstep and common subexpressions
    // optimized away.
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}


//	 
//	123 noise 3D
// This one has non-ideal tiling properties that I'm still tuning
//
float noise(float3 x)
{
    const float3 step = float3(110, 241, 171);

    float3 i = floor(x);
    float3 f = fract(x);

    // For performance, compute the base input to a 1D hash from the integer part of the argument and the 
    // incremental change to the 1D based on the 3D -> 1D wrapping
    float n = dot(i, step);

    float3 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(mix(hash(n + dot(step, float3(0, 0, 0))), hash(n + dot(step, float3(1, 0, 0))), u.x),
                   mix(hash(n + dot(step, float3(0, 1, 0))), hash(n + dot(step, float3(1, 1, 0))), u.x), u.y),
               mix(mix(hash(n + dot(step, float3(0, 0, 1))), hash(n + dot(step, float3(1, 0, 1))), u.x),
                   mix(hash(n + dot(step, float3(0, 1, 1))), hash(n + dot(step, float3(1, 1, 1))), u.x), u.y), u.z);
}
