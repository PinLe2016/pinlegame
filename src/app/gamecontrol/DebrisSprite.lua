
local DebrisSprite = class("DebrisSprite", function()
    return display.newSprite()
end)

function DebrisSprite:ctor(parms)
   -- self:create(" ",10,10,10,10)
   local sp = display.newTilesSprite("sp.jpg",cc.rect(10,10,10,10))
  

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
--       print(rect)
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