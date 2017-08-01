--  新版惊喜吧  老虎机

local SlotMachines = class("SlotMachines", function()
            return display.newLayer("SlotMachines")
end)
_SlotMachines_id=nil
function SlotMachines:ctor(params)
       self.sur_pageno=1
       self.Integralrecord_data_num_tag=0
       self.Integralrecord_data_num = 0
       self.floating_layer = require("app.layers.FloatingLayer").new()
       self.floating_layer:addTo(self,100000)
       self.SlotMachinesgametimes=params.SlotMachinesgametimes
       self.SlotMachineslevelmax=params.SlotMachineslevelmax
       self.SlotMachineslevelmin=params.SlotMachineslevelmin
       self.SlotMachinesmylevel=params.SlotMachinesmylevel
       self.SlotMachinesscore=params.SlotMachinesscore
       self.SlotMachinesId=params.SlotMachinesId
       self.SlotMachtitle=params.title
       self.SlotMachimg=params.img
       self.SlotMachcontent=params.content
       SlotMachines_id=params.SlotMachines_id
       self.score_three={}
       self.LV_hierarchy_table={"平民","骑士","勋爵","男爵","子爵","伯爵","侯爵","公爵","国王"}
       self._table_points_tag={10,20,30,50,100,200,300}
       self._table_points_tag_img={{0,1,2},{0,0,2},{1,1,2},{2,1,2},{0,0,0},{1,1,1},{2,3,2}}
       self:setNodeEventEnabled(true)
       --  初始化界面
       self:fun_init()
       self:fun_Popup_window()
       
end
--  弹窗
function SlotMachines:fun_Popup_window( ... )
         local new_time_two=cc.UserDefault:getInstance():getIntegerForKey("pop_new_count_two",0)
         if new_time_two == 2 then
            self.floating_layer:fun_congratulations("您已经成功参与惊喜吧活动,\n离奖品只差一步,\n赶紧好友助力帮您赢大奖！","稍后助力","马上助力","恭喜",function (sender, eventType)
                                  if eventType==1 then
                                      local _userdata=LocalData:Instance():get_user_data()
                                      local loginname=_userdata["loginname"]
                                      self.share=Util:share(self.SlotMachinesId,loginname,self.SlotMachtitle ,self.SlotMachimg , self.SlotMachcontent,2)
                                  end
            end)
         end
end
function SlotMachines:fun_init( ... )
	self.SlotMachines = cc.CSLoader:createNode("SlotMachines.csb");
	self:addChild(self.SlotMachines)
	self.lh_bg=self.SlotMachines:getChildByName("lh_bg")
      -- --  初始化老虎机
      self:fun_Slot_machines_init()
      self:fun_touch_bt()
      self:fun_Initialize_infor()
end
--  初始化数据
function SlotMachines:fun_Initialize_infor( ... )
      self.slotlh_ldb=self.lh_bg:getChildByName("lh_ldb")  -- 进度条
      self.slotlh_ldb:setPercent(tonumber(self.SlotMachineslevelmin)  / tonumber(self.SlotMachineslevelmax)  *100)
      self.slotbumber=self.lh_bg:getChildByName("bumber") --  次数
      self.slotbumber:setString( tostring(self.SlotMachinesgametimes)  )
      self.slotintegral=self.lh_bg:getChildByName("integral") --  积分
      self.slotintegral:setString(tostring(self.SlotMachinesscore))
      self.slotlevel=self.lh_bg:getChildByName("level") --  等级
      self.slotlevel:setString(tostring(self.SlotMachinesmylevel))
      self.slotlv_name1=self.lh_bg:getChildByName("lv_name1") --  进度条当前等级
      self.slotlv_name1:setString(tostring(self.SlotMachinesmylevel))
      self.slotlv_name2=self.lh_bg:getChildByName("lv_name2") --  下一等级
      local _lv=1
      for i=1,#self.LV_hierarchy_table do
        if tostring(self.LV_hierarchy_table[i]) == tostring(self.SlotMachinesmylevel)  then
         _lv=i
        end
      end
      if _lv==#self.LV_hierarchy_table  then
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv])
      else
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv+1])
      end
      
