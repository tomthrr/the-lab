vec3 directionalLigth(
    vec3 lightColor,
    float lightIntensity,
    vec3 normal,
    vec3 lightPosition,
    vec3 viewDirection, // vecctor from camera to the current fragment
    float specularPower
) {
    vec3 lightDirection = normalize(lightPosition);
    vec3 lightReflection = reflect(- lightDirection, normal); // vecctor from ligth to the current fragment

    // Shading
    float shading = dot(normal, lightDirection);
    shading = max(0.0, shading);

    // Specular
    // if the light reflection is in the same direction with viewDirection
    // then reflection
    float specular = - dot(lightReflection, viewDirection);
    specular = max(0.0, specular);
    specular = pow(specular, specularPower);

    return lightColor * lightIntensity * (shading + specular);
    //    return vec3(specular);
}