//
//  npMovieClip.h
//  displaylist
//
//  Created by Kris Temmerman on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npMovieClip_h
#define displaylist_npMovieClip_h

#include "npBitmapSprite.h"

class npMovieClip:public npBitmapSprite
{
  float  uvXStart ;
    float uvYStart;
    float uvWidthStart;
    float uvHeightStart ;


public:
    npMovieClip(){};
    int frame;
    void setFrame(int _frame);
    virtual  void setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH);
    virtual void setUV(float u  , float v ,float  uSize,float vSize);    


};


#endif  
