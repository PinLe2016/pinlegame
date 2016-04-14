
local DebrisSprite = class("DebrisSprite", function()
    return display.newSprite()
end)

function DebrisSprite:ctor(parms)
   -- self:create(" ",10,10,10,10)
  	self:setNodeEventEnabled(true)        
  	dump("pppppp")
	-- self:create(parms)
	NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.LOGIN_POST, nil)--消息测试
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
function DebrisSprite:create (buf)
	local  pobSprite =DebrisSprite
            pobSprite.srcPostion=setPosition(buf.posx,buf.posy)
            local  rect = cc.rect(buf.col*buf.width, buf.row*buf.height,buf.width, buf.height);
            

end
return DebrisSprite