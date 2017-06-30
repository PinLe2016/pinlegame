--  新版惊喜吧  活动详情
local SurpriseNode_Detail = class("SurpriseNode_Detail", function()
            return display.newLayer("SurpriseNode_Detail")
end)
function SurpriseNode_Detail:fun_Popup_window( ... )
       --  弹窗
       if cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday_count_count",0)  ==3 then
          self.floating_layer:fun_congratulations("拼乐送您给您的助力大礼包,把他发送给您的微信好友,只要他们成功登陆拼乐,你们双方都会获得当前活动20次参与机会,最高可获得100次",
            function (sender, eventType)
                                  if eventType==1 then
                                    print("马上助力")
                                  end
                            end)
       end
       self:Popup_window()
       local tab=os.date("*t");
       if cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday",tab.day) ~= tab.day  then
         cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday",tab.day)
         self.floating_layer:fun_NotificationMessage("距离大奖越来越近,赶快邀请好友给您赢大奖",function (sender, eventType)
                                  if eventType==1 then
                                    print("马上助力")
                                  end
                            end)
        else
           if cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday_two",0)  ==  2    then
              cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday_two",4)
              self.floating_layer:fun_NotificationMessage("您已经成功参与惊喜吧活动,离奖品只差一步,赶快邀请好友助力帮您赢大奖",function (sender, eventType)
                                  if eventType==1 then
                                    print("马上助力")
                                  end
                            end)
            else
              local _tm=cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday_two",0)
              if _tm  ~= 2 and _tm  ~= 4 and  _tm  ==  10 then
                cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday_two",6)
              elseif _tm  ~= 2 and _tm  ~= 4 and  _tm  ==  6 then
                cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday_two",2)
              end
              
           end
        
       end
end
function SurpriseNode_Detail:Popup_window(  )
    local new_time_two=cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday",0)
    local tab=os.date("*t");
     if new_time_two~=0 then
       cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday",tab.day)
       cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday_two",10)
     end
end
function SurpriseNode_Detail:ctor(params)
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self.time_count_n=1
      self.surprise_id=params.id
       self:setNodeEventEnabled(true)
       self:fun_Popup_window()

       --  初始化界面
       self:fun_init()     
       self:fun_Initialize_variable()
      Server:Instance():getactivitybyid(self.surprise_id,0)  --  详情

end
--  初始化变量
function SurpriseNode_Detail:fun_Initialize_variable( ... )
    self.LV_hierarchy_table={"平民","骑士","勋爵","男爵","子爵","伯爵","侯爵","公爵","国王"}
    self.LV_hierarchy_table_number={0,7,16,26,37,50,65,81,100}
    self.winnersPreview_comout=0
    self.winnersPreview_number=0
    self:fun_winnersPreview()  --  初始化奖项详情界面
    Server:Instance():getactivityawards(self.surprise_id)  --  爵位等级奖项详情和奖项详情一样
    --  定时器
    self.time=0
    self.secondOne = 0
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self:update(dt)
    end)
end
function SurpriseNode_Detail:update(dt)
            self.secondOne = self.secondOne+dt
            if self.secondOne <1 then return end
            self.secondOne=0
            self.time=1+self.time
              self.countdown_time=Util:FormatTime_colon(self.DJS_time-self.time)
              self.LH_number:setString(self.countdown_time[1]  .. self.countdown_time[2]  ..self.countdown_time[3]  ..self.countdown_time[4])
end
function SurpriseNode_Detail:fun_init( ... )
	self.DetailsOfSurprise = cc.CSLoader:createNode("DetailsOfSurprise.csb");
	self:addChild(self.DetailsOfSurprise)
      self.introduce=nil
      self._DOS_ScrollView=self.DetailsOfSurprise:getChildByName("Friend_Node"):getChildByName("DOS_ScrollView")

      self.XQ_bg=self.DetailsOfSurprise:getChildByName("XQ_bg")
      self.LH_bg=self.XQ_bg:getChildByName("LH_bg")
      self.LH_number=self.LH_bg:getChildByName("LH_number")
      self:fun_touch_bt()
      --  好友列表初始化
      self:fun_friend_list_init()
      self:fun_lv_touch()
