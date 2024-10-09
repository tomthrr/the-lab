varying vec2 vUv;

void main()
{
    vUv = uv; // Assigner les coordonnées UV
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
