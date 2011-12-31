//
//  Shader.vsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;

uniform mat4 worldMatrix;
uniform mat4 perspectiveMatrix;

varying vec3 colorVarying;

void main()
{
    
    
    
    
    
    vec4 worldSpace = worldMatrix*position;
    gl_Position =perspectiveMatrix*worldSpace;

    
    
    float d = (worldSpace.z )/-10.0;
   
  
     colorVarying  = vec3(d,d,d);

}
