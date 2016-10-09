--
-- Author: peter
-- Date: 2016-10-08 11:08:51
--
-----------------------------------------------------
--日期：3013-12-31
--作者：Mr.Wu
--QQ：351189069
--E-Mail:351189069@qq.com 
--如有招聘程序，欢迎骚扰作者
----------------------------------------------------
-- require "AudioEngine"

local HitVolesLayer = class("HitVolesLayer", function()
    return display.newLayer("HitVolesLayer")
end)
--分数标签
local kTagSprite1 = 1
--分数
local kTagSprite2 = 2
--地鼠
local kTagSprite3 = 3
--锤子
local kTagSprite4 = 4
--金币
local kTagSprite5 = 5

local scene1 = nil 
local scene2 = nil 
local scene3 = nil
local pic = "menuitemsprite.png"
local flag = 1
local loadResource = false

local visibleSize = cc.Director:getInstance():getVisibleSize()
local origin = cc.Director:getInstance():getVisibleOrigin()
local scheduler = cc.Director:getInstance():getScheduler()
local s = cc.Director:getInstance():getWinSize()

local schedulHandle = nil 

--农场背景层
local layerFarm = nil
--游戏层，包括人物，地鼠，锤子
local layerPlay = nil
--显示分数层
local layerScore= nil


-- -- for CCLuaEngine traceback
 function __G__TRACKBACK__(msg)
     print("----------------------------------------")
     print("LUA ERROR: " .. tostring(msg) .. "\n")
     print(debug.traceback())
     print("----------------------------------------")
     print("")
 end

 local function checkClision(x,y)
      local sVole = layerPlay:getChildByTag(kTagSprite3)
      dump(layerPlay)
      local sHammer = layerPlay:getChildByTag(kTagSprite4)
      -- local rectVole = sVole:boundingBox()
      -- local rectHammer = sHammer:boundingBox()


local rect   = sVole:getBoundingBox()

local rect1   = sHammer:getBoundingBox()

        if cc.rectContainsPoint(rect, rect1) then

print("碰撞")

      --if rectVole:intersectsRect(rectHammer) then
          coinAction(x,y)
          return true
      else
          return false
      end
 end

 -------------------------------------------------------------
--lable分数标签
local LabelAtlasTest = {}
LabelAtlasTest.layer = nil
LabelAtlasTest.__index = LabelAtlasTest
local m_time = 0

function LabelAtlasTest.step()
    m_time = m_time + 1
    local string = string.format("Score:")

    local label1_origin = LabelAtlasTest.layer:getChildByTag(kTagSprite1)
    local label1 = tolua.cast(label1_origin, "CCLabelAtlas")
    label1_origin:setString("Score:")    --

    local label2_origin = LabelAtlasTest.layer:getChildByTag(kTagSprite2)
    local label2 = tolua.cast(label2_origin, "CCLabelAtlas")
    string = string.format("%d", m_time)

    label2_origin:setString(string)
end

function LabelAtlasTest.onNodeEvent(tag)
    if tag == "exit" then
        LabelAtlasTest.layer:unscheduleUpdate()
    end
end

function LabelAtlasTest.create()
    m_time = 0
    local layer = cc.Layer:create()
    --Helper.initWithLayer(layer)
    LabelAtlasTest.layer = layer

    local label1 = cc.LabelAtlas:_create("Score:", "fonts/tuffy_bold_italic-charmap.plist")
    layer:addChild(label1, 0, kTagSprite1)
    label1:setPosition( cc.p(origin.x+s.width/100 ,s.height-s.height/10))
    label1:setColor(cc.c3b(255, 0, 0))
    --label1:setOpacity( 200 )

    local label2 = cc.LabelAtlas:_create("0", "fonts/tuffy_bold_italic-charmap.plist")
    layer:addChild(label2, 0, kTagSprite2)
    label2:setPosition( cc.p(origin.x+s.width/100 * 40 ,s.height-s.height/10))
    label2:setColor(cc.c3b(0, 0, 255))
    --label2:setOpacity( 32 )

    --layer:scheduleUpdateWithPriorityLua(LabelAtlasTest.step, 0)

    ---Helper.titleLabel:setString("LabelAtlas")
    ---Helper.subtitleLabel:setString("Updating label should be fast")

    layer:registerScriptHandler(LabelAtlasTest.onNodeEvent)
    return layer
