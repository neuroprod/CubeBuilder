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
    
   
    
  
    for (mediump float  j=-10.0;j<10.0;j++)
    {
     
      
           pos = vec2(temp.x ,temp.y+(j*0.002)) ;
            tempColor =texture2D(texture,pos );
          blurColor += tempColor.x*0.05;
    

       
    
    
    
    
    }

        
            mediump float v =clamp( (blurColor-sourceColor.y),0.0,1.0);
        
            mediump float srcAmin= 1.0 - sourceColor.a;
            gl_FragColor =vec4 (0.0,0.0,0.0 ,v*10.0*sourceColor.a );
            gl_FragColor += vec4 (1.0*srcAmin,1.0*srcAmin,1.0*srcAmin ,v*3.0*srcAmin);
     

     
}