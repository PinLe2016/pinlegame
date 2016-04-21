
local FloatingLayer = class("FloatingLayer", function()
    return display.newLayer()
end)

function FloatingLayer:ctor()
	self.float_number = 0
	self.float_array = {}
end

function FloatingLayer:showFloat(text,is_resource,resourceType)
	self.float_number = self.float_number + 1

	self.height = 46
	-- local floating_bg = display.newScale9Sprite("ui/floating.png")
	-- floating_bg:setPosition(320, display.cy+self.height+self.height/2+5)
	-- floating_bg:addTo(self,3)
	-- local string
	-- if is_resource then

	-- else
		string = text
	-- end

	local name = cc.ui.UILabel.new({text = string,
	       size = 28,
	       align = TEXT_ALIGN_CENTER,
	       font = "Arial",
	       color = cc.c4b(255,241,203),
	       })
	name:setAnchorPoint(0.5,0.5)

	name:setPosition(320, display.cy+self.height+self.height/2+5)
	name:addTo(self,100)


	table.insert(self.float_array,name)
	--在这里需要更改

	self:resetPos()

	local sequence1 = transition.sequence({
		cc.MoveBy:create(0.5, cc.p(0, 300)),
	    cc.FadeOut:create(0.5),
	})

	local sequence = transition.sequence({
		cc.DelayTime:create(1),
		sequence1,
		cc.CallFunc:create(function() self:remove() end)

	})
	name:runAction(sequence)
end

function FloatingLayer:remove()
	self.float_number = self.float_number - 1
	local sprite= self.float_array[1]
	sprite:removeFromParent()
	table.remove(self.float_array,1)
end 

function FloatingLayer:getFloatNumber()
	return self.float_number
end 


--我自己的方法
function FloatingLayer:resetPos()
	for i= 1,self.float_number do
		local sprite = self.float_array[self.float_number-i+1]
		-- local rect = sprite:getBoundingBox()
		if self.float_number > 1 then
			if sprite:getPositionY() < display.cy + i*self.height +rect.height/2 then
				local i_down_konw = display.cy+i*self.height+100/2
				sprite:setPosition(320,i_down_konw)
			end 
		end 
	end
end 

return FloatingLayer
