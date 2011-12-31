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
        npTweener::addTween(mijnTween);
        
        
        
    }else 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_OUT_BACK,400,delay);
        
        mijnTween.addProperty( &y,64 );
        npTweener::addTween(mijnTween);
        
    } 
    isDirty =true;
    
    
}

void MenuMenu::setup()
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
    
    
        
        
    
    
}





