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
    rollout.setUVauto(0,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    rollout.width =w;
    addChild(rollout);
    
    w-=32;
    
    
    


    int startX =10;
    int margin =60;
    int marginS =40;
    
       
    
    
 
    snapShot.setup(15);
    snapShot.x = startX;
    addChild(snapShot);
    makeCallBack(ViewMenu,onSnapShot,callsnap);
    snapShot.addEventListener(TOUCH_UP_INSIDE , callsnap);
    
       startX+=marginS;
    
    line2.setSize( 6, 64);
    line2.setUVauto(128,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    line2.x = startX;
    addChild( line2); 
    
       startX+=marginS;
    
    fit.setup(8);
    fit.x = startX;
    addChild(fit);
    makeCallBack(ViewMenu,onDownfit,callfit );
    fit.addEventListener(TOUCH_UP_INSIDE , callfit);
    startX+=marginS;
    
    line1.setSize(6, 64);
    line1.setUVauto(128,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    line1.x = startX;
    addChild( line1);
    
    startX+=marginS;
   
    front.setup(9);
    front.x = startX;
    addChild(front);
    makeCallBack(ViewMenu,onDownfront,callfront );
    front.addEventListener(TOUCH_UP_INSIDE , callfront);
    startX+=margin;
    
  
    back.setup(10);
     back.x = startX;
    addChild( back);
    makeCallBack(ViewMenu,onDownback,callback);
    back.addEventListener(TOUCH_UP_INSIDE , callback);
    startX+=margin;
    
    
  
    top.setup(11);
    top.x = startX;
    addChild(top);
    makeCallBack(ViewMenu,onDowntop,calltop );
    top.addEventListener(TOUCH_UP_INSIDE , calltop);
    startX+=margin;
    
   
    bottom.setup(12);
    bottom.x = startX;
    addChild(bottom);
    makeCallBack(ViewMenu,onDownbottom,callbottom );
    bottom.addEventListener(TOUCH_UP_INSIDE , callbottom);
    startX+=margin;
    
    
   
    left.setup(13);
    left.x = startX;
    addChild(left);
    makeCallBack(ViewMenu,onDownleft,callleft);
    left.addEventListener(TOUCH_UP_INSIDE , callleft);
    startX+=margin;
    
    
  
    right.setup(14);
    right.x = startX;
    addChild(right);
    makeCallBack(ViewMenu,onDownright,callright);
    right.addEventListener(TOUCH_UP_INSIDE , callright);
    startX+=marginS;

    
    
    
    
    
    
   // startX+=margin;
    
      
}




void ViewMenu::onDownfit(npEvent *e)
{
    //setSelected(false);
    model->camera->fit(false,1);
    model->camera->fit(false,2);
    model->camera->fit(false,3);
  
    model->camera->fit();
    fit.setSelected(false);


}
void ViewMenu::onDownfront(npEvent *e){
    //setSelected(false);
    model->camera->setView(0);
    clear();
    fit.setSelected(false);
    front.setSelected(false);

    
    
}
void ViewMenu::onDownback(npEvent *e){
    //setSelected(false);
    model->camera->setView(1);
    clear();
    fit.setSelected(false);
    back.setSelected(false);
    
}
void ViewMenu::onDowntop(npEvent *e){
    //setSelected(false);
    model->camera->setView(2);
    clear();
    fit.setSelected(false);
    top.setSelected(false);
    
}
void ViewMenu::onDownbottom(npEvent *e){
    //setSelected(false);
    model->camera->setView(3);
    clear();
    fit.setSelected(false);
    bottom.setSelected(false);
    
}
void ViewMenu::onDownleft(npEvent *e){
    //setSelected(false);
    model->camera->setView(4);
    clear();
    fit.setSelected(false);
    left.setSelected(false);
    
}
void ViewMenu::onDownright(npEvent *e){
   // setSelected(false);
    model->camera->setView(5);
    clear();
    fit.setSelected(false);
    right.setSelected(false);
    
}

void ViewMenu::onSnapShot(npEvent *e){

        cout <<"snapppp";
        OverlayEvent event;
        event.name ="setOverlay";
        event.overlayType =16;
        
        dispatchEvent(event);
   
   
    
}


void ViewMenu::clear()
{
  
    fit.setSelected(true);
    
  
    
   front.setSelected(true);
    back.setSelected(true);
    
    top.setSelected(true);
    bottom.setSelected(true);
    
    left.setSelected(true);
    right.setSelected(true);


}




