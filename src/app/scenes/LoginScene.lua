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
     if qqqq==0 then
       self:progressbarScene()
       qqqq=2
     else
       self:landing_init()
     end
   self.layertype=0  --判断界面
     


end
--新增加的进度条
function LoginScene:progressbarScene(  )
        self.ProgressbarScene = cc.CSLoader:createNode("ProgressbarScene.csb")
        self:addChild(self.ProgressbarScene)
        self.loadingBar=self.ProgressbarScene:getChildByTag(328)
        self.roleAction = cc.CSLoader:createTimeline("ProgressbarScene.csb")
        self.ProgressbarScene:runAction(self.roleAction)
         self.roleAction:gotoFrameAndPlay(0,40, true)
         self._time=0
         self:fun_countdown( )
         self.loadingBar:setPercent(0)
end
 function LoginScene:countdown()
           self._time=self._time+10
        
            self.loadingBar:setPercent(self._time)
            if self._time==110 then
               cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器
                 local login_info=LocalData:Instance():get_user_data()
                if login_info~=nil  then
                    Util:scene_control("MainInterfaceScene")
                    return
                end
               self:landing_init()
             
           end
end
function LoginScene:fun_countdown( )
      self._scnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdown()
              end,1.0, false)
end



 function LoginScene:registered_init()
   local function Getverificationcode_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           self.layertype=1
           self._random=Util:rand(  ) --随机验证码
           print("邀请码".. self.phone_text:getText(),  self._random)
           Server:Instance():sendmessage(1,self.phone_text:getText(),self._random)
        end
    end
     self. _random=000  --初始化
     self.Zphone_text=self.registered:getChildByTag(28)
     self.Zphone_text:setVisible(false)
     self.Zphone_text:setTouchEnabled(false)
     local password_text=self.registered:getChildByTag(29)
     password_text:setVisible(false)
     password_text:setTouchEnabled(false)
     local verificationcode_text=self.registered:getChildByTag(30)
     verificationcode_text:setVisible(false)
     verificationcode_text:setTouchEnabled(false)

    local res = "res/png/DLkuang.png"
    local width = 300
    local height = 40
    --注册
    self.phone_text = ccui.EditBox:create(cc.size(width,height),res)
    self.registered:addChild(self.phone_text)
    self.phone_text:setPosition(cc.p(self.Zphone_text:getPositionX()-20,self.Zphone_text:getPositionY()))--( cc.p(130,438 ))  
    self.phone_text:setPlaceHolder("请输入手机号码")
    self.phone_text:setAnchorPoint(0.5,0.5)  
    self.phone_text:setMaxLength(11)

    self.Zpassword_text = ccui.EditBox:create(cc.size(width,height),res)
    self.registered:addChild(self.Zpassword_text )
    self.Zpassword_text :setPosition(cc.p(password_text:getPositionX()-20,password_text:getPositionY()))--( cc.p(130,380 ))  
    self.Zpassword_text :setPlaceHolder("请输入密码")
    self.Zpassword_text :setAnchorPoint(0.5,0.5)  
    self.Zpassword_text :setMaxLength(19)
    self.Zpassword_text :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)

    self.Zcode_text = ccui.EditBox:create(cc.size(120,40),res)
    self.registered:addChild(self.Zcode_text)
    self.Zcode_text:setPosition(cc.p(verificationcode_text:getPositionX()-20,verificationcode_text:getPositionY()))--( cc.p(130,323 ))  
    self.Zcode_text:setPlaceHolder("验证码")
    self.Zcode_text:setAnchorPoint(0.5,0.5)  
    self.Zcode_text:setMaxLength(6)





     local function submit_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
        if tostring(self.Zcode_text:getText())  ~= tostring(self._random) then
              Server:Instance():prompt("验证码错误")
             return    
        end
        if self._scode then
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
        end
              Server:Instance():reg(self.phone_text:getText(),self.Zpassword_text:getText())
        end
    end
     local function callback_btCallback(sender, eventType) 
        if eventType == ccui.TouchEventType.ended then
           print("取消")
           self:landing_init()
           if self._scode then
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
           end
           if  self.registered then
                 self.registered:removeFromParent()
           end
          
        end
    end
    self.Getverificationcode_bt=self.registered:getChildByTag(27) --注册验证码按钮
    self.Getverificationcode_bt:addTouchEventListener(Getverificationcode_btCallback)
     local submit_bt=self.registered:getChildByTag(26)
    submit_bt:addTouchEventListener(submit_btCallback)
     local callback_bt=self.registered:getChildByTag(25)
    callback_bt:addTouchEventListener(callback_btCallback)
    

