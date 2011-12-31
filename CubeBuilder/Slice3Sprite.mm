//
//  Slice3Sprite.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 29/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "Slice3Sprite.h"

void Slice3Sprite::setup()
{



}
void Slice3Sprite::setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH)
{
    
    uvX  =(float)posX/uvSizeW;
    uvY =(float)posY/uvSizeH;
    uvWidth= (float)width/uvSizeW;
    uvHeight =(float)height/uvSizeH;
    isDirty =true;
    
}
void Slice3Sprite::setSize(int w , int h, int x,int  y  )
{
    width=w;
    height = h;
    
    p1.x  =x ;
    p1.y  =y ;
    
    p2.x  =x +w ;
    p2.y  =y ;
    
    p3.x  =x ;
    p3.y  =y +h;
    
    p4.x  =x +w ;
    p4.y  =y +h;
    
    
    
    isDirty =true;
    
}
void Slice3Sprite::resetData()
{
    
    
    
      p2.x  =x +width ;
      p4.x  =x +width ;
    
    if(uvWidth==0)uvWidth =0.1;
    if(uvHeight==0)uvHeight =0.1;
    globalMatrix  = localMatrix;
    if(parent )
    {
        renderalpha  =alpha*parent->renderalpha;
        globalMatrix*=parent->globalMatrix;
    }else
    {
        renderalpha  =alpha;
        
    }
   
    p1t = globalMatrix.preMult(p1);
    p2t = globalMatrix.preMult(p2);
    p3t = globalMatrix.preMult(p3);
    p4t = globalMatrix.preMult(p4);
    
    
    float margin = +21.3333 ;
    float uvw1 = uvWidth/3 ;
    
    
    
    //set data
    
    //links
    
    
    data[0] =p1t.x ;
    data[1] =p1t.y ;
    data[2] =p1t.z;
    data[3] = uvX;
    data[4] = uvY;
    data[5] = renderalpha;
    
    
    data[6] = p1t.x+margin  ;
    data[7] = p1t.y ;
    data[8] = p1t.z;
    data[9] = uvX +uvw1;
    data[10] = uvY;
    data[11] = renderalpha;
    
    
    
    data[12] = p3t.x ;
    data[13] = p3t.y ;
    data[14] = p3t.z;
    data[15] = uvX ;
    data[16] = uvY +uvHeight;
    data[17] = renderalpha;
    
    
    
    
    data[18] = p3t.x+margin ;
    data[19] = p3t.y ;
    data[20] = p3t.z;
    data[21] =  uvX +uvw1; 
    data[22] = uvY +uvHeight;
    data[23] = renderalpha;
    
    
    data[24] = data[12];
    data[25] = data[13];
    data[26] = data[14];
    data[27] = data[15];
    data[28] = data[16];
    data[29] = data[17];
    
    
    data[30] = data[6];
    data[31] = data[7];
    data[32] = data[8];
    data[33] = data[9];
    data[34] = data[10];
    data[35] = data[11];
    
    
    
    //center
    
    
    data[0+36] =p1t.x+margin ;
    data[1+36] =p1t.y ;
    data[2+36] =p1t.z;
    data[3+36] = uvX+uvw1;
    data[4+36] = uvY;
    data[5+36] = renderalpha;
    
    
    data[6+36] = p2t.x  -margin;
    data[7+36] = p2t.y ;
    data[8+36] = p2t.z;
    data[9+36] = uvX +uvw1*2;
    data[10+36] = uvY;
    data[11+36] = renderalpha;
    
    
    
    data[12+36] = p3t.x+margin ;
    data[13+36] = p3t.y+uvw1 ;
    data[14+36] = p3t.z;
    data[15+36] = uvX+uvw1;
    data[16+36] = uvY +uvHeight;
    data[17+36] = renderalpha;
    
    
    
    
    data[18+36] = p4t.x-margin ;
    data[19+36] = p4t.y ;
    data[20+36] = p4t.z;
    data[21+36] =  uvX +uvw1*2;

    data[22+36] = uvY +uvHeight;
    data[23+36] = renderalpha;
    
    
    data[24+36] = data[12+36];
    data[25+36] = data[13+36];
    data[26+36] = data[14+36];
    data[27+36] = data[15+36];
    data[28+36] = data[16+36];
    data[29+36] = data[17+36];
    
    
    data[30+36] = data[6+36];
    data[31+36] = data[7+36];
    data[32+36] = data[8+36];
    data[33+36] = data[9+36];
    data[34+36] = data[10+36];
    data[35+36] = data[11+36];

    
    
    //rechts
    
    
    data[0+72] =p4t.x -margin ;
    data[1+72] =p1t.y ;
    data[2+72] =p1t.z;
    data[3+72] = uvX+uvw1*2;

    data[4+72] = uvY;
    data[5+72] = renderalpha;
    
    
    data[6+72] = p2t.x  ;
    data[7+72] = p2t.y ;
    data[8+72] = p2t.z;
    data[9+72] = uvX +uvWidth;
    data[10+72] = uvY;
    data[11+72] = renderalpha;
    
    
    
    data[12+72] =p4t.x -margin ;
    data[13+72] = p3t.y ;
    data[14+72] = p3t.z;
    data[15+72] = uvX +uvw1*2;

    data[16+72] = uvY +uvHeight;
    data[17+72] = renderalpha;
    
    
    
    
    data[18+72] = p4t.x ;
    data[19+72] = p4t.y ;
    data[20+72] = p4t.z;
    data[21+72] =  uvX +uvWidth; 
    data[22+72] = uvY +uvHeight;
    data[23+72] = renderalpha;
    
    
    data[24+72] = data[12+72];
    data[25+72] = data[13+72];
    data[26+72] = data[14+72];
    data[27+72] = data[15+72];
    data[28+72] = data[16+72];
    data[29+72] = data[17+72];
    
    
    data[30+72] = data[6+72];
    data[31+72] = data[7+72];
    data[32+72] = data[8+72];
    data[33+72] = data[9+72];
    data[34+72] = data[10+72];
    data[35+72] = data[11+72];

    
    
};

void  Slice3Sprite::getData( vector <float> &vec)
{
    
    if(!visible)return;
    if(renderalpha==0)return;
    //    int pos  = vec.size();
    ///set vector
    
    vec.insert (vec.end(), data,data+(36*3));
    
    for(int i=0; i<children.size();i++)
    {
        
        children[i]->getData(vec);
    }
    
    
}