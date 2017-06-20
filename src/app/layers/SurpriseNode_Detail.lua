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
      self.surprise_ownerurl=params.ownerurl
       self:setNodeEventEnabled(true)
       self:fun_Popup_window()

       --  初始化界面
       self:fun_init()     
       self:fun_Initialize_variable()
      Server:Instance():getactivitybyid(self.surprise_id,0)  --  详情

end
--  初始化变量
function SurpriseNode_Detail:fun_Initialize_variable( ... )
    self.winnersPreview_comout=0
    self.winnersPreview_number=0
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
      self.XQ_bg=self.DetailsOfSurprise:getChildByName("XQ_bg")
      self.LH_bg=self.XQ_bg:getChildByName("LH_bg")
      self.LH_number=self.LH_bg:getChildByName("LH_number")
      self:fun_touch_bt()
      --  好友列表初始化
      self:fun_friend_list_init()
      self:fun_lv_touch()
end
function SurpriseNode_Detail:fun_data(  )
           local activitybyid_data=LocalData:Instance():get_getactivitybyid()
           local  Friend_Node=self.DetailsOfSurprise:getChildByName("Friend_Node")
           local  DOS_ScrollView=Friend_Node:getChildByName("DOS_ScrollView")
           local  DOS_LoadingBar=DOS_ScrollView:getChildByName("DOS_LoadingBar")
           local  DOS_biaoji=DOS_ScrollView:getChildByName("DOS_biaoji")
           DOS_LoadingBar:setPercent(tonumber(activitybyid_data["levelmin"])/tonumber(activitybyid_data["levelmax"]))
           DOS_biaoji:setAnchorPoint(cc.p(0,0))
           DOS_biaoji:setPositionX(tonumber(activitybyid_data["levelmin"])/tonumber(activitybyid_data["levelmax"])  * 1360)
           self.LH_number:setString(text)
           self.DJS_time=(activitybyid_data["finishtime"]-activitybyid_data["begintime"])-(activitybyid_data["nowtime"]-activitybyid_data["begintime"])
            local  _tabletime_data=Util:FormatTime_colon(self.DJS_time)
            self.LH_number:setString(_tabletime_data[1]  .. _tabletime_data[2]  .._tabletime_data[3]  .._tabletime_data[4]  )

           --  积分  排名
           local LH_integral=self.LH_bg:getChildByName("LH_integral")
           LH_integral:setString(activitybyid_data["score"])
           local LH_rank=self.LH_bg:getChildByName("LH_rank")
           LH_rank:setString(activitybyid_data["mylevel"])

           local  advertising_bt=self.DetailsOfSurprise:getChildByName("advertising_bt")
           local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
           advertising_bt:loadTexture(path..tostring(Util:sub_str(self.surprise_ownerurl, "/",":")))
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
      
       --  规则按钮
      local XQ_GZ=self.DetailsOfSurprise:getChildByName("XQ_GZ")
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
                print('规则')
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
                  self:addChild(SurpriseRank.new({id=activitybyid["id"],score=activitybyid["score"],mylevel=activitybyid["mylevel"]}),1,1)
      end)
      --好友助力
      local Friend_help=self.DetailsOfSurprise:getChildByName("Friend_help")
      Friend_help:addTouchEventListener(function(sender, eventType  )
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
      end)

       --奖项
      local award_bt=self.DetailsOfSurprise:getChildByName("award_bt")
      award_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                self:fun_winnersPreview()
                Server:Instance():getactivityawards(self.surprise_id)  --  奖项预览
      end)
       --开始
      local began_bt=self.DetailsOfSurprise:getChildByName("began_bt")
      began_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                 local SlotMachines = require("app.layers.SlotMachines")    
                self:addChild(SlotMachines.new(),1,1)
      end)
          
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
        --测试
        self:fun_friend_list_data()