end
function SurpriseNode_Detail:fun_data(  )
           local _lv=1
           local activitybyid_data=LocalData:Instance():get_getactivitybyid()
           local  Friend_Node=self.DetailsOfSurprise:getChildByName("Friend_Node") 
           local  DOS_LoadingBar=self._DOS_ScrollView:getChildByName("DOS_LoadingBar")
           local  DOS_biaoji=self._DOS_ScrollView:getChildByName("DOS_biaoji")
           for i=1,#self.LV_hierarchy_table do
             if tostring(self.LV_hierarchy_table[i]) == activitybyid_data["mylevel"] then
               _lv=i
             end
           end
           if _lv==#self.LV_hierarchy_table then
              DOS_LoadingBar:setPercent(100)
            else
              DOS_LoadingBar:setPercent(tonumber(self.LV_hierarchy_table_number[_lv]+(activitybyid_data["levelmin"])/tonumber(activitybyid_data["levelmax"]) * (self.LV_hierarchy_table_number[_lv+1] - self.LV_hierarchy_table_number[_lv])    ))
           end
           -- 进度条的角标
           DOS_biaoji:setPositionX(24+tonumber(self.LV_hierarchy_table_number[_lv]+(activitybyid_data["levelmin"])/tonumber(activitybyid_data["levelmax"]) * (self.LV_hierarchy_table_number[_lv+1] - self.LV_hierarchy_table_number[_lv]))  * 1281)
           self.LH_number:setString(text)
           self.DJS_time=(activitybyid_data["finishtime"]-activitybyid_data["begintime"])-(activitybyid_data["nowtime"]-activitybyid_data["begintime"])
            local  _tabletime_data=Util:FormatTime_colon(self.DJS_time)
            self.LH_number:setString(_tabletime_data[1]  .. _tabletime_data[2]  .._tabletime_data[3]  .._tabletime_data[4]  )

           --  积分  排名
           local LH_integral=self.LH_bg:getChildByName("LH_integral")
           LH_integral:setString(activitybyid_data["totalpoints"])
           local LH_rank=self.LH_bg:getChildByName("LH_rank")
           LH_rank:setString(activitybyid_data["mylevel"])
           self:fun_touch_bt_htp()
           self:scheduleUpdate()

end
function SurpriseNode_Detail:fun_touch_bt( ... )
     --  事件初始化
      --  返回按钮
      local XQ_BACK=self.DetailsOfSurprise:getChildByName("XQ_BACK")
            XQ_BACK:addTouchEventListener(function(sender, eventType  )
                  if eventType == 3 then
                          sender:setScale(1)
                          return
                      end
                      if eventType ~= ccui.TouchEventType.ended then
                          sender:setScale(1.2)
                      return
                      end
                      sender:setScale(1)
                       local tab=os.date("*t");
                       if cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday",tab.day) == tab.day  then
                         local _count=cc.UserDefault:getInstance():getIntegerForKey("new_time_tabday_count_count",0)
                         cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday_count_count",_count+self.time_count_n)
                        else
                          cc.UserDefault:getInstance():setIntegerForKey("new_time_tabday_count_count",0)
                        end
                      
                      self:unscheduleUpdate()
              self:removeFromParent()
      end)

      --排行榜
      local HL_list=self.XQ_bg:getChildByName("HL_list")
      HL_list:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                 local SurpriseRank = require("app.layers.SurpriseRank")  --排行榜
                 local activitybyid=LocalData:Instance():get_getactivitybyid()
                  self:addChild(SurpriseRank.new({id=activitybyid["id"],score=activitybyid["totalpoints"],mylevel=activitybyid["mylevel"]}),1,1)
      end)
      --好友助力
      self.Friend_help=self.DetailsOfSurprise:getChildByName("Friend_help")
      self:fun_LoadingNodebar_act(self.Friend_help)
      self.Friend_help:setVisible(false)

       --奖项
      self.award_bt=self.DetailsOfSurprise:getChildByName("award_bt")
      self.award_bt:setVisible(true)
      self.award_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                self.winnersPreview:setVisible(true)
                --Server:Instance():getactivityawards(self.surprise_id)  --  奖项预览
      end)
       
          
