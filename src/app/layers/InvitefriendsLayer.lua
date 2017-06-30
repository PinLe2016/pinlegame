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
       self._search_type=0
       self._table_box={}


       Server:Instance():get_reward_friend_list() --好友列表

      
      self:fun_init_infor()
       -- Util:layer_action(self.Invitefriends,self,"open")
      
      self.Invitefriends:setAnchorPoint(0.5,0.5)
      self.Invitefriends:setPosition(320, 568)

      local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       for i=1,#tasklist  do 
             if  tonumber(tasklist[i]["targettype"])   ==  2   then
                  LocalData:Instance():set_tasktable(tasklist[i]["targetid"])
             end
             
       end
       
       self:init()
end
function InvitefriendsLayer:fun_init_infor()
        local fragment_sprite_bg = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        self:addChild(fragment_sprite_bg)
        self.Invitefriends = cc.CSLoader:createNode("Invitefriends.csb")  --邀请好友排行榜
        self:addChild(self.Invitefriends)
end
function InvitefriendsLayer:move_layer(_layer)
     local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end
function InvitefriendsLayer:fun_friend_act(  )
         self.Friend_lan = cc.CSLoader:createNode("Friend_lan.csb")  --邀请好友排行榜
         self:addChild(self.Friend_lan,100)
          local  move1=cc.MoveTo:create(1, cc.p( self.Friend_lan:getPositionX(),self.Friend_lan:getPositionY()+400 ) )
          local action2 = cc.FadeOut:create(1)
         local action = cc.Spawn:create(move1, action2)  --  cc.Sequence:create(move1)--,cc.CallFunc:create(logSprRotation))  
         self.Friend_lan:stopAllActions()
         self.Friend_lan:runAction(action)
end

