//
//  MainCubeBuilder.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "MainCubeBuilder.h"


void MainCubeBuilder::setup()
{
    
    model =Model::getInstance();
   
    
    makeCallBack( MainCubeBuilder,becameActive,becameActivecall );
    model->addEventListener("becameActive" ,becameActivecall);
    
    
    camera =new Camera();
    model->camera =camera;
    flatRenderer =new FlatRenderer();
    flatRenderer->setup();
    
 
    cubeHandler =new CubeHandler();
    cubeHandler->setup();
     
    model->cubeHandler = cubeHandler;
    
    cubeRenderer =new CubeRenderer();
    cubeRenderer->setup();
    cubeRenderer->camera =camera;
    cubeRenderer->cubeHandler = cubeHandler;
    
    cubeHandler->vertexBuffer =cubeRenderer->vertexBuffer;
    cubeHandler->addCube(0,0,0);


  
    interfaceHandler =new InterfaceHandler();
    interfaceHandler->setup();
        
    backGround  =new BackGround();
    backGround->setup();
    
    
    
    model->setColor(24);
    
    glClearColor(0.0f,0.0f, 0.0f, 0.0f);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_CULL_FACE);
    glFrontFace(GL_CW);
    glCullFace(GL_BACK);
    
    OpenGLErrorChek::chek("mainsetup");
    
}


void MainCubeBuilder::update ()
{
   
    npTweener::update();
   
    interfaceHandler->renderTick();

    if(camera->isDirty)
    {
        camera->update();
        cubeRenderer->isDirty =true;
    }
    
    cubeHandler->update();
    cubeRenderer->renderTick();
    backGround->renderTick();
    
}


void MainCubeBuilder::draw ()
{
     

   
    if (!cubeRenderer->isDirty && !interfaceHandler->isDirty && !backGround->isDirty)return;
    
    if (model->renderHit) cubeRenderer->drawIDcubes()  ;
    
    // cout << "\ndirties: "<< cubeRenderer->isDirty << " "<<interfaceHandler->isDirty << " "<<backGround->isDirty <<" " <<cubeHandler->isDirty<<"\n";
    
    
    glClearColor(1.0f,1.0f, 1.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable (GL_BLEND); 
  

    
    flatRenderer->start();
    
    
    backGround->prepForFlatDraw();
    flatRenderer->draw();
    
    cubeRenderer->prepForFlatDraw();
    flatRenderer->draw();
    
    interfaceHandler->prepForFlatDraw();
    flatRenderer->draw();
    
  
    
    flatRenderer->stop ();
      
    glDisable  (GL_BLEND); 
    glClearColor(0.0f,0.0f, 0.0f, 0.0f);
    
}


void MainCubeBuilder::setTouches(vector<npTouch> &touches)
{
    int currentState  = model->currentState;
    
    for(int i =0;i<touches.size();i++ )
    {
       
        if(touches[i].phase ==NP_TOUCH_STOP)
        {
            
            if(touches[i].target)
            {
                npTouchEvent t;
                t.name  =TOUCH_UP;
                t.target = touches[i].target;
                touches[i].target->dispatchEvent(t );
                if(t.target->isTouching(touches[i]))
                {
                    npTouchEvent ti;
                    ti.name  =TOUCH_UP_INSIDE;
                    ti.target = touches[i].target;
                    touches[i].target->dispatchEvent(ti );
                    
                }
                
                
            }else
            {
                if (currentState<10)
                {
                    
                    if(cubeRenderer->getPoint(touches[i].x,touches[i ].y))
                    {
                        cubeHandler->touchedCube(cubeRenderer->currentCubeIndex,cubeRenderer->currentCubeSide,touches[i].phase);
                        
                    } 
                }
            }
        }
        else{
            
            if( !interfaceHandler->checkTouch(touches[i]))
            {
                if(touches[i].target ==NULL){
                if (currentState<10)
                {
                    if(cubeRenderer->getPoint(touches[i].x,touches[i ].y))
                    {
                        cubeHandler->touchedCube(cubeRenderer->currentCubeIndex,cubeRenderer->currentCubeSide,touches[i].phase);
                    
                    }  
                }
                else  if (currentState<20){
               
                    camera->checkTouch(touches[i]);
                              
                }}
            }
              
        }
    }
    
    
};

//landscape ==1   portrait ==0
void MainCubeBuilder::setOrientation(int orientation)
{
    if (currentorientation ==orientation)return;
    currentorientation =orientation;
    model->renderHit =true;
    
    cubeRenderer->setOrientation(currentorientation);
    flatRenderer->setOrientation(currentorientation);
    interfaceHandler->setOrientation(currentorientation);
   

}
void MainCubeBuilder::becameActive(npEvent *e)
{
    
    int temp = currentorientation;
    
    currentorientation  =-100;
    setOrientation(temp);

}