end

--------------------------------------------------------------

--function of load music
local function loadMusic(music_name)
    local bkMusicPath = cc.FileUtils:getInstance():fullPathForFilename(music_name)
    --local volum = AudioEngine.getMusicVolume()
    --print(volum)
    --AudioEngine.setMusicVolume(volum/2)



    --xin  AudioEngine.playMusic(bkMusicPath,true)
end

local function playMusicHit(music_name)
    local bkMusicPath = cc.FileUtils:getInstance():fullPathForFilename(music_name)
      --xin  AudioEngine.playEffect(bkMusicPath)
end

local function removeMusic(music_name)
    local bkMusicPath = cc.FileUtils:getInstance():fullPathForFilename(music_name)
      --xin  AudioEngine.stopMusic(true)
end

local function createFarmLayer()
    layerFarm = cc.Layer:create()
    local spriteFarm = cc.Sprite:create("farm.jpg")
    --spriteFarm:setScale(0.5)
    spriteFarm:setRotation(0)
    spriteFarm:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
    layerFarm:addChild(spriteFarm)

    --load land to farm
    -- for i=1,2 do
    --     for j=1,2 do
    --        -- print(i)
    --         local spriteLand = CCSprite:create("land.png")
    --         spriteLand:setPosition(origin.x+visibleSize.width/i+visibleSize.width / 10 * j,origin.y+visibleSize.height/j+visibleSize.height / 10 * j)
    --         --spriteLand:setPosition(200 + j * 180 - i % 2 * 90, 10 + i * 95 / 2+140)
    --         layerFarm:addChild(spriteLand)
    --     end
    -- end

    return layerFarm
end



--function of ceate playlayer
local function createPlayLayer()
    layerPlay = cc.Layer:create()

    local menue = cc.Menu:create()
    menue:setPosition(cc.p(s.width-50,s.height/10))
    layerPlay:addChild(menue)

        -- Font Item
    --local  spriteNormal = CCSprite:create(pic, CCRectMake(0,23*2,115,23))
    local  spriteNormal = cc.Sprite:create("back_normal.png")
    local  spriteSelected = cc.Sprite:create("back_select.png")
    local  spriteDisabled = cc.Sprite:create("back_normal.png")

    local  item1 = cc.MenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
    item1:registerScriptTapHandler(backMenuCallback)

    menue:addChild(item1)

    local function onTouchEnded(x, y)
        local s = layerPlay:getChildByTag(kTagSprite4)
        --s:stopAllActions()
        hammerAction(x,y)
        --fuck()
        --检测锤子和地鼠的碰撞
        if checkClision(x,y) then
            --分数累加
            print("已经检测出碰撞  分数增加")
            LabelAtlasTest.step()
        end
        
        --print("ontouch XXXXXXXXXX")
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return true
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
        end
    end

    layerPlay:setTouchEnabled(true)
    layerPlay:registerScriptTouchHandler(onTouch)


    local spriteboy = cc.Sprite:create("animation/grossini.png")
    spriteboy:setPosition(origin.x + visibleSize.width / 8, origin.y + (visibleSize.height / 3)*2)
    spriteboy:setScale(0.5)

    local spritegirl = cc.Sprite:create()
    spritegirl:setPosition(origin.x + (visibleSize.width / 8)*7, origin.y + visibleSize.height / 2 )

    local spriteVole = cc.Sprite:create()
    --spriteVole:setPosition(origin.x + (visibleSize.width / 3)*2, origin.y + visibleSize.height / 3)
    local spriteHammer = cc.Sprite:create()  
    local spriteCoins = cc.Sprite:create()

    layerPlay:addChild(spriteboy)
    layerPlay:addChild(spritegirl)
    --layerPlay:addChild(spriteVole)
    layerPlay:addChild(spriteVole, 0, kTagSprite3)
    layerPlay:addChild(spriteHammer, 0, kTagSprite4)
    layerPlay:addChild(spriteCoins, 0, kTagSprite5)
    --layerPlay:setPosition(origin.x,origin.y)

    --创建动画序列
    local animation = cc.Animation:create()
    local number,name
    for i=1,14 do
      if i <10 then
        number="0"..i
      else
        number = i 
      end 
      name = "animation/grossini_dance_"..number..".png"
      animation:addSpriteFrameWithFile(name)
    end

    animation:setDelayPerUnit(2.8/14.0)
    animation:setRestoreOriginalFrame(true)

    --创建动作
    local animate = cc.Animate:create(animation)

    --创建执行序列
    local action = cc.Sequence:create(animate,animate:reverse())

    --附加行为方式
    local perform = cc.RepeatForever:create(action)

    --run
    spriteboy:runAction(perform)

    --------------------------------------
    local cache = cc.AnimationCache:getInstance()
    cache:addAnimations("animations-2.plist")
    local animation2 = cache:getAnimation("dance_1")

    local action2 = cc.Animate:create(animation2)
    spritegirl:runAction(cc.RepeatForever:create(cc.Sequence:create(action2, action2:reverse())))
    -------------------------------------------------------------------
    --附加行为方式
   -- local perform3 = CCRepeatForever:create(action3)

    --run
    --spriteVole:runAction(perform3)

    schedulHandle = scheduler:scheduleScriptFunc(callback, 2.0, false)

    return layerPlay
