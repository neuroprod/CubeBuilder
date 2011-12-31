//
//  npTween.h
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef displaylist_npTween_h
#define displaylist_npTween_h

#include <iostream>
#include <vector>
#include "npDirty.h"
#include "npEventDispatcher.h"

using namespace std;


    

#define NP_TWEEN_COMPLETE "tweenComplete"



class npTweenParam
{
public:
    float *property;
    float startValue ;
    float changeValue ;
    
};

class npTween:public npEventDispatcher
{

    float _delay;
    float _time;
 
        vector<npTweenParam> params;
    
public:
    npTween(){};
  
    int startTime;
    void init(npDirty* target,int ease ,int time,int delay);
    void addProperty (float *target,float targetValue );
   
    bool update(int currentTime);
   

    void resolveDuplicates(npTween tween){//cout << "tweener implement resolve Duplicates -> split tween in params???";
    }
    npDirty *_target;
    float (npTween::*easeFunction)(float,float,float,float) ;

    
    /// easing functions
    
    inline float easeNone (float t ,float  b,float  c,float  d){
        return c*t/d + b;
    }
    
    inline float easeInSine (float t,float b , float c, float d) {
        return -c * cos(t/d * (1.57079633)) + c + b;
    }
    
    inline float easeOutSine(float t,float b , float c, float d) {
        return c * sin(t/d * (1.57079633)) + b;
    }

    
   inline float  easeInBack (float t,float b , float c, float d) {
        float s = 1.70158f;
        float postFix = t/=d;
        return c*(postFix)*t*((s+1)*t - s) + b;
    }
    
   inline float easeOutBack(float t,float b , float c, float d) {
        float s = 1.70158f;
        return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
    }
    
    inline float easeInExpo (float t,float b , float c, float d) {
        return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
    }
    inline float easeOutExpo(float t,float b , float c, float d) {
        return (t==d) ? b+c : c * (-pow(3, -10 * t/d) + 1) + b;
    }
    inline float  easeOutBackSoft (float t,float b , float c, float d) {
        float s = 0.60f;
        return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
    }
};

enum
{
    NP_EASE_NONE,
    NP_EASE_IN_SINE,
    NP_EASE_OUT_SINE,
    NP_EASE_IN_BACK,
    NP_EASE_OUT_BACK,
    NP_EASE_IN_EXPO,
    NP_EASE_OUT_EXPO,
    NP_EASE_OUT_BACK_SOFT

};
#endif
