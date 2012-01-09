//
//  npTweener.h
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npTweener_h
#define displaylist_npTweener_h

#include "npTimer.h"
#include "npTween.h"
#include "npDirty.h"
#include <iostream>
#include <vector>
using namespace std;
class npTweener
{
  
public:
    npTweener(){};
   static vector<npTween> tweens;
    
    
    static void addTween(npTween &tween,bool overrideTarget =true);
    
    static void update();



};


#endif
