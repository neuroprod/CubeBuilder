//
//  ColorBtn.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_ColorBtn_h
#define CubeBuilder_ColorBtn_h

#include "npBitmapSprite.h"
#include "npDisplayObject.h"
#include "cbColor.h"
#include "Model.h"

class Model;
class ColorBtn :public npDisplayObject
{

public: 
    ColorBtn(){};
    void setup();
    void setColor(int colorID);
    void setColor(cbColor &col );
    npBitmapSprite select;
    npBitmapSprite color;
    Model *model;
    void setSelected(bool sel);
  
    void touchColor(npEvent *e);
    int colorID;
    bool isSelected;
};

#endif
