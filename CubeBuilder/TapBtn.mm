//
//  TapButton.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "TapBtn.h"
#include "SettingsCubeBuilder.h"


void TapBtn::setup(int iconID)
{
    isEnabled =true;
    touchChildren =false;
    
    setSize( 64, 64,-32,-32);
    setUVauto(0,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    
    
    over.setSize( 64, 64,-32,-32);
   over.setUVauto(64,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    over.visible =false;
    
    addChild(over); 
    
    
    icon.setSize( 64, 64);
    icon.setUVauto(iconID*64,0,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    addChild(icon );
   
    iconSel.setSize( 64, 64);
    iconSel.setUVauto(iconID*64,64,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    addChild(iconSel);
    iconSel.visible =false;
    
    isDirty =true;
    isSelected = false;
    
    makeCallBack(TapBtn,onDown,call );
    addEventListener(TOUCH_DOWN , call);
    
    makeCallBack( TapBtn,onUp,call2 );
    addEventListener(TOUCH_UP , call2);
  
    
}
void TapBtn::setEnabled(bool  en)
{
    if (en == isEnabled)return;
    
    
    
    isEnabled = en;
    if (isEnabled)
    {
    
        touchEnabled =true;
        iconSel.visible =false;
          icon.visible =true;
        isDirty =true;
    }else 
    {
        touchEnabled =false;
        iconSel.visible =true;
        icon.visible =false;
        isDirty = true;
    }

};

void TapBtn::setSelected(bool sel )
{
   
    if (sel)
    {
        iconSel.visible =true;
        iconSel.isDirty =true;
        icon.visible =false;
      
        over.visible =true;
        over.isDirty =true; 
    }else
    {
        
        over.visible =false;
        over.isDirty =true; 
        iconSel.visible =false;
        icon.visible =true;
    
    }
    isSelected =sel;
    isDirty =true;

}
void TapBtn::onDown(npEvent *e)
{
   if (isSelected) return;
   
    over.visible =true;
    over.isDirty =true;  
}

void TapBtn::onUp(npEvent *e )
{
    
  
     if (isSelected) return;
    
   
    over.visible =false;
    over.isDirty =false;      
    isDirty =true;
    
}
