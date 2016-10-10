--
-- Author: peter
-- Date: 2016-09-18 11:05:34
--
local PhysicsScene = class("PhysicsScene", function()
      return display.newPhysicsScene("PhysicsScene")
end)


local GRAVITY         = -2000
local COIN_MASS       = 6000 --质量
local COIN_RADIUS     = 11--半径
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
local is_Shots=false
local ROD_V=3.0
local ROD_B_POPINT=0--台球杆的初始高度
local ROD_E_POPINT=130--台球杆的初始高度
local ROD_M_TIME=0.07---台球杆的移动时间

local BOLL_S_V=2000---台球的初始速度

function PhysicsScene:ctor()
    -- create touch layer


    -- display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    
    self:setNodeEventEnabled(true)--layer添加监听

    
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
                dump(self.rod_spr:getPositionX())
                self.coinSprite:setPosition(self.rod_spr:getPositionX(), ROD_B_POPINT+225)
                return true
            end
            if tag1==1 then 
                node=node2
                body=contact:getShapeB():getBody()
            end
            
            local cal= cc.CallFunc:create(function() 
                node:loadTexture("png/Physicshongqiu-xiao.png")
            end )
           local seq=transition.sequence({cc.DelayTime:create(0.3),cal})--屏幕抖动
           node:stopAllActions()
           if  node:getTag()<10 then
               node:loadTexture("png/Physicshongqiu-xiao-liang.png") 
               node:runAction(seq)
           else
               body:setGravityEnable(true)
               self.score_spr=node
           end
            
            

              
            return true  
    end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)  
  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(conListener,self) 

    self:add_ui()
    
end



function PhysicsScene:add_ui()
     self:getPhysicsWorld():setDebugDrawMask(
        true and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
    -- cc.Director:getInstance():getCamera():setCenterXYZ(100,0,100);

    self.phy_bg = cc.CSLoader:createNode("PhysicsLayer.csb");
    self:addChild(self.phy_bg)

    local sp_bg=self.phy_bg:getChildByTag(1791)

    -- self.layer = display.newLayer()
    -- self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    --     return self:onTouch(event.name, event.x, event.y)
    -- end)
    -- self.layer:setTouchEnabled(true)
    -- self.layer:setTouchSwallowEnabled(true)
    -- self.phy_bg:getChildByTag(1788):addChild(self.layer)



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
    local start_bt=self.phy_bg:getChildByTag(1795)
     start_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))

    self.rod_spr=self.phy_bg:getChildByTag(27)--棒子
    -- self.rod_spr:setVisible(false)
    ROD_B_POPINT=self.rod_spr:getPositionY()--记录台球杆的初始高度

    -- dump(self.rod_spr:getPositionX())
    self:createCoin(self.rod_spr:getPositionX()+0, self.rod_spr:getPositionY()+225)--小球

    self:add_obstacle()--障碍小球

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
    dangban:setPosition(self.rod_spr:getPositionX(), self.rod_spr:getPositionY()+210)
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

    local arr_ball={8,7,6,5,4,3,2,1,2,3,4,5,6,7,8}

    for i=0,14 do
        local modeSprite=modeSprite_ban_3:clone()
        self.phy_bg:addChild(modeSprite)

        modeSprite:loadTexture(string.format("png/Physicstaiqiu-%d.png", arr_ball[i+1]))
        modeSprite:setPosition(modeSprite_ban_3:getPositionX()+30*i,modeSprite_ban_3:getPositionY())
        modeSprite:setTag(arr_ball[i+1]*10)

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

           
           if tag==31 then  --返回
                Util:scene_control("MainInterfaceScene")
           end

           if tag==1795 then  --开启按钮
                is_Shots=false

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

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame))
    self.world:setAutoStep(false);
    self:scheduleUpdate()
end

function PhysicsScene:onEnterFrame(dt)
     
        for i=1,3 do
         self:getPhysicsWorld():step(1/180.0);
        end


        if self.rod_spr and is_Shots then
            -- print("---",self.rod_spr:getPositionY())
            self.rod_spr:setPositionY(self.rod_spr:getPositionY()-ROD_V)
            if self.rod_spr:getPositionY()<=ROD_E_POPINT then
                self.rod_spr:setPositionY(ROD_E_POPINT)
                is_Shots=false
            end
        end
        -- print("----",self.coinSprite:getPositionY())
        if  self.coinSprite and self.coinSprite:getPositionY()<200.0  then
            self.coinSprite:removeFromParent()
            self.coinSprite=nil
        end

        if  self.score_spr and self.score_spr:getPositionY()<200.0  then
            self.score_spr:removeFromParent()
            self.score_spr=nil
            self.phy_bg:removeFromParent()
            self:add_ui()
        end
end




return PhysicsScene
