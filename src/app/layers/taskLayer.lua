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
       self:init()
end
function taskLayer:init(  )
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
	for i=1,3 do
                  self.task_list:pushBackDefaultItem()
                  local  cell = self.task_list:getItem(i-1)

                  local  icon_image=cell:getChildByTag(200)--icon
                  --icon_image:loadTexture(" ")

                  local  task_but=cell:getChildByTag(178)--按钮
                  task_but:setTag(i)
                  task_but:setTitleText("签  到")
                  task_but:addTouchEventListener(function(sender, eventType  )

                                    self:touch_Callback(sender, eventType)
                   end)

                  local  gold_number=cell:getChildByTag(195)--获得金币
                  gold_number:setString("X30")

                  local  loadingbar_text=cell:getChildByTag(198)--进度条数值
                  loadingbar_text:setString("12/30")

                   local loadingbar=cell:getChildByTag(199)-- 进度条
	       local jindu=12/30 *100
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
           	 end
           end
          
end

function taskLayer:touch_Callback( sender, eventType )
	 if eventType ~= ccui.TouchEventType.ended then
                return
             end 
             local tag=sender:getTag()
	print("签到 ",tag)
end


function taskLayer:onEnter()
   
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FEEDBACK, self,
  --                      function()

  --                     end)
  
end

function taskLayer:onExit()
      --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FEEDBACK, self)
     
     	
end


return taskLayer




