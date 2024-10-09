uniform vec2 uResolution;
uniform vec2 uMouse;
uniform float uDistance;
uniform float uPow;
uniform float uNumbers; 
uniform float uTime; 

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
    vec2 basePosition = vec2(random(vec2(float(i), 0.0)), random(vec2(0.0, float(i))));

    float offsetX = 0.05 * sin(uTime + float(i) * 0.5); // Mouvement horizontal
    float offsetY = 0.05 * cos(uTime + float(i) * 0.3); // Mouvement vertical

    points[i] = basePosition + vec2(offsetX, offsetY);
  }

  float threshold = 0.005; 
  float dist_min = uDistance;

  int nbParticles = int(min(uNumbers, float(MAX_POINTS)));

  for(int i = 0; i < nbParticles; i++) {
    float distance = distance(vUv, points[i]);
    dist_min = min(distance, dist_min);
  }

  if (dist_min < threshold) {
    color = vec3(1.0, 0.0, 0.0);
  } else {
    color = vec3(dist_min);

    color += pow(dist_min, uPow);
    color = color / 0.5;   
  }

  float r = map(dist_min, 0., 0.3, 0., 1.);
  float g = map(dist_min, 0., 0.2, 1., 0.);
  float b = map(dist_min, 0., 0.8, 1., 0.);

  gl_FragColor = vec4(r, g, b, 1.0);
}
