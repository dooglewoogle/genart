#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;
uniform vec2 resolution;


float material_thickness = 1.0;
uniform float depth;
uniform float scale;
float iorBend = .01;
int sampleCount = 20;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 fade(vec2 x) { return x * x * x * (x * (x * 6. - 15.) + 10.); }

vec2 phash(vec2 p)
{
    p = fract(mat2(1.2989833, 7.8233198, 6.7598192, 3.4857334) * p);
    p = ((2384.2345 * p - 1324.3438) * p + 3884.2243) * p - 4921.2354;
    return normalize(fract(p) * 2. - 1.);
}

float noise(vec2 p)
{
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    float d00 = dot(phash(ip), fp);
    float d01 = dot(phash(ip + vec2(0, 1)), fp - vec2(0, 1));
    float d10 = dot(phash(ip + vec2(1, 0)), fp - vec2(1, 0));
    float d11 = dot(phash(ip + vec2(1, 1)), fp - vec2(1, 1));
    fp = fade(fp);
    return mix(mix(d00, d01, fp.y), mix(d10, d11, fp.y), fp.x);
}

void main(void)
{

    float OS = .2;
    vec2 uv = -1. + 2. * vertTexCoord.st;

    
    vec2 p = gl_FragCoord.xy * scale / resolution.y;
    vec2 c = vec2(noise(p+OS*5), noise(p+OS*10))+.5;
    vec2 c2 = vec2(noise(p+OS*2.), noise(p+OS*3.))+.5;
    
    vec3 accum = vec3(0);
    
    for (int i=0;i<sampleCount;i++){
       vec2 randIncoming = vec2(rand(vertTexCoord.st+2.+float(i)), rand(vertTexCoord.st+float(i)));
    
       vec2 bounce1_output = refract(randIncoming, c, 1.0 + iorBend);
       vec2 bounce2_output = refract(bounce1_output, c2, 1.0 - iorBend);
        
       vec2 coo = vertTexCoord.st + ( bounce2_output * depth);
       
       accum += texture2D(texture, coo).rgb;
    }
    accum /=float(sampleCount);
    gl_FragColor = vec4(accum, 1.);
}