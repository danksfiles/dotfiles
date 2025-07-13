// Purple Glow - Subtle shader with purple atmosphere and green highlights
#version 330 core

uniform float time;
uniform vec2 resolution;
uniform sampler2D source;

in vec2 v_texcoord;
out vec4 fragColor;

void main() {
    vec2 uv = v_texcoord;
    vec3 color = texture(source, uv).rgb;
    
    // Calculate luminance
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    
    // Add subtle purple tint to dark areas
    if (lum < 0.3) {
        vec3 purple = vec3(0.3, 0.1, 0.4);
        color = mix(color, purple, 0.15 * (1.0 - lum * 3.33));
    }
    
    // Add subtle green glow to bright areas
    if (lum > 0.7) {
        vec3 green = vec3(0.2, 0.8, 0.3);
        float intensity = (lum - 0.7) / 0.3;
        color = mix(color, green, intensity * 0.2);
        
        // Subtle pulsing glow
        float pulse = 1.0 + 0.1 * sin(time * 3.0);
        color *= pulse;
    }
    
    // Very subtle scanlines
    float scanline = sin(uv.y * 400.0) * 0.02 + 0.98;
    color *= scanline;
    
    fragColor = vec4(color, 1.0);
}
