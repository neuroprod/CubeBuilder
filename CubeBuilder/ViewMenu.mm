//
//  ViewMenu.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "ViewMenu.h"
void ViewMenu::setSelected(bool sel, float delay)
{
    isSelected =sel;
   
    if (!isSelected ) 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_IN_SINE,200,delay);
        
        mijnTween.addProperty( &y,bottomPos );
        npTweener::addTween(mijnTween);
        
       
       
    }else 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_OUT_BACK,400,delay);
        
        mijnTween.addProperty( &y,bottomPos-128 );
        npTweener::addTween(mijnTween);
    ;
    } 
    isDirty =true;
    
    
}

void ViewMenu::setBottom(int bot)
{

    bottomPos =bot;
    if (!isSelected ) 
    {
        y= bottomPos;
    }else 
    {
        y = bottomPos -128;
    } 
    isDirty =true;
    
}
void ViewMenu::setup()
{
  
    model =Model::getInstance();
      
    //over.alpha =0.0;
    // addChild(over);
 
    
    
    
    
    w =512;
    
    rollout.setSize( 64, 64,-32,-32);
    rollout.setUVauto(0,128,2048,2048);
    rollout.width =w;
    addChild(rollout);
    
    w-=32;
    
    
    


    int startX =32;
    int margin =64;
   fit.setSize( 64, 64);
    fit.setUVauto(8* 64,0,2048,2048);
    fit.x = startX;
    addChild(fit);
    makeCallBack(ViewMenu,onDownfit,callfit );
    fit.addEventListener(TOUCH_UP_INSIDE , callfit);
    startX+=margin+32;
    
    
    
   
    front.setSize( 64, 64);
    front.setUVauto(9* 64,0,2048,2048);
    front.x = startX;
    addChild(front);
    makeCallBack(ViewMenu,onDownfront,callfront );
    front.addEventListener(TOUCH_UP_INSIDE , callfront);
    startX+=margin;
    
  
    back.setSize( 64, 64);
     back.setUVauto(10* 64,0,2048,2048);
     back.x = startX;
    addChild( back);
    makeCallBack(ViewMenu,onDownback,callback);
    back.addEventListener(TOUCH_UP_INSIDE , callback);
    startX+=margin;
    
    
  
    top.setSize( 64, 64);
    top.setUVauto(11* 64,0,2048,2048);
    top.x = startX;
    addChild(top);
    makeCallBack(ViewMenu,onDowntop,calltop );
    top.addEventListener(TOUCH_UP_INSIDE , calltop);
    startX+=margin;
    
   
    bottom.setSize( 64, 64);
    bottom.setUVauto(12* 64,0,2048,2048);
    bottom.x = startX;
    addChild(bottom);
    makeCallBack(ViewMenu,onDownbottom,callbottom );
    bottom.addEventListener(TOUCH_UP_INSIDE , callbottom);
    startX+=margin;
    
    
   
    left.setSize( 64, 64);
    left.setUVauto(13* 64,0,2048,2048);
    left.x = startX;
    addChild(left);
    makeCallBack(ViewMenu,onDownleft,callleft);
    left.addEventListener(TOUCH_UP_INSIDE , callleft);
    startX+=margin;
    
    
  
    right.setSize( 64, 64);
    right.setUVauto(14* 64,0,2048,2048);
    right.x = startX;
    addChild(right);
    makeCallBack(ViewMenu,onDownright,callright);
    right.addEventListener(TOUCH_UP_INSIDE , callright);
   // startX+=margin;
    
      
}




void ViewMenu::onDownfit(npEvent *e)
{
    //setSelected(false);
    model->camera->fit();


}
void ViewMenu::onDownfront(npEvent *e){
    //setSelected(false);
    model->camera->setView(0);
    
    
}
void ViewMenu::onDownback(npEvent *e){
    //setSelected(false);
    model->camera->setView(1);
    
    
}
void ViewMenu::onDowntop(npEvent *e){
    //setSelected(false);
    model->camera->setView(2);
    
    
}
void ViewMenu::onDownbottom(npEvent *e){
    //setSelected(false);
    model->camera->setView(3);
    
    
}
void ViewMenu::onDownleft(npEvent *e){
    //setSelected(false);
    model->camera->setView(4);
    
    
}
void ViewMenu::onDownright(npEvent *e){
   // setSelected(false);
    model->camera->setView(5);
    
    
}








