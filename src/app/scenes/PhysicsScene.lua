--
-- Author: peter
-- Date: 2016-09-18 11:05:34
--
local PhysicsScene = class("PhysicsScene", function()
      return display.newPhysicsScene("PhysicsScene")
end)


local GRAVITY         = -2000
local COIN_MASS       = 10000 --质量
local COIN_RADIUS     = 11--半径
local COIN_RADIUS_tow     = 5--半径
local COIN_FRICTION   = 1.5--弹性系数
local COIN_FRICTION_tow   = 0.0--弹性系数
-- local WALL_FRICTION   = 0.0--弹力
local WALL_THICKNESS  = 64--密度
local COIN_ELASTICITY = 12.0---摩擦力
local COIN_ELASTICITY_tow = 20.0---摩擦力
-- local WALL_ELASTICITY = 0.0--摩擦系数

GAME_TEXTURE_DATA_FILENAME  = "png/AllSprites.plist"
GAME_TEXTURE_IMAGE_FILENAME = "png/AllSprites.png"


function PhysicsScene:ctor()
    -- create touch layer
    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    
    self:setNodeEventEnabled(true)--layer添加监听
    -- create label
    cc.ui.UILabel.new({text = "TAP SCREEN", size = 32, color = display.COLOR_WHITE})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    -- create physics world
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, GRAVITY))

    local leftWallSprite = display.newSprite("#Wall.png")
    leftWallSprite:setScaleY(display.height / WALL_THICKNESS)
    leftWallSprite:setPosition(display.left + WALL_THICKNESS / 2, display.cy + WALL_THICKNESS)
    self:addChild(leftWallSprite)

    local rightWallSprite = display.newSprite("#Wall.png")
    rightWallSprite:setScaleY(display.height / WALL_THICKNESS)
    rightWallSprite:setPosition(display.right - WALL_THICKNESS / 2, display.cy + WALL_THICKNESS)
    self:addChild(rightWallSprite)

    local bottomWallSprite = display.newSprite("#Wall.png")
    bottomWallSprite:setScaleX(display.width / WALL_THICKNESS)
    bottomWallSprite:setPosition(display.cx, display.bottom + WALL_THICKNESS / 2)
    self:addChild(bottomWallSprite)

    
    -- modeSprite:setPosition(x, y)

    local wallBox = display.newNode()
    wallBox:setAnchorPoint(cc.p(0.5, 0.5))
    wallBox:setPhysicsBody(
        cc.PhysicsBody:createEdgeBox(cc.size(display.width - WALL_THICKNESS*2, display.height - WALL_THICKNESS)))
    wallBox:setPosition(display.cx, display.height/2 + WALL_THICKNESS/2)

     

    -- self:addChild(wallBox)

    -- add debug node
    self:getPhysicsWorld():setDebugDrawMask(
        true and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
	


     --  碰撞监听  
    local conListener=cc.EventListenerPhysicsContact:create();  
    conListener:registerScriptHandler(function(contact)  
  
            -- print("---contact-碰撞了--")  
              
            -- --    处理游戏中精灵碰撞逻辑  
            -- local node1=contact:getShapeA():getBody():getNode()  
            -- local name1=node1:getName()  
            -- local tag1=node1:getTag()  
            -- print("name1:",name1)  
            
  
            -- local node2=contact:getShapeB():getBody():getNode()  
            -- local name2=node2:getName()  
            -- local tag2=node2:getTag()  
            -- print("name2:",name2)  
            -- local blink = cc.Blink:create(0.5, 2);
            --   node1:runAction(blink);
            

              
            return true  
    end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)  
  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(conListener,self) 

    self:add_ui()
    self:add_obstacle()
end



function PhysicsScene:add_ui()

    self.phy_bg = cc.CSLoader:createNode("PhysicsLayer.csb");
    self:addChild(self.phy_bg)



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




    -- local  verts1= {cc.p(-306.0000, -355.0), cc.p(-304.0, 498.0), cc.p(-320,493.0)} --根据点组成一个多边形，这样设置的PhysicsBody是一个三角形

    -- local  verts2= {cc.p(-295.0, 357.0), cc.p(-293.0, 395.0), cc.p(-246.0,417.0)}

    -- local  verts3= {cc.p(-245.0, 417), cc.p(-231.0, 448.0), cc.p(-174.0,454.0)}

    -- local  verts4= {cc.p(-173.0, 453.0), cc.p(-158.0, 467.0), cc.p(-122.0,468.0)}


    -- local  verts5= {cc.p(-121.00, 468.0), cc.p(-100.0, 489.0), cc.p(-55.0,477.0)}

    -- local  verts6= {cc.p(45.0, 478.0), cc.p(44.0, 487.0), cc.p(111.0,468.0)}

    -- local  verts7= {cc.p(99.0, 473.0), cc.p(110.0, 484.0), cc.p(180.0,449.0)}

    -- local  verts8= {cc.p(169.0, 453.0), cc.p(179.0, 467.0), cc.p(220.0,428.0)}

    -- local  verts9= {cc.p(220.0,431.0), cc.p(235.0, 444.0), cc.p(265.0,400.0)}

    -- local  verts10= {cc.p(266.0,399.0), cc.p(274.0, 407.0), cc.p(311.0,332.0)}

    -- local  verts11= {cc.p(-197.0,256.0), cc.p(-208.0, 248.0), cc.p(-302.0,338.0),cc.p(-296.0,355.0)}


    -- local coinBody = cc.PhysicsBody:create()
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts1))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts2))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts3))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts4))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts5))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts6))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts7))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts8))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts9))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts10))
    -- coinBody:addShape(cc.PhysicsShapeEdgePolygon:create(verts11))
    -- coinBody:setMass(COIN_MASS)
    -- coinBody:setDynamic(false)
    -- sp_bg:setPhysicsBody(coinBody)

