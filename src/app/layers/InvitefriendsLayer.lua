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

       Server:Instance():get_reward_friend_list() --好友列表

       

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
--一键领取
function InvitefriendsLayer:friends_levelup(  )
               local friendlist_table =  LocalData:Instance():get_reward_of_friends_levelup()
             if  not friendlist_table then
              return
             end
              self._ListView:removeAllItems()
             local playerinfo=friendlist_table["playerinfo"]
            self.gold_text:setString(playerinfo["curgolds"])
            if #friendlist_table["friendlist"]==0 then
              return
            end
            local _friendlist=friendlist_table["friendlist"]
            for i=1,#_friendlist do
               self._ListView:pushBackDefaultItem()
              local  _cell =  self._ListView:getItem(i-1)
              _cell:setTag(i)
              self.nickname = _cell:getChildByTag(94)  --名字
              self.nickname:setString(_friendlist[i]["nickname"])
              self.grade =  _cell:getChildByTag(95)  --等级
              self.grade:setString( _friendlist[i]["playergrade"] )
              self.imgurl =  _cell:getChildByTag(105)  --头像
              self.imgurl:loadTexture(tostring(Util:sub_str(_friendlist[i]["imgurl"], "/",":")))
               self.today_golds =  _cell:getChildByTag(102)  --今日贡献金币
              self.today_golds:setString( _friendlist[i]["today_golds"] )
              self.total_golds =  _cell:getChildByTag(101)  --贡献总金币
              self.total_golds:setString( _friendlist[i]["total_golds"] )
       
           end

end
function InvitefriendsLayer:fun_init(  )
            --以下都是测试
             local friendlist_table =  LocalData:Instance():get_reward_friend_list()
             if  not friendlist_table then
             	return
             end
              self._ListView:removeAllItems()

             local databg_text=self.Invitefriends:getChildByTag(106)  --数据背

            self.gold_text=databg_text:getChildByTag(113)  --未领取的金币
            self.gold_text:setString("0")
            if not friendlist_table["one_points"] then
              return
            end
            self.gold_text:setString(friendlist_table["one_points"])
            if #friendlist_table["friendlist"]==0 then
            	return
            end
            local _friendlist=friendlist_table["friendlist"]
            for i=1,#_friendlist do
	          	 self._ListView:pushBackDefaultItem()
	          	local  _cell =  self._ListView:getItem(i-1)
	            _cell:setTag(i)
	            self.nickname = _cell:getChildByTag(94)  --名字
	            self.nickname:setString(_friendlist[i]["nickname"])
	            self.grade =  _cell:getChildByTag(95)  --等级
	            self.grade:setString( _friendlist[i]["playergrade"] )
	            self.imgurl =  _cell:getChildByTag(105)  --头像
	            self.imgurl:loadTexture(tostring(Util:sub_str(_friendlist[i]["imgurl"], "/",":")))
                   self.today_golds =  _cell:getChildByTag(102)  --今日贡献金币
                  self.today_golds:setString( _friendlist[i]["today_golds"] )
                  self.total_golds =  _cell:getChildByTag(101)  --贡献总金币
                  self.total_golds:setString( _friendlist[i]["total_golds"] )
	     
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
            self.invitecode_num:setVisible(true)
	elseif tag==229 then  --回馈返回
		self.Friendsstep:setVisible(false)
		self.m_feedback:setVisible(false)
            self.invitecode_num:setVisible(false)
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
             if self.gold_text:getString() ==  "0" then
                 Server:Instance():prompt("没有金币领取")
                 return
             end
		--  local receive_table =  LocalData:Instance():get_reward_friend()
  --    dump(receive_table)
  --                        local _playerinfo = receive_table["playerinfo"]
  --                        if _playerinfo["curgolds"]==0 then
  --                        	Server:Instance():prompt("没有金币领取")
  --                        	return
  --                        end
  --                       local friendlist_table=LocalData:Instance():getfriendlist()
		-- print("一键获取")
		Server:Instance():get_reward_of_friends_levelup()
	
	
	end
end
function InvitefriendsLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self,
                       function()
                       	            print("初始化")
                      		self:init()
                      end)
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDSLEVELUP, self,
                       function()
                      		print("个人信息修改")
                          self:friends_levelup(  )
                      end)
end

function InvitefriendsLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self)
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDSLEVELUP, self)
end

return InvitefriendsLayer

















