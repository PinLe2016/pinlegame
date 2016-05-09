//
//  LaoHuJiDonghua.hpp
//  pinlegame
//
//  Created by Kennedy on 16/5/6.
//
//

#ifndef LaoHuJiDonghua_h
#define LaoHuJiDonghua_h

#include <stdio.h>
#include "cocos2d.h"
using namespace std;
USING_NS_CC;

class LaoHuJiDonghua : public cocos2d::Layer
{
public:
    LaoHuJiDonghua();
    ~LaoHuJiDonghua();
    CREATE_FUNC(LaoHuJiDonghua);
    virtual     bool init();
    
    std::string helloMsg();
public:
    void        setDate(const string& spritFileName, const string& spriteItemName, const int& itemNumber, const Vec2& vec, const string& backSpriteName = "");
    void        startGo();
    void        stopGo(int num);
    void        setStartSpeed(float ft);
    void        setMaxtSpeed(float ft);
    
    
    
private:
    void        updateTime(float ft);
    void        setNumberVector();
    void        setSlowStepVer(float num, int cont);
    
    void        addSpriteData(const string& itemSpriteName, const int& itemNumber);
    void        scheduleUpdate(float ft);
    
    vector<Label*> numberVer;
    vector<Sprite*> itemVer;
    ClippingNode* clipnode;
    
    bool    nowSlowDown;
    bool    nowSlowDown1;
    int     stopNumber;             //最终停止的数字
    vector<float>   slowStepVer;    //减速时每一次移动的距离
    float       startSpeed;         //开始速度
    float       maxSpeed;           //最大速度
    float       addSpeedDistance;   //加速间隔
    float       updateDistance;     //加速定时器时间间隔
    int         slowStepNumber;     //减速的步数
    float       clipNodeWidth;      //
    float       clipNodeHeight;     //
    int         movePositionDistance;   //间隔多久移动位置
    int         moveNum;
    
    
    
    
};

#endif /* LaoHuJiDonghua_hpp */
