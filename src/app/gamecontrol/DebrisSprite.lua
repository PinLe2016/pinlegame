
local DebrisSprite = class("DebrisSprite", function()
    return display.newSprite()
end)

function DebrisSprite:ctor(parms)
   -- self:create(" ",10,10,10,10)
          

	
end

function DebrisSprite:onEnter()
end

function DebrisSprite:onExit()
end
-- function DebrisSprite:create (const char *pszFileName,int row,int col,int width,int height,float sX,float sY,int posx,int posy)
--     local pobSprite =  DebrisSprite.new( );
--     pobSprite.srcPosition=cc.p(posx,posy);
--    local  rect = cc.rect(col*width, row*height,width, height);
--     pobSprite.m_nRowIndexSrc=row;
--     pobSprite.m_nColIndexSrc=col;
    
--     if (pobSprite and  pobSprite:setDisplayFrame(pszFileName, rect))
--     {
--         pobSprite:setScale(sX,sY);
--         pobSprite:setPosition(pobSprite.srcPosition);
--         return pobSprite;
--     }
--     return nil;

            

-- end
return DebrisSprite