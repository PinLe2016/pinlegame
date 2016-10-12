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
      local sVole = mainScene.yangtu  --layerPlay:getChildByTag(kTagSprite3)
      --dump(layerPlay)
      local sHammer = layerPlay:getChildByTag(kTagSprite4)
      -- local rectVole = sVole:boundingBox()
      -- local rectHammer = sHammer:boundingBox()


local rect   = sVole:getBoundingBox()

local rect1   = sHammer:getBoundingBox()

        if cc.rectContainsPoint(rect, rect1) then

--print("碰撞")

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
            --分数累加
            print("已经检测出碰撞  分数增加")
            LabelAtlasTest.step()
        end
        
        --print("ontouch XXXXXXXXXX")
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
        	print("---", x, y)
            return true
        elseif eventType == "ended" then
        local hight_=cc.pGetDistance(cc.p(0,y), cc.p(0,0))
        local off_y=math.cos(math.rad(65))*hight_ 
        local width_=cc.pGetDistance(cc.p(x,0), cc.p(0,0))
        local off_x=math.cos(math.rad(65))*width_ 
         print("222---", off_x)
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
    spriteHammer:setAnchorPoint(cc.p(0.5,1))

    local spriteCoins = cc.Sprite:create()

    -- layerPlay:addChild(spriteboy)
    -- layerPlay:addChild(spritegirl)
    --  以上两个已删除   
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
	--donghua:setVisible(false)
	--donghua:setScale(1.2, 1.2)
	local fragment_sprite = display.newSprite("png/Dmakuang.png")
	 fragment_sprite:setColor(cc.c3b(math.random(250),math.random(250),math.random(250)))
	-- fragment_sprite:setScaleX(0.703)
	-- fragment_sprite:setScaleY(0.703)
	--fragment_sprite:setRotation(45)

	--local fragment_sprite = cc.MotionStreak:create(1.0, 20, 250.0, cc.c3b(255, 255, 0), "png/Dmakuang.png")
            -- streak:setPosition(cc.p(200,300))
            -- mainScene:addChild(streak,20)  --donghua:getPositionX()-45,donghua:getPositionY()-45


	fragment_sprite:setContentSize(donghua:getContentSize().width,donghua:getContentSize().height)
	fragment_sprite:setScale(0.5)
	fragment_sprite:setAnchorPoint(0.3, 0.3)
	fragment_sprite:setPosition(cc.p(donghua:getPositionX()-5,donghua:getPositionY()-5))
	mainScene:addChild(fragment_sprite,-11)

            local move = cc.MoveTo:create(2, cc.p(fragment_sprite:getPositionX()-45,fragment_sprite:getPositionY()-45))
	local function CallFucnCallback4(sender)
	    fragment_sprite:setVisible(false)
	end
	local moveBack = cc.MoveTo:create(2, cc.p(fragment_sprite:getPositionX(),fragment_sprite:getPositionY()))
	local seq = cc.Sequence:create(move,moveBack,cc.CallFunc:create(CallFucnCallback4))
	fragment_sprite:runAction(seq)

	local move = cc.MoveTo:create(2, cc.p(donghua:getPositionX()-45,donghua:getPositionY()-45))
	local function CallFucnCallback3(sender)
	    donghua:setScale(1, 1)
	end
	local moveBack = cc.MoveTo:create(2, cc.p(donghua:getPositionX(),donghua:getPositionY()))
	local seq = cc.Sequence:create(move,moveBack,cc.CallFunc:create(CallFucnCallback3))
	donghua:runAction(seq)



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
	    --  地鼠随机出动的位置
	    local randomWidth = math.random(visibleSize.width)
	    local randomHeight = math.random(visibleSize.height)

	    node:setPosition(origin.x+randomWidth,origin.y+randomHeight/2)
	    --print(origin.x+randomWidth,origin.y+randomHeight/2)
	    --print(visibleSize.width,visibleSize.height)
	    node:setVisible(false)
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


     -- local action = cc.Sequence:create(
     --    cc.MoveBy:create(2, cc.p(200,0)),
     --    cc.CallFunc:create(doRemoveFromParentAndCleanup,{true}))

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
    -- mainScene:addChild(createScoreLayer())
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


 --xpcall(Enter, __G__TRACKBACK__
 function HitVolesLayer:refresh_table()
--  新增加
 	self.row=3
 	self.col=4
 	self.point=cc.p(57,100)
 	
 	 -- cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION3_D);
   --    self:setRotation3D({x=-30,y=0,z=0})

    -- local row_rand=self:RandomIndex(self.row,self.row)
    -- local col_rand=self:RandomIndex(self.col,self.col)

    local pos_x, pos_y =self.point.x,self.point.y
    local row ,col =self.row,self.col 
     local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"


    local cache = cc.Director:getInstance():getTextureCache():addImage("HitVoles/kkkkk.jpg")
    local layer=cc.Layer:create()
    layer:setScale(0.85)--(0.703)
    layer:addTo(self)
   for i=1,row do
        for j=1,col do
                -- local fragment_sprite = display.newScale9Sprite(path..self.filename, 0,0, cc.size(self._size.width,self._size.height))
                local fragment_sprite = cc.Sprite:create()
                
                --fragment_sprite:setRotation(45)
                fragment_sprite:setAnchorPoint(0, 0)

                --新增加
                local po={}
             	po.width=750
             	po.height=1000
            	self.content_size=po
            	

                local rect = cc.rect((i-1)*self.content_size.width/row, (j-1)*self.content_size.height/col, self.content_size.width/row-3, self.content_size.height/col-3)

                 fragment_sprite:setTexture(cache)
                 fragment_sprite:setTextureRect(rect)

                fragment_sprite:setPosition(-55+(i-1)*self.content_size.width/row, 400 +(3-j)*self.content_size.height/col)--设置图片显示的部分
                layer:addChild(fragment_sprite)
               
                -- clipnode:setTag(#self.fragment_table + 1)
                -- self.fragment_poins[#self.fragment_table + 1]=cc.p(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                 --self.fragment_table[#self.fragment_table + 1] = fragment_sprite

                  mainScene.fragment_table[#mainScene.fragment_table + 1] = fragment_sprite

                -- clipnode:setPosition(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                -- clipnode:setPosition(pos_x + (i-1)*po.width/row, pos_y + (j-1)*po.height/col)


                -- clipnode:setTouchEnabled(true)
                -- clipnode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                --                         --self:touch_event(clipnode,event)--监听回调
                --                         local position = cc.p(clipnode:getPosition())
                --                         local boundingBox = cc.rect(position.x, position.y, self.content_size.width/self.row, self.content_size.height/self.col) --getCascadeBoundingBox()方法获得的rect大小为整张图片的大小，此处重新计算图块的rect。

                --                         if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
                                                
                --                                 clipnode:setTouchSwallowEnabled(false)
                --                                 return false
                --                         end

                --                         if "began" == event.name then
                --                             print("22222222")
                --                                 clipnode:setTouchSwallowEnabled(false)--吞噬触摸，防止响应下层的图块。
                --                                 clipnode:setLocalZOrder(4)
                --                                 return true
                --                         elseif "moved" == event.name then
                --                               self:touch_event_move(event,clipnode)
                --                         elseif "ended" == event.name then
                --                                 self:touchEnd(event,clipnode)

                --                         end
                --             end)

                end

                 
       end  
end
 function HitVolesLayer:refresh_table1()
           --  新增加
     self.row=3
     self.col=4
    self.point=cc.p(57,100)
    local row_rand=self:RandomIndex(self.row,self.row)
    local col_rand=self:RandomIndex(self.col,self.col)

    local pos_x, pos_y =self.point.x,self.point.y
    local row ,col =self.row,self.col 
    local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
    for i=1,row do
         for j=1,col do
                -- local fragment_sprite = display.newScale9Sprite(path..self.filename, 0,0, cc.size(self._size.width,self._size.height))
                local fragment_sprite = display.newSprite("HitVoles/kkkkk.jpg")
                fragment_sprite:setScaleX(0.5)--(0.703)
                fragment_sprite:setScaleY(0.5)--(0.703)
                --fragment_sprite:setRotation(45)
                fragment_sprite:setAnchorPoint(0, 0)

                --新增加
                local po={}
 	    po.width=375--527.25
 	    po.height=500--703
	    self.content_size=po
	    print("款款  ",self.content_size.width)

                local rect = cc.rect(0,0, po.width/row-3, po.height/col-3)
                --创建一个裁剪区域用于裁剪图块
                local clipnode = cc.ClippingRegionNode:create()
                clipnode:setClippingRegion(rect)--设置裁剪区域的大小
                clipnode:setContentSize(self.content_size.width/row-3, self.content_size.height/col-3)
                clipnode:addChild(fragment_sprite)--添加图片
               -- fragment_sprite:setColor(cc.c3b(math.random(250),math.random(250),math.random(250)))

                -- clipnode:setAnchorPoint(0.5,0.5)
                fragment_sprite:setPosition(0 - (i-1)*self.content_size.width/row, 0 - (j-1)*self.content_size.height/col)--设置图片显示的部分
                self:addChild(clipnode)
               --赋值
                 clipnode:setTag(#mainScene.fragment_table + 1)
                -- self.fragment_poins[#self.fragment_table + 1]=cc.p(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                 mainScene.fragment_table[#mainScene.fragment_table + 1] = clipnode

                clipnode:setPosition(60 + (row_rand[i]-1)*po.width/row, 230 + (col_rand[j]-1)*po.height/col)
                --clipnode:setPosition(pos_x + (i-1)*po.width/row, pos_y + (j-1)*po.height/col)


                -- clipnode:setTouchEnabled(true)
                -- clipnode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                --                         --self:touch_event(clipnode,event)--监听回调
                --                         local position = cc.p(clipnode:getPosition())
                --                         local boundingBox = cc.rect(position.x, position.y, self.content_size.width/self.row, self.content_size.height/self.col) --getCascadeBoundingBox()方法获得的rect大小为整张图片的大小，此处重新计算图块的rect。

                --                         if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
                                                
                --                                 clipnode:setTouchSwallowEnabled(false)
                --                                 return false
                --                         end

                --                         if "began" == event.name then
                --                             print("22222222")
                --                                 clipnode:setTouchSwallowEnabled(false)--吞噬触摸，防止响应下层的图块。
                --                                 clipnode:setLocalZOrder(4)
                --                                 return true
                --                         elseif "moved" == event.name then
                --                               self:touch_event_move(event,clipnode)
                --                         elseif "ended" == event.name then
                --                                 self:touchEnd(event,clipnode)

                --                         end
                --             end)

                end
       end  
end




return  HitVolesLayer
