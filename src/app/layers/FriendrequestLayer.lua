--
-- Author: peter
-- Date: 2016-06-13 15:55:45
--邀请好友 
local FriendrequestLayer = class("FriendrequestLayer", function()
            return display.newScene("FriendrequestLayer")
end)
function FriendrequestLayer:ctor()--params

       self:setNodeEventEnabled(true)--layer添加监听
       Server:Instance():get_friend_reward_setting_list()  --邀请有礼接口
       --Server:Instance():getfriendlist()--查询好友列表   
       --Server:Instance():set_friend_reward_setting()
      
end
function FriendrequestLayer:init(  )


       self.Friendrequest = cc.CSLoader:createNode("Friendrequest.csb")
       self:addChild(self.Friendrequest)
       self:pop_up()--弹出框
       local back_bt=self.Friendrequest:getChildByTag(123)  --返回
	back_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
      self.dian1=self.Friendrequest:getChildByTag(171)
      self.dian2=self.Friendrequest:getChildByTag(172)

       local PageView_=self.Friendrequest:getChildByTag(1291)
       PageView_:addEventListener(function(sender, eventType  )
                 if eventType == ccui.PageViewEventType.turning then
                  PageView_:scrollToPage(PageView_:getCurPageIndex())
                      if PageView_:getCurPageIndex()==0 then
                      	   self.dian1:setSelected(true)
                           self.dian2:setSelected(false)
                       elseif PageView_:getCurPageIndex()==1 then
                           self.dian1:setSelected(false)
                           self.dian2:setSelected(true)
                      end
                end
        end)
        self.friendlist_num=LocalData:Instance():get_reward_setting_list()  
        local friend_num=self.Friendrequest:getChildByTag(160)  --邀请的人数
        friend_num:setString(tostring(self.friendlist_num["friendcount"]) .. "人")

       
       local _list=self.Friendrequest:getChildByTag(1291):getChildByTag(1292)

        local receive_bt1=_list:getChildByTag(129):getChildByTag(135)  --领取1
	receive_bt1:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt2=_list:getChildByTag(130):getChildByTag(138)--领取2
	receive_bt2:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt3=_list:getChildByTag(131):getChildByTag(141)--领取3
	receive_bt3:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt4=_list:getChildByTag(132):getChildByTag(144)--领取4
	receive_bt4:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
	
       local _listble=self.Friendrequest:getChildByTag(1291):getChildByTag(1590)

        local receive_bt5=_listble:getChildByTag(1591):getChildByTag(1599)  --领取5
	receive_bt5:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt6=_listble:getChildByTag(1592):getChildByTag(1600)--领取6
	receive_bt6:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt7=_listble:getChildByTag(1593):getChildByTag(1601)--领取7
	receive_bt7:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local receive_bt8=_listble:getChildByTag(1594):getChildByTag(1602)--领取8
	receive_bt8:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
       self.managerlist=self.friendlist_num["managerlist"]  --tag  0可以领取  1已经领取   2好友个数不到不可领取
       local _table = {3,5,10,20,30,50,80,100}
       local lo_img={receive_bt1,receive_bt2,receive_bt3,receive_bt4,receive_bt5,receive_bt6,receive_bt7,receive_bt8}
       for i=1,#self.managerlist do
         if self.managerlist[i]["tag"]==1 then
                lo_img[i]:setTouchEnabled(true)
        end
       end

      
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
       
       local _invitecodeNum=self.m_feedback:getChildByTag(236) -- 输入邀请码
       _invitecodeNum:setVisible(false)
       _invitecodeNum:setTouchEnabled(false)
       local res = "res/png/DLkuang.png"
       local width = 300
       local height = 40
       --登陆
      self.invitecode_num = ccui.EditBox:create(cc.size(width,height),res)
      self.invitecode_num:setVisible(false)
      self.m_feedback:addChild(self.invitecode_num)
      self.invitecode_num:setPosition(cc.p(_invitecodeNum:getPositionX()-130,_invitecodeNum:getPositionY()))--( cc.p(107,77 ))  
      self.invitecode_num:setPlaceHolder("请输入手机号码")
      self.invitecode_num:setAnchorPoint(0,0.5)  
      self.invitecode_num:setMaxLength(11)



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
            Server:Instance():set_friend_reward_setting(self.managerlist[1]["Id"])--奖励
	elseif tag==138 then
		print("hahahdfsfdsfdsf 2")
            Server:Instance():set_friend_reward_setting(self.managerlist[2]["Id"])--奖励
	elseif tag==141 then
		print("hahahdfsfdsfdsf 3")
            Server:Instance():set_friend_reward_setting(self.managerlist[3]["Id"])--奖励
	elseif tag==144 then
		print("hahahdfsfdsfdsf 4")
            Server:Instance():set_friend_reward_setting(self.managerlist[4]["Id"])--奖励
	elseif tag==1599 then
		print("hahahdfsfdsfdsf 5")
            Server:Instance():set_friend_reward_setting(self.managerlist[5]["Id"])--奖励
	elseif tag==1600 then
		print("hahahdfsfdsfdsf 6")
            Server:Instance():set_friend_reward_setting(self.managerlist[6]["Id"])--奖励
	elseif tag==1601 then
		print("hahahdfsfdsfdsf 7")
            Server:Instance():set_friend_reward_setting(self.managerlist[7]["Id"])--奖励
	elseif tag==1602 then
		print("hahahdfsfdsfdsf 8")
            Server:Instance():set_friend_reward_setting(self.managerlist[8]["Id"])--奖励
	elseif tag==161 then  --好友邀请
		self.Friendsstep:setVisible(true)
		self.m_friend:setVisible(true)
	elseif tag==162 then  --回馈邀请人
		self.Friendsstep:setVisible(true)
		self.m_feedback:setVisible(true)
		self.invitecode_num:setVisible(true)
	elseif tag==229 then  --回馈返回
		self.Friendsstep:setVisible(false)
		self.m_feedback:setVisible(false)
		self.invitecode_num:setVisible(false)
	elseif tag==242 then  --好友返回
		self.Friendsstep:setVisible(false)
		self.m_friend:setVisible(false)
	elseif tag==243 then  --分享
		print("分享11")
		Util:share()
	elseif tag==230 then  --下次再说
		self.Friendsstep:setVisible(false)
		self.m_friend:setVisible(false)
	elseif tag==231 then  --获取输入码
		local _num=self.invitecode_num:getText()
		Server:Instance():setinvitecode(tostring(_num))  --测试（与策划不符）
		print("获取输入码",_num)
	
	
	end
end
function FriendrequestLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.INVITATION_POLITE, self,
                       function()
                      		 self:init()

                      end)
	 -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self,
  --                      function()
  --                     		print("个人信息修改")
  --                     end)
end

function FriendrequestLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.INVITATION_POLITE, self)
     	 -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self)
end

return FriendrequestLayer

















