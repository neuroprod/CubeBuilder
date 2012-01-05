//
//  Shader.fsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



varying mediump vec3 normalVarying;
varying lowp vec3 colorVarying;

varying highp vec3 lightDir;
varying highp vec3 lightDir2;
varying highp vec3 eyeVec;

void main()
{
    
    highp float lambertTerm = abs(dot(lightDir,normalVarying ))*0.4+clamp(dot(lightDir2,normalVarying  ),0.0,1.0)*0.9;
    
    lambertTerm +=1.0;
    lambertTerm *=0.5;
     gl_FragColor =vec4(colorVarying*clamp(lambertTerm,0.0,1.0),1.0);
    
    
    highp vec3 R = reflect(-lightDir2, normalVarying );
    highp float p =max(dot(  eyeVec,R ), 0.0);
    highp float specular = pow (p,2.0);
     gl_FragColor+=specular*0.3;
    
    /*
 
     highp float lambertTerm = clamp(dot(lightDir,normalVarying ),0.0,1.0)*0.8+clamp(dot(lightDir2,normalVarying  ),0.0,1.0)*0.4;
    
   
    
    highp vec3 R = reflect(-lightDir, normalVarying );
    highp float p =max(dot(  eyeVec,R ), 0.0);
    highp float specular = pow (p,4.0);
    
    
    highp vec3 R2 = reflect(-lightDir2, normalVarying );
    highp float p2 =max(dot(  eyeVec,R2 ), 0.0);
    highp float  specular2 = pow (p2,4.0);
    
  
    lambertTerm =clamp(lambertTerm,0.0,1.0)*0.65+0.35;
    
    gl_FragColor =vec4(colorVarying*lambertTerm,1.0); 
    
   gl_FragColor+=specular*0.2+specular2*0.3;

    */
}