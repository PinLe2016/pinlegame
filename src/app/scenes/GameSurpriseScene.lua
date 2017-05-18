--
-- Author: peter
-- Date: 2017-05-18 16:31:41
--
--  新版惊喜吧 
local GameSurpriseScene = class("GameSurpriseScene", function()
            return display.newScene("GameSurpriseScene")
end)
function GameSurpriseScene:ctor()
      self:fun_init()
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键

end
function GameSurpriseScene:fun_init( ... )
	self.GameSurpriseScene = cc.CSLoader:createNode("GameSurpriseScene.csb");
	self:addChild(self.GameSurpriseScene)

end
function GameSurpriseScene:pushFloating(text)
       self.floating_layer:showFloat(text)  
end 

function GameSurpriseScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function GameSurpriseScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function GameSurpriseScene:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function GameSurpriseScene:onEnter()


	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()

                      end)--
end

function GameSurpriseScene:onExit()
     
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.PERFECT, self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
--android 返回键 响应
function GameSurpriseScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              self:unscheduleUpdate()
              Util:scene_control("MainInterfaceScene")
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end



return GameSurpriseScene