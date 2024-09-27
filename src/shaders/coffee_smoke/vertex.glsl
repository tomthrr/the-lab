#include '../utils/rotate2D.glsl';

uniform float uTime;
uniform sampler2D uPerlinTexture;

varying vec2 vUv;

void main()
{
    vec3 newPosition = position;

    //Twist
    float twistPerlin = texture(
        uPerlinTexture,
        vec2(0.5, uv.y * 0.2 - uTime * 0.005)
    ).r;
    float angle = twistPerlin * 10.0;
    newPosition.xz = rotate2D(newPosition.xz, angle);

    // Wind
    vec2 windOffset = vec2(
        texture(uPerlinTexture, vec2(0.25, uTime * 0.01)).r - 0.5,  // to not the value is always positive we substrait by 0.5, it goes from -0.5 to 0.5
        texture(uPerlinTexture, vec2(0.75, uTime * 0.01)).r - 0.5   // to not the value is always positive we substrait by 0.5, it goes from -0.5 to 0.5
    );

    windOffset *= pow(uv.y, 3.0) * 10.0;

    newPosition.xz += windOffset;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);

    // varying
    vUv = uv;
}