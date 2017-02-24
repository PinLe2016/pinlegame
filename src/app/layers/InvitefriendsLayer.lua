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
       self.friend_list_type=1
       self.table_insert={}
       self._table_int={}
       Server:Instance():get_reward_friend_list() --好友列表

              local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       for i=1,#tasklist  do 
             if  tonumber(tasklist[i]["targettype"])   ==  2   then
                  LocalData:Instance():set_tasktable(tasklist[i]["targetid"])
             end
             
       end
       self:init()
end
function InvitefriendsLayer:move_layer(_layer)
     local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end

function InvitefriendsLayer:init(  )
      
        -- self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        -- self.fragment_sprite:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
        -- self:addChild(self.fragment_sprite)

       self.Invitefriends = cc.CSLoader:createNode("Invitefriends.csb")  --邀请好友排行榜
       self:addChild(self.Invitefriends)
       --self:move_layer(self.Invitefriends)
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
      self.obtain_bt=self.Invitefriends:getChildByTag(106):getChildByTag(116)  --一键获取
	self.obtain_bt:addTouchEventListener(function(sender, eventType)
	self:touch_callback(sender, eventType)
       end)
      self.addFriend_bt=self.Invitefriends:getChildByTag(3627)  --添加好友
      self.addFriend_bt:addTouchEventListener(function(sender, eventType)
                  self:touch_callback(sender, eventType)
      end)
      self.moveFriend_bt=self.Invitefriends:getChildByTag(3628)--删除好友
      self.moveFriend_bt:addTouchEventListener(function(sender, eventType)
                  self:touch_callback(sender, eventType)
      end)

       self._ListView=self.Invitefriends:getChildByTag(91)--邀请好友排行list
       self._ListView:setItemModel(self._ListView:getItem(0))
       self._ListView:removeAllItems()
       



end
--一键领取
function InvitefriendsLayer:friends_levelup(  )
               local friendlist_table =  LocalData:Instance():get_reward_of_friends_levelup()
             if  not friendlist_table then
              return
             end
              self._ListView:removeAllItems()
             local playerinfo=friendlist_table["playerinfo"]
            self.gold_text:setString(playerinfo["golds"])
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
             --self.obtain_bt:setColor(cc.c3b(100,100,100)) 
             self.obtain_bt:setBright(false) 
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
             self.gold_text:setString(friendlist_table["one_golds"])
            if tostring(friendlist_table["one_golds"])  ==  "0" then
              --self.obtain_bt:setColor(cc.c3b(100,100,100))  
              self.obtain_bt:setBright(false) 
            else
              --self.obtain_bt:setColor(cc.c3b(255,255,255))
              self.obtain_bt:setBright(true)   
            end
           
            if #friendlist_table["friendlist"]==0 then
            	return
            end
            self.table_insert={}
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
                   self.today_golds =  _cell:getChildByTag(102)  --贡献金币
                  self.today_golds:setString( _friendlist[i]["total_golds"] )
                  self.total_golds =  _cell:getChildByTag(101)  --贡献经验
                  self.total_golds:setString( _friendlist[i]["total_points"] )
                  

                   local move_friend =_cell:getChildByName("CheckBox_1")  --删除好友

                   local yao_text_friend =_cell:getChildByTag(4411)  --邀字 
                  if tonumber(_friendlist[i]["tag"]) ==  0  then    --  o邀请  1  是好友
                      yao_text_friend:setString("员")
                      move_friend:setVisible(false)
                  else
                    yao_text_friend:setString("友")
                  end


                  move_friend:setTag(i)
                  move_friend:addEventListener(function(sender, eventType  )
                           if eventType == ccui.CheckBoxEventType.selected then
                                   local t_table_int =  {}
                                   t_table_int["playerid"]=_friendlist[i]["playerId"]
                                  table.insert(self.table_insert, t_table_int)
                                  print("添加",self.table_insert[1])
                                  -- if #self.table_insert  ~= 0 then
                                  --   for i=1,#self.table_insert do
                                  --   print("添加 ",self.table_insert[i]["playerid"])
                                  -- end
                                  -- end

                           elseif eventType == ccui.CheckBoxEventType.unselected then
                                   print("删除")
                                   if #self.table_insert >0  then
                                      for j=1,#self.table_insert do

                                        --print("删除 ss ",self.table_insert[j]["playerid"]," ",_friendlist[i]["playerId"])
                                        if tostring(self.table_insert[j]["playerid"]) == tostring(_friendlist[i]["playerId"]) then
                                            table.remove(self.table_insert,j)
                                            --table.remove(self._table_int,i)
                                            return
                                        end
                                      end
                                   end
                                   
                           end
                  end)

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
             Server:Instance():getuserinfo()  --钻石刷新
            if self.share then
                   if self.share:getIs_Share()  and  LocalData:Instance():get_tasktable()    then   --  判断分享是否做完任务
                       Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
                        LocalData:Instance():set_tasktable(nil)--制空
                 end
            end


            -- Server:Instance():getuserinfo() -- 初始化数据
            Server:Instance():gettasklist()
		        self:removeFromParent()
            Util:all_layer_backMusic()
           -- Util:scene_control("MainInterfaceScene")
	elseif tag==117 then
		-- self.Friendsstep:setVisible(true)
		-- self.m_friend:setVisible(true)
    self.share = Util:share()
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
      elseif tag==3627 then  --添加好友
            print("添加好友")
            self:function_addFriend()
            self._search_name_friend=nil
            Server:Instance():getsearchfriendlist(5,1) 
      elseif tag==3628 then  --删除好友
            print("删除好友")
           Server:Instance():setfriendoperation(self.table_insert,1)
           self.friend_list_type=1

	elseif tag==230 then  --下次再说
		self.Friendsstep:setVisible(false)
		self.m_friend:setVisible(false)
	elseif tag==231 then  --获取输入码
		local _num=self.invitecode_num:getString()
		Server:Instance():setinvitecode(tostring(_num))  --测试（与策划不符）
		print("获取输入码",_num)
	elseif tag==116 then  --一键获取
             if self.gold_text:getString() ==  "0" then
                 --Server:Instance():prompt("没有金币领取")
                 sender:setTouchEnabled(false)
                 return
              else
                sender:setTouchEnabled(true)
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
	  Server:Instance():getuserinfo()
	
	end

