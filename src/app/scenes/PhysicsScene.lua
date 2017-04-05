--
-- Author: peter
-- Date: 2016-09-18 11:05:34
--
local PhysicsScene = class("PhysicsScene", function()
      return display.newPhysicsScene("PhysicsScene")
end)


local GRAVITY         = -2000
local COIN_MASS       = 6000 --质量
local COIN_RADIUS     = 9--半径
local COIN_RADIUS_tow     = 6--半径
local COIN_FRICTION   = 0.8--弹性系数
local COIN_FRICTION_tow   =0.8--弹性系数
local COIN_FRICTION_three   =0.5--弹性系数
-- local WALL_FRICTION   = 0.0--弹力
local WALL_THICKNESS  = 10--密度
local COIN_ELASTICITY = 0.15---摩擦力
local COIN_ELASTICITY_tow = 0.2---摩擦力
-- local WALL_ELASTICITY = 0.0--摩擦系数
--PhysicsMaterial 参数1、density（密度）2、restiution（弹性）3、friction（摩擦力）

local BOLL_OFF_SET=60--台球杆初始位置调整的偏移量

local is_Shots=false
local is_Down=true
local ROD_V=3.0
local ROD_B_POPINT=0--台球杆的初始高度
local ROD_E_POPINT=130+BOLL_OFF_SET--台球杆的初始高度
local ROD_M_TIME=0.05---台球杆的移动时间

local BOLL_S_V=2100---台球的初始速度



function PhysicsScene:pushFloating(text)
    if is_resource then
        self.floating_layer:showFloat(text)  
        
    else
        if self.barrier_bg then 
            self.barrier_bg:setVisible(false)
        end
        self.floating_layer:showFloat(text)
    end
end 

function PhysicsScene:push_buffer(is_buffer)

       self.floating_layer:show_http(is_buffer) 
       
end 
function PhysicsScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end

-- 倒计时
function PhysicsScene:fun_time(  )

      local node = cc.CSLoader:createNode("countdownLayer.csb")
      local action = cc.CSLoader:createTimeline("countdownLayer.csb")

      local advert =node:getChildByTag(590)  --  广告
        local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
      self._imagetu=Util:sub_str(list_table[1]["imgurl"], "/",":")
      local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
      advert:loadTexture(path..self._imagetu)

      action:setTimeSpeed(0.25)
      node:runAction(action)
      action:gotoFrameAndPlay(0,80,false)
      local function stopAction()
              if node then
                node:removeFromParent()
              end
      end
      local callfunc = cc.CallFunc:create(stopAction)
      node:runAction(cc.Sequence:create(cc.DelayTime:create(6),callfunc  ))
      self:addChild(node)

