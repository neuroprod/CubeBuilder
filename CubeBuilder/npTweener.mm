//
//  npTweener.cpp
//  displaylist
//
//  Created by Kris Temmerman on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "npTweener.h"
vector<npTween> npTweener::tweens;
 void npTweener::update()
{
    int s = tweens.size();
   
    if (s==0) return;
    int time =  npTimer::getCurrentTime() ;
    for (int i=0 ; i< s ;++i)
    {
        if( tweens[i].update(time))
        {
            if ( tweens[i].hasEventListeners){
                npEvent e;
                e.name =NP_TWEEN_COMPLETE;
                tweens[i].dispatchEvent(e );
                tweens[i].removeAllEvents();/// memory leak hack ->remove if you keep your tweens allocated, or fix this
            }
            tweens.erase (  tweens.begin()+i );
            s = tweens.size();
            i--;
        }
    
    }
   
  

}
void  npTweener::addTween(npTween &tween,bool overrideTarget )
{
  int s = tweens.size();
    for (int i=0 ; i< s ;++i)
    {
        if(tweens[i]._target ==tween._target )
        {
            if( overrideTarget)
            {
               
                if ( tweens[i].hasEventListeners){
                   
                    tweens[i].removeAllEvents();/// memory leak hack ->remove if you keep your tweens allocated, or fix this
                }
                tweens.erase (  tweens.begin()+i );
                s = tweens.size();
                i--;

            }else
            {
            
                tweens[i].resolveDuplicates(tween);
            
            }
    
        }
    
    }
    
    tween.startTime = npTimer::getCurrentTime() ;
    tweens.push_back(tween ); 

}

