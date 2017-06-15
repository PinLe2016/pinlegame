
--  新版大转盘
local LuckyDraw = class("LuckyDraw", function()
            return display.newScene("LuckyDraw")
end)

------------start---------------------
--手动修改参数，测试抽奖流程
local m_touchCount = 1 --点击后直接开始抽奖，=2表示先点击转动转盘，再点击一次开始抽奖
local ROTATE_TIME = 0.1 --旋转Action的时间
local ROTATE_TIME2 = 1.0 --转盘回滚的时间
local ROTATE_SPEED = 500 --旋转速度，每次旋50度  ＊
local ROTATE_GROUP = 80 --旋转圈数，旋转8圈后慢慢停下来  ＊
------------end------------------------
local m_imgZhuanpan = nil --转盘图片

--旋转逻辑的相关属性参数
local m_awardNum = 1 --奖品总数  分为的区间
local m_bStartAward = false --是否开始抽奖
local m_nSpeed = 0 --旋转速度  12
local m_nGroup = 0 --旋转的圈数  12

local setstartAngle=0  --开始角度
local startAngle = setstartAngle 
local acceleration = 0 --加速度

local endAngle = 0
local m_bModify = false -- 是否需要调整保证在中间位置

local m_bRotateEnable = false --是否旋转中
local m_bRotateOver = false --抽奖是否结束
local m_bAssign = false --当前是否需要指定抽哪种奖品
local m_nAwardID = 0 --指定当前抽的奖品ID  
local m_info_data_1={"1元话费","110经验","5元话费","1充电宝","366金币","10元话费","50经验","66金币","20经验","166金币"}
local m_info_data_2={"30元话费","200经验","5元话费","AV眼睛","5888金币","10积分","红米","1888金币","500经验","2888金币"}
local m_info_data_3={"20元话费","200经验","5元话费","1音响","999金币","10元话费","普通种子","333金币","100经验","666金币"}
function LuckyDraw:ctor()
      self:fun_init()
      self:fun_constructor()
end
function LuckyDraw:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
      self.m_info={ }
      self.m_info.data={ }
      self:init()
      self:show()
      self:fun_radio()
end

function LuckyDraw:fun_LuckyDraw_visble( ... )
	self.LuckyDraw_zbg1:setVisible(false)
	self.LuckyDraw_zbg2:setVisible(false)
	self.LuckyDraw_zbg3:setVisible(false)
	self.m_info={ }
            self.m_info.data={ }
end
function LuckyDraw:fun_LuckyDraw_touch( istouch )
	self.LuckyDraw_Rotary_bt1:setTouchEnabled(istouch)
	self.LuckyDraw_Rotary_bt2:setTouchEnabled(istouch)
	self.LuckyDraw_Rotary_bt3:setTouchEnabled(istouch)
end
function LuckyDraw:fun_init( ... )
	self.LuckyDraw = cc.CSLoader:createNode("LuckyDraw.csb");
	self:addChild(self.LuckyDraw)
	self.LuckyDraw_bg=self.LuckyDraw:getChildByName("LuckyDraw_bg")
	self.LuckyDraw_node=self.LuckyDraw:getChildByName("LuckyDraw_node")
	self.LuckyDraw_zbg1=self.LuckyDraw_node:getChildByName("LuckyDraw_zbg1")
	self.LuckyDraw_zbg2=self.LuckyDraw_node:getChildByName("LuckyDraw_zbg2")
	self.LuckyDraw_zbg3=self.LuckyDraw_node:getChildByName("LuckyDraw_zbg3")
	self.LuckyDraw_Rotary1=self.LuckyDraw_zbg1:getChildByName("LuckyDraw_Rotary1")
	self.LuckyDraw_Rotary2=self.LuckyDraw_zbg2:getChildByName("LuckyDraw_Rotary2")
	self.LuckyDraw_Rotary3=self.LuckyDraw_zbg3:getChildByName("LuckyDraw_Rotary3")
	
	--  事件初始化
	--  返回
	local LuckyDraw_back=self.LuckyDraw_bg:getChildByName("LuckyDraw_back")
          	LuckyDraw_back:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	              Util:scene_control("MainInterfaceScene")
            end)
            --  200
            self.LuckyDraw_Rotary_bt1=self.LuckyDraw_node:getChildByName("LuckyDraw_Rotary_bt1")
            self.LuckyDraw_Rotary_bt1:setBright(false)
     	self.curr_bright=self.LuckyDraw_Rotary_bt1
          	self.LuckyDraw_Rotary_bt1:addTouchEventListener(function(sender, eventType  )
	               self:list_btCallback(sender, eventType)
            end)
            --  500
            self.LuckyDraw_Rotary_bt2=self.LuckyDraw_node:getChildByName("LuckyDraw_Rotary_bt2")
          	self.LuckyDraw_Rotary_bt2:addTouchEventListener(function(sender, eventType  )
	              self:list_btCallback(sender, eventType)     
            end)
            --  2000
            self.LuckyDraw_Rotary_bt3=self.LuckyDraw_node:getChildByName("LuckyDraw_Rotary_bt3")
          	self.LuckyDraw_Rotary_bt3:addTouchEventListener(function(sender, eventType  )
	              self:list_btCallback(sender, eventType)     
            end)
            self:fun_draw_go()

