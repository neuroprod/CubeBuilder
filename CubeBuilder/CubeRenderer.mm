//
//  CubeRenderer.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "CubeRenderer.h"

// 65535/36 = max 1800
// 518400  

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

enum {
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    ATTRIB_COLOR,
    ATTRIB_ID,
    NUM_ATTRIBUTES
};

enum {
    ATTRIB_VERTEX_BLUR,
    ATTRIB_UV_BLUR
   
};


void CubeRenderer::setup(){
    
    model = Model::getInstance();
    
    
    glGenTextures(1, &flatTexture);
	glBindTexture(GL_TEXTURE_2D, flatTexture);
	
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    int width =1024;
    int height =1024;
	
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
   
    glGenRenderbuffers(1, &rbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, rbuffer);
	//glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
	
	glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, flatTexture, 0);
    
    GLint status =glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if(status ==GL_FRAMEBUFFER_COMPLETE)cout << "fbo interface complete\n";

    
  
    
    
    glGenFramebuffers(1, &sampleFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
    
    
    
    glGenRenderbuffers(1, &sampleColorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, sampleColorRenderbuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, width,height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,sampleColorRenderbuffer);
    glGenRenderbuffers(1, &sampleDepthRenderbuffer); 
    glBindRenderbuffer(GL_RENDERBUFFER, sampleDepthRenderbuffer); 
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT16,width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,sampleDepthRenderbuffer);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    cout <<"Failed to make complete framebuffer object "<<glCheckFramebufferStatus(GL_FRAMEBUFFER)<< "\n";
    
    
    
    vertexData= new GLfloat[720000];

    
    for (int i=0; i <720000;i++) 
    {
        vertexData[i ] =0;
    } 
        
  //  65535/24 =2500 cubus
    
    indexData =new GLushort[90000];
    
    int count =0;
    for (int i=0; count<90000; i+=4) 
    {
        indexData[count] =i;
        count++;
        
  
        indexData[count] =i+3;
        count++;
        
        indexData[count] =i+1;
        count++;
        
        
        indexData[count] =i;
        count++;
        
    
        
        indexData[count] =i+2;
        count++;
        
        indexData[count] =i+3;
        count++;
    }
  
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*720000,vertexData, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1,&indexBuffer  );
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*90000,indexData, GL_STATIC_DRAW);

    
   /*glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    */
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    npProgramLoader *pLoader = new npProgramLoader;
    programMain  =    pLoader->loadProgram ("ShaderCubeMain");
    
    
    
    glBindAttribLocation(programMain, ATTRIB_VERTEX, "position");
    glBindAttribLocation(programMain, ATTRIB_NORMAL, "normal");
    glBindAttribLocation(programMain, ATTRIB_COLOR, "color");
    pLoader->linkProgram();
    
    glUseProgram(programMain);
   
    
    
    uWorldMatrixMain= glGetUniformLocation(programMain, "worldMatrix");
    uNormalMatrixMain= glGetUniformLocation(programMain, "normalMatrix");
    uPerspectiveMatrixMain= glGetUniformLocation(programMain, "perspectiveMatrix");

    
    //GLint uWorldMatrixMain;
   // GLint uNormalMatrixMain;
    //GLint uPerspectiveMatrixMain;
    
    glUseProgram(0);
    setupIDCubes();
    
    useAO=false;
    setupAO();
    
};

void CubeRenderer::update()

{
    

    
 
    

};

void CubeRenderer::renderTick(){

    if(!cubeHandler->isDirty && !isDirty )return;
    isDirty =true;
    cubeHandler->isDirty =false;
    cout << "\ndrawCubes\n";
     glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
    
  // glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    
    glViewport(0,vpY, vpW, vpH);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
  glEnable (GL_DEPTH_TEST);
    
    if (previewCube->x != 10000) {previewCube->draw();
    
    
    }else 
    {
        previewCube->isDirty =false;
    }
    
    
    
    
    glUseProgram(programMain);
    
   
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
   

    
    glUniformMatrix4fv(uWorldMatrixMain, 1,0, camera->worldMatrix.getPtr());
    glUniformMatrix4fv(uNormalMatrixMain, 1, 0, camera->normalMatrix.getPtr());
    glUniformMatrix4fv(uPerspectiveMatrixMain, 1, 0, camera->perspectiveMatrix.getPtr());
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12,(GLvoid*) (sizeof(float) * 0));
    glEnableVertexAttribArray(ATTRIB_NORMAL);
    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12, (GLvoid*) (sizeof(float) * 3));
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12, (GLvoid*) (sizeof(float) * 6));
   
   
   
   
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexBuffer);   
    glDrawElements(GL_TRIANGLES, 36* cubeHandler->cubes.size(), GL_UNSIGNED_SHORT, (void*)0);
    
    
    
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, fbo);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, sampleFramebuffer);
    glResolveMultisampleFramebufferAPPLE();
    
    
    //clean
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
    glDisableVertexAttribArray(ATTRIB_VERTEX);
    glDisableVertexAttribArray(ATTRIB_NORMAL);
    glDisableVertexAttribArray(ATTRIB_COLOR);
    glDisable (GL_DEPTH_TEST);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    if (useAO) renderAO();

};
void CubeRenderer::prepForFlatDraw(){
    
    glBindTexture(GL_TEXTURE_2D, flatTexture);
    isDirty =false ;

};

