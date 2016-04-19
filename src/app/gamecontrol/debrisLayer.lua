--
-- Author: Your Name
-- Date: 2016-04-19 09:45:58
--
--
-- Author: Your Name
-- Date: 2016-04-19 09:22:52
--
--
-- Author: Your Name
-- Date: 2016-04-19 09:10:58
--

local debrisLayer = class("debrisLayer", function()
    return display.newLayer()
end)

function debrisLayer:ctor(filename,row,col)
    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

--  self.genie_sprite="bg.png"
self.filename=filename
self.row=row
self.col=col
self.fragment_sprite_bg = display.newScale9Sprite(filename, 0, 0, cc.size(display.width,display.height))
 self.fragment_sprite_bg:setAnchorPoint(0.0, 0.0)
self.content_size = self.fragment_sprite_bg:getContentSize()
 self.fragment_sprite_bg:setPosition(display.cx - self.content_size.width/2, display.cy - self.content_size.height/2 )
 self.fragment_sprite_bg:addTo(self)
  self.fragment_sprite_bg:setOpacity(0)


self.fragment_table={}
self.fragment_poins={}
self.fragment_success={}
self.genie_sprite="sp.png"
 
local pos_x, pos_y = 0,0
   for i=1,row do
   	for j=1,col do

            local fragment_sprite = display.newScale9Sprite(self.genie_sprite, 0, 0, cc.size(display.width,display.height))
            fragment_sprite:setAnchorPoint(0, 0)
            local po = fragment_sprite:getContentSize()
            local rect = cc.rect(0,0, po.width/row-3, po.height/col-3)
            --创建一个裁剪区域用于裁剪图块
            local clipnode = cc.ClippingRegionNode:create()
            clipnode:setClippingRegion(rect)--设置裁剪区域的大小
            clipnode:setContentSize(self.content_size.width/row-3, self.content_size.height/col-3)
            clipnode:addChild(fragment_sprite)--添加图片
            fragment_sprite:setPosition(0 - (j-1)*self.content_size.width/row, 0 - (i-1)*self.content_size.height/col)--设置图片显示的部分
            self:addChild(clipnode)
            
            -- self.fragment_table[i][j] = clipnode
           
            clipnode:setTag(#self.fragment_table + 1)
            self.fragment_poins[#self.fragment_table + 1]=cc.p(pos_x + (j-1)*po.width/row, pos_y + (i-1)*po.height/col)
            self.fragment_success[#self.fragment_table + 1]=cc.p(pos_x + (j-1)*po.width/row, pos_y + (i-1)*po.height/col)

            self.fragment_table[#self.fragment_table + 1] = clipnode
            clipnode:setPosition(pos_x + (j-1)*po.width/row, pos_y + (i-1)*po.height/col)


            clipnode:setTouchEnabled(true)
            clipnode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                            --local boundingBox = clipnode:getCascadeBoundingBox()
                            local position = cc.p(clipnode:getPosition())
                            local boundingBox = cc.rect(position.x, position.y, self.content_size.width/row, self.content_size.height/col) --getCascadeBoundingBox()方法获得的rect大小为整张图片的大小，此处重新计算图块的rect。

                            if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
                                clipnode:setTouchSwallowEnabled(false)
                                return false
                            end

                            if "began" == event.name then
                                clipnode:setTouchSwallowEnabled(true)--吞噬触摸，防止响应下层的图块。
                                clipnode:setLocalZOrder(4)
                                return true
                            elseif "moved" == event.name then
                                local pos_x, pos_y = clipnode:getPosition()
                                pos_x = pos_x + event.x - event.prevX
                                pos_y = pos_y + event.y - event.prevY
                                if pos_x < display.left or pos_x > display.right + self.content_size.width/row then
                                    pos_x = pos_x - event.x + event.prevX
                                end
                                if pos_y < display.bottom or pos_y > display.top + self.content_size.height/col then
                                    pos_y = pos_y - event.y + event.prevY
                                end
                                clipnode:setPosition(pos_x, pos_y)
                            elseif "ended" == event.name then
                               self:touchEnd(event,clipnode)

                            end
                        end)

       	end
       end  
end

function debrisLayer:touchEnd(event,clipnode,pos)
       
        dump(clipnode:getPosition())
        clipnode:setLocalZOrder(3)
        dump(tonumber(clipnode:getTag()))
        
    for i=1,#self.fragment_table do
        local clipnode_1=self.fragment_table[i]
        local position = cc.p(clipnode_1:getPosition())
        local boundingBox = cc.rect(position.x, position.y, self.content_size.width/self.row, self.content_size.height/self.col)
        if cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) and tonumber(clipnode:getTag())~= tonumber(clipnode_1:getTag()) then
            -- dump(self.fragment_poins[tonumber(clipnode_1:getTag())])
            -- dump(self.fragment_poins[tonumber(clipnode:getTag())])

             clipnode:setPosition(self.fragment_poins[tonumber(clipnode_1:getTag())])
             clipnode_1:setPosition(self.fragment_poins[tonumber(clipnode:getTag())])
           
            self.fragment_poins[tonumber(clipnode:getTag())]=cc.p(clipnode:getPosition())
            self.fragment_poins[tonumber(clipnode_1:getTag())]=cc.p(clipnode_1:getPosition())
            -- return
        end
    end

    clipnode:setPosition(self.fragment_poins[tonumber(clipnode:getTag())])

    self:saw_issuccess()
end

function debrisLayer:saw_issuccess()
    for i=1,#self.fragment_poins do
        local pos=self.fragment_poins[i]
        local pos_suss=self.fragment_success[i]
        print("wwdwaf ",math.floor(pos.x),math.floor(pos_suss.x))
        if (math.floor(pos.x)~=math.floor(pos_suss.x) or math.floor(pos.y)~=math.floor(pos_suss.y) ) then
            print("失败")
            return
        end
    end
    print("成功")

end

function debrisLayer:onEnter()
end

function debrisLayer:onExit()
end

return debrisLayer