end

local function createScoreLayer()
    return LabelAtlasTest.create()
end

--地鼠钻地动画定时器回调函数
function callback(dt)
    local animation3 = cc.Animation:create()

    local number2,name2
    for i=0,4 do
      number2 = i
      name2= "laoshu_"..number2..".png"
      animation3:addSpriteFrameWithFile(name2)
    end

    animation3:setDelayPerUnit(1.0/5.0)
    animation3:setRestoreOriginalFrame(true)

    --创建动作
    local animate3 = cc.Animate:create(animation3)
 
    --创建执行序列
    local action3 = cc.Sequence:create(animate3,animate3:reverse())

    local node = layerPlay:getChildByTag(kTagSprite3)
    local randomWidth = math.random(visibleSize.width)
    local randomHeight = math.random(visibleSize.height)
    node:setPosition(origin.x+randomWidth,origin.y+randomHeight/2)
    --print(origin.x+randomWidth,origin.y+randomHeight/2)
    --print(visibleSize.width,visibleSize.height)
    
    node:runAction(action3)
end
--
--金币动画
function coinAction(x,y)
        --创建动画序列
    local animation = cc.Animation:create()
    local number,name
    for i=0,2 do
      number = i 
      name = "jinbi_"..number..".png"
      animation:addSpriteFrameWithFile(name)
    end

    animation:setDelayPerUnit(0.5/3.0)
    animation:setRestoreOriginalFrame(true)

    --创建动作
    local animate = cc.Animate:create(animation)

    --创建执行序列
    local action = cc.Sequence:create(animate,animate:reverse())

    --附加行为方式
    --local perform = CCRepeatForever:create(action)

    local node = layerPlay:getChildByTag(kTagSprite5)

    node:setPosition(x,y)

    --run
    node:runAction(action)
    playMusicHit("hit.mp3")
end

--锤子动画函数
function hammerAction(x,y)
    --创建动画序列
    local animation = cc.Animation:create()
    local number,name
    for i=0,2 do
      number = i 
      name = "chuizi_"..number..".png"
      animation:addSpriteFrameWithFile(name)
    end

    animation:setDelayPerUnit(0.3/3.0)
    animation:setRestoreOriginalFrame(true)

    --创建动作
    local animate = cc.Animate:create(animation)

    --创建执行序列
    local action = cc.Sequence:create(animate,animate:reverse())

    --附加行为方式
    --local perform = CCRepeatForever:create(action)

    local node = layerPlay:getChildByTag(kTagSprite4)

    node:setPosition(x,y)

    --run
    node:runAction(action)

end



local function createGameScene()
    -- 防止内存泄露
    collectgarbage("setpause",100)
    collectgarbage("setstepmul",5000)

    --加载背景音乐
    loadMusic("background.mp3")

    local mainScene = cc.Scene:create()

    --添加背景层到场景
    mainScene:addChild(createFarmLayer())
    --添加精灵动画层到场景
    mainScene:addChild(createPlayLayer())
    --添加分数层到场景
    mainScene:addChild(createScoreLayer())

    return mainScene

end