function InvitefriendsLayer:init(  )
     

      local actionTo = cc.ScaleTo:create(0.08, 1.1)
      local actionTo1 = cc.ScaleTo:create(0.1, 1)
      self.Invitefriends:runAction(cc.Sequence:create(actionTo,actionTo1  ))
     
      self.No_friends=self.Invitefriends:getChildByTag(901)  --暂无好友
      self.No_friends:setVisible(false)
       local back_bt=self.Invitefriends:getChildByTag(3187)  --返回
  back_bt:addTouchEventListener(function(sender, eventType)
            if eventType == 3 then
                       sender:setScale(1)
                       return
              end

            if eventType ~= ccui.TouchEventType.ended then
                       sender:setScale(1.2)
                       return
                  end
            sender:setScale(1)

            Server:Instance():getuserinfo()  --钻石刷新
            if self.share then
                if self.share:getIs_Share()  and  LocalData:Instance():get_tasktable()    then   --  判断分享是否做完任务
                    Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
                    LocalData:Instance():set_tasktable(nil)--制空
                end
            end
            Server:Instance():gettasklist()
            Util:all_layer_backMusic()
            --display.getRunningScene():fun_refresh_friend()--  目的是成长树刷新好友
            local function stopAction()
            self:removeFromParent()
            end
            local actionTo = cc.ScaleTo:create(0.08, 1.1)
            local actionTo1 = cc.ScaleTo:create(0.1, 0.7)
            local callfunc = cc.CallFunc:create(stopAction)
            self.Invitefriends:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))

       end)
       self.sp_ysprite=self.Invitefriends:getChildByTag(962)  --邀请好友
       self.sp_ysprite:addTouchEventListener(function(sender, eventType  )
                         if eventType ~= ccui.TouchEventType.ended then
                             return
                        end
                        print("邀请好友")
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

      self.addFriend_truebt=self.Invitefriends:getChildByTag(1199)  --确认删除
      self.addFriend_truebt:addTouchEventListener(function(sender, eventType)
                  self:touch_callback(sender, eventType)
      end)
      self.addFriend_falsebt=self.Invitefriends:getChildByTag(1200)  --取消删除
      self.addFriend_falsebt:addTouchEventListener(function(sender, eventType)
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
              --  self.today_golds =  _cell:getChildByTag(102)  --今日贡献金币
              -- self.today_golds:setString( _friendlist[i]["today_golds"] )
              -- self.total_golds =  _cell:getChildByTag(101)  --贡献总金币
              -- self.total_golds:setString( _friendlist[i]["total_golds"] )
       
           end

end
function InvitefriendsLayer:fun_init( _isvisber)
            --以下都是测试  
            self._table_box={}
             local friendlist_table =  LocalData:Instance():get_reward_friend_list()
             --self.obtain_bt:setColor(cc.c3b(100,100,100)) 
             local _count=1
             self.obtain_bt:setBright(false) 
             if  not friendlist_table then

              return
             end
              self._ListView:removeAllItems()

             local databg_text=self.Invitefriends:getChildByTag(106)  --数据背

            self.gold_text=databg_text:getChildByTag(113)  --未领取的金币
            self.gold_text:setString("+ 0")
            if not friendlist_table["one_points"] then
              return
            end
             self.gold_text:setString("+ "  ..  friendlist_table["one_golds"])
            if tostring(friendlist_table["one_golds"])  ==  "0" then
              --self.obtain_bt:setColor(cc.c3b(100,100,100))  
              self.obtain_bt:setBright(false) 
            else
              --self.obtain_bt:setColor(cc.c3b(255,255,255))
              self.obtain_bt:setBright(true)   
            end
           
            if #friendlist_table["friendlist"]==0 then
            self.No_friends:setVisible(true)
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
              self.imgurl:loadTexture("png/"   ..   string.lower(tostring(Util:sub_str(_friendlist[i]["imgurl"], "/",":"))))
                  --  self.today_golds =  _cell:getChildByTag(102)  --贡献金币
                  -- self.today_golds:setString( _friendlist[i]["total_golds"] )
                  -- self.total_golds =  _cell:getChildByTag(101)  --贡献经验
                  -- self.total_golds:setString( _friendlist[i]["total_points"] )
                  

                   local move_friend =_cell:getChildByName("CheckBox_1")  --删除好友

                   local yao_text_friend =_cell:getChildByTag(4411)  --邀字 
                  if tonumber(_friendlist[i]["tag"]) ==  0  then    --  o邀请  1  是好友
                      yao_text_friend:setString("员")
                      move_friend:setVisible(false)
                  else
                    yao_text_friend:setString("友")
                    move_friend:setVisible(_isvisber)
                    --self._table_box[_count] = move_friends
                    table.insert(self._table_box,{k=move_friend})
                  end
                  _count=_count+1
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
              Server:Instance():gettasklist()
              Util:all_layer_backMusic()
              display.getRunningScene():fun_refresh_friend()--  目的是成长树刷新好友
              -- local function stopAction()
              -- self:removeFromParent()
              -- end
              -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
              -- local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
              -- local callfunc = cc.CallFunc:create(stopAction)
              -- self.Invitefriends:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
              Util:layer_action(self.Invitefriends,self,"close")

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
            self.f_count=0
            self.f_count_num=0
            self.f_count_str="旗鼓"
            self.f_shousuo=false
            self._search_name_friend=nil
            self:function_addFriend()
            Server:Instance():getsearchfriendlist(5,1) 
      elseif tag==3628 then  --删除好友
            self.addFriend_truebt:setVisible(true)
            self.addFriend_falsebt:setVisible(true)
            self.sp_ysprite:setVisible(false)
            for i=1,#self._table_box do
              self._table_box[i].k:setVisible(true)
            end

      elseif tag==1199 then  --确认删除
            if #self.table_insert ==  0  then
                 for i=1,#self._table_box do
                  self._table_box[i].k:setVisible(false)
                end
                self.addFriend_truebt:setVisible(false)
                self.sp_ysprite:setVisible(true)
                self.addFriend_falsebt:setVisible(false)

                return
            end
            Server:Instance():setfriendoperation(self.table_insert,1)
            sender:setTouchEnabled(false)   
            local function stopAction()
                  sender:setTouchEnabled(true)      
            end
            local callfunc = cc.CallFunc:create(stopAction)
           sender:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
           self.friend_list_type=1
      elseif tag==1200 then  --取消删除
            self.sp_ysprite:setVisible(true)
            self.addFriend_truebt:setVisible(false)
            self.addFriend_falsebt:setVisible(false)
            --self:fun_init(false)
             for i=1,#self._table_box do
              self._table_box[i].k:setVisible(false)
            end
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
    
    Server:Instance():get_reward_of_friends_levelup()
    Server:Instance():getuserinfo()
  
  end

end

function InvitefriendsLayer:function_addFriend(  )
            self.search_friend_pageno=1
            self.addFriendSp = cc.CSLoader:createNode("addFriendSp.csb")  --邀请好友排行榜
            self:addChild(self.addFriendSp)
            -- self.addFriendSp:setScale(0.7)
            self.addFriendSp:setAnchorPoint(0.5,0.5)
            self.addFriendSp:setPosition(320, 568)
            local actionTo = cc.ScaleTo:create(0.15, 1.1)
           local actionTo1 = cc.ScaleTo:create(0.1, 1)
            self.addFriendSp:runAction(cc.Sequence:create(actionTo,actionTo1  ))

            self.add_ListView=self.addFriendSp:getChildByTag(4013)
            self.add_ListView:setItemModel(self.add_ListView:getItem(0))
            self.add_ListView:removeAllItems()
            local back =self.addFriendSp:getChildByTag(3227)  --返回
            back:addTouchEventListener(function(sender, eventType)
                  if eventType == 3 then
                     sender:setScale(1)
                     return
                  end

                  if eventType ~= ccui.TouchEventType.ended then
                     sender:setScale(1.2)
                     return
                  end
                  sender:setScale(1)
                    Server:Instance():get_reward_friend_list() --好友列表
                    if self.addFriendSp then
                      local function stopAction()
                      self.addFriendSp:removeFromParent()
                      self.addFriendSp=nil
                      end
                      local actionTo = cc.ScaleTo:create(0.08, 1.1)
                      local actionTo1 = cc.ScaleTo:create(0.1, 0.7)
                      local callfunc = cc.CallFunc:create(stopAction)
                      self.addFriendSp:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
                    end

                    
            end)
            local search_name_friend =self.addFriendSp:getChildByTag(4476)  --收索好友的昵称
            search_name_friend:setFontSize(22)
    
            self:function_keyboard(self.addFriendSp,search_name_friend,13)
            self._search_name_friend=search_name_friend
            local search_friend =self.addFriendSp:getChildByTag(4379)  --收索好友
            self._search_name_friend=search_name_friend
            search_friend:addTouchEventListener(function(sender, eventType)
                    if eventType ~= ccui.TouchEventType.ended then
                          return
                    end
                    self.f_shousuo = true
                    self._search_type=1
                     local _str=""
                      if self._search_name_friend  ~=  nil then
                          _str=self._search_name_friend:getString()
                      end
                     Server:Instance():getsearchfriendlist(5,1,_str) 
                    print("收索添加好友",search_name_friend:getString())
            end)
            -- local again_search =self.addFriendSp:getChildByTag(4380)  --换一批
            -- again_search:addTouchEventListener(function(sender, eventType)
            --         if eventType ~= ccui.TouchEventType.ended then
            --               return
            --         end
            --         self.search_friend_pageno=self.search_friend_pageno+1
            --          local _str=""
            --           if self._search_name_friend  ~=  nil then
            --               _str=self._search_name_friend:getString()
            --           end

            --         Server:Instance():getsearchfriendlist(5,self.search_friend_pageno) 
            --        print("刷新好友")
                    
            -- end)
            
           
end

function InvitefriendsLayer:function_keyboard(_parent,target,font_size)
        -- local alert = ccui.Text:create()
        -- alert:setString("|")
        -- alert:setFontName("png/chuti.ttf")
        -- local _guangbiao_x=target:getPositionX()
        -- alert:setPosition(target:getPositionX(),target:getPositionY())
        -- alert:setFontName(font_TextName)
        -- alert:setFontSize(40)
        -- alert:setColor(cc.c3b(0, 0, 0))
        -- _parent:addChild(alert)
        -- alert:setVisible(false)

        local function textFieldEvent(sender, eventType)  
              if eventType == ccui.TextFiledEventType.attach_with_ime then  
                   --print("attach_with_ime") 
                   local  move=cc.Blink:create(1, 1)  
                    local action = cc.RepeatForever:create(move)
                    --alert:runAction(action) 
                  --alert:setVisible(false)
              elseif eventType == ccui.TextFiledEventType.detach_with_ime then  
                   --print("detach_with_ime") 
                 -- alert:stopAllActions() 
                  --alert:setVisible(false)
              elseif eventType == ccui.TextFiledEventType.insert_text then  
                 --print("insert_text")  
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str) --Util:fun_Strlen(str)
                 --alert:setPositionX(_guangbiao_x+len*font_size)    
              elseif eventType == ccui.TextFiledEventType.delete_backward then  
                   
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str)
                 --alert:setPositionX(_guangbiao_x+len*font_size)     
                 if tonumber(len)  ==  0 then
                    Server:Instance():getsearchfriendlist(5,self.search_friend_pageno) 
                  end 
        end  
      end
      target:addEventListener(textFieldEvent) 


