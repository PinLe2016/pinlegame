--
-- Author: Your Name
-- Date: 2016-04-19 09:45:07
--
local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

 -- local PinUIInput=require("app.scenes.PinUIInput") 


function  LoginScene:ctor()

   self.floating_layer = require("app.layers.FloatingLayer").new()
   --self.floating_layer:addTo(self,100)
   self:addChild(self.floating_layer, 10000)
   self.is_wechat_reg=false

     if version_upd==0 then
      --请求版本更新链接
        self:progressbarScene()

     else
       self:landing_init()
     end

   self.layertype=0  --判断界面
    self.sex=0


-- self.code_bt=nil

end
--新增加的进度条
function LoginScene:progressbarScene(  )
        self.ProgressbarScene = cc.CSLoader:createNode("LoadingNode.csb");  --LoadingNode   LoginNode_Mobile
        self:addChild(self.ProgressbarScene)
        self.ProgressbarScene:getChildByName("Image_2"):getChildByName("Button_7"):setVisible(false)
        self.LoadingNodebar=cc.CSLoader:createNode("LoadingNodebar.csb")
        self.ProgressbarScene:addChild(self.LoadingNodebar)

        loadingBar=self.LoadingNodebar:getChildByName("ldb_Loading")
        self.particle = cc.ParticleSystemQuad:create("loading.plist")
       loadingBar:addChild(self.particle)

        local labelAtlas=self.LoadingNodebar:getChildByName("all_Numberi")
        local _labelAtlas=self.LoadingNodebar:getChildByName("all_Count")
        local all_Count = ccui.TextAtlas:create()
        all_Count:setPosition(cc.p(_labelAtlas:getPositionX(),_labelAtlas:getPositionY()))  
        all_Count:setProperty( "100","LoadingNode/LG_32.png", 19, 23, "0")  --tostring(self.friendlist_num["friendcount"]),
        self.LoadingNodebar :addChild(all_Count) 

        local all_Numberi = ccui.TextAtlas:create()
        all_Numberi:setTag(255)
        all_Numberi :setPosition(cc.p(labelAtlas:getPositionX(),labelAtlas:getPositionY()))  
        all_Numberi:setProperty("0","LoadingNode/LG_32.png", 19, 23, "0")  --tostring(self.friendlist_num["friendcount"]),
        self.LoadingNodebar :addChild( all_Numberi) 
         
        loadingBar:setPercent(0)
        
        self:fun_LoadingNodebar_act(self.LoadingNodebar)
        
end
function LoginScene:fun_LoadingNodebar_act( _obj )
              local act_bg=_obj:getChildByName("act_bg")
              local act_h1=act_bg:getChildByName("act_h1")
              local act_h2=act_bg:getChildByName("act_h2")
              local act_hU1=act_h1:getChildByName("act_hU1")
              local act_hU2=act_h2:getChildByName("act_hU2")
              local actionT1 = cc.RotateTo:create( 1, 2)
              local actionTo1 = cc.RotateTo:create( 1, -2)
              local actionT2 = cc.RotateTo:create( 1, 3)
              local actionTo2 = cc.RotateTo:create( 1, -3)
              local actionT3 = cc.RotateTo:create( 1, 2)
              local actionTo3 = cc.RotateTo:create( 1, -2)
              local actionT4 = cc.RotateTo:create( 1, 10)
              local actionTo4 = cc.RotateTo:create( 1, -10)
              local actionT5 = cc.RotateTo:create( 1, 4)
              local actionTo5 = cc.RotateTo:create( 1, -4)
              act_bg:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT1, actionTo1)))
              act_h1:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT2, actionTo2)))
              act_h2:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT3, actionTo3)))
              act_hU1:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT4, actionTo4)))
              act_hU2:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT5, actionTo5)))

end
--微信发送请求
 function LoginScene:countdown(Iswechat)
           if Iswechat   then
                if Util:getWeixinLoginDate() then
                  cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)
                  if self.is_wechat_reg==false then
                    Server:Instance():wechatreg(Util:getWeixinLoginDate().openid,Util:getWeixinLoginDate().nickname)
                    self.is_wechat_reg=true
                  end
                  
                 
                end
            else
               self:fun_progress()
           end


end
function LoginScene:fun_progress( )
     self._time=self._time+2
            loadingBar:setPercent(self._time)
            self.LoadingNodebar :getChildByTag(255):setString(tostring(self._time))
            self.particle:setPositionX(loadingBar:getContentSize().width/100 *self._time)
            if self._time>96 then
              self.LoadingNodebar :getChildByTag(255):setString("100%")
              loadingBar:setPercent(100)
            end
            if self._time==100 then
               cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器
               local new_start=cc.UserDefault:getInstance():getStringForKey("new_start","0")
               if new_start=="0" then
                  self:_coverlayer()
                  cc.UserDefault:getInstance():setStringForKey("new_start","1")
                  return
               end
              
              local login_info=LocalData:Instance():get_user_data()
              if login_info~=nil and login_info["diamondnum"] then
                 Util:scene_control("MainInterfaceScene")
                return
              end
              self:landing_init()             

            end
