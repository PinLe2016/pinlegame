--
-- Author: peter
-- Date: 2016-06-13 15:55:45
--邀请好友 
local FriendrequestLayer = class("FriendrequestLayer", function()
            return display.newScene("FriendrequestLayer")
end)
function FriendrequestLayer:ctor()--params

       self:setNodeEventEnabled(true)--layer添加监听

       self:init()
      
end
function FriendrequestLayer:init(  )
       self.Friendrequest = cc.CSLoader:createNode("Friendrequest.csb")
       self:addChild(self.Friendrequest)
       self:pop_up()--弹出框
       local back_bt=self.Friendrequest:getChildByTag(123)  --返回
	back_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt1=self.Friendrequest:getChildByTag(129):getChildByTag(135)  --领取1
	receive_bt1:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt2=self.Friendrequest:getChildByTag(130):getChildByTag(138)--领取2
	receive_bt2:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt3=self.Friendrequest:getChildByTag(131):getChildByTag(141)--领取3
	receive_bt3:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt4=self.Friendrequest:getChildByTag(132):getChildByTag(144)--领取4
	receive_bt4:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local friend_bt=self.Friendrequest:getChildByTag(161)  --好友邀请
	friend_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local feedback_bt=self.Friendrequest:getChildByTag(162)  --回馈邀请人
	feedback_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

end

function FriendrequestLayer:pop_up(  )
       self.Friendsstep = cc.CSLoader:createNode("Friendsstep.csb")  --谈出框
       self:addChild(self.Friendsstep)
       self.Friendsstep:setVisible(false)
       self.m_feedback=self.Friendsstep:getChildByTag(226)  --回馈邀请人界面
       self.m_feedback:setVisible(false)
       self.m_friend=self.Friendsstep:getChildByTag(238)  --邀请好友界面
       self.m_friend:setVisible(false)

       local friend_back=self.m_friend:getChildByTag(242)  --好友返回
	friend_back:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local share_bt=self.m_friend:getChildByTag(243)  --前往邀请  分享
	share_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

      local feedback_back=self.m_feedback:getChildByTag(229)  --回馈返回
	feedback_back:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local _backbt=self.m_feedback:getChildByTag(230)  --下次再说
	_backbt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local obtain_bt=self.m_feedback:getChildByTag(231)  --输入获取
	obtain_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
end
function FriendrequestLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==123 then --返回
		print("fanh ")
		self:removeFromParent()
	elseif tag==135 then
		print("hahahdfsfdsfdsf 1")
	elseif tag==138 then
		print("hahahdfsfdsfdsf 2")
	elseif tag==141 then
		print("hahahdfsfdsfdsf 3")
	elseif tag==144 then
		print("hahahdfsfdsfdsf 4")
	elseif tag==161 then  --好友邀请
		self.Friendsstep:setVisible(true)
		self.m_friend:setVisible(true)
	elseif tag==162 then  --回馈邀请人
		self.Friendsstep:setVisible(true)
		self.m_feedback:setVisible(true)
	elseif tag==229 then  --回馈返回
		self.Friendsstep:setVisible(false)
		self.m_feedback:setVisible(false)
	elseif tag==242 then  --好友返回
		self.Friendsstep:setVisible(false)
		self.m_friend:setVisible(false)
	elseif tag==243 then  --分享
		print("分享")
	elseif tag==230 then  --下次再说
		self.Friendsstep:setVisible(false)
		self.m_friend:setVisible(false)
	elseif tag==231 then  --获取输入码
		print("获取输入码")
	
	
	end
end
function FriendrequestLayer:onEnter()
	 -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self,
  --                      function()
  --                     		self:init()
  --                     end)
	 -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self,
  --                      function()
  --                     		print("个人信息修改")
  --                     end)
end

function FriendrequestLayer:onExit()
     	 -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self)
     	 -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self)
end

return FriendrequestLayer

















