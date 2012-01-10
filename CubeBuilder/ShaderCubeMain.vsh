//
//  Shader.vsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec4 normal;
attribute vec3 color;

uniform mat4 worldMatrix;
uniform mat4 normalMatrix;
uniform mat4 perspectiveMatrix;

varying vec4 colorVarying;


void main()
{
     vec4 worldSpace = worldMatrix*position;
    gl_Position =perspectiveMatrix*worldSpace;
    
    
   
    vec4 N  = normalMatrix* normal;
 
     
     
     vec4 lightWorld =vec4(85.0,-70.0,100.0,1.0);
     vec3 lightDir = normalize(lightWorld.xyz-worldSpace.xyz) ;
    
     vec3 lightWorld2 =vec3(50.0,100.0,200.0);
     vec3 lightDir2 = normalize(lightWorld2);
    vec3  eyeVec =normalize(-worldSpace.xyz);
    
    
    
    float lambertTerm = abs(dot(lightDir,N.xyz ))*0.4+clamp(dot(lightDir2,N.xyz  ),0.0,1.0)*0.9;
    
    lambertTerm +=0.5;
    lambertTerm *=0.66666;
   colorVarying =vec4(color*clamp(lambertTerm,0.0,1.0),1.0);
    
    
    vec3 R = reflect(-lightDir2, N.xyz );
     float p =max(dot(  eyeVec,R ), 0.0);
     float specular = pow (p,4.0);
    colorVarying+=specular*0.3;
    

}
