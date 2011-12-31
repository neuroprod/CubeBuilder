//
//  Shader.fsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


varying mediump vec3 uvVarying;

uniform sampler2D texture; 

void main()
{
    
    
    gl_FragColor =texture2D(texture, uvVarying.xy);
    gl_FragColor.xyz /=gl_FragColor.a ;
     
}