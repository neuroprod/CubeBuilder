//
//  CubeRenderer.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "CubeRenderer.h"
#include "ImageDataLoader.h"
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
   
    isIpad1 =model->isIpad1;
    glGenTextures(1, &flatTexture);
	glBindTexture(GL_TEXTURE_2D, flatTexture);
	
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    int width =1024;
    int height =1024;
	
	
	glTexImage2D(GL_TEXTURE_2D, 0,GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
   
    glGenRenderbuffers(1, &rbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, rbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
	
	
    
    glGenFramebuffers(1, &fbo);
	glBindFramebuffer(GL_FRAMEBUFFER, fbo);	
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,rbuffer);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, flatTexture, 0);
    
    GLint status =glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if(status ==GL_FRAMEBUFFER_COMPLETE)cout << "fbo interface complete\n";

    
  
     sizeFactor=3;
    if(!isIpad1){
        
    sizeFactor=2;
    glGenFramebuffers(1, &sampleFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
    
    
    //GL_RGBA8_OES
    glGenRenderbuffers(1, &sampleColorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, sampleColorRenderbuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, width,height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,sampleColorRenderbuffer);
    glGenRenderbuffers(1, &sampleDepthRenderbuffer); 
    glBindRenderbuffer(GL_RENDERBUFFER, sampleDepthRenderbuffer); 
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT24_OES,width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,sampleDepthRenderbuffer);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    cout <<"Failed to make complete framebuffer object "<<glCheckFramebufferStatus(GL_FRAMEBUFFER)<< "\n";
    
    }
    int numV=720000;
    int numI =90000;
    GLushort * indexData;
    GLfloat * vertexData;
    vertexData= new GLfloat[numV];

    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*numV,vertexData, GL_DYNAMIC_DRAW);
     delete []vertexData;
    
    
    
    indexData =new GLushort[numI];
    
 int count =0;
    for (int i=0; count<numI; i+=4) 
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
  
   
    glGenBuffers(1,&indexBuffer  );
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*numI,indexData, GL_STATIC_DRAW);

   
    delete []indexData;
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
    delete pLoader;
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
#if (defined USEAO)
 if (!isIpad1)setupAO();
#endif
    
};

void CubeRenderer::update()

{
    

    
 
    

};

void CubeRenderer::renderTick(){

    if(!cubeHandler->isDirty && !isDirty )return;
    isDirty =true;
    cubeHandler->isDirty =false;
    bool tempIpad;
    if(useAO)
    {
    
    
        tempIpad = isIpad1;
        isIpad1 =false;
    
    }
    
    
    if (isIpad1)
    {
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    }else
    {
     glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
    
    }
    // glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
    
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
    
    if (!isIpad1)
    {
   
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, fbo);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, sampleFramebuffer);
    glResolveMultisampleFramebufferAPPLE();
    }
    
    //clean
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
    glDisableVertexAttribArray(ATTRIB_VERTEX);
    glDisableVertexAttribArray(ATTRIB_NORMAL);
    glDisableVertexAttribArray(ATTRIB_COLOR);
    glDisable (GL_DEPTH_TEST);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    if (useAO) {
    
        isIpad1 =tempIpad;
        renderAO();
    }

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
delete pLoader;
    glUseProgram(programID);
    
    
    
    uWorldMatrixID= glGetUniformLocation(programID, "worldMatrix");
    uPerspectiveMatrixID= glGetUniformLocation(programID, "perspectiveMatrix");
    

    
    glUseProgram(0);

    
    pixels =new GLubyte[1024* 768*4/sizeFactor];

}
void CubeRenderer::drawIDcubes()
{
   // glBindFramebuffer(GL_FRAMEBUFFER, 0);

   glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glViewport(0, 0, vpWID, vpHID);
    
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


    glReadPixels(0, 0,  vpWID,vpHID, GL_RGBA,GL_UNSIGNED_BYTE, pixels);
    glViewport(0, 0, vpW, vpH);
   model->renderHit =false;
  
   // cout << "redraw id cubes\n";
    //OpenGLErrorChek::chek("id cubes");    
}
bool CubeRenderer::getPoint(int x, int y )
{
    ofVec4f vec;
    int pos =(        x/sizeFactor +((vpHID-y/sizeFactor)*vpWID ))*4;
    
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
    vpWID =vpW/sizeFactor;
    vpHID =vpH/sizeFactor;
    camera->setOrientation(orientation);


#if (defined USEAO)
    
    
    if (isIpad1 ) return;    
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
#endif   
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
    
    

	glGenFramebuffers(1, &fboDepth);
	glBindFramebuffer(GL_FRAMEBUFFER, fboDepth);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureDepth, 0);
    
    npProgramLoader *pLoader = new npProgramLoader;
    programDepth =    pLoader->loadProgram ("ShaderCubeDepth");
    
    
    glBindAttribLocation(programDepth, ATTRIB_VERTEX, "position");
    glBindAttribLocation(programDepth, ATTRIB_NORMAL, "normal");
    pLoader->linkProgram();
    delete pLoader;
    glUseProgram(programDepth);
    
    uWorldMatrixDepth= glGetUniformLocation(programDepth, "worldMatrix");
    uPerspectiveMatrixDepth= glGetUniformLocation(programDepth, "perspectiveMatrix");
     uNormalMatrixDepth= glGetUniformLocation(programDepth, "normalMatrix");
    
    uDepthRange= glGetUniformLocation(programDepth, "depthRange");
    uMinDepth= glGetUniformLocation(programDepth, "minDepth");
 
    
   
    
    glUseProgram(0);
    
    
    /*
     *
     *
     *
     *
     *
     *     BLUR11111
     *
     */
	int width2=1024;
    int height2=1024;    
    glGenTextures(1, &textureBlur);
	glBindTexture(GL_TEXTURE_2D, textureBlur);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_LINEAR);
    
 

	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA ,width2, height2, 0, GL_RGBA , GL_UNSIGNED_BYTE, NULL);
    

	glGenFramebuffers(1, &fboBlur);
	glBindFramebuffer(GL_FRAMEBUFFER, fboBlur);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureBlur, 0);
    
    
    
    
    npProgramLoader *pLoaderBlur = new npProgramLoader;
    programBlur =    pLoaderBlur->loadProgram ("ShaderBlur1");

    glBindAttribLocation(programBlur, ATTRIB_VERTEX_BLUR, "position");
    
    glBindAttribLocation(programBlur, ATTRIB_UV_BLUR, "uv");
    pLoaderBlur->linkProgram();
    delete pLoaderBlur;
    glUseProgram(programBlur);
    
    
    uWorldMatrixBlur= glGetUniformLocation(programBlur, "worldMatrix");
 hDepth = glGetUniformLocation(programBlur, "texture");
     hNoise = glGetUniformLocation(programBlur, "textureNoise");
    
    
    cout << "\nsetup"<<  hDepth <<" "<< hNoise <<"\n";
    ImageDataLoader IDloader;
    GLubyte *imagedata;
    
    
    imagedata = IDloader.loadFile(@"noiseMap.jpg");
    glGenTextures(1, &textureNoise);
    glBindTexture(GL_TEXTURE_2D,textureNoise);
    
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,  GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA , 1024,1024, 0, GL_RGBA, GL_UNSIGNED_BYTE, imagedata);
    
    free(imagedata);

       
    
    
    
    /*
     *
     *
     *
     *
     *
     *
     *
     */
    
    
    
    
      OpenGLErrorChek::chek("blursetup");
    
    worldMatrixBlur.makeOrtho2DMatrix(0,1024,768,0);
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

    
    
    
    
    
    return;
    ///
    for(int i =0;i<32;i++ )
    {
   //  pSphere[20] = vec3(-0.010735935, 0.01647018, -0.0062425877);
        
        ofVec4f v;
        v.x =((float )rand()/RAND_MAX -0.5)*2.0;
          v.y =((float )rand()/RAND_MAX -0.5)*2.0;
        v.z =2.0;//+(float )rand()/RAND_MAX ;
        v.normalize();
   //cout <<  "pSphere["<<i<<"] = vec3("<<v.x<<","<< v.y<<"," <<v.z<<");\n";
    
    }
    
    
    
    
    
    
    
}

