//
//  FlatRenderer.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "FlatRenderer.h"
#include "npProgramLoader.h"
enum {
    ATTRIB_VERTEX,
    ATTRIB_UV,
    NUM_ATTRIBUTES
};

void FlatRenderer::setup()
{
    npProgramLoader *pLoader = new npProgramLoader;
    program  =    pLoader->loadProgram ("ShaderFlat");
    


    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    
    glBindAttribLocation(program, ATTRIB_UV, "uv");
    pLoader->linkProgram();
    
    glUseProgram(program);
    
    
    uWorldMatrix= glGetUniformLocation(program, "worldMatrix");
    
    
     worldMatrix.makeOrtho2DMatrix(0,1024,768,0);
    glUseProgram(0);

    
    data = new float [36];
    

    float  uvX = 0;
      float  uvY = 1;
    float uvHeight =-1;
    float uvWidth =1;
    
    data[0] =0 ;
    data[1] =0 ;
    data[2] =0;
    data[3] = uvX;
    data[4] = uvY;
    data[5] = 1;
    
    
    data[6] = 1024 ;
    data[7] = 0 ;
    data[8] = 0;
    data[9] = uvX +uvWidth;
    data[10] = uvY;
    data[11] = 1;
    
    
    
    data[12] = 0 ;
    data[13] = 1024 ;
    data[14] = 0;
    data[15] = uvX ;
    data[16] = uvY +uvHeight;
    data[17] = 1;
    
    
    
    
    data[18] = 1024 ;
    data[19] = 1024 ;
    data[20] = 0;
    data[21] =  uvX +uvWidth; 
    data[22] = uvY +uvHeight;
    data[23] = 1;
    
    
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

}


void FlatRenderer::start(){

 // glViewport(0, 0, 1024, 768);
        OpenGLErrorChek::chek(22);
    glEnable (GL_BLEND); 
   

 
    
    glUseProgram(program);
    glUniformMatrix4fv(uWorldMatrix, 1, 0, worldMatrix.getPtr());
  
  
    GLfloat *pointer =data;
    
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    
    pointer +=3;
    glVertexAttribPointer(ATTRIB_UV, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_UV);
    
    
  
     //  OpenGLErrorChek::chek(11);
    

}

void   FlatRenderer::draw(){

   glDrawArrays(GL_TRIANGLES, 0, 6);

}

void   FlatRenderer::stop()
{

    glUseProgram(0);
    glDisable  (GL_BLEND); 
    
   
    glBindTexture(GL_TEXTURE_2D, 0);
    
 
}


void FlatRenderer::setOrientation(int orientation)
{

    float  uvX ;
    float  uvY ;
    float uvHeight ;
    float uvWidth ;
    float  h;
    float  w;
    
    
    float  h2;
    float  w2;
    
  
    
    //landscape
    if ( orientation==1)
    {
        
        w=1024.0f;
        h = 768.0f;
       
        w2= 1024;
        h2 = 768;
        
        uvX = 0;
        uvY = 0;
        uvHeight =h/w;
        uvWidth =1;
    }
    //portrait
    if ( orientation ==0)
    {
        w = 768;
        h = 1024;
        
        w2= 768;
        h2 = 1024;
        
        uvX = 0;
        uvY = 0;
        uvHeight =1;
        uvWidth =w/h;
        
    }
   worldMatrix.makeOrtho2DMatrix(0,w2,h2,0);
    
    
    data[0] =0 ;
    data[1] =0 ;
    data[2] =0;
    data[3] = uvX;
    data[4] =uvY;
    data[5] = 1;
    
    
    data[6] = w ;
    data[7] = 0 ;
    data[8] = 0;
    data[9] = uvX +uvWidth;
    data[10] =uvY;
    data[11] = 1;
    
    
    
    data[12] = 0 ;
    data[13] = h ;
    data[14] = 0;
    data[15] = uvX ;
    data[16] =  uvY +uvHeight;
    data[17] = 1;
    
    
    
    
    data[18] = w ;
    data[19] = h ;
    data[20] = 0;
    data[21] =  uvX +uvWidth; 
    data[22] = uvY +uvHeight;
    data[23] = 1;
    
    
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
    
}
