#include "../utils/noise/perlinClassic3D.glsl"

uniform float uTime;
uniform float uBigWavesElevation;
uniform vec2 uBigWavesFrequency;
uniform float uBigWavesSpeed;

uniform float uSmallWavesElevation;
uniform float uSmallWavesFrequency;
uniform float uSmallWavesSpeed;
uniform float uSmallIterations;

varying float vElevation;
varying vec3 vNormal;
varying vec3 vPosition;

#ifdef USE_FOG
    varying float fogDepth;
    varying vec3 vFogWorldPosition;
#endif

float waveElevation(vec3 position) {
    float elevation = sin(position.x * uBigWavesFrequency.x + uTime * uBigWavesSpeed) *
    sin(position.z * uBigWavesFrequency.y + uTime * uBigWavesSpeed) *
    uBigWavesElevation;

    for(float i = 1.0; i <= uSmallIterations; i++)
    {
        elevation -= abs(perlinClassic3D(vec3(position.xz * uSmallWavesFrequency * i, uTime * uSmallWavesSpeed)) * uSmallWavesElevation / i);
    }

    return elevation;
}

void main()
{
    // Base position
    float shift = 0.01; // how far the neighbours will be
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    vec3 modelPositionA = modelPosition.xyz + vec3(shift, 0.0, 0.0);
    vec3 modelPositionB = modelPosition.xyz + vec3(0.0, 0.0, - shift);

    // Elevation
    float elevation = waveElevation(modelPosition.xyz);
    modelPosition.y += elevation;
    modelPositionA.y += waveElevation(modelPositionA);
    modelPositionB.y += waveElevation(modelPositionB);

    // Compute normal
    vec3 toA = normalize(modelPositionA - modelPosition.xyz);
    vec3 toB = normalize(modelPositionB - modelPosition.xyz);
    vec3 computeNormal = cross(toA, toB);

    // Final position
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;

    #ifdef USE_FOG
        viewPosition = viewMatrix * modelPosition;
        fogDepth = -viewPosition.z; // Utiliser la vraie profondeur
        vFogWorldPosition = modelPosition.xyz; // Stocker la position globale pour le brouillard d'horizon
    #endif

    gl_Position = projectedPosition;

    // Varyings
    vElevation = elevation;
    vNormal = computeNormal;
    vPosition = modelPosition.xyz;
}