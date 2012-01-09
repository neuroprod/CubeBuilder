//
//  npEventDispatcher.h
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npEventDispatcher_h
#define displaylist_npEventDispatcher_h
#include "npEvent.h"

#include <vector>
#define makeCallBack(ap,bp,cp) npEventFunctor<ap> *cp =new npEventFunctor<ap>(this,&ap::bp); //params: Class,function,callback

using namespace std;

class TnpEventFunctor
{
public:
    
   // virtual  ~TnpEventFunctor()
    //{
      //  cout << "delete functor22";
    //}
    
    virtual void Call( npEvent* event)=0;       
};



template <class TClass> class npEventFunctor : public TnpEventFunctor
{
private:
    void (TClass::*fpt)(npEvent* event);   
    TClass* pt2Object;                 
    
public:
    
      npEventFunctor ( TClass*  _pt2Object, void(TClass::*_fpt)( npEvent* event))
    { 
        pt2Object = _pt2Object;  
        fpt=_fpt; 
    };
 
  
    virtual void Call( npEvent* event)
    { 
        (*pt2Object.*fpt)(event);
    
    
    };            
};


class npEventDispatcher
{
   
    vector< pair <string , TnpEventFunctor* >  > pairs ;
public:
    
    bool hasEventListeners;
    npEventDispatcher() :pairs(NULL) {
    
    
    }
    virtual ~npEventDispatcher() {
        
       /*// return; 
        cout <<"\n";
        for(int i=0;i<pairs.size();i++)
        {
            
          // pairs[i ]->first =="ddd"; 
          //delete  pairs[i ]->second;
            cout <<"del- "<< pairs[i ]->first<<" "<<pairs[i ]->second << "\n"  ;     
            
        }
       //pairs.clear();
       */
    
    }
    void removeAllEvents()
    {
        for(int i=0;i<pairs.size();i++)
        {
            
            // pairs[i ]->first =="ddd"; 
            delete  pairs[i ].second;
           // cout <<"del- "<< pairs[i ]->first<<" "<<pairs[i ]->second << "\n"  ;     
            
        }
        pairs.clear();
    
    }
    void addEventListener(string name  ,TnpEventFunctor* functor );
    void removeEventListener(string name ,TnpEventFunctor* functor );
    
    void dispatchEvent(npEvent &event);
  
    
};

#endif
