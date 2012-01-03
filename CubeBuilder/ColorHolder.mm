//
//  ColorHolder.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "ColorHolder.h"


void ColorHolder::setup()
{
    model = Model::getInstance();

    setSize( 1, 1);
    setUVauto(0,0,2048,2048);

    int  posStartX =-11*22 +22;
    int posStartY =-7*22 +22-4;
    
    // 11*7
    int count =0;
    
    for (int i=0;i<7;i++)
    {
        int posY = i*44 +posStartY;
        for (int j=0;j<11;j++)
        {
              ColorBtn *btn =new ColorBtn();
            int posX = j*44 +posStartX;
            btn->setup();
            btn->x =posX;
            btn->y =posY;
            btn->setColor(model->colors[count]);
            
            addChild(*btn);
            count++;
            
            btns.push_back(btn);
        }
        
        
        
        
    }
   
  

}

void ColorHolder::setColor(int colorid)
{
    for (int i=0;i<btns.size();i++)
    {
        btns[i ]->setSelected(false);
    }
     btns[colorid ]->setSelected(true);
}