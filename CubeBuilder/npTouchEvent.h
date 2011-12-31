//
//  npTouchEvent.h
//  displaylist
//
//  Created by Kris Temmerman on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npTouchEvent_h
#define displaylist_npTouchEvent_h

class npDisplayObject;
#include "npEvent.h"

#include "npTouch.h"



class npTouchEvent:public npEvent
{

public:
    npDisplayObject *target; 

};

#define TOUCH_DOWN "touchDown"
#define TOUCH_UP "touchUp"
#define TOUCH_UP_INSIDE "touchUpInside"
#endif
