//
//  SelectIconBtn.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_SelectIconBtn_h
#define CubeBuilder_SelectIconBtn_h

#include "npBitmapSprite.h"
#include "npEvent.h"
#include "Slice3Sprite.h"
class SelectIconBtn: public npBitmapSprite
{
    
    
public: 
    bool isSelected;
    SelectIconBtn(){};
    void setup(int type );
    void setSelected(bool sel );
    void onDown(npEvent *e);
    void onUp(npEvent *e );
    npBitmapSprite selected;
    npBitmapSprite unselected;
    Slice3Sprite rollover;
    Slice3Sprite rollout;
};




#endif
