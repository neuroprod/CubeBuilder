//
//  ImageDataLoader.h
//  mbcarconfig
//
//  Created by Kris Temmerman on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef mbcarconfig_ImageDataLoader_h
#define mbcarconfig_ImageDataLoader_h


#include <iostream>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include  "Foundation/Foundation.h"


using namespace std;


class ImageDataLoader
{

public: 
    ImageDataLoader(){};
    GLubyte * loadFile(NSString *file);




};

#endif
