
local FloatingLayer = class("FloatingLayer", function()
    return display.newLayer("FloatingLayer")
end)
-- function FloatingLayer:new(o)  
--     o = o or {}  
--     setmetatable(o,self)  
--     self.__index = self 
--     return o  
-- end 

function FloatingLayer:ctor()
    self:setTouchSwallowEnabled(false)--防止吞吃
end

function FloatingLayer:show_http(is_show,str)
       if  is_show==false then
         self:removeChildByTag(250, true)
         return
     end

     self:setTouchSwallowEnabled(true)--防止吞吃
    local loadingLayer = cc.CSLoader:createNode("loadingLayer.csb")
    self:addChild(loadingLayer,1,250)
    local _str=loadingLayer:getChildByTag(74)
    if str then
      _str:setString("授权中...")
    else
      _str:setString("加载中...")
    end

    local action = cc.CSLoader:createTimeline("loadingLayer.csb")
    action:setTimeSpeed(0.5)
    loadingLayer:runAction(action)
    action:gotoFrameAndPlay(0,30,true)
end
function FloatingLayer:showFloat(dialogtextString,call)  --floatingLayer_init
  

    self.dialog = cc.CSLoader:createNode("Dialog.csb");
    self:addChild(self.dialog,20,20)
    dialogtext = self.dialog:getChildByTag(44)
    dialogtext:setString(dialogtextString)


    local dialogsure_bt=self.dialog:getChildByTag(43)
        dialogsure_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
     local dialogback_bt=self.dialog:getChildByTag(42)
        dialogback_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)

    if call then
      self.call=call
    end
    return  self.dialog
end

function FloatingLayer:touch_callback( sender, eventType )
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    local tag=sender:getTag()
    if tag==43 then --确定
            if self.call then
              self.call(self,1)
              -- return
            end
            if tostring(LocalData:Instance():get_user_time()) == "1" then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JIGSAWCOUNT)
            end
            if tostring(LocalData:Instance():get_per()) == "1" then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PERFECT)
            end
            if tostring(LocalData:Instance():get_user_pintu( ))  ==  "1"  then  
              NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.AUTOMATICPUZZLE)
            end
            if tostring(LocalData:Instance():get_user_reg())  ==  "1"  then    --注册成功
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.REG)--注册相关消息
            end
             
             if dialogdetermine==1 then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PASSWOEDCHANGE)
             end  
              if tostring(LocalData:Instance():get_back()) == "1" then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.TFEDBACK)
            end
            self:removeChildByTag(20)

    elseif tag==42 then --返回
            if self.call then
              self.call(self,2)
              -- return
            end
            self:removeChildByTag(20)
             -- if  self.dialog then
             --     self.dialog:removeFromParent()
             -- end
              if tostring(LocalData:Instance():get_back()) == "1" then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.TFEDBACK)
            end
            NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.REG)
         
    end
    
    
    self:setTouchSwallowEnabled(false)--防止吞吃
end

function FloatingLayer:network_box(prompt_text )
      self.networkbox = cc.CSLoader:createNode("PromptNode.csb")
      self:addChild(self.networkbox)
      local back=self.networkbox:getChildByTag(213)
      local _text=self.networkbox:getChildByTag(214)
      _text:setString(prompt_text)
       back:addTouchEventListener(function(sender, eventType  )
                  if eventType == 3 then
                       sender:setScale(1)
                       return
                    end
                    
                 if eventType ~= ccui.TouchEventType.ended then
                        sender:setScale(0.5)
                        return
                 end
                 sender:setScale(1)
                if self.networkbox then
                      self.networkbox:removeFromParent()
                      cc.Director:getInstance():endToLua()   --退出游戏  
                end
       end)

end
function FloatingLayer:fun_Grawpopup( popup_text ,call)
                    self.Grawpopup = cc.CSLoader:createNode("Grawpopup.csb");
                    self:addChild(self.Grawpopup,30,30)
                    local determine=self.Grawpopup:getChildByTag(3141)
                    local _text=self.Grawpopup:getChildByTag(3140)
                    _text:setString(popup_text)
                     determine:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                              if self.call then
                                self.call(self,1)
                                -- return
                              end
                              self:removeChildByTag(30)
                    end)
                  local back=self.Grawpopup:getChildByTag(1229)
                  back:addTouchEventListener(function(sender, eventType  )
                           if eventType ~= ccui.TouchEventType.ended then
                                  return
                           end
                           if self.call then
                              self.call(self,2)
                              -- return
                            end
                          self:removeChildByTag(30)
                  end)

                  if call then
                    self.call=call
                  end
                  return  self.Grawpopup

