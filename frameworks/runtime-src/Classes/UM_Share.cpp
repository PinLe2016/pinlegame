//
//  UM_Share.cpp
//  pinlegame
//
//  Created by Kennedy on 16/5/19.
//
//

#include "UM_Share.hpp"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    #include "C2DXShareSDK.h"
    using namespace cn::sharesdk;
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    #include "Cocos2dx/Common/CCUMSocialSDK.h"
    #include "Cocos2dx/ShareButton/UMShareButton.h"
    USING_NS_UM_SOCIAL;
#endif

USING_NS_CC;

UM_Share::UM_Share()
{
}
UM_Share::~UM_Share()
{
}
UM_Share* UM_Share::createWithShare(string sharePicPath)
{
    
    UM_Share* layer=new UM_Share();
    if(layer)
    {
        layer->initWithShare(sharePicPath);
        layer->autorelease();
        return layer;
    }
    return NULL;
}

bool UM_Share::initWithShare(string sharePicPath)
{
    if ( !Layer::init() )
    {
        return false;
    }
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
        shareWithAndroid(sharePicPath);
    
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    
        shareWithIos(sharePicPath);
    
#endif

    return true;
}

void UM_Share::shareWithIos(string sharePicPath)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    // 创建分享按钮, 参数1为按钮正常情况下的图片, 参数2为按钮选中时的图片,参数3为友盟appkey, 参数4为分享回调
    //"res/cre/main_bar.png","res/cre/main_bar.png"
    UMShareButton *shareButton =UMShareButton::create("res/cre/main_bar.png","res/cre/main_bar.png", "573c1df5e0f55afa04001f9f",NULL);
    // 显示在友盟分享面板上的平台
    vector<int>* platforms = new vector<int>();
    
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
#endif
}


void UM_Share::shareWithAndroid(string sharePicPath)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    __Dictionary *content = __Dictionary::create();
    //Dictionary可用的Key如下，如果需要用到其它字段，可自行参考Sample中的代码实现：
    // (并不是所有平台都有这些字段，需要参考文档http://wiki.mob.com/Android_%E4%B8%8D%E5%90%8C%E5%B9%B3%E5%8F%B0%E5%88%86%E4%BA%AB%E5%86%85%E5%AE%B9%E7%9A%84%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E)

    //    content -> setObject(String::create("王二狗"), "content"); //要分享的内容，注意在文档中content对应的是text字段
    content -> setObject(String::create(sharePicPath), "image"); //可以是本地路径（如：/sdcard/a.jpg）或是一个URL
    content -> setObject(String::create("拼乐游戏"), "title");
    content -> setObject(String::create("这是一款赚钱的游戏"), "description");
        content -> setObject(String::create("http://sharesdk.cn"), "url");
    content -> setObject(String::createWithFormat("%d", C2DXContentTypeNews), "type");
        content -> setObject(String::create("http://sharesdk.cn"), "siteUrl");
    content -> setObject(String::create("拼乐Game"), "site");
    //    content -> setObject(String::create("http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"), "musicUrl");
    content -> setObject(String::create("extInfo"), "extInfo"); //微信分享应用时传给应用的附加信息
    C2DXShareSDK::showShareMenu(NULL, content, cocos2d::Point(100, 100), C2DXMenuArrowDirectionLeft, NULL);
#endif
}
void UM_Share::shareMenuItemClick(cocos2d::Ref * pSender)
{
       //    C2DXShareSDK::showShareView(C2DXPlatTypeSinaWeibo, content, shareResultHandler);
}
//void shareResultHandler(C2DXResponseState state, C2DXPlatType platType, __Dictionary *shareInfo, __Dictionary *error)
//{
//    CCLog("shareResultHandler");
//    switch (state) {
//        case C2DXResponseStateSuccess:
//            C2DXShareSDK::toast("分享成功");
//            break;
//        case C2DXResponseStateFail:
//            C2DXShareSDK::toast("分享失败");
//            break;
//        default:
//            C2DXShareSDK::toast("分享取消");
//            break;
//    }
//}
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

