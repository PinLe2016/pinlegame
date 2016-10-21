--
-- Author: Your Name
-- Date: 2016-04-19 09:45:07
--
local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

local FloatingLayerEx = require("app.layers.FloatingLayer")


function LoginScene:ctor()
   self.floating_layer = require("app.layers.FloatingLayer").new()
   --self.floating_layer:addTo(self,100)
   self:addChild(self.floating_layer, 100)


     if qqqq==0 then
      --请求版本更新链接
        self:progressbarScene()

     else
       self:landing_init()
     end

   self.layertype=0  --判断界面
     


self.code_bt=nil

end
--新增加的进度条
function LoginScene:progressbarScene(  )
        self.ProgressbarScene = cc.CSLoader:createNode("ProgressbarScene.csb")
        self:addChild(self.ProgressbarScene)
        loadingBar=self.ProgressbarScene:getChildByTag(328)
        self.roleAction = cc.CSLoader:createTimeline("ProgressbarScene.csb")
        self.ProgressbarScene:runAction(self.roleAction)
         self.roleAction:gotoFrameAndPlay(0,41, true)
         -- self:fun_countdown( )
        loadingBar:setPercent(0)
end
 function LoginScene:countdown()
           self._time=self._time+100
        

            loadingBar:setPercent(self._time)
            if self._time==200 then
               cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器
               --判断是否是第一次登陆
               local new_start=cc.UserDefault:getInstance():getStringForKey("new_start","0")
               if new_start=="0" then
                  self:_coverlayer()
                  cc.UserDefault:getInstance():setStringForKey("new_start","1")
                  return
               end
              
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
function LoginScene:_coverlayer( )

      self.coverlayer = cc.CSLoader:createNode("coverlayer.csb")
      self:addChild(self.coverlayer)

      local advertiPv=self.coverlayer:getChildByTag(1531)
      local advertiPa = advertiPv:getChildByTag(1532)

      advertiPv:addEventListener(function(sender, eventType  )
                
                 if eventType == ccui.PageViewEventType.turning then

                    advertiPv:scrollToPage(advertiPv:getCurPageIndex())
                end
        end)
       local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
        local advertiImg1=advertiPa:getChildByTag(640)
        advertiImg1:setVisible(false)
         for i=2, 4 do  --
              local  call=advertiPa:clone() 
              local a_dvertiImg=call:getChildByTag(1533)--cover1.jpg
              a_dvertiImg:loadTexture("res/png/cover"  ..  tostring(i)   ..   ".jpg")--imgurl
              local advertiImg=call:getChildByTag(640)
              if i< 4 then
                advertiImg:setVisible(false)
              elseif i==4 then
                advertiImg:setVisible(true)
              self. _advertiImg=advertiImg
              end
              advertiPv:addPage(call)   
        end

        self. _advertiImg:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end

                local login_info=LocalData:Instance():get_user_data()
                if login_info~=nil  then
                        Util:scene_control("MainInterfaceScene")
                        return
                end
                self:landing_init()  
                print("封面")
        end)