end
function LuckyDraw:fun_draw_go( ... )
	local go_bt=self.LuckyDraw_node:getChildByName("go_bt")
          	go_bt:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)

	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	              print("go")
	              self:fun_LuckyDraw_touch(false)
	              self:maskTouch()  --  第一种
            end)
end
  function LuckyDraw:list_btCallback( sender, eventType )
              
              local tag=sender:getName()
              if self.curr_bright:getName()==tag then
                  return
              end
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)

              self.curr_bright:setBright(true)
              sender:setBright(false)
               if tag=="LuckyDraw_Rotary_bt1" then  
		print("200")
		self:fun_LuckyDraw_visble()
		self:initdata(m_info_data_1)
		m_imgZhuanpan = self.LuckyDraw_Rotary1
		self.LuckyDraw_zbg1:setVisible(true)
               elseif tag=="LuckyDraw_Rotary_bt2" then
		print("500")
		self:fun_LuckyDraw_visble()
		self:initdata(m_info_data_2)
		m_imgZhuanpan = self.LuckyDraw_Rotary2
		self.LuckyDraw_zbg2:setVisible(true)
	   elseif tag=="LuckyDraw_Rotary_bt3" then
		print("2000")
		self:fun_LuckyDraw_visble()
		self:initdata(m_info_data_3)
		m_imgZhuanpan = self.LuckyDraw_Rotary3
		self.LuckyDraw_zbg3:setVisible(true)
	   end

              self.curr_bright=sender
end
function LuckyDraw:init()
	--转盘图片
	m_imgZhuanpan = self.LuckyDraw_Rotary1
	startAngle = setstartAngle
	--加速度
	acceleration = 1
end

function LuckyDraw:show(_str)
	self:initdata(m_info_data_1)
end

function LuckyDraw:initdata(_type)

--  文档上面数据
	local _tp=_type
	for i=1,#_tp do
		table.insert(self.m_info.data,{id =i,name = _tp[i]})
	end
	m_awardNum = #self.m_info.data
	
end

function LuckyDraw:refView()
	
	self:setRotateEnable(false)
	self:resetRotate()
	
end
--  开始按钮操作
function LuckyDraw:maskTouch()
	m_nAwardID = math.random(1,m_awardNum)  --＊＊＊
	print("抽奖设置id",m_nAwardID)   --  使我们设置的参数
	self:awardStart()
end

--转盘开始转动
function LuckyDraw:awardStart()
	if m_bRotateEnable then
		if m_touchCount == 2 then
			print("start award 开始抽奖")
			if not m_bStartAward then
				m_bStartAward = true
				m_bAssign = true
			end
		end
	else
		self:setRotateEnable(true)
		self:resetRotate()

		if m_touchCount == 2 then
			print("start rotate 启动转盘，再次点击开始抽奖")
			self:begin(ROTATE_SPEED,ROTATE_GROUP,false)
		else
			print("start rotate 启动转盘，开始抽奖")
			self:begin(ROTATE_SPEED,ROTATE_GROUP,true)
			self:setAwards(m_nAwardID)--设置指定中奖项ID
		end
		self:doRotateAction(m_imgZhuanpan,handler(self,self.rotateOver),ROTATE_TIME,m_nSpeed)
	end
end
--转盘停止
function LuckyDraw:awardEnd()
	self:fun_LuckyDraw_touch(true)
	dump("抽奖成功,抽到"..self.m_info.data[m_nAwardID].name)
end
function LuckyDraw:doRotateAction(node,callback,time,speed)
  --cclog("doRotateAction")
  local sequence = nil
  local act1 = cc.RotateBy:create(time,speed)
  local callfunc = cc.CallFunc:create(callback)
  sequence = cc.Sequence:create(act1, callfunc)
  node:runAction(sequence)
end
function LuckyDraw:rotateOver()
	local rotate = m_imgZhuanpan:getRotation()
	if m_bRotateEnable then
		startAngle = startAngle + m_nSpeed
		if m_bStartAward then
			if m_bAssign then
				m_bAssign = false
				self:setAwards(m_nAwardID)
				m_imgZhuanpan:stopAllActions()
				m_imgZhuanpan:setRotation(0)
			else
				m_nSpeed = m_nSpeed - acceleration				
			end
		end
		--速度等于0则停下来
		--dump(m_nSpeed,"速度等于0则停下来")
		if m_nSpeed <= 0 then
			self:proRotateStop(startAngle)
			if m_bModify then
				dump("校准开始")
				m_bStartAward = false
				startAngle = startAngle + endAngle
				self:doRotateAction(m_imgZhuanpan,handler(self,self.rotateOver),ROTATE_TIME2,endAngle)
			else
				dump("校准结束")
				self:setRotateEnable(false)				
				m_imgZhuanpan:stopAllActions()
				local delaytime=cc.DelayTime:create(1)
				local callfunc = cc.CallFunc:create(handler(self,self.awardEnd))
				local act=cc.Sequence:create(delaytime,callfunc)
				m_imgZhuanpan:runAction(act)				
			end
			
		else
			self:doRotateAction(m_imgZhuanpan,handler(self,self.rotateOver),ROTATE_TIME,m_nSpeed)		
		end
	end
