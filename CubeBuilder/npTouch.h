//
//  npTouch.h
//  displaylist
//
//  Created by Kris Temmerman on 23/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npTouch_h
#define displaylist_npTouch_h


#define NP_TOUCH_START 0
#define NP_TOUCH_MOVE 1
#define NP_TOUCH_STOP 2

class npDisplayObject;

class npTouch
{

public:
    npTouch(){ markDelete =false;target =NULL;};
    int phase ;
    
    float x;
    float y;
    bool markDelete;

    npDisplayObject *target ; 
};

#endif
