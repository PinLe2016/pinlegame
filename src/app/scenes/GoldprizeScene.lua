
local GoldprizeScene = class("GoldprizeScene", function()
    return display.newScene("GoldprizeScene")
end)
local  jackpotlayer= require("app.layers.JackpotLayer")--


function GoldprizeScene:ctor()

   self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:addTo(self,100000)
   self.sur_pageno=1
   self:init()
               
            
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
                        Server:Instance():getgoldspoollist({pagesize=2,pageno=self.sur_pageno})  --发送消息
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
		self.jac_data_num= #jac_data /  2  +  #jac_data %  2
		-- dump(sup_data)
		local path=cc.FileUtils:getInstance():getWritablePath()

		for i=1,self.jac_data_num do
				self.jackpot_ListView:pushBackDefaultItem()
				local  cell = self.jackpot_ListView:getItem(i-1)
				        cell:setTag(i)

		        local bg1=cell:getChildByTag(63)
		        local bg1_image=bg1:getChildByTag(121)

				bg1_image:loadTexture(path..tostring(Util:sub_str(jac_data[2*i-1]["imageurl"], "/",":")))  --图片
				bg1_image:setTag(2*i-1)

				bg1_image:addTouchEventListener(function(sender, eventType  )
						if eventType ~= ccui.TouchEventType.ended then
								return
						end

						local tag=sender:getTag()

						local jackpotlayer= jackpotlayer.new({id=jac_data[2*i-1]["id"]})

						self:addChild(jackpotlayer)

				end)

		    local end1=bg1:getChildByTag(66) --结束
		    local began1=bg1:getChildByTag(67) --未结束
		    local title1=bg1:getChildByTag(70)

		    title1:setString(tostring(jac_data[2*i-1]["name"]))
		    local goldsamount1=bg1:getChildByTag(71)--总金币
		    goldsamount1:setString(tostring(jac_data[2*i-1]["goldsamount"]))

		    local goldsremain1=bg1:getChildByTag(72) --剩余金币
		    goldsremain1:setString(tostring(jac_data[2*i-1]["goldsremain"]))

		    if i*2-1== #jac_data  then
		    	 return
		    end

			local bg2=cell:getChildByTag(64)
			bg2:setVisible(true)

			local bg2_img=bg2:getChildByTag(91)
			bg2_img:loadTexture(tostring(path..Util:sub_str(jac_data[2*i]["imageurl"], "/",":")))  --图片
			bg2_img:setTag(2*i)
			bg2_img:addTouchEventListener(function(sender, eventType  )

					if eventType ~= ccui.TouchEventType.ended then
						return
					end

					local tag=sender:getTag()
					local jackpotlayer= jackpotlayer.new({id=jac_data[2*i]["id"]})

				    self:addChild(jackpotlayer)
			end)

		    local end1=bg2:getChildByTag(89) --结束
		    local began1=bg2:getChildByTag(90) --未结束
		    local title1=bg2:getChildByTag(60)

		    title1:setString(tostring(jac_data[2*i]["name"]))
		    local goldsamount1=bg2:getChildByTag(61)--总金币

		    goldsamount1:setString(tostring(jac_data[2*i]["goldsamount"]))
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
		print("说明")
	end
end

function GoldprizeScene:onEnter()
  Server:Instance():getgoldspoollist({pagesize=2,pageno=self.sur_pageno})  --发送消息

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















return GoldprizeScene