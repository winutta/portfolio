
varying vec3 pos;
varying vec3 lpos;
varying vec2 vUV;
varying vec3 n;

uniform float iTime;
uniform float transition;
uniform float iSpeed;
uniform float maxSpeed;
uniform float minSpeed;

#define PI 3.1415926538

float smin( float a, float b, float k )
{
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*h*k*(1.0/6.0);
}

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

float stepper(vec2 uv) {

    float a = getAngle(uv)*PI*2.;
    float d = length(uv);
    
    d -= 2.;
    a *= 5.;
    
    float sOsc = (cos(iTime+PI) + 1.)/2.;
    sOsc = (cos(iTime +PI - sin(iTime))+1.)/2.;
    float eps = .5;
    sOsc = smoothstep(0.5-eps,0.5+eps,abs(fract(iTime/15.)-0.5)*2.);
    // sOsc = 0.;

    float start = smoothstep(.9,1.,transition);
    // float mi = 0.9;
    // float ma = 1.;
    // start = smoothstep(0.,1.,clamp((transition - mi)/(ma-mi),0.,1.));

    // float maxSpeed = 4.5;
    // float minSpeed = 1.;

    // float speedRange = maxSpeed-minSpeed;
    
    // float speeder = (minSpeed+speedRange/2.)*iTime + speedRange*(cos(iTime + PI/2.)+1.)/2. - speedRange/2.;
    // float speed = minSpeed*0. + speedRange/2. - speedRange*sin(iTime + PI/2.)/2. ;
    
    // float val = sin(a-d*5.*sOsc - d*speed + iTime*4.*0. + speeder*4. + sOsc*5.) + d*d - sOsc*5.*0. - sin(a + d)*0.-0.;
    // Just replace speeder with iTime when altering speed in javascript.
    // Manually pass speed as a uniform;
    float speeder = iTime;
    float speed = (iSpeed - minSpeed)/(maxSpeed-minSpeed);
    speed = max(speed,0.);

    float val = sin(a - d*speed*4. + speeder*4.) + d*d;
    // val = d-1.;
    float transform = smoothstep(0.,1.1,speed);
    // val = mix(val,d*d- 2.,transform);
    
    float s = smoothstep(0.,1.5*fwidth(-val),-val);
    
    return s;

}


void main() {
  vec2 uv = vUV - 0.5;
  uv *= 10.;

  vec2 p = pos.xy;

  float a = getAngle(p);

  float n = noise(vec2(a*PI*4.*1.5,0.235));

  float l = -length(p) - (cos(a*PI*2.*6.)+1.)/10.*0. + n*1. + -1. +transition*3.2; 

  float circle = smoothstep(0.,1.5*fwidth(l),l);

  // vec3 col = vec3(1.,0.,1.);

  float o = stepper(uv);
  
  vec3 col = vec3(o*circle);

  float la = getAngle(lpos.xy);

  float speed = (iSpeed - minSpeed)/(maxSpeed-minSpeed);
  speed = max(speed,0.);
  float transform = smoothstep(0.,1.,speed);
  transform = 0.;

  vec3 rotationColor = mix(vec3(0.5,0.4,0.9),vec3(0.7,0.5,0.4),transform) + cos(la*PI*2.*1. + iTime*4./5.)/5.;
//   rotationColor = mix(rotationColor,vec3(0.2,0.6,0.8),transform);

  col *= rotationColor;
  
  col = pow(col,vec3(1./2.2));

  gl_FragColor = vec4(col,1.);
}