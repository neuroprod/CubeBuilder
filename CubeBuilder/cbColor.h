//
//  cbColor.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 26/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_cbColor_h
#define CubeBuilder_cbColor_h

class cbColor
{
    
    
    
    
    
public:
    float r;
    float g;
    float b;
    int colorID;
    
    float u;
    float v;
    
    cbColor(){};
    void set(float _r,float _g , float _b)
    {
    
        r =_r;
        g =_g;
        b =_b;
        
        
    }
    void setID(int id)
    {
    //65536
        int rint =floor  ((float)id/ 65025);
        int gint   =floor  ((float)(id-(rint *65025)    )/ 255);
        int bint   =id -(rint *65025) -(gint *255);
        
        r =(float) rint/255.0;
        g =(float) gint/255.0;
        b =(float) bint/255.0;
    }
    

    
    
    
};

#endif