end
function PhysicsScene:ctor(params)
        --dump(params)
        self.heroid=params.heroid
        self.cycle=params.cycle
        self.id=params.id
        self.phyimage=params.phyimage
        self.actid=LocalData:Instance():get_actid()

        
        --防home键退出处理
        self.save_table={
          score=1111,
          cycle=params.cycle,
          actid=self.actid["act_id"]
      }
      
      -- io.writefile(cc.FileUtils:getInstance():getWritablePath() .."Physics.csv", TableToString(recv,true,true))
        --LocalData:Instance():set_getactivitypoints(nil)
        
    -- create touch layer
    -- self.layer = display.newLayer()
    -- self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     return self:onTouch(event.name, event.x, event.y)
    -- end)
    -- self:addChild(self.layer)


    -- display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    
       self:setNodeEventEnabled(true)--layer添加监听
       self.floating_layer = require("app.layers.FloatingLayer").new()
       self.floating_layer:addTo(self,100000)

    
    -- create label
    cc.ui.UILabel.new({text = "TAP SCREEN", size = 32, color = display.COLOR_WHITE})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    -- create physics world
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, GRAVITY))

    -- local leftWallSprite = display.newSprite("#Wall.png")
    -- leftWallSprite:setScaleY(display.height / WALL_THICKNESS)
    -- leftWallSprite:setPosition(display.left + WALL_THICKNESS / 2, display.cy + WALL_THICKNESS)
    -- self:addChild(leftWallSprite)

    -- local rightWallSprite = display.newSprite("#Wall.png")
    -- rightWallSprite:setScaleY(display.height / WALL_THICKNESS)
    -- rightWallSprite:setPosition(display.right - WALL_THICKNESS / 2, display.cy + WALL_THICKNESS)
    -- self:addChild(rightWallSprite)

    -- local bottomWallSprite = display.newSprite("#Wall.png")
    -- bottomWallSprite:setScaleX(display.width / WALL_THICKNESS)
    -- bottomWallSprite:setPosition(display.cx, display.bottom + WALL_THICKNESS / 2)
    -- self:addChild(bottomWallSprite)

    
    -- modeSprite:setPosition(x, y)

    local wallBox = display.newNode()
    wallBox:setAnchorPoint(cc.p(0.5, 0.5))
    wallBox:setPhysicsBody(
        cc.PhysicsBody:createEdgeBox(cc.size(display.width - WALL_THICKNESS*2, display.height - WALL_THICKNESS)))
    wallBox:setPosition(display.cx, display.height/2 + WALL_THICKNESS/2)

     

    -- self:addChild(wallBox)

    -- add debug node
    -- self:getPhysicsWorld():setDebugDrawMask(
    --     true and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
	


     --  碰撞监听  
    local conListener=cc.EventListenerPhysicsContact:create();  
    conListener:registerScriptHandler(function(contact)  
  
            -- print("---contact-碰撞了--")  
              
            --    处理游戏中精灵碰撞逻辑  
            local node1=contact:getShapeA():getBody():getNode()  
            local tag1=node1:getTag()  
            -- print("name1:",name1)  
            
  
            local node2=contact:getShapeB():getBody():getNode()  
            local tag2=node2:getTag()  
            -- print("name2:",name2)  --Physicshongqiu-xiao-liang
            local node=node1
            local body=contact:getShapeA():getBody()

            

            if tag1==255 or tag2==255 then --处理力度不够没有弹上去的情况

                -- self.rod_coinBody:setGravityEnable(false)
                -- dump(self.rod_spr:getPositionX())
                self.coinSprite:setPosition(self.rod_spr:getPositionX(),ROD_B_POPINT+225-BOLL_OFF_SET)
                self.start_bt:setTouchEnabled(true)

                cc.UserDefault:getInstance():setStringForKey("Physics",nil)
                -- Util:player_music("PHYSICS",false )
                return true
            end
            if tag1==1 then 
                node=node2
                body=contact:getShapeB():getBody()
            end
            
            local cal= cc.CallFunc:create(function() 
                Util:player_music("PHYSICS",false)
                node:loadTexture("png/Physicshongqiu-xiao.png")
            end )
           local seq=transition.sequence({cc.DelayTime:create(0.3),cal})--屏幕抖动
           node:stopAllActions()
           if  node:getTag()<10 then
               node:loadTexture("png/Physicshongqiu-xiao-liang.png") 
               node:runAction(seq)
           else
                Util:player_music("res/PHYSICS",false)
               body:setGravityEnable(true)
               self.score_spr=node
               cc.UserDefault:getInstance():setStringForKey("Physics",nil)
               self:fun_server()
           end
            
            return true  
    end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)  
  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(conListener,self) 
    self:add_ui(true)
    
end
function PhysicsScene:fun_server( )

    if self._score1~=0 then
      return
    end
      self._score1=self.score_spr:getTag()/10
      self.score2=math.random(9)
      self.score3=math.random(9)
      self.score4=math.random(9)
      if tonumber(self._score1)==9 then
        self.score4=math.random(5)
      end
      local  _score=  self._score1 ..   self.score4  ..   self.score2  ..   self.score3 
      Server:Instance():getactivitypoints(self.actid["act_id"],self.cycle,_score)
end
function PhysicsScene:_refresh( )
   local activitybyid=LocalData:Instance():get_getactivitybyid()
   --弹球最高得分
         self.bestscore_text=self.phy_bg:getChildByTag(1803)
        self.bestscore_text:setString(tostring(activitybyid["bestpoints"]))
        --弹球累计得分
        self.allscore_text=self.phy_bg:getChildByTag(1802)
        self.allscore_text:setString(tostring(activitybyid["mypoints"]))
        
        --  押注金币
        self._betgolds=self.phy_bg:getChildByTag(1799)  

        if tonumber(activitybyid["remaintimes"]) < 0 then
          self._betgolds:setString("/")
        else
          self._betgolds:setString("剩余弹珠次数:"   ..   activitybyid["remaintimes"]  )
        end
end

function PhysicsScene:add_ui(_istrue)

    self.phy_bg = cc.CSLoader:createNode("PhysicsLayer.csb");
    self:addChild(self.phy_bg)


    self._score1=0

    if _istrue then
      -- Server:Instance():getactivitybyid(self.id,self.cycle)  ---新加的2016、11、18  补签次数
      self:fun_time(  )--  倒计时
    end
    

        --弹球广告图
        local activitybyid=LocalData:Instance():get_getactivitybyid()
        local _imagename=self.phy_bg:getChildByTag(87)
        _imagename:loadTexture(self.phyimage)
       
       
    local sp_bg=self.phy_bg:getChildByTag(1791)
    local physics=Util:read_json("res/physics.json")

    local coinBody = cc.PhysicsBody:create()

    for i=1,#physics["physics"] do
        local ver={}
        for j=1,#physics["physics"][i] do
            local vers=physics["physics"][i][j]
            ver[j]=cc.p(vers[1]+17,vers[2]-137)
            
        end
        coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(ver))
    end

    coinBody:setMass(COIN_MASS)
    coinBody:setDynamic(false)
    sp_bg:setPhysicsBody(coinBody)

    --返回按钮
    local back_bt=self.phy_bg:getChildByTag(31)
     back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))

     --qidong
     self.start_bt=self.phy_bg:getChildByTag(1795)
     self.start_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))

    self.rod_spr=self.phy_bg:getChildByTag(27)--棒子
    self.rod_spr:setPositionY(BOLL_OFF_SET+self.rod_spr:getPositionY())
    -- self.rod_spr:setVisible(false)
    ROD_B_POPINT=self.rod_spr:getPositionY()--记录台球杆的初始高度

    -- dump(self.rod_spr:getPositionX())
     self.yangqiu=self.phy_bg:getChildByTag(1789)
     self.yangqiu:setVisible(false)
     dump(self.rod_spr:getPositionX())
    self:createCoin(self.rod_spr:getPositionX()+0,  ROD_B_POPINT+225-BOLL_OFF_SET)--小球

    self:add_obstacle()--障碍小球

    if _istrue then
      Server:Instance():getactivitybyid(self.id,self.cycle)  ---新加的2016、11、18  补签次数
      -- self:fun_time(  )--  倒计时
       --self:_refresh()
    else
      self:fun_data() 
    end