end


 function LoginScene:registered_init()
   local function Getverificationcode_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
          sender:setColor(cc.c3b(100, 100, 100))
          sender:setTouchEnabled(false)
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

    local res = "  "--res/png/DLkuang.png"
    local width = 300
    local height = 40
    --注册
    self.phone_text = ccui.EditBox:create(cc.size(width,height),res)
    self.registered:addChild(self.phone_text)
    self.phone_text:setPosition(cc.p(self.Zphone_text:getPositionX(),self.Zphone_text:getPositionY()))--( cc.p(130,438 ))  
    self.phone_text:setPlaceHolder("请输入手机号码")
    self.phone_text:setAnchorPoint(0.5,0.5)  
    self.phone_text:setMaxLength(11)

    self.Zpassword_text = ccui.EditBox:create(cc.size(width,height),res)
    self.registered:addChild(self.Zpassword_text )
    self.Zpassword_text :setPosition(cc.p(password_text:getPositionX(),password_text:getPositionY()))--( cc.p(130,380 ))  
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
              Server:Instance():promptbox_box_buffer("验证码错误")
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
                 self.registered=nil
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

    print("层级关系222",self.floating_layer:getLocalZOrder(),"  ",landing:getLocalZOrder())
   -- local dialog=FloatingLayer:Instance():floatingLayer_init("多少分开始的")
   -- self:addChild(dialog)
   -- self:replaceScene(dialog)
  phone_bg=landing:getChildByTag(6)

  local Editphone = landing:getChildByTag(6):getChildByTag(16)
  Editphone:setTouchEnabled(false)
  Editphone:setVisible(false)

   
  local EditPassword=landing:getChildByTag(6):getChildByTag(17)
  EditPassword:setTouchEnabled(false)
  EditPassword:setVisible(false)


    local res = " "--res/png/DLkuang.png"
    local width = 350
    local height = 40
    --登陆
    self.Dphone_text = ccui.EditBox:create(cc.size(width,height),res)
    self.Dphone_text:setPlaceHolder("请输入手机号码")  --setString
    self.Dphone_text:setVisible(true)
    self.Dphone_text:setPosition(cc.p(Editphone:getPositionX(),Editphone:getPositionY()))--( cc.p(107,77 ))  
    self.Dphone_text:setAnchorPoint(0,0.5)  
    self.Dphone_text:setMaxLength(11)
    phone_bg:addChild(self.Dphone_text)
    print("层级关系",self.Dphone_text:getLocalZOrder(),"  ",phone_bg:getLocalZOrder())

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
                Server:Instance():promptbox_box_buffer("填写的手机号不能为空哦！")   --prompt
                return
            end
            self._gobt:setTouchEnabled(false)
           Server:Instance():login(self.Dphone_text:getText(),self.Dpassword_text :getText())
           local function stopAction()
                          self._gobt:setTouchEnabled(true)

             end
              local callfunc = cc.CallFunc:create(stopAction)
             self:runAction(cc.Sequence:create(cc.DelayTime:create(2),callfunc  ))


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


   self._gobt = landing:getChildByTag(6):getChildByTag(11)--登陆
   --self._gobt=go_bt
    self._gobt:addTouchEventListener(go_btCallback)

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

            local res = "  "--res/png/DLkuang.png"
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
                       Server:Instance():promptbox_box_buffer("填写手机号码错误")
                       return
                   end
                   sender:setTouchEnabled(false)
                   sender:setColor(cc.c3b(100, 100, 100))
                   self.layertype=2
                  Server:Instance():sendmessage(2,self._mobilephone,self.p_random)
                  print("邀请码"..self.p_random)
             end
end
function LoginScene:_resetpasswordLayer(  )

            self._mobilephone=self.Wphone_text:getText()
            if tostring(self._yanzhengma:getText())=="" then
                Server:Instance():promptbox_box_buffer("验证码不能为空,请重新输入")
                return
            end

            if tostring(self._yanzhengma:getText())  ~= tostring(self.p_random) then
              Server:Instance():promptbox_box_buffer("验证码错误")
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
              local res = "  "--res/png/DLkuang.png"
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
              if self.code_bt then
                self.code_bt:setTouchEnabled(true)
                self.code_bt:setColor(cc.c3b(255, 255, 255))
              end
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
   Server:Instance():version_login_url()  
  if LocalData:Instance():get_music() then 
    Util:player_music("GAMEBG",true )
  end 
  
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.VERSION_LINK, self,
                       function()
                              if qqqq==0 then
                                  --请求版本更新链接
                                  Server:Instance():getversion()
                                  qqqq=2
                              end
                      end)

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

    NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.REG, self,--注册成功返回
                       function()
                         
                         if  self.registered then
                               self:landing_init()
                             if self._scode then
                                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                             end

                               self.registered:removeFromParent()
                               self.registered=nil
                         end
                        
                      end)

   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.PASSWOEDCHANGE, self,
                       function()
                         if self.resetpasswordLayer then
                                self.resetpasswordLayer:removeFromParent()
                                self:landing_init()
                         end
                      end)



--热更消息接收
 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.VERRSION, self,function()
                          self:getVersionInfo()
                        end)

end
function LoginScene:onExit()
  --audio.stopMusic(G_SOUND["LOGO"])
    Util:stop_music("LOGO")
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REG, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)

  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.PASSWOEDCHANGE, self)


  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.VERRSION, self)
  
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.VERSION_LINK, self)


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
function LoginScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function LoginScene:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end

