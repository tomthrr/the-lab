uniform sampler2D uPerlinTexture;
uniform float uTime;


varying vec2 vUv;

void main()
{
    // Scale and animate
    vec2 smokeUv = vUv; // create a sample to play with vUv values
    smokeUv.x *= 0.5;
    smokeUv.y *= 0.3; // reduce the pattern from perlin texture

    smokeUv.y -= uTime * 0.03;


    // Smoke
    float smoke = texture(uPerlinTexture, smokeUv).r;

    // Remap
    smoke = smoothstep(0.4, 1.0, smoke); // all values below 0.4 will stay at 0, and then add smooth transition, like ease in out

    // Edges
    smoke *= smoothstep(0.0, 0.1, vUv.x); // left part 0 -> 1
    smoke *= smoothstep(1.0, 0.9, vUv.x); // right part 1 -> 0

    smoke *= smoothstep(0.0, 0.1, vUv.y); // left part 0 -> 1
    smoke *= smoothstep(1.0, 0.4, vUv.y); // right part 1 -> 0

    gl_FragColor = vec4(0.6, 0.3, 0.2, smoke);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}