end
function SurpriseNode_Detail:fun_LoadingNodebar_act( _obj )
              local actionT1 = cc.RotateTo:create( 1, 2)
              local actionTo1 = cc.RotateTo:create( 1, -2)
              _obj:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT1, actionTo1)))

end
function SurpriseNode_Detail:fun_touch_bt_htp( ... )
      local activitybyid=LocalData:Instance():get_getactivitybyid()
      
       --  规则按钮
      local XQ_GZ=self.DetailsOfSurprise:getChildByName("XQ_GZ")
      XQ_GZ:setVisible(false)
      if activitybyid["description"]  ~= "" then
         XQ_GZ:setVisible(true)
      end
      XQ_GZ:addTouchEventListener(function(sender, eventType  )
            if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                if activitybyid["description"]  ~= "" then
                   self:fun_storebrowser(tostring(activitybyid["description"]))
                end
      end)
      self._advertising_bt=self.DetailsOfSurprise:getChildByName("advertising_bt")
      self._advertising_bt:addTouchEventListener(function(sender, eventType  )
            if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(0.8)
                return
                end
                sender:setScale(1)
                if activitybyid["description"]  ~= "" then
                   self:fun_storebrowser(tostring(activitybyid["description"]))
                end
      end)
      --开始
      self.began_bt=self.DetailsOfSurprise:getChildByName("began_bt")
      self.began_bt:setVisible(true)
      self.award_bt:setVisible(true)
      local HL_gametimes=self.began_bt:getChildByName("HL_gametimes")
      HL_gametimes:setString(tostring(activitybyid["gametimes"]))
      self.began_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                self.Friend_help:setVisible(false)
                self.began_bt:setVisible(false)
                self.award_bt:setVisible(false)
                local sup_data=LocalData:Instance():get_getactivitybyid()
                --  if tonumber(sup_data["gametimes"])<=0 then
                --     self.floating_layer:prompt_box("您的次数已经用完")
                --     return
                -- end
                local _SlotMachinesTable={}
                
                _SlotMachinesTable["SlotMachinesId"] = sup_data["id"]
                _SlotMachinesTable["SlotMachinesmylevel"] = sup_data["mylevel"]
                _SlotMachinesTable["SlotMachineslevelmin"] = sup_data["levelmin"]
                _SlotMachinesTable["SlotMachineslevelmax"] = sup_data["levelmax"]
                _SlotMachinesTable["SlotMachinesgametimes"] = sup_data["gametimes"]
                _SlotMachinesTable["SlotMachinesscore"] = sup_data["totalpoints"]
                _SlotMachinesTable["SlotMachines_id"] = self.surprise_id                
                 local SlotMachines = require("app.layers.SlotMachines")    
                self:addChild(SlotMachines.new(_SlotMachinesTable),1,1)
      end)
end
-- 外部链接
function SurpriseNode_Detail:fun_storebrowser( _url)
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      self.Storebrowser:setTag(1314)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                  end
                  self:removeChildByTag(1314, true)
            end)
              self.share=cc.UM_Share:create()
              self.Storebrowser:addChild(self.share)
              self.share:add_WebView(tostring(_url),cc.size(store_size:getContentSize().width ,store_size:getContentSize().height),
               cc.p(store_size:getPositionX(),store_size:getPositionY()))
