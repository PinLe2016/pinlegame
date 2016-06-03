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
    //传入分享图片路径
    static UM_Share* createWithShare(string sharePicPath);
    
    bool initWithShare(string sharePicPath);

    void shareWithIos(string sharePicPath);//友盟SDK分享
    
    void shareWithAndroid(string sharePicPath);//sharesdk分享
    
public:
    void shareMenuItemClick(cocos2d::Ref* pSender);//android 分享回调
//    void shareResultHandler(C2DXResponseState state, C2DXPlatType platType, __Dictionary *shareInfo, __Dictionary *error);
//    void shareCallback(int platform, int stCode, string& errorMsg);
};

#endif /* UM_Share_hpp */
