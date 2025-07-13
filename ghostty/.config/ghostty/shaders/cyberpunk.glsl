// Cyberpunk Purple & Neon Green Shader for Ghostty
// Inspired by retro terminals and cyberpunk aesthetics

#version 330 core

uniform float time;
uniform vec2 resolution;
uniform sampler2D source;

in vec2 v_texcoord;
out vec4 fragColor;

// Noise function for subtle effects
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Smooth noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Neon glow effect
vec3 neonGlow(vec3 color, float intensity) {
    return color * (1.0 + intensity * (0.5 + 0.5 * sin(time * 4.0)));
}

// Scanlines
float scanlines(vec2 coord) {
    return sin(coord.y * 600.0) * 0.08 + 0.92;
}

// CRT curvature (very subtle)
vec2 curveScreen(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    vec2 offset = abs(uv.yx) / vec2(8.0, 6.0);
    uv = uv + uv * offset * offset;
    uv = uv * 0.5 + 0.5;
    return uv;
}

// Chromatic aberration
vec3 chromaticAberration(sampler2D tex, vec2 uv) {
    vec2 distortion = (uv - 0.5) * 0.015;
    float r = texture(tex, uv - distortion).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv + distortion).b;
    return vec3(r, g, b);
}

void main() {
    vec2 uv = curveScreen(v_texcoord);
    
    // Sample the source texture with chromatic aberration
    vec3 color = chromaticAberration(source, uv);
    
    // Calculate luminance for selective coloring
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    
    // Add purple atmosphere to dark areas
    if (lum < 0.2) {
        vec3 purpleAtmosphere = vec3(0.4, 0.15, 0.6);
        color = mix(color, purpleAtmosphere, 0.25 * (1.0 - lum * 5.0));
    }
    
    // Enhance bright areas with neon green glow
    if (lum > 0.6) {
        vec3 neonGreen = vec3(0.1, 1.0, 0.3);
        float glowStrength = (lum - 0.6) / 0.4;  // 0 to 1 for lum 0.6 to 1.0
        color = mix(color, neonGreen, glowStrength * 0.3);
        color = neonGlow(color, glowStrength * 0.6);
    }
    
    // Add subtle flickering
    float flicker = 1.0 + 0.03 * sin(time * 60.0) * random(vec2(time * 0.001));
    color *= flicker;
    
    // Add scanlines
    color *= scanlines(uv * resolution);
    
    // Add some film grain
    float grain = noise(uv * resolution * 0.5 + time * 0.1) * 0.05;
    color += grain;
    
    // Vignette effect
    vec2 vignetteUV = uv * (1.0 - uv);
    float vignette = vignetteUV.x * vignetteUV.y * 16.0;
    vignette = pow(vignette, 0.15);
    color *= vignette;
    
    // Final color boost and atmosphere
    color += vec3(0.05, 0.02, 0.1) * (0.5 + 0.5 * sin(time * 2.0));
    
    fragColor = vec4(color, 1.0);
}