end
function SurpriseNode_Detail:fun_friend_list_data( ... )
--  有没有好友图片
self.DetailsOfSurprise:getChildByName("Friend_Node"):getChildByName("XQ_Friend_bg"):getChildByName("no_friend_bg"):setVisible(false)
        for i=1,20 do
          self.XQ_FD_LIST:pushBackDefaultItem()
          local  cell = self.XQ_FD_LIST:getItem(i-1)
        end
end
function SurpriseNode_Detail:fun_lv_touch( ... )
           local DOS_ScrollView=self.DetailsOfSurprise:getChildByName("Friend_Node"):getChildByName("DOS_ScrollView")
           local  DOS_bt1=DOS_ScrollView:getChildByName("DOS_bg1"):getChildByName("DOS_bt1")
           DOS_bt1:addTouchEventListener(function(sender, eventType  )
                    self:fun_lv_touch_back(sender, eventType)
          end)
           local  DOS_bt2=DOS_ScrollView:getChildByName("DOS_bg2"):getChildByName("DOS_bt2")
           DOS_bt2:addTouchEventListener(function(sender, eventType  )
                    self:fun_lv_touch_back(sender, eventType)
          end)
           local  DOS_bt3=DOS_ScrollView:getChildByName("DOS_bg3"):getChildByName("DOS_bt3")
           DOS_bt3:addTouchEventListener(function(sender, eventType  )
                    self:fun_lv_touch_back(sender, eventType)
          end)

end
function SurpriseNode_Detail:fun_lv_touch_back( sender, eventType  )
                if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
              local tag=sender:getName()
              if tag  ==  "DOS_bt1" then
                self.floating_layer:prompt_box("恭喜您获得:索尼（SONY） 微单相机")
              elseif tag  ==  "DOS_bt2" then
                self.floating_layer:prompt_box("恭喜您获得:意大利德龙家用磨豆机")
              elseif tag  ==  "DOS_bt3" then
                self.floating_layer:prompt_box("恭喜您获得:小米充电宝")
              end
end
--奖项
function SurpriseNode_Detail:fun_winnersPreview( ... )
      self.winnersPreview = cc.CSLoader:createNode("winnersPreview.csb");
      self.winnersPreview:setTag(1311)
      self:addChild(self.winnersPreview)
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
                self:removeChildByTag(1311, true)
      end)
        self.win_ListView=self.winnersPreview:getChildByName("win_ListView")
        self.win_ListView:addScrollViewEventListener((function(sender, eventType  )
                  if eventType  ==6 then
                        LocalData:Instance():set_getactivitywinners(nil)
                        Server:Instance():getactivityawards(self.surprise_id)
                                   return
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
          number:setString("0 ~ "  ..  sup_data[i]["awardcount"])
          local prize=cell:getChildByName("prize")
          prize:setString(sup_data[i]["awardorder"] ..  "等奖")
          local win_name=cell:getChildByName("win_name")
          win_name:setString(sup_data[i]["goodsname"])
          local win_img=cell:getChildByName("win_img")  
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
function SurpriseNode_Detail:onEnter()
   cc.SpriteFrameCache:getInstance():addSpriteFrames("DetailsiOfSurprise/LH_Plist.plist")
   NotificationCenter:Instance():AddObserver("GETACTIVITYAWARDS", self,
                       function()
                                  self:winnersPreview_list_image()
                      end)
   NotificationCenter:Instance():AddObserver("GAME_GETACTIVITYAWARDS", self,
                       function()
                                  self:fun_winnersPreview_list_init()
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
                       function()
                                  self:fun_data()
                      end)
end

function SurpriseNode_Detail:onExit()
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("DetailsiOfSurprise/LH_Plist.plist")
    NotificationCenter:Instance():RemoveObserver("GETACTIVITYAWARDS", self)
    NotificationCenter:Instance():RemoveObserver("GAME_GETACTIVITYAWARDS", self)
    NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
end

return SurpriseNode_Detail




