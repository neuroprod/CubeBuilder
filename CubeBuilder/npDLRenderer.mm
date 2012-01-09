//
//  npDLRenderer.cpp
//  displaylist
//
//  Created by Kris Temmerman on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npDLRenderer.h"
enum {
    ATTRIB_VERTEX,
    ATTRIB_UV,
    NUM_ATTRIBUTES
};

npDLRenderer::npDLRenderer()
{



}
npDLRenderer::~npDLRenderer()
{

} 
void npDLRenderer::setup()
{
    npProgramLoader *pLoader = new npProgramLoader;
    program  =    pLoader->loadProgram ("ShaderFlatDPpng");
   
    worldMatrix.makeOrtho2DMatrix(0,1024,768,0);
    // worldMatrix.makeOrtho2DMatrix(0,0,1024,768);

    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    
    glBindAttribLocation(program, ATTRIB_UV, "uv");
    pLoader->linkProgram();
    delete pLoader;
    glUseProgram(program);
    
  
    uWorldMatrix= glGetUniformLocation(program, "worldMatrix");

    glUseProgram(0);
}

bool  npDLRenderer::update(npDisplayObject * displayObject)
{

  return   displayObject->update(false);

}
void npDLRenderer::render(npDisplayObject * displayObject)
{
    
    vector <float> data;
    displayObject->getData(data);
    
    
    float arr[data.size()];
    memcpy( arr, &data[0], sizeof( float) * data.size() );

    
    glEnable (GL_BLEND); 
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
     
    glUseProgram(program);
    glUniformMatrix4fv(uWorldMatrix, 1, 0, worldMatrix.getPtr());
    
    glBindTexture(GL_TEXTURE_2D, displayObject->texture);
   
 
    GLfloat *pointer =arr;

    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    
    pointer +=3;
    glVertexAttribPointer(ATTRIB_UV, 3, GL_FLOAT, 0, 6*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_UV);
    
    
    glDrawArrays(GL_TRIANGLES, 0, data.size() /6);
    glDisableVertexAttribArray(ATTRIB_VERTEX);
    glDisableVertexAttribArray(ATTRIB_UV);

    glUseProgram(0);
    glDisable  (GL_BLEND); 
  
       

 }
void  npDLRenderer::setSize(float w,float h)
{
  worldMatrix.makeOrtho2DMatrix(0,w,h,0);

}