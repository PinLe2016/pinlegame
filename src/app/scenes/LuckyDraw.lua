
--  新版大转盘
local LuckyDraw = class("LuckyDraw", function()
            return display.newScene("LuckyDraw")
end)

------------start---------------------
--手动修改参数，测试抽奖流程
local m_touchCount = 1 --点击后直接开始抽奖，=2表示先点击转动转盘，再点击一次开始抽奖
local ROTATE_TIME = 0.1 --旋转Action的时间
local ROTATE_TIME2 = 1.0 --转盘回滚的时间
local ROTATE_SPEED = 700 --旋转速度，每次旋50度  ＊
local ROTATE_GROUP = 20 --旋转圈数，旋转8圈后慢慢停下来  ＊
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
local m_info_data_1={}--{"1元话费","110经验","5元话费","1充电宝","366金币","10元话费","50经验","66金币","20经验","166金币"}
local m_info_data_2={}--{"30元话费","200经验","5元话费","AV眼睛","5888金币","10积分","红米","1888金币","500经验","2888金币"}
local m_info_data_3={}--{"20元话费","200经验","5元话费","1音响","999金币","10元话费","普通种子","333金币","100经验","666金币"}
local m_info_data_name1={}
local m_info_data_name2={}
local m_info_data_name3={}
local m_info_data_obj1={}
local m_info_data_obj2={}
local m_info_data_obj3={}
local LuckyDraw_type=200


function LuckyDraw:ctor()
      self:fun_init()
      self:fun_constructor()
      Server:Instance():getfortunewheelrewards(200)
      Server:Instance():getrecentfortunewheelrewardlist()
      
end
function LuckyDraw:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
      self.radio_table={}  --  广播表
      self.rewardid_table={}
      self.reward_IsGold=2
      self.x_rand=0
      self.x_rand_is=1
      --  定时器
      self.image_table={}  --  存放奖品图片
      self.time=0
      self.secondOne = 0
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
	      	self:update(dt)
      end)
      self.m_info={ }
      self.m_info.data={ }
      self:init()
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
function LuckyDraw:fun_LuckyDrawGoNode( ... )
	 --  新手引导
	local new_start=cc.UserDefault:getInstance():getStringForKey("Newbieguide","0")
	if tonumber(new_start)==0 then
	self.GONODE=cc.CSLoader:createNode("LuckyDrawGoNode.csb")
	self.GONODE:setTag(568)
	self:addChild(self.GONODE)
	self.shareroleAction = cc.CSLoader:createTimeline("LuckyDrawGoNode.csb")
     	self.GONODE:runAction(self.shareroleAction)
     	self.shareroleAction:setTimeSpeed(1)
     	self.shareroleAction:gotoFrameAndPlay(0,80, true)
     	local Image_2=self.GONODE:getChildByName("Image_2")
            Image_2:addTouchEventListener(function(sender, eventType  )
                     
                      if eventType ~= ccui.TouchEventType.ended then
                           return
                      end
                     self:removeChildByTag(568, true)

      end)
	        cc.UserDefault:getInstance():setStringForKey("Newbieguide","2")
	end

	
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
	self:fun_win_img_init()
	self:fun_LuckyDrawGoNode()
	self.go_bt=self.LuckyDraw_node:getChildByName("go_bt")
	self.go_bt:setTouchEnabled(false)
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
	                Util:all_layer_backMusic()
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
function LuckyDraw:fun_win_img_init( ... )
	for i=1,10 do
		table.insert(m_info_data_name1,{name = self.LuckyDraw_Rotary1:getChildByName("rewardImg"   ..   i):getChildByName("rewardImgname"   ..   i)})
	end
	for i=1,10 do
		table.insert(m_info_data_name2,{name = self.LuckyDraw_Rotary2:getChildByName("rewardImg"   ..   i):getChildByName("rewardImgname"   ..   i)})
	end
	for i=1,10 do
		table.insert(m_info_data_name3,{name = self.LuckyDraw_Rotary3:getChildByName("rewardImg"   ..   i):getChildByName("rewardImgname"   ..   i)})
	end
	for i=1,10 do
		table.insert(m_info_data_obj1,{name = self.LuckyDraw_Rotary1:getChildByName("rewardImg"   ..   i)})
	end
	for i=1,10 do
		table.insert(m_info_data_obj2,{name = self.LuckyDraw_Rotary2:getChildByName("rewardImg"   ..   i)})
	end
	for i=1,10 do
		table.insert(m_info_data_obj3,{name = self.LuckyDraw_Rotary3:getChildByName("rewardImg"   ..   i)})
	end
