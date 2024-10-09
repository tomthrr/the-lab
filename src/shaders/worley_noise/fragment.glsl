#include "../utils/random2D.glsl"

uniform vec2 uResolution;
uniform vec2 uMouse;
uniform float uDistance;
uniform float uPow;
uniform float uNumbers; 

varying vec2 vUv; 

// NB Points max
const int MAX_POINTS = 100; // Taille maximale fixe pour le tableau
vec2 points[MAX_POINTS]; // Déclaration du tableau

float map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float random(vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main()
{
    vec2 fragCoord = vUv; 
    fragCoord.x *= uResolution.x / uResolution.y;

    vec3 color = vec3(0.0);

    // Jamais plus de MAX_POINTS
    float effectiveNumbers = min(uNumbers, float(MAX_POINTS));

    // Générer des coordonnées aléatoires dans l'intervalle [0.0, 1.0]
    for (int i = 0; i < MAX_POINTS; i++) {
      points[i] = vec2(random(vec2(float(i), 0.0)), random(vec2(0.0, float(i))));
    }

    // Souris
    points[0] = uMouse;

    float dist_min = uDistance;

    // Calculer la distance 
    for (int i = 0; i < int(effectiveNumbers); i++) {
        float dist = distance(fragCoord, points[i]);
        dist_min = min(dist, dist_min);
    }

    float mappedDistance = map(dist_min, 0.0, uDistance, 0.0, 1.0);
    
    // Mapping exponentiel pour la profondeur
    float depthValue = pow(mappedDistance, uPow);
    
    // Mapping de couleur en niveaux de gris
    color = vec3(depthValue); 

    // Optionnel : appliquer un léger effet de bruit
    // float noise = random2D(fragCoord);
    // color += vec3(noise) * 0.01; 

    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}
