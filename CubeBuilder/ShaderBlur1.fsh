//
//  Shader.fsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


varying mediump vec2 uvVarying;

uniform sampler2D texture; 

const highp float totStrength = 1.38;
const  highp float strength = 2.8;
const  highp float offset = 30.0;
const  highp float falloff = 0.1;
const  highp float rad = 0.02;

const highp float invSamples = 1.0/20.0;


void main()
{
 
    mediump vec4 sourceColor = texture2D(texture, uvVarying);

    highp vec3 pSphere[30];
    
    pSphere[0] = vec3(-0.010735935, 0.01647018, 0.0062425877);
    pSphere[1] = vec3(-0.06533369, 0.3647007, -0.13746321);
    pSphere[2] = vec3(-0.6539235, -0.016726388, -0.53000957);
    pSphere[3] = vec3(0.40958285, 0.0052428036, -0.5591124);
    pSphere[4] = vec3(-0.1465366, 0.09899267, 0.15571679);
    pSphere[5] = vec3(-0.44122112, -0.5458797, 0.04912532);
    pSphere[6] = vec3(0.03755566, -0.10961345, -0.33040273);
    pSphere[7] =vec3(0.019100213, 0.29652783, 0.066237666);
    pSphere[8] =vec3(0.8765323, 0.011236004, 0.28265962);
    pSphere[9] =vec3(0.29264435, -0.40794238, 0.15964167);
    
    
    pSphere[10] = vec3(0.010735935, 0.01647018, 0.0062425877);
    pSphere[11] = vec3(0.06533369, 0.3647007, -0.13746321);
    pSphere[12] = vec3(0.6539235, -0.016726388, -0.53000957);
    pSphere[13] = vec3(-0.40958285, 0.0052428036, -0.5591124);
    pSphere[14] = vec3(0.1465366, 0.09899267, 0.15571679);
    pSphere[15] = vec3(0.44122112, -0.5458797, 0.04912532);
    pSphere[16] = vec3(-0.03755566, -0.10961345, -0.33040273);
    pSphere[17] =vec3(-0.019100213, 0.29652783, 0.066237666);
    pSphere[18] =vec3(-0.8765323, 0.011236004, 0.28265962);
    pSphere[19] =vec3(-0.29264435, -0.40794238, 0.15964167);
    
   /* 
    pSphere[20] = vec3(-0.010735935, 0.01647018, -0.0062425877);
    pSphere[21] = vec3(-0.06533369, 0.3647007, 0.13746321);
    pSphere[22] = vec3(-0.6539235, -0.016726388, 0.53000957);
    pSphere[23] = vec3(0.40958285, 0.0052428036, 0.5591124);
    pSphere[24] = vec3(-0.1465366, 0.09899267, -0.15571679);
    pSphere[25] = vec3(-0.44122112, -0.5458797, -0.04912532);
    pSphere[26] = vec3(0.03755566, -0.10961345, 0.33040273);
    pSphere[27] =vec3(0.019100213, 0.29652783, -0.066237666);
    pSphere[28] =vec3(0.8765323, 0.011236004, -0.28265962);
    pSphere[29] =vec3(0.29264435, -0.40794238, -0.15964167);
    */
    
     //highp vec3 fres = normalize((texture2D(rnm,uv*offset).xyz*2.0) - vec3(1.0));
    highp vec3 fres = vec3(0.0,0.0,1.0);//make random
    highp vec4 currentPixelSample = texture2D(texture,uvVarying);
    
    highp float currentPixelDepth =1.0- currentPixelSample.a;
    
    // current fragment coords in screen space
    highp vec3 ep = vec3(uvVarying,currentPixelDepth);
    // get the normal of current fragment
    highp vec3 norm = currentPixelSample.xyz;
    
    highp float bl = 0.0;
    // adjust for the depth ( not shure if this is good..)
    highp float radD = rad/currentPixelDepth;
    
    //vec3 ray, se, occNorm;
    highp float occluderDepth;
    highp float depthDifference;
    highp vec4 occluderFragment;
    highp vec3 ray;
    
    
    
    for(int i=0; i<20;++i)
    {
        // get a vector (randomized inside of a sphere with radius 1.0) from a texture and reflect it
        ray = radD*reflect(pSphere[i],fres);
        
        // get the depth of the occluder fragment
        occluderFragment = texture2D(texture ,ep.xy + sign(dot(ray,norm) )*ray.xy);
        // if depthDifference is negative = occluder is behind current fragment
        depthDifference = currentPixelDepth-(1.0-occluderFragment.a);
        
        // calculate the difference between the normals as a weight
        // the falloff equation, starts at falloff and is kind of 1/x^2 falling
        bl += step(falloff,depthDifference)*(1.0-dot(occluderFragment.xyz,norm))*(1.0-smoothstep(falloff,strength,depthDifference));
    }
    
    // output the result
    gl_FragColor =vec4(0.0,0.0,0.0,bl*invSamples);
     
}