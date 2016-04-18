
local DebrisSprite = class("DebrisSprite", function()
    return display.newLayer()
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
-- function DebrisSprite:create ( pszFileName, row, col, width, height, sX, sY, posx, posy)
--     local pobSprite =  DebrisSprite.new( );
--     local srcPosition=cc.p(posx,posy);
--    local  rect = cc.rect(col*width, row*height,width, height);
--     local clipnode = display.newClippingRegionNode(rect)
--     pobSprite.m_nRowIndexSrc=row;
--     pobSprite.m_nColIndexSrc=col;
--     print(pszFileName  )
--     if (pobSprite and  pobSprite:cc.prite:initWithFile(pszFileName, rect)) then
    
--         pobSprite:setScale(sX,sY);
--         pobSprite:setPosition(pobSprite.srcPosition);
--         return pobSprite;
--     end 
--     return nil;
--  end
return DebrisSprite