
--
-- 
local SurpriseScene = class("SurpriseScene", function()
            return display.newScene("SurpriseScene")
end)

local GameScene = require("app.scenes.GameScene")

function SurpriseScene:ctor()
      --self:addChild(SurpriseOverLayer.new())
	self.time=0
	self.secondOne = 0
	self.list_table={}
	self.floating_layer = FloatingLayerEx.new()
	self.floating_layer:addTo(self,100000)
	self:Surpriseinit()

	 self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        		self:update(dt)
    	end)
      Server:Instance():getactivitylist("1")
-- local pinle_loclation=cc.PinLe_platform.new()
--   local city=pinle_loclation:getCity()
--   dump(city)

end

function SurpriseScene:Surpriseinit()  --floatingLayer_init

  -- self.time=0
  -- self.secondOne = 0
  -- self.list_table={}
  -- self.floating_layer = FloatingLayerEx.new()
  -- self.floating_layer:addTo(self,100000)
  -- self:Surpriseinit()


  --  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
  --           self:update(dt)
  --     end)
    -- Server:Instance():validateactivitycode("123456")


    ActivitymainnterfaceiScene = cc.CSLoader:createNode("ActivitymainnterfaceiScene.csb");
    self:addChild(ActivitymainnterfaceiScene)

    local Soon_bt=ActivitymainnterfaceiScene:getChildByTag(29)--即将
    Soon_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))
     local activity_bt=ActivitymainnterfaceiScene:getChildByTag(30)-- 本期
    activity_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))
     local Reviewpast_bt=ActivitymainnterfaceiScene:getChildByTag(31)--回顾
    Reviewpast_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))
     local mysurprise_bt=ActivitymainnterfaceiScene:getChildByTag(117)--回顾
    mysurprise_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end)
    )
    local back_bt=ActivitymainnterfaceiScene:getChildByTag(28)--回顾
    back_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end))

    activity_ListView=ActivitymainnterfaceiScene:getChildByTag(33)--惊喜吧列表
    activity_ListView:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                                  -- print("技术开发建设看到房价",self.tt)
                                  --   activity_ListView:pushBackDefaultItem()
                                  --   local  cell = activity_ListView:getItem(self.tt)
                                 return
                      end
     end))
    activity_ListView:setItemModel(activity_ListView:getItem(0))
    activity_ListView:removeAllItems()
    return  self
end
  function SurpriseScene:list_btCallback( sender, eventType )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getTag()
              if tag==29 then
                      Server:Instance():getactivitylist("0")
                      activity_ListView:removeAllItems()
                      self:unscheduleUpdate()
              elseif tag==30 then
                      Server:Instance():getactivitylist("1")
                      activity_ListView:removeAllItems()
                      self:unscheduleUpdate()
              elseif tag==31 then
                      Server:Instance():getactivitylist("2")
                      activity_ListView:removeAllItems()
                      self:unscheduleUpdate()
              elseif tag==117 then
                      Server:Instance():getactivitylist("3")
                      activity_ListView:removeAllItems()
                      self:unscheduleUpdate()
              elseif tag==28 then
                        Util:scene_control("MainInterfaceScene")
              end
  end
  function SurpriseScene:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
            self.time=1+self.time
            local  sup_data=self.list_table["game"]
            if not sup_data then return end
            for i=1,#sup_data do
         	local  cell = activity_ListView:getItem(i-1)
            local _table=Util:FormatTime_colon(sup_data[i]["finishtime"]-sup_data[i]["begintime"]-self.time)
            local dayText=cell:getChildByTag(38)
            dayText:setString(tostring(_table[1]))
            local hoursText=cell:getChildByTag(39)
            hoursText:setString(tostring(_table[2]))
            local pointsText=cell:getChildByTag(40)
            pointsText:setString(tostring(_table[3]))
            local secondsText=cell:getChildByTag(41)
            secondsText:setString(tostring(_table[4]))
        end
  end

        
function SurpriseScene:Surprise_list(  )--Util:sub_str(command["command"], "/") 
          activity_ListView:removeAllItems()

          self.list_table=LocalData:Instance():get_getactivitylist()
          local  sup_data=self.list_table["game"]
           self.tt= #sup_data
           -- dump(sup_data)
          local  function onImageViewClicked(sender, eventType)
                    
                    if eventType == ccui.TouchEventType.ended then
                           self.act_id=sup_data[sender:getTag()]["id"]
                           self. act_image=tostring(Util:sub_str(sup_data[sender:getTag()]["ownerurl"], "/",":"))
                          self:addChild(DetailsLayer.new({id=self.act_id,image=self. act_image,type=sup_data[sender:getTag()]["type"]}))
                    end
          end  
          --活动列表进行排序
          local type_table={}
          for i=1,#sup_data do
                  type_table[i]=sup_data[i]["type"]
          end

          for i=1,#type_table do
                  for j=1,#type_table-i do
                       if type_table[j]>type_table[j+1] then 
                              local  _data=sup_data[j]
                              sup_data[j]=sup_data[j+1]
                              sup_data[j+1]=_data
                       end
                  end
          end

          self.list_table=LocalData:Instance():get_getactivitylist()
          local  sup_data=self.list_table["game"]
          for i=1,#sup_data do
          	activity_ListView:pushBackDefaultItem()
          	local  cell = activity_ListView:getItem(i-1)
            cell:setTag(i)
            local activity_Panel=cell:getChildByTag(36)
            cell:addTouchEventListener(onImageViewClicked)
            activity_Panel:loadTexture(tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            local Nameprize_text=cell:getChildByTag(42)
            Nameprize_text:setString(tostring(sup_data[i]["gsname"]))
            local type=cell:getChildByTag(133)
            local type_image=sup_data[i]["type"] .. ".png"
            type:loadTexture(type_image)
          end

          self:scheduleUpdate()
end
function SurpriseScene:Surpriseimages_list(  )
         local list_table=LocalData:Instance():get_getactivitylist()
         local  sup_data=list_table["game"]
         for i=1,#sup_data do
         	local com_={}
         	com_["command"]=sup_data[i]["ownerurl"]
         	com_["max_pic_idx"]=#sup_data
         	com_["curr_pic_idx"]=i
       
         	Server:Instance():request_pic(sup_data[i]["ownerurl"],com_) --下载图片
         end
end
function SurpriseScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function SurpriseScene:onEnter()

	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()
                       self:Surpriseimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()
                        print("get_suprite  ")
                       self:Surprise_list()
                      end)
end

function SurpriseScene:onExit()
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)

end

return SurpriseScene