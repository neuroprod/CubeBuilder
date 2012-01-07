//
//  ColorBtn.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "ColorBtn.h"

void ColorBtn::setup()
{
    model =Model::getInstance();
    select.setSize(64-20, 64-20);
    select.setUVauto(10, 64*4+10,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    addChild(select);
    select.visible =false;
    color.setSize(32, 32);
    addChild(color);
    isSelected =false;
    select.touchEnabled =false;
    makeCallBack(ColorBtn,touchColor,touchColorC);
    color.addEventListener(TOUCH_UP_INSIDE , touchColorC );
    
    colorID =-1;
}
void ColorBtn::setColor(cbColor &col )
{
    if (colorID == col.colorID )return;
    
    color.setUVauto(col.u  , col.v  , STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    color.isDirty =true;
    colorID =col.colorID;
    
}
void ColorBtn::setColor(int colID )
{
    cbColor col= model->colors[colID];
    if (colorID == col.colorID )return;
    
    color.setUVauto(col.u  , col.v  , STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    color.isDirty =true;
    colorID =col.colorID;
    
}
void ColorBtn::setSelected(bool sel)
{
    if (sel == isSelected)return;
    if (sel )
    {
    
    select.visible =true;
    }
    else
    {
    select.visible =false;
    }
    isDirty =true;
    isSelected =sel;
}

void ColorBtn::touchColor(npEvent *e)
{
    model->setColor(colorID);
}