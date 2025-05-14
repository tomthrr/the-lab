#include "../utils/noise/perlinClassic3D.glsl"

uniform float uTime;
uniform vec3 uBaseColor;
uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform sampler2D uMask;

uniform float uNoiseScale;
uniform float uNoiseSpeed;
uniform float uNoiseStrength;
uniform float uNoiseContrast;

varying vec2 vUv;
varying vec3 vWorldPosition;

void main()
{
    vec3 position = vWorldPosition;

    // Noise animé avec contrôle
    float noise = perlinClassic3D(position * uNoiseScale + vec3(0.0, uTime * uNoiseSpeed, 0.0));
    noise = clamp(noise * 0.5 + 0.5, 0.0, 1.0); // Remap [-1,1] -> [0,1]
    noise = mix(0.5, pow(noise, uNoiseContrast), uNoiseStrength);

    // Couleurs intermédiaires en fonction du bruit
    vec3 noisyColor = mix(uBaseColor, uDepthColor, smoothstep(0.0, 0.1, noise));
    noisyColor = mix(noisyColor, uSurfaceColor, smoothstep(0.1, 0.75, noise));

    // Atténuer l’effet du bruit sur les parties basses de l’herbe
    float heightFactor = smoothstep(0.05, 0.2, position.y);
    vec3 finalColor = mix(uBaseColor, noisyColor, heightFactor);

    vec3 maskColor = texture2D(uMask, vUv).rgb;

    gl_FragColor = vec4(finalColor, 1.0);

    if(maskColor.r <= 0.1){
        discard;
    }
}