void CubeRenderer::prepForAODraw()
{
  glBindTexture(GL_TEXTURE_2D, textureBlur);
    useAO =false;
}

void CubeRenderer::renderAO()
{
#if (defined USEAO)
    if (isIpad1)return;

    model->camera->setDepthRange();
    
    
    glEnable (GL_DEPTH_TEST);
      
    glViewport(0,vpY, vpW, vpH);
    glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
  /// glBindFramebuffer(GL_FRAMEBUFFER,fboDepth);
   glClearColor(0.0, 0.0, 0.0,0.0);
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    

    glUseProgram(programDepth);
    
    glUniformMatrix4fv(uWorldMatrixDepth, 1,0, camera->worldMatrix.getPtr());
    glUniformMatrix4fv(uPerspectiveMatrixDepth, 1, 0, camera->perspectiveMatrix.getPtr());
    glUniformMatrix4fv(uNormalMatrixDepth, 1, 0, camera->normalMatrix.getPtr());
    
    glUniform1f(uMinDepth,  model->camera->minDepth);
    glUniform1f(uDepthRange,- model->camera->depthRange);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);

    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12,(GLvoid*) (sizeof(float) * 0));
    
    glEnableVertexAttribArray(ATTRIB_NORMAL);
    glVertexAttribPointer(ATTRIB_NORMAL, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 12,(GLvoid*) (sizeof(float) * 3));

    
    
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
    
    
    
  
    
     glBindFramebuffer(GL_FRAMEBUFFER, fboBlur);
    //glBindFramebuffer(GL_FRAMEBUFFER, sampleFramebuffer);
        glViewport(0,vpY, vpW, vpH);
    
   
    
    // glClearColor(0.0, 0.0, 0.0, 0.0);
     glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glUseProgram(programBlur);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, textureNoise);
    glUniform1i(hNoise, 1);  
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureDepth);
    
    glUniform1i(hDepth, 0);
    
  
    
   // glBindTexture(GL_TEXTURE_2D, textureDepth);
    glUniformMatrix4fv(uWorldMatrixBlur, 1, 0, worldMatrixBlur.getPtr());
    
    
    GLfloat *pointer =data;
    
    glVertexAttribPointer(ATTRIB_VERTEX_BLUR, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_VERTEX_BLUR);
    
    
    pointer +=3;
    glVertexAttribPointer(ATTRIB_UV_BLUR, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_UV_BLUR);
    
    
    
   
    
    


    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    
    glClearColor(0.0, 0.0, 0.0, 0.0);
  

    
    glUseProgram(0);
   
    /*glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, fboBlur);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, sampleFramebuffer);
    glResolveMultisampleFramebufferAPPLE();*/
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glClearColor(0.0, 0.0, 0.0, 0.0);
#endif   

}



