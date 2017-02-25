--
-- Author: Your Name
-- Date: 2015-10-27 15:37:56
--

--[[--

quick 按钮控件

]]

-- 按钮控件构建函数
-- @function [parent=#UIPushButton] ctor
-- @param table images 各种状态的图片
-- @param table options 参数表 其中scale9为是否缩放

--[[--

按钮控件构建函数

状态值:
-   normal 正常状态
-   pressed 按下状态
-   disabled 无效状态

--处理与 ScrollView或 UIListView 同时使用的菜单按钮触摸识别问题
require("app.layers.ToolLayers.ScrollViewMenu")
]]

local UIButton = cc.ui.UIButton
local UIPushButton = cc.ui.UIPushButton
local ScrollViewMenu = class("ScrollViewMenu",UIPushButton)

function ScrollViewMenu:ctor(images, options)
    ScrollViewMenu.super.ctor(self, {
        {name = "disable", from = {"normal", "pressed"}, to = "disabled"},
        {name = "enable",  from = {"disabled"}, to = "normal"},
        {name = "press",   from = "normal",  to = "pressed"},
        {name = "release", from = "pressed", to = "normal"},
    }, "normal", options)
    if type(images) ~= "table" then images = {normal = images} end
    self:setButtonImage(UIPushButton.NORMAL, images["normal"], true)
    self:setButtonImage(UIPushButton.PRESSED, images["pressed"], true)
    self:setButtonImage(UIPushButton.DISABLED, images["disabled"], true)

	self:setTouchSwallowEnabled(false)
end

function ScrollViewMenu:onTouch_(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
        self.touchBeganX = x
        self.touchBeganY = y
        if not self:checkTouchInSprite_(x, y) then return false end
        self.fsm_:doEvent("press")
        self.touchBegan=cc.p(x,y)
        self:dispatchEvent({name = UIPushButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        return true
    end

    local touchInTarget = self:checkTouchInSprite_(self.touchBeganX, self.touchBeganY)
                        and self:checkTouchInSprite_(x, y)
    if name == "moved" then
        if touchInTarget and self.fsm_:canDoEvent("press") then
            self.fsm_:doEvent("press")
            self:dispatchEvent({name = UIPushButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        elseif not touchInTarget and self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = UIPushButton.RELEASE_EVENT, x = x, y = y, touchInTarget = true})
        end
    else
    	local touchEnded=cc.p(x,y)
    	-- if (cc.pDistanceSQ(touchEnded, self.touchBegan) > 20) then
    	-- 	return
    	-- end
        if self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = UIPushButton.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
        end
        if name == "ended" and touchInTarget then
    	 if (cc.pDistanceSQ(touchEnded, self.touchBegan) < 20) then
        	self:dispatchEvent({name = UIPushButton.CLICKED_EVENT, x = x, y = y, touchInTarget = true})
         end
        end
    end
end

return ScrollViewMenu