end


function PhysicsScene:add_obstacle()

    local modeSprite1 =self.phy_bg:getChildByTag(1790)
    local modeSprite2 =self.phy_bg:getChildByTag(1797)
    local modeSprite3 =self.phy_bg:getChildByTag(1796)

    --小球
	for i=0,10 do
		for j=0,7 do
		  local modeSprite=modeSprite1:clone()

			-- print("---fe ",math.floor(j%2))
            if (math.floor(j%2)==1 and i~=10) or math.floor(j%2)==0 then
                modeSprite:setPosition(modeSprite1:getPositionX()+(modeSprite2:getPositionX()-modeSprite1:getPositionX()-0.5)*i+20*math.floor(j%2),modeSprite1:getPositionY()-j*(modeSprite1:getPositionY()-modeSprite3:getPositionY()-2))
                modeSprite:setTag(2)

                self.phy_bg:addChild(modeSprite)
                local material=cc.PhysicsMaterial(WALL_THICKNESS, COIN_FRICTION_tow, COIN_ELASTICITY_tow)
                if j~=0 then
                    material=cc.PhysicsMaterial(WALL_THICKNESS, COIN_FRICTION_three, COIN_ELASTICITY_tow)
                end

                local coinBody=self:add_Rigidbody(material)
                modeSprite:setPhysicsBody(coinBody)
            end
			

		end
	end


    ---挡板
    local modeSprite_ban_1 =self.phy_bg:getChildByTag(1805)
    local modeSprite_ban_2 =self.phy_bg:getChildByTag(1806)

    local dangban=modeSprite_ban_1:clone()
    dangban:setRotation(90)
    dangban:setPosition(self.rod_spr:getPositionX(), self.rod_spr:getPositionY()+210-BOLL_OFF_SET)
    dangban:setOpacity(0)
    local material=cc.PhysicsMaterial(WALL_THICKNESS, 0, 500)
    local coinBody = cc.PhysicsBody:createBox(cc.size(8,35),
        material)
    coinBody:setContactTestBitmask(0x03)  
    coinBody:setDynamic(false)
    dangban:setPhysicsBody(coinBody)
    dangban:setTag(255)   
    self.phy_bg:addChild(dangban)


    for i=0,13 do
        local modeSprite=modeSprite_ban_1:clone()
        modeSprite:setTag(-2)
        self.phy_bg:addChild(modeSprite)
         modeSprite:setPosition(modeSprite_ban_1:getPositionX()-8+(modeSprite_ban_2:getPositionX()-modeSprite_ban_1:getPositionX())*i,modeSprite_ban_1:getPositionY())
         local material=cc.PhysicsMaterial(WALL_THICKNESS, 0, 0)
         local coinBody = cc.PhysicsBody:createBox(cc.size(8,35),
                material)
        coinBody:setDynamic(false)
        modeSprite:setPhysicsBody(coinBody)
    end
    modeSprite_ban_1:removeFromParent()
    modeSprite_ban_2:removeFromParent()


    --碰分小球
    local modeSprite_ban_3 =self.phy_bg:getChildByTag(1792)

    local arr_ball={8,7, 6, 5, 4, 3, 2, 1, 7, 6, 5, 4, 3, 2}
      for i=1,#arr_ball do
       self._randTable=self:RandomIndex(#arr_ball,#arr_ball) 
    end


    for i=0,14 do
        local modeSprite=modeSprite_ban_3:clone()
        self.phy_bg:addChild(modeSprite)
        if i == 0 then
             self._dt = 9
        else
             self._dt=arr_ball[self._randTable[i]]
        end
       
        modeSprite:loadTexture(string.format("png/Physicstaiqiu-%d.png", self._dt))--arr_ball[self._randTable[i+1]]))  --_randt))--
        modeSprite:setScale(0.27,0.27)
        modeSprite:setPosition(modeSprite_ban_3:getPositionX()-5+30*i,modeSprite_ban_3:getPositionY())
        modeSprite:setTag(self._dt*10)--(arr_ball[self._randTable[i+1]]*10)  --(_randt*10)--

         local material=cc.PhysicsMaterial(WALL_THICKNESS, 0, 0)
         local coinBody = cc.PhysicsBody:createCircle(8,
                material)
        coinBody:setMass(COIN_MASS)
        coinBody:setGravityEnable(false)
        -- coinBody:setDynamic(false)
        -- coinBody:setCategoryBitmask(0x03) --类别掩码 默认值为0xFFFFFFFF  
        coinBody:setContactTestBitmask(0x02) --接触掩码 默认值为 0x00000000

        modeSprite:setPhysicsBody(coinBody)
    end
    modeSprite_ban_3:removeFromParent()
  
