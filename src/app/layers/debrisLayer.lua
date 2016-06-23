--
-- Author: peter
-- Date: 2016-06-07 11:13:42
--
--
-- Author: Your Name
-- Date: 2016-04-19 09:45:58
--
--[[--传入必要参数
    params.filename   图片名
     params.row          图片切割竖行
     params.col            图片切割横
     params._size         图片大小
]]
local debrisLayer = class("debrisLayer", function()
    return display.newLayer()
end)

function debrisLayer:ctor(params)
       self:setNodeEventEnabled(true)--layer添加监听
        self.filename=params.filename
        self.point=params.point
        self._size=params._size
        self.row=params.row
        self.adid=params.adid
        self.col=params.col
        self.count=params.row* params.col
        self.fragment_sprite_bg = display.newScale9Sprite(self.filename, self.point.x,self.point.y, cc.size(self._size.width,self._size.height))
        self.fragment_sprite_bg:setAnchorPoint(0.0, 0.0)
        self.content_size = self._size

        self:addChild(self.fragment_sprite_bg)
        self.fragment_sprite_bg:setOpacity(0)

        self.fragment_table={}
        self.fragment_poins={}
        self.fragment_success={}
        self.fragment_col={}
        self.fragment_row={}
         self:sort_sure()--正确排序加载
         self:refresh_table()
end


function debrisLayer:refresh_table()

    local row_rand=self:RandomIndex(self.row,self.row)
    local col_rand=self:RandomIndex(self.col,self.col)

    local pos_x, pos_y =self.point.x,self.point.y
    local row ,col =self.row,self.col 
   for i=1,row do
        for j=1,col do
                local fragment_sprite = display.newScale9Sprite(self.filename, 0,0, cc.size(self._size.width,self._size.height))
                fragment_sprite:setAnchorPoint(0, 0)
                local po = self._size
                local rect = cc.rect(0,0, po.width/row-3, po.height/col-3)
                --创建一个裁剪区域用于裁剪图块
                local clipnode = cc.ClippingRegionNode:create()
                clipnode:setClippingRegion(rect)--设置裁剪区域的大小
                clipnode:setContentSize(self.content_size.width/row-3, self.content_size.height/col-3)
                clipnode:addChild(fragment_sprite)--添加图片
                -- clipnode:setAnchorPoint(0.5,0.5)
                fragment_sprite:setPosition(0 - (i-1)*self.content_size.width/row, 0 - (j-1)*self.content_size.height/col)--设置图片显示的部分
                self:addChild(clipnode)
               
                clipnode:setTag(#self.fragment_table + 1)
                self.fragment_poins[#self.fragment_table + 1]=cc.p(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                self.fragment_table[#self.fragment_table + 1] = clipnode

                clipnode:setPosition(pos_x + (row_rand[i]-1)*po.width/row, pos_y + (col_rand[j]-1)*po.height/col)
                --clipnode:setPosition(pos_x + (i-1)*po.width/row, pos_y + (j-1)*po.height/col)


                clipnode:setTouchEnabled(true)
                clipnode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                                        --self:touch_event(clipnode,event)--监听回调
                                        local position = cc.p(clipnode:getPosition())
                                        local boundingBox = cc.rect(position.x, position.y, self.content_size.width/self.row, self.content_size.height/self.col) --getCascadeBoundingBox()方法获得的rect大小为整张图片的大小，此处重新计算图块的rect。

                                        if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
                                                
                                                clipnode:setTouchSwallowEnabled(false)
                                                return false
                                        end

                                        if "began" == event.name then
                                            print("22222222")
                                                clipnode:setTouchSwallowEnabled(false)--吞噬触摸，防止响应下层的图块。
                                                clipnode:setLocalZOrder(4)
                                                return true
                                        elseif "moved" == event.name then
                                              self:touch_event_move(event,clipnode)
                                        elseif "ended" == event.name then
                                                self:touchEnd(event,clipnode)

                                        end
                            end)

                end
       end  
end
function debrisLayer:RandomIndex(indexNum, tabNum)

    indexNum = indexNum or tabNum

    local t = {}

    local rt = {}

    for i = 1,indexNum do

        local ri = math.random(1,tabNum + 1 - i)

        local v = ri

        for j = 1,tabNum do

            if not t[j] then

                ri = ri - 1

                if ri == 0 then

                    table.insert(rt,j)

                    t[j] = true

                end

            end

        end
   end
    --dump(rt)
    return rt
  
end

function debrisLayer:touch_event_move(event,clipnode)
        local pos_x, pos_y = clipnode:getPosition()
        pos_x = pos_x + event.x - event.prevX
        pos_y = pos_y + event.y - event.prevY
        if pos_x < display.left or pos_x > display.right + self.content_size.width/self.row then
            pos_x = pos_x - event.x + event.prevX
        end
        if pos_y < display.bottom or pos_y > display.top + self.content_size.height/self.col then
            pos_y = pos_y - event.y + event.prevY
        end
        clipnode:setPosition(pos_x, pos_y)        
end
function debrisLayer:sort_sure()
    local po = self.fragment_sprite_bg:getContentSize()
    dump(po)
    local pos_x, pos_y = self.point.x,self.point.y
    local dex = 1
    for i=1,self.row do --
        for j=1,self.col do --hang
            self.fragment_success[dex]=cc.p(pos_x + (i-1)*po.width/self.row, pos_y + (j-1)*po.height/self.col)
            dex=dex+1
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
            print("失败",self.adid)  
     --         Util:scene_control("SurpriseOverScene")
     -- Server:Instance():setgamerecord(self.adid)
            return
        end
    end
    print("成功")
    Util:scene_control("SurpriseOverScene")
    Server:Instance():setgamerecord(self.adid)
end

function debrisLayer:onEnter()
                NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self,
                       function()
                        print("拼图结束")
                        Util:scene_control("SurpriseOverScene")
                end)
end

function debrisLayer:onExit()
               NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self)
end

return debrisLayer
