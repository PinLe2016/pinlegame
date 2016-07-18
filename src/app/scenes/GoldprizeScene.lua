
local GoldprizeScene = class("GoldprizeScene", function()
    return display.newScene("GoldprizeScene")
end)
local  jackpotlayer= require("app.layers.JackpotLayer")--


function GoldprizeScene:ctor()

   self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:addTo(self,100000)
   self.sur_pageno=1
   self:init()
               
   self:listener_home() --注册安卓返回键         
end


function GoldprizeScene:init(  )

	self.GoldprizeScene = cc.CSLoader:createNode("Goldprize.csb")
      	self:addChild(self.GoldprizeScene)
      	 
      	local back=self.GoldprizeScene:getChildByTag(57)
    	back:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local instructions_bt=self.GoldprizeScene:getChildByTag(58)
    	instructions_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	self.jackpot_ListView=self.GoldprizeScene:getChildByTag(127)--奖池列表
    	self.jackpot_ListView:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        self.sur_pageno=self.sur_pageno+1
                        Server:Instance():getgoldspoollist({pagesize=6,pageno=self.sur_pageno,adownerid = ""})  --发送消息
                                 return
                      end
	end))
	self.jackpot_ListView:setItemModel(self.jackpot_ListView:getItem(0))
	self.jackpot_ListView:removeAllItems()
	-- self:data_init()

end


function GoldprizeScene:data_init(  )
		self.jackpot_ListView:removeAllItems()

		local  list_table=LocalData:Instance():get_getgoldspoollist()
		local  jac_data=list_table["goldspools"]
		local jioushu=math.floor(tonumber(#jac_data)) % 2  == 1 and 1 or 2   --判段奇数 偶数
		local _jioushu=0
		if jioushu==1 then
			 _jioushu=#jac_data /  2-0.5
	 	else
	 		_jioushu=#jac_data /  2
		end
		print("sdsfdsfdsfds  ","  ",_jioushu,"  ",#jac_data %  2)
		self.jac_data_num=_jioushu  +  #jac_data %  2
		local path=cc.FileUtils:getInstance():getWritablePath()

		for i=1,self.jac_data_num do
				self.jackpot_ListView:pushBackDefaultItem()
				local  cell = self.jackpot_ListView:getItem(i-1)
				        cell:setTag(i)

		        local bg1=cell:getChildByTag(63)
		        local bg1_image=bg1:getChildByTag(121)
		        local bg1_jibiao=bg1:getChildByTag(986)
		        local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
				bg1_image:loadTexture(path..tostring(Util:sub_str(jac_data[2*i-1]["imageurl"], "/",":")))  --图片
				bg1_image:setTag(2*i-1)
				bg1_jibiao:setString(tostring(jac_data[2*i-1]["goldspoolcount"]))
				bg1_image:addTouchEventListener(function(sender, eventType  )
						if eventType ~= ccui.TouchEventType.ended then
								return
						end

						local tag=sender:getTag()

						local jackpotlayer= jackpotlayer.new({id=jac_data[2*i-1]["id"],  adownerid= jac_data[2*i-1]["adownerid"],goldspoolcount=  jac_data[2*i]["goldspoolcount"] })

						self:addChild(jackpotlayer)

				end)

		    local end1=bg1:getChildByTag(66) --结束
		    local began1=bg1:getChildByTag(67) --未结束
		    local title1=bg1:getChildByTag(70)

		    title1:setString(tostring(jac_data[2*i-1]["name"]))
		    local goldsamount1=bg1:getChildByTag(71)--总金币
		    goldsamount1:setString(tostring(jac_data[2*i-1]["goldsremain"]))  --goldsamount

		    local goldsremain1=bg1:getChildByTag(72) --剩余金币
		    goldsremain1:setString(tostring(jac_data[2*i-1]["goldsremain"]))

		    bg2=cell:getChildByTag(64)
		    bg2:setVisible(false)

		    if i*2-1== #jac_data  then
		    	 return
		    end

			--local bg2=cell:getChildByTag(64)
			bg2:setVisible(true)

			local bg2_img=bg2:getChildByTag(91)
			local bg2_jiaobiao=bg2:getChildByTag(985)
			local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
			bg2_img:loadTexture(path..tostring(Util:sub_str(jac_data[2*i]["imageurl"], "/",":")))  --图片
			bg2_img:setTag(2*i)
			bg2_jiaobiao:setString(tostring(jac_data[2*i]["goldspoolcount"]))
			bg2_img:addTouchEventListener(function(sender, eventType  )

					if eventType ~= ccui.TouchEventType.ended then
						return
					end

					local tag=sender:getTag()

					local jackpotlayer= jackpotlayer.new({id=jac_data[2*i]["id"],  adownerid= jac_data[2*i]["adownerid"] })

				    self:addChild(jackpotlayer)
			end)

		    local end1=bg2:getChildByTag(89) --结束
		    local began1=bg2:getChildByTag(90) --未结束
		    local title1=bg2:getChildByTag(60)

		    title1:setString(tostring(jac_data[2*i]["name"]))
		    local goldsamount1=bg2:getChildByTag(61)--总金币

		    goldsamount1:setString(tostring(jac_data[2*i]["goldsremain"]))--goldsamount
		    local goldsremain1=bg2:getChildByTag(62) --剩余金币

		    goldsremain1:setString(tostring(jac_data[2*i]["goldsremain"]))
		end
end

--下载图片
function GoldprizeScene:imgurl_download(  )
          local  list_table=LocalData:Instance():get_getgoldspoollist()
          local  jac_data=list_table["goldspools"]
          for i=1,#jac_data do
	          	local _table={}
	            _table["imageurl"]=jac_data[i]["imageurl"]
         	            _table["max_pic_idx"]=#jac_data
         	            _table["curr_pic_idx"]=i
                       Server:Instance():jackpot_pic(jac_data[i]["imageurl"],_table) --下载图片
          end
         

end
function GoldprizeScene:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==57 then --返回
		 Util:scene_control("MainInterfaceScene")
	elseif tag==58 then --说明
		 self:fun_prizepoolules()
	elseif tag==1044 then
		self.Prizepoolules:removeFromParent()

	end
end
function GoldprizeScene:fun_prizepoolules()
	self.Prizepoolules = cc.CSLoader:createNode("Prizepoolules.csb")  --邀请好友排行榜
             self:addChild(self.Prizepoolules)
             local back=self.Prizepoolules:getChildByTag(1044)
	 back:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
end
function GoldprizeScene:onEnter()
	--audio.playMusic(G_SOUND["GAMEBG"],true)
	Util:player_music("GAMEBG",true )
  Server:Instance():getgoldspoollist({pagesize=6,pageno=self.sur_pageno,adownerid =""})  --发送消息

  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_POST, self,
                       function()
                       self:imgurl_download()
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_PIC_POST, self,
                       function()
                       self:data_init()  --初始化
                      end)
  

end

function GoldprizeScene:onExit()
	  --audio.stopMusic(G_SOUND["GAMEBG"])
	  Util:stop_music("GAMEBG")
	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_POST, self)
	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_PIC_POST, self)
  
end


function GoldprizeScene:pushFloating(text)
	if is_resource then
		self.floating_layer:showFloat(text)  
		
	else
		if self.barrier_bg then 
			self.barrier_bg:setVisible(false)
		end
		self.floating_layer:showFloat(text)
	end
end 

function GoldprizeScene:push_buffer(is_buffer)

       self.floating_layer:show_http(is_buffer) 
       
end 



--android 返回键 响应
function GoldprizeScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              Util:scene_control("MainInterfaceScene")
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end











return GoldprizeScene