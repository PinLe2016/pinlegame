
local Dialog_Zhuanpan = class("Dialog_Zhuanpan", function()
    return display.newLayer("Dialog_Zhuanpan")
end)
--私有的
Dialog_Zhuanpan.m_mainMenu = nil
Dialog_Zhuanpan.m_info = nil
--------转盘抽奖相关参数------------------

------------start---------------------
--手动修改参数，测试抽奖流程
local m_touchCount = 1 --点击后直接开始抽奖，=2表示先点击转动转盘，再点击一次开始抽奖
local ROTATE_TIME = 0.1 --旋转Action的时间
local ROTATE_TIME2 = 1.0 --转盘回滚的时间
local ROTATE_SPEED = 20 --旋转速度，每次旋50度  ＊
local ROTATE_GROUP = 20 --旋转圈数，旋转8圈后慢慢停下来  ＊
------------end------------------------

local m_visibleSize = nil --屏幕尺寸
local m_imgZhuanpan = nil --转盘图片
local m_imgZhuanpan1= nil --转盘阴影


--旋转逻辑的相关属性参数
local m_awardNum = 1 --奖品总数  分为的区间
local m_bStartAward = false --是否开始抽奖
local m_nSpeed = 0 --旋转速度  12
local m_nGroup = 0 --旋转的圈数  12

local setstartAngle=0  --开始角度
local startAngle = setstartAngle 
local acceleration = 1 --加速度

local endAngle = 0
local m_bModify = false -- 是否需要调整保证在中间位置

local m_bRotateEnable = false --是否旋转中
local m_bRotateOver = false --抽奖是否结束
local m_bAssign = false --当前是否需要指定抽哪种奖品
local m_nAwardID = 0 --指定当前抽的奖品ID  

--------第二套方案------------------

function Dialog_Zhuanpan:Big_wheel( _m_turnBg )
	local m_turnBg=_m_turnBg
	local fragment_table={ }
	  self.gridNumer=8    --   一共的格子数
	  self.gridAngle=360/self.gridNumer   --   每个格子的度数
	  self.x_rand=3
	table.insert(fragment_table,{_shuzi = self.x_rand})
	local   _int = #fragment_table  

	if (_int>1)   then 
		local  xin = fragment_table[_int-1]._shuzi
		if (self.x_rand > xin)   then 
		    self.x_rand = self.x_rand - xin;
		else
		    self.x_rand = self.gridNumer+  (self.x_rand - xin);
		end
	end
	self._rand= (self.x_rand  *  self.gridAngle   ) ;
	local  angleZ = self._rand + 1080*5+setstartAngle--720;  
	local  pAction1 = cc.RotateBy:create(8,1080+angleZ)--cc.EaseExponentialOut:create(cc.RotateBy:create(8,1080+angleZ))
	m_turnBg:runAction(pAction1)
end
--------------------------------------------------------------------------------------------------------------
function Dialog_Zhuanpan:ctor()
		self:init()
		self:show()
end
function Dialog_Zhuanpan:init()
	self.m_mainMenu = cc.Layer:create()
	self.m_mainMenu:setTouchEnabled  (true)
	self:addChild(self.m_mainMenu)

	m_visibleSize=cc.Director:getInstance():getVisibleSize()

	local function touchEvent(sender,eventType)
	    if eventType == ccui.TouchEventType.began then
	        print("Touch Down")
	        self:maskTouch()  --  第一种
	    --self:Big_wheel(m_imgZhuanpan)  --第二种
	    end
	end
            local button = ccui.Button:create()
            button:setTouchEnabled(true)
            button:setScale9Enabled(true)
            button:loadTextures("png/httpgame.pinlegame.comheadheadicon_0.jpg", "png/httpgame.pinlegame.comheadheadicon_0.jpg", "")
            button:setPosition(cc.p(m_visibleSize.width / 2.0, m_visibleSize.height / 2.0-200))
            button:setContentSize(cc.size(150, button:getVirtualRendererSize().height * 1.5))
            button:addTouchEventListener(touchEvent)
            self.m_mainMenu:addChild(button,100)
	--转盘图片
	m_imgZhuanpan = display.newSprite("image/TurntableImage_1.png")
	m_imgZhuanpan:retain()
	m_imgZhuanpan:setPosition(cc.p(m_visibleSize.width/2,m_visibleSize.height/2))
	m_imgZhuanpan:setAnchorPoint(cc.p(0.5, 0.5))
	self.m_mainMenu:addChild(m_imgZhuanpan)

	m_imgZhuanpan1 = display.newSprite("image/ceshiPlist.png")
	if m_imgZhuanpan1 then
	    m_imgZhuanpan1:retain()
	    m_imgZhuanpan1:setPosition(cc.p(m_visibleSize.width/2+20,m_visibleSize.height/2))
	    m_imgZhuanpan1:setAnchorPoint(cc.p(0.5, 0.5))
	    self.m_mainMenu:addChild(m_imgZhuanpan1)
	end
	startAngle = setstartAngle
	--加速度
	acceleration = 1