end
--  刷新后数据
function SlotMachines:fun_Initialize_data( ... )
      local activitygame=LocalData:Instance():get_activitygame()
      self.slotlh_ldb:setPercent(tonumber(activitygame["levelminpoints"])  / tonumber(activitygame["levelmaxpoints"])  *100)
      self.slotbumber:setString(  tostring(activitygame["remaintimes"])    )
      self.SlotMachinesgametimes=activitygame["remaintimes"]
      self.slotintegral:setString(tostring(activitygame["totalpoints"]))
      self.slotlevel:setString(tostring(activitygame["level"]))
      for i=1,9 do
        if self.LV_hierarchy_table[i] == tostring(activitygame["level"]) then
           cc.UserDefault:getInstance():setIntegerForKey("pop_new_mylevel_refresh",i)
        end
      end
      self.slotlv_name1:setString(tostring(activitygame["level"]))
      local _lv=1
      for i=1,#self.LV_hierarchy_table do
        if tostring(self.LV_hierarchy_table[i]) == tostring(activitygame["level"])  then
         _lv=i
        end
      end
      if _lv==#self.LV_hierarchy_table  then
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv])
      else
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv+1])
      end
      
end
--老虎机
function SlotMachines:fun_Slot_machines_init( ... )
   self. _table={}
   self._table_number={}
   self._table_number_tag=1
    for i=1,3 do
        local score=self.lh_bg
        local pox_1=self.lh_bg:getChildByName("lh_score1"):getPositionX()
        local poy_1=self.lh_bg:getChildByName("lh_score1"):getPositionY()
        local pox_2=self.lh_bg:getChildByName("lh_score2"):getPositionX()
        local pox_3=self.lh_bg:getChildByName("lh_score3"):getPositionX()
        self.laoHuJi1 = cc.LaoHuJiDonghua:create()--cc.CustomClass:create()
        local msg = self.laoHuJi1:helloMsg()
        release_print("customClass's msg is : " .. msg)
        self.laoHuJi1:setDate("DetailsiOfSurprise/LH_Plist", "DetailsiOfSurprise/JXB_YX_S_", 10,cc.p(pox_1+127*(i-1) ,poy_1) );
        self.laoHuJi1:setStartSpeed(15);
        score:addChild(self.laoHuJi1);
        self._table[i]=self.laoHuJi1
    end