end
function LoginScene:fun_countdown(Iswechat )
      self._scnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdown(Iswechat)
              end,0.02, false)
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
                      --advertiImg:setVisible(true)
                      self. _advertiImg=advertiImg
                      call:setTouchEnabled(true)
                      call:addTouchEventListener(function(sender, eventType  )
                             if eventType == ccui.TouchEventType.began then
                                    local login_info=LocalData:Instance():get_user_data()
                                          if login_info~=nil and login_info["diamondnum"] then
                                                    Util:scene_control("MainInterfaceScene")
                                                    --display.replaceScene(require("app.scenes.MainInterfaceScene"):new())
                                                    return
                                          end
                                    self:landing_init()  
                            end
                      end)

              end
              advertiPv:addPage(call)   
        end

        self. _advertiImg:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end

                local login_info=LocalData:Instance():get_user_data()
                if login_info~=nil and login_info["diamondnum"] then
                        Util:scene_control("MainInterfaceScene")
                        --display.replaceScene(require("app.scenes.MainInterfaceScene"):new())
                        return
                end
                self:landing_init()  
                print("封面")
        end)
end
 function LoginScene:registered_init()

   local _ybt=self.LoginNode_Register:getChildByName("Button_5") --注册验证码按钮
   local function Getverificationcode_btCallback(sender, eventType)
         self.code_bt=self.Getverificationcode_bt
         
          _ybt:setVisible(false)
        if eventType == ccui.TouchEventType.ended then
        
          _ybt:setVisible(true)
          --sender:setColor(cc.c3b(100, 100, 100))
          sender:setTouchEnabled(false)
           self.layertype=1
           self._random=Util:rand(  ) --随机验证码
           print("邀请码".. self.phone_text:getString(),  self._random)
           if tostring(Util:judgeIsAllNumber(tostring(self.phone_text:getString())))  ==  "false"  and self.Zpassword_text:getString() ~= "" and string.len(self.phone_text:getString()) == 11 then
              Server:Instance():promptbox_box_buffer("手机号码格式错误")
              return
           end
           Server:Instance():sendmessage(1,self.phone_text:getString())
        end
    end
     self. _random=000  --初始化
     self.Zphone_text=self.LoginNode_Register:getChildByName("tf_Mobile")
     -- self.Zphone_text:setVisible(false)
     -- self.Zphone_text:setTouchEnabled(false)
     self.phone_text=self.Zphone_text
     Util:function_keyboard(self.registered,self.Zphone_text,23,245,126,20)
     local password_text=self.LoginNode_Register:getChildByName("tf_Password")
     self.Zpassword_text=password_text
     Util:function_keyboard(self.registered,password_text,14,245,126,20)
     -- password_text:setVisible(false)
     -- password_text:setTouchEnabled(false)
     local verificationcode_text=self.LoginNode_Register:getChildByName("tf_Token")
     self.Zcode_text=verificationcode_text
     Util:function_keyboard(self.registered,verificationcode_text,23,245,126,20)
     -- verificationcode_text:setVisible(false)
     -- verificationcode_text:setTouchEnabled(false)

    local res = "  "--res/png/DLkuang.png"
    local width = 300
    local height = 40
    --注册
    -- self.phone_text = ccui.EditBox:create(cc.size(width,height),res)
    -- self.registered:addChild(self.phone_text)
    -- self.phone_text:setPosition(cc.p(self.Zphone_text:getPositionX(),self.Zphone_text:getPositionY()))--( cc.p(130,438 ))  
    -- self.phone_text:setPlaceHolder("请输入手机号码")
    -- self.phone_text:setAnchorPoint(0.5,0.5)  
    -- self.phone_text:setMaxLength(11)

    -- self.Zpassword_text = ccui.EditBox:create(cc.size(width,height),res)
    -- self.registered:addChild(self.Zpassword_text )
    -- self.Zpassword_text :setPosition(cc.p(password_text:getPositionX(),password_text:getPositionY()))--( cc.p(130,380 ))  
    -- self.Zpassword_text :setPlaceHolder("请输入密码")
    -- self.Zpassword_text :setAnchorPoint(0.5,0.5)  
    -- self.Zpassword_text :setMaxLength(19)
    -- self.Zpassword_text :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)

    -- self.Zcode_text = ccui.EditBox:create(cc.size(120,40),res)
    -- self.registered:addChild(self.Zcode_text)
    -- self.Zcode_text:setPosition(cc.p(verificationcode_text:getPositionX()-20,verificationcode_text:getPositionY()))--( cc.p(130,323 ))  
    -- self.Zcode_text:setPlaceHolder("验证码")
    -- self.Zcode_text:setAnchorPoint(0.5,0.5)  
    -- self.Zcode_text:setMaxLength(6)





     local function submit_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
                sender:setTouchEnabled(false)
                local _spr= cc.Sprite:create()
                self:addChild(_spr)
                 local function stopAction()
                                sender:setTouchEnabled(true)      
                end
                local callfunc = cc.CallFunc:create(stopAction)
               _spr:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
               
                if  self.phone_text:getString () == "" then
                      Server:Instance():promptbox_box_buffer("请输入正确的手机号 或者 密码 或者验证码")   --prompt
                      return
                end
                if tostring(Util:judgeIsAllNumber(tostring(self.phone_text:getString())))  ==  "false"  then
                      Server:Instance():promptbox_box_buffer("账号不存在") 
                      return
                end

                if  string.len(self.phone_text:getString()) < 11 then
                      Server:Instance():promptbox_box_buffer("手机号填写错误")   --prompt
                      return
                end
                if  string.len(self.phone_text:getString()) ==  11  and  self.Zpassword_text :getString()  ==  ""   then
                      Server:Instance():promptbox_box_buffer("请输入6～20位之间的密码哦")   --prompt
                      return
                end
                 if  string.len(self.Zpassword_text:getString()) <6   or string.len(self.Zpassword_text:getString()) >20   then
                      Server:Instance():promptbox_box_buffer("输入的密码须在6～20位之间哦")   --prompt
                      return
                end



               
               
                Server:Instance():reg(self.phone_text:getString(),self.Zpassword_text:getString(),self.Zcode_text:getString())
                
          end
    end

     local function callback_btCallback(sender, eventType) 
                    if eventType == 3 then
                       sender:setScale(1)
                       return
                     end
                    if eventType ~= ccui.TouchEventType.ended then
                         sender:setScale(1.2)
                         return
                    end
                    sender:setScale(1)
                  -- self:landing_init()
                   self:_landing_interface()
                   if self._scode then
                      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                   end
                   if  self.registered then
                         self.registered:removeFromParent()
                         self.registered=nil
                  end
    end
    self.Getverificationcode_bt=self.LoginNode_Register:getChildByName("btn_Token") --注册验证码按钮
    self.Getverificationcode_bt:addTouchEventListener(Getverificationcode_btCallback)
     local submit_bt=self.LoginNode_Register:getChildByName("btn_Submit")
    submit_bt:addTouchEventListener(submit_btCallback)
     local callback_bt=self.registered:getChildByName("Image_2")
    callback_bt:addTouchEventListener(callback_btCallback)
    

