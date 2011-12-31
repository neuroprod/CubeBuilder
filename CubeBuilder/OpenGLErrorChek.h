//
//  OpenGLErrorChek.h
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_OpenGLErrorChek_h
#define displaylist_OpenGLErrorChek_h

#include <iostream>


#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


using namespace std;
class OpenGLErrorChek
{


public:
    
    static void chek(int pos) 
    {
        
        GLenum errCode;
        errCode = glGetError();
        if ((errCode ) != GL_NO_ERROR) {
            cout << "\n GL ERROR "<< pos;
            cout << ": "<< errCode;
            if(errCode == GL_INVALID_ENUM)cout <<" GL_INVALID_ENUM";
            if(errCode == GL_INVALID_VALUE)cout <<"GL_INVALID_VALUE";
            if(errCode == GL_INVALID_OPERATION)cout <<"GL_INVALID_OPERATION";
            if(errCode == GL_OUT_OF_MEMORY)cout <<"GL_OUT_OF_MEMORY";
            cout <<"\n";
        }};






    static void chek(string pos ) 
    {
    
        GLenum errCode;
        errCode = glGetError();
        if ((errCode ) != GL_NO_ERROR) {
        cout << "\n GL ERROR "<< pos;
        cout << ": "<< errCode;
        if(errCode == GL_INVALID_ENUM)cout <<" GL_INVALID_ENUM";
        if(errCode == GL_INVALID_VALUE)cout <<"GL_INVALID_VALUE";
        if(errCode == GL_INVALID_OPERATION)cout <<"GL_INVALID_OPERATION";
        if(errCode == GL_OUT_OF_MEMORY)cout <<"GL_OUT_OF_MEMORY";
        cout <<"\n";
        }
    };




};

#endif
