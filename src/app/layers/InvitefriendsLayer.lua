--
-- Author: peter
-- Date: 2016-06-14 11:58:11
--
--
-- Author: peter
-- Date: 2016-06-13 15:55:45
--邀请好友排行榜 
local InvitefriendsLayer = class("InvitefriendsLayer", function()
            return display.newScene("InvitefriendsLayer")
end)
function InvitefriendsLayer:ctor()--params

       self:setNodeEventEnabled(true)--layer添加监听

       --Server:Instance():get_reward_friend_list() --初始化未领取金币
       Server:Instance():get_reward_of_friends_levelup()
       Server:Instance():getfriendlist()--查询好友列表   
       
        -- self:fun_init()-- 数据初始化
end
function InvitefriendsLayer:init(  )
       self.Invitefriends = cc.CSLoader:createNode("Invitefriends.csb")  --邀请好友排行榜
       self:addChild(self.Invitefriends)
        self:pop_up()--  弹出框
       local back_bt=self.Invitefriends:getChildByTag(82)  --返回
	back_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
       local friendrequest_bt=self.Invitefriends:getChildByTag(117)  --好友邀请
	friendrequest_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
       local feedback_bt=self.Invitefriends:getChildByTag(118)  --回馈邀请人
	feedback_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
       local obtain_bt=self.Invitefriends:getChildByTag(106):getChildByTag(116)  --一键获取
	obtain_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       self._ListView=self.Invitefriends:getChildByTag(91)--邀请好友排行list
       self._ListView:setItemModel(self._ListView:getItem(0))
       self._ListView:removeAllItems()

       self:fun_init()-- 数据初始化


end
function InvitefriendsLayer:fun_init(  )
            --以下都是测试
             local receive_table =  LocalData:Instance():get_reward_friend()
             if  not receive_table then
             	return
             end
            
             local _playerinfo = receive_table["playerinfo"]
   
            local friendlist_table=LocalData:Instance():getfriendlist()

	local inviter_text=self.Invitefriends:getChildByTag(85):getChildByTag(88)  --邀请的人数
            inviter_text:setString("已经成功邀请 " .. tostring(#friendlist_table["friendlist"]) .. " 人")

            local databg_text=self.Invitefriends:getChildByTag(106)  --数据背景

            local totalgold_text=databg_text:getChildByTag(111)   --总金币
            totalgold_text:setString("88868")

            local totalexperience_text=databg_text:getChildByTag(112) --总经验
            totalexperience_text:setString("88868")

            local gold_text=databg_text:getChildByTag(113)  --未领取的金币
            gold_text:setString(_playerinfo["curgolds"])

            local experience_text=databg_text:getChildByTag(114) --未领取的经验
            experience_text:setString("88868")
           

            if #friendlist_table["friendlist"]==0 then
            	return
            end
            for i=1,#friendlist_table["friendlist"] do
	          	 self._ListView:pushBackDefaultItem()
	          	local  cell =  self._ListView:getItem(i-1)
	            cell:setTag(i)
	            local  nickname =  call:getChildByTag(94)
	            nickname:setString(friendlist_table["nickname"])
	            local  grade =  call:getChildByTag(96)
	            grade:setString("LV." .. friendlist_table["grade"] )
	            local  imgurl =  call:getChildByTag(105)
	            imgurl:loadTexture("cre/"..LocalData:Instance():get_user_head())--(tostring(Util:sub_str(friendlist_table["imgurl"], "/",":")))
	     
           end

	
end
function InvitefriendsLayer:pop_up(  )
       self.Friendsstep = cc.CSLoader:createNode("Friendsstep.csb")  --
       self:addChild(self.Friendsstep)
       self.Friendsstep:setVisible(false)
       self.m_feedback=self.Friendsstep:getChildByTag(226)  --回馈邀请人界面
       self.m_feedback:setVisible(false)
       self.m_friend=self.Friendsstep:getChildByTag(238)  --邀请好友界面
       self.m_friend:setVisible(false)
       
       self.invitecode_num=self.m_feedback:getChildByTag(236) -- 输入邀请码
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

function InvitefriendsLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==82 then --返回
		self:removeFromParent()
	elseif tag==117 then
		self.Friendsstep:setVisible(true)
		self.m_friend:setVisible(true)
	elseif tag==118 then
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
		Util:share()
	elseif tag==230 then  --下次再说
		self.Friendsstep:setVisible(false)
		self.m_friend:setVisible(false)
	elseif tag==231 then  --获取输入码
		local _num=self.invitecode_num:getString()
		Server:Instance():setinvitecode(tostring(_num))  --测试（与策划不符）
		print("获取输入码",_num)
	elseif tag==116 then  --一键获取
		 local receive_table =  LocalData:Instance():get_reward_friend()
                         local _playerinfo = receive_table["playerinfo"]
                         if _playerinfo["curgolds"]==0 then
                         	Server:Instance():prompt("没有金币领取")
                         	return
                         end
                        local friendlist_table=LocalData:Instance():getfriendlist()
		print("一键获取")
		Server:Instance():get_reward_of_friends_levelup()
	
	
	end
end
function InvitefriendsLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self,
                       function()
                       	            print("初始化")
                      		self:init()
                      end)
	 -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self,
  --                      function()
  --                     		print("个人信息修改")
  --                     end)
end

function InvitefriendsLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self)
     	 -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self)
end

return InvitefriendsLayer

