end
--  好友列表
function SurpriseNode_Detail:fun_friend_list_init( ... )
        local  Friend_Node=self.DetailsOfSurprise:getChildByName("Friend_Node")
        local XQ_Friend_bg=Friend_Node:getChildByName("XQ_Friend_bg")
         local XQ_FD_LIST_Back=XQ_Friend_bg:getChildByName("XQ_FD_LIST_Back")
         local XQ_FD_LIST_More_Bg=XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bg")
           local XQ_FD_LIST_More_Bt=XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bt")
        XQ_FD_LIST_Back:setVisible(false)
        XQ_Friend_bg:setTouchEnabled(false)
      
      --  关闭好友界面
      
      XQ_FD_LIST_Back:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                XQ_FD_LIST_Back:setVisible(false)
                XQ_FD_LIST_More_Bg:setVisible(true)
                Friend_Node:setPositionY(0)
                XQ_Friend_bg:setTouchEnabled(false)
                XQ_FD_LIST_More_Bt:setVisible(true)
      end)
      --  关闭好友界面
      
      XQ_FD_LIST_More_Bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                XQ_FD_LIST_Back:setVisible(true)
                XQ_FD_LIST_More_Bg:setVisible(false)
                Friend_Node:setPositionY(635)
                XQ_Friend_bg:setTouchEnabled(true)
                XQ_FD_LIST_More_Bt:setVisible(false)
      end)


        self.XQ_FD_LIST=XQ_Friend_bg:getChildByName("XQ_FD_LIST")
        self.XQ_FD_LIST:setItemModel(self.XQ_FD_LIST:getItem(0))
        self.XQ_FD_LIST:removeAllItems()
        
end
function SurpriseNode_Detail:fun_friend_list_data( ... )
--  有没有好友图片
        self.XQ_FD_LIST:removeAllItems()
        local sup_data=LocalData:Instance():get_getactivitybyid()
        local friendhelp=sup_data["friendhelp"]
       
        if not sup_data["friendhelp"]   then
            self.DetailsOfSurprise:getChildByName("Friend_Node"):getChildByName("XQ_Friend_bg"):getChildByName("no_friend_bg"):setVisible(true)
            return
        else
          self.DetailsOfSurprise:getChildByName("Friend_Node"):getChildByName("XQ_Friend_bg"):getChildByName("no_friend_bg"):setVisible(false)
        end
        if #friendhelp  <=  0 then
          return
        end
        for i=1,#friendhelp do
          self.XQ_FD_LIST:pushBackDefaultItem()
          local  cell = self.XQ_FD_LIST:getItem(i-1)
          local XQ_FD_LIST_Head=cell:getChildByName("XQ_FD_LIST_Head")
          XQ_FD_LIST_Head:loadTexture("png/httpgame.pinlegame.comheadheadicon_"  ..  math.random(1,8) .. ".jpg")
          --local _index=string.match(tostring(Util:sub_str(friendhelp[i]["head"], "/",":")),"%d")
          --XQ_FD_LIST_Head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
          local XQ_FD_LIST_Nickname=cell:getChildByName("XQ_FD_LIST_Nickname")
          XQ_FD_LIST_Nickname:setString(friendhelp[i]["nick"])
          local XQ_FD_LIST_Number=cell:getChildByName("XQ_FD_LIST_Number")
          --XQ_FD_LIST_Number:setString(friendhelp[i]["nick"])
          XQ_FD_LIST_Number:setString(math.random(1,8))
          local XQ_FD_LIST_img=cell:getChildByName("XQ_FD_LIST_img")
         -- XQ_FD_LIST_img:loadTexture("json")
        end
