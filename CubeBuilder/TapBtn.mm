//
//  TapButton.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "TapBtn.h"



void TapBtn::setup(int iconID)
{
    touchChildren =false;
    
    setSize( 64, 64,-32,-32);
    setUVauto(0,128,2048,2048);
    
    
    over.setSize( 64, 64,-32,-32);
   over.setUVauto(64,128,2048,2048);
    over.visible =false;
    
    addChild(over); 
    
    
    icon.setSize( 64, 64);
    icon.setUVauto(iconID*64,0,2048,2048);
    addChild(icon );
   
    iconSel.setSize( 64, 64);
    iconSel.setUVauto(iconID*64,64,2048,2048);
    addChild(iconSel);
    iconSel.visible =false;
    
    isDirty =true;
    isSelected = false;
    
    makeCallBack(TapBtn,onDown,call );
    addEventListener(TOUCH_DOWN , call);
    
    makeCallBack( TapBtn,onUp,call2 );
    addEventListener(TOUCH_UP , call2);

}
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
    
    cout << "up" << isSelected;
    over.visible =false;
    over.isDirty =false;      
    isDirty =true;
    
}
