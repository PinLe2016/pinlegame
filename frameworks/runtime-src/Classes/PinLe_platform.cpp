//
//  PinLe_ platform.cpp
//  pinlegame
//
//  Created by Kennedy on 16/5/16.
//
//

#include "PinLe_platform.hpp"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #include "PluginHelper.h"
#endif
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#define  CLASS_NAME "org/cocos2dx/lua/AppActivity"
#endif
USING_NS_CC;

PinLe_platform::PinLe_platform()
{
}

PinLe_platform::~PinLe_platform()
{

}

static PinLe_platform* pinLe_platform=NULL;

PinLe_platform* PinLe_platform::Instance()
{
    if(pinLe_platform == NULL)
    {
        pinLe_platform = new PinLe_platform();
        pinLe_platform->setCity("");
        pinLe_platform->setCounty("");
        pinLe_platform->setProvince("");
    }
    return pinLe_platform;
}


void PinLe_platform::getLocation()
{
    std::string last_all;
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    {
        PluginHelper::getInstance()->getCity();//获取位置
    }
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    {
        JniMethodInfo t;
        if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getLocationString", "(I)Ljava/lang/String;"))
        {
            jstring channel = (jstring)t.env->CallStaticObjectMethod (t.classID, t.methodID,0);
            last_all=JniHelper::jstring2string(channel);
            this->setProvince(last_all);
            log("111 %s",last_all.c_str());
            
        }
        if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getLocationString", "(I)Ljava/lang/String;"))
        {
            
            jstring channel = (jstring)t.env->CallStaticObjectMethod (t.classID, t.methodID,1);
            last_all=JniHelper::jstring2string(channel);
            this->setCity(last_all);
//            LocPlay::getInstance()->setCity(last_all);
            log("222 %s",last_all.c_str());
        }
        if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getLocationString", "(I)Ljava/lang/String;"))
        {
            jstring channel = (jstring)t.env->CallStaticObjectMethod (t.classID, t.methodID,2);
            last_all=JniHelper::jstring2string(channel);
            this->setCounty(last_all);
            log("333 %s",last_all.c_str());
        }
    }
#endif

    log("getCoordinate longitude2222222 = %s, ", last_all.c_str());
}