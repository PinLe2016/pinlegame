--
-- Author: peter
-- Date: 2016-05-09 10:14:40
--
--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
--
local SurpriseOverLayer = class("SurpriseOverLayer", function()
            return display.newScene("SurpriseOverLayer")
end)
function SurpriseOverLayer:ctor()--params

       local actid=LocalData:Instance():get_actid({act_id=self.id})
       Server:Instance():getactivitypoints(actid["act_id"])  --老虎机测试

       self:setNodeEventEnabled(true)--layer添加监听
      --self:init()
end
function SurpriseOverLayer:init(  )

	self.Laohuji = cc.CSLoader:createNode("Laohuji.csb")
    	self:addChild(self.Laohuji)
    	self.began_bt=self.Laohuji:getChildByTag(164)
    	self.began_bt:setVisible(true)
    	self.began_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local show_bt=self.Laohuji:getChildByTag(165)
    	show_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)

 --    	local back_bt=self.Laohuji:getChildByTag(160)
 --    	back_bt:addTouchEventListener(function(sender, eventType )
 --    		print("反馈的就是福克斯的")
	-- 	self:touch_callback(sender, eventType)
	-- end)
    	self.end_bt=self.Laohuji:getChildByTag(44)
    	self.end_bt:setVisible(false)
    	self.end_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	self. _table={}
    	for i=1,4 do
    		local score1=self.Laohuji:getChildByTag(157):getChildByTag(40-i)--score1
	    	local po1x=score1:getPositionX()
	    	local po1y=score1:getPositionY()
	            local laoHuJi1 = cc.LaoHuJiDonghua:create()--cc.CustomClass:create()
	            local msg = laoHuJi1:helloMsg()
	            release_print("customClass's msg is : " .. msg)
	            laoHuJi1:setDate("CSres/public/publicUI/number0-9", "item_", 10,cc.p(po1x,po1y) );
	            laoHuJi1:setStartSpeed(30);
	            self:addChild(laoHuJi1);
	            self._table[i]=laoHuJi1
    	end
    

end

function SurpriseOverLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local activitypoints=LocalData:Instance():getactivitypoints_callback()
	local tag=sender:getTag()
	if tag==164 then --开始
		self.began_bt:setVisible(false)
	            self.end_bt:setVisible(true)
		for i=1,#self. _table do
			self. _table[i]:startGo()
		end
	elseif tag==165 then --分享
		print("分享")
		Util:share()
	elseif tag==160 then --返回
	          	--Util:scene_control("SurpriseScene")
	elseif tag==44 then  --结束
		print("4444444")
		self:L_end(  )
	end
end
function SurpriseOverLayer:L_end(  )
	print("kaishi 1213")
	local  tempn = activitypoints["points"]
	for i=1,#self. _table do
		local  stopNum = 0;
		if (tempn > 0)  then
			stopNum = tempn % 10;
			tempn = tempn / 10;
	            end
	(self. _table[i]):stopGo(stopNum);
	end
	print("kaishi 33333")
	local daojishi_bg=self.Laohuji:getChildByTag(102)
	daojishi_bg:setGlobalZOrder(100)
	self.daojishi_text=daojishi_bg:getChildByTag(104)
	daojishi_bg:setVisible(true)
	self._time=10
    	self.L_began=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdown()
             end,1.0, false)
            print("kaishi ")
end
 function SurpriseOverLayer:countdown()
 print("试试事实上 " ,self._time)
           self._time=self._time-1
           self.daojishi_text:setString(tostring(self._time))
           if self._time==0 then
              self.began_bt:setVisible(true)
	  self.end_bt:setVisible(false)
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.L_began)--停止定时器
           end
end


--初始化数据
function SurpriseOverLayer:init_data(  )
	local activitypoints=LocalData:Instance():getactivitypoints_callback()

            local allscore_text=self.Laohuji:getChildByTag(63)--累计积分
            allscore_text:setString(tostring(activitypoints["totalPoints"]))
            local bestscore_text=self.Laohuji:getChildByTag(62)--最佳积分
            bestscore_text:setString(tostring(activitypoints["bestpoints"]))
            local rank_text=self.Laohuji:getChildByTag(64)--排名
            rank_text:setString(tostring(activitypoints["rank"]))
end
function SurpriseOverLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self,
                       function()
                      		 self:init()--活动详情初始化
                      end)
end

function SurpriseOverLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self)
end

return SurpriseOverLayer

















