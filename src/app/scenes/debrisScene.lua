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


-- local de=debrisLayer.new("sp.png",3,4)
-- self:addChild(de)

  landing = cc.CSLoader:createNode("landing.csb");
  self:addChild(landing);
  landingbg_2 = landing:getChildByTag(6):getChildByTag(16)
  landingbg_2:setString("textl刘雅丽1226566")
  --landingbg_2:addEventListener(textFieldEvent)
  landingbg_2:addEventListener(function( )
                    print("hahaha开心")
            end)

ui.newTTFLabel({text = "User Login", size = 20, align = ui.TEXT_ALIGN_CENTER})
:pos(display.cx, display.cy+50)
:addTo(landingbg_2)
------
local function onEdit(event, editbox)
if event == "began" then
-- 开始输入
elseif event == "changed" then
-- 输入框内容发生变化
elseif event == "ended" then
-- 输入结束
elseif event == "return" then
-- 从输入框返回
end
end


end
local function textFieldEvent(sender, eventType)
     print("hahaha开心")
end
function debrisScene:onEnter()
end

function debrisScene:onExit()
end

return debrisScene