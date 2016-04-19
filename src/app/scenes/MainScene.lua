
require("app.model.Server.Server")
require("app.model.NotificationCenter")
require("app.model.LocalData.LocalData")

local FloatingLayerEx = require("app.layers.FloatingLayer")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)


local  debrisSprite=require("app.gamecontrol.DebrisSprite")

function MainScene:ctor()
	     ----  全局变量  服务器选择
   HttpOrSocket = "HTTP"

   self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:setTouchSwallowEnabled(false)
   self.floating_layer:addTo(self,100000)
   
   --local  sp=debrisSprite.new()

   --  local sprite1 = display.newSprite("sp.png")
   --  sprite1:setPosition(display.cx,display.cy)
   --  local  rect = cc.rect(100,100,100,100)
   --  local clipnode = display.newClippingRegionNode(rect)
   -- clipnode:addChild(sprite1)
    
   --  local  layer=display.newLayer()
   --  layer:addChild(clipnode)
   --  self:addChild(layer)


   debrisSprite:create("sp.png",10,10,10,10,10,10,10,10)


end

function MainScene:onEnter()
  dump("222")
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self,
                       function()
                        dump("测试消息集成")
                      end)
   local debris=debrisSprite.new()
end

function MainScene:onExit()
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self)
end


function MainScene:pushFloating(text,is_resource,r_type)
   if is_resource then
       self.floating_layer:showFloat(text,is_resource,r_type)  
   else
       self.floating_layer:showFloat(text,is_resource) 
   end
end 

return MainScene
