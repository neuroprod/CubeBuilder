//
//  TogleIcon.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_TogleIcon_h
#define CubeBuilder_TogleIcon_h
#include "npBitmapSprite.h"
#include "npEvent.h"

class TogleIcon: public npBitmapSprite
{
    
    
public:
    TogleIcon(){isSelected =false;}
    
    void setup(int iconID);
    void setSelected(bool sel );
    void onDown(npEvent *e);
    void onUp(npEvent *e);
    
    bool isSelected;
    
 
    npBitmapSprite iconSel;
    
   
    
    
};



#endif