end
function SurpriseNode_Detail:fun_lv_touch( ... )
           self.win_package_table={}
           for i=1,9 do
                 local  DOS_bt1=self._DOS_ScrollView:getChildByName("DOS_bg"  ..  tostring(i)):getChildByName("DOS_bt"  ..  tostring(i))
                 DOS_bt1:setVisible(false)
                 self.win_package_table[i]=DOS_bt1
                 DOS_bt1:addTouchEventListener(function(sender, eventType  )
                        self:fun_lv_touch_back(sender, eventType)
              end)
           end
          

end
function SurpriseNode_Detail:fun_win_package_table( ... )
           local getactivitywinners=LocalData:Instance():get_getactivitywinners()
           local awardlist=getactivitywinners["awardlist"]
            if #awardlist    ~= 0  then
             for i=1,#awardlist do
               self.win_package_table[#self.win_package_table-i+1]:setVisible(true)
             end
           end
end
function SurpriseNode_Detail:fun_lv_touch_back( sender, eventType  )
             local _sender=sender
             local _x=self._DOS_ScrollView:getPositionX()
             local _y=self._DOS_ScrollView:getPositionY()
             local sender_x=sender:getParent():getPositionX()
             local sender_y=sender:getParent():getPositionY()
             local tag=sender:getName()
             local getactivitywinners=LocalData:Instance():get_getactivitywinners()
             local awardlist=getactivitywinners["awardlist"]
                if self.introduce then
                   self.introduce:setVisible(false)
                 end
                if eventType == 3 then
                    sender:setScale(1)
                    self.introduce:setVisible(false)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                          sender:setScale(1.2)
                          if tag  ==  "DOS_bt1" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt2" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt3" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt4" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt5" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt6" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt7" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt8" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          elseif tag  ==  "DOS_bt9" then
                            self:function_introduce(awardlist[1]["goodsname"],sender_x+_x,sender_y+_y,true,_sender)
                          end
                      return
                end
                sender:setScale(1)
                self.introduce:setVisible(false)
             


end
function SurpriseNode_Detail:function_introduce(_text ,_x,_y,_isvisible,_obj)
            self.introduce = cc.CSLoader:createNode("introduce.csb");
            _obj:addChild(self.introduce)
            self.introduce:setPosition(cc.p(40,40))
            self.introduce:setVisible(_isvisible)
             local introduce_Text=self.introduce:getChildByName("introduce_Text")
             introduce_Text:setString(tostring(_text))
             return   self.introduce
end
--奖项
function SurpriseNode_Detail:fun_winnersPreview(  )
      self.winnersPreview = cc.CSLoader:createNode("winnersPreview.csb");
      self.winnersPreview:setTag(1311)
      self:addChild(self.winnersPreview)
      self.winnersPreview:setVisible(false)
      local back=self.winnersPreview:getChildByName("back")
       back:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                self.winnersPreview:setVisible(false)
      end)
        self.win_ListView=self.winnersPreview:getChildByName("win_ListView")
        self.win_ListView:addScrollViewEventListener((function(sender, eventType  )
                  if eventType  ==6 then
                        -- LocalData:Instance():set_getactivitywinners(nil)
                        -- Server:Instance():getactivityawards(self.surprise_id)
                        --            return
                  end
        end))
        self.win_ListView:setItemModel(self.win_ListView:getItem(0))
        self.win_ListView:removeAllItems()

        
end
function SurpriseNode_Detail:fun_winnersPreview_list_init( ... )
       local list_table=LocalData:Instance():get_getactivitywinners()
       local  sup_data=list_table["awardlist"]
       local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
       self.winnersPreview_comout=#sup_data
       if self.winnersPreview_number>=self.winnersPreview_comout then
         return
       end
       for i=1,#sup_data do
          self.win_ListView:pushBackDefaultItem()
          local  cell = self.win_ListView:getItem(i-1)
          local number=cell:getChildByName("number")
          --number:setString("0 ~ "  ..  sup_data[i]["awardcount"])  s
          local _bj=i
          if _bj>=9 then
            _bj=9
          end
          number:setString(self.LV_hierarchy_table[10-_bj])
          local prize=cell:getChildByName("prize")
          prize:setString(sup_data[i]["awardorder"] ..  "等奖")
          local win_name=cell:getChildByName("win_name")
          win_name:setString(sup_data[i]["goodsname"])
          local win_img=cell:getChildByName("win_img")  
          --  缺一个刷新下载图片  
          win_img:loadTexture(path..tostring(Util:sub_str(sup_data[i]["goodsimageurl"], "/",":")))

        end
        self.winnersPreview_number=self.winnersPreview_comout
