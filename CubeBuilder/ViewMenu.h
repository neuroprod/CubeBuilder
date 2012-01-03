//
//  ViewMenu.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_ViewMenu_h
#define CubeBuilder_ViewMenu_h


#include "npDisplayObject.h"
#include "npBitmapSprite.h"
#include "npEvent.h"
#include "Slice3Sprite.h"
#include "npTweener.h"
#include "Model.h"
#include "TogleIcon.h"

class ViewMenu:public npDisplayObject
{
    public :
    bool isOpen;
    ViewMenu(){isSelected =false;};
    void setup( );
    void setSelected(bool sel , float delay=0);
   
    
    bool isSelected;
    
    Model *model;
    
    
    Slice3Sprite rollout;
   
    
    TogleIcon fit;
    
    npBitmapSprite line1;
    
    TogleIcon front;
    TogleIcon back;
    
    TogleIcon top;
    TogleIcon bottom;
    
    TogleIcon left;
    TogleIcon right;
    
    npBitmapSprite line2;
    
    TogleIcon snapShot;
    
    
    void onDownfit(npEvent *e);
    void onDownfront(npEvent *e);
    void onDownback(npEvent *e);
    void onDowntop(npEvent *e);
     void onDownbottom(npEvent *e);
    void onDownleft(npEvent *e);
    void onDownright(npEvent *e);
    
    void onSnapShot(npEvent *e);
    
    void setBottom(int bot);
    float bottomPos;
    float w;

};

#endif
