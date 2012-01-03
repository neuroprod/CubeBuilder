//
//  ColorMenu.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_ColorMenu_h
#define CubeBuilder_ColorMenu_h

#include "npDisplayObject.h"
#include "npBitmapSprite.h"
#include "npEvent.h"
#include "Slice3Sprite.h"
#include "npTweener.h"
#include "Model.h"
#include "ColorBtn.h"

#include "npEvent.h"
#include "OverlayEvent.h"
#include "TogleIcon.h"
class ColorBtn;
class ColorMenu:public npDisplayObject
{
    public :
    
    public :
    bool isOpen;
    ColorMenu(){isSelected =false;};
    void setup( );
    void setSelected(bool sel , float delay=0);
    void setColor(int colorid);
    
    bool isSelected;
    
    Model *model;
    
    
    Slice3Sprite rollout;
    
    
 
     vector < ColorBtn* > btns;
    
 TogleIcon openColorsBtn ;
    
    void setBottom(int bot);
    float bottomPos;
    float w;

    
    void onDownOverlay(npEvent *e);
        
 
    
    void setOverlay(int currentOverLay);
    
};



#endif
