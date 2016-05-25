//
//  UM_Share.cpp
//  pinlegame
//
//  Created by Kennedy on 16/5/19.
//
//

#include "UM_Share.hpp"
#include "Cocos2dx/Common/CCUMSocialSDK.h"
#include "Cocos2dx/ShareButton/UMShareButton.h"

USING_NS_UM_SOCIAL;

UM_Share::UM_Share()
{
}
UM_Share::~UM_Share()
{
}

bool UM_Share::init()
{
    if ( !Layer::init() )
    {
        return false;
    }

    // 创建分享按钮, 参数1为按钮正常情况下的图片, 参数2为按钮选中时的图片,参数3为友盟appkey, 参数4为分享回调
    //"res/cre/main_bar.png","res/cre/main_bar.png"
    UMShareButton *shareButton =UMShareButton::create("res/cre/main_bar.png","res/cre/main_bar.png", "573c1df5e0f55afa04001f9f",NULL);
    // 显示在友盟分享面板上的平台
    vector<int>* platforms = new vector<int>();
//    platforms->push_back(SINA);
//    platforms->push_back(RENREN) ;
//    platforms->push_back(DOUBAN) ;
//    platforms->push_back(QZONE) ;
//    platforms->push_back(QQ) ;
    platforms->push_back(WEIXIN);
    platforms->push_back(WEIXIN_CIRCLE);
    // 设置友盟分享面板上显示的平台
    shareButton->setPlatforms(platforms);
    // 设置文本分享内容
    shareButton->setShareContent("刘可是个屁妞。。。") ;
    // 设置要分享的图片, 图片支持本地图片和url图片, 但是url图片必须以http://或者https://开头
    shareButton->setShareImage("res/CSres/main/MainUI/main_bar.png") ;
    // 设置按钮的位置
    shareButton->setPosition(ccp(150, 180));
    // 然后开发者需要将该按钮添加到游戏场景中
    CCMenu* pMenu = CCMenu::create(shareButton, NULL);
    pMenu->setPosition(CCPointZero);
    this->addChild(pMenu, 1);
    
    // ********************** 设置平台信息 ***************************
     CCUMSocialSDK *sdk = shareButton->getSocialSDK();
    // sdk->setQQAppIdAndAppKey("设置QQ的app id", "appkey");
     sdk->setWeiXinAppInfo("wx9389b5e4d6e62685","d99360c9e13c53207f20f786a6902587");
    // sdk->setYiXinAppKey("设置易信和易信朋友圈的app id");
    // sdk->setLaiwangAppInfo("设置来往和来往动态的app id",
    //                  "设置来往和来往动态的app key", "我的应用名");
    // sdk->setFacebookAppId("你的facebook appid");
    // 设置用户点击一条图文分享时用户跳转到的目标页面, 一般为app主页或者下载页面
    // sdk->setTargetUrl("http://www.umeng.com/social");
    //     // 打开或者关闭log
    // sdk->setLogEnable(true) ;
    // **********************   END ***************************
    return true;
}

//void UM_Share::shareCallback(int platform, int stCode, string& errorMsg)
//{
//    if ( stCode == 100 )
//    {
//        CCLog("#### HelloWorld 开始分享");
//    }
//    else if ( stCode == 200 )
//    {
//        CCLog("#### HelloWorld 分享成功");
//    }
//    else
//    {
//        CCLog("#### HelloWorld 分享出错");
//    }
//    
//    CCLog("platform num is : %d.", platform);
//}

