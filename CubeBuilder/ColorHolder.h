//
//  ColorHolder.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_ColorHolder_h
#define CubeBuilder_ColorHolder_h
#include "npBitmapSprite.h"
#include "ColorBtn.h"
#include "Model.h"

class Model;
class ColorBtn;
class ColorHolder:public npBitmapSprite

{
 vector < ColorBtn* > btns;

public:
   
    Model *model;
    ColorHolder(){};
    void setup();
    void setColor(int colorid);
   
   
};

#endif
