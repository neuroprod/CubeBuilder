//
//  ZoomHolder.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_ZoomHolder_h
#define CubeBuilder_ZoomHolder_h


#include "npBitmapSprite.h"
#include "Model.h"


class ZoomHolder: public npBitmapSprite
{
    
private:
    virtual bool isTouching(npTouch &touch);
    Model * model;
public:
    ZoomHolder(){touchPointer =NULL;};
    void setup();
    npTouch * touchPointer;
    float startY;
    
};


#endif
