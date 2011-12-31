//
//  Shader.fsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


varying lowp vec3 uvVarying;

uniform sampler2D texture; 

void main()
{
    
    
    gl_FragColor =texture2D(texture, uvVarying.xy);
  gl_FragColor.a   *= uvVarying.z;
 gl_FragColor.xyz /=gl_FragColor.a ;
    
   // gl_FragColor = vec4(0.0,1.0,1.0,1.0);
    
}