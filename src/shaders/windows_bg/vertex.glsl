precision highp float;

attribute vec3 terrPosi;
attribute float angle;

uniform float uWaveFrequency;
uniform float uTime;
uniform float uWaveSpeed;
uniform float uWindStrength;

varying vec3 vWorldPosition;
varying vec2 vUv;


/* https://www.geeks3d.com/20141201/how-to-rotate-a-vertex-by-a-quaternion-in-glsl/ */
vec4 quat_from_axis_angle(vec3 axis, float angle)
{ 
  vec4 qr;
  float half_angle = angle * 0.5; // PAS de conversion ici
  qr.x = axis.x * sin(half_angle);
  qr.y = axis.y * sin(half_angle);
  qr.z = axis.z * sin(half_angle);
  qr.w = cos(half_angle);
  return qr;
}

vec4 quat_conj(vec4 q)
{ 
  return vec4(-q.x, -q.y, -q.z, q.w); 
}
  
vec4 quat_mult(vec4 q1, vec4 q2)
{ 
  vec4 qr;
  qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
  qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
  qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
  qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
  return qr;
}

vec3 rotate_vertex_position(vec3 position, vec3 axis, float angle)
{ 
  vec4 qr = quat_from_axis_angle(axis, angle);
  vec4 qr_conj = quat_conj(qr);
  vec4 q_pos = vec4(position.x, position.y, position.z, 0);
  
  vec4 q_tmp = quat_mult(qr, q_pos);
  qr = quat_mult(q_tmp, qr_conj);
  
  return vec3(qr.x, qr.y, qr.z);
}

/**********/

void main(){
    vec3 finalPos = position;
    finalPos.x *= 0.15;
    finalPos.y += 0.5;

    // Rotation initiale autour de Y (selon angle)
    vec3 axis = vec3(0., 1., 0.);
    finalPos = rotate_vertex_position(finalPos, axis, angle);

    // Appliquer position dans le monde
    finalPos += terrPosi;

    // Calcul du vent
    float wind = sin((terrPosi.z + finalPos.y) * uWaveFrequency + uTime * uWaveSpeed) * uWindStrength;

    // On applique le vent uniquement sur la partie haute (selon Y)
    finalPos.x += wind * position.y;

    // Projection finale
    gl_Position = projectionMatrix * modelViewMatrix * vec4(finalPos, 1.0);

    vWorldPosition = finalPos;
    vUv = uv;
}
