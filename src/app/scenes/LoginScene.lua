--
-- Author: Your Name
-- Date: 2016-04-19 09:45:07
--
local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

local  SurpriseScene=require("app.scenes.SurpriseScene")
local FloatingLayerEx = require("app.layers.FloatingLayer")


function LoginScene:ctor()
   self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:addTo(self,100000)
    Server:Instance():version_login_url()
   self:landing_init()
  -- phone_text:addEventListener(function()
  --                  Server:Instance():login(phone_text:getString(),password_text:getString())
  --           end）
  -- password_text:addEventListener(function()
  --                 Server:Instance():login(phone_text:getString(),password_text:getString())
  --           end)
  
  --Server:Instance():login("liuyali","554564564564")
  --landingbg_2:addEventListener(textFieldEvent)
end
 function LoginScene:registered_init()
   local function Getverificationcode_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           local _random=math.random(1000,9999)
           print("邀请码".._random)
        end
    end
     local function submit_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("提交")

        end
    end
     local function callback_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("取消")
           self:landing_init()
           registered:removeFromParent()
        end
    end
    local Getverificationcode_bt=registered:getChildByTag(27)
    Getverificationcode_bt:addTouchEventListener(Getverificationcode_btCallback)
     local submit_bt=registered:getChildByTag(26)
    submit_bt:addTouchEventListener(submit_btCallback)
     local callback_bt=registered:getChildByTag(25)
    callback_bt:addTouchEventListener(callback_btCallback)

end
function LoginScene:landing_init()
    landing = cc.CSLoader:createNode("landing.csb");
    self:addChild(landing)

   -- local dialog=FloatingLayer:Instance():floatingLayer_init("多少分开始的")
   -- self:addChild(dialog)
   -- self:replaceScene(dialog)

  phone_text = landing:getChildByTag(6):getChildByTag(16)
  password_text=landing:getChildByTag(6):getChildByTag(17)

local function go_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           Server:Instance():login(phone_text:getString(),password_text:getString())
        end
    end

    local function registered_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("注册")
            registered = cc.CSLoader:createNode("registered.csb");
            self:addChild(registered);
            landing:removeFromParent()
            self:registered_init()
        end
    end

    local function Forgotpassword_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           print("忘记密码")
        end
    end


   local go_bt = landing:getChildByTag(6):getChildByTag(11)--登陆
    go_bt:addTouchEventListener(go_btCallback)

     local registered_bt = landing:getChildByTag(6):getChildByTag(12)--注册
    registered_bt:addTouchEventListener(registered_btCallback)

     local Forgotpassword_bt = landing:getChildByTag(6):getChildByTag(13)--忘记密码
    Forgotpassword_bt:addTouchEventListener(Forgotpassword_btCallback)
end
function LoginScene:onEnter()
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self,
                       function()
                        --Util:scene_control("MainInterfaceScene")
                        --display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)

end

function LoginScene:onExit()
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)
end
function LoginScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 
return LoginScene