end
function LoginScene:landing_init()
    landing = cc.CSLoader:createNode("landing.csb");
    self:addChild(landing)

   -- local dialog=FloatingLayer:Instance():floatingLayer_init("多少分开始的")
   -- self:addChild(dialog)
   -- self:replaceScene(dialog)
  phone_bg=landing:getChildByTag(6)
  dump(phone_bg:getPosition())
  print("顶顶顶顶",phone_bg:getPositionX(),phone_bg:getPositionY())
  local Editphone = landing:getChildByTag(6):getChildByTag(16)
  Editphone:setTouchEnabled(false)
  Editphone:setVisible(false)

   
  local EditPassword=landing:getChildByTag(6):getChildByTag(17)
  EditPassword:setTouchEnabled(false)
  EditPassword:setVisible(false)


    local res = "res/png/DLkuang.png"
    local width = 350
    local height = 40
    --登陆
    self.Dphone_text = ccui.EditBox:create(cc.size(width,height),res)
    phone_bg:addChild(self.Dphone_text)
    self.Dphone_text:setVisible(true)
    self.Dphone_text:setPosition(cc.p(Editphone:getPositionX(),Editphone:getPositionY()))--( cc.p(107,77 ))  
    self.Dphone_text:setPlaceHolder("请输入手机号码")
    self.Dphone_text:setAnchorPoint(0,0.5)  
    self.Dphone_text:setMaxLength(11)

    self.Dpassword_text = ccui.EditBox:create(cc.size(width,height),res)
    self.Dpassword_text:setVisible(true)
    phone_bg:addChild(self.Dpassword_text )
    self.Dpassword_text :setPosition(cc.p(EditPassword:getPositionX(),EditPassword:getPositionY()))--( cc.p(107,25 ))  
    self.Dpassword_text :setPlaceHolder("请输入密码")
    self.Dpassword_text :setAnchorPoint(0,0.5)  
    self.Dpassword_text :setMaxLength(19)
    self.Dpassword_text :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)





local function go_btCallback(sender, eventType)

        if eventType == ccui.TouchEventType.ended then
            if  self.Dphone_text:getText() == "" then
                Server:Instance():prompt("填写的手机号不能为空哦！")
               return
            end
           Server:Instance():login(self.Dphone_text:getText(),self.Dpassword_text :getText())
        end   
    end

    local function registered_btCallback(sender, eventType)
   
    
        if eventType == ccui.TouchEventType.ended then
           print("注册")
            self.registered = cc.CSLoader:createNode("registered.csb");
            self:addChild(self.registered);
            if  landing then
                 self.Dpassword_text :setVisible(false)
                 self.Dphone_text:setVisible(false)
                 landing:removeFromParent()
                 
                 --password_text:removeFromParent()
            end
          
            self:registered_init()
        end
    end

    local function Forgotpassword_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
                 print("忘记密码")
                 self.Dpassword_text :setVisible(false)
                 self.Dphone_text:setVisible(false)
                 landing:removeFromParent()
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
-- function LoginScene:touchCallback( sender, eventType )
--               if eventType ~= ccui.TouchEventType.ended then
--                        return
--               end
--               local tag=sender:getTag()
--               if tag==11 then  
--                      Server:Instance():prompt("11验证码错误")
--                      return
--                      print("不会吧11")
--                      Server:Instance():login(phone_text:getText(),password_text:getText())
--             end
             
            
-- end 

function LoginScene:_passwordLayer( )

          local _back = self.passwordLayer:getChildByTag(290)
          _back:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))

          local submit = self.passwordLayer:getChildByTag(292)
          submit:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))
           self.yanzhengma = self.passwordLayer:getChildByTag(291)
          self.yanzhengma:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))


            local phone=self.passwordLayer:getChildByTag(293)
            phone:setVisible(false)
            phone:setTouchEnabled(false)
            local Wcode_text = self.passwordLayer:getChildByTag(294)
            Wcode_text:setVisible(false)
            Wcode_text:setTouchEnabled(false)

            local res = "res/png/DLkuang.png"
            local width = 300
            local height = 40
            --忘记密码
            self.Wphone_text = ccui.EditBox:create(cc.size(width,height),res)
            self.passwordLayer:addChild(self.Wphone_text)
            self.Wphone_text:setPosition(cc.p(phone:getPositionX(),phone:getPositionY()))--( cc.p(58,441 ))  
            self.Wphone_text:setPlaceHolder("请输入手机号码")
            self.Wphone_text:setAnchorPoint(0,0.5)  
            self.Wphone_text:setMaxLength(11)

            self._yanzhengma = ccui.EditBox:create(cc.size(120,40),res)
            self.passwordLayer:addChild(self._yanzhengma)
            self._yanzhengma:setPosition(cc.p(Wcode_text:getPositionX(),Wcode_text:getPositionY()))--( cc.p(58,356 ))  
            self._yanzhengma:setPlaceHolder("验证码")
            self._yanzhengma:setAnchorPoint(0,0.5)  
            self._yanzhengma:setMaxLength(6)

            





