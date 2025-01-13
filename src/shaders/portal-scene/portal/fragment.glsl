#include "../../utils/noise/perlinClassic3D.glsl"

uniform float uTime;
uniform vec3 uColorStart;
uniform vec3 uColorEnd;

varying vec2 vUv;

void main()
{
    // displace the Uv
    vec2 displacedUv = vUv + perlinClassic3D(vec3(vUv * 5.0, uTime * 0.1));


    // perlin noise
    float strength = perlinClassic3D(vec3(displacedUv * 5.0, uTime * 0.2));

    // outer glow
    float outerGlow = distance(vUv, vec2(0.5)) * 5.0 -1.4;
    strength += outerGlow;

    vec3 finalColor = mix(uColorStart, uColorEnd, strength);

    gl_FragColor = vec4(finalColor, 1.0);
}