end
function LuckyDraw:fun_draw_go( ... )
	
          	self.go_bt:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)

	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	                Util:player_music_new("spin_button.mp3",false )
	              self.go_bt:setTouchEnabled(false)
	              self:fun_LuckyDraw_touch(false)
	              local _LuckyDraw_type=200
	              if LuckyDraw_type==200 then
	              	_LuckyDraw_type=200
	              elseif LuckyDraw_type==500 then
	              	_LuckyDraw_type=500
	              else
	              	_LuckyDraw_type=2000
	              end
	              Server:Instance():getfortunewheelrandomreward(_LuckyDraw_type)
	              self:fun_Isgold(self.reward_IsGold)
	              self.reward_IsGold=1
	              
            end)
end
function LuckyDraw:fun_Isgold(_type)
	if _type==1 then
		local fortunewheelrandomreward=LocalData:Instance():get_getfortunewheelrandomreward()
		local remaingolds = tonumber(fortunewheelrandomreward["remaingolds"])
		if tonumber(remaingolds) - LuckyDraw_type < 0 then
			self.floating_layer:showFloat("金币不足")
			return  
		end
	else
		local getfortunewheelrewards=LocalData:Instance():get_getfortunewheelrewards()
	            local remaingolds = tonumber(getfortunewheelrewards["remaingolds"])
		if tonumber(remaingolds) - LuckyDraw_type < 0 then
			self.floating_layer:showFloat("金币不足")  
			return
		end
	end
	self:fun_began_start()

	