function LoginScene:updateLayer()

    local layer = cc.Layer:create()

    local support  = false
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) 
        or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) 
        or (cc.PLATFORM_OS_MAC  == targetPlatform) then
        support = true
    end

    -- if not support then
    --     print("Platform is not supported!")
    --     return layer
    -- end

   
    local isUpdateItemClicked = false
    local assetsManager       = nil
    local pathToSave          = ""

    pathToSave = createDownloadDir()


    local function reload(is_upd)

        if not is_upd then 

            return
        end

        local unReloadModule = {["common.string"] = 1,["common.class"]=1,["common.event"]=1,["common.luadata"]=1,["libs.protobuf"]=1,["pb.protoList"]=1}
        for k,v in pairs(package.loaded) do

            --只有lua模块卸载
            local path = string.gsub(k, "%.", "/")

            path = cc.FileUtils:getInstance():fullPathForFilename("src/"..path..".lua");
            local file = io.open(path);
            -- print("file---",file)
            -- io.writefile(cc.FileUtils:getInstance():getWritablePath() .."costTime.lua", path.."\n","a+")
            -- dump(path)
            if file and unReloadModule[k]==nil then
                file:close();
                local parent = require(k);
                if type(parent) == "table" then
                    for k1,_ in pairs(parent) do
                        parent[k1] = nil
                    end
                end
                local pac=package.loaded[k]
                package.loaded[k] = nil
               
                _G[k] = nil
            end

        end
        --说明，安卓重新加载文件，不知为啥，model 文件数据必须重新添加，不然更新model 文件初始重加载不了
        if device.platform=="android" then
            require("app.model.Server.Server")
            require("app.model.Server.ServerLogin")
            require("app.model.Server.ServerSurprise")
            require("app.model.Server.ServerUserData")   
            require("app.model.Server.ServerJackpot") 
            require("app.model.Server.ServerFriends") 

            require("app.model.LocalData.LocalData")
            require("app.model.LocalData.LocalLogin")
            require("app.model.LocalData.LocalSurprise")
            require("app.model.LocalData.LocalPerInformation")
            require("app.model.LocalData.LocalJackpot")
            require("app.model.LocalData.LocalUserdata")
            require("app.model.LocalData.LocalFriends")

            require("app.model.NotificationCenter")
            require("app.model.Util")
        end
       

        xpcall(main, __G__TRACKBACK__)
        require("app.MyApp").new():run()
        -- require("main")

    end




    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            -- loadingBar:setPercent(100)
            self._time=0
            self:fun_countdown()
            reload(false)
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            -- progressLable:setString("network error")
            self:pushFloating("请检查你的网络")
        end
    end


    local function onProgress( percent )
        -- local progress = string.format("downloading %d%%",percent)
        -- progressLable:setString(progress)
        loadingBar:setPercent(percent)
    end

    local function onSuccess()
        -- progressLable:setString("downloading ok")
        reload(true)
        loadingBar:setPercent(100)
        
    end

    local function getAssetsManager()--"https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip"
        if nil == assetsManager then--"https://raw.github.com/samuele3hu/AssetsManagerTest/master/version"
            assetsManager = cc.AssetsManager:new(self.url,
                                           self.masterURL,
                                           pathToSave)
            -- assetsManager = cc.AssetsManager:new("https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip",
            --                                "https://raw.github.com/samuele3hu/AssetsManagerTest/master/version",
            --                                pathToSave)
            assetsManager:retain()
            assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
            assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            assetsManager:setConnectionTimeout(3)
        end

        return assetsManager
    end


    --清空当前，重新热更
    -- self:reset()
    -- getAssetsManager():deleteVersion()
--版本下载更新中
    getAssetsManager():update()
    
    return layer
end


function LoginScene:getVersionInfo()
    local up_date=LocalData:Instance():get_version_date()
    dump(up_date)

    --检测是否需要下载新版本

    if tonumber(up_date["downloadIsused"])==1 then
        if tonumber(up_date["downloadupdate"])==1 then
              self.floating_layer:showFloat("发现新版本请更新",function (sender, eventType)
                                 if eventType==1 then
                                    self:reset()--更新删除缓存
                                    device.openURL(up_date["downloadurl"])
                                    -- device.openURL("http://www.allchina.cn/news/xinwenAD_post_90987.html")
                                  else
                                     cc.Director:getInstance():endToLua()   --退出游戏
                                 end
                            end)
            return
        end
    end


    if tonumber(up_date["Isused"])~=1 then--Isused 0.开启热更，1 关闭热更
      
      self.masterURL=up_date["masterURL"]
      self.url=up_date["url"]
      self:addChild(self:updateLayer())
      return
    end

    -- local login_info=LocalData:Instance():get_user_data()
    -- if login_info~=nil  then
    --        Util:scene_control("MainInterfaceScene")
    --         return
    -- end
        -- Util:scene_control("LoginScene")

    -- self:landing_init()
    self._time=0
    self:fun_countdown()
end


function LoginScene:reset()
        print("--删除--")
        pathToSave = createDownloadDir()
        deleteDownloadDir(pathToSave)

        -- getAssetsManager():deleteVersion()

        createDownloadDir()
 end




return LoginScene