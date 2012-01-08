//
//  Shader.fsh
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


varying mediump vec3 uvVarying;

uniform sampler2D texture; 

 mediump vec2 pos;
    
    mediump vec4 tempColor;

void main()
{
   
    mediump vec4 sourceColor = texture2D(texture, uvVarying.xy);

    
        mediump float blurColor =0.0 ;
    
        mediump vec2 temp =  uvVarying.xy;
    
   
    
        for (mediump float  i =-10.0;i<10.0;i++)
        {
     
      
            pos = vec2(temp.x +(i*0.002),temp.y) ;
            tempColor =texture2D(texture,pos );
            
            blurColor += tempColor.x*0.05;
           
          }
     
    
    
        gl_FragColor =vec4 ( blurColor, sourceColor.y, 0.0 ,sourceColor.a);
 
  

     
}