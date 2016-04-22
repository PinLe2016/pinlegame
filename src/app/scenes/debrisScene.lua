--
-- Author: Your Name
-- Date: 2016-04-19 09:45:07
--
local debrisScene = class("debrisScene", function()
    return display.newScene("debrisScene")
end)

local debrisLayer = require("app.gamecontrol.debrisLayer")
function debrisScene:ctor()
 


 --self._widget = cc.uiloader:load("Layer.csb"):addTo(self)


local de=debrisLayer.new("sp.png",3,4)
self:addChild(de)

-- local node = cc.CSLoader:createNode("Layer.csb");
--     self:addChild(node);

end

function debrisScene:onEnter()
end

function debrisScene:onExit()
end

return debrisScene