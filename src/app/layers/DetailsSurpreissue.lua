
--  新版惊喜吧  活动详情
local DetailsSurpreissue = class("DetailsSurpreissue", function()
            return display.newLayer("DetailsSurpreissue")
end)
function DetailsSurpreissue:ctor(params)
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self.surprise_id=params.id
      self.surprise_mylevel=params.mylevel
      self.time_count_n=1
      self.lv_table_image_idex={14,15,16,17,13,12,11,10,9}
      self.LV_hierarchy_table={"国王","公爵","侯爵","伯爵","子爵","男爵","勋爵","骑士","平民"}
      Server:Instance():getactivitywinners(self.surprise_id)  --  获奖名单
      self:setNodeEventEnabled(true)

       --  初始化界面
       self:fun_init()     
       self:fun_Initialize_variable()
       Server:Instance():getactivitybyid(self.surprise_id,0)  --  详情
end
--  初始化变量
function DetailsSurpreissue:fun_Initialize_variable( ... )
    --  定时器
    self.time=0
    self.secondOne = 0
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self:update(dt)
    end)
end
function DetailsSurpreissue:update(dt)
            self.secondOne = self.secondOne+dt
            if self.secondOne <1 then return end
            self.secondOne=0
            self.time=1+self.time
              self.countdown_time=Util:FormatTime_colon(self.DJS_time-self.time)
              self.LH_number:setString(self.countdown_time[1]  .. self.countdown_time[2]  ..self.countdown_time[3]  ..self.countdown_time[4])
end
function DetailsSurpreissue:fun_init( ... )
      self.DetailsOfSurprise = cc.CSLoader:createNode("DetailsSurpreissue.csb");
      self:addChild(self.DetailsOfSurprise)

      self.XQ_bg=self.DetailsOfSurprise:getChildByName("XQ_bg")
      self.LH_bg=self.XQ_bg:getChildByName("LH_bg")
      self.LH_number=self.LH_bg:getChildByName("LH_number")
      self.ProjectNode_3=self.DetailsOfSurprise:getChildByName("ProjectNode_3")
      self.XQ_Friend_bg=self.ProjectNode_3:getChildByName("XQ_Friend_bg")

      self.LV_IMG=self.LH_bg:getChildByName("LV_IMG")
      for i=1,#self.LV_hierarchy_table do
          if self.surprise_mylevel  == self.LV_hierarchy_table[i]  then
           self.LV_IMG:loadTexture("DetailsiOfSurprise/JXB_BQHD_CUXQ_"   ..  self.lv_table_image_idex[i]  ..   ".png")
          end
      end
      self.Text_10=self.LH_bg:getChildByName("Text_10")

      self.XQ_FD_LIST=self.XQ_Friend_bg:getChildByName("XQ_FD_LIST")
      self.XQ_FD_LIST:setItemModel(self.XQ_FD_LIST:getItem(0))
      self.XQ_FD_LIST:removeAllItems()
      self.XQ_FD_LIST:setInnerContainerSize(self.XQ_FD_LIST:getContentSize())
      self:fun_touch()
