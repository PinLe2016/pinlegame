--
-- Author: peter
-- Date: 2016-05-12 11:06:05
--
--
-- Author: peter
-- Date: 2016-05-09 10:14:40
--
--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
--
--结束界面   老虎机  
local SurpriseOverScene = class("SurpriseOverScene", function()
            return display.newScene("SurpriseOverScene")
end)
function SurpriseOverScene:ctor(params)--params
        self.tp=params.tp
        self.floating_layer = FloatingLayerEx.new()
        self.floating_layer:addTo(self,1000)
        self.actid=LocalData:Instance():get_actid()
        self:init()
      
end
function SurpriseOverScene:init(  )

	self.Laohuji = cc.CSLoader:createNode("Laohuji.csb")
    	self:addChild(self.Laohuji)

      local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
      self._imagetu=Util:sub_str(list_table[1]["imgurl"], "/",":")
      

    
    	if self.tp==2 then
    		local image_name=self.Laohuji:getChildByTag(161)
    	            image_name:setVisible(false)
	    	local _imagename=self.Laohuji:getChildByTag(336)
	    	_imagename:loadTexture(self.actid["image"])
	 else
	  	local image_name=self.Laohuji:getChildByTag(161)
    	            image_name:setVisible(false)
	    	      local _imagename=self.Laohuji:getChildByTag(336)
         
              local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
                 _imagename:loadTexture(path..self._imagetu)
	    	--image_name:loadTexture(self._imagetu)--(self.actid["image"])
    	end
    	
    	-- local image_pic=display.newScale9Sprite(self.actid["image"], image_name:getPositionX(),image_name:getPositionY(), image_name:getContentSize())
    	-- self.Laohuji:addChild(image_pic)
    	-- -- dump(image_name:getSize())
    	-- -- image_name:setScaleX(image_name:getContentSize().width/575)

    	-- image_name:removeFromParent()
      --测试  初始化
    local _betgolds=self.Laohuji:getChildByTag(99)   --  押注金币
    _betgolds:setString("20")


    	self.began_bt=self.Laohuji:getChildByTag(164)
    	self.began_bt:setVisible(true)
    	self.began_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local show_bt=self.Laohuji:getChildByTag(165)
    	show_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local view_bt=self.Laohuji:getChildByTag(163)
    	view_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local back_bt=self.Laohuji:getChildByTag(160)
    	back_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
      local share_bt=self.Laohuji:getChildByTag(213)-- 分享
      share_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

    	self.end_bt=self.Laohuji:getChildByTag(44)
    	self.end_bt:setVisible(false)
    	self.end_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	self. _table={}
    	for i=1,4 do
    		local score=self.Laohuji:getChildByTag(157)
    		local score1=self.Laohuji:getChildByTag(157):getChildByTag(40-i)--score1
	    	local po1x=score1:getPositionX()
	    	local po1y=score1:getPositionY()
	            local laoHuJi1 = cc.LaoHuJiDonghua:create()--cc.CustomClass:create()
	            local msg = laoHuJi1:helloMsg()
	            release_print("customClass's msg is : " .. msg)
	            laoHuJi1:setDate("CSres/public/publicUI/number0-9", "item_", 10,cc.p(po1x,po1y) );
	            laoHuJi1:setStartSpeed(30);
	            score:addChild(laoHuJi1);
	            self._table[i]=laoHuJi1
    	end
    

end

function SurpriseOverScene:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local activitypoints=LocalData:Instance():get_getactivitypoints()
	local tag=sender:getTag()
	if tag==164 then --开始

         --self.began_bt:setButtonEnabled(false)
           --w:setFocusEnabled(false)
           -- self.began_bt:setColor(cc.c3b(255, 255,   0))
		audio.playMusic(G_SOUND["FALLMONEY"],true)
		Server:Instance():getactivitypoints(self.actid["act_id"])  --老虎机测试
	elseif tag==165 then --分享
		print("分享")
		Util:share()
	elseif tag==163 then --点我有惊喜
		print("点我有惊喜")
	elseif tag==160 then --返回
		--Util:scene_control("MainInterfaceScene")
     cc.Director:getInstance():popScene()
	elseif tag==44 then  --结束
             -- audio.stopMusic(G_SOUND["FALLMONEY"])
             -- audio.playMusic(G_SOUND["PERSONALCHAGE"],true)
             Util:stop_music("FALLMONEY")
             Util:player_music("PERSONALCHAGE",true )
		self:L_end(  )
      elseif tag==213 then  --分享
           Util:share()
           print("fenxiagn")
		
	end
