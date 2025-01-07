#include "../utils/light/ambientLight.glsl"
#include "../utils/light/directionalLight.glsl"
#include "../utils/light/pointLight.glsl"

uniform vec3 uColor;

varying vec3 vNormal;
varying vec3 vPosition;


void main()
{
    vec3 normal = normalize(vNormal); // We normalize, every normal are not equal to 1
    vec3 viewdirection = normalize(vPosition - cameraPosition);
    vec3 color = uColor;

    // Light
    vec3 light = vec3(0.0); // the light of the entire scene
    light += ambientLight(
        vec3(1.0),              // Light color
        0.03                    // Light intensity
    );
    light += directionalLigth(
        vec3(0.1, 0.1, 1.0),    // Light color
        1.0,                    // Light intensity
        normal,                 // Normal
        vec3(0.0, 0.0, 3.0),    // LightPosition
        viewdirection,          // ViewDirection
        20.0                    // Specular power
    );
    light += pointLight(
        vec3(1.0, 0.1, 0.1),    // Light color
        1.0,                    // Light intensity
        normal,                 // Normal
        vec3(0.0, 2.5, 0.0),    // LightPosition
        viewdirection,          // ViewDirection
        20.0,                   // Specular power
        vPosition,
        0.25                    // Decay
    );
    color *= light;

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}