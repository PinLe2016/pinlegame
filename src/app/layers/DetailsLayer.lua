--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
-- 活动详情
local DetailsLayer = class("DetailsLayer", function()
            return display.newLayer("DetailsLayer")
end)
GameScene = require("app/scenes/GameScene")
function DetailsLayer:ctor(params)
       self:setNodeEventEnabled(true)--layer添加监听
       self._ky=params._ky
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
		     -- Util:scene_control("MainInterfaceScene",self.id)s
		     -- self:removeFromParent()
		     if self._ky=="sup" then
		     	 Util:scene_control("SurpriseScene")
		     else
		     	 self:removeFromParent()
		     end
		    
		    
		end
	end

	local  function began_btCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
		     -- Util:scene_controlid("GameScene",{adid=self.id,type="daojishi",image=" "}) -- 目前暂停
		       local scene=GameScene.new({adid=self.id,type="surprise",image=" "})  --daojishi
                      	       cc.Director:getInstance():pushScene(scene)
		      --Util:scene_control("SurpriseOverScene")
		      
		end
	end
	local details = cc.CSLoader:createNode("DetailsScene.csb")
	self:addChild(details)

	local back_bt=details:getChildByTag(32)
	back_bt:addTouchEventListener(back_btCallback)

	local began_bt=details:getChildByTag(26)
	began_bt:addTouchEventListener(began_btCallback)
            
             local rules_bt=details:getChildByTag(27)--规则
             rules_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
               end)
              )

	local act_image=details:getChildByTag(35)
	local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
	act_image:loadTexture(path..self.image)

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
	head_image:loadTexture("cre/"..LocalData:Instance():get_user_head())

	local Personalrecord_bt=details:getChildByTag(42)--个人记录
	if self.type==3   or  self.type==4 then
		Personalrecord_bt:setVisible(false)
	else
		Personalrecord_bt:setVisible(true)
	end
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
		self:addChild(RankinglistofactiviesLayer.new({id=self.id,count=20,image=self.image,title=self.title,_type=self.type}))
	elseif tag==42 then --个人记录
		self:addChild(OnerecordLayer.new({id=self.id,type=self.type,title=self.title,_type=self.type}))
	elseif tag==27 then   --规则
		self:guizelayer(  )
            elseif tag==787 then   --规则
		if self.Ruledescription then
			self.Ruledescription:removeFromParent()
		end
	elseif tag==786 then   --疑问
		print("疑问")
	end
	
end
function DetailsLayer:_btCallback(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	 if self.curr_bright:getTag()==tag then
                  return
              end
            self.curr_bright:setBright(true)
            sender:setBright(false)
	if tag==810 then 
	      self:is_visible(  )
	      local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(803)
	      _text1:setVisible(true)
	elseif tag==811 then
		 self:is_visible(  )
		 local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(804)
	             _text1:setVisible(true)
	elseif tag==812 then
		self:is_visible(  )
		 local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(805)
	            _text1:setVisible(true)
	elseif tag==813 then
		self:is_visible(  )
		 local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(806)
	             _text1:setVisible(true)
	elseif tag==814 then
		self:is_visible(  )
		 local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(807)
	            _text1:setVisible(true)
	elseif tag==815 then
		self:is_visible(  )
	            local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(808)
	            _text1:setVisible(true)
	end
	self.curr_bright=sender
end
function DetailsLayer:is_visible(  )
	  local _text1=self.Ruledescription:getChildByTag(802):getChildByTag(803)
	   _text1:setVisible(false)
	   local _text2=self.Ruledescription:getChildByTag(802):getChildByTag(804)
	   _text2:setVisible(false)
	   local _text3=self.Ruledescription:getChildByTag(802):getChildByTag(805)
	   _text3:setVisible(false)
	   local _text4=self.Ruledescription:getChildByTag(802):getChildByTag(806)
	   _text4:setVisible(false)
	   local _text5=self.Ruledescription:getChildByTag(802):getChildByTag(807)
	   _text5:setVisible(false)
	   local _text6=self.Ruledescription:getChildByTag(802):getChildByTag(808)
	   _text6:setVisible(false)

end
function DetailsLayer:guizelayer(  )
	self.Ruledescription = cc.CSLoader:createNode("Ruledescription.csb")
            self:addChild(self.Ruledescription)
            local back_bt=self.Ruledescription:getChildByTag(787)--
	back_bt:addTouchEventListener(function(sender, eventType  )
		self:list_btCallback(sender, eventType)
	end)
	local doubt_bt=self.Ruledescription:getChildByTag(786)--  问号
	doubt_bt:addTouchEventListener(function(sender, eventType  )
		self:list_btCallback(sender, eventType)
	end)

	 local type_bt=self.Ruledescription:getChildByTag(810)--年
	type_bt:addTouchEventListener(function(sender, eventType  )
		self:_btCallback(sender, eventType)
	end)
	type_bt:setBright(false)
            self.curr_bright=type_bt--记录当前高亮

	 local type_bt1=self.Ruledescription:getChildByTag(811)--月
	type_bt1:addTouchEventListener(function(sender, eventType  )
		self:_btCallback(sender, eventType)
	end)
	 local type_bt2=self.Ruledescription:getChildByTag(812)--周
	type_bt2:addTouchEventListener(function(sender, eventType  )
		self:_btCallback(sender, eventType)
	end)
	 local type_bt3=self.Ruledescription:getChildByTag(813)--热门
	type_bt3:addTouchEventListener(function(sender, eventType  )
		self:_btCallback(sender, eventType)
	end)
	 local type_bt4=self.Ruledescription:getChildByTag(814)--日
	type_bt4:addTouchEventListener(function(sender, eventType  )
		self:_btCallback(sender, eventType)
	end)
	 local type_bt5=self.Ruledescription:getChildByTag(815)--整点
	type_bt5:addTouchEventListener(function(sender, eventType  )
		self:_btCallback(sender, eventType)
	end)

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
























