//
//  ZoomHolder.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "ZoomHolder.h"
void ZoomHolder::setup()
{

    setSize( 64, 64*4.5);
    setUVauto(64*7,64*4,STARTMAP_SIZE_W,STARTMAP_SIZE_H);



    model=Model::getInstance();

}
bool ZoomHolder::isTouching(npTouch &touch)
{
    
    if ( touchPointer ==&touch)
    {
    
        if( touch.phase==1)
        {
            float move =startY-(float)touch.y;
            model->camera->setZoomMove(move);
            //if (move >2) model->renderHit =true;
            startY =(float)touch.y;
        }
        if( touch.phase==2)
        {
            model->renderHit =true;
            touchPointer =NULL;
        }
    }

  
        if(p1t.x<touch.x  && p1t.y <touch.y && p4t.x>touch.x  && p4t.y >touch.y )
        {
            
           
                if( touch.phase==0)
                {
                
                    startY =(float)touch.y;
                    touchPointer =&touch;
                    touch.target =this;
                }
               
                     
            
            
            return true;
        }
   
  
    return false;
    
}