
varying vec3 pos;
varying vec3 lpos;
varying vec2 vUV;
varying vec3 n;

uniform float iTime;
uniform float transition;
uniform float iSpeed;
uniform float maxSpeed;
uniform float minSpeed;

uniform float exit;
uniform float ready;

uniform float rTime;

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
    float transform = smoothstep(0.,1.2,speed);
    val = mix(val,d*d- 2.,transform);
    
    float s = smoothstep(0.,1.5*fwidth(-val),-val);
    
    return s;

}


void main() {
  vec2 uv = vUV - 0.5;
  uv *= 10.;

  vec2 p = pos.xy;

  float a = getAngle(p);

  float n = noise(vec2(a*PI*4.*1.5,0.235));

  float l = -length(p)  + n*1. + -1. +transition*5.2; 

  float circle = smoothstep(0.,1.5*fwidth(l),l);


  float l2 = -length(p) + n*1. + -1.  +(exit)*5.2; 

  float circle2 = 1.-smoothstep(0.,1.5*fwidth(l2),l2);

  // vec3 col = vec3(1.,0.,1.);

  float o = stepper(uv);
  
  vec3 col = vec3(o*circle*circle2);

  float la = getAngle(lpos.xy);

  float speed = (iSpeed - minSpeed)/(maxSpeed-minSpeed);
  speed = max(speed,0.);
  float transform = smoothstep(0.,1.,speed);

  // transform = 0.;

  vec3 rotationColor = vec3(0.5,0.4,0.9) + cos(la*PI*2.*5. + iTime*4.)/5.;
//   rotationColor = mix(rotationColor,vec3(0.2,0.6,0.8),transform);

  // col *= rotationColor;

  vec3 blinkColor1 = vec3(0.1,0.1,0.4);
  vec3 blinkColor2 = vec3(1.,1.,0.8);

  float xT = fract(rTime/2.);
  float bK = .25;
  float blink = smoothstep( .5-bK, 1.-bK -step(.5-bK,abs(xT-.5)) , xT-step(1.-bK,xT) );

  xT = rTime*4.;
  blink = (cos(xT + PI - sin(xT))+1.)/2.;
  blink = (cos(xT)+1.)/2.;

  float moving = smoothstep(0.,0.25,speed);
  // float ready2 = smoothstep(1.,0.,transition);
  blink = mix(blink,0.,max(moving,1.-ready));

  vec3 bCol = mix(blinkColor1,blinkColor2, blink);

  col *= bCol;

  col *= mix(vec3(1.),rotationColor, transform);
  // col *= mix(1.,1.5,transform2);

  float topSpeed = smoothstep(0.5,1.,speed);
  float topSpeed2 = smoothstep(0.8,1.,speed);
  float topSpeed3 = smoothstep(0.99,1.,speed);

  col *= mix(1.,5.5,topSpeed);
  col *= mix(1., 5.5, topSpeed2);
  col *= mix(1., 1.3, topSpeed3);
  // col = rotationColor;

  // col *= rotationColor;

  // col *= (blinkColor+blink*.5);

  // col = mix(col,blinkColor*col,blink);
  
  col = pow(col,vec3(1./2.2));

  gl_FragColor = vec4(col,1.);
}