//
//  npEventDispatcher.cpp
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npEventDispatcher.h"

void npEventDispatcher::addEventListener(string name  ,TnpEventFunctor* functor )
{
  //  npEvent e;
   // functor->Call(&e );
    
    pair <string , TnpEventFunctor* > myPair (name, functor);
    pairs.push_back( myPair);
    hasEventListeners =true;

}

void npEventDispatcher::removeEventListener(string name ,TnpEventFunctor* functor )

{


}

void npEventDispatcher::dispatchEvent(npEvent &event)
{
     
    if(pairs.size() ==0)return;
    string searchVal = event.name;
    for(int i=0;i<pairs.size();i++)
    {
    
        if (searchVal.compare(pairs[i].first)==0 )
        {
            pairs[i ].second->Call(&event);
        
        
        }
    }
   

}
