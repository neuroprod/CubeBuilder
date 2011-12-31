//
//  npDisplayList.h
//  displaylist
//
//  Created by Kris Temmerman on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npDisplayList_h
#define displaylist_npDisplayList_h




//

#include <iostream>
#include <vector>
#include  "npTimer.h"

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "Foundation/Foundation.h"

#include "npDirty.h"

#include "ofMatrix4x4.h"
#include "ofVec4f.h"

using namespace std;



#define NP_ALIGN_TOP 1
#define NP_ALIGN_LEFT 2
#define NP_ALIGN_BOTTEM 3
#define NP_ALIGN_RIGHT 4


#define NP_ALIGN_TOPLEFT 5
#define NP_ALIGN_TOPRIGHT 6
#define NP_ALIGN_BOTTEMLEFT 7
#define NP_ALIGN_BOTTEMRIGHT 8

#define NP_ALIGN_CENTER 9

#endif