end
--  初始化点击GO 
function LuckyDraw:fun_began_start()
		
	
       local function CallFucnCallback3(sender)
                if self.x_rand~=0 then
                  self:maskTouch(self.x_rand)
                  self.x_rand=0
                else
                  self:fun_began_start()
                end

        end
        local  pAction1 =cc.RotateBy:create(0.1,-360)
        m_imgZhuanpan:runAction(cc.Sequence:create(pAction1,cc.CallFunc:create(CallFucnCallback3)))
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
                Util:all_layer_backMusic()
              self.curr_bright:setBright(true)
              sender:setBright(false)
               if tag=="LuckyDraw_Rotary_bt1" then  
		print("200")
		self:unscheduleUpdate()
		self.image_table={}
		LuckyDraw_type=200
		self.reward_IsGold=2
		self.rewardid_table={}
		self.go_bt:setTouchEnabled(false)
		Server:Instance():getfortunewheelrewards(200)
		self:fun_LuckyDraw_visble()
		m_imgZhuanpan = self.LuckyDraw_Rotary1
		self.LuckyDraw_zbg1:setVisible(true)
               elseif tag=="LuckyDraw_Rotary_bt2" then
		print("500")
		self:unscheduleUpdate()
		self.image_table={}
		LuckyDraw_type=500
		self.reward_IsGold=2
		self.rewardid_table={}
		self.go_bt:setTouchEnabled(false)
		Server:Instance():getfortunewheelrewards(500)
		self:fun_LuckyDraw_visble()
		m_imgZhuanpan = self.LuckyDraw_Rotary2
		self.LuckyDraw_zbg2:setVisible(true)
	   elseif tag=="LuckyDraw_Rotary_bt3" then
		print("2000")
		self:unscheduleUpdate()
		self.image_table={}
		LuckyDraw_type=2000
		self.reward_IsGold=2
		self.rewardid_table={}
		self.go_bt:setTouchEnabled(false)
		Server:Instance():getfortunewheelrewards(2000)
		self:fun_LuckyDraw_visble()
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
	self:initdata(_str)
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
function LuckyDraw:maskTouch(_id)
	
	m_nAwardID =_id --math.random(1,m_awardNum)  --＊＊＊
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
	audio.stopAllSounds()
	Util:player_music_new("huode.mp3",false )
	self:fun_LuckyDraw_touch(true)
	self.go_bt:setTouchEnabled(true)
	
	local function fun_stopGo()
	        self:fun_LuckyDrawEndAct()
	  end
	  self:runAction( cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(fun_stopGo)))
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
				audio.stopAllSounds()
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
function LuckyDraw:fun_radio( _text ,_number)
	local LuckyDraw_text =self.LuckyDraw_bg:getChildByName("LuckyDraw_text")
	LuckyDraw_text:setVisible(false)
	local crn=cc.ClippingRectangleNode:create(cc.rect(0,0,560,140))
	crn:setAnchorPoint(cc.p(0,0))
                  crn:setPosition(cc.p(LuckyDraw_text:getPositionX()-LuckyDraw_text:getContentSize().width/2,LuckyDraw_text:getPositionY()-LuckyDraw_text:getContentSize().height/2))
                  self.LuckyDraw_bg:addChild(crn)

                  local title = ccui.Text:create(_text, "resources/com/huakangfangyuan.ttf", 27)
                  title:setPosition(cc.p(290,-140-title:getContentSize().height))
                  title:setAnchorPoint(cc.p(0.5,0))
                  crn:addChild(title)
                  title:setColor(cc.c3b(255, 255, 255))
               
                        --描述动画
                    local move = cc.MoveTo:create((title:getContentSize().height)/(10+_number*2), cc.p(290,140+title:getContentSize().height))
                    --local move_back = move:reverse()
                     local callfunc = cc.CallFunc:create(function(node, value)
                            title:setPosition(cc.p(290,-140-title:getContentSize().height))
                          end, {tag=0})
                     local seq = cc.Sequence:create(move,cc.DelayTime:create(0.2),callfunc  ) 
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
--下载图片
function LuckyDraw:LuckyDraw_download_list(  )
         local fortunewheelrewards=LocalData:Instance():get_getfortunewheelrewards()
         local  rewardlist=fortunewheelrewards["rewardlist"]
         if #rewardlist  ==0  then
         	return
         end
         local _number=0
         local _number_count=0
         for i=1,#rewardlist do
         	if tonumber(rewardlist[i]["type"] ) ==1 then
         		_number=_number+1
         	end
         end
         for i=1,#rewardlist do
         	local com_={}
         	if  tonumber(rewardlist[i]["type"] )  ==1  then  --  1  实物  2  金币  3  话费
         		_number_count=_number_count+1
         		com_["command"]=rewardlist[i]["goodsimageurl"]
	         	com_["max_pic_idx"]=_number
	         	com_["curr_pic_idx"]=_number_count
	         	com_["TAG"]="getfortunewheelrewards"
	         	Server:Instance():request_pic(rewardlist[i]["goodsimageurl"],com_) 
         	end
         	
         end
end
--刷新时间的定时器
function LuckyDraw:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
           
           --  刷新下载的图片
	if #self.image_table~=0 then
	   local next_num=0
	  for i=1,#self.image_table do
	      local file=cc.FileUtils:getInstance():isFileExist(self.image_table[i].name)
	      if file and self.image_table[i]._obj then
	          local activity_Panel=self.image_table[i]._obj
	          activity_Panel:loadTexture(self.image_table[i].name)
	          self.image_table[i]._obj=nil
	          next_num=next_num+1
	      end
	  end
	  if next_num == #self.image_table then
	     self.image_table={}
	     self:unscheduleUpdate()
	  end
	end
