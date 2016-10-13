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

--打地鼠炸弹类型和时间
--score为-1 的情况是进度条倒计时相关，不计入实际加分项
local rand_Date =nil --记录选中容器数据
 local color_Mode={
    {color_type=cc.c3b(0, 0, 0),time=3,score=1},
    {color_type=cc.c3b(242, 21, 16),time=2,score=4},
    {color_type=cc.c3b(242, 16, 147),time=3,score=3},
    {color_type=cc.c3b(62, 12, 223),time=1,score=1},
    {color_type=cc.c3b(22, 155, 240),time=1.5,score=0},
    {color_type=cc.c3b(22, 240, 169),time=3.5,score=10},

    {color_type=cc.c3b(85, 240, 22),time=3,score=-1},
    {color_type=cc.c3b(240, 185, 22),time=-3,score=-1},
    {color_type=cc.c3b(242, 250, 8),time=-6,score=-1}
}
-- local color_Mode={}
-- color_Mode[1]={color_type=cc.cc.c3b(0, 0, 0),time=3,score=1}
    
    





 local function checkClision(x,y)
        local sVole = mainScene.yangtu  --layerPlay:getChildByTag(kTagSprite3)
        if not sVole then
          return
        end

        -- mainScene.yangtu=nil

        local sHammer = layerPlay:getChildByTag(kTagSprite4)
        -- local rectVole = sVole:boundingBox()
        -- local rectHammer = sHammer:boundingBox()


        local rect   = sVole:getBoundingBox()

        local rect1   = sHammer:getBoundingBox()

        if cc.rectContainsPoint(rect, rect1) then
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
    m_time = m_time +1
    local string = string.format("Score:")

    local label1_origin = LabelAtlasTest.layer:getChildByTag(kTagSprite1)
    local label1 = tolua.cast(label1_origin, "CCLabelAtlas")
    label1_origin:setString("Score:")    --

    local label2_origin = LabelAtlasTest.layer:getChildByTag(kTagSprite2)
    local label2 = tolua.cast(label2_origin, "CCLabelAtlas")
    dump(rand_Date["score"])

    string = string.format("%d",m_time )

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
    label1:setOpacity( 200 )

    local label2 = cc.LabelAtlas:_create("0", "HitVoles/fonts/tuffy_bold_italic-charmap.plist")
    layer:addChild(label2, 0, kTagSprite2)
    label2:setPosition( cc.p(origin.x+s.width/100 * 40 ,s.height-s.height/10))
    label2:setColor(cc.c3b(255, 0, 0))
    label2:setOpacity(200 )

    -- layer:scheduleUpdateWithPriorityLua(LabelAtlasTest.step, 0)

    -- Helper.titleLabel:setString("LabelAtlas")
    -- Helper.subtitleLabel:setString("Updating label should be fast")

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
    spriteFarm:setVisible(false)
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
    -- local  spriteNormal = cc.Sprite:create("back_normal.png")
    -- local  spriteSelected = cc.Sprite:create("back_select.png")
    -- local  spriteDisabled = cc.Sprite:create("back_normal.png")

    -- local  item1 = cc.MenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
    -- item1:registerScriptTapHandler(backMenuCallback)

    -- menue:addChild(item1)

    local function onTouchEnded(x,y,y1)
        local s = layerPlay:getChildByTag(kTagSprite4)
        --s:stopAllActions()
        hammerAction(x,y1)
        --fuck()
        --检测锤子和地鼠的碰撞
        if checkClision(x,y) then

             if rand_Date["score"]==-1 then --倒计时进度条+-时间相关

                     --写入倒计时进度条控制情况
        
                return
            end

            --分数累加
            print("已经检测出碰撞  分数增加")
            
            LabelAtlasTest.step()
        end
        
        --print("ontouch XXXXXXXXXX")
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
        	-- print("---", x, y)
            return true
        elseif eventType == "ended" then
        local hight_=cc.pGetDistance(cc.p(0,y), cc.p(0,0))
        local off_y=math.cos(math.rad(65))*hight_ 
        local width_=cc.pGetDistance(cc.p(x,0), cc.p(0,0))
        local off_x=math.cos(math.rad(65))*width_ 
         -- print("222---", off_x)
             return onTouchEnded(x+off_x/2,y,y+off_y)
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
    spriteHammer:setAnchorPoint(cc.p(0.5,1.0))

    local spriteCoins = cc.Sprite:create()

    -- layerPlay:addChild(spriteboy)
    -- layerPlay:addChild(spritegirl)
    --  以上两个已删除   
    --layerPlay:addChild(spriteVole)
    layerPlay:addChild(spriteVole, 0, kTagSprite3)
    layerPlay:addChild(spriteHammer, 0, kTagSprite4)
    layerPlay:addChild(spriteCoins, 0, kTagSprite5)


    schedulHandle = scheduler:scheduleScriptFunc(callback, 4.0, false)

    return layerPlay