void CubeRenderer::setupIDCubes()
{
    npProgramLoader *pLoader = new npProgramLoader;
    programID  =    pLoader->loadProgram ("ShaderCubeID");
    
    
    
    glBindAttribLocation(programID, ATTRIB_VERTEX, "position");
    glBindAttribLocation(programID, ATTRIB_NORMAL, "color");
    
    pLoader->linkProgram();

    glUseProgram(programID);
    
    
    
    uWorldMatrixID= glGetUniformLocation(programID, "worldMatrix");
    uPerspectiveMatrixID= glGetUniformLocation(programID, "perspectiveMatrix");
    

    
    glUseProgram(0);

    
    pixels =new GLubyte[1024* 768*4];

}
void CubeRenderer::drawIDcubes()
{
    
  cout << "drawID";
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    
  // glDisable(GL_BLEND);

    glUseProgram(programID);
    
    glEnable (GL_DEPTH_TEST);
    
    
    
    
    
    glUniformMatrix4fv(uWorldMatrixID, 1,0, camera->worldMatrix.getPtr());
   
    glUniformMatrix4fv(uPerspectiveMatrixID, 1, 0, camera->perspectiveMatrix.getPtr());
     
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
     
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12,(GLvoid*) (sizeof(float) * 0));

    
    glEnableVertexAttribArray(ATTRIB_NORMAL);
    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12, (GLvoid*) (sizeof(float) * 9));
    
    
    
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexBuffer);   
    glDrawElements(GL_TRIANGLES, 36* cubeHandler->cubes.size(), GL_UNSIGNED_SHORT, (void*)0);
    
   
    glDisableVertexAttribArray(ATTRIB_VERTEX);
    glDisableVertexAttribArray(ATTRIB_NORMAL);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
    glUseProgram(0);
    glDisable (GL_DEPTH_TEST);
   // glEnable(GL_BLEND);


    glReadPixels(0, 0,  vpW,vpH, GL_RGBA,GL_UNSIGNED_BYTE, pixels);
    
    model->renderHit =false;
   // cout << "redraw id cubes\n";
    //OpenGLErrorChek::chek("id cubes");    
}
bool CubeRenderer::getPoint(int x, int y )
{
    ofVec4f vec;
    int pos =(        x +((vpH-y)*vpW ))*4;
    
    int a = (int)pixels[pos+3];
    if (a ==0) return false;
    
    
    currentCubeSide  = (int)pixels[pos];
    
    int g = (int)pixels[pos+1];
    int b = (int)pixels[pos+2];
    currentCubeIndex = g*256 +b;
    

    return true;
    
}