end


function InvitefriendsLayer:function_keyboard1(target)
        local function keyboardReleased(keyCode, event)
                print("key")
                -- print("长度",self._guangbiao_x,"  ",self._search_name_friend:getStringLength(),"  ",self.alert:getFontSize())
                 local str=tostring(self._search_name_friend:getString())
                 local len = Util:fun_Strlen(str)
                 self.alert:setPositionX(self._guangbiao_x+len*13)
                if self._search_name_friend:getStringLength()  ==  6  and self.f_count== 1 then
                   Server:Instance():getsearchfriendlist(5,self.search_friend_pageno) 
                end
                self.f_count=  self._search_name_friend:getStringLength()
        end
   
        local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(keyboardReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
        local eventDispatcher = target:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, target)

        -- local listener = cc.EventListenerKeyboard:create()
        -- listener:registerScriptHandler(function (keyCode) print("press keyCode:", keyCode) end, cc.Handler.EVENT_KEYBOARD_PRESSED)
        -- listener:registerScriptHandler(function (keyCode) print("release keyCode:", keyCode) end, cc.Handler.EVENT_KEYBOARD_RELEASED)
        -- cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener,1 )



end

--  刷新添加好友数据
function InvitefriendsLayer:function_addFriend_data( )
            local getsearchfriendlist= LocalData:Instance():get_getsearchfriendlist()--保存数据
            local list=getsearchfriendlist["list"]
            if self._search_type==1  and  #list ==  0  then
                       self:fun_friend_act()
                       self._search_type=0
                       self.add_ListView:removeAllItems()
            end
            self.add_ListView:removeAllItems()
               for i=1,#list do
                   self.add_ListView:pushBackDefaultItem()
                  local  _cell =  self.add_ListView:getItem(i-1)
                  _cell:setTag(i)
                  local nickname = _cell:getChildByTag(4047)  --名字
                  nickname:setString(list[i]["nickname"])
                  local grade =  _cell:getChildByTag(4048)  --等级
                  grade:setString( "LV."  ..  list[i]["grade"] )
                  local imgurl =  _cell:getChildByTag(4044)  --头像
                  imgurl:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(list[i]["imageUrl"], "/",":"))))
                 
                  
                  local is_online =  _cell:getChildByTag(4049)  --是否在线
                  is_online:setString( "不在线")
                  local again_friend =_cell:getChildByName("Button_2")  --添加好友
                  again_friend:setTag(i)
                  again_friend:addTouchEventListener(function(sender, eventType)
                          if eventType ~= ccui.TouchEventType.ended then
                                return
                          end
                         local _table={}
                         local table_list={}
                         _table["playerid"]=list[sender:getTag()]["playerid"]
                         table_list[1]=_table
                         Server:Instance():setfriendoperation(table_list,0)
                         sender:setTouchEnabled(false)   
                        local function stopAction()
                              sender:setTouchEnabled(true)      
                        end
                        local callfunc = cc.CallFunc:create(stopAction)
                       sender:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))

                          self.friend_list_type=0
                  end)

           end
