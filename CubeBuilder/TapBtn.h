//
//  TapBtn.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_TapBtn_h
#define CubeBuilder_TapBtn_h
#include "npBitmapSprite.h"


class TapBtn: public npBitmapSprite
{


public:
    TapBtn(){isSelected =false;}
    
    void setup(int iconID);
    void setSelected(bool sel );
    void onDown(npEvent *e);
    void onUp(npEvent *e);
    
    bool isSelected;

    npBitmapSprite icon;
    npBitmapSprite iconSel;
    
    npBitmapSprite over;


};

#endif