end
function LuckyDraw:fun_LuckyDrawEndAct(  )
  local LuckyDrawEndAct = cc.CSLoader:createNode("LuckyDrawEndAct.csb");
  self:addChild(LuckyDrawEndAct) 
  LuckyDrawEndAct:setTag(159)
  local function fun_stopGo()
        self:removeChildByTag(159,true)
  end
  LuckyDrawEndAct:runAction( cc.Sequence:create(cc.DelayTime:create(3 ),cc.CallFunc:create(fun_stopGo)))
   local Image_guang=LuckyDrawEndAct:getChildByName("Image_102")
   local actionT1= cc.ScaleTo:create( 1, 1.2)
   local actionTo1 = cc.ScaleTo:create( 1, 0.85)
   local actionT2 = cc.RotateBy:create( 1, 70)
   local actionTo2 = cc.RotateBy:create(1, 70)
  Image_guang:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT1, actionTo1)))
  Image_guang:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT2, actionTo2)))
  
   local actionT3= cc.ScaleTo:create( 1, 1.3)
   local actionTo3 = cc.ScaleTo:create( 1, 0.8)
   local Image_103=LuckyDrawEndAct:getChildByName("Image_103")
   --Image_103:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT3, actionTo3)))
  local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
  local fortunewheelrewards=LocalData:Instance():get_getfortunewheelrewards()
  local rewardlist= fortunewheelrewards["rewardlist"]
  if tonumber(rewardlist[self.x_rand_is]["type"])  ==  2 then  --金币
     	Image_103:loadTexture("Dialog_Zhuanpan/ZLB_CJ_10.png")
  elseif tonumber(rewardlist[self.x_rand_is]["type"])  ==  3 then   --  话费
	Image_103:loadTexture("Dialog_Zhuanpan/ZLB_CJ_13.png")
  else
  	Image_103:loadTexture(path..tostring(Util:sub_str(rewardlist[self.x_rand_is]["goodsimageurl"], "/",":")))
 end

  local pwtrue=LuckyDrawEndAct:getChildByName("Image_1")
            pwtrue:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                   self:removeChildByTag(159,true)
            end)
     
     
