#include "../utils/noise/perlinClassic3D.glsl"

uniform float uTime;
uniform vec3 uBaseColor;
uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;

varying vec2 vUv;
varying vec3 vWorldPosition;

void main()
{
    vec3 position = vWorldPosition;

    // Noise animé
    float noiseStrength = 0.3;
    float noise = perlinClassic3D(position * 1. + vec3(0.0, uTime * 0.05, 0.0));
    noise = clamp(noise * 0.5 + 0.5, 0.0, 1.0);
    noise = mix(0.5, noise, noiseStrength);

    // Couleurs intermédiaires en fonction du bruit
    vec3 noisyColor = mix(uBaseColor, uDepthColor, smoothstep(0.0, 0.1, noise));
    noisyColor = mix(noisyColor, uSurfaceColor, smoothstep(0.1, 0.75, noise));

    // Atténuer l'effet du bruit sur les parties basses de l'herbe
    float heightFactor = smoothstep(0., 0.2, position.y); // 0 = base, 1 = sommet
    vec3 finalColor = mix(uBaseColor, noisyColor, heightFactor);

    gl_FragColor = vec4(finalColor, 1.0);
}
