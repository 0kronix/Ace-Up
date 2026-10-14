#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec2 prismatic;
extern PRECISION float dissolve;
extern PRECISION float time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

vec3 prismatic_palette(float t) {
    t = fract(t);

    vec3 c0 = vec3(0.10, 1.00, 0.45);
    vec3 c1 = vec3(0.10, 0.85, 1.00);
    vec3 c2 = vec3(0.95, 1.00, 0.15);
    vec3 c3 = vec3(1.00, 0.65, 0.10);
    vec3 c4 = vec3(0.90, 0.15, 0.55);
    vec3 c5 = vec3(0.55, 0.15, 1.00);
    vec3 c6 = vec3(1.00, 0.85, 0.95);

    float s = t * 7.0;
    float f = fract(s);
    int i = int(floor(s));

    if (i == 0) return mix(c0, c1, f);
    if (i == 1) return mix(c1, c2, f);
    if (i == 2) return mix(c2, c3, f);
    if (i == 3) return mix(c3, c4, f);
    if (i == 4) return mix(c4, c5, f);
    if (i == 5) return mix(c5, c6, f);
                return mix(c6, c0, f);
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

    if (tex.a == 0.0) return vec4(0.0);

    float t = prismatic.y * 2.221 + time;

    float lum = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

    vec2 adjusted_uv = uv - vec2(0.5, 0.5);
    adjusted_uv.x = adjusted_uv.x * texture_details.b / texture_details.a;

    float radius = length(adjusted_uv);
    vec2 dir = adjusted_uv / (radius + 0.0001);

    float swirl = dir.x * 4.0 + dir.y * 3.0 + radius * 8.0 + t * 0.6;
    float swirl2 = dir.x * -3.0 + dir.y * 5.0 + radius * 5.0 - t * 0.4;
    float swirl3 = dir.x * 2.0 - dir.y * 4.0 - radius * 12.0 + t * 0.8;

    float band = (sin(swirl) + sin(swirl2) + sin(swirl3)) / 3.0;
    band = band * 0.5 + 0.5;

    float radial = smoothstep(0.0, 0.7, radius);
    float palette_pos = band * 0.75 + radial * 0.25 + lum * 0.15;

    vec3 iri_a = prismatic_palette(palette_pos);
    vec3 iri_b = prismatic_palette(palette_pos + 0.5);
    vec3 iri = mix(iri_a, iri_b, 0.5);

    iri = pow(iri, vec3(0.85));

    float blend = smoothstep(0.1, 0.75, lum);
    vec3 base = mix(tex.rgb * vec3(0.40, 0.55, 0.50), iri, blend * 0.95 + 0.05);

    float highlight_dot = dir.x * 0.7 + dir.y * 0.7 + sin(t * 0.5) * 0.15;
    float highlight = smoothstep(0.55, 0.95, highlight_dot);
    base = mix(base, vec3(1.00, 1.00, 0.90), highlight * 0.50 * radial);

    float shine = smoothstep(0.80, 1.0, lum);
    base = mix(base, vec3(1.00, 1.00, 0.95), shine * 0.50);

    float vignette = 1.0 - length(uv - 0.5) * 0.4;
    base *= vignette;

    tex.rgb = clamp(base, 0.0, 1.0);
    return dissolve_mask(tex * colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }
    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01;
    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t/143.6340), cos(-t/99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t/53.1532),  cos( t/61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t/87.53218), sin(-t/49.0000));
    float field = (1.+(cos(length(field_part1)/19.483)+sin(length(field_part2)/33.155)*cos(field_part2.y/15.73)+cos(length(field_part3)/27.193)*sin(field_part3.x/21.92)))/2.;
    vec2 borders = vec2(0.2, 0.8);
    float res = (.5+.5*cos((adjusted_dissolve)/82.612+(field+-.5)*3.14))
    -(floored_uv.x>borders.y?(floored_uv.x-borders.y)*(5.+5.*dissolve):0.)*(dissolve)
    -(floored_uv.y>borders.y?(floored_uv.y-borders.y)*(5.+5.*dissolve):0.)*(dissolve)
    -(floored_uv.x<borders.x?(borders.x-floored_uv.x)*(5.+5.*dissolve):0.)*(dissolve)
    -(floored_uv.y<borders.x?(borders.x-floored_uv.y)*(5.+5.*dissolve):0.)*(dissolve);
    if (tex.a>0.01&&burn_colour_1.a>0.01&&!shadow&&res<adjusted_dissolve+0.8*(0.5-abs(adjusted_dissolve-0.5))&&res>adjusted_dissolve) {
        if (!shadow&&res<adjusted_dissolve+0.5*(0.5-abs(adjusted_dissolve-0.5))&&res>adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) { tex.rgba = burn_colour_2.rgba; }
    }
    return vec4(shadow?vec3(0.,0.,0.):tex.xyz, res>adjusted_dissolve?(shadow?tex.a*0.3:tex.a):.0);
}

extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    if (hovering <= 0.) { return transform_projection * vertex_position; }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03-0.3*max(0.,0.3-mid_dist))*hovering*(length(mouse_offset)*length(mouse_offset))/(2.-mid_dist);
    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif