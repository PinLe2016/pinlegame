
local DebrisSprite = class("DebrisSprite", function()
    return display.newSprite()
end)

function DebrisSprite:ctor()
   -- self:create(" ",10,10,10,10)
   print("liuyali")
   local sprite1 = display.newSprite("sp.png")
    local  rect = cc.rect(10,10,10,10)
    local clipnode = display.newClippingRegionNode(rect)
   --clipnode:addChild(sprite1)
    self:addChild(sprite1)
  

end

function DebrisSprite:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self,
											 function()
												dump("测试消息集成")
											end)
end

function DebrisSprite:onExit()
	NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self)
end
function DebrisSprite:create ( pszFileName, row, col, width, height, sX, sY, posx, posy)
  print("liuyali " .. posy)
    local pobSprite =  display.newSprite(pszFileName)
    local srcPosition=cc.p(posx,posy);
   local  rect = cc.rect(col*width, row*height,width, height);
    local clipnode = display.newClippingRegionNode(rect)
    pobSprite.m_nRowIndexSrc=row;
    pobSprite.m_nColIndexSrc=col;
    clipnode:addChild(pobSprite)
    pobSprite:setScale(sX,sY);
    pobSprite:setPosition(pobSprite.srcPosition);
    return pobSprite;

    


-- local fragment_sprite = display.newScale9Sprite(self.genie_sprite, 0, 0, cc.size(display.width,display.height))
-- fragment_sprite:setAnchorPoint(0, 0)
-- --fragment_sprite:setContentSize(fragment_sprite:getContentSize().width*0.8,fragment_sprite:getContentSize().height*0.8)
-- local po = fragment_sprite:getContentSize()
-- self.opop=po
-- self.content_size=po
-- local rect = cc.rect(0,0, po.width/3-3, po.height/3-3)
-- --创建一个裁剪区域用于裁剪图块
-- local clipnode = cc.ClippingRegionNode:create()
-- clipnode:setClippingRegion(rect)--设置裁剪区域的大小
-- clipnode:setContentSize(self.content_size.width/3-3, self.content_size.height/3-3)
-- clipnode:addChild(fragment_sprite)--添加图片
-- fragment_sprite:setPosition(0 - (j-1)*self.content_size.width/3, 0 - (i-1)*self.content_size.height/3)--设置图片显示的部分
-- self:addChild(clipnode)
-- self.fragment_table[#self.fragment_table + 1] = clipnode
-- clipnode:setPosition(pos_x + (j-1)*po.width/3, pos_y + (i-1)*po.height/3)











 end
return DebrisSprite