--
-- Author: peter
-- Date: 2016-05-09 16:51:21
--
local ContrastRecordLayer = class("ContrastRecordLayer", function()
            return display.newLayer("ContrastRecordLayer")
end)
function ContrastRecordLayer:ctor()
     
end
function ContrastRecordLayer:init(  )
	self.ContrastRecordLayer = cc.CSLoader:createNode("ContrastRecordLayer.csb");
    	self:addChild(self.ContrastRecordLayer)
    

end
function ContrastRecordLayer:onEnter()
	
end

function ContrastRecordLayer:onExit()
     	 
end

return ContrastRecordLayer


