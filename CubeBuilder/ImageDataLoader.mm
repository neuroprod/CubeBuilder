//
//  ImageDataLoader.cpp
//  mbcarconfig
//
//  Created by Kris Temmerman on 22/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#include "ImageDataLoader.h"

GLubyte * ImageDataLoader::loadFile(NSString *file )
{
    CGImageRef spriteImage = [UIImage imageNamed:file].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", file);
        exit(1);
    }
    
 
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, 
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
    
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    return spriteData;

}