-----------------------------------------------------------------------------------------
 function HitVolesLayer:ctor()
    print("kkkk1")
    --scene1 = cc.Scene:create()
    local layer = cc.Layer:create()
    local sprite = cc.Sprite:create("start_background.png")
    sprite:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
    layer:addChild(sprite)
    --local bgLayer = CCLayerColor:create(ccc4(0,0,255,255))
    --layer:addChild(bgLayer, -1)
    local menueStart = cc.Menu:create()
    layer:addChild(menueStart)

    

        -- Font Item
    --local  spriteNormal = CCSprite:create(pic, CCRectMake(0,23*2,115,23))
    local  spriteNormal = cc.Sprite:create("start_normal.png")
    local  spriteSelected = cc.Sprite:create("start_select.png")
    local  spriteDisabled = cc.Sprite:create("start_end.png")

    local  item1 = cc.MenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
    item1:registerScriptTapHandler(menuStartCallback)

    menueStart:addChild(item1)

    
    menueStart:setPosition(cc.p(s.width/2, s.height/2))
    --------------------------------------------------------------
    local menueQuit = cc.Menu:create()
    layer:addChild(menueQuit)
    spriteNormal = cc.Sprite:create("quit_normal.png")
    spriteSelected = cc.Sprite:create("quit_select.png")
    spriteDisabled = cc.Sprite:create("quit_select.png")

    item1 = cc.MenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
    item1:registerScriptTapHandler(menuQuitCallback)
    menueQuit:addChild(item1)
    menueQuit:setPosition(cc.p(s.width/2, s.height/2-200))
    ------------------------------------------------------------------
    local menueAbout = cc.Menu:create()
    layer:addChild(menueAbout)
    spriteNormal = cc.Sprite:create("about_normal.png")
    spriteSelected = cc.Sprite:create("about_select.png")
    spriteDisabled = cc.Sprite:create("about_select.png")

    item1 = cc.MenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
    item1:registerScriptTapHandler(menuAboutCallback)
    menueAbout:addChild(item1)
    menueAbout:setPosition(cc.p(s.width/2, s.height/2-100))



    self:addChild(layer)
    --return scene1
end

local function createScene2()
    return createGameScene() 
end

local function createScene3()
    scene3 = cc.Scene:create()
    local layer = cc.Layer:create()
    local sprite = cc.Sprite:create("about.png")
    sprite:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
    layer:addChild(sprite)
    --local bgLayer = CCLayerColor:create(ccc4(0,0,255,255))
    --layer:addChild(bgLayer, -1)
    local menue = cc.Menu:create()
    menue:setPosition(cc.p(s.width-50,s.height/10))
    layer:addChild(menue)

        -- Font Item
    --local  spriteNormal = CCSprite:create(pic, CCRectMake(0,23*2,115,23))
    local  spriteNormal = cc.Sprite:create("back_normal.png")
    local  spriteSelected = cc.Sprite:create("back_select.png")
    local  spriteDisabled = cc.Sprite:create("back_normal.png")

    local  item1 = cc.MenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
    item1:registerScriptTapHandler(backMenuCallback)

    menue:addChild(item1)

    scene3:addChild(layer)

    return scene3
end

function translateScene()
    --local scene = nextAction()
    local scene = nil 
    if flag == 1 then
        scene = createScene2()
        --flag = 2
        loadResource = true
        scene = cc.TransitionFadeTR:create(1.2, scene)
    elseif flag == 2 then
        scene = createScene1()
        --flag = 1
        if loadResource then
            scheduler:unscheduleScriptEntry(schedulHandle)
            removeMusic("background.mp3") 
        end

        scene = cc.TransitionShrinkGrow:create(1.2, scene)
    elseif flag == 3 then
        scene = createScene3()
        --flag = 1
        scene = cc.TransitionProgressRadialCCW:create(1.2, scene)
    end
    
    cc.Director:getInstance():replaceScene(scene)
end

function menuStartCallback(sender)
    --print("XXXXXXXXXXXXXXXXXXXX")
    flag = 1
    translateScene()
end
function menuQuitCallback(  )
    cc.Director:getInstance():endToLua() 
end

function menuAboutCallback(  )
    flag = 3
    translateScene() 
end

function backMenuCallback()
    flag = 2
    translateScene()
end


-- function HitVoles:ctor()
--     local scene = createScene1()
--     cc.Director:getInstance():runWithScene(scene)
-- end

 --xpcall(Enter, __G__TRACKBACK__)
return  HitVolesLayer
