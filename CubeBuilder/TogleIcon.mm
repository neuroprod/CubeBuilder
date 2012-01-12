
//
//  TogleIcon.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "TogleIcon.h"
#include "SettingsCubeBuilder.h"
#include "Model.h"
void TogleIcon::setup(int iconID)
{
    setSize( 64, 64);
    setUVauto(iconID*64,0,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    touchChildren =false;
    
        
   
    
    
    iconSel.setSize( 64, 64);
    
    iconSel.touchEnabled =false;
    
    iconSel.setUVauto(iconID*64,64,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    addChild(iconSel);
    iconSel.visible =false;


}
void TogleIcon::setSelected(bool sel )
{
    
    if (sel == isSelected)return;
    if (sel){ iconSel.visible =true;}
    else { iconSel.visible =false;}
    isDirty  =true;
   if(sel) Model::getInstance()->playSound(SOUND_HIT_BTN);
    isSelected  =sel; 

}
void TogleIcon::onDown(npEvent *e)
{


 
}
void TogleIcon::onUp(npEvent *e)
{


}