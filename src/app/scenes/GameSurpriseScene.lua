--
-- Author: peter
-- Date: 2017-05-18 16:31:41
--
--  新版惊喜吧 
local GameSurpriseScene = class("GameSurpriseScene", function()
            return display.newScene("GameSurpriseScene")
end)
function GameSurpriseScene:ctor()
      self:fun_init()
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键

end
function GameSurpriseScene:fun_init( ... )
	self.GameSurpriseScene = cc.CSLoader:createNode("GameSurpriseScene.csb");
	self:addChild(self.GameSurpriseScene)

	--  事件初始化
	--  返回
	local btn_Back=self.GameSurpriseScene:getChildByName("btn_Back")
          	btn_Back:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              Util:scene_control("MainInterfaceScene")
            end)
            -- 规则
            local btn_Guide=self.GameSurpriseScene:getChildByName("btn_Guide")
          	btn_Guide:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("规则")
            end)
            --  本期活动
            local btn_Current=self.GameSurpriseScene:getChildByName("btn_Current")
          	btn_Current:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("本期活动")
		self.lvw_Surorise:removeAllItems()
		--  列表数据刷新
		self:fun_list_data(4)
            end)
            --  往期活动
            local btn_Past=self.GameSurpriseScene:getChildByName("btn_Past")
          	btn_Past:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              self.lvw_Surorise:removeAllItems()
		--  列表数据刷新
		self:fun_list_data(5)
	              print("往期活动")
            end)

          	self:fun_Surorise()
end
--初始化列表
function GameSurpriseScene:fun_Surorise( )
	self.lvw_Surorise=self.GameSurpriseScene:getChildByName("ProjectNode_3"):getChildByName("lvw_Surorise")--惊喜吧列表
	self.lvw_Surorise:addScrollViewEventListener((function(sender, eventType  )
	          if eventType  ==6 then
	                     print("下啦刷新")
	                     return
	          end
	end))
	self.lvw_Surorise:setItemModel(self.lvw_Surorise:getItem(0))
	self.lvw_Surorise:removeAllItems()

	--  列表数据刷新
	self:fun_list_data(3)
end
function GameSurpriseScene:fun_list_data( Num )
	local num=Num
	local jioushu=math.floor(tonumber(num)) % 2  == 1 and 1 or 2   --判段奇数 偶数
		local _jioushu=0
		if jioushu==1 then
			 _jioushu=num /  2-0.5
	 	else
	 		_jioushu=num /  2
		end
		self.jac_data_num=_jioushu  +  num %  2
		for i=1,self.jac_data_num do
			self.lvw_Surorise:pushBackDefaultItem()
			local  cell = self.lvw_Surorise:getItem(i-1)
			local  _bg=cell:getChildByName("bg")
			local  _bg_Copy=cell:getChildByName("bg_Copy")
			_bg_Copy:setVisible(false)
			local ig_GiftPhoto=_bg:getChildByName("ig_GiftPhoto")
		          	ig_GiftPhoto:addTouchEventListener(function(sender, eventType  )
			               if eventType ~= ccui.TouchEventType.ended then
			                   return
			              end
			              print("活动编号"  ..  2*i-1)
			              local SurpriseNode_Detail = require("app.layers.SurpriseNode_Detail")  --关于拼乐界面  
				  self:addChild(SurpriseNode_Detail.new(),1,12)
		            end)
			if i*2-1== num  then
				return
			end
			_bg_Copy:setVisible(true)
			local ig_GiftPhoto_Copy=_bg_Copy:getChildByName("ig_GiftPhoto_Copy")
		          	ig_GiftPhoto_Copy:addTouchEventListener(function(sender, eventType  )
			               if eventType ~= ccui.TouchEventType.ended then
			                   return
			              end
			              print("活动编号"  ..  2*i)
			              local SurpriseNode_Detail = require("app.layers.SurpriseNode_Detail")  --关于拼乐界面  
				  self:addChild(SurpriseNode_Detail.new(),1,12)
		            end)
		end
end
function GameSurpriseScene:pushFloating(text)
       self.floating_layer:showFloat(text)  
end 

function GameSurpriseScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function GameSurpriseScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function GameSurpriseScene:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function GameSurpriseScene:onEnter()


	-- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
 --                       function()

 --                      end)--
end

function GameSurpriseScene:onExit()
     
      --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.PERFECT, self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
--android 返回键 响应
function GameSurpriseScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              self:unscheduleUpdate()
              Util:scene_control("MainInterfaceScene")
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end



return GameSurpriseScene