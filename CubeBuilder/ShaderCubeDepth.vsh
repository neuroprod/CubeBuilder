//
//  Shader.vsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec4 normal;



uniform mat4 normalMatrix;
uniform mat4 worldMatrix;
uniform mat4 perspectiveMatrix;
uniform float minDepth;
uniform float depthRange;

varying vec4 colorVarying;

void main()
{
    
    
    
    
    
    vec4 worldSpace = worldMatrix*position;
    gl_Position =perspectiveMatrix*worldSpace;

    vec4 N = normalMatrix *normal;
    
    
    float d = (worldSpace.z+minDepth )/(depthRange*2.0) ;
    
  
     colorVarying  = vec4(N.xyz,1.0-d );

}
