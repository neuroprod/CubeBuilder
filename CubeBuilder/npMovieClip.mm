//
//  npMovieClip.cpp
//  displaylist
//
//  Created by Kris Temmerman on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npMovieClip.h"

void npMovieClip::setFrame(int _frame)
{
    if( _frame== frame) return;
    uvX  =uvXStart +((float )_frame*  uvWidth);
    cout << " xstart::  "<<uvXStart;
    frame =_frame;
      
    isDirty =true;




}
void  npMovieClip::setUV(float u  , float v ,float  uSize,float vSize)
{
    frame = 0;
cout << "setUV";
    uvX  =u ;
    uvY =v;
    uvWidth= uSize;
    uvHeight =vSize;
    
    uvXStart  =u ;
   
    
    
    isDirty =true;




}
void npMovieClip::setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH)
{
    
    uvX  =(float)posX/uvSizeW;
    uvY =(float)posY/uvSizeH;
    uvWidth= (float)width/uvSizeW;
    uvHeight =(float)height/uvSizeH;
    isDirty =true;
      uvXStart =   uvX  ;
}