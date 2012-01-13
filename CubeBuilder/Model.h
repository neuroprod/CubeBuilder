//
//  Model.h
//  CubeBuilder
//
//  Created by Kris Temmerman on 27/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef CubeBuilder_Model_h
#define CubeBuilder_Model_h
#include "SettingsCubeBuilder.h"
#include "Camera.h"
#include "npEventDispatcher.h"
#include "cbColor.h"

#include "CubeHandler.h"
#include "ColorHolder.h"
#include "ColorMenu.h"
#include "TapBtn.h"
#include "BackGround.h"

#define STATE_ADD 1
#define STATE_REMOVE 2
#define STATE_PAINT 3
#define STATE_MOVE 11
#define STATE_ROTATE 12


#define STATE_VIEW 21
#define STATE_MENU 22




#define SOUND_ADD_CUBE 0
#define SOUND_REMOVE_CUBE 0
#define SOUND_PAINT_CUBE 0
#define SOUND_HIT_BTN 1
#define SOUND_CAMERA 2
class CubeHandler;
class ColorMenu;
class ColorHolder;
class Camera;

class Model :public npEventDispatcher
{

private:
    static Model* m_pSingleton;
    
protected: 
    Model();
public:
  
    virtual ~Model();
    static Model* getInstance();
    
    void setCurrentState(int state );
    int currentState;
    
    bool renderHit;
    
    void cancelOverlay();
    void clearCubes();
    void setLoadData(int *dataCube,int size);
    void becameActive();
    void prepForSaveShow();
    
    Camera *camera;

    
    void resolveCenter();
    ofVec3f center;
    ofVec3f centerOld;
    ofVec3f min;
    ofVec3f max;
    
    
    void setColor(int colorid);
    vector <cbColor> colors;
    
    CubeHandler * cubeHandler;
    ColorHolder *colorHolder;
    ColorMenu *colorMenu;
    
    bool isDirty;
    bool takeSnapshot;
    bool useAO;
    bool keepAO;
    GLubyte *pixeldata;
    int pixelW;
    int pixelH;
    int currentLoadID;
    
    TapBtn *redoBtn;
    TapBtn *undoBtn;
    
    bool isIpad1;
    
    BackGround *backGround;
    void prepForSaveImage();
    int snapType;
    void setBackGround(int bgId)
    {
        backGround->setColor(bgId);
    
    }
    
    void  playSound(int soundID);
    bool isSound;
};

#endif
