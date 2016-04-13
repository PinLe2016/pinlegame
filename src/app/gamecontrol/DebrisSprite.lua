
local DebrisSprite = class("DebrisSprite", function()
    return display.newSprite()
end)

function DebrisSprite:ctor(parms)
   -- self:create(" ",10,10,10,10)
          

	print("------------")
	dump(parms)
	self:create(parms)
end

function DebrisSprite:onEnter()
end

function DebrisSprite:onExit()
end
function DebrisSprite:create (buf)
	local  pobSprite =DebrisSprite
            pobSprite.srcPostion=setPosition(buf.posx,buf.posy)
            local  rect = cc.rect(buf.col*buf.width, buf.row*buf.height,buf.width, buf.height);
            

end
return DebrisSprite