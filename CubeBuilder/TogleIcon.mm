
//
//  TogleIcon.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "TogleIcon.h"
void TogleIcon::setup(int iconID)
{
    setSize( 64, 64);
    setUVauto(iconID*64,0,2048,2048);
   
    
    iconSel.setSize( 64, 64);
    iconSel.setUVauto(iconID*64,64,2048,2048);
    addChild(iconSel);
    iconSel.visible =false;


}
void TogleIcon::setSelected(bool sel )
{
    
    if (sel == isSelected)return;
    if (sel){ iconSel.visible =true;}
    else { iconSel.visible =false;}
    isDirty  =true;
    
    isSelected  =sel; 

}
void TogleIcon::onDown(npEvent *e)
{



}
void TogleIcon::onUp(npEvent *e)
{


}