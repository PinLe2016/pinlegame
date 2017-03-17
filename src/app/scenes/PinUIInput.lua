--
-- Author: peter
-- Date: 2017-03-10 15:40:27
--
--local PinUIInput = import("framework/cc/ui/UIInput")
local PinUIInput = class("PinUIInput", cc.ui.UIInput)
-- local PinUIInput = class("PinUIInput", function()
--     local node = display.newClippingRegionNode()
--     return node
-- end)

function PinUIInput:ctor(params)
    dump(params)
    assert(params and type(params) == 'table')
    assert(params.fontSize)
    assert(params.size)
    params.UIInputType = 1

     PinUIInput.super.ctor(self, params)

    self.fontSize = params.fontSize
    self.size = params.size

    self.allText = {}
    local curText = self:getStringValue()--"pinle"
    curText:gsub(".", function (c) table.insert(self.allText, c) end)

    self:addEventListener(self.textFieldEventListner)
--     self:setTouchEnabled(true)
--     self:setNodeEventEnabled(true)--layer添加监听
--     self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event) 
--                if event.name == "began" then  
--                  print("坐标")
--                  self:textFieldEventListner(event)  
--                end  
--                return true  
--       end)  
-- self:textFieldEventListner(1)  
    self:initCursorSprite("png/chengzhangshu-shou-2.png")
end

function PinUIInput:textFieldEventListner(eventType)
    print('------------>input event: '..eventType)
    local curText = self:getStringValue()
    local curDimension = self:getDimension(curText)

    if eventType == 0 then      -- attach IME
        PinLog.debug('PinUIInput Event: Attach IME. curText: %s', curText)
        self.cursor:setVisible(true)

        local allText = table.concat(self.allText)
        local allDimension = self:getDimension(allText)
        if allDimension > self:getContentSize().width then

            local charWidth = allDimension / #allText
            local displayLen = math.floor(self:getContentSize().width / charWidth - 0.5)

            local startPos = #allText - displayLen
            if startPos < 1 then
                startPos = 1
            end
            curText = string.sub(allText, startPos, -1)
            self:setText(curText)
        end

    elseif eventType == 1 then  -- detach IME
        PinLog.debug('PinUIInput Event: Detach IME. curText: %s', curText)
        self.cursor:setVisible(false)

    elseif eventType == 2 then  -- insert text
        table.insert(self.allText, string.sub(curText, -1, -1))

        PinLog.debug('PinUIInput Event: Insert text. curText: [%s] allText: [%s]', 
            curText, table.concat(self.allText))

        if curDimension > self:getContentSize().width then
            curText = string.sub(curText, 2)
            self:setText(curText)
        end

    elseif eventType == 3 then  -- delete text
        if curText == '' then
            self.allText = {}
        else
            table.remove(self.allText)
        end

        PinLog.debug('PinUIInput Event: Delete backward text. curText: %s allText: [%s]', 
            curText, table.concat(self.allText))

        local allText = table.concat(self.allText)
        local allDimension = self:getDimension(allText)
        if allDimension > self:getContentSize().width then
            if #allText > #curText then
                local startPos, endPos = string.find(allText, curText)
                curText = string.sub(allText, startPos - 2, endPos)
            end
            self:setText(curText)
        end
    end

    self.cursor:setPositionX(self:getDimension(curText))
end
--  光标闪烁图片
function PinUIInput:initCursorSprite(imageName)
    self.cursor = display.newSprite(imageName, 0, self.size.height / 2, {scale9 = false})
    self.cursor:addTo(self)

    local sequence = transition.sequence({
        cc.FadeOut:create(0.6),
        cc.FadeIn:create(0.7),
    })
    local foreverAction = cc.RepeatForever:create(sequence)

    self.cursor:runAction(foreverAction)
   -- self.cursor:setVisible(false)
end

function PinUIInput:getDimension(text)
    local label = cc.ui.UILabel.new({
        text = text, 
        size = self.fontSize, 
        font = self:getFontName()})

    return label:getContentSize().width
end

function PinUIInput:getAllText()
    return table.concat(self.allText)
end

return PinUIInput