end
function InvitefriendsLayer:function_addFriend(  )
            self.search_friend_pageno=1
            self.addFriendSp = cc.CSLoader:createNode("addFriendSp.csb")  --邀请好友排行榜
            self:addChild(self.addFriendSp)
            self.add_ListView=self.addFriendSp:getChildByTag(4013)
            self.add_ListView:setItemModel(self.add_ListView:getItem(0))
            self.add_ListView:removeAllItems()
            local back =self.addFriendSp:getChildByTag(3882)  --返回
            back:addTouchEventListener(function(sender, eventType)
                    if eventType ~= ccui.TouchEventType.ended then
                          return
                    end
                    Server:Instance():get_reward_friend_list() --好友列表
                    if self.addFriendSp then
                      self.addFriendSp:removeFromParent()
                    end

                    
            end)
            local search_name_friend =self.addFriendSp:getChildByTag(4476)  --收索好友的昵称
            
            local search_friend =self.addFriendSp:getChildByTag(4379)  --收索好友
            search_friend:addTouchEventListener(function(sender, eventType)
                    if eventType ~= ccui.TouchEventType.ended then
                          return
                    end
                    self._search_name_friend=search_name_friend
                     Server:Instance():getsearchfriendlist(5,1,search_name_friend:getString()) 
                    print("收索添加好友",search_name_friend:getString())
                    
            end)
            local again_search =self.addFriendSp:getChildByTag(4380)  --换一批
            again_search:addTouchEventListener(function(sender, eventType)
                    if eventType ~= ccui.TouchEventType.ended then
                          return
                    end
                    self.search_friend_pageno=self.search_friend_pageno+1
                    Server:Instance():getsearchfriendlist(5,self.search_friend_pageno) 
                   print("刷新好友")
                    
            end)
            
           
end
--  刷新添加好友数据
function InvitefriendsLayer:function_addFriend_data( )
            local getsearchfriendlist= LocalData:Instance():get_getsearchfriendlist()--保存数据
            local list=getsearchfriendlist["list"]
            if #list ==  0  then
               return
            end
               for i=1,#list do
                   self.add_ListView:pushBackDefaultItem()
                  local  _cell =  self.add_ListView:getItem(i-1)
                  _cell:setTag(i)
                  local nickname = _cell:getChildByTag(4047)  --名字
                  nickname:setString(list[i]["nickname"])
                  local grade =  _cell:getChildByTag(4048)  --等级
                  grade:setString( "LV."  ..  list[i]["grade"] )
                  local imgurl =  _cell:getChildByTag(4044)  --头像
                  print("头像",string.lower(tostring(Util:sub_str(list[i]["imageUrl"], "/",":"))))
                  imgurl:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(list[i]["imageUrl"], "/",":"))))
                  local gender =  _cell:getChildByTag(4046)  -- 性别
                  --  男 IcnMale.png  女  IcnFemale.png
                  if tostring(list[i]["gender"] )  ==  "true" then   --  true是男
                      gender:loadTexture("png/IcnMale.png")
                  else
                      gender:loadTexture("png/IcnFemale.png")
                  end
                  
                  local is_online =  _cell:getChildByTag(4049)  --是否在线
                  is_online:setString( "不在线")
                  local again_friend =_cell:getChildByName("Button_2")  --添加好友
                  again_friend:setTag(i)
                  again_friend:addTouchEventListener(function(sender, eventType)
                          if eventType ~= ccui.TouchEventType.ended then
                                return
                          end
                         print("点击添加好友")
                         local _table={}
                         local table_list={}
                         _table["playerid"]=list[sender:getTag()]["playerid"]
                         table_list[1]=_table
                         Server:Instance():setfriendoperation(table_list,0)
                          self.friend_list_type=0
                  end)

           end
end
function InvitefriendsLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self,
                       function()
                       	            print("初始化")
                      		--self:init()
                          self:fun_init()-- 数据初始化
                      end)
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDSLEVELUP, self,
                       function()
                      		print("个人信息修改")
                          self:friends_levelup(  )
                      end)
       NotificationCenter:Instance():AddObserver("FRIEND_GETSEARCHFRIENDLIST", self,
                       function()
                         self:function_addFriend_data()
                        
                      end)
       NotificationCenter:Instance():AddObserver("FRIEND_SETFRIENDOPERATION", self,
                       function()
                          if self.friend_list_type==1 then
                           Server:Instance():promptbox_box_buffer("成功删除好友") 
                           Server:Instance():get_reward_friend_list() --好友列表
                          elseif self.friend_list_type==0 then
                            Server:Instance():promptbox_box_buffer("成功添加好友") 
                            -- LocalData:Instance():set_getsearchfriendlist(nil)
                            Server:Instance():getsearchfriendlist(5,1,self._search_name_friend:getString()) 
                          end
                          
                          
                      end)
end

function InvitefriendsLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self)
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDSLEVELUP, self)
        NotificationCenter:Instance():RemoveObserver("FRIEND_GETSEARCHFRIENDLIST", self)
        NotificationCenter:Instance():RemoveObserver("FRIEND_SETFRIENDOPERATION", self)
end

return InvitefriendsLayer

















