//
//  Shader.fsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


varying mediump vec2 uvVarying;

uniform sampler2D texture; 
uniform sampler2D textureNoise; 
const highp float totStrength = 1.38;
const  highp float strength = 0.08;

const  highp float falloff = 0.00001;
const  highp float rad = 0.006;

const highp float invSamples = 1.0/20.0;


void main()
{
 
    mediump vec4 sourceColor = texture2D(texture, uvVarying);

    highp vec3 pSphere[20];
    pSphere[0] = vec3(-0.390934,-0.288094,0.781881);
    pSphere[1] = vec3(0.222725,-0.0360308,0.871365);
    pSphere[2] = vec3(0.0284122,-0.243688,0.867091);
    pSphere[3] = vec3(-0.37143,0.146671,0.820013);
    pSphere[4] = vec3(0.147826,0.358394,0.824476);
    pSphere[5] = vec3(-0.103622,0.0172705,0.889478);
    pSphere[6] = vec3(0.263622,-0.370725,0.796526);
    pSphere[7] = vec3(-0.370794,0.0246623,0.830375);
    pSphere[8] = vec3(0.138745,-0.399093,0.810666);
    pSphere[9] = vec3(-0.0967774,-0.359567,0.830106);
    pSphere[10] = vec3(-0.0726019,0.164336,0.879874);
    pSphere[11] = vec3(0.0740651,0.3583,0.832411);
    pSphere[12] = vec3(0.29569,0.0230021,0.854184);
    pSphere[13] = vec3(-0.340008,0.128258,0.83328);
    pSphere[14] = vec3(-0.0737434,0.176623,0.877891);
    pSphere[15] = vec3(0.336474,0.21501,0.820027);
    pSphere[16] = vec3(-0.193235,-0.36812,0.813461);
    pSphere[17] = vec3(0.204307,-0.148647,0.865407);
    pSphere[18] = vec3(0.114868,0.222057,0.866023);
    pSphere[19] = vec3(0.3997,-0.109613,0.81399);
     
   //highp vec3 fres = normalize((texture2D(textureNoise,uvVarying).xyz )  ) ;
   mediump  vec3 fres = normalize((texture2D(textureNoise,uvVarying).xyz*2.0) - vec3(1.0));
    
    //highp vec3 fres = vec3(0.0,0.0,1.0);//make random
    fres.z*=-1.0;
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
        ray = radD*reflect(fres,pSphere[i]);
       

        // get the depth of the occluder fragment
        occluderFragment = texture2D(texture ,uvVarying +pSphere[i].xy*0.05);// + sign(dot(ray,norm) )*ray.xy);
        // if depthDifference is negative = occluder is behind current fragment
        depthDifference =occluderFragment.a - currentPixelDepth;
        
        // calculate the difference between the normals as a weight
        // the falloff equation, starts at falloff and is kind of 1/x^2 falling
      // bl += step(falloff,depthDifference)*(1.0-dot(occluderFragment.xyz,norm))*(1.0-smoothstep(falloff,strength,depthDifference));
        bl+= clamp(-depthDifference,0.0,1.0)*5.0;
       // bl +=occluderFragment.a ;//(1.0-dot((occluderFragment.xyz-0.5)/2.0,(norm-0.5)/2.0))/2.0;

    }
    
    // output the result
 //  gl_FragColor =vec4(0.0,0.0,0.0,bl*invSamples)  ;
   //    gl_FragColor =vec4(bl*invSamples,bl*invSamples,bl*invSamples,1.0)  ;
    
    gl_FragColor =vec4(0.0,0.0,0.0,0.0);
    
     //gl_FragColor =vec4(currentPixelDepth,currentPixelDepth,currentPixelDepth,1.0)  ;
   //  gl_FragColor =sourceColor +texture2D(textureNoise,uvVarying) ;
}