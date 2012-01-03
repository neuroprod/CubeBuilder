//
//  Slice9Sprite.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "Slice9Sprite.h"
void Slice9Sprite::setup()
{
    
    
    
}
void Slice9Sprite::setUVauto(int posX , int posY,int  uvSizeW,int uvSizeH)
{
    
    uvX  =(float)posX/uvSizeW;
    uvY =(float)posY/uvSizeH;
    uvWidth= (float)width/uvSizeW;
    uvHeight =(float)height/uvSizeH;
    isDirty =true;
    
}
void Slice9Sprite::setSize(int w , int h, int x,int  y  )
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
void Slice9Sprite::resetData()
{
    
    p1.x  =-width/2;
    p1.y  =-height/2 ;
    
    p2.x  =width/2;
    p2.y  =-height/2 ;
    
    p3.x  =-width/2;
    p3.y  =height/2;
    
    p4.x  =width/2 ;
    p4.y  =height/2;
    
   
    
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
    
    //linksTop
    
    
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
    
    
    
    data[12] = p1t.x ;
    data[13] = p1t.y+margin ;
    data[14] = p1t.z;
    data[15] = uvX ;
    data[16] = uvY +uvw1;
    data[17] = renderalpha;
    
    
    
    
    data[18] = p1t.x+margin ;
    data[19] = p1t.y+margin ;
    data[20] = p1t.z;
    data[21] =  uvX +uvw1; 
    data[22] = uvY +uvw1;
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
    data[1+36] =p1t.y+margin ;
    data[2+36] =p1t.z;
    data[3+36] = uvX+uvw1;
    data[4+36] = uvY+uvw1;
    data[5+36] = renderalpha;
    
    
    data[6+36] = p2t.x  -margin;
    data[7+36] = p2t.y +margin;
    data[8+36] = p2t.z;
    data[9+36] = uvX +uvWidth-uvw1;
    data[10+36] = uvY+uvHeight-uvw1;
    data[11+36] = renderalpha;
    
    
    
    data[12+36] = p3t.x+margin ;
    data[13+36] = p3t.y-margin ;
    data[14+36] = p3t.z;
    data[15+36] = uvX+uvw1;
    data[16+36] = uvY +uvHeight-uvw1;
    data[17+36] = renderalpha;
    
    
    
    
    data[18+36] = p4t.x-margin ;
    data[19+36] = p4t.y -margin;
    data[20+36] = p4t.z;
    data[21+36] =  uvX+uvWidth-uvw1;
    
    data[22+36] = uvY +uvHeight -uvw1;
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
    
    int pos = 36*2; 
    
    
    //right top
    
    
    data[0+pos] =p2t.x-margin ;
    data[1+pos] =p2t.y ;
    data[2+pos] =p2t.z;
    data[3+pos] = uvX+uvWidth- uvw1;
    data[4+pos] = uvY;
    data[5+pos] = renderalpha;
    
    
    data[6+pos] = p2t.x  ;
    data[7+pos] = p2t.y ;
    data[8+pos] = p2t.z;
    data[9+pos] = uvX +uvWidth;
    data[10+pos] = uvY;
    data[11+pos] = renderalpha;
    
    
    
    data[12+pos] = p2t.x-margin ;
    data[13+pos] = p2t.y+margin ;
    data[14+pos] = p2t.z;
    data[15+pos] = uvX +uvWidth-uvw1;
    data[16+pos] = uvY+uvw1;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p2t.x;
    data[19+pos] = p2t.y +margin;
    data[20+pos] = p2t.z;
    data[21+pos] =  uvX+uvWidth;
    
    data[22+pos] = uvY +uvw1;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos];

    
