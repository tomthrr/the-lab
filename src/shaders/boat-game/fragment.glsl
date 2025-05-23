#include "../utils/light/ambientLight.glsl"
#include "../utils/light/pointLight.glsl"
#include "../utils/noise/perlinClassic3D.glsl"

uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;
uniform float uColorOffset;
uniform float uColorMultiplier;

uniform vec3 fogHorizonColor;
uniform vec3 uBoatPosition;

varying float vElevation;
varying vec3 vNormal;
varying vec3 vPosition;

#ifdef USE_FOG
uniform vec3 fogColor;
uniform vec3 fogNearColor;
varying float fogDepth;
#ifdef FOG_EXP2
		uniform float fogDensity;
#else
		uniform float fogNear;
uniform float fogFar;
#endif
  varying vec3 vFogWorldPosition;
uniform float time;
uniform float fogNoiseSpeed;
uniform float fogNoiseFreq;
uniform float fogNoiseImpact;
#endif

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);

    // Base color
    float mixStrength = (vElevation + uColorOffset) * uColorMultiplier;
    mixStrength = smoothstep(0.0, 1.0, mixStrength);
    vec3 color = mix(uDepthColor, uSurfaceColor, mixStrength);

    // Light
    vec3 light = vec3(0.0);

    light += pointLight(
        vec3(1.0),            // Light color
        10.0,                 // Light intensity,
        normal,               // Normal
        vec3(uBoatPosition.x, 0.25, uBoatPosition.z), // Light position
        viewDirection,        // View direction
        60.0,                 // Specular power
        vPosition,            // Position
        0.3                   // Decay
    );

    color *= light;

    // Final color
    gl_FragColor = vec4(color, 1.0);

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

    #ifdef USE_FOG
        #ifdef USE_LOGDEPTHBUF_EXT
            float depth = gl_FragDepthEXT / gl_FragCoord.w;
    #else
            float depth = gl_FragCoord.z / gl_FragCoord.w;
    #endif
        float fogFactor = smoothstep( fogNear, fogFar, depth );
    gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );
    #endif
}