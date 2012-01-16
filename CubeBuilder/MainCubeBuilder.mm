//
//  MainCubeBuilder.cpp
//  CubeBuilder
//
//  Created by Kris Temmerman on 22/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include "MainCubeBuilder.h"

//#define USEAO 0
void MainCubeBuilder::setup1()
{
  

    model =Model::getInstance();
    model->isDirty =true; 
    
    
    interfaceHandler =new InterfaceHandler();
    interfaceHandler->setup();
    
    makeCallBack( MainCubeBuilder,becameActive,becameActivecall );
    model->addEventListener("becameActive" ,becameActivecall);
    
    
    camera =new Camera();
    model->camera =camera;
    flatRenderer =new FlatRenderer();
    flatRenderer->setup();
    
 
   }
void MainCubeBuilder::setup2()
{
    
   
    
    
    cubeHandler =new CubeHandler();
    cubeHandler->setup();
    
    model->cubeHandler = cubeHandler;
    
    
    
    
   }

void MainCubeBuilder::setup3 ()
{
    cubeRenderer =new CubeRenderer();
    cubeRenderer->setup();
    cubeRenderer->camera =camera;
    cubeRenderer->cubeHandler = cubeHandler;
    
    cubeHandler->vertexBuffer =cubeRenderer->vertexBuffer;
    cubeHandler->addCube(0,0,0);

    
    previewCube =new PreviewCube();
    previewCube->setup();
    
    cubeRenderer->previewCube  = previewCube;
    
    cubeHandler->previewCube =previewCube;
       
    
    backGround  =new BackGround();
    backGround->setup();
    
    model->backGround =backGround;
    
    model->setColor(24);
    
    
    
    
    glClearColor(0.0f,0.0f, 0.0f, 0.0f);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_CULL_FACE);
    glFrontFace(GL_CW);
    glCullFace(GL_BACK);
    
    OpenGLErrorChek::chek("mainsetup");
    
    
    model->renderHit =true;
    backGround->isDirty =true;
    

    
    
    
  //  interfaceHandler->display.setOpen(true);
    
   
}
void MainCubeBuilder::start()
{
    if (model->isIpad1)npTweener::speedFactor=1.5;
    npEvent *e;
    interfaceHandler->display.setAdd(e );
    interfaceHandler->display.setOpen(true);
    camera->setZoomStart();
    
   // cout <<"STARTFIRSTRUNN?? " << model->firstRun<<endl;
    
}
void MainCubeBuilder::update1()
{
    npTweener::update();
    
    interfaceHandler->renderTick();
    interfaceHandler->isDirty =false;

}
void MainCubeBuilder::update2()
{
    if(camera->isDirty)
    {
        camera->update();
        cubeRenderer->isDirty =true;
    }
    if (model->useAO)
    {
        
        // cubeRenderer->isDirty =true;
        // cubeRenderer->useAO=true;
    }
    cubeHandler->update();
    if (previewCube->isDirty)cubeRenderer->isDirty =true;
    
    cubeRenderer->renderTick();
    cubeRenderer->isDirty =false;
    
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
    if (model->useAO)
    {
        
   // cubeRenderer->isDirty =true;
   // cubeRenderer->useAO=true;
    }
    cubeHandler->update();
    if (previewCube->isDirty)cubeRenderer->isDirty =true;
    
    cubeRenderer->renderTick();
    backGround->renderTick();
     
}


void MainCubeBuilder::draw ()
{
     
 
   
    if (!cubeRenderer->isDirty && !interfaceHandler->isDirty && !backGround->isDirty && !model->isDirty){
     //   cubeHandler->clean();
        return;
    }
    
    
    // cout << "\ndirties: "<< cubeRenderer->isDirty << " "<<interfaceHandler->isDirty << " "<<backGround->isDirty <<" " <<cubeHandler->isDirty<<"\n";
    if (model->renderHit) cubeRenderer->drawIDcubes()  ;
 

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable (GL_BLEND); 
  
  
    
    flatRenderer->start();
    
  
    backGround->prepForFlatDraw();
    flatRenderer->draw();
 
    cubeRenderer->prepForFlatDraw();
    flatRenderer->draw();
#if (defined USEAO)
 

    

    if (cubeRenderer->useAO     || model->keepAO){
        model->useAO =false;
        if(!model->isIpad1)
        {
        cubeRenderer->prepForAODraw();
            flatRenderer->draw();
        
        }else
        {
            model->keepAO =false;
            cubeRenderer->useAO =false;
               cubeRenderer-> isDirty =false ;
        }
        
    }
#endif
    if(model->takeSnapshot)
    {
        
      ///  if (model->pixeldata ){ delete[]  model->pixeldata ;}
        int vpW;
        int vpH;
        if (currentorientation ==1)
        {
            vpW = 1024;
            vpH = 768;
            
        }
        else
        {
            vpH = 1024;
            vpW = 768;
        }
        GLubyte *data =(GLubyte *) malloc(768*1024*4);
        
        glReadPixels(0, 0,  vpW,vpH, GL_RGBA,GL_UNSIGNED_BYTE,data);
        
        
        
        model->pixelW= vpW;
        model->pixelH = vpH;
        model->pixeldata = data;
        model->takeSnapshot =false;
        draw ();
        
       
      
        if (model->snapType==0)[[NSNotificationCenter defaultCenter] postNotificationName:@"setOverView" object:[NSNumber numberWithInt:11]]; 
        if (model->snapType==1)[[NSNotificationCenter defaultCenter] postNotificationName:@"setOverView" object:[NSNumber numberWithInt:14]]; 
       return;
    }
    
    interfaceHandler->prepForFlatDraw();
    flatRenderer->draw();
    
  
    
    flatRenderer->stop ();
      
    glDisable  (GL_BLEND); 

     model->isDirty =false;
}
void MainCubeBuilder::resolveGesture()
{
    for(int i =0;i<gestureTouches.size();++i)
    {
        if(gestureTouches[i]->phase !=NP_TOUCH_MOVE ){
            isGuesturing=false;
            model->renderHit =true;
            model->isDirty =true;
            return;
        
        }
        
    }

    float centerX =0.5*(gestureTouches[0]->x +gestureTouches[1]->x);
    float centerY =0.5*(gestureTouches[0]->y +gestureTouches[1]->y);
    float dx = gestureTouches[0]->x -gestureTouches[1]->x;
    float dy = gestureTouches[0]->y -gestureTouches[1]->y;
    float dist =sqrt(dx*dx +dy*dy);
    camera->setZoomMove((dist-startDist)/8.0);
    startDist =dist;
    camera->setMove(centerX-startX,startY-centerY);
    startY =centerY;
    startX =centerX;
    
    
  
}