end
function function_name( ... )
  -- body
end


function LoginScene:fun_move_act(_obj,x)
     if x<0 then
       _x=x+math.abs(x)
      else
        _x=x/2
     end
     local  move1=cc.MoveTo:create(6, cc.p(_x ,_obj:getPositionY() ) )
     local  move2=cc.MoveTo:create(6, cc.p(  x,_obj:getPositionY() ) )
     local action = cc.RepeatForever:create(cc.Sequence:create(move1,move2))
     _obj:stopAllActions()
     _obj:runAction(action)
end

function LoginScene:fun_endanimation(_obj,_image,_type,_istrue)   
      local  cliper = cc.ClippingNode:create()
      local  _content=_obj
      local  stencil = _content
      local spark = display.newSprite("LoginScene_Main/"  .. _image  )
      spark:setPosition(cc.p(_content:getPositionX()-  _type,_content:getPositionY()));
     -- spark:setColor(cc.c3b(250,100,30))
      cliper:setAlphaThreshold(0.5)
      cliper:setStencil(stencil)
      cliper:addChild(spark)
      cliper:setVisible(_istrue)
      cliper:setLocalZOrder(9999)
      self.WeChat:addChild(cliper)
      local moveTo = cc.MoveTo:create(4,cc.p(_content:getPositionX()+_type,_content:getPositionY()))
      local moveBack = cc.MoveTo:create(4,cc.p(_content:getPositionX()-_type,_content:getPositionY()))  --moveTo:reverse()  --
     -- local seq1=cc.Sequence:create(cc.FadeIn:create(4),cc.FadeOut:create(4))  --FadeOut
      local seq = cc.Sequence:create(moveTo,moveBack)
      local spawn = cc.Spawn:create( seq)
      local SpeedTest_action1 = cc.Speed:create(cc.RepeatForever:create(spawn), 2.0)
      spark:runAction(SpeedTest_action1)
end 
--微信头像下载
function LoginScene:fun_WeChat_avatar_pic(  )
    local _table={}
    _table["imageurl"]=Util:getWeixinLoginDate().headimgurl
    _table["max_pic_idx"]=1
    _table["curr_pic_idx"]=1
    Server:Instance():jackpotlayer_pic(_table["imageurl"],_table) --下载图片
