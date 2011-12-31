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

varying vec3 normalVarying;
varying vec3 colorVarying;

varying  vec3 lightDir;
varying  vec3 lightDir2;
varying  vec3 eyeVec;

void main()
{
     vec4 worldSpace = worldMatrix*position;
    gl_Position =perspectiveMatrix*worldSpace;
    
    
   
    vec4 N  = normalMatrix* normal;
    
    normalVarying  = N.xyz;
     colorVarying  = color;
     
     
     vec3 lightWorld =vec3(-20.0,-20.0,100.0);
    lightDir = normalize(lightWorld) ;
    
     vec3 lightWorld2 =vec3(100.0,100.0,100.0);
    lightDir2 = normalize(lightWorld2);
    eyeVec =normalize(-worldSpace.xyz);

}