end


function PhysicsScene:add_obstacle()

    local modeSprite1 =self.phy_bg:getChildByTag(1790)
    local modeSprite2 =self.phy_bg:getChildByTag(1797)
    local modeSprite3 =self.phy_bg:getChildByTag(1796)

	for i=0,10 do
		for j=0,7 do
		  local modeSprite=modeSprite1:clone()

			-- print("---fe ",math.floor(i%2))
			modeSprite:setPosition(modeSprite1:getPositionX()+(modeSprite2:getPositionX()-modeSprite1:getPositionX())*i+20*math.floor(j%2),modeSprite1:getPositionY()-j*(modeSprite1:getPositionY()-modeSprite3:getPositionY()))
			self.phy_bg:addChild(modeSprite)
			local coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS_tow,
			cc.PhysicsMaterial(COIN_RADIUS, COIN_FRICTION_tow, COIN_ELASTICITY_tow))
			coinBody:setMass(COIN_MASS)
			coinBody:setDynamic(false)
            -- coinBody:setCategoryBitmask(0x03) --类别掩码 默认值为0xFFFFFFFF  
            coinBody:setContactTestBitmask(0x02) --接触掩码 默认值为 0x00000000  
            -- coinBody:setCollisionBitmask(0x02) --碰撞掩码 默认值为0xFFFFFFFF  

			modeSprite:setPhysicsBody(coinBody)

		end
	end
  
end

function PhysicsScene:createCoin(x, y)
    -- add sprite to scene
    local coinSprite = display.newSprite("marble_res/baiqiu.png")
    -- coinSprite:setScale(0.8)
    self.phy_bg:addChild(coinSprite)

    local coinBody = cc.PhysicsBody:createCircle(COIN_RADIUS,
        cc.PhysicsMaterial(COIN_RADIUS, COIN_FRICTION, COIN_ELASTICITY))
    coinBody:setMass(COIN_MASS)
    coinBody:setVelocity(cc.p(0,2000))

    -- coinBody:setRotationEnable(false)
    -- coinBody:setDynamic(false)
    -- coinBody:setCategoryBitmask(1)
    -- coinBody:setContactTestBitmask(1)

    --设置碰撞掩码  
    coinBody:setCategoryBitmask(0x03)  
    coinBody:setContactTestBitmask(0x01)  
    coinBody:setCollisionBitmask(0x01)


    coinSprite:setPhysicsBody(coinBody)
    coinSprite:setPosition(x, y)
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
    self:scheduleUpdate()
end

function PhysicsScene:onEnterFrame(dt)
     
        for i=1,3 do
         self:getPhysicsWorld():step(1/180.0);
        end
end

return PhysicsScene
