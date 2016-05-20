//
//  UM_Share.hpp
//  pinlegame
//
//  Created by Kennedy on 16/5/19.
//
//

#ifndef UM_Share_hpp
#define UM_Share_hpp

#include <stdio.h>
#include <stdio.h>
#include "cocos2d.h"
using namespace std;
USING_NS_CC;
class UM_Share :public Layer
{
public:
    UM_Share();
    ~UM_Share();
    virtual bool init();
    CREATE_FUNC(UM_Share);
public:
//    void shareCallback(int platform, int stCode, string& errorMsg);
};

#endif /* UM_Share_hpp */
