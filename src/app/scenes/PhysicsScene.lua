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
local is_rest=true



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
            -- print("name2:",name2)  
            local blink = cc.Blink:create(1.0, 1);
            if tag1==1 then
                node2:stopAllActions()
              node2:runAction(blink)
          else
              node1:stopAllActions()
              node1:runAction(blink)
            end
            
            

              
            return true  
    end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)  
  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(conListener,self) 

    self:add_ui()
    self:add_obstacle()
end



function PhysicsScene:add_ui()

    -- cc.Director:getInstance():getCamera():setCenterXYZ(100,0,100);

    self.phy_bg = cc.CSLoader:createNode("PhysicsLayer.csb");
    -- self.phy_bg:setAnchorPoint(cc.p(0,0.5))
    self:addChild(self.phy_bg)
    -- self.phy_bg:setRotation3D({x=0,y=30,z=0})
    -- self.phy_bg:setSkewY(10)
    -- self.phy_bg:setSkewX(20)



    self.phy_bg:getChildByTag(1788):setTouchEnabled(false)

    local sp_bg=self.phy_bg:getChildByTag(1791)

    self.layer = display.newLayer()
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    self.layer:setTouchEnabled(true)
    self.layer:setTouchSwallowEnabled(true)
    sp_bg:addChild(self.layer)



    local physics=Util:read_json("res/physics.json")

    local coinBody = cc.PhysicsBody:create()

    for i=1,#physics["physics"] do
        local ver={}
        for j=1,#physics["physics"][i] do
            local vers=physics["physics"][i][j]
            ver[j]=cc.p(vers[1],vers[2])
            
        end
        coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(ver))
    end

    coinBody:setMass(COIN_MASS)
    coinBody:setDynamic(false)
    sp_bg:setPhysicsBody(coinBody)

end


function PhysicsScene:add_obstacle()

    local modeSprite1 =self.phy_bg:getChildByTag(1790)
    local modeSprite2 =self.phy_bg:getChildByTag(1797)
    local modeSprite3 =self.phy_bg:getChildByTag(1796)

	for i=0,10 do
		for j=0,7 do
		  local modeSprite=modeSprite1:clone()

			-- print("---fe ",math.floor(j%2))
            if (math.floor(j%2)==1 and i~=10) or math.floor(j%2)==0 then
                modeSprite:setPosition(modeSprite1:getPositionX()+(modeSprite2:getPositionX()-modeSprite1:getPositionX())*i+20*math.floor(j%2),modeSprite1:getPositionY()-j*(modeSprite1:getPositionY()-modeSprite3:getPositionY()))
                self.phy_bg:addChild(modeSprite)
                local material=cc.PhysicsMaterial(WALL_THICKNESS, COIN_FRICTION_tow, COIN_ELASTICITY_tow)
                if j~=0 then
                    material=cc.PhysicsMaterial(WALL_THICKNESS, COIN_FRICTION_three, COIN_ELASTICITY_tow)
                end

                local coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS_tow,
                material)
                coinBody:setMass(COIN_MASS)
                coinBody:setDynamic(false)
                -- coinBody:setCategoryBitmask(0x03) --类别掩码 默认值为0xFFFFFFFF  
                coinBody:setContactTestBitmask(0x02) --接触掩码 默认值为 0x00000000  
                -- coinBody:setCollisionBitmask(0x02) --碰撞掩码 默认值为0xFFFFFFFF  

                modeSprite:setPhysicsBody(coinBody)
            end
			

		end
	end
  
end

function PhysicsScene:createCoin(x, y)
    -- add sprite to scene
    local coinSprite = display.newSprite("marble_res/baiqiu.png")
    -- coinSprite:setScale(0.8)
    self.phy_bg:addChild(coinSprite)

    local coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS,
        cc.PhysicsMaterial(WALL_THICKNESS, COIN_FRICTION, COIN_ELASTICITY))--
    coinBody:setMass(COIN_MASS)
    coinBody:setVelocity(cc.p(0,2500))
    coinBody:setTag(1)
    coinBody:setRotationEnable(false)
    -- coinBody:setDynamic(false)
    -- coinBody:setCategoryBitmask(1)
    -- coinBody:setContactTestBitmask(1)

    --设置碰撞掩码  
    coinBody:setCategoryBitmask(0x03)  
    coinBody:setContactTestBitmask(0x01)  
    coinBody:setCollisionBitmask(0x01)


    coinSprite:setPhysicsBody(coinBody)
    coinSprite:setPosition(x, y)
    coinSprite:setTag(1)

    self:scheduleUpdate()
end

function PhysicsScene:onTouch(event, x, y)
    if event == "began" then
        self:createCoin(x, y)
    end
end

function PhysicsScene:onEnter()
    self.layer:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame))
    self.world:setAutoStep(false);
    
end

function PhysicsScene:onEnterFrame(dt)
     
        for i=1,3 do
         self:getPhysicsWorld():step(1/180.0);
        end
        
        if  self.phy_bg:getChildByTag(1) and self.phy_bg:getChildByTag(1):getPositionY()<350.0  then
            -- print("------",self.phy_bg:getChildByTag(1):getPositionY())
            -- self.phy_bg:removeChildByTag(1)
            -- is_rest=false
        end
end

return PhysicsScene