end
--  微信登陆界面
function LoginScene:landing_init()
     
      self.WeChat = cc.CSLoader:createNode("LoginScene.csb")
      self:addChild(self.WeChat,100)
      
        self:fun_LoadingNodebar_act(self.WeChat)
      self.wechat_bt=self.WeChat:getChildByName("wechat"):getChildByName("btn_Wechat")   --getChildByTag(561):getChildByTag(561)
      self.wechat_bt:setLocalZOrder(100)
      local _table=LocalData:Instance():get_version_date()--游戏中心和 商城开关
      if _table and tonumber(_table["shopIsused"])==0 then
           self.wechat_bt:setVisible(false)
      else
          self.wechat_bt:setVisible(true)
      end

      --微信登陆按钮
      self.wechat_bt:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                  cc.UserDefault:getInstance():setStringForKey("WeChat_landing","1")
                   self:function_bt_act(self.wechat_bt,"weixindenglu-anniu-guangxiao-",4,0.2,true,10011)
                   local function stopAction()
                             self.WeChat:removeChildByTag(10011, true)
                             self:fun_countdown(true)     
                                
                  end
                  local function stopAction1()   
                             --self:push_buffer(false)  
                             self.floating_layer:show_http(false,"授权中")  
                  end
                  --self:push_buffer(true) 
                  self.floating_layer:show_http(true,"授权中")
                  local callfunc = cc.CallFunc:create(stopAction)
                  local callfunc1 = cc.CallFunc:create(stopAction1)
                 self:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),callfunc,cc.DelayTime:create(2.0),callfunc1))
                 Util:weixinLogin() 
                 self.is_wechat_reg=false
      end)

      self.phone_bt=self.WeChat:getChildByName("wechat"):getChildByName("btn_Mobile")
      self.phone_bt:setLocalZOrder(100)
      self.phone_bt:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                 cc.UserDefault:getInstance():setStringForKey("WeChat_landing","2")
                  self:function_bt_act(self.phone_bt,"shoujidenglu-anniu-guanxiao-",4,0.2,true,20020)
                   local function stopAction()
                              self.WeChat:removeChildByTag(20020, true)
                               self:_landing_interface()
                               self.WeChat:removeFromParent()
                  end
                  local callfunc = cc.CallFunc:create(stopAction)
                 self:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),callfunc  ))

      end)
      self:fun_endanimation(self.wechat_bt,"LG_AN_2_1.png",-self.wechat_bt:getContentSize().width,true)
     self:fun_endanimation(self.phone_bt,"LG_AN_1_1.png",self.phone_bt:getContentSize().width,true)
end

--按钮动画 
function LoginScene:function_bt_act(_obj,_img,_count,_speed,isvisible,_tag)  
  local animation = cc.Animation:create()
  local name=nil
  for i=1,_count do
    name = "LoginScene_Main/".."LG_AN_1_1_"..i..".png"
    animation:addSpriteFrameWithFile(name)
  end
  animation:setDelayPerUnit(_speed)
  animation:setRestoreOriginalFrame(true)
  --创建动作
  local animate = cc.Animate:create(animation)
  self._template = cc.Sprite:create()
  self._template:setVisible(isvisible)
  self._template:setPosition(cc.p(_obj:getPositionX(),_obj:getPositionY()))
  self.WeChat:addChild(self._template,200,_tag)  --  
  local seq=cc.RepeatForever:create(cc.Sequence:create(animate))    
  --_template:stopAllActions()
  self._template:runAction(seq)--(animate)

end

--  登陆界面
function LoginScene:_landing_interface()
    -- landing = cc.CSLoader:createNode("landing.csb");
    -- self:addChild(landing)
     landing = cc.CSLoader:createNode("LoadingNode.csb");  --LoadingNode   LoginNode_Mobile
    self:addChild(landing)
    self.LoginNode_Mobile=cc.CSLoader:createNode("LoginNode_Mobile.csb")
    landing:addChild(self.LoginNode_Mobile)


    landing:setTag(1314)

     local land_back_bt=landing:getChildByName("Image_2")
      land_back_bt:addTouchEventListener(function(sender, eventType  )
                if eventType == 3 then
                       sender:setScale(1)
                       return
                end

                if eventType ~= ccui.TouchEventType.ended then
                     sender:setScale(1.2)
                     return
                end
                sender:setScale(1)
                self:landing_init()
                self:removeChildByTag(1314, true)
      end)

  
   -- local dialog=FloatingLayer:Instance():floatingLayer_init("多少分开始的")
   -- self:addChild(dialog)
   -- self:replaceScene(dialog)
  phone_bg=landing:getChildByTag(6)

  local Editphone = self.LoginNode_Mobile:getChildByName("TextField_1")
  self.Dphone_text=Editphone
  Util:function_keyboard(self.LoginNode_Mobile,Editphone,23,245,126,20)
  Editphone:setPlaceHolder("请输入手机号码")
  -- Editphone:setTouchEnabled(false)
  -- Editphone:setVisible(false)

  local EditPassword=self.LoginNode_Mobile:getChildByName("TextField_1_Copy")
  self.Dpassword_text=EditPassword
  Util:function_keyboard(self.LoginNode_Mobile,EditPassword,14,245,126,20)
  EditPassword:setPlaceHolder("请输入密码")

  -- EditPassword:setTouchEnabled(false)
  -- EditPassword:setVisible(false)


    -- local res = " "--res/png/DLkuang.png"
    -- local width = 350
    -- local height = 40
    -- --登陆
    -- self.Dphone_text = ccui.EditBox:create(cc.size(width,height),res)
    -- self.Dphone_text:setPlaceHolder("请输入手机号码")  --setString
    -- self.Dphone_text:setVisible(true)
    -- self.Dphone_text:setPosition(cc.p(Editphone:getPositionX(),Editphone:getPositionY()))--( cc.p(107,77 ))  
    -- self.Dphone_text:setAnchorPoint(0,0.5)  
    -- self.Dphone_text:setMaxLength(11)
    -- phone_bg:addChild(self.Dphone_text)
    -- print("层级关系",self.Dphone_text:getLocalZOrder(),"  ",phone_bg:getLocalZOrder())

    -- self.Dpassword_text = ccui.EditBox:create(cc.size(width,height),res)
    -- self.Dpassword_text:setVisible(true)
    -- phone_bg:addChild(self.Dpassword_text )
    -- self.Dpassword_text :setPosition(cc.p(EditPassword:getPositionX(),EditPassword:getPositionY()))--( cc.p(107,25 ))  
    -- self.Dpassword_text :setPlaceHolder("请输入密码")
    -- self.Dpassword_text :setAnchorPoint(0,0.5)  
    -- self.Dpassword_text :setMaxLength(19)
    -- self.Dpassword_text :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)