//top    
    pos+=36;
    
    data[0+pos] =p1t.x+margin;
    data[1+pos] =p1t.y ;
    data[2+pos] =p1t.z;
    data[3+pos] = uvX+uvw1;
    data[4+pos] = uvY;
    data[5+pos] = renderalpha;
    
    
    
    data[6+pos] =p2t.x-margin ;
    data[7+pos] =p2t.y ;
    data[8+pos] =p2t.z;
    data[9+pos] = uvX+uvWidth- uvw1;
    data[10+pos] = uvY;
    data[11+pos] = renderalpha;
    
    
    
    data[12+pos] = p1t.x +margin;
    data[13+pos] = p1t.y+margin ;
    data[14+pos] = p1t.z;
    data[15+pos] = uvX+uvw1 ;
    data[16+pos] = uvY +uvw1;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p2t.x-margin ;
    data[19+pos] = p2t.y+margin ;
    data[20+pos] = p2t.z;
    data[21+pos] = uvX +uvWidth-uvw1;
    data[22+pos] = uvY+uvw1;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos];
    
    //left    
    pos+=36;
    
    data[0+pos] =p1t.x;
    data[1+pos] =p1t.y+margin ;
    data[2+pos] =p1t.z;
    data[3+pos] = uvX;
    data[4+pos] = uvY+uvw1;
    data[5+pos] = renderalpha;
    
    
    
    data[6+pos] =p1t.x+margin ;
    data[7+pos] =p1t.y +margin;
    data[8+pos] =p2t.z;
    data[9+pos] = uvX+uvw1;
    data[10+pos] = uvY+uvw1;
    data[11+pos] = renderalpha;
    
    
    
    data[12+pos] = p3t.x;
    data[13+pos] = p3t.y-margin ;
    data[14+pos] = p1t.z;
    data[15+pos] = uvX ;
    data[16+pos] = uvY+uvHeight- uvw1 ;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p3t.x+margin ;
    data[19+pos] = p3t.y-margin ;
    data[20+pos] = p2t.z;
    data[21+pos] = uvX+uvw1 ;
    data[22+pos] = uvY+uvHeight- uvw1;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos]; 
    
    
    //left  bottme  
    pos+=36;
    
 
    data[0+pos] = p3t.x;
    data[1+pos] = p3t.y-margin ;
    data[2+pos] = p1t.z;
    data[3+pos] = uvX ;
    data[4+pos] = uvY+uvHeight- uvw1 ;
    data[5+pos] = renderalpha;
    
    
    
    
    data[6+pos] = p3t.x+margin ;
    data[7+pos] = p3t.y-margin ;
    data[8+pos] = p2t.z;
    data[9+pos] = uvX+uvw1 ;
    data[10+pos] = uvY+uvHeight- uvw1;
    data[11+pos] = renderalpha;
    

    
    
    
    data[12+pos] = p3t.x;
    data[13+pos] = p3t.y ;
    data[14+pos] = p1t.z;
    data[15+pos] = uvX ;
    data[16+pos] = uvY+uvHeight ;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p3t.x+margin ;
    data[19+pos] = p3t.y;
    data[20+pos] = p2t.z;
    data[21+pos] = uvX+uvw1 ;
    data[22+pos] = uvY+uvHeight;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos]; 
    
    
    
    
    //bottom
    pos+=36;
    
    
    data[0+pos] = p3t.x+margin ;
    data[1+pos] = p3t.y-margin ;
    data[2+pos] = p2t.z;
    data[3+pos] = uvX+uvw1 ;
    data[4+pos] = uvY+uvHeight- uvw1;
    data[5+pos] = renderalpha;
    
    
    
    
    data[6+pos] = p4t.x-margin ;
    data[7+pos] = p4t.y-margin ;
    data[8+pos] = p2t.z;
    data[9+pos] = uvX+uvWidth -uvw1 ;
    data[10+pos] = uvY+uvHeight- uvw1;
    data[11+pos] = renderalpha;
    
    
    
    
    
    data[12+pos] = p3t.x+margin ;
    data[13+pos] = p3t.y;
    data[14+pos] = p2t.z;
    data[15+pos] = uvX+uvw1 ;
    data[16+pos] = uvY+uvHeight;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p4t.x-margin ;
    data[19+pos] = p4t.y;
    data[20+pos] = p2t.z;
    data[21+pos] = uvX+uvHeight -uvw1 ;
    data[22+pos] = uvY+uvHeight;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos];
    
    
    //bottom right
    pos+=36;
    
    
    data[0+pos] = p4t.x-margin ;
    data[1+pos] = p4t.y-margin ;
    data[2+pos] = p2t.z;
    data[3+pos] = uvX+uvWidth -uvw1 ;
    data[4+pos] = uvY+uvHeight- uvw1;
    data[5+pos] = renderalpha;
    
    
    
    
    data[6+pos] = p4t.x ;
    data[7+pos] = p4t.y-margin ;
    data[8+pos] = p2t.z;
    data[9+pos] = uvX+uvWidth;
    data[10+pos] = uvY+uvHeight- uvw1;
    data[11+pos] = renderalpha;
    
    
    
    
    
    data[12+pos] = p4t.x-margin ;
    data[13+pos] = p4t.y;
    data[14+pos] = p2t.z;
    data[15+pos] = uvX+uvHeight -uvw1 ;
    data[16+pos] = uvY+uvHeight;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p4t.x;
    data[19+pos] = p4t.y;
    data[20+pos] = p2t.z;
    data[21+pos] = uvX+uvHeight ;
    data[22+pos] = uvY+uvHeight;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos];
    
    
    
    // right
    pos+=36;
    
    
    data[0+pos] = p2t.x-margin ;
    data[1+pos] = p2t.y+margin ;
    data[2+pos] = p2t.z;
    data[3+pos] = uvX +uvWidth-uvw1;
    data[4+pos] = uvY+uvw1;
    data[5+pos] = renderalpha;
    
    
    
    
    data[6+pos] = p2t.x;
    data[7+pos] = p2t.y +margin;
    data[8+pos] = p2t.z;
    data[9+pos] =  uvX+uvWidth;
    
    data[10+pos] = uvY +uvw1;
    data[11+pos] = renderalpha;
    
    
    
    
    
    data[12+pos] = p4t.x-margin ;
    data[13+pos] = p4t.y-margin ;
    data[14+pos] = p2t.z;
    data[15+pos] = uvX+uvWidth -uvw1 ;
    data[16+pos] = uvY+uvHeight- uvw1;
    data[17+pos] = renderalpha;
    
    
    
    
    data[18+pos] = p4t.x ;
    data[19+pos] = p4t.y-margin ;
    data[20+pos] = p2t.z;
    data[21+pos] = uvX+uvWidth;
    data[22+pos] = uvY+uvHeight- uvw1;
    data[23+pos] = renderalpha;
    
    
    data[24+pos] = data[12+pos];
    data[25+pos] = data[13+pos];
    data[26+pos] = data[14+pos];
    data[27+pos] = data[15+pos];
    data[28+pos] = data[16+pos];
    data[29+pos] = data[17+pos];
    
    
    data[30+pos] = data[6+pos];
    data[31+pos] = data[7+pos];
    data[32+pos] = data[8+pos];
    data[33+pos] = data[9+pos];
    data[34+pos] = data[10+pos];
    data[35+pos] = data[11+pos];

       
};

void  Slice9Sprite::getData( vector <float> &vec)
{
    
    if(!visible)return;
    if(renderalpha==0)return;
    //    int pos  = vec.size();
    ///set vector
    
    vec.insert (vec.end(), data,data+(36*9));
    
    for(int i=0; i<children.size();i++)
    {
        
        children[i]->getData(vec);
    }
    
    
}