end
--  开始
function SlotMachines:fun_Slot_machines( _num,_point )
      self.lh_record:setTouchEnabled(false)
      self.score_three[#self.score_three+1]=_num
         audio.stopAllSounds()
       Util:player_music_new("bg_7_f.mp3",true )
        for i=1,#self. _table do
              self. _table[i]:startGo()
        end
        local  tempn = _num  

         local function fun_stopGo()

		for i=1,#self. _table do
			local  stopNum = 0;
			if (tempn > 0)  then
				stopNum = tempn % 10;
				tempn = tempn / 10;
			end
                  table.insert(self._table_number,{number =  stopNum })
		end
                  local function fun_stopGo1()
                      self. _table[self._table_number_tag]:stopGo(self._table_number[#self. _table-(self._table_number_tag-1)].number);
                      self._table_number_tag=self._table_number_tag+1
                      if self._table_number_tag==4 then
                           self._table_number={}
                           self._table_number_tag=1
                           local function fun_stopGo2()
                            audio.stopAllSounds()
                              local count=self:stringToTable(tostring(_num))
                              if count==1 then
                                Util:player_music_new("open_box.mp3",false )
                              elseif count==2 then
                                Util:player_music_new("big_win.mp3",false )
                              else
                                Util:player_music_new("super_big.mp3",false )
                              end
                              audio.resumeMusic()
                              self:fun_Initialize_data()
                              self:fun_PowerWindows(_point)
                              self.lh_record:setTouchEnabled(true)
                           end
                           self:runAction( cc.Sequence:create(cc.DelayTime:create(3 ),cc.CallFunc:create(fun_stopGo2)))
                     end
                  end
                  self:runAction( cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(fun_stopGo1),cc.DelayTime:create(0.5)),3))
          end
          local actionTo = cc.ScaleTo:create(0.5, 1)
          self:runAction( cc.Sequence:create(cc.DelayTime:create(2 ),cc.CallFunc:create(fun_stopGo)))
end
function SlotMachines:fun_PowerWindows( _text )
  local PowerWindows = cc.CSLoader:createNode("PowerWindows.csb");
  self:addChild(PowerWindows) 
  PowerWindows:setTag(123)
  local function fun_stopGo()
         self.hl_began:setTouchEnabled(true)
        self:removeChildByTag(123,true)
  end
  PowerWindows:runAction( cc.Sequence:create(cc.DelayTime:create(3 ),cc.CallFunc:create(fun_stopGo)))
  local Image_guang=PowerWindows:getChildByName("Image_9")

   local actionT1= cc.ScaleTo:create( 1.5, 1.1)
   local actionTo1 = cc.ScaleTo:create( 1.5, 0.8)
   local actionT2 = cc.RotateBy:create( 1, 50)
   local actionTo2 = cc.RotateBy:create(1, 50)
  Image_guang:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT1, actionTo1)))
  Image_guang:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT2, actionTo2)))
  
  --  local actionT3= cc.ScaleTo:create( 1.5, 1.1)
  --  local actionTo3 = cc.ScaleTo:create( 1.5, 0.8)
  -- PowerWindows:getChildByName("Image_5"):runAction(cc.RepeatForever:create(cc.Sequence:create(actionT3, actionTo3)))
  local number=PowerWindows:getChildByName("Text_4")
  number:setString("+"  ..  tostring(_text))
 

  local pwtrue=PowerWindows:getChildByName("Image_1")
            pwtrue:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                  self.hl_began:setTouchEnabled(true)
                   self:removeChildByTag(123,true)
            end)
      --  连续三次分数弹窗
      if #self.score_three<4   or #self.score_three>4 then
        return
      end
     
        if self.score_three[#self.score_three] +  self.score_three[#self.score_three-1] +self.score_three[#self.score_three-2] >9 then
            self.floating_layer:fun_congratulations("距离大奖越来越近了,\n赶快邀请好友给您助力","稍后助力","马上助力","助力啦",function (sender, eventType)
                                    if eventType==1 then
                                      local _userdata=LocalData:Instance():get_user_data()
                                      local loginname=_userdata["loginname"]
                                      self.share=Util:share(self.SlotMachinesId,loginname,self.SlotMachtitle ,self.SlotMachimg , self.SlotMachcontent,2)
                                    end
              end)
        else
          self.floating_layer:fun_congratulations("成绩不满意,\n好友帮您得积分","稍后助力","马上助力","助力啦",function (sender, eventType)
                                    if eventType==1 then
                                      local _userdata=LocalData:Instance():get_user_data()
                                      local loginname=_userdata["loginname"]
                                      self.share=Util:share(self.SlotMachinesId,loginname,self.SlotMachtitle ,self.SlotMachimg , self.SlotMachcontent,2)
                                    end
              end)
        end
     
end
function SlotMachines:fun_touch_bt( ... )
     --  事件初始化
      --  返回按钮
      local lh_back=self.SlotMachines:getChildByName("lh_back")
            lh_back:addTouchEventListener(function(sender, eventType  )
                  if eventType == 3 then
                          sender:setScale(1)
                          return
                      end
                      if eventType ~= ccui.TouchEventType.ended then
                          sender:setScale(1.2)
                      return
                      end
                      sender:setScale(1)
                      Util:all_layer_backMusic()
                      self:removeFromParent()
                      Server:Instance():getactivitybyid(SlotMachines_id,0)  --  详情

      end)
      
       --  规则按钮
      self.lh_record=self.lh_bg:getChildByName("lh_record")
      self.lh_record:setTouchEnabled(true)
      self.lh_record:addTouchEventListener(function(sender, eventType  )
            if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                Util:all_layer_backMusic()
                Server:Instance():getactivitypointsdetail(self.SlotMachinesId,self.sur_pageno)
                self:fun_Integralrecord()
      end)
     
      --开始
      self.hl_began=self.lh_bg:getChildByName("hl_began")
      self.hl_began:addTouchEventListener(function(sender, eventType  )

              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                sender:setTouchEnabled(false)
                local _pop_new_count_two=cc.UserDefault:getInstance():getIntegerForKey("pop_new_count_two",0)
                if _pop_new_count_two==3 then
                  cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",4)
                else
                  cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",1)
                end
                
                audio.pauseMusic()
                Util:player_music_new("spin_button.mp3",false )
                if self.SlotMachinesgametimes<=0 then
                    self.floating_layer:fun_congratulations("金币,积分天天送,\n抓紧好友助力吧！","稍后助力","马上助力","助力赢大奖",function (sender, eventType)
                                  if eventType==1 then
                                      local _userdata=LocalData:Instance():get_user_data()
                                      local loginname=_userdata["loginname"]
                                      self.share=Util:share(self.SlotMachinesId,loginname,self.SlotMachtitle ,self.SlotMachimg , self.SlotMachcontent,2)
                                  end
                                  sender:setTouchEnabled(true)
                    end)
                    return
                end
                if tonumber(self.slotbumber:getString())>0 then
                  self.slotbumber:setString(  tostring(tonumber(self.slotbumber:getString()) -1 )  )
                  local actionT1 = cc.ScaleTo:create( 0.2, 1.5)
                  local actionTo1 = cc.ScaleTo:create( 0.2, 1)
                  self.slotbumber:runAction(cc.Sequence:create(actionT1, actionTo1))
                end
                
                Server:Instance():activitygame(self.SlotMachinesId)
      end)

       --帮助
      local help_bt=self.lh_bg:getChildByName("help_bt")
      self:fun_LoadingNodebar_act(help_bt)
      help_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                local _userdata=LocalData:Instance():get_user_data()
                local loginname=_userdata["loginname"]
                self.share=Util:share(self.SlotMachinesId,loginname,self.SlotMachtitle ,self.SlotMachimg , self.SlotMachcontent,2)
      end)
       
