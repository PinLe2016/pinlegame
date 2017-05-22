
local GoldprizeScene = class("GoldprizeScene", function()
    return display.newScene("GoldprizeScene")
end)

-- local GameScene = require("app.scenes.GameScene")
function GoldprizeScene:ctor()

   self.floating_layer = require("app.layers.FloatingLayer").new()
   self.floating_layer:addTo(self,100000)
   self.sur_pageno=1
   self:init()
   self._dtid=""
   LocalData:Instance():set_getgoldspoollist(nil)
               
   self:listener_home() --注册安卓返回键    
   self.image={}    
   self.choose=0 --1p拼图   2   打地鼠
   --LocalData:Instance():set_sign(1)
end
--  金币动画
function GoldprizeScene:gold_act(  )
	local userdt = LocalData:Instance():get_userdata()
	self. _table={}

    	for i=1,9 do
    		local score=self.GoldprizeScene
    		local score1=self.GoldprizeScene:getChildByTag(1158)
    		score1:setVisible(false)
	    	local po1x=score1:getPositionX()
	    	local po1y=score1:getPositionY()
	            local laoHuJi1 = cc.LaoHuJiDonghua:create()--cc.CustomClass:create()
	            local msg = laoHuJi1:helloMsg()
	            release_print("customClass's msg is : " .. msg)
	            laoHuJi1:setDate("resources/jiangchijiemian/jiangchijinbiPlist", "resources/jiangchijiemian/JCJM_SZ_", 10,cc.p(po1x+(i-1)*34.3,po1y) );
	            laoHuJi1:setStartSpeed(30);
	            score:addChild(laoHuJi1);
	            self._table[i]=laoHuJi1
    	end
    	for i=1,#self. _table do
                      self. _table[i]:startGo()
            end
            local  tempn =   tonumber(userdt["golds"])
	for i=1,#self. _table do
		local  stopNum = 0;
		if (tempn > 0)  then
			stopNum = tempn % 10;
			tempn = tempn / 10;
	            end
	(self. _table[#self. _table-(i-1)]):stopGo(stopNum);
	end
end

function GoldprizeScene:init(  )

	self.GoldprizeScene = cc.CSLoader:createNode("Goldprize.csb")
      	self:addChild(self.GoldprizeScene)
      	self.roleAction = cc.CSLoader:createTimeline("Goldprize.csb")
            self.GoldprizeScene:runAction(self.roleAction)
            self.roleAction:setTimeSpeed(0.3)
            self.roleAction:gotoFrameAndPlay(0,122, true)
      	
      	self.act_loading=self.GoldprizeScene:getChildByTag(1134)  --  加载标记

      	local back=self.GoldprizeScene:getChildByTag(57)
    	back:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	
    	self.jackpot_ListView=self.GoldprizeScene:getChildByTag(127)--奖池列表
    	self.jackpot_ListView:addScrollViewEventListener((function(sender, eventType  )
                      if eventType  ==6 then
                        if self.sur_pageno==1 then
                        	self.jackpot_ListView:jumpToPercentVertical(100)   
                        else
                        	self.jackpot_ListView:jumpToPercentVertical(100)
                        end
                        
                        self.act_loading:setVisible(true)
                        
                         local function stopAction()
                         	
                               self.sur_pageno=self.sur_pageno+1
                               Server:Instance():getgoldspoollist({pagesize=6,pageno=self.sur_pageno,adownerid = ""})  --发送消息
                        end
                        local callfunc = cc.CallFunc:create(stopAction)
                        self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),callfunc  ))

                                 return
                      end
	end))
	self.jackpot_ListView:setItemModel(self.jackpot_ListView:getItem(0))
	for i=2,2 do
		self.jackpot_ListView:pushBackDefaultItem()
		local  cell = self.jackpot_ListView:getItem(i-1)
	end
	-- self.jackpot_ListView:removeAllItems()
	-- self:data_init()
	self:gold_act()

end


