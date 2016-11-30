--
-- Author: peter
-- Date: 2016-09-20 14:46:35
--
--
-- Author: peter
-- Date: 2016-09-20 14:40:44
--

local MallScene = class("MallScene", function()
      return display.newScene("MallScene")
end)

function MallScene:ctor(params)

     self.floating_layer = require("app.layers.FloatingLayer").new()
     self.floating_layer:addTo(self,100000)

     self:listener_home() --注册安卓返回键

     self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
      back:addTouchEventListener(function(sender, eventType  )
        if eventType ~= ccui.TouchEventType.ended then
          return
        end
          Util:scene_control("MainInterfaceScene")
          self.Storebrowser:getChildByTag(255):loadURL("about:blank")
          self.Storebrowser:getChildByTag(255):reload()
           
      end)


        local login_info=LocalData:Instance():get_user_data()
        local _key=login_info["loginname"]
        local _loginkey=login_info["loginkey"]


        local url
         if tostring(params.type)=="emil" then
            url=Server:Instance():mall(tostring(_key),tostring(_loginkey))
         elseif tostring(params.type)=="play_mode" then
            url="http://playios.pinlegame.com/GameCenter/index.html"
        end
        
        local webview = cc.WebView:create()
        self.Storebrowser:addChild(webview,1,255)
        webview:setVisible(true)
        webview:setScalesPageToFit(true)
        webview:loadURL(url)
        webview:setContentSize(cc.size(store_size:getContentSize().width   ,store_size:getContentSize().height  )) -- 一定要设置大小才能显示
        webview:reload()
        webview:setPosition(cc.p(store_size:getPositionX(),store_size:getPositionY()))

end


function MallScene:onEnter()
    
      

end

function MallScene:onExit()

          
end

function MallScene:pushFloating(text)

   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end

end 
function MallScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function MallScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
--android 返回键 响应
function MallScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              Util:scene_control("MainInterfaceScene")
              self.Storebrowser:getChildByTag(255):loadURL("about:blank")
              self.Storebrowser:getChildByTag(255):reload()
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end


return MallScene