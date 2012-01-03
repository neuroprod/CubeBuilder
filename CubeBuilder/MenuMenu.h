//
//  MenuMenu.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_MenuMenu_h
#define CubeBuilder_MenuMenu_h

#include "npDisplayObject.h"
#include "npBitmapSprite.h"
#include "npEvent.h"
#include "Slice3Sprite.h"
#include "npTweener.h"
#include "Model.h"
#include "TogleIcon.h"
#include "OverlayEvent.h"



class MenuMenu:public npDisplayObject
{
    public :
    
   MenuMenu(){isSelected =false;};
    void setup( );
    void setSelected(bool sel, float delay =0 );
    
    
    bool isSelected;
    
    Model *model;
    
    
    Slice3Sprite rollout;
    
    
    float w;
    
    
    
    TogleIcon remove;
    
    npBitmapSprite line1;
    
    TogleIcon save ;
    TogleIcon load;

    
    npBitmapSprite line2;
    TogleIcon galery;
  
    
    npBitmapSprite line3;
    TogleIcon snapshot;
    
    npBitmapSprite line4;
    TogleIcon info;
    
    void onDowngalery(npEvent *e);
    void onDownremove(npEvent *e);
    void onDownsave(npEvent *e);
    void onDownload(npEvent *e);
    void onDownsnapshot(npEvent *e);
    void onDowninfo(npEvent *e);
    
    void setOverlay(int currentOverLay);
 
};



#endif
