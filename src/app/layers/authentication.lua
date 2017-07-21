--  实名认证  手机认证

local authentication = class("authentication", function()
            return display.newLayer("authentication")
end)

function authentication:ctor(params)
       local _tag=params._tag
       self:setNodeEventEnabled(true)
       --  初始化界面
           --  定时器
    self.time=50
    self.secondOne = 0
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self:update(dt)
    end)
       self:fun_init(_tag)
end
function authentication:fun_init(_tag)
	local fragment_sprite_bg = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
            self:addChild(fragment_sprite_bg)
            
            
	if _tag==1 then

		self.ThephoneauthenticationNode = cc.CSLoader:createNode("ThephoneauthenticationNode.csb");
		self:addChild(self.ThephoneauthenticationNode)
		self.Thephoneauthentication=self.ThephoneauthenticationNode:getChildByTag(1984)
		self:fun_Thephoneauthentication()
	else
		self.RealnameauthenticationNode = cc.CSLoader:createNode("RealnameauthenticationNode.csb");
		self:addChild(self.RealnameauthenticationNode)
		self.Realnameauthentication=self.RealnameauthenticationNode:getChildByTag(2014)
		self:fun_Realnameauthentication()
	end
end
function authentication:fun_Thephoneauthentication( ... )
	self.ThephoneauthenticationNode:setScale(0.7)
            self.ThephoneauthenticationNode:setAnchorPoint(0.5,0.5)
            self.ThephoneauthenticationNode:setPosition(320, 568)
            Util:layer_action(self.ThephoneauthenticationNode,self,"open") 

	local str_phone=self.Thephoneauthentication:getChildByTag(1779)  --手机号
	Util:function_keyboard(self.Thephoneauthentication,str_phone,23)
	local str_code=self.Thephoneauthentication:getChildByTag(1781) --验证码
	Util:function_keyboard(self.Thephoneauthentication,str_code,23)
	local btn_Back=self.Thephoneauthentication:getChildByTag(1782)
          	btn_Back:addTouchEventListener(function(sender, eventType  )
	                  if eventType == 3 then
		           sender:setScale(1)
		           return
		      end
		      if eventType ~= ccui.TouchEventType.ended then
		         sender:setScale(1.2)
		         return
		      end
		      sender:setScale(1)
                  Server:Instance():getuserinfo()
		      self:unscheduleUpdate()
		      Util:layer_action(self.ThephoneauthenticationNode,self,"close") 
            end)
            --发送验证码
            self.btn_code=self.Thephoneauthentication:getChildByTag(1778)
          	self.btn_code:addTouchEventListener(function(sender, eventType  )
	                if eventType ~= ccui.TouchEventType.ended then
	                   return
	               end
	               if tostring(Util:judgeIsAllNumber(tostring(str_phone:getString())))  ==  "false"    then
		              Server:Instance():promptbox_box_buffer("手机号码格式错误")
		              return
          		  end
          		  if string.len(str_phone:getString()) < 11 then
		              Server:Instance():promptbox_box_buffer("手机号填写错误")
		              return
          		  end
          		  self.btn_code:setTouchEnabled(false)
          		  Server:Instance():sendmessage(4,str_phone:getString())
            end)
            --提交
            local btn_submit=self.Thephoneauthentication:getChildByTag(1776)
          	btn_submit:addTouchEventListener(function(sender, eventType  )
	                if eventType ~= ccui.TouchEventType.ended then
	                   return
	               end
	               self:unscheduleUpdate()
	               self.time=50
	               self.btn_code:setTitleText("获取验证码")
	               self.btn_code:setTouchEnabled(true)
                     Server:Instance():getusercitybyphone()
	               Server:Instance():phoneverify(str_phone:getString(),str_code:getString())
            end)
end
function authentication:fun_Realnameauthentication( ... )
	self.RealnameauthenticationNode:setScale(0.7)
            self.RealnameauthenticationNode:setAnchorPoint(0.5,0.5)
            self.RealnameauthenticationNode:setPosition(320, 568)
            Util:layer_action(self.RealnameauthenticationNode,self,"open") 

	local Id_card=self.Realnameauthentication:getChildByTag(1804)  --手机号
	Util:function_advice_keyboard(self.Realnameauthentication,Id_card,40)
	
	local btn_Back=self.Realnameauthentication:getChildByTag(1803)
          	btn_Back:addTouchEventListener(function(sender, eventType  )
	                  if eventType == 3 then
		           sender:setScale(1)
		           return
		      end
		      if eventType ~= ccui.TouchEventType.ended then
		         sender:setScale(1.2)
		         return
		      end
		      sender:setScale(1)
		      Util:layer_action(self.RealnameauthenticationNode,self,"close") 
            end)
            --提交
            local btn_submit=self.Realnameauthentication:getChildByTag(1805)
          	btn_submit:addTouchEventListener(function(sender, eventType  )
	                if eventType ~= ccui.TouchEventType.ended then
	                   return
	               end
	                if tostring(Util:judgeIsAllNumber(tostring(Id_card:getString())))  ==  "false"    then
		              Server:Instance():promptbox_box_buffer("身份证号码格式错误")
		              return
          		  end
          		  if string.len(Id_card:getString()) < 18 then
		              Server:Instance():promptbox_box_buffer("身份证号填写错误")
		              return
          		  end
	              print("提交")
            end)
end
function authentication:update(dt)
            self.secondOne = self.secondOne+dt
            if self.secondOne <1 then return end
            self.secondOne=0
            self.time=self.time-1
            self.btn_code:setTitleText(tostring(self.time)  ..  " S")
            if self.time==0 then
            	self:unscheduleUpdate()
            	self.btn_code:setTitleText("获取验证码")
            	self.btn_code:setTouchEnabled(true)
            	self.time=50
            end
              
end
function authentication:onEnter()
   
  NotificationCenter:Instance():AddObserver("wangjimima", self,
                       function()
                                  self.btn_code:setTouchEnabled(true)
                      end)
    NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self,
                       function()
                                  self.btn_code:setTitleText("50S")
                                  self:scheduleUpdate()
                      end)
    NotificationCenter:Instance():AddObserver("phoneverifyfalse", self,
                       function()
                                  self:scheduleUpdate()
                      end)
    
end

function authentication:onExit()
      NotificationCenter:Instance():RemoveObserver("wangjimima", self)
      NotificationCenter:Instance():RemoveObserver("wangjimima", self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REGISTRATIONCODE, self)
      
end

return authentication




