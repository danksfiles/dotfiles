#version 330 core

uniform sampler2D source;
in vec2 v_texcoord;
out vec4 fragColor;

void main() {
    vec3 color = texture(source, v_texcoord).rgb;
    // Make everything have a green tint - this should be VERY obvious
    color = mix(color, vec3(0.0, 1.0, 0.0), 0.3);
    fragColor = vec4(color, 1.0);
}
