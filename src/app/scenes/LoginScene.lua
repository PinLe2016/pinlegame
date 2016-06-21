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



end
 function LoginScene:registered_init()
   local function Getverificationcode_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           self._random=Util:rand(  ) --随机验证码
           print("邀请码".. self.phone_text:getString(),  self._random)
           Server:Instance():sendmessage(1,self.phone_text:getString(),self._random)
        end
    end
    self. _random=000  --初始化
     self.phone_text=registered:getChildByTag(28)
     local password_text=registered:getChildByTag(29)
     local verificationcode_text=registered:getChildByTag(30)
     local function submit_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
        if tostring(verificationcode_text:getString())  ~= tostring(self._random) then
              Server:Instance():prompt("验证码错误")
             return    
        end
              Server:Instance():reg(self.phone_text:getString(),password_text:getString())
        end
    end
     local function callback_btCallback(sender, eventType) 
        if eventType == ccui.TouchEventType.ended then
           print("取消")
           self:landing_init()
           if  self.registered then
                 self.registered:removeFromParent()
           end
          
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
            if  landing then
                 landing:removeFromParent()
            end
          
            self:registered_init()
        end
    end

    local function Forgotpassword_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
                 print("忘记密码")
                self.passwordLayer = cc.CSLoader:createNode("passwordLayer.csb");
                self:addChild(self.passwordLayer);
                self:_passwordLayer()
                self.p_random=00
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
                        Util:scene_control("MainInterfaceScene")
                        --display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)

end
function LoginScene:_passwordLayer( )

          local _back = self.passwordLayer:getChildByTag(290)
          _back:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))

          local submit = self.passwordLayer:getChildByTag(292)
          submit:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))
           local yanzhengma = self.passwordLayer:getChildByTag(291)
          yanzhengma:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))

end
function LoginScene:touch_Callback( sender, eventType  )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getTag()
              if tag==290 then      --修改密码 返回
                 if  self.passwordLayer then
                     self.passwordLayer:removeFromParent()
                end
             elseif tag==292 then   --修改密码 提交
                local phone=self.passwordLayer:getChildByTag(293)
                self._mobilephone=phone:getString()
                self:_resetpasswordLayer()
                
              elseif tag==305 then  --重新设置密码  返回
                if self.resetpasswordLayer then
                   self.resetpasswordLayer:removeFromParent()
                end
              elseif tag==303 then
                local password = self.resetpasswordLayer:getChildByTag(302)
                local _pass=password:getString()
                 print("提交",_pass,"  ",self._mobilephone)
                 Server:Instance():changepassword(self._mobilephone,_pass)
              elseif tag==291 then
                  self.p_random=Util:rand(  ) --随机验证码
                  Server:Instance():sendmessage(2,self._mobilephone,self.p_random)
                  print("邀请码"..self.p_random)
             end
end
function LoginScene:_resetpasswordLayer(  )
            local _yanzhengma = self.passwordLayer:getChildByTag(294)
            if tostring(_yanzhengma:getString())  ~= tostring(self.p_random) then
              Server:Instance():prompt("验证码错误")
              return    
           end
            if  tostring(self._mobilephone) == " "   then
               return
            end
           
            self.resetpasswordLayer = cc.CSLoader:createNode("resetpasswordLayer.csb");
            self:addChild(self.resetpasswordLayer);
             local _back = self.resetpasswordLayer:getChildByTag(305)
             _back:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))
             local submit = self.resetpasswordLayer:getChildByTag(303)
             submit:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))
             local phone = self.resetpasswordLayer:getChildByTag(300)
             phone:setString(self._mobilephone)
             if self.passwordLayer then
                   self.passwordLayer:removeFromParent()
            end
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

function LoginScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
end 



















return LoginScene