end
function SlotMachines:fun_LoadingNodebar_act( _obj )
              local actionT1 = cc.RotateTo:create( 1, 2)
              local actionTo1 = cc.RotateTo:create( 1, -2)
              _obj:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT1, actionTo1)))

end
--  个人记录
function SlotMachines:fun_Integralrecord( ... )
         self.Integralrecord = cc.CSLoader:createNode("Integralrecord.csb");
         self:addChild(self.Integralrecord)
         self.Integralrecord:setTag(987)
         local TicketCenter_informationBT=self.Integralrecord:getChildByName("Image_156")
            TicketCenter_informationBT:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                  Util:all_layer_backMusic()
                  self.sur_pageno=1
                  self:removeChildByTag(987, true)
                  self.Integralrecord_data_num_tag=0
                  self.Integralrecord_data_num = 0
            end)
            self.XQ_FD_LIST_View=self.Integralrecord:getChildByName("ListView_5")
            self.XQ_FD_LIST_View:addScrollViewEventListener((function(sender, eventType  )
                  if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        Server:Instance():getactivitypointsdetail(self.SlotMachinesId,self.sur_pageno)
                              return
                 end
           end))

      self.XQ_FD_LIST_View:setItemModel(self.XQ_FD_LIST_View:getItem(0))
      self.XQ_FD_LIST_View:removeAllItems()
      self.XQ_FD_LIST_View:setInnerContainerSize(self.XQ_FD_LIST_View:getContentSize())
