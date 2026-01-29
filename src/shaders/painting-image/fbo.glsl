varying vec2 vUv;
uniform sampler2D tDiffuse;
uniform sampler2D tPrev;
uniform vec4 resolution;
uniform float time;
uniform float noiseScale;
uniform float dispStrength;
uniform float bleedIntensity;
uniform float fadeRate;
uniform float fadeOffset;

// Fractal noise from https://github.com/yiwenl/glsl-fbm/blob/master/2d.glsl
float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
        mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

float fbm(vec2 x, int numOctaves) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));
    for (int i = 0; i < numOctaves; ++i) {
        v += a * noise(x);
        x = rot * x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

float blendDarken(float base, float blend) {
    return min(blend,base);
}

vec3 blendDarken(vec3 base, vec3 blend) {
    return vec3(blendDarken(base.r,blend.r),blendDarken(base.g,blend.g),blendDarken(base.b,blend.b));
}

vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
    return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
}

//https://github.com/Experience-Monks/glsl-hsl2rgb/blob/master/index.glsl
float hue2rgb(float f1, float f2, float hue) {
    if (hue < 0.0)
    hue += 1.0;
    else if (hue > 1.0)
    hue -= 1.0;
    float res;
    if ((6.0 * hue) < 1.0)
    res = f1 + (f2 - f1) * 6.0 * hue;
    else if ((2.0 * hue) < 1.0)
    res = f2;
    else if ((3.0 * hue) < 2.0)
    res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
    else
    res = f1;
    return res;
}

vec3 hsl2rgb(vec3 hsl) {
    vec3 rgb;

    if (hsl.y == 0.0) {
        rgb = vec3(hsl.z); // Luminance
    } else {
        float f2;

        if (hsl.z < 0.5)
        f2 = hsl.z * (1.0 + hsl.y);
        else
        f2 = hsl.z + hsl.y - hsl.y * hsl.z;

        float f1 = 2.0 * hsl.z - f2;

        rgb.r = hue2rgb(f1, f2, hsl.x + (1.0/3.0));
        rgb.g = hue2rgb(f1, f2, hsl.x);
        rgb.b = hue2rgb(f1, f2, hsl.x - (1.0/3.0));
    }
    return rgb;
}

vec3 hsl2rgb(float h, float s, float l) {
    return hsl2rgb(vec3(h, s, l));
}

const vec3 bgColor = vec3(1.0);
const vec3 brushColor = vec3(0.0); // Black brush for revealing

void main()
{
    vec4 color = texture2D(tDiffuse, vUv); // mouse movement (white sphere on black bg)
    vec4 prev = texture2D(tPrev, vUv); // previous frame

    // Correct aspect ratio for displacement
    float aspectRatio = resolution.x / resolution.y;
    vec2 aspectCorrection = vec2(1.0 / aspectRatio, 1.0);

    // Generate noise-based displacement using uniforms
    vec2 disp = vec2(fbm(vUv * noiseScale, 4)) * aspectCorrection * dispStrength;

    // Sample previous frame with displacement for watercolor bleeding effect
    vec3 texelCenter = texture2D(tPrev, vUv).rgb;
    vec3 texelRight = texture2D(tPrev, vUv + vec2(disp.x, 0.0)).rgb;
    vec3 texelLeft = texture2D(tPrev, vUv - vec2(disp.x, 0.0)).rgb;
    vec3 texelUp = texture2D(tPrev, vUv + vec2(0.0, disp.y)).rgb;
    vec3 texelDown = texture2D(tPrev, vUv - vec2(0.0, disp.y)).rgb;

    // Blend all samples using darken mode for watercolor spreading
    vec3 floodColor = texelCenter;
    floodColor = blendDarken(floodColor, texelRight);
    floodColor = blendDarken(floodColor, texelLeft);
    floodColor = blendDarken(floodColor, texelUp);
    floodColor = blendDarken(floodColor, texelDown);

    // Apply watercolor bleeding with controlled intensity
    vec3 watercolor = blendDarken(prev.rgb, floodColor, bleedIntensity);

    // The sphere is white on black background - color.r will be high where sphere is
    // We want to darken (paint) where the sphere is
    vec3 finalColor = blendDarken(watercolor, vec3(1.0 - color.r));

    // Slight fade towards white to prevent over-darkening over time
    finalColor = min(bgColor, finalColor * fadeRate + fadeOffset);

    gl_FragColor = vec4(finalColor, 1.0);
}
