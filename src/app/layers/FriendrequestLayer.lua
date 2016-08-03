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

      self.receive_bt1=_list:getChildByTag(129):getChildByTag(135)  --领取1
	self.receive_bt1:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

      self.receive_bt2=_list:getChildByTag(130):getChildByTag(138)--领取2
	self.receive_bt2:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       self.receive_bt3=_list:getChildByTag(131):getChildByTag(141)--领取3
	self.receive_bt3:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

      self.receive_bt4=_list:getChildByTag(132):getChildByTag(144)--领取4
	self.receive_bt4:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
	
       local _listble=self.Friendrequest:getChildByTag(1291):getChildByTag(1590)

      self.receive_bt5=_listble:getChildByTag(1591):getChildByTag(1599)  --领取5
	self.receive_bt5:addTouchEventListener(function(sender, eventType)
	       self:touch_callback(sender, eventType)
       end)

      self.receive_bt6=_listble:getChildByTag(1592):getChildByTag(1600)--领取6
	self.receive_bt6:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

      self.receive_bt7=_listble:getChildByTag(1593):getChildByTag(1601)--领取7
	self.receive_bt7:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

      self.receive_bt8=_listble:getChildByTag(1594):getChildByTag(1602)--领取8
	self.receive_bt8:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
       self.managerlist=self.friendlist_num["managerlist"]  
       local _table = {3,5,10,20,30,50,80,100}

       local lo_img={self.receive_bt1,self.receive_bt2,self.receive_bt3,self.receive_bt4,self.receive_bt5,self.receive_bt6,self.receive_bt7,self.receive_bt8}
       for i=1,#self.managerlist do    --   tag
          for j=1,#_table do
            if self.managerlist[i]["friendscount"]==_table[j] then  --
                lo_img[j]:setTouchEnabled(false)
        end
          end
         
       end

       for i=1,#_table do
        for j=1,#self.managerlist do
            if self.managerlist[j]["friendscount"]==_table[i]   then  --
                  if tonumber(self.managerlist[j]["tag"]) ==1 then 
                      lo_img[i]:setColor(cc.c3b(100,100,100))
                       lo_img[i]:setTouchEnabled(false)
                  end
            end
          end
      end
      
      for i=1,8 do  --self.friendlist_num["friendcount"]
       if _table[i]<tonumber(self.friendlist_num["friendcount"]) then
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

      if self.Friendsstep then
         self.Friendsstep:removeFromParent()
         self.Friendsstep=nil
      end

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
      
      local friendlist_code =LocalData:Instance():get_reward_setting_list() 
      
      if tostring(friendlist_code["invitecode"])~="0" then

               self.invitecode_num = cc.ui.UILabel.new({text = tostring(friendlist_code["invitecode"]),
                        size = 28,
                        align = TEXT_ALIGN_CENTER,
                        font = "Arial",
                        color = cc.c4b(255,241,203),
                        })
         -- self.invitecode_num:setAnchorPoint(0.5,0.5)

         self.invitecode_num:setPosition(cc.p(_invitecodeNum:getPositionX()-130,_invitecodeNum:getPositionY()))
         self.invitecode_num:addTo(self.m_feedback,100)
          -- self.invitecode_num:setPlaceHolder()
          -- self.m_feedback:setTouchEnabled(false)
        else
                self.invitecode_num = ccui.EditBox:create(cc.size(width,height),res)
                self.invitecode_num:setVisible(false)
                self.m_feedback:addChild(self.invitecode_num)
                self.invitecode_num:setPosition(cc.p(_invitecodeNum:getPositionX()-130,_invitecodeNum:getPositionY()))--( cc.p(107,77 ))  
                self.invitecode_num:setPlaceHolder("请输入手机号码")
                self.invitecode_num:setAnchorPoint(0,0.5)  
                self.invitecode_num:setMaxLength(11)
      end


       local friend_back=self.m_friend:getChildByTag(242)  --好友返回
	friend_back:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)

       local share_bt=self.m_friend:getChildByTag(243)  --前往邀请  分享
	share_bt:addTouchEventListener(function(sender, eventType)
	-- self:touch_callback(sender, eventType)
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

   if tostring(friendlist_code["invitecode"])~="0" then
      _backbt:setVisible(false)
      obtain_bt:setVisible(false)
   end
end

function FriendrequestLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
     local lo_img={self.receive_bt1,self.receive_bt2,self.receive_bt3,self.receive_bt4,self.receive_bt5,self.receive_bt6,self.receive_bt7,self.receive_bt8}
     local friendlist_num=LocalData:Instance():get_reward_setting_list()  
     local managerlist=self.friendlist_num["managerlist"]
     local _table = {3,5,10,20,30,50,80,100}

--判断是否领取
    for i=1,#_table do
        for j=1,#managerlist do

            if tag==lo_img[i]:getTag()  and  self.managerlist[j]["friendscount"]==_table[i]   then  --
               self.j_count=j
               if tonumber(managerlist[j]["tag"]) ==1 then   --tag  0可以领取  1已经领取   2好友个数不到不可领取
                    Server:Instance():prompt("您已经领取过了")
                     return
              elseif tonumber(managerlist[j]["tag"])==2 then   --tag  0可以领取  1已经领取   2好友个数不到不可领取
                    Server:Instance():prompt("您好友个数不到,不可领取")
                    return
              end
              
          end

        end
    end

	if tag==123 then --返回
		print("fanh ")
          Util:scene_control("MainInterfaceScene")
          Server:Instance():getuserinfo() -- 初始化数据
		self:removeFromParent()
	elseif tag==135 then
		print("hahahdfsfdsfdsf 1")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==138 then
		print("hahahdfsfdsfdsf 2")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==141 then
		print("hahahdfsfdsfdsf 3")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==144 then
		print("hahahdfsfdsfdsf 4")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==1599 then
		print("hahahdfsfdsfdsf 5")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==1600 then
		print("hahahdfsfdsfdsf 6")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==1601 then
		print("hahahdfsfdsfdsf 7")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==1602 then
		print("hahahdfsfdsfdsf 8")
            Server:Instance():set_friend_reward_setting(self.managerlist[self.j_count]["Id"])--奖励
            Server:Instance():prompt("恭喜您领取成功")
	elseif tag==161 then  --好友邀请
		-- self.Friendsstep:setVisible(true)
		-- self.m_friend:setVisible(true)
    print("分享11")
    Util:share()

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
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.STECODE, self,
                       function()
                      		self:pop_up()--弹出框
                      end)
end

function FriendrequestLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.INVITATION_POLITE, self)
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.STECODE, self)
end

return FriendrequestLayer

















