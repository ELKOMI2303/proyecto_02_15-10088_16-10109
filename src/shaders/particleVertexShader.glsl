//#version 300 es
precision highp float;

in vec3 position;
in float size;
in vec3 customColor;

out vec3 vColor;
uniform float time;
uniform float amplitud; // param1
uniform float frecuencia; // param2
uniform float fase; // param3
uniform int behavior;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main() {
    vColor = customColor;
    vec3 pos = position;

    if (behavior == 0) {
        // Simulación de humo
        pos.y += amplitud * sin(time * frecuencia + position.x + fase);
        pos.x += amplitud * cos(time * frecuencia + position.y + fase);
    } else if (behavior == 1) {
        // Movimiento basado en fuerzas (gravedad)
        pos.y -= amplitud * time;
    } else if (behavior == 2) {
        // Estelas de partículas siguiendo un objeto
        pos.x += sin(time * frecuencia + position.x) * amplitud + fase;
        pos.y += cos(time * frecuencia + position.y) * amplitud + fase;
    }

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = size * (300.0 / -mvPosition.z) * amplitud;
    gl_Position = projectionMatrix * mvPosition;
}
