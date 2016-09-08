--
-- Author: peter
-- Date: 2016-08-24 14:24:11   taskLayer
-- Author: peter
-- Date: 2016-05-09 16:51:38
--  任务拼乐界面
local taskLayer = class("taskLayer", function()
            return display.newLayer("taskLayer")
end)
function taskLayer:ctor()
       self:setNodeEventEnabled(true)--layer添加监听
       self.sur_pageno=1
       Server:Instance():gettasklist()
       
end
function taskLayer:init(  )
        LocalData:Instance():set_sign(2)
        self.taskLayer = cc.CSLoader:createNode("taskLayer.csb");
        self:addChild(self.taskLayer)

         local back_bt=self.taskLayer:getChildByTag(141)  --返回
            back_bt:addTouchEventListener((function(sender, eventType  )
                     self:touch_btCallback(sender, eventType)
               end))
            self.task_list=self.taskLayer:getChildByTag(143)--邮箱列表
            self.task_list:setItemModel(self.task_list:getItem(0))
            self.task_list:removeAllItems()
            self.task_list:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        --Server:Instance():getaffichelist(self.sur_pageno)   --下拉刷新功能
                                 return
                      end
             end))          

            self:data_init()  --测试
end
function taskLayer:data_init(  )
      local _table=LocalData:Instance():get_gettasklist()
      local tasklist=_table["tasklist"]
      if #tasklist==0 then
        self.task_list:setVisible(false)
        return
      end

	for i=1,#tasklist do
                  self.task_list:pushBackDefaultItem()
                  local  cell = self.task_list:getItem(i-1)

                  local  icon_image=cell:getChildByTag(200)--icon
                  --icon_image:loadTexture(" ")

                  local  task_but=cell:getChildByTag(178)--按钮
                  task_but:setTag(i)
                   local  task_text=cell:getChildByTag(1227)--按钮
                   

                   if  tonumber(tasklist[i]["status"]) == 1   then   --1未完成  2已完成未领取  3已完成所有任务且已领取
                      task_text:setString(tasklist[i]["title"])
                  elseif tonumber(tasklist[i]["status"]) == 2 then
                      task_text:setString("领 取")
                  elseif tonumber(tasklist[i]["status"]) == 3 then
                      task_text:setString("已领取")
                      tasktask_text_but:setColor(cc.c3b(100,100,100))
                      task_but:setTouchEnabled(false)
                  end
                  print("ajfkdsaj几点上课范德萨发就",task_text:getStringLength())
                  if task_text:getStringLength() <= 4   then
                     task_text:setFontSize(28)
                  elseif  task_text:getStringLength() > 4   and   task_text:getStringLength() <=  6   then
                    task_text:setFontSize(20)
                  else
                    task_text:setFontSize(15)
                  end

                  
                  task_but:addTouchEventListener(function(sender, eventType  )

                                    self:touch_Callback(sender, eventType)
                   end)

                  local  title=cell:getChildByTag(196)--描述
                  title:setString(tasklist[i]["description"])
                  
                  if title:getStringLength() <= 7     then
                     title:setFontSize(23)
                  elseif  title:getStringLength() >= 7   then
                    title:setFontSize(12)
                  end


                  local  gold_number=cell:getChildByTag(195)--获得金币   后续的改

                  if tasklist[i]["rewardtype"] == 0  then  --0为金币，1为积分，2为道具，3为商品
                     gold_number:setString("X" ..  tasklist[i]["rewardamount"])
                  end
                  
                  local  loadingbar_text=cell:getChildByTag(198)--进度条数值
                  loadingbar_text:setString(tasklist[i]["progress"]  ..  "/"   ..   tasklist[i]["targetgoal"])  
                   local loadingbar=cell:getChildByTag(199)-- 进度条
      	       local jindu= tonumber(tasklist[i]["progress"]) /  tonumber(tasklist[i]["targetgoal"])  *100
      	       loadingbar:setPercent(jindu)
            end
end
function taskLayer:touch_btCallback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                return
            end 
           local tag=sender:getTag()
           if tag==141 then  --返回
           	  if self.taskLayer then
           		self:removeFromParent()
              Util:scene_control("MainInterfaceScene")
              LocalData:Instance():set_sign(1)
           	 end
           end  
end

function taskLayer:touch_Callback( sender, eventType )
	 if eventType ~= ccui.TouchEventType.ended then
                return
       end 
       local tag=sender:getTag() 
       local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       LocalData:Instance():set_tasktable(tasklist[tag]["targetid"])  --记录
       local targettype=tasklist[tag]["targettype"]  --0为签到，1为邀请好友，2为分享，3为惊喜吧，4为奖池,5为获得金币数，6为获得积分数
       if tonumber(tasklist[tag]["status"]) == 2 then
               Server:Instance():settasktargetrecord(tasklist[tag]["targetid"])  --领取奖励
               return
       end
       if  tonumber(targettype) == 0  then
            Server:Instance():getcheckinhistory()
       elseif  tonumber(targettype) == 1 then ---待定
             local FriendrequestLayer = require("app.layers.FriendrequestLayer")  --邀请好友
            self:addChild(FriendrequestLayer.new())
      elseif  tonumber(targettype) == 2 then  --分享
            --  local FriendrequestLayer = require("app.layers.FriendrequestLayer")  --邀请好友
            -- self:addChild(FriendrequestLayer.new())
      elseif  tonumber(targettype) == 3 then
            -- Util:scene_control("SurpriseScene")
             local scene=SurpriseScene.new()
            cc.Director:getInstance():pushScene(scene)

      elseif  tonumber(targettype) == 4 then
             --Util:scene_control("GoldprizeScene")
             local GoldprizeScene = require("app.scenes.GoldprizeScene")--主界面
              local scene=GoldprizeScene.new()
            cc.Director:getInstance():pushScene(scene)

       end
  

end 


function taskLayer:onEnter()
   
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
                       function()
                                  self:init()
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.TASKTARGETRECORD, self,
                       function()
                                  LocalData:Instance():set_gettasklist(nil)
                                  Server:Instance():gettasklist()
                      end)
  
end

function taskLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.TASKTARGETRECORD, self)
     
     	
end


return taskLayer




