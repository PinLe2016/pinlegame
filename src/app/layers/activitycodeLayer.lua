--
-- Author: peter
-- Date: 2016-06-22 21:47:44
--
--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--  活动吗
local activitycodeLayer = class("activitycodeLayer", function()
            return display.newLayer("activitycodeLayer")
end)
-- 标题 活动类型 
function activitycodeLayer:ctor()
         
         --Server:Instance():getactivitypointsdetail(self.id," ")  --个人记录排行榜HTTP
         self.tablecout=1
         self:setNodeEventEnabled(true)--layer添加监听
         self.time=0
         self.secondOne = 0
         self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        		self:update(dt)
    	end)

         self:init()
end
function activitycodeLayer:init(  )
	self.inputcodeLayer = cc.CSLoader:createNode("inputcodeLayer.csb");
    	self:addChild(self.inputcodeLayer)
            
             local hongdong_bt=self.inputcodeLayer:getChildByTag(115)--输入活动吗
             hongdong_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
              local back_bt=self.inputcodeLayer:getChildByTag(744)--输入活动吗
             back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))


    	
    self.activity_ListView=self.inputcodeLayer:getChildByTag(748)--惊喜吧列表
    self.activity_ListView:setItemModel(self.activity_ListView:getItem(0))
    -- self.activity_ListView:removeAllItems()


	 local true_bt=self.inputcodeLayer:getChildByTag(746)--关注活动
             true_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
		         LocalData:Instance():set_getactivitylist(nil)--数据制空
	                      self.tablecout=0  
	                      Server:Instance():getactivitylist(tostring(4),1)
	                      self.activity_ListView:removeAllItems()
	                      self:unscheduleUpdate()


                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
            end)

             local true_bt=self.inputcodeLayer:getChildByTag(745)--关注活动
             true_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            LocalData:Instance():set_getactivitylist(nil)--数据制空
	                 self.tablecout=0  
	                 Server:Instance():getactivitylist(tostring(5),1)
	                 self.activity_ListView:removeAllItems()
	                 self:unscheduleUpdate()

                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
            end)

	 

 
end
function activitycodeLayer:Onerecord_init(  )
	
end
function activitycodeLayer:touch_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
 	 local tag=sender:getTag()
              if tag==115 then   
                    self:huodong(  )
              elseif tag==761 then
              	if self.ActivitycodeLayer then
                            self:unscheduleUpdate()
              	     self.ActivitycodeLayer:removeFromParent()
              	end
              elseif  tag==764 then
              	Server:Instance():validateactivitycode(self. _sing:getString())
              	if self.ActivitycodeLayer then
              	     self.ActivitycodeLayer:removeFromParent()
              	end
              elseif tag==746 then
              	if conditions then
              		--todo
              	end
              	--todo
              elseif tag==745 then
              	--todo
              elseif tag==744 then
              	if self.inputcodeLayer then
                    self:unscheduleUpdate()
              	     self.inputcodeLayer:removeFromParent()
              	end
              end
            
            

end
function activitycodeLayer:huodong(  )
	self.ActivitycodeLayer = cc.CSLoader:createNode("ActivitycodeLayer.csb");
    	self:addChild(self.ActivitycodeLayer)
    	self. _sing=self.ActivitycodeLayer:getChildByTag(765)--活动码输入框
    
    	local back_bt=self.ActivitycodeLayer:getChildByTag(761)--关闭
             back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))


             local true_bt=self.ActivitycodeLayer:getChildByTag(764)--确定
             true_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)

               end))


            


end
function activitycodeLayer:actimages_list( )
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
function activitycodeLayer:act_list()
	
          self.list_table=LocalData:Instance():get_getactivitylist()
          local  sup_data=self.list_table["game"]
           self.sup_data_num= #sup_data
           if self.tablecout<self.sup_data_num then
                   print("小于",self.tablecout ,"  ",self.sup_data_num)
           elseif self.tablecout>self.sup_data_num then
                 print("大于")
                 activity_ListView:removeAllItems() 
            else
                 return
           end

          
           
          local  function onImageViewClicked(sender, eventType)
                    
                    if eventType == ccui.TouchEventType.ended then
                           self:unscheduleUpdate()
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
          -- dump(self.list_table)
          self.activity_ListView:removeAllItems()
          local  sup_data=self.list_table["game"]
          for i=self.tablecout+1,#sup_data do
          	self.activity_ListView:pushBackDefaultItem()
          	local  cell = self.activity_ListView:getItem(i-1)
            cell:setTag(i)
            local activity_Panel=cell:getChildByTag(750)
            cell:addTouchEventListener(onImageViewClicked)
            activity_Panel:loadTexture(tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            local type=cell:getChildByTag(751)
            local type_image=sup_data[i]["type"] .. ".png"
            type:loadTexture(type_image)
          end
           self:scheduleUpdate()
          self.tablecout=self.sup_data_num
end
  function activitycodeLayer:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
            self.time=1+self.time
            local  sup_data=self.list_table["game"]
            if not sup_data then return end
            for i=1,#sup_data do
         	local  cell = self.activity_ListView:getItem(i-1)
            local _table=Util:FormatTime_colon(sup_data[i]["finishtime"]-sup_data[i]["begintime"]-self.time)
            local dayText=cell:getChildByTag(756)
            dayText:setString(tostring(_table[1] .. _table[2] .. _table[3] .. _table[4] ))
            -- local hoursText=cell:getChildByTag(39)
            -- hoursText:setString(tostring(_table[2]))
            -- local pointsText=cell:getChildByTag(40)
            -- pointsText:setString(tostring(_table[3]))
            -- local secondsText=cell:getChildByTag(41)
            -- secondsText:setString(tostring(_table[4]))
        end
  end
function activitycodeLayer:onEnter()
	
	self.tablecout=0
  LocalData:Instance():set_getactivitylist(nil)
	Server:Instance():getactivitylist(tostring(4),1)  --self.ser_status   self.sur_pageno
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()
                         --print("7-------------")  --下载图片
                        
                       self:actimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()
                         --print("下拉刷新")   --获得图片
                       self:act_list()
                      end)
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ACTIVITYCODE, self,
                       function()
                        self:unscheduleUpdate()
                        LocalData:Instance():set_getactivitylist(nil)
                         Server:Instance():getactivitylist(tostring(4),1)   --再次刷新
                      end)--

end

function activitycodeLayer:onExit()
     	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYCODE, self)
end


return activitycodeLayer