end
function InvitefriendsLayer:onEnter()
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self,
                       function()
                                    print("初始化")
                          --self:init()

                           local function stopAction()
                                 if self.x_isviset==0 then
                                        self.x_isviset=1
                                        self:fun_init(true)
                                        return
                                  end
                                  self:fun_init(false)-- 数据初始化

                              end
                        
                              local callfunc = cc.CallFunc:create(stopAction)
                              self.Invitefriends:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),callfunc  ))


                         
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
       NotificationCenter:Instance():AddObserver("FRIEND_GETSEARCHFRIENDLIST_FALSE", self,
                       function()
                         self._search_type=0
                        
                      end)
       NotificationCenter:Instance():AddObserver("FRIEND_SETFRIENDOPERATION", self,
                       function()
                          if self.friend_list_type==1 then
                           Server:Instance():promptbox_box_buffer("成功删除好友") 
                           self.x_isviset=0
                           Server:Instance():get_reward_friend_list() --好友列表

                          elseif self.friend_list_type==0 then
                            Server:Instance():promptbox_box_buffer("成功添加好友") 
                            -- LocalData:Instance():set_getsearchfriendlist(nil)
                            local _str=""
                            if self._search_name_friend  ~=  nil then
                                _str=self._search_name_friend:getString()
                            end
                            Server:Instance():getsearchfriendlist(5,1,_str) 
                          end
                          
                          
                      end)
end

function InvitefriendsLayer:onExit()
        NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDLIST_POST, self)
        NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FRIENDSLEVELUP, self)
        NotificationCenter:Instance():RemoveObserver("FRIEND_GETSEARCHFRIENDLIST", self)
        NotificationCenter:Instance():RemoveObserver("FRIEND_SETFRIENDOPERATION", self)
        NotificationCenter:Instance():RemoveObserver("FRIEND_GETSEARCHFRIENDLIST_FALSE", self)
        cc.Director:getInstance():getTextureCache():removeAllTextures() 
end

return InvitefriendsLayer

















