//
//  npTween.cpp
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npTween.h"

bool npTween::update(int currentTime)
{
    int time =currentTime -startTime-_delay;
   
    if(time<0)return false;
 
    _target->isDirty  =true;
        
    int numParam = params.size();

    if(time<_time )
    {
        for (int i=0;i<numParam;++i)
        {
        
           npTweenParam param =  params[i];
           *param.property = (*this.*easeFunction)(time,param.startValue,param.changeValue,_time);  
         
        }
        
        return false;
    
    }else
    {
        for (int i=0;i<numParam;++i)
        {
            npTweenParam param =  params[i];
            *param.property  = param.startValue+param.changeValue;
            
        }
        params.clear();
        return true;
    }
    
}
/*
* @param t             Current time (in frames or seconds).
* @param b             Starting value.
* @param c             Change needed in value.
* @param d             Expected easing duration (in frames or seconds).
* @return              The correct value
*/



void npTween::init(npDirty *target,int ease,int time,int delay){
    
    switch ( ease  ) {
            
        case NP_EASE_OUT_SINE : 
            easeFunction =&npTween::easeOutSine   ;
            break;
            
        case NP_EASE_IN_SINE : 
             easeFunction =&npTween::easeInSine ;
            break;
        case NP_EASE_OUT_BACK : 
            easeFunction =&npTween::easeOutBack ;
            break;
        case NP_EASE_IN_BACK : 
            easeFunction =&npTween::easeInBack;
            break;
        case NP_EASE_IN_EXPO : 
            easeFunction =&npTween::easeInExpo ;
            break;
        case NP_EASE_OUT_EXPO : 
            easeFunction =&npTween::easeOutExpo;
            break;
        case NP_EASE_NONE : 
            easeFunction =&npTween::easeNone;
            break;
        case NP_EASE_OUT_BACK_SOFT : 
            easeFunction =&npTween::easeOutBackSoft ;
            break;
      
            
    }
  
    _target = target;
    _delay =delay;
    _time =time;
}
void npTween::addProperty (float *target,float targetValue ){
    float startValue  = *target;
    float changeValue = targetValue-startValue;
    npTweenParam param;
    param.startValue = startValue;
    param.changeValue =changeValue;
    param.property  =target;
    params.push_back(param);
   
}


