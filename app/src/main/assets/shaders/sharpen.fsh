precision mediump float;
uniform sampler2D sampler0;
uniform vec2 u_texelDelta;
varying vec2 v_texcoord0;

void main() {
    vec2 d = u_texelDelta;
    vec4 center = texture2D(sampler0, v_texcoord0);
    vec4 up     = texture2D(sampler0, v_texcoord0 + vec2(0.0, -d.y));
    vec4 down   = texture2D(sampler0, v_texcoord0 + vec2(0.0,  d.y));
    vec4 left   = texture2D(sampler0, v_texcoord0 + vec2(-d.x, 0.0));
    vec4 right  = texture2D(sampler0, v_texcoord0 + vec2( d.x, 0.0));

    vec4 neighborAvg = (up + down + left + right) * 0.25;
    vec4 edgeDiff = abs(center - neighborAvg);
    float edgeStrength = clamp((edgeDiff.r + edgeDiff.g + edgeDiff.b) * 3.0, 0.0, 1.0);

    float amount = 0.75 * edgeStrength;
    vec4 sharpened = center * (1.0 + 4.0 * amount) - (up + down + left + right) * amount;

    vec4 result = clamp(sharpened, 0.0, 1.0);
    result.rgb = mix(result.rgb, result.rgb * 1.06, 0.5);

    gl_FragColor = clamp(result, 0.0, 1.0);
}
