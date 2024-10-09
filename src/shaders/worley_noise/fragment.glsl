uniform vec2 uResolution;
uniform vec2 uMouse;
uniform float uDistance;
uniform float uPow;
uniform float uNumbers; 

varying vec2 vUv;

const int MAX_POINTS = 100; 
vec2 points[MAX_POINTS]; 

float map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
  vec3 color = vec3(1.0, 1.0, 1.0); // Couleur blanche par défaut

  for(int i = 0; i < MAX_POINTS; i++) {
    points[i] = vec2(random(vec2(float(i), 0.0)), random(vec2(0.0, float(i))));
  }

  float threshold = 0.005; 
  float dist_min = 1.0;

  int nbParticles = int(min(uNumbers, float(MAX_POINTS)));

  for(int i = 0; i < nbParticles; i++) {
    float distance = distance(vUv, points[i]);
    dist_min = min(distance, dist_min);
  }

  if (dist_min < threshold) {
    color = vec3(1.0, 0.0, 0.0); // Rouge
  } else {
    color = vec3(dist_min); // Gris proportionnel à la distance minimale
  }

  gl_FragColor = vec4(color, 1.0);
}