end
--随机数
function PhysicsScene:RandomIndex(indexNum, tabNum)

    indexNum = indexNum or tabNum

    local t = {}

    local rt = {}

    for i = 1,indexNum do

        local ri = math.random(1,tabNum + 1 - i)

        local v = ri

        for j = 1,tabNum do

            if not t[j] then

                ri = ri - 1

                if ri == 0 then

                    table.insert(rt,j)

                    t[j] = true

                end

            end

        end
   end
    --dump(rt)
    return rt
  
end


--添加静态刚体
function PhysicsScene:add_Rigidbody(material)
    local coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS_tow,
                material)
    coinBody:setMass(COIN_MASS)
    coinBody:setDynamic(false)
    -- coinBody:setCategoryBitmask(0x03) --类别掩码 默认值为0xFFFFFFFF  
    coinBody:setContactTestBitmask(0x02) --接触掩码 默认值为 0x00000000
    -- coinBody:setCollisionBitmask(0x02) --碰撞掩码 默认值为0xFFFFFFFF  
    return   coinBody
end

function PhysicsScene:createCoin(x, y)
    -- add sprite to scene
    self.coinSprite = display.newSprite("png/baiqiu.png")
    self.phy_bg:addChild(self.coinSprite)

    self.rod_coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS,
        cc.PhysicsMaterial(WALL_THICKNESS, COIN_FRICTION, COIN_ELASTICITY))--
    self.rod_coinBody:setMass(COIN_MASS)
    -- self.rod_coinBody:setVelocity(cc.p(0,0))
    -- coinBody:setTag(1)
    self.rod_coinBody:setRotationEnable(false)
    self.rod_coinBody:setGravityEnable(false)


    --设置碰撞掩码  
    self.rod_coinBody:setCategoryBitmask(0x03)  
    self.rod_coinBody:setContactTestBitmask(0x01)  
    self.rod_coinBody:setCollisionBitmask(0x01)


    self.coinSprite:setPhysicsBody(self.rod_coinBody)
    self.coinSprite:setPosition(x, y)
    self.coinSprite:setTag(1)

    
end



