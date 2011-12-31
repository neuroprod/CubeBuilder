//
//  Cube.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_Cube_h
#define CubeBuilder_Cube_h
#include "SettingsCubeBuilder.h"
#include "cbColor.h"
#include "ofVec3f.h"

class Cube
{

    
    
public:
    Cube() {};
    ~Cube(){};
    
    
    
    
    void setup(int idex, int posx, int posy,int posz,cbColor color);
    void setCubeIndex(int index);
    void setCubeColor(cbColor color);
    
  
    ofVec3f pos;
   
    cbColor color;
    int cubeIndex;
    
    float    data[288];
    
    

};


#endif
