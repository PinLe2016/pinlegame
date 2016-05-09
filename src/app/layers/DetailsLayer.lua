--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
--
local DetailsLayer = class("DetailsLayer", function()
            return display.newLayer("DetailsLayer")
end)
function DetailsLayer:ctor(params)
      self:setNodeEventEnabled(true)--layer添加监听

      self.id=params.id
      self.image=params.image
      Server:Instance():getactivitybyid(self.id)
 
end
function DetailsLayer:init(  )
            
	local activitybyid=LocalData:Instance():get_getactivitybyid()
            local user=LocalData:Instance():get_user_data()

	local  function back_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		     Util:scene_control("SurpriseScene")
		end
	end

	local  function began_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		     Util:scene_control("GameScene")
		     self:removeFromParent()
		end
	end
	local details = cc.CSLoader:createNode("DetailsScene.csb")
	self:addChild(details)

	local back_bt=details:getChildByTag(32)
	back_bt:addTouchEventListener(back_btCallback)

	local began_bt=details:getChildByTag(26)
	began_bt:addTouchEventListener(began_btCallback)

	local act_image=details:getChildByTag(35)
	act_image:loadTexture(self.image)

	local act_title=details:getChildByTag(45)
	act_title:setString(activitybyid["title"])

	local integral_text=details:getChildByTag(40)
	integral_text:setString(activitybyid["mypoints"])

	local rank_text=details:getChildByTag(41)
	rank_text:setString(activitybyid["myrank"])

	local name_text=details:getChildByTag(38)
	name_text:setString(user["nickname"])

	local status_text=details:getChildByTag(39)
	status_text:setString(user["rankname"])

	local head_image=details:getChildByTag(36)
	--head_image:setString(user["myrank"])

	local Personalrecord_bt=details:getChildByTag(42)--个人记录
	Personalrecord_bt:addTouchEventListener(function(sender, eventType  )
		self:list_btCallback(sender, eventType)
	end)

	local list_bt=details:getChildByTag(43)--排行榜
	list_bt:addTouchEventListener(function(sender, eventType  )
		self:list_btCallback(sender, eventType)
	end)


end

function DetailsLayer:list_btCallback(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==43 then
		print("近段时间分开打手机费",self.id)
		Server:Instance():getranklistbyactivityid(self.id,2)  --排行榜HTTP
	elseif tag==42 then

	end
	
end
function DetailsLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
                       function()
                      		 self:init()--活动详情初始化
                      end)
end

function DetailsLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
end

return DetailsLayer


