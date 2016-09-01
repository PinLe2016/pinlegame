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
       local _type={"Server:Instance():getcheckinhistory()","1","2"}
        self.type_table={}
        for i=1,#_type do
          self.type_table[i]=_type[i]
        end
       
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
                  task_but:setTitleText(tasklist[i]["title"])
                  task_but:addTouchEventListener(function(sender, eventType  )

                                    self:touch_Callback(sender, eventType)
                   end)

                  local  title=cell:getChildByTag(196)--描述
                  title:setString(tasklist[i]["description"])

                  local  gold_number=cell:getChildByTag(195)--获得金币   后续的改
                  if tasklist[i]["rewardtype"] == 0  then  --0为金币，1为积分，2为道具，3为商品
                     gold_number:setString("X" ..  tasklist[i]["rewardamount"])
                  end
                  

                  local  loadingbar_text=cell:getChildByTag(198)--进度条数值
                  loadingbar_text:setString(tasklist[i]["targetgoal"]  ..  "/"   ..   tasklist[i]["progress"])
                   local loadingbar=cell:getChildByTag(199)-- 进度条
      	       local jindu= tonumber(tasklist[i]["targetgoal"]) /  tonumber(tasklist[i]["progress"])  *100
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
       local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       LocalData:Instance():set_tasktable(tasklist[tag]["targetid"])  --记录
       local targettype=tasklist[tag]["targettype"]  --0为签到，1为邀请好友，2为分享，3为惊喜吧，4为奖池,5为获得金币数，6为获得积分数
	Server:Instance():getcheckinhistory()

        

end 


function taskLayer:onEnter()
   
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
                       function()
                                  self:init()
                      end)
  
end

function taskLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
     
     	
end


return taskLayer




