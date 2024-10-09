uniform float uTime;

varying vec2 vUv;

void main()
{
    vUv = uv; // Assigner les coordonnées UV

    // Final position
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;
}
