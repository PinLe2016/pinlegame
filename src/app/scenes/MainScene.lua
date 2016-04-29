
require("app.model.Server.Server")
require("app.model.NotificationCenter")
require("app.model.LocalData.LocalData")

local FloatingLayerEx = require("app.layers.FloatingLayer")

local MainScene = class("MainScene", function()
    return display.newScene("debrisScene")
end)


local  debrisSprite=require("app.gamecontrol.DebrisSprite")

function MainScene:ctor()
	     ----  全局变量  服务器选择
   HttpOrSocket = "HTTP"

   self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:setTouchSwallowEnabled(false)
   self.floating_layer:addTo(self,100000)




   -- Server:Instance():version_login_url()
-- Server:Instance():request_pic("http://f.hiphotos.baidu.com/zhidao/pic/item/d833c895d143ad4b4cbf3f3081025aafa50f06a8.jpg","0.png")
-- Server:Instance():request_pic("http://img4.kwcdn.kuwo.cn/star/KuwoArtPic/2013/15/1396929659847_w.jpg","1.png")
-- Server:Instance():request_pic("http://www.16sucai.com/uploadfile/2012/0708/20120708023948159.jpg","2.png")


local sp=display.newSprite("1.png")
sp:setAnchorPoint(0.0,0.0)
sp:addTo(self)
end

function MainScene:onEnter()

  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self,
                       function()
                       
                      end)
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