end
--下载奖项预览图片
function SurpriseNode_Detail:winnersPreview_list_image(  )
         local list_table=LocalData:Instance():get_getactivitywinners()
         if not list_table then
           return
         end
         local  sup_data=list_table["awardlist"]
         for i=1,#sup_data do
          local com_={}
          com_["command"]=sup_data[i]["goodsimageurl"]
          com_["max_pic_idx"]=#sup_data
          com_["curr_pic_idx"]=i
          com_["TAG"]="getactivitywinners"
          Server:Instance():request_pic(sup_data[i]["goodsimageurl"],com_) 
         end
end
--下载奖项预览图片
function SurpriseNode_Detail:winnersPreview_Home_image(  )
         local sup_data=LocalData:Instance():get_getactivitybyid()
         if not sup_data then
           return
         end
          local com_={}
          com_["command"]=sup_data["imageurl"]
          com_["max_pic_idx"]=1
          com_["curr_pic_idx"]=1
          com_["TAG"]="getactivitybyid"
          Server:Instance():request_pic(sup_data["imageurl"],com_) 
end
function SurpriseNode_Detail:fun_help_data( ... )
                        self.Friend_help:setVisible(true)
                         local activitybyid_data=LocalData:Instance():get_getactivitybyid()
                         local _activitybyid_id=activitybyid_data["id"]
                         local _userdata=LocalData:Instance():get_user_data()
                         local loginname=_userdata["loginname"]
                        self.Friend_help:addTouchEventListener(function(sender, eventType  )
                                if eventType == 3 then
                                      sender:setScale(1)
                                      return
                                  end
                                  if eventType ~= ccui.TouchEventType.ended then
                                      sender:setScale(1.2)
                                  return
                                  end
                                  sender:setScale(1)
                                  print("好友助力")
                                  self.share=Util:share(_activitybyid_id,loginname)
                        end)
end
function SurpriseNode_Detail:onEnter()
   cc.SpriteFrameCache:getInstance():addSpriteFrames("DetailsiOfSurprise/LH_Plist.plist")
   --下载图片
   NotificationCenter:Instance():AddObserver("GETACTIVITYAWARDS", self,
                       function()

                                  self:winnersPreview_list_image()
                                  self:fun_win_package_table()
                      end)
   --  奖项详情
   NotificationCenter:Instance():AddObserver("GAME_GETACTIVITYAWARDS", self,
                       function()
                                  self:fun_winnersPreview_list_init()
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
                       function()
                        self:fun_data()
                        self:winnersPreview_Home_image()
                        self:fun_friend_list_data()
                        self:fun_help_data()
                                  

                      end)
   NotificationCenter:Instance():AddObserver("msg_getactivitybyid", self,
                       function()
                                  local sup_data=LocalData:Instance():get_getactivitybyid()
                                  local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
                                  self._advertising_bt:loadTexture(path..tostring(Util:sub_str(sup_data["imageurl"], "/",":")))
                      end)
end

function SurpriseNode_Detail:onExit()
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("DetailsiOfSurprise/LH_Plist.plist")
    NotificationCenter:Instance():RemoveObserver("GETACTIVITYAWARDS", self)
    NotificationCenter:Instance():RemoveObserver("msg_getactivitybyid", self)
    NotificationCenter:Instance():RemoveObserver("GAME_GETACTIVITYAWARDS", self)
    NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
end

return SurpriseNode_Detail




