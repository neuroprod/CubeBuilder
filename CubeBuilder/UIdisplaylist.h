//
//  UIdisplaylist.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 23/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_UIdisplaylist_h
#define CubeBuilder_UIdisplaylist_h

#include "ImageDataLoader.h"
#include "SettingsCubeBuilder.h"

#include "npDisplayList.h"
#include "npBitmapSprite.h"

#include "SelectIconBtn.h"
#include "Model.h"
#include "Slice3Sprite.h"
#include "ViewMenu.h"
#include "TapBtn.h"
#include "ZoomHolder.h"
#include "MenuMenu.h"
#include "ColorMenu.h"
#include "ColorHolder.h"

class UIdisplaylist: public npBitmapSprite
{


    
    
    Model *model;
    
    
    SelectIconBtn addBtn;
    SelectIconBtn removeBtn;
    SelectIconBtn paintBtn;
    SelectIconBtn rotateBtn;
    SelectIconBtn moveBtn;
    TapBtn viewBtn;
    
     TapBtn menuBtn;
     TapBtn redoBtn;
     TapBtn undoBtn;
    ZoomHolder zoomHolder;
    
    
    
    ViewMenu viewMenu;
    ColorMenu colorMenu;
    MenuMenu menuMenu;
    
    ColorHolder colorHolder;
public :
    UIdisplaylist(){};
    void setup();
    
    
    void setAdd(npEvent *e );
    void setRemove(npEvent *e );
    void setPaint(npEvent *e );
    void setRotate(npEvent *e );
    void setMove(npEvent *e );
    
     void setView(npEvent *e );
     void setMenu(npEvent *e );
    
    
    
    void closeCurrentState();
    
    
    void setOrientation(int orientation);
};



#endif
