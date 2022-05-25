float mix(float x, float y, float a)
{
    return x * (1 - a) + y * a;
}

float fract(float x)
{
    return x - floor(x);
}

float mod(float x, float y)
{
    return x - y * floor(x/y);
}