end
function LuckyDraw:onEnter()
	--  动态广播返回数据
	NotificationCenter:Instance():AddObserver("GAME_GETRECENTFORTUNEWHEELREWARDLIST", self,
                       function()
                       		local  recentfortunewheelrewardlist=LocalData:Instance():get_getrecentfortunewheelrewardlist()
                       		local rewardlist= recentfortunewheelrewardlist["rewardlist"]
                       		if #rewardlist  ==  0 then
                       			return
                       		end
                       		for i=1,#rewardlist  do
                       			self.radio_table[i]="恭喜 " ..  rewardlist[i]["nickname"] ..  " 获得 "  ..  rewardlist[i]["rewardname"]  
                       		end
                       		self:fun_radio(table.concat(self.radio_table,"\n\n"),#rewardlist-1 )
                      end)--
	--  点击GO  返回的数据
	NotificationCenter:Instance():AddObserver("GAME_GETFORTUNEWHEELRANDOMREWARD", self,
                       function()
                       		local fortunewheelrandomreward=LocalData:Instance():get_getfortunewheelrandomreward()
                       		local rewardid=fortunewheelrandomreward["rewardid"]
                       		for i=1,#self.rewardid_table do
                       			if self.rewardid_table[i]  == rewardid  then
                       				self.x_rand=i
                       				self.x_rand_is=i
                       			end
                       		end
                      end)--
	--  GO 错误
	NotificationCenter:Instance():AddObserver("GAME_GETFORTUNEWHEELRANDOMREWARD_FALSE", self,
                       function()
                       		self.go_bt:setTouchEnabled(true)
                       		self:fun_LuckyDraw_touch(true)
                       		audio.stopAllSounds()
		            Util:player_music_new("jbbuzu.mp3",false )
                      end)--

	NotificationCenter:Instance():AddObserver("GAME_GETFORTUNEWHEELREWARDS", self,
                       function()
			local fortunewheelrewards=LocalData:Instance():get_getfortunewheelrewards()
			local rewardlist= fortunewheelrewards["rewardlist"]
			local _obj_name=m_info_data_name1
			local _info_data=m_info_data_1
			local  _img=m_info_data_obj1
			if LuckyDraw_type==200 then
				_obj_name=m_info_data_name1
				_info_data=m_info_data_1
				_img=m_info_data_obj1
			elseif LuckyDraw_type==500 then
				_obj_name=m_info_data_name2
				_info_data=m_info_data_2
				_img=m_info_data_obj2
			else
				_obj_name=m_info_data_name3
				_info_data=m_info_data_3
				_img=m_info_data_obj3
			end
			for i=1,#rewardlist do
				_obj_name[i].name:setString(rewardlist[i]["name"])
				_info_data[i]=rewardlist[i]["name"]
				self.rewardid_table[i]=rewardlist[i]["rewardid"]
				if tonumber(rewardlist[i]["type"])  ==  2 then  --金币
					_img[i].name:loadTexture("Dialog_Zhuanpan/ZLB_CJ_10.png")
				elseif tonumber(rewardlist[i]["type"])  ==  3 then   --  话费
					_img[i].name:loadTexture("Dialog_Zhuanpan/ZLB_CJ_13.png")
				end
			end
			self.go_bt:setTouchEnabled(true)
			self:show(_info_data)
			self:LuckyDraw_download_list()
                      end)--

	NotificationCenter:Instance():AddObserver("msg_getfortunewheelrewards", self,
                       function()
                       		local fortunewheelrewards=LocalData:Instance():get_getfortunewheelrewards()
			local rewardlist= fortunewheelrewards["rewardlist"]
			local  _img=m_info_data_obj1
			if LuckyDraw_type==200 then
				_img=m_info_data_obj1
			elseif LuckyDraw_type==500 then
				_img=m_info_data_obj2
			else
				_img=m_info_data_obj3
			end
			local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
		            for i=1,#rewardlist do
				if tonumber(rewardlist[i]["type"])  ==  1 then  --实物
				          local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(rewardlist[i]["goodsimageurl"], "/",":")))
				          if not  file then
				              table.insert(self.image_table,{_obj = _img[i].name ,name=path..tostring(Util:sub_str(rewardlist[i]["goodsimageurl"], "/",":"))})
				           else
				               _img[i].name:loadTexture(path..tostring(Util:sub_str(rewardlist[i]["goodsimageurl"], "/",":")))
				          end
				end
			end
			self:scheduleUpdate()
                      end)--
	
end

function LuckyDraw:onExit()
      self:fun_table_init()
       NotificationCenter:Instance():RemoveObserver("GAME_GETFORTUNEWHEELRANDOMREWARD_FALSE", self)
       NotificationCenter:Instance():RemoveObserver("GAME_GETFORTUNEWHEELREWARDS", self)
       NotificationCenter:Instance():RemoveObserver("GAME_GETRECENTFORTUNEWHEELREWARDLIST", self)
       NotificationCenter:Instance():RemoveObserver("msg_getfortunewheelrewards", self)
       NotificationCenter:Instance():RemoveObserver("GAME_GETFORTUNEWHEELRANDOMREWARD", self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
function LuckyDraw:fun_table_init( ... )
      m_info_data_1={}
      m_info_data_2={}
      m_info_data_3={}
      m_info_data_name1={}
      m_info_data_name2={}
      m_info_data_name3={}
      m_info_data_obj1={}
      m_info_data_obj2={}
      m_info_data_obj3={}
      LuckyDraw_type=200
      self.image_table={}
      self.radio_table={}
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