end

local function createScoreLayer()
    return LabelAtlasTest.create()
end

--地鼠钻地动画定时器回调函数
function callback(dt)

	local donghua=mainScene.fragment_table[math.random(#mainScene.fragment_table)]
	-- dump(donghua)
	mainScene.yangtu=donghua

    rand_Date=color_Mode[math.random(9)]


	local fragment_sprite = display.newSprite("png/dadishu-1.png")

	fragment_sprite:setColor(rand_Date["color_type"])
	fragment_sprite:setScaleX(247/204)
	fragment_sprite:setScaleY(247/190)
    
	fragment_sprite:setAnchorPoint(0.0, 0.06)
	donghua:addChild(fragment_sprite)

	local function CallFucnCallback3(sender)
	    fragment_sprite:removeFromParent()
	end

     local rate=cc.RotateBy:create(0.5, {x=-5,y=0,z=0})--,

    local seq = cc.Sequence:create(rate,cc.DelayTime:create(rand_Date["time"]-1.0),rate:reverse(),cc.CallFunc:create(CallFucnCallback3))

    donghua:runAction(seq)

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
    --local action = cc.Sequence:create(animate,animate:reverse())

    --附加行为方式
    --local perform = CCRepeatForever:create(action)

    local node = layerPlay:getChildByTag(kTagSprite5)

    node:setVisible(true)
    local function logSprRotation(sender)
	node:setVisible(false)
   end


     local action = cc.Sequence:create(animate,animate:reverse(),cc.CallFunc:create(logSprRotation))



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
   

    --附加行为方式
    --local perform = CCRepeatForever:create(action)

    local node = layerPlay:getChildByTag(kTagSprite4)
    node:setVisible(true)
    local function logSprRotation(sender)
	node:setVisible(false)
    end
    local action = cc.Sequence:create(animate,animate:reverse(),cc.CallFunc:create(logSprRotation))

    node:setPosition(x,y)


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


    self:refresh_table()


    --添加精灵动画层到场景
    mainScene:addChild(createPlayLayer())
    --添加分数层到场景
    mainScene:addChild(createScoreLayer())

    return mainScene

end

-----------------------------------------------------------------------------------------
 function HitVolesLayer:ctor()
  
   
cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION3_D);
      self:setRotation3D({x=-25,y=0,z=0})	
 
     mainScene=self
     mainScene:addChild(createFarmLayer())
     mainScene.fragment_table={}
     self:refresh_table()

    --添加精灵动画层到场景
    mainScene:addChild(createPlayLayer())
    -- --添加分数层到场景
    mainScene:addChild(createScoreLayer())
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


 function HitVolesLayer:refresh_table()
--  新增加
 	self.row=3
 	self.col=4
 	self.point=cc.p(57,100)
 	

    local pos_x, pos_y =self.point.x,self.point.y
    local row ,col =self.row,self.col 
     local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"


    local cache = cc.Director:getInstance():getTextureCache():addImage("HitVoles/kkkkk.jpg")
    local layer=cc.Layer:create()
    layer:setScale(0.85)--(0.703)
    layer:addTo(self)
   for i=1,row do
        for j=1,col do
            local fragment_sprite = cc.Sprite:create()
            fragment_sprite:setAnchorPoint(0.5, 1)
            --新增加
            local po={}
            po.width=750
            po.height=1000
            self.content_size=po


            local rect = cc.rect((i-1)*self.content_size.width/row, (j-1)*self.content_size.height/col, self.content_size.width/row-3, self.content_size.height/col-3)
            fragment_sprite:setTexture(cache)
            fragment_sprite:setTextureRect(rect)

            fragment_sprite:setPosition(70+(i-1)*self.content_size.width/row, 550 +(3-j)*self.content_size.height/col)--设置图片显示的部分
            layer:addChild(fragment_sprite)


            mainScene.fragment_table[#mainScene.fragment_table + 1] = fragment_sprite

            end

                 
       end  
end
 



return  HitVolesLayer
