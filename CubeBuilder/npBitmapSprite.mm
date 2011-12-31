//
//  npBitmapSprite.cpp
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npBitmapSprite.h"

bool  npBitmapSprite::update(bool parentIsDirty =false)
{
    
   return  npDisplayObject::update( parentIsDirty);
    


}
void  npBitmapSprite::getData( vector <float> &vec)
{
 
  if(!visible)return;
    if(renderalpha==0)return;
//    int pos  = vec.size();
    ///set vector
   
     vec.insert (vec.end(), data,data+36);
   
    for(int i=0; i<children.size();i++)
    {
    
        children[i]->getData(vec);
    }


}
void npBitmapSprite::setSize(int w   , int h)
{

    setSize( w ,  h,-w/2,-h/2);
    width=w;
    height = h;
}
void npBitmapSprite::setSize(int w , int h, int align)
{
 
    
    switch(align)
    {
        case NP_ALIGN_CENTER:
        {
            setSize( w ,  h,-w/2,-h/2);
            break;
        }
    
        case NP_ALIGN_TOPLEFT:
        {
            setSize( w ,  h,0,0);
            break;
        }
        case NP_ALIGN_BOTTEM:
        {
            setSize( w ,  h,-w/2,-h);
            break;
        }
        case NP_ALIGN_TOP:
        {
            setSize( w ,  h,-w/2,0);
            break;
        }
        case NP_ALIGN_TOPRIGHT:
        {
            setSize( w ,  h,-w,0);
            break;
        }
        case NP_ALIGN_BOTTEMLEFT:
        {
            setSize( w ,  h,0,-h);
            break;
        }
        case NP_ALIGN_BOTTEMRIGHT:
        {
            setSize( w ,  h,-w,-h);
            break;
        }
        default : 
        {
        cout << "\n*************\nNOT IMPLEMETEND ALIGN , PLEASE DOO IT!!!!! \n*****************\n";
        }
    }
    /*
    #define NP_ALIGN_CENTER
#define NP_ALIGN_TOP "npALignTop"
#define NP_ALIGN_LEFT "npALignLeft"
#define NP_ALIGN_BOTTEM "npALignBottem"
#define NP_ALIGN_RIGHT "npALignRight"
    
    
#define NP_ALIGN_TOPLEFT "npALignTop"
#define NP_ALIGN_TOPRIGHT "npALignTopRight"
#define NP_ALIGN_BOTTEMLEFT "npALignBottemLeft"
#define NP_ALIGN_BOTTEMRIGHT "npALignBottemRight"
    */

}
void npBitmapSprite::setSize(int w , int h, int x,int  y  )
{
    width=w;
    height = h;
    
    p1.x  =x ;
    p1.y  =y ;
    
    p2.x  =x +w ;
    p2.y  =y ;
    
    p3.x  =x ;
    p3.y  =y +h;
    
    p4.x  =x +w ;
    p4.y  =y +h;

   
    
    isDirty =true;
    
}

void npBitmapSprite::setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH)
{
  
    uvX  =(float)posX/uvSizeW;
    uvY =(float)posY/uvSizeH;
    uvWidth= (float)width/uvSizeW;
    uvHeight =(float)height/uvSizeH;
    isDirty =true;

}
void npBitmapSprite::setUV(float u  , float v ,float  uSize,float vSize)
{
    
    uvX  =u ;
    uvY =v;
    uvWidth= uSize;
    uvHeight =vSize;
    isDirty =true;
    
}

void npBitmapSprite::resetData()
{
    if(uvWidth==0)uvWidth =0.1;
     if(uvHeight==0)uvHeight =0.1;
      globalMatrix  = localMatrix;
    if(parent )
    {
       renderalpha  =alpha*parent->renderalpha;
        globalMatrix*=parent->globalMatrix;
    }else
    {
        renderalpha  =alpha;
    
    }
    
 p1t = globalMatrix.preMult(p1);
    p2t = globalMatrix.preMult(p2);
    p3t = globalMatrix.preMult(p3);
     p4t = globalMatrix.preMult(p4);
  
    
     //set data
   
 
    
    
    data[0] =p1t.x ;
   data[1] =p1t.y ;
   data[2] =p1t.z;
   data[3] = uvX;
   data[4] = uvY;
   data[5] = renderalpha;
    
    
   data[6] = p2t.x  ;
   data[7] = p2t.y ;
   data[8] = p2t.z;
   data[9] = uvX +uvWidth;
   data[10] = uvY;
   data[11] = renderalpha;
    
    
    
   data[12] = p3t.x ;
   data[13] = p3t.y ;
   data[14] = p3t.z;
   data[15] = uvX ;
   data[16] = uvY +uvHeight;
   data[17] = renderalpha;
    
    
    
    
   data[18] = p4t.x ;
   data[19] = p4t.y ;
   data[20] = p4t.z;
   data[21] =  uvX +uvWidth; 
   data[22] = uvY +uvHeight;
   data[23] = renderalpha;
    
    
   data[24] = data[12];
   data[25] = data[13];
   data[26] = data[14];
   data[27] = data[15];
   data[28] = data[16];
   data[29] = data[17];
    
    
   data[30] = data[6];
   data[31] = data[7];
   data[32] = data[8];
   data[33] = data[9];
   data[34] = data[10];
   data[35] = data[11];
    
    
};

bool npBitmapSprite::isTouching(npTouch &touch)
{
  
    if(rotation ==0 && z==0)
    {        
        if(p1t.x<touch.x  && p1t.y <touch.y && p4t.x>touch.x  && p4t.y >touch.y )
        {
            if(hasEventListeners)
            {
                if(touch.phase   ==NP_TOUCH_START ) 
                {
                    npTouchEvent event;
                    event.name  =TOUCH_DOWN ;
                    event.target  =this;
                    dispatchEvent(event);
                    touch.target =this;
                }
            
            
            }
            return true;
        }
    }
    else
    {
        cout << "\nIMPLEMENT ROTATION TOUCH  \n";
    
    }
    return false;

}