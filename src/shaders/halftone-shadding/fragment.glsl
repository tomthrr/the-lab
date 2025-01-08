#include "../utils/light/ambientLight.glsl"
#include "../utils/light/directionalLight.glsl"
#include "../utils/halftone.glsl"

uniform vec3 uColor;
uniform vec2 uResolution;
uniform float uShadowRepetitions;
uniform vec3 uShadowColor;
uniform float uLightRepetitions;
uniform vec3 uLightColor;

varying vec3 vNormal;
varying vec3 vPosition;

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = uColor;

    // Lights
    vec3 light = vec3(0.0);

    light += ambientLight(
            vec3(1.0),  // LightColor
            1.0         // Intensity
    );

    light += directionalLigth(
        vec3(1.0, 1.0, 1.0),    // Light color
        1.0,                    // Light intensity
        normal,                 // Normal
        vec3(1.0, 1.0, 0.0),    // LightPosition
        viewDirection,          // ViewDirection
        1.0                     // Specular power
    );

    color *= light;

    // Halftone
    color = halftone(
        color,
        uShadowRepetitions,
        vec3(0.0, -1.0, 0.0),
        -0.8,
        1.5,
        uShadowColor,
        normal,
        uResolution
    );

    color = halftone(
        color,
        uLightRepetitions,
        vec3(1.0, 1.0, 0.0),
        0.5,
        1.5,
        uLightColor,
        normal,
        uResolution
    );

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}