end


function SurpriseOverScene:L_end(  )
            -- 老虎机数据
            local _laohujidata=LocalData:Instance():get_getactivitypoints()
            local userdt = LocalData:Instance():get_userdata()
            userdt["golds"]=_laohujidata["golds"]
            userdt["points"]=_laohujidata["points"]
            LocalData:Instance():set_userdata(userdt) --  保存数据



	local activitypoints=LocalData:Instance():get_getactivitypoints()
	local  tempn = activitypoints["points"]
	for i=1,#self. _table do
		local  stopNum = 0;
		if (tempn > 0)  then
			stopNum = tempn % 10;
			tempn = tempn / 10;
	            end
	(self. _table[i]):stopGo(stopNum);
	end
	self:init_data()
	self.daojishi_bg=self.Laohuji:getChildByTag(102)
	self.daojishi_bg:setGlobalZOrder(999999)
	self.daojishi_text=self.daojishi_bg:getChildByTag(104)
	self.daojishi_bg:setVisible(true)
       local _imagename1=self.daojishi_bg:getChildByTag(158)
       _imagename1:setVisible(false)
       local _imagename2=self.daojishi_bg:getChildByTag(335)
       _imagename2:setVisible(true)

       local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
       _imagename2:loadTexture(path..self._imagetu)

	self._time=10
    	self.L_began=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self.daojishi_text:setString(tostring(self._time))
                                self:countdown()
             end,1.0, false)
end
 function SurpriseOverScene:countdown()
           self._time=self._time-1
           self.daojishi_text:setString(tostring(self._time))
           if self._time==0 then
              self.began_bt:setVisible(true)
	  self.end_bt:setVisible(false)
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.L_began)--停止定时器
              self.daojishi_bg:setVisible(false)
           end
end


--初始化数据
function SurpriseOverScene:init_data(  )
	local activitypoints=LocalData:Instance():get_getactivitypoints()
            local allscore_text=self.Laohuji:getChildByTag(63)--累计积分
            allscore_text:setString(tostring(activitypoints["totalPoints"]))
            local bestscore_text=self.Laohuji:getChildByTag(62)--最佳积分
            bestscore_text:setString(tostring(activitypoints["bestpoints"]))
            local rank_text=self.Laohuji:getChildByTag(64)--排名
            rank_text:setString(tostring(activitypoints["rank"]))
            local _betgolds=self.Laohuji:getChildByTag(99)   --  押注金币
             _betgolds:setString(tostring(activitypoints["betgolds"]))
    --         local function stopAction()
    --             self.began_bt:setVisible(true)
	   -- self.end_bt:setVisible(false)
    --         end
    --          local callfunc = cc.CallFunc:create(stopAction)
    --          rank_text:runAction(cc.Sequence:create(cc.DelayTime:create(2),callfunc  ))

            
end
function SurpriseOverScene:onEnter()
       --audio.playMusic(G_SOUND["PERSONALCHAGE"],true)
       Util:player_music("PERSONALCHAGE",true )
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self,
                       function()
                  local _table=LocalData:Instance():get_getactivitypoints()
	           if _table["remaintimes"]==0 then
                   Server:Instance():prompt("您参与次数已经用完")
                end
                  self.began_bt:setVisible(false)
                  self.end_bt:setVisible(true)
                  for i=1,#self. _table do
                      self. _table[i]:startGo()
                  end
                  dump(self.actid["act_id"])


                      end)
end

function SurpriseOverScene:onExit()
       --audio.stopMusic(G_SOUND["PERSONALCHAGE"])
       Util:stop_music("PERSONALCHAGE")
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE, self)
end
function SurpriseOverScene:pushFloating(text)

   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end

end 
function SurpriseOverScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
return SurpriseOverScene

