end
function LuckyDraw:proRotateStop(startAngle)
	local testFloat = startAngle + 90
	testFloat = testFloat % 360
	for i,v in ipairs(self.m_info.data) do
		--中奖角度范围
		local tmp = i - 1
		local angleFrom = 90 + 270 - (tmp + 1) * (360 / m_awardNum)
		local angleTo = 90 + 270 - tmp * (360 / m_awardNum)
		--print("i = %d,from = %d,to = %d",i,angleFrom,angleTo)
		if testFloat > angleFrom and testFloat <= angleTo then
			local midAngle = angleFrom+(360 / m_awardNum)/2
			endAngle = midAngle - testFloat
			if math.abs(endAngle) > 2 then
				m_bModify = true
			else
				m_bModify = false
			end
			break
		end
	end
end
function LuckyDraw:calcBeginSpeed(awardIndex)
	--每项角度区域
	dump(awardIndex,"calcBeginSpeed awardIndex")
	local eachAngle = 360 / m_awardNum
	--中奖角度范围
	local angleFrom = 360 + 270 - (awardIndex + 1) * eachAngle
	local angleTo = 360 + 270 - awardIndex * eachAngle
	
	local sFrom = m_nGroup * 360 + angleFrom
	local v1 = (math.sqrt(acceleration * acceleration + 8 * acceleration * sFrom) - acceleration) / 2

	local sTo = m_nGroup * 360 + angleTo
	local v2 = (math.sqrt(acceleration * acceleration + 8 * acceleration * sTo) - acceleration) / 2

	m_nSpeed = (v1 + math.random() * (v2 - v1));
	
	
end
--设置奖项-转到哪一项停止
function LuckyDraw:setAwards(awardID)
	startAngle = setstartAngle
	local index = math.max(0,awardID - 1)
	self:calcBeginSpeed(index)
end
---设置转盘的参数
--@param speed 转的速度
--@param group 转的圈数
--@param isAwaring 是否开始抽奖
function LuckyDraw:begin(speed,group,isAwarding)
	m_bStartAward = isAwarding
	m_nSpeed = speed
	m_nGroup = group
end
function LuckyDraw:setRotateEnable(enable)
	m_bRotateEnable = enable
end
function LuckyDraw:setRotateOver(over)
	m_bRotateOver = over
end
--重置转盘的初始动作
function LuckyDraw:resetRotate()
	startAngle = setstartAngle
	m_bAssign = false
	m_bModify = false
	m_imgZhuanpan:stopAllActions()
	m_imgZhuanpan:setRotation(0)
	self:setRotateOver(false)
end
--  广播 跑马灯
function LuckyDraw:fun_radio( ... )
	local LuckyDraw_text =self.LuckyDraw_bg:getChildByName("LuckyDraw_text")
	LuckyDraw_text:setVisible(false)
	local crn=cc.ClippingRectangleNode:create(cc.rect(0,0,560,140))
	crn:setAnchorPoint(0)
                  crn:setPosition(cc.p(LuckyDraw_text:getPositionX()-LuckyDraw_text:getContentSize().width/2,LuckyDraw_text:getPositionY()-LuckyDraw_text:getContentSize().height/2))
                  self.LuckyDraw_bg:addChild(crn)

                  local title = ccui.Text:create("恭喜拼乐融资成功\n\n希望拼乐签约成功\n\n拼乐新版本即将上线", "resources/com/huakangfangyuan.ttf", 27)
                  title:setPosition(cc.p(290,-140))
                  title:setAnchorPoint(cc.p(0.5,0))
                  crn:addChild(title)
                  title:setColor(cc.c3b(255, 255, 255))

                        --描述动画
                    local move = cc.MoveTo:create((title:getContentSize().height)/25, cc.p(290,140))
                    --local move_back = move:reverse()
                     local callfunc = cc.CallFunc:create(function(node, value)
                            title:setPosition(cc.p(290,-140))
                          end, {tag=0})
                     local seq = cc.Sequence:create(move,cc.DelayTime:create(1),callfunc  ) 
                    local rep = cc.RepeatForever:create(seq)
                    title:runAction(rep)
end
function LuckyDraw:pushFloating(text)
       self.floating_layer:showFloat(text)  
end 

function LuckyDraw:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function LuckyDraw:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function LuckyDraw:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function LuckyDraw:onEnter()
	-- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
 --                       function()
	-- 		self:fun_list_data()
			          
 --                      end)--
end

function LuckyDraw:onExit()
      -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
--android 返回键 响应
function LuckyDraw:listener_home() 
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

return LuckyDraw