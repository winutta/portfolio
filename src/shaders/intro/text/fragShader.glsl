#define PI 3.1415926538

varying vec3 pos;
varying vec2 vUV;
varying vec3 n;

uniform float iTime;

uniform float transition;
uniform float exit;

float getAngle(vec2 v1)
{
    //return atan(v1.x,v1.y) -atan(v2.x,v2.y);
    return mod( atan(v1.x,v1.y) -atan(1.,0.), PI*2.)/PI/2.; //0 ... TWOPI
    //return mod( atan(v1.x,v1.y) -atan(v2.x,v2.y), TWOPI) - PI; //-pi to +pi 
}

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

void main() {
  // vec3 col = vec3(1.,0.,1.);
  vec2 uv = vUV - 0.5;
  vec2 p = pos.xy;

  float a = getAngle(p);

  float n = noise(vec2(a*PI*4.*1.5,0.235));

  float l = -length(p) + n*1. + -1.  +transition*5.2;

  float circle = smoothstep(0.,1.5*fwidth(l),l);

  
  float l2 = -length(p) + n*1. + -1.  +(exit)*5.2; 

  float circle2 = 1.-smoothstep(0.,1.5*fwidth(l2),l2);


  vec3 col = vec3(circle*circle2);

  

  gl_FragColor = vec4(col,1.);
}