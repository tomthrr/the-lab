uniform float uTime;
uniform vec3 uColor;

varying vec3 vPosition;
varying vec3 vNormal;

void main()
{
    vec3 normal = normalize(vNormal);
    if (!gl_FrontFacing) {
        normal *= -1.0;
    }

    float stripes = mod((vPosition.y - uTime * 0.02) * 20.0, 1.0);
    stripes = pow(stripes, 3.0);

    // Fresnel
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    // 2 vectors
    // If same directions -> 1
    // else if perpendicular -> 0
    // else opposite -> -1
    float fresnel = dot(viewDirection, normal) + 1.0;
    fresnel = pow(fresnel, 2.0);

    // Falloff
    float fallOff = smoothstep(0.8, 0.0, fresnel);

    float hologram = stripes * fresnel;
    hologram += fresnel * 1.25;
    hologram *= fallOff;

    gl_FragColor = vec4(uColor, hologram);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}