local function go_btCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended then

             if  self.Dphone_text:getString() == "" then
                Server:Instance():promptbox_box_buffer("填写的手机号不能为空哦！")   --prompt
                return
            end
            if tostring(Util:judgeIsAllNumber(tostring(self.Dphone_text:getString())))  ==  "false"  then
                Server:Instance():promptbox_box_buffer("账号不存在") 
                return
            end
           
            if  string.len(self.Dphone_text:getString()) < 11 then
                Server:Instance():promptbox_box_buffer("手机号填写错误")   --prompt
                return
            end
            if  string.len(self.Dphone_text:getString()) ==  11  and  self.Dpassword_text:getString()  ==  ""   then
                Server:Instance():promptbox_box_buffer("输入的密码须在6～20位之间哦")   --prompt
                return
            end


            self._gobt:setTouchEnabled(false)
           local function stopAction()
                          self._gobt:setTouchEnabled(true)

             end
              local callfunc = cc.CallFunc:create(stopAction)
             sender:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
             Server:Instance():login(self.Dphone_text:getString(),self.Dpassword_text :getString())


        end   
    end

    local function registered_btCallback(sender, eventType)

        if eventType == ccui.TouchEventType.ended then
           print("注册")
            -- self.registered = cc.CSLoader:createNode("registered.csb");
            -- self:addChild(self.registered);

            self.registered = cc.CSLoader:createNode("LoadingNode.csb");  --LoadingNode   LoginNode_Mobile
            self:addChild(self.registered)
            self.LoginNode_Register=cc.CSLoader:createNode("LoginNode_Register.csb")
            self.registered:addChild(self.LoginNode_Register)

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
                -- self.passwordLayer = cc.CSLoader:createNode("passwordLayer.csb");
                -- self:addChild(self.passwordLayer);

                self.passwordLayer = cc.CSLoader:createNode("LoadingNode.csb");  --LoadingNode   LoginNode_Mobile
                self:addChild(self.passwordLayer)
                self.LoginNode_Forget=cc.CSLoader:createNode("LoginNode_Forget.csb")
                self.passwordLayer:addChild(self.LoginNode_Forget)

                self:_passwordLayer()
                self.p_random=00
        end
    end


   self._gobt =self.LoginNode_Mobile:getChildByName("btn_Login")
   --self._gobt=go_bt
    self._gobt:addTouchEventListener(go_btCallback)

     local registered_bt = self.LoginNode_Mobile:getChildByName("btn_Register")
    registered_bt:addTouchEventListener(registered_btCallback)

     local Forgotpassword_bt = self.LoginNode_Mobile:getChildByName("btn_Fogret")--忘记密码
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

          local _back = self.passwordLayer:getChildByName("Image_2")
          _back:addTouchEventListener((function(sender, eventType  )
                      if eventType == 3 then
                       sender:setScale(1)
                       return
                     end
                      if eventType ~= ccui.TouchEventType.ended then
                               sender:setScale(1.2)
                               return
                          end
                          sender:setScale(1)

                          if self._scode then
                            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                      end
                      --self:landing_init()
                       self:_landing_interface()
                      if  self.passwordLayer then
                         self.passwordLayer:removeFromParent()
                      end

               end))

          local submit = self.LoginNode_Forget:getChildByName("btn_Submit")
          -- self.changepassword_bt=submit
          -- self.changepassword_bt:setTouchEnabled(false)
          submit:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))
           self.yanzhengma = self.LoginNode_Forget:getChildByName("btn_Token")
           self.code_bt=self.yanzhengma
          self.yanzhengma:addTouchEventListener((function(sender, eventType  )
                     --self:touch_Callback(sender, eventType)

                      if eventType ~= ccui.TouchEventType.ended then
                            
                       return
                     end
           

                    self.p_random=Util:rand(  ) --随机验证码\
                    local phone=self.LoginNode_Forget:getChildByName("TextField_1")
                    self._mobilephone=self.Wphone_text:getString()
                     if tostring(Util:judgeIsAllNumber(tostring(self.Wphone_text:getString())))  ==  "false"  then
                      Server:Instance():promptbox_box_buffer("请输入正确的手机号") 
                      return
                   end 
                    if string.len(self._mobilephone)~=11 then
                     Server:Instance():promptbox_box_buffer("填写手机号码错误")
                     return
                    end

                    sender:setTouchEnabled(false)
                    --sender:setColor(cc.c3b(100, 100, 100))
                    self.layertype=2
                    Server:Instance():sendmessage(2,self._mobilephone)

               end))


            local phone=self.LoginNode_Forget:getChildByName("TextField_1")
            -- phone:setVisible(false)
            -- phone:setTouchEnabled(false)
            self.Wphone_text=phone
            Util:function_keyboard(self.passwordLayer,phone,23,245,126,20) 
            local Wcode_text = self.LoginNode_Forget:getChildByName("TextField_1_Copy")
            self._yanzhengma=Wcode_text
            Util:function_keyboard(self.passwordLayer,Wcode_text,23,245,126,20) 
            -- Wcode_text:setVisible(false)
            -- Wcode_text:setTouchEnabled(false)

            local res = "  "--res/png/DLkuang.png"
            local width = 300
            local height = 40
            --忘记密码
            -- self.Wphone_text = ccui.EditBox:create(cc.size(width,height),res)
            -- self.passwordLayer:addChild(self.Wphone_text)
            -- self.Wphone_text:setPosition(cc.p(phone:getPositionX(),phone:getPositionY()))--( cc.p(58,441 ))  
            -- self.Wphone_text:setPlaceHolder("请输入手机号码")
            -- self.Wphone_text:setAnchorPoint(0,0.5)  
            -- self.Wphone_text:setMaxLength(11)

            -- self._yanzhengma = ccui.EditBox:create(cc.size(120,40),res)
            -- self.passwordLayer:addChild(self._yanzhengma)
            -- self._yanzhengma:setPosition(cc.p(Wcode_text:getPositionX(),Wcode_text:getPositionY()))--( cc.p(58,356 ))  
            -- self._yanzhengma:setPlaceHolder("验证码")
            -- self._yanzhengma:setAnchorPoint(0,0.5)  
            -- self._yanzhengma:setMaxLength(6)

