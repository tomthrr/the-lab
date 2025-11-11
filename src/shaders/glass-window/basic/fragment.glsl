uniform float u_time;
varying vec2 vUv;

void main()
{
    vec3 color = vec3(0.);
    vec3 colorA = vec3(1., vUv);
    vec3 colorB = vec3(vUv, 1.);

    float pct = abs(sin(u_time));

    color = mix(colorA, colorB, pct);

    gl_FragColor = vec4(color, 1.0);
}