function PhysicsScene:touch_btCallback( sender, eventType )
            
            local tag=sender:getTag()
            if eventType == ccui.TouchEventType.began and tag==1795 then
                is_Shots=true
                
            end
            if eventType ~= ccui.TouchEventType.ended then
                return
            end 

           if tag==77400 then   --  以前的167
               self.phy_bg:removeFromParent()
              self.PhysicsPop:removeFromParent()
            if tonumber(self.cycle)   ~=  0 then
                        local getuserinfo=LocalData:Instance():get_getuserinfo()--保存数据
                        local userdt = LocalData:Instance():get_userdata()
                         local activitypoints = LocalData:Instance():get_getactivitypoints()

                             userdt["golds"]=activitypoints["golds"]
                     
                        LocalData:Instance():set_userdata(userdt)
                        
                        cc.Director:getInstance():popScene()

                        Server:Instance():getactivitypointsdetail(self.id,self.heroid)

                return
            end
            local userdt = LocalData:Instance():get_userdata()
             local activitypoints = LocalData:Instance():get_getactivitypoints()
                 userdt["golds"]=activitypoints["golds"]
            LocalData:Instance():set_userdata(userdt)
            cc.Director:getInstance():popScene()
            Server:Instance():getactivitybyid(self.id,self.cycle)
           end
           if tag==167 then
              local activitypoints = LocalData:Instance():get_getactivitypoints()
              dump(activitypoints)
              if tonumber(activitypoints["golds"])  -   tonumber(activitypoints["betgolds"])   <=0 then
                  Server:Instance():prompt("金币不足，无法参与活动，快去奖池屯点金币吧！")
                  return
              end
              if tonumber(activitypoints["remaintimes"]) <=0 then
                Server:Instance():prompt("您参与次数已经用完")
                return
              end
              self.start_bt:setTouchEnabled(true)
              self.PhysicsPop:removeFromParent()
              self.phy_bg:removeFromParent()
                 self:add_ui(false)--再来一次

           end
            if tag==166 then
              print("好像是客服")
           end
           if tag==31 then  --返回
             --Util:scene_control("MainInterfaceScene")
             -- cc.Director:getInstance():popScene()
             -- Server:Instance():getactivitybyid(self.id,self.cycle)   --  跟新详情数据
             Util:player_music_hit("GAMEBG",true )
            if tonumber(self.cycle)   ~=  0 then
                        local getuserinfo=LocalData:Instance():get_getuserinfo()--保存数据
                        local userdt = LocalData:Instance():get_userdata()
                         local activitypoints = LocalData:Instance():get_getactivitypoints()
                         if activitypoints["golds"]   then
                             userdt["golds"]=activitypoints["golds"]
                         end
                        LocalData:Instance():set_userdata(userdt)
                        --Server:Instance():getactivitypointsdetail(self.id,self.heroid)
                        cc.Director:getInstance():popScene()

                        --Server:Instance():getactivitybyid(self.id,self.cycle)
                return
            end
            
            cc.Director:getInstance():popScene()
            Server:Instance():getactivitybyid(self.id,self.cycle)
           end

           if tag==1795 then  --开启按钮

            local recv = json.encode(self.save_table)
            dump(recv)
            cc.UserDefault:getInstance():setStringForKey("Physics",recv)

                is_Shots=false
            self.start_bt:setTouchEnabled(false)
                local curr_point=self.rod_spr:getPositionY()
                local cal= cc.CallFunc:create(function() 

                    local speed_rod=BOLL_S_V*(ROD_B_POPINT-ROD_E_POPINT-(curr_point-ROD_E_POPINT))/(ROD_B_POPINT-ROD_E_POPINT)
                    -- dump(speed_rod)
                    -- speed_rod=speed_rod+500
                    if speed_rod>1600 and speed_rod<2500 then
                        speed_rod=speed_rod+400
                    end
                    dump(speed_rod)
                    -- print("1111    ",speed_rod,(ROD_B_POPINT-ROD_E_POPINT-(curr_point-ROD_E_POPINT))/(ROD_B_POPINT-ROD_E_POPINT))
                     self.rod_coinBody:setGravityEnable(true)
                     self.rod_coinBody:setVelocity(cc.p(0,speed_rod))
                     
                end )
                local move=cc.MoveTo:create(ROD_M_TIME,cc.p(self.rod_spr:getPositionX(),ROD_B_POPINT))
               local seq=transition.sequence({move,cal})--
               self.rod_spr:stopAllActions()

               self.rod_spr:runAction(seq)
           end


end



function PhysicsScene:onTouch(event, x, y)
    if event == "began" then
        self:createCoin(x, y)
    end
end

function PhysicsScene:onEnter()
    Util:player_music_hit("ACTIVITY",true )
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame))
    self.world:setAutoStep(false);
    self:scheduleUpdate()
    NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self,
                       function()
                        
                         
                         --Server:Instance():getactivitybyid(self.id,self.cycle)--  从新初始化
                      end)
    NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
                       function()  
                         self:_refresh()
                       
                        --self:fun_data()
                      end)

end
function PhysicsScene:fun_data( )
       local activitypoints = LocalData:Instance():get_getactivitypoints()

       --弹球最高得分
        self.bestscore_text=self.phy_bg:getChildByTag(1803)
        self.bestscore_text:setString(tostring(activitypoints["bestpoints"]))
        --弹球累计得分
        self.allscore_text=self.phy_bg:getChildByTag(1802)
        self.allscore_text:setString(tostring(activitypoints["totalPoints"]))

        self._betgolds=self.phy_bg:getChildByTag(1799)   
        if tonumber(activitypoints["remaintimes"]) < 0 then
          self._betgolds:setString("/")
        else
          self._betgolds:setString("剩余弹珠次数:"   ..   activitypoints["remaintimes"]  )
        end
        

        