function GoldprizeScene:data_init(  )
		-- self.jackpot_ListView:removeAllItems()
		self.act_loading:setVisible(false)
		self.jackpot_ListView:jumpToPercentVertical(0)   
		self.image={}
		local  list_table=LocalData:Instance():get_getgoldspoollist()

		if list_table then
			self.jackpot_ListView:removeAllItems()
		end

		
		local  jac_data=list_table["goldspools"]
		local jioushu=math.floor(tonumber(#jac_data)) % 2  == 1 and 1 or 2   --判段奇数 偶数
		local _jioushu=0
		if jioushu==1 then
			 _jioushu=#jac_data /  2-0.5
	 	else
	 		_jioushu=#jac_data /  2
		end
		self.jac_data_num=_jioushu  +  #jac_data %  2
		local path=cc.FileUtils:getInstance():getWritablePath()

		for i=1,self.jac_data_num do
				self.jackpot_ListView:pushBackDefaultItem()
				local  cell = self.jackpot_ListView:getItem(i-1)
				        cell:setTag(i)

		        local bg1=cell:getChildByTag(63)
		        local bg1_image=bg1:getChildByTag(121)
		        local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
				--bg1_image:loadTexture(path..tostring(Util:sub_str(jac_data[2*i-1]["imageurl"], "/",":")))  --图片
				local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(jac_data[2*i-1]["imageurl"], "/",":")))
			            if not  file then
			              table.insert(self.image,{obj =  bg1_image ,name=path..tostring(Util:sub_str(jac_data[2*i-1]["imageurl"], "/",":"))})
			             else
			                bg1_image:loadTexture(path..tostring(Util:sub_str(jac_data[2*i-1]["imageurl"], "/",":")))
			            end

				bg1_image:setTag(2*i-1)
				if tonumber(jac_data[2*i-1]["playtimes"]) >0 then
					bg1:getChildByTag(4809):setVisible(true)
				end
				bg1_image:addTouchEventListener(function(sender, eventType  )
						if eventType ~= ccui.TouchEventType.ended then
								return
						end
						self:fun_selectbox( 2*i-1 )


						local tag=sender:getTag()

				end)

		  
		  
		    local goldsamount1=bg1:getChildByTag(71)--总金币
		    goldsamount1:setString(tostring(jac_data[2*i-1]["goldsamount"]))  --goldsamount

		   
		    bg2=cell:getChildByTag(64)
		    bg2:setVisible(false)

		    if i*2-1== #jac_data  then
		    	if tonumber(self.sur_pageno)~=0 then
		            dump(self.sur_pageno)
		             self.jackpot_ListView:jumpToPercentVertical(110)
		           else
		             self.jackpot_ListView:jumpToPercentVertical(0)
		          end
		    	 return
		    end

			--local bg2=cell:getChildByTag(64)
			bg2:setVisible(true)

			local bg2_img=bg2:getChildByTag(91)
			local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
			--bg2_img:loadTexture(path..tostring(Util:sub_str(jac_data[2*i]["imageurl"], "/",":")))  --图片
			local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(jac_data[2*i]["imageurl"], "/",":")))
		            if not  file then
		              table.insert(self.image,{obj =  bg2_img ,name=path..tostring(Util:sub_str(jac_data[2*i]["imageurl"], "/",":"))})
		             else
		               bg2_img:loadTexture(path..tostring(Util:sub_str(jac_data[2*i]["imageurl"], "/",":")))  --图片
		            end
		            if tonumber(jac_data[2*i]["playtimes"]) >0 then
					bg2:getChildByTag(4810):setVisible(true)
			end
			bg2_img:setTag(2*i)
			bg2_img:addTouchEventListener(function(sender, eventType  )

					if eventType ~= ccui.TouchEventType.ended then
						return
					end
					self:fun_selectbox( 2*i )
					-- local tag=sender:getTag()
					-- Server:Instance():getgoldspoolbyid(jac_data[2*i]["id"])   --主要是判断是否玩完两次
					-- self._dtid=jac_data[2*i]["id"]  --为了后面拼图id  准备
					-- self.adownerid  =   jac_data[2*i]["adownerid"]
					-- self.goldspoolcount  =  jac_data[2*i]["goldspoolcount"]
					-- self.image_name  =  path..tostring(Util:sub_str(jac_data[2*i]["imageurl"], "/",":"))



			end)

		   
		  
		    local goldsamount1=bg2:getChildByTag(61)--总金币

		    goldsamount1:setString(tostring(jac_data[2*i]["goldsamount"]))--goldsamount
		  
		end

		if tonumber(self.sur_pageno)~=0 then
	             self.jackpot_ListView:jumpToPercentVertical(120)
	           else
	             self.jackpot_ListView:jumpToPercentVertical(0)
	          end

	          local function stopAction()
		  if #self.image~=0 then

		  	-- dump(self.image)
			for i=1,#self.image do
				local file=cc.FileUtils:getInstance():isFileExist(self.image[i].name)
				if file and self.image[i]["obj"] then
					-- dump(self.image[i])
					print("----",#self.image,i,self.image[1].name)
					self.image[i]["obj"]:loadTexture(self.image[i].name)
					self.image[i]["obj"]=nil
				end
			end
			
		  end
	          end
	          local callfunc = cc.CallFunc:create(stopAction)
	         self:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))


