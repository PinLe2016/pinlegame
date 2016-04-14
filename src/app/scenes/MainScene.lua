
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
  
 -- self.debrisSprite:create(" ",10,10,10,10,10,10,10,10)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end


function MainScene:pushFloating(text,is_resource,r_type)
   if is_resource then
       self.floating_layer:showFloat(text,is_resource,r_type)  
   else
       self.floating_layer:showFloat(text,is_resource) 
   end
end 

return MainScene