end
function PhysicsScene:onExit()
         NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self)
         NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
         cc.Director:getInstance():getTextureCache():removeAllTextures() 
end


function PhysicsScene:onEnterFrame(dt)
     
        for i=1,3 do
         self:getPhysicsWorld():step(1/180.0);
        end


        if self.rod_spr and is_Shots then
            -- print("---",self.rod_spr:getPositionY())
            if self.rod_spr:getPositionY()<=ROD_E_POPINT then
              is_Down=false
              self.rod_spr:setPositionY(ROD_E_POPINT)
            elseif self.rod_spr:getPositionY()>=ROD_B_POPINT then
              is_Down=true
              self.rod_spr:setPositionY(ROD_B_POPINT)
            end
            -- if self.rod_spr:getPositionY()<=ROD_E_POPINT then
            --     self.rod_spr:setPositionY(ROD_E_POPINT)
            --     -- is_Shots=false
            -- end
            if is_Down then
              self.rod_spr:setPositionY(self.rod_spr:getPositionY()-ROD_V)
            else
              self.rod_spr:setPositionY(self.rod_spr:getPositionY()+ROD_V)
            end
            
            
        end
        -- print("----",self.coinSprite:getPositionY())
        if  self.coinSprite and self.coinSprite:getPositionY()<200.0  then
            self.coinSprite:removeFromParent()
            self.coinSprite=nil
        end

        if  self.score_spr and self.score_spr:getPositionY()<200.0  then

            dump(self.score_spr:getTag())
            -- self._score1=self.score_spr:getTag()/10
            self.score_spr:removeFromParent()
            self.score_spr=nil
            -- self.phy_bg:removeFromParent()

            self:Phypop_up()
        end

end
function PhysicsScene:fun_countdown( )
      self._scnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdown()
              end,1.0, false)
end
 function PhysicsScene:countdown()
           self._time=self._time-1
           self._dajishi:setString(tostring(self._time))
           if self._time<0 then
               cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器
               self.phy_bg:removeFromParent()
               self.PhysicsPop:removeFromParent()
                if tonumber(self.cycle) ~=  -1 then
                            local getuserinfo=LocalData:Instance():get_getuserinfo()--保存数据
                             local activitypoints = LocalData:Instance():get_getactivitypoints()
                              local userdt = LocalData:Instance():get_userdata()
                             if activitypoints["golds"]  then
                                 userdt["golds"]=activitypoints["golds"]
                             end
                            LocalData:Instance():set_userdata(userdt)
                            -- Server:Instance():getactivitypointsdetail(self.id,self.heroid)
                            
                            -- Server:Instance():getactivitybyid(self.id,self.cycle)
                            cc.Director:getInstance():popScene()
                    return
                end
                Server:Instance():getactivitybyid(self.id,self.cycle)
                cc.Director:getInstance():popScene()

           end
