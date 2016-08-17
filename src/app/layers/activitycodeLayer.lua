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
         --audio.stopMusic("ACTIVITY")
         Util:stop_music("ACTIVITY")
         self.sur_pageno=1
         --Server:Instance():getactivitypointsdetail(self.id," ")  --个人记录排行榜HTTP
         self.tablecout=1
         self:setNodeEventEnabled(true)--layer添加监听
         self.time=0
         self.secondOne = 0
         self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        		self:update(dt)
    	end)
          self._typeevt=4
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
            self.activity_ListView:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        Server:Instance():getactivitylist(tostring(self._typeevt),self.sur_pageno)   --下拉刷新功能
                        --self:scheduleUpdate()
                                 return
                      end
            end))

            self.activity_ListView:removeAllItems()



	      local true_bt1=self.inputcodeLayer:getChildByTag(916)--关注活动
             true_bt1:setBright(false)
            self.curr_bright=true_bt1--记录当前高亮
             true_bt1:addTouchEventListener((function(sender, eventType  )
                     self:_touchbak(sender, eventType)
              end))

             local end_bt1=self.inputcodeLayer:getChildByTag(917)--结束活动
             end_bt1:addTouchEventListener((function(sender, eventType  )
                     self:_touchbak(sender, eventType)
              end))


            --  true_bt:addEventListener(function(sender, eventType  )
            --          if eventType == ccui.CheckBoxEventType.selected then
            --                 LocalData:Instance():set_getactivitylist(nil)--数据制空
	           --       self.tablecout=0  
	           --       Server:Instance():getactivitylist(tostring(5),1)
	           --       self.activity_ListView:removeAllItems()
	           --       self:unscheduleUpdate()

            --          elseif eventType == ccui.CheckBoxEventType.unselected then
            --                  print("关闭")
            --          end
            -- end)

	 

 
end
function activitycodeLayer:Onerecord_init(  )
	
end
function activitycodeLayer:_touchbak( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
            end
             local tag=sender:getTag()
             if self.curr_bright:getTag()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)

            
           if tag==916 then

                       LocalData:Instance():set_getactivitylist(nil)--数据制空
                        self.tablecout=0  
                        self._typeevt=4
                        Server:Instance():getactivitylist(tostring(self._typeevt),1)
                        self.activity_ListView:removeAllItems()
                        self:unscheduleUpdate()

              elseif tag==917 then

                 LocalData:Instance():set_getactivitylist(nil)--数据制空
                   self.tablecout=0  
                   self._typeevt=5
                   Server:Instance():getactivitylist(tostring(self._typeevt),1)
                   self.activity_ListView:removeAllItems()
                   self:unscheduleUpdate()
            end
             self.curr_bright=sender
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
              elseif tag==916 then

              	       LocalData:Instance():set_getactivitylist(nil)--数据制空
                        self.tablecout=0  
                        self._typeevt=4
                        Server:Instance():getactivitylist(tostring(self._typeevt),1)
                        self.activity_ListView:removeAllItems()
                        self:unscheduleUpdate()

              elseif tag==917 then

              	 LocalData:Instance():set_getactivitylist(nil)--数据制空
                   self.tablecout=0  
                   self._typeevt=5
                   Server:Instance():getactivitylist(tostring(self._typeevt),1)
                   self.activity_ListView:removeAllItems()
                   self:unscheduleUpdate()

              elseif tag==744 then
              	if self.inputcodeLayer then
                   -- audio.stopMusic(G_SOUND["GAMEBG"])
                   -- audio.playMusic(G_SOUND["ACTIVITY"],true)
                   Util:stop_music("GAMEBG")
                   Util:player_music("ACTIVITY",true )
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
          dump(self.list_table)
          if  self.activity_ListView then
            self.activity_ListView:removeAllItems() 
          end
          --self.activity_ListView:removeAllItems() 
          local  sup_data=self.list_table["game"]
           self.sup_data_num= #sup_data
           if self.tablecout<self.sup_data_num then
                   print("小于",self.tablecout ,"  ",self.sup_data_num)
           elseif self.tablecout>=self.sup_data_num then
                 print("大于")
                 self.activity_ListView:removeAllItems() 
           end
            self:unscheduleUpdate()
          
           
          local  function onImageViewClicked(sender, eventType)
                    
                    if eventType == ccui.TouchEventType.ended then
                           -- if self._typeevt  == 5 then
                           --    Server:Instance():prompt("活动已结束")
                           --    return
                           -- end
                             if self._typeevt  == 5  then     --获奖名单
                                      local  win_id=  sup_data[sender:getTag()]["id"]
                                      Server:Instance():getactivitywinners(win_id)
                                      self:_winners( )
                                      return
                             end

                           --self:unscheduleUpdate()
                           self.act_id=sup_data[sender:getTag()]["id"]
                           self. act_image=tostring(Util:sub_str(sup_data[sender:getTag()]["ownerurl"], "/",":"))
                            local  l_time=sup_data[sender:getTag()]["nowtime"]-sup_data[sender:getTag()]["begintime"]
                            if tonumber(l_time) <=  0 then
                              self:addChild(DetailsLayer.new({id=self.act_id,image=self. act_image,type=sup_data[sender:getTag()]["type"],_ky="act",ser_status=0}))
                              return
                            end

                          self:addChild(DetailsLayer.new({id=self.act_id,image=self. act_image,type=sup_data[sender:getTag()]["type"],_ky="act",ser_status=1}))
                 
                    end
          end  
          --活动列表进行排序
          local type_table={}
          -- for i=1,#sup_data do
          --         type_table[i]=sup_data[i]["type"]
          -- end

          -- for i=1,#type_table do
          --         for j=1,#type_table-i do
          --              if type_table[j]>type_table[j+1] then 
          --                     local  _data=sup_data[j]
          --                     sup_data[j]=sup_data[j+1]
          --                     sup_data[j+1]=_data
          --              end
          --         end
          -- end

          --self.list_table=LocalData:Instance():get_getactivitylist()
          -- dump(self.list_table)
          -- self.activity_ListView:removeAllItems()
         -- local  sup_data=self.list_table["game"]
          for i=1,#sup_data do  --self.tablecout+
          	self.activity_ListView:pushBackDefaultItem()
          	local  cell = self.activity_ListView:getItem(i-1)
            cell:setTag(i)
            local activity_Panel=cell:getChildByTag(750)
            cell:addTouchEventListener(onImageViewClicked)
            local path=cc.FileUtils:getInstance():getWritablePath()
            print("99999   ",tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            activity_Panel:loadTexture(tostring(Util:sub_str(sup_data[i]["ownerurl"], "/",":")))
            local type=cell:getChildByTag(751)
            local type_image=  "png/J_" .. sup_data[i]["type"] .. ".png"   --sup_data[i]["type"] .. ".png"  
            type:loadTexture(type_image)
             local _table=Util:FormatTime_colon((sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])-self.time)
            local dayText=cell:getChildByTag(756)
            local  _time=sup_data[i]["nowtime"]-sup_data[i]["begintime"]
            if _time <=  0 then
              local time_text=cell:getChildByTag(780)
              time_text:setString("距离活动开始还有:")
            end
            dayText:setString(tostring(_table[1] .. _table[2] .. _table[3] .. _table[4] ))

            if self._typeevt  == 5  then  --影藏标记
               local _tag=cell:getChildByTag(753)
               _tag:setVisible(false)
               local time_bg=cell:getChildByTag(754)
               time_bg:setVisible(false)
               local time_=cell:getChildByTag(756)
               time_:setVisible(false)
               local time_string=cell:getChildByTag(780)
               time_string:setVisible(false)
               local huojiang_bg=cell:getChildByTag(781)
               huojiang_bg:setVisible(true)
                if tonumber(sup_data[i]["isswardprize"])==0 then  --1是已经发奖  0是未发
                        cell:setTouchEnabled(false)  --禁止点击
                        activity_Panel:setTouchEnabled(true)
                        huojiang_bg:setColor(cc.c3b(100, 100, 100))
                        huojiang_bg:setTouchEnabled(false)
             end


            end
          end

          if tonumber(self.tablecout)~=0 then
            dump(self.tablecout)
             self.activity_ListView:jumpToPercentVertical(120)
           else
             self.activity_ListView:jumpToPercentVertical(0)
          end

           self:scheduleUpdate()
          self.tablecout=self.sup_data_num   

