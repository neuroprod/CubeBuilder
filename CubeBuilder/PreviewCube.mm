//
//  PreviewCube.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 02/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "PreviewCube.h"


enum {
    ATTRIB_VERTEX,
    
};
void PreviewCube::setup(){

    
    model= Model::getInstance();
    
    npProgramLoader *pLoader = new npProgramLoader;
    programMain  =    pLoader->loadProgram ("ShaderCubeLine");
    
    
    
    glBindAttribLocation(programMain, ATTRIB_VERTEX, "position");
   
    pLoader->linkProgram();
    
    glUseProgram(programMain);
    
    
    
    uWorldMatrixMain= glGetUniformLocation(programMain, "worldMatrix");
 
    uPerspectiveMatrixMain= glGetUniformLocation(programMain, "perspectiveMatrix");
    uColor= glGetUniformLocation(programMain, "color");
    uPosition= glGetUniformLocation(programMain, "pos");
    //GLint uWorldMatrixMain;
    // GLint uNormalMatrixMain;
    //GLint uPerspectiveMatrixMain;
    
    glUseProgram(0);

    x = 10000;
    y=10000;
    z=10000;
    
    float hSize =1.01;
    numi =6*12;
    data =new float[numi];
    float gCubeVertexData[] = 
    {
        
        -hSize,-hSize,-hSize , hSize,-hSize,-hSize,
        -hSize,hSize,-hSize , hSize,hSize,-hSize,
        
        
        -hSize,-hSize,hSize , hSize,-hSize,hSize,
        -hSize,hSize,hSize , hSize,hSize,hSize,
        
        
        -hSize,-hSize,-hSize , -hSize,hSize,-hSize,
        -hSize,-hSize,hSize , -hSize,hSize,hSize,
        hSize,-hSize,-hSize , hSize,hSize,-hSize,
        hSize,-hSize,hSize , hSize,hSize,hSize,
        
        hSize,hSize,-hSize , hSize,hSize,hSize, 
        -hSize,hSize,-hSize , -hSize,hSize,hSize,
        hSize,-hSize,-hSize , hSize,-hSize,hSize,
        -hSize,-hSize,-hSize , -hSize,-hSize,hSize
        
    };
    
    
    memcpy(data, &gCubeVertexData[0], numi*sizeof(float));
    
    colorID =-2;
    

}
void PreviewCube::setPos(float _x, float _y, float _z)
{
    if (_x != x ||_y != y || _z != z)
    {
        
        x =_x;
        y=_y;
        z=_z;
        
        
        isDirty =true;
    
    }


}
void PreviewCube::setColor(int _colorID)
{
   
    if (colorID!= _colorID)
    {
   
        if (_colorID ==-1)
        {
            r =1.0f;
            g=1.0f;
            b=1.0f;
        }else 
        {
           cbColor col =  model->colors[_colorID];
            r =col.r;
            g=col.g;
            b=col.b;
     
        
        }
        colorID = _colorID;
    }


}
void PreviewCube::update()
{



}
void PreviewCube::draw()
{

    glEnable(GL_BLEND);
    
    glUseProgram(programMain);
    glUniformMatrix4fv(uWorldMatrixMain, 1, 0,model->camera->worldMatrix.getPtr());
    glUniformMatrix4fv(uPerspectiveMatrixMain, 1, 0, model->camera->perspectiveMatrix.getPtr());
   
    glUniform4f(uPosition,x,y, z, 1.0);
    GLfloat *pointer =data;
    
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0, 3*sizeof(GLfloat), pointer);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    
   
    
   // glDisable(GL_DEPTH_TEST);
    
   
    
    
    
    glUniform4f(uColor,r,g,b,1.0);
    glLineWidth(4); 
    
    
    glDrawArrays(GL_LINES, 0, numi/3);
    
   
   

    
    glUseProgram(0);
   
    // glEnable(GL_DEPTH_TEST);
    
    //OpenGLErrorChek::chek("previewCube");



    isDirty =false;



}