end
function SlotMachines:fun_SlotMachines_list_data( ... )
              local getactivitypointsdetail=LocalData:Instance():get_getactivitypointsdetail()
              local mypointslist=getactivitypointsdetail["mypointslist"]
              if #mypointslist  <=0  then
                return
              end
              self.Integralrecord_data_num = #mypointslist+self.Integralrecord_data_num_tag
              if self.Integralrecord_data_num_tag==self.Integralrecord_data_num  and self.Integralrecord_data_num_tag== 0  then
                return
              end
               for i=self.Integralrecord_data_num_tag+1,self.Integralrecord_data_num do
                      self.XQ_FD_LIST_View:pushBackDefaultItem()
                      local  cell = self.XQ_FD_LIST_View:getItem(i-1)
                      local WIN_TEXT=cell:getChildByName("WIN_TEXT")
                      WIN_TEXT:setString(mypointslist[i-self.Integralrecord_data_num_tag]["points"])
                      local _img1="DetailsiOfSurprise/JXB_YX_S_0.png"
                      local _img2="DetailsiOfSurprise/JXB_YX_S_1.png"
                      local _img3="DetailsiOfSurprise/JXB_YX_S_2.png"
                      for j=1,#self._table_points_tag do
                          if tonumber(mypointslist[i-self.Integralrecord_data_num_tag]["points"])==self._table_points_tag[j] then
                              _img1="DetailsiOfSurprise/JXB_YX_S_"  .. self._table_points_tag_img[j][1]   ..   ".png"
                              _img2="DetailsiOfSurprise/JXB_YX_S_"  .. self._table_points_tag_img[j][2]   ..   ".png"
                              _img3="DetailsiOfSurprise/JXB_YX_S_"  .. self._table_points_tag_img[j][3]   ..   ".png"
                          end
                      end
                      local WIN_TYPE_1=cell:getChildByName("WIN_TYPE_1")
                      WIN_TYPE_1:loadTexture(_img1)
                      local WIN_TYPE_2=cell:getChildByName("WIN_TYPE_2")
                      WIN_TYPE_2:loadTexture(_img2)
                      local WIN_TYPE_3=cell:getChildByName("WIN_TYPE_3")
                      WIN_TYPE_3:loadTexture(_img3)
                end
                if tonumber(self.Integralrecord_data_num_tag)~=0 then
                       self.XQ_FD_LIST_View:jumpToPercentVertical(120)
                else
                       self.XQ_FD_LIST_View:jumpToPercentVertical(0)
                end
                self.Integralrecord_data_num_tag=self.Integralrecord_data_num
end
--  判断字符串中相同的个数
function SlotMachines:stringToTable(str)  
  local _count_one=0
  local _count_two=0
  local _count_three=0
  local _table={}
   for i=1,3 do
    _table[i]=string.char(string.byte(str, i))
   end
   for i=1,#_table do
    if tonumber(_table[i]) == 0 then
      _count_one=_count_one+1
    end
    if tonumber(_table[i]) == 1 then
      _count_two=_count_two+1
    end
    if tonumber(_table[i]) == 2 then
      _count_three=_count_three+1
    end
   end
   local _count=_count_one>=_count_two  and _count_one or _count_two
   return    _count>=_count_three  and _count or _count_three
end 
function SlotMachines:onEnter()
   cc.SpriteFrameCache:getInstance():addSpriteFrames("DetailsiOfSurprise/LH_Plist.plist")
  NotificationCenter:Instance():AddObserver("activitygame", self,
                       function()
                                  local activitygame=LocalData:Instance():get_activitygame()
                                  self:fun_Slot_machines(tonumber(activitygame["fruit"]),activitygame["points"])
                      end)
  NotificationCenter:Instance():AddObserver("activitygamefalse", self,
                       function()
                                  self.hl_began:setTouchEnabled(true)
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self,
                       function()
                                  self:fun_SlotMachines_list_data()
                      end)
  
end

function SlotMachines:onExit()
  cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("DetailsiOfSurprise/LH_Plist.plist")
  NotificationCenter:Instance():RemoveObserver("activitygame", self)
  NotificationCenter:Instance():RemoveObserver("activitygamefalse", self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self)
  
end

return SlotMachines