void MainCubeBuilder::setTouches(vector<npTouch> &touches)
{
    int currentState  = model->currentState;
    
    if (!isGuesturing)
    {
        int mtGuestureCount =0;
        for(int i =0;i<touches.size();++i)
        {
            if(touches[i].phase ==NP_TOUCH_MOVE && touches[i].target ==NULL){mtGuestureCount++;}
    
        }
        if (mtGuestureCount >1) {
        
        gestureTouches.clear();
       
        for(int i =touches.size()-1;i>-1;i--)
        {
            if(touches[i].phase ==NP_TOUCH_MOVE && touches[i].target ==NULL)
            {
                
                touches[i].target =&interfaceHandler->display.mainInfoBack ;// hack-> now has a target so it can never add or remove cubes
                gestureTouches.push_back(&touches[i]);
                if (gestureTouches.size()==2)break;
            }
            
        }
            startX =0.5*(gestureTouches[0]->x +gestureTouches[1]->x);
            startY =0.5*(gestureTouches[0]->y +gestureTouches[1]->y);
            float dx = gestureTouches[0]->x -gestureTouches[1]->x;
            float dy = gestureTouches[0]->y -gestureTouches[1]->y;
            startDist =sqrt(dx*dx +dy*dy);
            previewCube->setPos(10000 , -10000,-10000);
            isGuesturing=true;
            camera->touchPointer =NULL;
            //resolveGesture();
        }
    }
 
    for(int i =0;i<touches.size();++i)
    {
        if(isGuesturing)
        {
            if(&touches[i]==gestureTouches[0 ])continue;
            if(&touches[i]==gestureTouches[1 ])continue;
        
        }
        if(touches[i].phase ==NP_TOUCH_STOP && touches[i].target)
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
                touches[i].target =NULL;
        }
        else if (touches[i].phase ==NP_TOUCH_START)
        {
            
            if( !interfaceHandler->checkTouch(touches[i]))
            {
                    if (isGuesturing)continue;
                    if (currentState<10)
                    {
                        if(cubeRenderer->getPoint(touches[i].x,touches[i ].y))
                        {
                            if (model->firstRun)
                            {
                            
                                model->firstRun =false;
                                interfaceHandler->display.closeFirstRun();
                            
                            }
                            cubeHandler->touchedCube(cubeRenderer->currentCubeIndex,cubeRenderer->currentCubeSide,touches[i].phase);
                            
                        } else 
                        {
                            previewCube->setPos(10000 , -10000,-10000);
                        } 
                    }
                    else  if (currentState<20)
                    {
                        
                        camera->checkTouch(touches[i]);
                        
                    }
              
            }
            
        }else///move
        {
            if(touches[i].target)
            {
                interfaceHandler->checkTouch(touches[i]);             
        
            }else
            {
            
                if (isGuesturing)continue;
            
                if (currentState<10)
                {
                    if(cubeRenderer->getPoint(touches[i].x,touches[i ].y))
                    {
                        cubeHandler->touchedCube(cubeRenderer->currentCubeIndex,cubeRenderer->currentCubeSide,touches[i].phase);
                        
                    } 
                    else 
                    {
                        previewCube->setPos(10000 , -10000,-10000);
                    } 
                }
                else  if (currentState<20)
                {
                    
                    camera->checkTouch(touches[i]);
                    
                }

            
            
            
            }
        
        
        
        
        }
    }
    
   if (isGuesturing)
    {
       
        resolveGesture();
        
    }
  
    
}

//landscape ==1   portrait ==0
void MainCubeBuilder::setOrientation(int orientation)
{
    if (currentorientation ==orientation)return;
    
    currentorientation =orientation;
    model->renderHit =true;
    
    cubeRenderer->setOrientation(currentorientation);
    flatRenderer->setOrientation(currentorientation);
    interfaceHandler->setOrientation(currentorientation);
   
    backGround->setOrientation(currentorientation);
   // cout << "set";
    

}
void MainCubeBuilder::becameActive(npEvent *e)
{
    
     model->isDirty =true;

}
