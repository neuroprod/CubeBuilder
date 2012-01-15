//
//  MenuMenu.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "MenuMenu.h"


void MenuMenu::setSelected(bool sel, float delay)
{
    isSelected =sel;
    
    if (!isSelected ) 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_IN_SINE,200,delay);
        
        mijnTween.addProperty( &y,-64 );
        
        makeCallBack(MenuMenu, hideComplete ,hideCall);
        mijnTween.addEventListener(NP_TWEEN_COMPLETE , hideCall );
        npTweener::addTween(mijnTween);
        
    }else 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_OUT_BACK,400,delay);
        
        mijnTween.addProperty( &y,64 );
        npTweener::addTween(mijnTween);
        visible =true;
        
    } 
    isDirty =true;
    
    
}
void MenuMenu::hideComplete(npEvent *e){
    
    visible =false;
}
void MenuMenu::setup()
{
    
    model =Model::getInstance();
    visible =false;
    //over.alpha =0.0;
    // addChild(over);
    
    
    
    
    
    w =512-64-36+16+64;
    
    rollout.setSize( 64, 64,-32,-32);
    rollout.setUVauto(0,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    rollout.width =w;
    addChild(rollout);
    
    w-=32;
    
    
    int startX =32-16+3;
    int margin =60;
    int marginS =40;
    
  
   

    
    save.setup(18);
    save.x = startX;
    addChild(save);
    makeCallBack(MenuMenu,onDownsave ,callsave );
    save.addEventListener(TOUCH_UP_INSIDE , callsave);
    startX+=margin-6;
    
    
    load.setup(19);
    load.x = startX;
    addChild(load);
    makeCallBack(MenuMenu,onDownload ,calload );
    load.addEventListener(TOUCH_UP_INSIDE , calload);
    
    startX+=margin-6;
    
    remove.setup(17);
    remove.x = startX;
    addChild(remove);
    makeCallBack(MenuMenu,onDownremove,callremove );
    remove.addEventListener(TOUCH_UP_INSIDE , callremove);
  
    
    
    startX+=marginS;
    
    line2.setSize(6, 64);
    line2.setUVauto(128,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    line2.x = startX;
    addChild( line2);
    
    startX+=marginS;
    
    galery.setup(20);
   galery.x = startX;
    addChild(galery);
    makeCallBack(MenuMenu,onDowngalery ,callgalery);
    galery.addEventListener(TOUCH_UP_INSIDE , callgalery);
    startX+=marginS;
    
    line1.setSize(6, 64);
    line1.setUVauto(128,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    line1.x = startX;
    addChild( line1);
    
    startX+=marginS;
    
    snapshot.setup(15);
    snapshot.x = startX;
    addChild( snapshot);
    makeCallBack(MenuMenu,onDownsnapshot ,callsnapshot);
    snapshot.addEventListener(TOUCH_UP_INSIDE , callsnapshot);
   
    
    startX+=marginS;
    
    line3.setSize(6, 64);
    line3.setUVauto(128,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    line3.x = startX;
    addChild( line3);
    
    startX+=marginS;
    

    
   info.setup(21);
    info.x = startX;
    addChild(info);
    makeCallBack(MenuMenu,onDowninfo  ,callinfo);
    info.addEventListener(TOUCH_UP_INSIDE , callinfo);
    
    startX+=marginS;
    
    line5.setSize(6, 64);
    line5.setUVauto(128,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    line5.x = startX;
    addChild( line5);
    
    startX+=marginS;
    
    
    
    sound.setup(24);
    sound.x = startX;
    addChild(sound);
    makeCallBack(MenuMenu,onDownSound  ,callsound);
    sound.addEventListener(TOUCH_UP_INSIDE , callsound);
    
    
       
    
}

void MenuMenu::onDownremove(npEvent *e){

    OverlayEvent event;
    event.name ="setOverlay";
    event.overlayType =10;
   
    dispatchEvent(event);
    
   

}
void MenuMenu::onDownsave(npEvent *e){
    OverlayEvent event;
    event.name ="setOverlay";
    event.overlayType =11;
    
    dispatchEvent(event);

}
void MenuMenu::onDownload(npEvent *e){

    OverlayEvent event;
    event.name ="setOverlay";
    event.overlayType =12;
    
    dispatchEvent(event);
}
void MenuMenu::onDowngalery(npEvent *e){

    OverlayEvent event;
    event.name ="setOverlay";
    event.overlayType =13;
    
    dispatchEvent(event);
}
void MenuMenu::onDownsnapshot(npEvent *e){

    OverlayEvent event;
    event.name ="setOverlay";
    event.overlayType =14;
    
    dispatchEvent(event);
}
void MenuMenu::onDowninfo(npEvent *e){

    OverlayEvent event;
    event.name ="setOverlay";
    event.overlayType =15;
    
    dispatchEvent(event);

}
void MenuMenu::onDownSound(npEvent *e){
    
    model->isSound =!model->isSound;
    sound.setSelected(model->isSound );
}

void MenuMenu::setOverlay(int currentOverLay)
{
    remove.setSelected(false);
    
    
    save.setSelected(false);
    
    
    load.setSelected(false);
    

    
    galery.setSelected(false);
   
    
    info.setSelected(false);
    
    if (currentOverLay==10)   remove.setSelected(true);
   else  if (currentOverLay==11)   save.setSelected(true);
     else  if (currentOverLay==12)   load.setSelected(true);
     else  if (currentOverLay==13)   galery.setSelected(true);
     else  if (currentOverLay==15)   info.setSelected(true);

}