end
function LoginScene:touch_Callback( sender, eventType  )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getTag()
              if tag==290 then      --修改密码 返回
                  
             elseif tag==141 then   --修改密码 提交
               if string.len(self.Wphone_text:getString())~=11 then
                  Server:Instance():promptbox_box_buffer("填写手机号码错误")
               return
              end
               if tostring(Util:judgeIsAllNumber(tostring(self.Wphone_text:getString())))  ==  "false"  then
                      Server:Instance():promptbox_box_buffer("请输入正确的手机号") 
                      return
                   end 
             
              if self._yanzhengma:getString()  ==  "" then
                 Server:Instance():promptbox_box_buffer("验证码不能为空")
                 return
              end

                if self._scode then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
              end
              
              Server:Instance():changepassword(self._yanzhengma:getString(),3,self.Wphone_text:getString())
                --self:_resetpasswordLayer()
                
              elseif tag==305 then  --重新设置密码  返回
                
              elseif tag==151 then
                local password = self.LoginNode_NewPassword:getChildByName("tf_Password")
                local _pass=self.Wpassword_text:getString()
                  if  string.len(_pass) <6  or   string.len(Util:filter_spec_chars(_pass)) ~= string.len(_pass)    then
                    Server:Instance():promptbox_box_buffer("密码格式不对哦（密码为6-20位数字或字母的组合")   --prompt
                    return
                end
                 Server:Instance():changepassword(self.y_yanzhengma,1,self._mobilephone,_pass)  --(1  忘记密码)
              elseif tag==291 then
                 --self.changepassword_bt:setTouchEnabled(true)
                self.code_bt=self.yanzhengma
                  self.p_random=Util:rand(  ) --随机验证码\
                     local phone=self.LoginNode_Forget:getChildByName("TextField_1")
                    self._mobilephone=self.Wphone_text:getString()
                   
                   if string.len(self._mobilephone)~=11 then
                       Server:Instance():promptbox_box_buffer("填写手机号码错误")
                       return
                   end
                  
                   sender:setTouchEnabled(false)
                   --sender:setColor(cc.c3b(100, 100, 100))
                   self.layertype=2
                  Server:Instance():sendmessage(2,self._mobilephone)
                  print("邀请码"..self.p_random)
             end
