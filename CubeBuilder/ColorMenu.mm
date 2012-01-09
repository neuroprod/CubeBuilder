//
//  ColorMenu.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#include "ColorMenu.h"
void ColorMenu::setSelected(bool sel, float delay)
{
    isSelected =sel;
    
    if (!isSelected ) 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_IN_SINE,200,delay);
        
        mijnTween.addProperty( &y,bottomPos );
        makeCallBack(ColorMenu, hideComplete ,hideCall);
        mijnTween.addEventListener(NP_TWEEN_COMPLETE , hideCall );
        
        npTweener::addTween(mijnTween);
        
        
        
        
    }else 
    {
        npTween mijnTween;
        mijnTween.init(this,NP_EASE_OUT_BACK,400,delay);
        
        mijnTween.addProperty( &y,bottomPos-128 );
        npTweener::addTween(mijnTween);
        visible =true;
     
    } 
    isDirty =true;
    
    
}
void ColorMenu::hideComplete(npEvent *e){
    
    visible =false;
}
void ColorMenu::setBottom(int bot)
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
void ColorMenu::setup()
{
    visible =false;
    model =Model::getInstance();
    
    //over.alpha =0.0;
    // addChild(over);
    
    
    
    
    
    w =512;
    
    rollout.setSize( 64, 64,-32,-32);
    rollout.setUVauto(0,128,STARTMAP_SIZE_W,STARTMAP_SIZE_H);
    rollout.width =w;
    addChild(rollout);
    
    w-=32;
    
    
    
    int count =0;
    
    int posStartX =5;
    for (int j=0;j<10;j++)
    {
        ColorBtn *btn =new ColorBtn();
        int posX = j*44 +posStartX;
        btn->setup();
        btn->x =posX;
        
        btn->setColor(model->colors[count]);
        
        addChild(*btn);
        count++;
        
        btns.push_back(btn);
    }
    btns[0]->setSelected(true);
    
   // int startX =32;
    //int margin =64;
        
    btns[0]->setColor(36);
    btns[1]->setColor(38);
    btns[2]->setColor(39);
    btns[3]->setColor(41);
    btns[4]->setColor(42);
    btns[5]->setColor(65);
    btns[6]->setColor(66);
    btns[7]->setColor(33);
    btns[8]->setColor(0);
    btns[9]->setColor(69);
  //  btns[9]->setColor(69);
    
    
    openColorsBtn.setup(23);
     openColorsBtn.x = 464;
    addChild( openColorsBtn);
    makeCallBack(ColorMenu,onDownOverlay ,callinfo);
     openColorsBtn.addEventListener(TOUCH_UP_INSIDE , callinfo);
}

void ColorMenu::setColor(int colorid)
{
    bool exist =false;
    int index =-1;
    
    for (int i=0;i<btns.size();i++)
    {
       // cout << "btns["<<i<<"]->setColor("<<btns[i ]->colorID <<");\n"; // lazy :p
        btns[i ]->setSelected(false);
        if (btns[i ]->colorID == colorid)  {  
            exist =true; 
            index =i;
          
        }
    }
    if (exist)
    {
       
        btns[index ]->setSelected(true);
        return;
    
    }
    
    int prevID = btns[0 ]->colorID;
    for (int i=1;i<btns.size();i++)
    {
        int temp =btns[i ]->colorID;
        
        btns[i ]->setColor(model->colors[prevID]);
        prevID =temp;
    }
    
    
    btns[0 ]->setColor(model->colors[colorid]);
    
    btns[0 ]->setSelected(true);
    
    
}
void ColorMenu::resetColors()
{
    btns[0]->setColor(36);
    btns[1]->setColor(38);
    btns[2]->setColor(39);
    btns[3]->setColor(41);
    btns[4]->setColor(42);
    btns[5]->setColor(65);
    btns[6]->setColor(66);
    btns[7]->setColor(33);
    btns[8]->setColor(0);
    btns[9]->setColor(69);

}
void ColorMenu::onDownOverlay(npEvent *e){
    
    OverlayEvent event;
    event.name ="setOverlay";
    
    
    event.overlayType =1;
    if (openColorsBtn.isSelected) event.overlayType =-1;
    dispatchEvent(event);
    
}

void ColorMenu::setOverlay(int currentOverLay)
{
    if(currentOverLay ==1) {openColorsBtn.setSelected(true);}
    else{openColorsBtn.setSelected(false);}
    
}