end
--弹出框关闭
function PhysicsScene:Phypop_up()

            self.PhysicsPop = cc.CSLoader:createNode("PhysicsPop.csb");
            self:addChild(self.PhysicsPop)

            self._back=self.PhysicsPop:getChildByTag(167)  --  关闭按钮
            self._back:setVisible(false)
            self._back:addTouchEventListener(function(sender, eventType  )
            self:touch_btCallback(sender, eventType)
            end)
            local again_bt_bg=self.PhysicsPop:getChildByTag(775)  --  在来一句
            again_bt_bg:setVisible(false)
            self.again_bt=self.PhysicsPop:getChildByTag(774)  --  在来一句
            self.again_bt:setTouchEnabled(false)
            self.again_bt:setVisible(false)
            self.again_bt:addTouchEventListener(function(sender, eventType  )
            self:touch_btCallback(sender, eventType)
            end)

            local customer_button =self.PhysicsPop:getChildByTag(166)  --  客服
            customer_button :addTouchEventListener(function(sender, eventType  )
            self:touch_btCallback(sender, eventType)
            end)

            local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
            self._imagetu=Util:sub_str(list_table[1]["imgurl"], "/",":")
            local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
            local advert =self.PhysicsPop:getChildByTag(165)  --  广告
            advert:loadTexture(path..self._imagetu)

             local score_text1 =self.PhysicsPop:getChildByTag(171)  --  分数1
            -- score_text1:loadTexture(string.format("png/Physicstaiqiu-%d.png",self._score1 ))
             local score_text2 =self.PhysicsPop:getChildByTag(168)  --  分数2
            -- score_text2:loadTexture(string.format("png/Physicstaiqiu-%d.png",self.score2 ))
             local score_text3 =self.PhysicsPop:getChildByTag(169)  --  分数3
            -- score_text3:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score3))
             local score_text4 =self.PhysicsPop:getChildByTag(170)  --  分数4
            -- score_text4:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score4))
              local function logSprRotation(sender)
                 -- self:fun_data()
                 self._back:setVisible(true)
            end

            local action = cc.Sequence:create(cc.DelayTime:create(4.5),cc.CallFunc:create(logSprRotation))
            self._back:runAction(action)
     
            --  千位数动画
            local   _table={ }
            local open_xiangzi =self.PhysicsPop:getChildByTag(515)  --  小球开箱
            local open_xiangziyangqiu =open_xiangzi:getChildByTag(529)  --样求
            local open_xiangziwai =open_xiangzi:getChildByTag(517)  --  小球开箱外层
            local open_xiangzi_hua =open_xiangzi:getChildByTag(519)  --  小球开箱
            open_xiangzi_hua:setVisible(true)
            open_xiangzi_hua:setOpacity(0)
            local close_xiangzi =self.PhysicsPop:getChildByTag(518)  --  小球关闭箱子 
            close_xiangzi:setVisible(true)
            close_xiangzi:setOpacity(0)
            local _xiangqiu={}
            for i=530,532 do
              local open_xiangziyangqiu1 =open_xiangzi:getChildByTag(i)  --样求
              _xiangqiu[i-529]=open_xiangziyangqiu1
            end
            --初始化小球
            for i=520,528 do
               local open_xiangzi_xiaoqiu =open_xiangzi:getChildByTag(i)  --  小球
               _table[i-519]=open_xiangzi_xiaoqiu
               open_xiangzi_xiaoqiu:loadTexture(string.format("png/Physicstaiqiu-%d.png",i-519))--arr_ball[self._randTable[i+1]]))  --_randt))--
            end

            local _guang =self.PhysicsPop:getChildByTag(309)  --  背景光
            local _qianscore =self.PhysicsPop:getChildByTag(310)  --  千位数求

            _qianscore:loadTexture(string.format("png/Physicstaiqiu-%d.png",self._score1 ))
            local  scale = cc.ScaleTo:create(0.5,0.5)
            local  back  = cc.ScaleTo:create(1,1)
            local function stopAction()
                    _guang:setOpacity(0)
                    local  seq_1=cc.MoveTo:create(1.0, cc.p( score_text1:getPositionX(),score_text1:getPositionY() ) )
                    local  seq_2=cc.ScaleTo:create(0.5,0.5)
                    local spawn = cc.Spawn:create(seq_1, seq_2)
                    local function stopAction1()
                          
                           --小球下降
                          open_xiangzi:setVisible(true)
                          for i=1,#_table do
                      
                                local  _yang=cc.MoveTo:create(0.5, cc.p( _table[i]:getPositionX(),open_xiangziyangqiu:getPositionY() ) )
                                  _table[i]:runAction(_yang)
                          end

                            local actionTo = cc.RotateTo:create( 0.2, 30)
                            local actionTo1 = cc.RotateTo:create( 0.2, -30)
                            local actionTo2 = cc.RotateTo:create(0.2 , 30)
                            local actionTo3 = cc.RotateTo:create( 0.2, -30)
                            local actionTo4 = cc.RotateTo:create( 0.2, 30)
                            local actionTo5 = cc.RotateTo:create( 0.2, -30)
                            local actionTo6 = cc.RotateTo:create( 0.2, 0)
                           
                           local function logSprRotation(sender)
                                 open_xiangzi:setVisible(false)
                                 close_xiangzi:setOpacity(255)
                            end

                             local function logSprRotation1(sender)
                                  open_xiangzi:setVisible(true)
                                  close_xiangzi:setOpacity(0)
                                  local animation = cc.Animation:create()
                                  local name
                                  for i=1,3 do
                                      name = "png/taiqiu-lihua-"..i..".png"
                                      animation:addSpriteFrameWithFile(name)
                                  end
                                  animation:setDelayPerUnit(0.1)
                                  animation:setRestoreOriginalFrame(true)
                                  --创建动作
                                  local animate = cc.Animate:create(animation)
                                  local spr=display.newSprite()
                                  spr:setPosition(cc.p(open_xiangzi_hua:getPositionX(),open_xiangzi_hua:getPositionY()))
                                  open_xiangzi:addChild(spr)
                                  spr:runAction(animate)
                            end

                            local function logSprRotation3(sender)
                                  Server:Instance():getactivitybyid(self.id,self.cycle)
                                   _table[1]:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score4))
                                   local  t_yang1=cc.MoveTo:create(0.3, cc.p( _table[1]:getPositionX()+50*(-2),open_xiangziyangqiu:getPositionY()+150 ) )
                                   local  _yang1=cc.MoveTo:create(0.6, cc.p( _xiangqiu[1]:getPositionX(),_xiangqiu[1]:getPositionY() ) )
                                   _table[1]:runAction(cc.Sequence:create(t_yang1,_yang1))
                                   _table[2]:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score2))
                                   local  t_yang2=cc.MoveTo:create(0.5, cc.p( _table[2]:getPositionX()+50*(1),open_xiangziyangqiu:getPositionY()+150 ) )
                                   local  _yang2=cc.MoveTo:create(0.5, cc.p( _xiangqiu[2]:getPositionX(),_xiangqiu[2]:getPositionY() ) )
                                   _table[2]:runAction(cc.Sequence:create(t_yang2,_yang2))
                                   _table[3]:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score3))
                                   local  t_yang3=cc.MoveTo:create(0.7, cc.p( _table[3]:getPositionX()+50*(3),open_xiangziyangqiu:getPositionY()+150 ) )
                                   local  _yang3=cc.MoveTo:create(0.4, cc.p( _xiangqiu[3]:getPositionX(),_xiangqiu[3]:getPositionY() ) )

                                     local function logSprRotation2(sender)
                                          open_xiangzi:setOpacity(0)
                                          score_text1:loadTexture(string.format("png/Physicstaiqiu-%d.png",self._score1 ))
                                          score_text2:loadTexture(string.format("png/Physicstaiqiu-%d.png",self.score2 ))
                                          score_text3:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score3))
                                          score_text4:loadTexture(string.format("png/Physicstaiqiu-%d.png", self.score4))
                                          self:fun_data()  --刷新积分
                                          print("1112")
                                    end

                                   _table[3]:runAction(cc.Sequence:create(t_yang3,_yang3,cc.CallFunc:create(logSprRotation2)))
                                   self.again_bt:setTouchEnabled(true)

                            end
                            local action = cc.Sequence:create(cc.DelayTime:create(0.8),cc.CallFunc:create(logSprRotation),
                              actionTo,actionTo1,actionTo2,actionTo3,actionTo4,actionTo5,actionTo6,cc.CallFunc:create(logSprRotation1),cc.DelayTime:create(0.2),cc.CallFunc:create(logSprRotation3))
                            close_xiangzi:runAction(action)

                    end
                    local callfunc1 = cc.CallFunc:create(stopAction1)
                    _qianscore:runAction(cc.Sequence:create(spawn,callfunc1))
                          
            end
            local callfunc = cc.CallFunc:create(stopAction)
            local  seq   = cc.Sequence:create(scale,back,callfunc)
            _guang:runAction(seq)



            -- 播放其他小球动画
            self:play_action(score_text2)
            self:play_action(score_text3)
            self:play_action(score_text4)

             local _table=LocalData:Instance():get_gettasklist()
            local tasklist=_table["tasklist"]
           for i=1,#tasklist  do 
                 if  tonumber(tasklist[i]["targettype"])   ==  3   then
                      LocalData:Instance():set_tasktable(tasklist[i]["targetid"])
                 end
                 
           end
           
             if  LocalData:Instance():get_tasktable()    then   --  判断惊喜吧是否做完任务
                       Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
                       LocalData:Instance():set_tasktable(nil)--制空
                       -- self.again_bt:setTouchEnabled(true)
            end

          
           
end


function PhysicsScene:play_action(spritt)
    -- spritt:setOpacity(0)
     local animation = cc.Animation:create()
            local number,name
            for i=1,9 do
                number = math.random(9)
                name = "png/Physicstaiqiu-"..number..".png"
                animation:addSpriteFrameWithFile(name)
            end

            animation:setDelayPerUnit(0.2)
            animation:setRestoreOriginalFrame(true)

            --创建动作
            local animate = cc.Animate:create(animation)

             local spr=display.newSprite()
             spr:setAnchorPoint(0,0)
            spritt:addChild(spr,100)
            -- spr:setPosition(spritt:getPositionX(), spritt:getPositionY())
            local function logSprRotation(sender)
                -- spritt:setOpacity(255)
            end


     local action = cc.Sequence:create(animate,animate:reverse(),cc.CallFunc:create(logSprRotation))

            -- local action = cc.Sequence:create(animate,animate:reverse())

            spr:runAction(action)

end

return PhysicsScene