void CubeRenderer::setOrientation(int orientation)
{
    isDirty =true;
    cubeHandler->isDirty =true;
    if (orientation ==1)
    {
        vpW = 1024;
        vpH = 768;
        vpY = 1024-768;
    }
    else
    {
        vpW = 768;
        vpH = 1024;
        vpY = 0;
    }
    
    camera->setOrientation(orientation);
    
   
    if (!useAO)return;
    
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
 
    
    
    worldMatrixBlur.makeOrtho2DMatrix(0,w2,h2,0);
    
    
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







//
//
//
//


void CubeRenderer::setupAO()
{
//// depth
    
    glGenTextures(1, &textureDepth);
	glBindTexture(GL_TEXTURE_2D, textureDepth);
	
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    int width =1024;
    int height =1024;
	
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
    glGenRenderbuffers(1, &rbufferDepth);
	glBindRenderbuffer(GL_RENDERBUFFER, rbufferDepth);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
	
	glGenFramebuffers(1, &fboDepth);
	glBindFramebuffer(GL_FRAMEBUFFER, fboDepth);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureDepth, 0);
    
    npProgramLoader *pLoader = new npProgramLoader;
    programDepth =    pLoader->loadProgram ("ShaderCubeDepth");
    
    
    glBindAttribLocation(programDepth, ATTRIB_VERTEX, "position");
  
    pLoader->linkProgram();
    
    glUseProgram(programDepth);
    
    uWorldMatrixID= glGetUniformLocation(programDepth, "worldMatrix");
    uPerspectiveMatrixID= glGetUniformLocation(programDepth, "perspectiveMatrix");
    
    
    glUseProgram(0);
    
    
    //// blur
	int width2=1024;
    int height2=1024;    
    glGenTextures(1, &textureBlur);
	glBindTexture(GL_TEXTURE_2D, textureBlur);
	
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_LINEAR);
    
 

	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,width2, height2, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
    glGenRenderbuffers(1, &rbufferBlur);
	glBindRenderbuffer(GL_RENDERBUFFER, rbufferBlur);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width2, height2);
 
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,rbufferBlur);
	
	glGenFramebuffers(1, &fboBlur);
	glBindFramebuffer(GL_FRAMEBUFFER, fboBlur);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureBlur, 0);
    
    
    
    
    npProgramLoader *pLoaderBlur = new npProgramLoader;
    programBlur =    pLoaderBlur->loadProgram ("ShaderBlur1");
    
    
    
    glBindAttribLocation(programBlur, ATTRIB_VERTEX_BLUR, "position");
    
    glBindAttribLocation(programBlur, ATTRIB_UV_BLUR, "uv");
    pLoaderBlur->linkProgram();
    
    glUseProgram(programBlur);
    
    
    uWorldMatrixBlur= glGetUniformLocation(programBlur, "worldMatrix");
    
    
    worldMatrixBlur.makeOrtho2DMatrix(0,1024,768,0);
    glUseProgram(0);
    OpenGLErrorChek::chek("blursetup");
    
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

void CubeRenderer::prepForAODraw()
{
  glBindTexture(GL_TEXTURE_2D, textureBlur);

}

void CubeRenderer::renderAO()
{
        OpenGLErrorChek::chek("beforerrr");
    glEnable (GL_DEPTH_TEST);
    
    
    glViewport(0,vpY, vpW, vpH);
     glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
   //glBindFramebuffer(GL_FRAMEBUFFER,fboDepth);
    glClearColor(1.0, 1.0, 1.0, 0.0);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    

    glUseProgram(programDepth);
    
    glUniformMatrix4fv(uWorldMatrixID, 1,0, camera->worldMatrix.getPtr());
    glUniformMatrix4fv(uPerspectiveMatrixID, 1, 0, camera->perspectiveMatrix.getPtr());
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);

    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12,(GLvoid*) (sizeof(float) * 0));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexBuffer);   
    glDrawElements(GL_TRIANGLES, 36* cubeHandler->cubes.size(), GL_UNSIGNED_SHORT, (void*)0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
    glDisableVertexAttribArray(ATTRIB_VERTEX);

    glDisable (GL_DEPTH_TEST);
    
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, fboDepth);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, sampleFramebuffer);
    glResolveMultisampleFramebufferAPPLE();
    
   glBindFramebuffer(GL_FRAMEBUFFER, 0);
 glUseProgram(0);
    
    ///
    
    
    
    
     OpenGLErrorChek::chek("before");
    
     glBindFramebuffer(GL_FRAMEBUFFER, fboBlur);
    //glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
        glViewport(0,vpY, vpW, vpH);
    
    OpenGLErrorChek::chek("after");
    
     glClearColor(0.0, 0.0, 0.0, 0.0);
     glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glUseProgram(programBlur);
    
    glBindTexture(GL_TEXTURE_2D, textureDepth);
    glUniformMatrix4fv(uWorldMatrixBlur, 1, 0, worldMatrixBlur.getPtr());
    
    
    GLfloat *pointer =data;
    
    glVertexAttribPointer(ATTRIB_VERTEX_BLUR, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_VERTEX_BLUR);
    
    
    pointer +=3;
    glVertexAttribPointer(ATTRIB_UV_BLUR, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_UV_BLUR);
    
    
    
   
    
    


    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    



    
    glUseProgram(0);
   
    /*glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, fboBlur);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, sampleFramebuffer);
    glResolveMultisampleFramebufferAPPLE();*/
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    

}



