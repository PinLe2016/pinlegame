--
-- Author: peter
-- Date: 2016-05-09 10:14:40
--
--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
--
local SurpriseOverLayer = class("SurpriseOverLayer", function()
            return display.newLayer("SurpriseOverLayer")
end)
function SurpriseOverLayer:ctor()
      self:init()
      -- self.Laohuji = cc.CSLoader:createNode("RankinglistofactiviesLayer.csb");
      -- self:addChild(self.Laohuji)
end
function SurpriseOverLayer:init(  )

	local function began_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local  tempn = 4895
			for i=1,#self. _table do
				local  stopNum = 0;
				if (tempn > 0)  then
				stopNum = tempn % 10;
				tempn = tempn / 10;
				end
				(self. _table[i]):stopGo(stopNum);
			end
		end
	end

	local function show_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			for i=1,#self. _table do
				self. _table[i]:startGo()
			end
		end
	end

	self.Laohuji = cc.CSLoader:createNode("Laohuji.csb");
    	self:addChild(self.Laohuji)
    	local began_bt=self.Laohuji:getChildByTag(164)
    	began_bt:addTouchEventListener(began_btCallback)
    	local show_bt=self.Laohuji:getChildByTag(165)
    	show_bt:addTouchEventListener(show_btCallback)
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
function SurpriseOverLayer:onEnter()
	 -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
  --                      function()
  --                     		 self:init()--活动详情初始化
  --                     end)
end

function SurpriseOverLayer:onExit()
     	 --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
end

return SurpriseOverLayer


