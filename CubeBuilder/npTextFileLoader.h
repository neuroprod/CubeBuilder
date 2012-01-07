//
//  npTextFileLoader.h
//  displaylist
//
//  Created by Kris Temmerman on 01/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npTextFileLoader_h
#define displaylist_npTextFileLoader_h
#include  "Foundation/Foundation.h"
#include <iostream>
#include <string>

using namespace std;
class npTextFileLoader
{

public:
    static string  load(string file, string type )
    {
        char *bufF =new char[file.size()];
        strcpy(bufF,file.c_str());

        char *bufT=new char[type.size()];
        strcpy(bufT,type.c_str());
      
        NSString *fileNS = [[NSString alloc] initWithUTF8String:bufF];
        NSString *typeNS = [[NSString alloc] initWithUTF8String:bufT ];
        NSString *Pathname;
        Pathname = [[NSBundle mainBundle] pathForResource:fileNS ofType:typeNS];
        
        
      delete bufF;
        delete bufT;
   
        string source;
        source = (string  )[[NSString stringWithContentsOfFile:Pathname encoding:NSUTF8StringEncoding error:nil] UTF8String];
        
        [fileNS release];
        [typeNS release];
        
  [ Pathname release];
        return source;
    
    
    
    }
    static const char * loadChar(string file, string type )
    {
        char *bufF =new char[file.size()];
        strcpy(bufF,file.c_str());
        
        char *bufT=new char[type.size()];
        strcpy(bufT,type.c_str());
        
        NSString *fileNS = [[NSString alloc] initWithUTF8String:bufF];
        NSString *typeNS = [[NSString alloc] initWithUTF8String:bufT ];
        NSString *Pathname;
        Pathname = [[NSBundle mainBundle] pathForResource:fileNS ofType:typeNS];
        
       
        

        
        const char* source;
        source = [[NSString stringWithContentsOfFile:Pathname encoding:NSUTF8StringEncoding error:nil] UTF8String];
        
        delete bufF;
        delete bufT;
        [fileNS release];
        [typeNS release];
        
       // [ Pathname release];
        
        return source;
        
        
        
    }

};


#endif
