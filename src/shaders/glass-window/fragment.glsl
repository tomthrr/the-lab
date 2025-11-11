// shaders/glass-window/fragment.glsl
uniform sampler2D u_texture;
uniform vec2 u_resolution;
uniform vec3 u_glassTint;
uniform float u_blurAmount;
uniform float u_opacity;
uniform float u_mixGlassTint;

varying vec2 vUv;

void main() {
    // coordonnées écran normalisées -> pour échantillonner la texture rendue en renderTarget
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    vec4 color = vec4(0.0);
    float total = 0.0;

    // Simple box blur
    float blurSize = u_blurAmount / u_resolution.x;
    for(float x = -4.0; x <= 4.0; x += 1.0) {
        for(float y = -4.0; y <= 4.0; y += 1.0) {
            vec2 offset = vec2(x, y) * blurSize;
            color += texture2D(u_texture, uv + offset);
            total += 1.0;
        }
    }
    color /= total;

    // Add frosted glass tint
    color.rgb = mix(color.rgb, u_glassTint, u_mixGlassTint);

    // Edge highligth: bord autour de chaque carré
    float edge = smoothstep(0.0, 0.1, vUv.x) * smoothstep(1.0, 0.9, vUv.x) *
    smoothstep(0.0, 0.1, vUv.y) * smoothstep(1.0, 0.9, vUv.y);
    color.rgb += (1.0 - edge) * 0.1;

    gl_FragColor = vec4(color.rgb, u_opacity); // utiliser u_opacity
}
