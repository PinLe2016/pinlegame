--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
-- 活动详情
local DetailsLayer = class("DetailsLayer", function()
            return display.newLayer("DetailsLayer")
end)
function DetailsLayer:ctor(params)
       self:setNodeEventEnabled(true)--layer添加监听

       self.id=params.id
       self.image=params.image
       self.type=params.type--活动类型
       LocalData:Instance():set_actid({act_id=self.id,image=self.image})--保存数据
       Server:Instance():getactivitybyid(self.id)
     
 
end
function DetailsLayer:init(  )
            
	local activitybyid=LocalData:Instance():get_getactivitybyid()
            local user=LocalData:Instance():get_user_data()
            self.title=activitybyid["title"]
	local  function back_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		     Util:scene_control("SurpriseScene",self.id)
		     
		end
	end

	local  function began_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		      Util:scene_controlid("GameScene",{id=self.id,type="surprise",image=" "})
		      
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
	if tag==43 then --排行榜
		self:addChild(RankinglistofactiviesLayer.new({id=self.id,count=1,image=self.image,title=self.title}))
	elseif tag==42 then --个人记录
		self:addChild(OnerecordLayer.new({type=self.type,title=self.title}))
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
























