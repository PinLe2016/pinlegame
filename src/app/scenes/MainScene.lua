
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local  debrisSprite=require("app.gamecontrol.DebrisSprite")

function MainScene:ctor()
     local buf={}
	buf.pszfilename="liuyali"
	buf["row"]=1
	buf.col=2
	buf.width=2
	buf.height=3
	buf.sX=3
	buf.sY=3
	buf.posx=3
	buf.posy=4
    debrisSprite.new(buf)
   --[[cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)  ]]--

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