end
--初始化获奖名单
function activitycodeLayer:_winners( )
    self.Winners = cc.CSLoader:createNode("Winners.csb");
    self:addChild(self.Winners)

    local back_bt= self.Winners:getChildByTag(63)--返回
    back_bt:addTouchEventListener((function(sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                       return
            end
            if self.Winners then
               self.Winners:removeFromParent()
            end
                         
     end))

    self.win_ListView=self.Winners:getChildByTag(69)--获奖列表
    self.win_ListView:setItemModel(self.win_ListView:getItem(0))
    self.win_ListView:removeAllItems()

    self:winners_init()  --更新数据

end
--获奖名单中数据更新
function activitycodeLayer:winners_init( )
          self.win_table= LocalData:Instance():get_getactivitywinners()
          local  sup_data=self.win_table["winnerlist"]
          if not sup_data then
            return
          end
        self.win_ListView:removeAllItems()
          for i=1, #sup_data do  --#sup_data
            self.win_ListView:pushBackDefaultItem()

            local  cell = self.win_ListView:getItem(i-1)

            local name_text=cell:getChildByTag(72)--昵称
            name_text:setString(tostring(sup_data[i]["nickname"]))

            local paiming_tex=cell:getChildByTag(71)--排名
            paiming_tex:setString(tostring(i))

             local points_text=cell:getChildByTag(73)--积分
            points_text:setString(tostring(sup_data[i]["points"]))

            local goodsname_text=cell:getChildByTag(74) --获奖物品
            goodsname_text:setString(tostring(sup_data[i]["goodsname"]))
          end  
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
            local  _time=sup_data[i]["nowtime"]-sup_data[i]["begintime"]
             local _table={}
            if _time <=  0 then
               _table=Util:FormatTime_colon(sup_data[i]["begintime"]-sup_data[i]["nowtime"]-self.time)
            else
               _table=Util:FormatTime_colon((sup_data[i]["finishtime"]-sup_data[i]["begintime"])-(sup_data[i]["nowtime"]-sup_data[i]["begintime"])-self.time)
            end
          
            local dayText=cell:getChildByTag(756)
            dayText:setString(tostring(_table[1] .. _table[2] .. _table[3] .. _table[4] ))
        end
  end
function activitycodeLayer:onEnter()
      --audio.playMusic(G_SOUND["GAMEBG"],true)
      Util:player_music("GAMEBG",true )
	self.tablecout=0
      LocalData:Instance():set_getactivitylist(nil)
      self._typeevt=4
	Server:Instance():getactivitylist(tostring(self._typeevt),1)  --self.ser_status   self.sur_pageno
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
                        self._typeevt=4
                         Server:Instance():getactivitylist(tostring(self._typeevt),1)   --再次刷新
                      end)--
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.WINNERS, self,
                       function()

                       --self:_winners( )-- 获奖名单
                       self:winners_init()  --更新数据
                      end)

end

function activitycodeLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.WINNERS, self)
     	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYCODE, self)
end


return activitycodeLayer