end
function GoldprizeScene:fun_selectbox( _tag )
	local  list_table=LocalData:Instance():get_getgoldspoollist()
	local  jac_data=list_table["goldspools"]
	local  _playtimes=jac_data[_tag]["playtimes"] 
	if tonumber(_playtimes)  >  0  then
		self.image_name  =  tostring(Util:sub_str(jac_data[_tag]["imageurl"], "/",":"))
		Server:Instance():getgoldspoolreward(jac_data[_tag]["id"])
		return
	end

	      

		       
	self.Selectbox = cc.CSLoader:createNode("Selectbox.csb")
            self:addChild(self.Selectbox)
            self.Selectbox:setTag(999)

             local back=self.Selectbox:getChildByTag(145)   --返回
       	 back:addTouchEventListener(function(sender, eventType  )
	                 if eventType ~= ccui.TouchEventType.ended then
	                        return
                              end
                              if self.Selectbox then
                              	self.Selectbox:removeFromParent()
                              	Util:all_layer_backMusic()
                              end
            end)

       	 local pintu=self.Selectbox:getChildByTag(142)   --拼图
       	 pintu:addTouchEventListener(function(sender, eventType  )
       	 	    
	                 if eventType ~= ccui.TouchEventType.ended then
	                        return
	                  end
	                  
	                  self.choose=1
	                  local path=cc.FileUtils:getInstance():getWritablePath()
	            
		       local  list_table=LocalData:Instance():get_getgoldspoollist()
		       local  jac_data=list_table["goldspools"]
	                   Server:Instance():getgoldspoolbyid(jac_data[_tag]["id"])   --主要是判断是否玩完两次
		       self._dtid=jac_data[_tag]["id"]    --为了后面拼图id  准备
		       self.adownerid  =   jac_data[_tag]["adownerid"]
		       self.goldspoolcount  =  jac_data[_tag]["goldspoolcount"]
		       self.image_name  =  tostring(Util:sub_str(jac_data[_tag]["imageurl"], "/",":"))
            end)


       	 local dadishu=self.Selectbox:getChildByTag(143)   --打地鼠
       	 dadishu:addTouchEventListener(function(sender, eventType  )
       	 	     

	                 if eventType ~= ccui.TouchEventType.ended then
	                        return
                              end


                              
                              local path=cc.FileUtils:getInstance():getWritablePath()
                              self.choose=2
                               local  list_table=LocalData:Instance():get_getgoldspoollist()
		       local  jac_data=list_table["goldspools"]

                               Server:Instance():getgoldspoolbyid(jac_data[_tag]["id"])   --主要是判断是否玩完两次
		       self._dtid=jac_data[_tag]["id"]    --为了后面拼图id  准备
		       self.adownerid  =   jac_data[_tag]["adownerid"]
		       self.goldspoolcount  =  jac_data[_tag]["goldspoolcount"]
		       self.image_name  =  tostring(Util:sub_str(jac_data[_tag]["imageurl"], "/",":"))
            end)

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
	if eventType == 3 then
                       sender:setScale(1)
                       return
                    end

                    if eventType ~= ccui.TouchEventType.ended then
                       sender:setScale(1.2)
                       return
                    end

                    

                    sender:setScale(1)
	local tag=sender:getTag()
	if tag==57 then --返回
		if tonumber(LocalData:Instance():get_sign()) ~=  2 then
                            Util:scene_control("MainInterfaceScene")
        else
        	
            cc.Director:getInstance():popToRootScene()
            Server:Instance():gettasklist()
    --      local taskLayer = require("app.layers.taskLayer")  --关于任务界面
				-- self:addChild(taskLayer.new())
         end
         Util:all_layer_backMusic()
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
	 --Util:player_music_hit("GAMEBG",true )
	 cc.SpriteFrameCache:getInstance():addSpriteFrames("resources/jiangchijiemian/jiangchijinbiPlist.plist")
  Server:Instance():getgoldspoollist({pagesize=6,pageno=self.sur_pageno,adownerid =""})  --发送消息

  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_POST, self,
                       function()
                       self:imgurl_download()
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_PIC_POST, self,
                       function()
                       self:data_init()  --初始化

                       
                       
                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST, self,
                       function()  
                         local getgoldspoolbyid  = LocalData:Instance():get_getgoldspoolbyid()--获得玩了几次数据
                         if tonumber(getgoldspoolbyid["coolingtime"]) == -1  or   tonumber(getgoldspoolbyid["getcardamount"]) == 0  then   --因为getcardamount这个后台不准，所以只能多加一个coolingtime来保险的判断是否玩过两次

                         	--LocalData:Instance():set_user_pintu("1")  --主要是要确定点击后  要自动拼图
                                    -- self.floating_layer:showFloat("今日该广告机会已经用完啦",function (sender, eventType)        
                                    --                             if eventType==1    then

                                                                    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.AUTOMATICPUZZLE)
                                                --                 end                
                                                -- end)    --  然并卵的提示语
                                    
                         else
                         	
                         	--self:removeChildByTag(999, true)
                         	local  _Issecond=0

                         	if tonumber(getgoldspoolbyid["getcardamount"]) ~=2 then

                         		_Issecond=1
                         	end
                         	  LocalData:Instance():set_user_img(self.image_name)
                         	 -- local scene=GameScene.new({adid= self._dtid,type="audition",img=self.image_name,image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount})--拼图
               	           --   cc.Director:getInstance():pushScene(scene)
               	             Util:scene_controlid("GameScene",{adid= self._dtid,type="audition",img=self.image_name,image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose,Issecond=_Issecond})
		             LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
                         end
		
                      end)
  --点击弹出框点击确定自动进入拼图界面  够任性吧  
  NotificationCenter:Instance():AddObserver("GETGOLDSPOOLREWARD", self,
                       function()
			 LocalData:Instance():set_user_img(self.image_name)
                        
               -- 	             Util:scene_controlid("GameScene",{adid= self._dtid,type="audition",img=self.image_name,image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose,Issecond=1})
		             -- LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
		              
		                local jackpotEnd= require("app.layers.jackpotEnd").new({_dtid=self._dtid,image_name=self.image_name,choose=self.choose})
			    cc.Director:getInstance():replaceScene(jackpotEnd) 
		           
                      end)

end

function GoldprizeScene:onExit()
	  --audio.stopMusic(G_SOUND["GAMEBG"])
	  --Util:stop_music("GAMEBG")
	   cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("resources/jiangchijiemian/jiangchijinbiPlist.plist")
	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_POST, self)
	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_PIC_POST, self)
	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST, self)
	  NotificationCenter:Instance():RemoveObserver("GETGOLDSPOOLREWARD", self)

  	  cc.Director:getInstance():getTextureCache():removeAllTextures() 

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
function GoldprizeScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
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