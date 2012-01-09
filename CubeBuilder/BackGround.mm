//
//  BackGround.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "BackGround.h"
#include "ImageDataLoader.h"
#include "npProgramLoader.h"
enum {
    ATTRIB_VERTEX,
    ATTRIB_UV,
    NUM_ATTRIBUTES
};
void BackGround::setup()
{
    isDirty =true;
    
    ImageDataLoader IDloader;
    GLubyte *imagedata;
    
    
    imagedata = IDloader.loadFile(@"background.jpg");
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA , 1024,512, 0, GL_RGBA, GL_UNSIGNED_BYTE, imagedata);
    
    free(imagedata);
    
    
  
    
    
    glGenTextures(1, &flatTexture);
	glBindTexture(GL_TEXTURE_2D, flatTexture);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    int width =1024;
    int height =1024;
	
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);
    
    
    //glGenRenderbuffers(1, &rbuffer);
	//glBindRenderbuffer(GL_RENDERBUFFER, rbuffer);
	//glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
	
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, flatTexture, 0);
    
    GLint status =glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if(status ==GL_FRAMEBUFFER_COMPLETE)cout << "fbo back complete\n";


    
    npProgramLoader *pLoader = new npProgramLoader;
    program  =    pLoader->loadProgram ("ShaderFlat");
    
    
    
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    
    glBindAttribLocation(program, ATTRIB_UV, "uv");
    pLoader->linkProgram();
    delete pLoader;
    glUseProgram(program);
    
    
    uWorldMatrix= glGetUniformLocation(program, "worldMatrix");
    
    
    worldMatrix.makeOrtho2DMatrix(0,1024,768,0);
    glUseProgram(0);
    
    
    data = new float [36];
    
    
    

}
void BackGround::setColor(int BgID)
{
    if (bgID ==BgID) return;
    
    bgID =BgID;
    setOrientation(currentOrr);

}


void BackGround::renderTick()
{
    
    if (!isDirty)return;

   
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glViewport(0, 0, 1024, 1024);
  
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    glUseProgram(program);
    glUniformMatrix4fv(uWorldMatrix, 1, 0, worldMatrix.getPtr());
    
    
    GLfloat *pointer =data;
    
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    
    pointer +=3;
    glVertexAttribPointer(ATTRIB_UV, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_UV);
    
    
  
    
    glDrawArrays(GL_TRIANGLES, 0, 6);

    
    glUseProgram(0);
  
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    
    

}
void BackGround::setOrientation(int orientation)
{
    currentOrr =orientation;
    float  uvX ;
    float  uvY ;
    float uvHeight ;
    float uvWidth ;
    float  h;
    float  w;
    
    
    float  h2;
    float  w2;
    
    //384
    

   float ofz=0;
    if( bgID ==1)ofz = 0.377;
    
        w = 768;
        h = 1024;
        
        w2= 1024;
        h2 = 1024;
        
        uvX = ofz;
        uvY = 0;
        uvHeight =1;
        uvWidth =0.370;
        

    
   
    //landscape
    if ( orientation==1)
    {
         worldMatrix.makeOrtho2DMatrix(0-256,w2-256,h2,0); 
        worldMatrix.postMultRotate(90, 0, 0, 1);
      
    }
    //portrait
    if ( orientation ==0)
    {
              worldMatrix.makeOrtho2DMatrix(0,w2,h2,0);   
    }
   
    
    
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
    isDirty =true;
    
}

void BackGround::prepForFlatDraw()
{
   
    glBindTexture(GL_TEXTURE_2D, flatTexture);


    isDirty =false;

};