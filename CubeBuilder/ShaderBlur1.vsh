//
//  Shader.vsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 uv;

uniform mat4 worldMatrix;

varying vec2 uvVarying;



void main()
{
    
    gl_Position =worldMatrix*position;
    uvVarying.x=uv.x;
     uvVarying.y=1.0-uv.y;
 }