end
function DetailsSurpreissue:fun_win_list_data( ... )
	local getactivitywinners=LocalData:Instance():get_getactivitywinners()
	local winnerlist =getactivitywinners["winnerlist"]
	if #winnerlist  <= 0  then
		return
	end
	 for i=1,#winnerlist do
	          self.XQ_FD_LIST:pushBackDefaultItem()
	          local  cell = self.XQ_FD_LIST:getItem(i-1)
	          local XQ_FD_LIST_Nickname=cell:getChildByName("XQ_FD_LIST_Nickname")
	          XQ_FD_LIST_Nickname:setString(winnerlist[i]["nickname"])

	          local Text_17=cell:getChildByName("Text_17")
	          Text_17:setString(winnerlist[i]["points"])

	          local XQ_FD_LIST_Number=cell:getChildByName("XQ_FD_LIST_Number")
	          XQ_FD_LIST_Number:setString(winnerlist[i]["goodsname"])

	          local XQ_FD_LIST_Head=cell:getChildByName("XQ_FD_LIST_Head")
	          local _index=string.match(tostring(Util:sub_str(winnerlist[i]["headimageurl"], "/",":")),"%d")
          	          if _index==nil then
          	          	_index=1
          	          end
          	         XQ_FD_LIST_Head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
	          
	          local XQ_FD_LIST_img=cell:getChildByName("XQ_FD_LIST_img")
	          local img_index=9
	          if tonumber(winnerlist[i]["rank"])>=9 then
	          	img_index=9
	           else
	           	img_index=tonumber(winnerlist[i]["rank"])
	          end
	          
	          XQ_FD_LIST_img:loadTexture("DetailsiOfSurprise/JXB_BQHD_CUXQ_"   ..  self.lv_table_image_idex[img_index]  ..   ".png")
                local  userdata=LocalData:Instance():get_user_data()
                local nickname=userdata["loginname"]
                if nickname== winnerlist[i]["nickname"] then
                    self.Text_10:setString(tostring(i))
                else
                  self.Text_10:setString("暂未上榜")
                end

	  end
end
function DetailsSurpreissue:fun_touch( ... )
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
                      Util:all_layer_backMusic()
                       
                      
                      self:unscheduleUpdate()
              self:removeFromParent()
      end)
      local XQ_FD_LIST_More_Bt=self.XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bt")
      local XQ_FD_LIST_Back=self.XQ_Friend_bg:getChildByName("XQ_FD_LIST_Back")
      local XQ_FD_LIST_More_Bg=self.XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bg")
      XQ_FD_LIST_Back:setVisible(false)
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
                Util:all_layer_backMusic()
                XQ_FD_LIST_Back:setVisible(true)
                XQ_FD_LIST_More_Bg:setVisible(false)
                self.ProjectNode_3:setPositionY(350)
                XQ_FD_LIST_More_Bt:setVisible(false)
      end)



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
                Util:all_layer_backMusic()
                XQ_FD_LIST_Back:setVisible(false)
                XQ_FD_LIST_More_Bg:setVisible(true)
                XQ_FD_LIST_More_Bt:setVisible(true)
                self.ProjectNode_3:setPositionY(0)
      end)
end
function DetailsSurpreissue:fun_ctor_data( ... )
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
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                if activitybyid["description"]  ~= "" then
                   self:fun_storebrowser(tostring(activitybyid["description"]))
                end
      end)

      self.DJS_time=(activitybyid["finishtime"]-activitybyid["begintime"])-(activitybyid["nowtime"]-activitybyid["begintime"])
      local  _tabletime_data=Util:FormatTime_colon(self.DJS_time)
      self.LH_number:setString(_tabletime_data[1]  .. _tabletime_data[2]  .._tabletime_data[3]  .._tabletime_data[4]  )
      self:scheduleUpdate()

end
--下载奖项预览图片
function DetailsSurpreissue:winnersPreview_Home_image(  )
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
function DetailsSurpreissue:onEnter()

 
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
                       function()
                       	 self:fun_ctor_data()
                        self:winnersPreview_Home_image()
                      end)
   NotificationCenter:Instance():AddObserver("msg_getactivitybyid", self,
                       function()
                                  local sup_data=LocalData:Instance():get_getactivitybyid()
                                  local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
                                  self._advertising_bt:loadTexture(path..tostring(Util:sub_str(sup_data["imageurl"], "/",":")))
                      end)
    NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.WINNERS, self,
                       function()
                       	 self:fun_win_list_data()
                      end)
end

function DetailsSurpreissue:onExit()
     NotificationCenter:Instance():RemoveObserver("msg_getactivitybyid", self)
     NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.WINNERS, self)
     NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
end

return DetailsSurpreissue




