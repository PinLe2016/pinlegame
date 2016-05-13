--
-- Author: peter
-- Date: 2016-05-12 11:06:05
--
--
-- Author: peter
-- Date: 2016-05-09 10:14:40
--
--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
--
local SurpriseOverScene = class("SurpriseOverScene", function()
            return display.newScene("SurpriseOverScene")
end)
function SurpriseOverScene:ctor()--params

        self.actid=LocalData:Instance():get_actid({act_id=self.id})
        self:init()
      
end
function SurpriseOverScene:init(  )

	self.Laohuji = cc.CSLoader:createNode("Laohuji.csb")
    	self:addChild(self.Laohuji)
    	local image_name=self.Laohuji:getChildByTag(161)
    	image_name:loadTexture(self.actid["image"])
    	self.began_bt=self.Laohuji:getChildByTag(164)
    	self.began_bt:setVisible(true)
    	self.began_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local show_bt=self.Laohuji:getChildByTag(165)
    	show_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local view_bt=self.Laohuji:getChildByTag(163)
    	view_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local back_bt=self.Laohuji:getChildByTag(160)
    	back_bt:addTouchEventListener(function(sender, eventType  )
    		print("拼乐加油")
		self:touch_callback(sender, eventType)
	end)
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

function SurpriseOverScene:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local activitypoints=LocalData:Instance():get_getactivitypoints()
	local tag=sender:getTag()
	if tag==164 then --开始
		self.began_bt:setVisible(false)
	            self.end_bt:setVisible(true)
		for i=1,#self. _table do
			self. _table[i]:startGo()
		end
		Server:Instance():getactivitypoints(self.actid["act_id"])  --老虎机测试
	elseif tag==165 then --分享
		print("分享")
	elseif tag==163 then --点我有惊喜
		print("点我有惊喜")
	elseif tag ==160 then --返回
		Util:scene_control("SurpriseScene")
	elseif tag==44 then  --结束
		local  tempn = activitypoints["points"]
		for i=1,#self. _table do
			local  stopNum = 0;
			if (tempn > 0)  then
				stopNum = tempn % 10;
				tempn = tempn / 10;
		            end
		           (self. _table[i]):stopGo(stopNum);
		end
		self:init_data()
	end
end
--初始化数据
function SurpriseOverScene:init_data(  )
	local activitypoints=LocalData:Instance():get_getactivitypoints()
	dump(activitypoints)
            local allscore_text=self.Laohuji:getChildByTag(63)--累计积分
            allscore_text:setString(tostring(activitypoints["totalPoints"]))
            local bestscore_text=self.Laohuji:getChildByTag(62)--最佳积分
            bestscore_text:setString(tostring(activitypoints["bestpoints"]))
            local rank_text=self.Laohuji:getChildByTag(64)--排名
            rank_text:setString(tostring(activitypoints["rank"]))
end
function SurpriseOverScene:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self,
                       function()
	                      	self.began_bt:setVisible(false)
		            self.end_bt:setVisible(true)
                      end)
end

function SurpriseOverScene:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self)
end

return SurpriseOverScene

















