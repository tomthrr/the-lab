uniform float uTime;
uniform float uWindStrength;
uniform float uWaveFrequency;
uniform float uWaveSpeed;

varying vec2 vUv;
varying vec3 vWorldPosition;

void main() {
    vUv = uv;

    vec4 worldPosition = modelMatrix * vec4(position, 1.0);

    // Le vent souffle sur Z, mais varie en fonction de Z et du temps
    float wind = sin(worldPosition.z * uWaveFrequency + uTime * uWaveSpeed) * uWindStrength;

    // On applique l'effet en Z mais en fonction de la hauteur Y pour éviter d'étirer toute la feuille
    worldPosition.z += wind * position.z;

    vWorldPosition = worldPosition.xyz;

    gl_Position = projectionMatrix * viewMatrix * worldPosition;
}
