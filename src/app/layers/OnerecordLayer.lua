--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--
local OnerecordLayer = class("OnerecordLayer", function()
            return display.newLayer("OnerecordLayer")
end)
function OnerecordLayer:ctor()
     
end
function OnerecordLayer:init(  )
	self.OnerecordLayer = cc.CSLoader:createNode("OnerecordLayer.csb");
    	self:addChild(self.OnerecordLayer)
	
    

end
function OnerecordLayer:onEnter()
	
end

function OnerecordLayer:onExit()
     	 
end

return OnerecordLayer