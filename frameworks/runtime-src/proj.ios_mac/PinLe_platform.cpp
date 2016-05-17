//
//  PinLe_ platform.cpp
//  pinlegame
//
//  Created by Kennedy on 16/5/16.
//
//

#include "PinLe_platform.hpp"
#include "PluginHelper.h"
PinLe_platform::PinLe_platform()
{
}

PinLe_platform::~PinLe_platform()
{

}


void PinLe_platform::getCity()
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
            LocPlay::getInstance()->setProvince(last_all);
            GAMELOG("111 %s",last_all.c_str());
            
        }
        if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getLocationString", "(I)Ljava/lang/String;"))
        {
            
            jstring channel = (jstring)t.env->CallStaticObjectMethod (t.classID, t.methodID,1);
            last_all=JniHelper::jstring2string(channel);
            LocPlay::getInstance()->setIs_iphone(false);
            LocPlay::getInstance()->setCity(last_all);
            GAMELOG("222 %s",last_all.c_str());
        }
        if (JniHelper::getStaticMethodInfo(t, CLASS_NAME, "getLocationString", "(I)Ljava/lang/String;"))
        {
            jstring channel = (jstring)t.env->CallStaticObjectMethod (t.classID, t.methodID,2);
            last_all=JniHelper::jstring2string(channel);
            LocPlay::getInstance()->setConty(last_all);
            GAMELOG("333 %s",last_all.c_str());
        }
    }
#endif
    
//    GAMELOG("getCoordinate longitude2222222 = %s, ", last_all.c_str());
}