end
function FloatingLayer:prompt_box(prompt_text ,call)
      self.networkbox = cc.CSLoader:createNode("PromptNode.csb")
      self:addChild(self.networkbox)
      self.networkbox:setTag(111)
      local back=self.networkbox:getChildByTag(213)
      local _text=self.networkbox:getChildByTag(214)
      _text:setString(prompt_text)
       if call then
                    self.call=call
        end
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                 end
                if self.networkbox then
                       self.networkbox:removeFromParent()
                end
                if self.call then
                        self.call(self,1)
                        self:removeChildByTag(111)
                end
            if tostring(LocalData:Instance():get_user_time()) == "1" then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JIGSAWCOUNT)
            end
            if tostring(LocalData:Instance():get_user_pintu( ))  ==  "1"  then  
              NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.AUTOMATICPUZZLE)
            end
            if tostring(LocalData:Instance():get_user_reg())  ==  "1"  then    --注册成功
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.REG)--注册相关消息
            end
              if tostring(LocalData:Instance():get_user_reg())  ==  "3"  then    --注册成功
               NotificationCenter:Instance():PostNotification("zhucechegngong")--注册相关消息
            end
             if  self.dialog  then
                 self.dialog:removeFromParent()
             end
             if dialogdetermine==1 then
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PASSWOEDCHANGE)
             end

       end)

end
--  恭喜
function FloatingLayer:fun_congratulations( p_text ,call)
  print("jkjk")
                    self.congratulations = cc.CSLoader:createNode("congratulations.csb");
                    self:addChild(self.congratulations,40,40)
                    local determine=self.congratulations:getChildByName("GX_CAN")
                    local _text=self.congratulations:getChildByName("GX_ProjectNode"):getChildByName("NM_Text")
                    _text:setString(p_text)
                     determine:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                              if self.call then
                                self.call(self,1)
                                -- return
                              end
                              self:removeChildByTag(40)
                    end)
                  local back=self.congratulations:getChildByName("GX_NO")
                  back:addTouchEventListener(function(sender, eventType  )
                           if eventType ~= ccui.TouchEventType.ended then
                                  return
                           end
                           if self.call then
                              self.call(self,2)
                              -- return
                            end
                          self:removeChildByTag(40)
                  end)

                  if call then
                    self.call=call
                  end
                  return  self.congratulations

end

--  通知
function FloatingLayer:fun_NotificationMessage( po_text ,call)
                    self.NotificationMessage = cc.CSLoader:createNode("NotificationMessage.csb");
                    self:addChild(self.NotificationMessage,50,50)
                    local determine=self.NotificationMessage:getChildByName("TZ_TRUE")
                    local _text=self.NotificationMessage:getChildByName("TZ_NODE"):getChildByName("NM_Text")
                    _text:setString(po_text)
                     determine:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                              if self.call then
                                self.call(self,1)
                                -- return
                              end
                              self:removeChildByTag(50)
                    end)
                  local back=self.NotificationMessage:getChildByName("TZ_FALSE")
                  back:addTouchEventListener(function(sender, eventType  )
                           if eventType ~= ccui.TouchEventType.ended then
                                  return
                           end
                           if self.call then
                              self.call(self,2)
                              -- return
                            end
                          self:removeChildByTag(50)
                  end)

                  if call then
                    self.call=call
                  end
                  return  self.NotificationMessage

end

-- function FloatingLayer:showFloat(text,is_resource,resourceType)
-- 	self.float_number = self.float_number + 1

-- 	self.height = 46
-- 	-- local floating_bg = display.newScale9Sprite("ui/floating.png")
-- 	-- floating_bg:setPosition(320, display.cy+self.height+self.height/2+5)
-- 	-- floating_bg:addTo(self,3)
-- 	-- local string
-- 	-- if is_resource then

-- 	-- else
-- 		string = text
-- 	-- end

-- 	local name = cc.ui.UILabel.new({text = string,
-- 	       size = 28,
-- 	       align = TEXT_ALIGN_CENTER,
-- 	       font = "Arial",
-- 	       color = cc.c4b(255,241,203),
-- 	       })
-- 	name:setAnchorPoint(0.5,0.5)

-- 	name:setPosition(320, display.cy+self.height+self.height/2+5)
-- 	name:addTo(self,100)


-- 	table.insert(self.float_array,name)
-- 	--在这里需要更改

-- 	self:resetPos()

-- 	local sequence1 = transition.sequence({
-- 		cc.MoveBy:create(0.5, cc.p(0, 300)),
-- 	    cc.FadeOut:create(0.5),
-- 	})

-- 	local sequence = transition.sequence({
-- 		cc.DelayTime:create(1),
-- 		sequence1,
-- 		cc.CallFunc:create(function() self:remove() end)

-- 	})
-- 	name:runAction(sequence)
-- end

-- function FloatingLayer:remove()
-- 	self.float_number = self.float_number - 1
-- 	local sprite= self.float_array[1]
-- 	sprite:removeFromParent()
-- 	table.remove(self.float_array,1)
-- end 

-- function FloatingLayer:getFloatNumber()
-- 	return self.float_number
-- end 


-- --我自己的方法
-- function FloatingLayer:resetPos()
-- 	for i= 1,self.float_number do
-- 		local sprite = self.float_array[self.float_number-i+1]
-- 		-- local rect = sprite:getBoundingBox()
-- 		if self.float_number > 1 then
-- 			if sprite:getPositionY() < display.cy + i*self.height +rect.height/2 then
-- 				local i_down_konw = display.cy+i*self.height+100/2
-- 				sprite:setPosition(320,i_down_konw)
-- 			end 
-- 		end 
-- 	end
-- end 

return FloatingLayer