end

function Dialog_Zhuanpan:show(_str)
	self:initdata()
	self.m_mainMenu:setTouchEnabled(true)
	self.m_mainMenu:setVisible(true)
end
function Dialog_Zhuanpan:initdata(info)
	info = {
		data = {		
			{id = 1,name="S卡x1"},
			{id = 2,name="C卡x10"},
			{id = 3,name="B卡x5"},
			{id = 4,name="银币x20"},
			{id = 5,name="金币x100000"},
			{id = 6,name="钻石x100"},
			{id = 7,name="钻石x20"},
			{id = 8,name="药瓶x5"}
			
		}
	}
	self.m_info = info
	m_awardNum = #self.m_info.data
	
end

function Dialog_Zhuanpan:refView()
	
	self:setRotateEnable(false)
	self:resetRotate()

end
--  开始按钮操作
function Dialog_Zhuanpan:maskTouch()
	m_nAwardID = math.random(1,m_awardNum)  --＊
	print("抽奖设置id",m_nAwardID)   --  使我们设置的参数
	self:awardStart()
end

--转盘开始转动
function Dialog_Zhuanpan:awardStart()
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
function Dialog_Zhuanpan:awardEnd()
	dump("抽奖成功,抽到"..self.m_info.data[m_nAwardID].name)
end
function Dialog_Zhuanpan:doRotateAction(node,callback,time,speed)
  --cclog("doRotateAction")
  local sequence = nil
  local act1 = cc.RotateBy:create(time,speed)
  local callfunc = cc.CallFunc:create(callback)
  sequence = cc.Sequence:create(act1, callfunc)
  node:runAction(sequence)
end
function Dialog_Zhuanpan:rotateOver()
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
function Dialog_Zhuanpan:proRotateStop(startAngle)
	local testFloat = startAngle + 90
	testFloat = testFloat % 360
	dump(startAngle,"startAngle")
	--dump(testFloat,"testFloat")
	for i,v in ipairs(self.m_info.data) do
		--中奖角度范围
		local tmp = i - 1
		local angleFrom = 90 + 270 - (tmp + 1) * (360 / m_awardNum)
		local angleTo = 90 + 270 - tmp * (360 / m_awardNum)
		print("i = %d,from = %d,to = %d",i,angleFrom,angleTo)
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
function Dialog_Zhuanpan:calcBeginSpeed(awardIndex)
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
function Dialog_Zhuanpan:setAwards(awardID)
	startAngle = setstartAngle
	local index = math.max(0,awardID - 1)
	self:calcBeginSpeed(index)
end
---设置转盘的参数
--@param speed 转的速度
--@param group 转的圈数
--@param isAwaring 是否开始抽奖
function Dialog_Zhuanpan:begin(speed,group,isAwarding)
	m_bStartAward = isAwarding
	m_nSpeed = speed
	m_nGroup = group
end
function Dialog_Zhuanpan:setRotateEnable(enable)
	m_bRotateEnable = enable
end
function Dialog_Zhuanpan:setRotateOver(over)
	m_bRotateOver = over
end
--重置转盘的初始动作
function Dialog_Zhuanpan:resetRotate()
	startAngle = setstartAngle
	m_bAssign = false
	m_bModify = false
	m_imgZhuanpan:stopAllActions()
	m_imgZhuanpan:setRotation(0)
	self:setRotateOver(false)
end


return Dialog_Zhuanpan