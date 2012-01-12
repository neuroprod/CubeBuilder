//
//  SelectIconBtn.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "SelectIconBtn.h"
#include "SettingsCubeBuilder.h"
#include "npTweener.h"
#include "Model.h"
void SelectIconBtn::setSelected(bool sel )
{
    if(sel ) {
        selected.visible =true;
        
    
        
          rollover.visible =true;
        
        unselected.visible =false;
    }else
    {
        selected.visible =false ;
        unselected.visible =true;
        rollover.visible =false;
    }
    isDirty =true;
    isSelected =sel;
    
}
void SelectIconBtn::setup(int type)
{
    touchChildren = false;
    touchEnabled =true;
   setSize( 64, 64);
    setUVauto(1000,1000,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    //over.setUVauto(1836,0,2048,2048);
    
    
    //over.alpha =0.0;
    // addChild(over);
    makeCallBack(SelectIconBtn,onDown,call );
    addEventListener(TOUCH_DOWN , call);
    
    makeCallBack( SelectIconBtn,onUp,call2 );
    addEventListener(TOUCH_UP , call2);
        
   
    
    
   
  
    
    rollout.setSize( 64, 64,-32,-32);
    rollout.setUVauto(0,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    rollout.width =32;
    addChild(rollout);

    rollover.setSize( 64, 64,-32,-32);
    rollover.setUVauto(64,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
   rollover.visible =false;
      rollover.width =32;
    rollover.isDirty =true;
    addChild(rollover); 
    
    
    unselected.setSize( 64, 64);
    unselected.setUVauto(type*64,0,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    addChild(unselected);
    selected.setSize( 64, 64);
    
    selected.setUVauto(type*64,64,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    addChild(selected);
    selected.visible =false;
      
    isDirty =true;
    isSelected = false;
            
}
void SelectIconBtn::onDown(npEvent *e)
{
   
    if (!isSelected) 
    {
        npEvent e;
        e.name ="setState";
        dispatchEvent(e);
    }
    rollover.alpha =1;
    rollover.visible =true;
    selected.visible =true;
    unselected.visible =false;
    
    rollover.isDirty =true;
    npTween mijnTween;
    mijnTween.init(&rollover,NP_EASE_OUT_EXPO,300,0);
     
    mijnTween.addProperty( &rollover.width,64+32 );
    npTweener::addTween(mijnTween);
     
     
    npTween mijnTween2;
    mijnTween2.init(&selected,NP_EASE_OUT_EXPO,300,0);
    
    mijnTween2.addProperty( &selected.x,64-8);
    npTweener::addTween(mijnTween2);
    Model::getInstance()->playSound(SOUND_HIT_BTN);
}

void SelectIconBtn::onUp(npEvent *e )
{
   

   // if (isSelected) return;
    
    npTween mijnTween;
    mijnTween.init(&rollover,NP_EASE_OUT_EXPO,200,0);
  //   mijnTween.addProperty(&rollover.alpha,0 );
    mijnTween.addProperty(&rollover.width,32 );
    npTweener::addTween(mijnTween);

    rollout.width  =rollover.width;
    
    npTween mijnTween3;
    mijnTween3.init(&rollout,NP_EASE_OUT_EXPO,200,0);
    mijnTween3.addProperty(&rollout.width,32 );
    npTweener::addTween(mijnTween3);
    
    
    
    
    
    npTween mijnTween2;
    mijnTween2.init(&selected,NP_EASE_OUT_EXPO,200,0);
    
    mijnTween2.addProperty( &selected.x,0);
    npTweener::addTween(mijnTween2);
    
    
    
}