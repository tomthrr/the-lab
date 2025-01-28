uniform vec2 mousePos;
uniform vec2 resolution;
uniform vec3 hitPos;

varying vec3 vWorldPosition;
varying float vDistMouse;

void main()
{
    float dist = distance(vWorldPosition, hitPos);
    float radius = 0.3;

    // Dégradé progressif autour du point
    float intensity = smoothstep(radius, radius * 0.5, dist);

    // Couleur de base
    vec3 baseColor = vec3(0.8, 0.8, 0.8);

    // Couleur finale (on ajoute du blanc si proche de la souris)
    vec3 finalColor = mix(vec3(0.9, 0.9, 0.9), baseColor, intensity);

    gl_FragColor = vec4(finalColor, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}