end
function LoginScene:touch_Callback( sender, eventType  )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getTag()
              if tag==290 then      --修改密码 返回
                   if self._scode then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                 end
                  self:landing_init()
                 if  self.passwordLayer then
                     self.passwordLayer:removeFromParent()
                end
             elseif tag==292 then   --修改密码 提交
                if self._scode then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
              end
                self:_resetpasswordLayer()
                
              elseif tag==305 then  --重新设置密码  返回
                self:landing_init()
           
                if self.resetpasswordLayer then
                   self.resetpasswordLayer:removeFromParent()
                end
              elseif tag==303 then
                local password = self.resetpasswordLayer:getChildByTag(302)
                local _pass=self.Wpassword_text:getText()
                 print("提交",_pass,"  ",self._mobilephone)
                 Server:Instance():changepassword(self._mobilephone,_pass)
              elseif tag==291 then
                  self.p_random=Util:rand(  ) --随机验证码\
                     local phone=self.passwordLayer:getChildByTag(293)
                    self._mobilephone=self.Wphone_text:getText()
                   print(" 长度 ",string.len(self._mobilephone))

                   if string.len(self._mobilephone)~=11 then
                       Server:Instance():prompt("填写手机号码错误")
                       return
                   end
                   self.layertype=2
                  Server:Instance():sendmessage(2,self._mobilephone,self.p_random)
                  print("邀请码"..self.p_random)
             end
end
function LoginScene:_resetpasswordLayer(  )

            self._mobilephone=self.Wphone_text:getText()

            if tostring(self._yanzhengma:getText())  ~= tostring(self.p_random) then
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
             local password1 = self.resetpasswordLayer:getChildByTag(302)
             password1:setVisible(false)
             password1:setTouchEnabled(false)
              local res = "res/png/DLkuang.png"
              local width = 350
              local height = 40
             --修改密码
              self.Wpassword_text = ccui.EditBox:create(cc.size(width,height),res)
              self.resetpasswordLayer:addChild(self.Wpassword_text )
              self.Wpassword_text :setPosition(cc.p(password1:getPositionX()-200,password1:getPositionY()))--( cc.p(100,375 ))  
              self.Wpassword_text :setPlaceHolder("请输入密码")
              self.Wpassword_text :setAnchorPoint(0,0.5)  
              self.Wpassword_text :setMaxLength(19)
              self.Wpassword_text :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
              





             if self.passwordLayer then
                   self.passwordLayer:removeFromParent()
            end
end

 function LoginScene:countdowncode()
           self._code=self._code-1
           self.code_bt:setTitleText(tostring(self._code) .. "S")
            if self._code==0 then
               cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止定时器
                 self.code_bt:setTitleText("获取验证密码")
             
           end
end
function LoginScene:fun_countdowncode( )
      self._scode=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdowncode()
              end,1.0, false)
end

function LoginScene:onEnter()
  --audio.playMusic(G_SOUND["LOGO"],true)
  Util:player_music("LOGO",true )
  
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self,
                       function()
                        Util:scene_control("MainInterfaceScene")
                        --display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self,
                       function()
                       print("注册的验证码")
                       self._code=30
                       if  self.layertype==1 then
                           self.code_bt=self.Getverificationcode_bt
                        elseif self.layertype==2 then
                           self.code_bt=self.yanzhengma
                       end
                       self.code_bt:setTitleText("30S")
                       self:fun_countdowncode()
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.PASSWOEDCHANGE, self,
                       function()
                         if self.resetpasswordLayer then
                                self.resetpasswordLayer:removeFromParent()
                                self:landing_init()
                         end
                      end)



end
function LoginScene:onExit()
  --audio.stopMusic(G_SOUND["LOGO"])
  Util:stop_music("LOGO")
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.PASSWOEDCHANGE, self)
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