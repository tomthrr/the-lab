#include "../utils/noise/perlinClassic3D.glsl"

uniform vec3 hitPos;
uniform float uTime;

varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPosition;
varying vec3 vWorldPosition;
varying float vDistMouse;


void main()
{
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    float dist = distance(modelPosition.xyz, hitPos);
    float radius = 0.3;

    //Deforation
    float elevation = sin(modelPosition.x * 10.0 - uTime) * 0.02;
        elevation += sin(modelPosition.z * 1.0 - uTime) * 0.02;
    modelPosition.z += elevation;

    // Deformation Souris
    // Intensité de la déformation (plus proche = plus fort)
    float deformationStrength = smoothstep(radius, 0.0, dist) * 0.05;

    // Déformation sommet
    modelPosition.xyz += normal * deformationStrength;

    gl_Position = projectionMatrix * viewMatrix * modelPosition;

    vDistMouse = dist;
    vWorldPosition = modelPosition.xyz;
}