end
function LoginScene:_resetpasswordLayer(  )

            self._mobilephone=self.Wphone_text:getString()
             

              if tostring(Util:judgeIsAllNumber(tostring(self.Wphone_text:getString())))  ==  "false"  then
                Server:Instance():promptbox_box_buffer("账号不存在") 
                 self.yanzhengma:setVisible(true)
                  self.yanzhengma:setTouchEnabled(true)
                  self.yanzhengma:setColor(cc.c3b(255, 255, 255))
                  self.yanzhengma:setTitleText("获取验证码")
                return
             end
            if  string.len(self.Wphone_text:getString()) < 11 then
                          Server:Instance():promptbox_box_buffer("手机号填写错误")   --prompt
                          self.yanzhengma:setVisible(true)
                          self.yanzhengma:setTouchEnabled(true)
                          self.yanzhengma:setColor(cc.c3b(255, 255, 255))
                          self.yanzhengma:setTitleText("获取验证码")
                          return
            end



            if tostring(self._yanzhengma:getString())=="" then
                 Server:Instance():promptbox_box_buffer("验证码不能为空,请重新输入")
                 self.yanzhengma:setVisible(true)
                  self.yanzhengma:setTouchEnabled(true)
                  self.yanzhengma:setColor(cc.c3b(255, 255, 255))
                  self.yanzhengma:setTitleText("获取验证码")

                return
            end

           --  if tostring(self._yanzhengma:getText())  ~= tostring(self.p_random) then
           --    Server:Instance():promptbox_box_buffer("验证码错误")
           --    return    
           -- end
            self.y_yanzhengma=self._yanzhengma:getString()
            if  tostring(self._mobilephone) == " "   then
               return
            end
           
            -- self.resetpasswordLayer = cc.CSLoader:createNode("resetpasswordLayer.csb");
            -- self:addChild(self.resetpasswordLayer);


            self.resetpasswordLayer = cc.CSLoader:createNode("LoadingNode.csb");  --LoadingNode   LoginNode_Mobile
            self:addChild(self.resetpasswordLayer)
            self.LoginNode_NewPassword=cc.CSLoader:createNode("LoginNode_NewPassword.csb")
            self.resetpasswordLayer:addChild(self.LoginNode_NewPassword)



            self.resetpasswordLayer:setTag(7531)

             local _back = self.resetpasswordLayer:getChildByName("Image_2")
             _back:addTouchEventListener((function(sender, eventType  )
                    if eventType == 3 then
                       sender:setScale(1)
                       return
                     end
                     
                    if eventType ~= ccui.TouchEventType.ended then
                         sender:setScale(1.2)
                         return
                    end
                    sender:setScale(1)
                    self:_landing_interface()
                    if self.resetpasswordLayer then
                    self:removeChildByTag(7531, true)
                    end

               end))
             local submit = self.LoginNode_NewPassword:getChildByName("btn_Submit")
             submit:addTouchEventListener((function(sender, eventType  )
                     self:touch_Callback(sender, eventType)
               end))
             local phone = self.LoginNode_NewPassword:getChildByName("Text_1")
             phone:setString(self._mobilephone)
             local password1 = self.LoginNode_NewPassword:getChildByName("tf_Password")
             self.Wpassword_text=password1
             Util:function_keyboard(self.resetpasswordLayer,password1,14,245,126,20) 
             -- password1:setVisible(false)
             -- password1:setTouchEnabled(false)
              local res = "  "--res/png/DLkuang.png"
              local width = 350
              local height = 40
             --修改密码
              -- self.Wpassword_text = ccui.EditBox:create(cc.size(width,height),res)
              -- self.resetpasswordLayer:addChild(self.Wpassword_text )
              -- self.Wpassword_text :setPosition(cc.p(password1:getPositionX()-200,password1:getPositionY()))--( cc.p(100,375 ))  
              -- self.Wpassword_text :setPlaceHolder("请输入密码")
              -- self.Wpassword_text :setAnchorPoint(0,0.5)  
              -- self.Wpassword_text :setMaxLength(19)
              -- self.Wpassword_text :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
              
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
                self.code_bt:setVisible(true)
                self.code_bt:setColor(cc.c3b(255, 255, 255))
              end
               cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止定时器
                 self.code_bt:setTitleText("获取验证码")
             
           end
end
function LoginScene:fun_countdowncode( )
      self._scode=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdowncode()
              end,1.0, false)
end

