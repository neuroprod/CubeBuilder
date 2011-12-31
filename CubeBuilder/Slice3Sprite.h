//
//  Slice3Sprite.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_Slice3Sprite_h
#define CubeBuilder_Slice3Sprite_h

#include "npDisplayObject.h"


// quick slice 3, just what i need for this project

class Slice3Sprite:public npDisplayObject
{
    
    
private:
    float uvX;
    float uvY;
    float uvWidth;
    float uvHeight;
    
    
    
    
    ofVec4f p1;
    ofVec4f p2;
    ofVec4f p3;
    ofVec4f p4;
    
    
    
    ofVec4f p1t;
    ofVec4f   p2t;
    ofVec4f p3t;
    ofVec4f p4t;
    
  

public: 
    Slice3Sprite(){};
 
    void setup();
    
    
    float width;
    float height;
    
    float data [108];
  //  virtual bool update(bool parentIsDirty );
    virtual void getData( vector <float> &vec );
    void resetData();
    void setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH);
    void  setSize(int w , int h, int x,int  y  );
    
};






#endif
