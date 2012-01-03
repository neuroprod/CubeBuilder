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

uniform vec4 color;
uniform vec4 pos;

varying vec4 colorVarying;


void main()
{
    vec4 posF = worldMatrix*(pos+position);
    gl_Position =perspectiveMatrix* posF;
     colorVarying  = color;
}