function LoginScene:onEnter()
  --audio.playMusic(G_SOUND["LOGO"],true)
  cc.SpriteFrameCache:getInstance():addSpriteFrames("LoadingNode/LG_32.plist")
   Server:Instance():version_login_url()  
    Util:player_music_hit("GAMEBG",true )
   
  
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.VERSION_LINK, self,
                       function()
                              if version_upd==0 then
                                  --请求版本更新链接
                                  Server:Instance():getversion()
                                  version_upd=2
                              end
                      end)

   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self,
                       function()
                        Util:scene_control("MainInterfaceScene")
                        --display.replaceScene(require("app.scenes.MainInterfaceScene"):new())
                        --display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self,
                       function()
                       print("注册的验证码")
                       self._code=50
                       if  self.layertype==1 then
                           self.code_bt=self.Getverificationcode_bt
                          -- self.code_bt:setVisible(false)
                        elseif self.layertype==2 then
                           self.code_bt=self.yanzhengma
                       end
                       self.code_bt:setTitleText("50S")
                       self:fun_countdowncode()
                      end)
   NotificationCenter:Instance():AddObserver("wangjimima", self,
                       function()
                 
                        print("振奋")
                        if self._scode then
                                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                         end  
                             if self.code_bt then
                                   self.code_bt:setVisible(true)
                                    self.code_bt:setTouchEnabled(true)
                                    self.code_bt:setColor(cc.c3b(255, 255, 255))
                                    self.code_bt:setTitleText("获取验证码")
                             end
                             



                      end)

    NotificationCenter:Instance():AddObserver("zhucechegngong", self,
                       function()
                        print("开始99")
                         if  self.registered then
                              --self:landing_init()
                              
                             if self._scode then
                              print("振奋")
                             
                                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                             end
                              self.Getverificationcode_bt:setVisible(true)
                              self.Getverificationcode_bt:setTouchEnabled(true)
                              self.Getverificationcode_bt:setColor(cc.c3b(255, 255, 255))
                              self.Getverificationcode_bt:setTitleText("获取验证码")

                               -- self.registered:removeFromParent()
                               -- self.registered=nil
                         end
                      end)
     NotificationCenter:Instance():AddObserver("zhuceshibai", self,
                       function()
                         
                         if  self.registered then
                              --self:landing_init()
                             
                             -- if self._scode then
                             --  print("振奋")
                             
                             --    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                             -- end
                              -- self.Getverificationcode_bt:setVisible(true)
                              -- self.Getverificationcode_bt:setTouchEnabled(true)
                              -- self.Getverificationcode_bt:setColor(cc.c3b(255, 255, 255))
                              -- self.Getverificationcode_bt:setTitleText("获取验证码")

                               -- self.registered:removeFromParent()
                               -- self.registered=nil
                         end
                      end)


    NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.REG, self,--注册成功返回
                       function()
                         

                         if  self.registered then
                              -- self:landing_init()
                               if self.Getverificationcode_bt then
                                  self.Getverificationcode_bt:setTouchEnabled(true)
                                  self.Getverificationcode_bt:setColor(cc.c3b(255, 255, 255))
                              end
                              --    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止定时器
                                   self.Getverificationcode_bt:setTitleText("获取验证码")
                                  print("开始")
                             if self._scode then
                                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                             end

                               --self.registered:removeFromParent()
                               --self.registered=nil
                         end
                        
                      end)

   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.PASSWOEDCHANGE, self,
                       function()
                         if self.resetpasswordLayer then
                                --self.resetpasswordLayer:removeFromParent()
                                self:removeChildByTag(7531, true)
                                self:landing_init()
                         end
                      end)



--热更消息接收  
 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.VERRSION, self,function()
                          self:getVersionInfo()
                        end)
 --  注册成功
 NotificationCenter:Instance():AddObserver("REG_CALLBACK", self,function()
                  
                  Util:scene_control("MainInterfaceScene")--成功后直接跳转主界面
                  --display.replaceScene(require("app.scenes.MainInterfaceScene"):new())
                   if self._scode then
                      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scode)--停止注册定时器
                   end
                   if  self.registered then
                         self.registered:removeFromParent()
                         self.registered=nil
                  end

                        end)
 --  注册成功
 NotificationCenter:Instance():AddObserver("CHANGEPASSWORD", self,function()
                    self:_resetpasswordLayer()
                    
                        end)


end
function LoginScene:onExit()
  --audio.stopMusic(G_SOUND["LOGO"])
    --Util:stop_music("LOGO")
  cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("LoadingNode/LG_32.plist")
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REG, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)

  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.PASSWOEDCHANGE, self)
  NotificationCenter:Instance():RemoveObserver("REG_CALLBACK", self)
  NotificationCenter:Instance():RemoveObserver("CHANGEPASSWORD", self)


  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.VERRSION, self)
  
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.VERSION_LINK, self)
  NotificationCenter:Instance():RemoveObserver("wangjimima", self)
  NotificationCenter:Instance():RemoveObserver("zhucechegngong", self)
  NotificationCenter:Instance():RemoveObserver("zhuceshibai", self)
  cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
function LoginScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function LoginScene:push_buffer(is_buffer)
  dump("网络监听2")
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
            self:fun_countdown(false)
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
        loadingBar:getChildByTag(255):setString(tostring(percent).."%")
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


    if tonumber(up_date["Isused"])==0 then--Isused 0.开启热更，1 关闭热更
      
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
    self:fun_countdown(false)
end


function LoginScene:reset()
        print("--删除--")
        pathToSave = createDownloadDir()
        deleteDownloadDir(pathToSave)

        -- getAssetsManager():deleteVersion()

        createDownloadDir()
 end




return LoginScene