--
-- Author: peter
-- Date: 2016-05-09 16:52:14
--
local RankinglistofactiviesLayer = class("RankinglistofactiviesLayer", function()
            return display.newLayer("RankinglistofactiviesLayer")
end)
function RankinglistofactiviesLayer:ctor()
     
end
function RankinglistofactiviesLayer:init(  )

	self:setNodeEventEnabled(true)
	
	self.RankinglistofactiviesLayer = cc.CSLoader:createNode("RankinglistofactiviesLayer.csb");
    	self:addChild(self.RankinglistofactiviesLayer)

    	list=self.RankinglistofactiviesLayer:getChildByTag(71)--排行榜列表
    	list:setItemModel(list:getItem(0))
    	list:removeAllItems()
	
end

function RankinglistofactiviesLayer:Rankinglistofactivies_init()
	
end

function RankinglistofactiviesLayer:onEnter()
	
end

function RankinglistofactiviesLayer:onExit()
     	 
end

return RankinglistofactiviesLayer