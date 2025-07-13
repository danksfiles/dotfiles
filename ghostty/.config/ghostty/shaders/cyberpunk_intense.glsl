// Cyberpunk INTENSE - Strong neon effects and visible pulsing
#version 330 core

uniform float time;
uniform vec2 resolution;
uniform sampler2D source;

in vec2 v_texcoord;
out vec4 fragColor;

// Noise function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Strong neon glow with visible pulsing
vec3 neonGlow(vec3 color, float intensity) {
    float pulse = 1.0 + 0.4 * sin(time * 6.0) + 0.2 * sin(time * 12.0);
    return color * (1.0 + intensity * pulse);
}

// More visible scanlines
float scanlines(vec2 coord) {
    return sin(coord.y * 500.0) * 0.15 + 0.85;
}

// Chromatic aberration
vec3 chromaticAberration(sampler2D tex, vec2 uv) {
    vec2 distortion = (uv - 0.5) * 0.025;
    float r = texture(tex, uv - distortion).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv + distortion).b;
    return vec3(r, g, b);
}

void main() {
    vec2 uv = v_texcoord;
    
    // Sample with chromatic aberration
    vec3 color = chromaticAberration(source, uv);
    
    // Calculate luminance
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    
    // Strong purple atmosphere for ALL dark areas
    if (lum < 0.4) {
        vec3 purpleAtmosphere = vec3(0.6, 0.2, 0.8);
        float mixAmount = 0.4 * (1.0 - lum * 2.5);
        color = mix(color, purpleAtmosphere, mixAmount);
    }
    
    // AGGRESSIVE neon green for any moderately bright content
    if (lum > 0.3) {
        vec3 neonGreen = vec3(0.0, 1.0, 0.2);
        float glowStrength = (lum - 0.3) / 0.7;  // 0 to 1 for lum 0.3 to 1.0
        
        // Much stronger mixing
        color = mix(color, neonGreen, glowStrength * 0.6);
        
        // Strong pulsing glow
        color = neonGlow(color, glowStrength * 1.2);
        
        // Extra bright boost for very bright areas
        if (lum > 0.7) {
            color *= 1.3;
        }
    }
    
    // Strong flickering effect
    float flicker = 1.0 + 0.08 * sin(time * 80.0) * random(vec2(time * 0.01));
    color *= flicker;
    
    // Visible scanlines
    color *= scanlines(uv * resolution);
    
    // More visible film grain
    float grain = random(uv * resolution * 0.3 + time * 0.2) * 0.1;
    color += grain;
    
    // Global pulsing atmosphere
    float globalPulse = 1.0 + 0.1 * sin(time * 3.0);
    color *= globalPulse;
    
    // Final neon boost
    color += vec3(0.1, 0.4, 0.1) * sin(time * 4.0) * 0.2;
    
    fragColor = vec4(color, 1.0);
}
