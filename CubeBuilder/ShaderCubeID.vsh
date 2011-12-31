//
//  Shader.vsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;

attribute vec3 color;

uniform mat4 worldMatrix;

uniform mat4 perspectiveMatrix;


varying vec3 colorVarying;


void main()
{
    
    gl_Position =perspectiveMatrix* worldMatrix*position;
  
    
  
     colorVarying  = color;
}
