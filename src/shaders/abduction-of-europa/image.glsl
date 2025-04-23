precision mediump float;

uniform sampler2D tReveal;
uniform sampler2D tColor;
varying vec2 vUv;

void main() {
    float mask = texture2D(tReveal, vUv).r;
    vec4 sourceColor = texture2D(tColor, vUv);
    vec3 gray = vec3(dot(sourceColor.rgb, vec3(0.299, 0.587, 0.114)));
    vec3 fadedColor = mix(gray, sourceColor.rgb, 0.1);

    vec3 finalColor = mix(min(sourceColor.rgb, 1.), fadedColor, mask);
    gl_FragColor = vec4(finalColor, sourceColor.a);
}
