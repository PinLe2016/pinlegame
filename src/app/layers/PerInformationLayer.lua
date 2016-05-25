



--
-- Author: peter
-- Date: 2016-05-09 10:14:40
--
--
-- Author: Your Name
-- Date: 2016-05-06 10:43:44
--
local PerInformationLayer = class("PerInformationLayer", function()
            return display.newScene("PerInformationLayer")
end)
function PerInformationLayer:ctor()--params

       self:setNodeEventEnabled(true)--layer添加监听
        --Server:Instance():getuserinfo() -- 初始化数据

        
      self:init()

end
function PerInformationLayer:init(  )

	self.Perinformation = cc.CSLoader:createNode("Perinformation.csb")
    	self:addChild(self.Perinformation)

    	self.birthday_bt=self.Perinformation:getChildByTag(245)
    	self.birthday_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local city_bt=self.Perinformation:getChildByTag(244)
    	city_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local true_bt=self.Perinformation:getChildByTag(83)  --确定
    	true_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local back_bt=self.Perinformation:getChildByTag(97)  --返回
    	back_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	self:perinformation_init()

end
--个人信息初始化
function PerInformationLayer:perinformation_init(  )

	local  userdata=LocalData:Instance():get_user_data() --用户数据

	local  bg=self.Perinformation:getChildByTag(26)
	local image_head=bg:getChildByTag(67)  --头像
    	image_head:loadTexture(tostring(Util:sub_str(userdata["imageUrl"], "/",":")))
    	local name=self.Perinformation:getChildByTag(68)  --名字
    	name:setString(userdata["nickname"])
    	local golds=self.Perinformation:getChildByTag(73)  --金币
    	golds:setString(userdata["golds"])
    	local rankname=self.Perinformation:getChildByTag(76)  --等级
    	rankname:setString("LV." .. userdata["rankname"])

    	-- local  userdatainit=LocalData:Instance():get_userinfoinit() --初始化个人信息
    	-- local registereday=self.Perinformation:getChildByTag(86)  --注册日期
    	-- registereday:setString(tostring(userdatainit["registertime"]))  --checkBox:setSelectedState(true)
    	-- local genderman=self.Perinformation:getChildByTag(79)  --性别男
    	-- local gendergirl=self.Perinformation:getChildByTag(80)  --性别女
    	-- if userdatainit["gender"]==0 then    --0女1男2未知
    	-- 	genderman:setSelected(false)
    	-- 	gendergirl:setSelected(true)
    	-- elseif userdatainit["gender"]==1 then
    	-- 	genderman:setSelected(true)
    	-- 	gendergirl:setSelected(false)
    	-- else
    	-- 	genderman:setSelected(false)
    	-- 	gendergirl:setSelected(false)
    	-- end  
    	-- --初始化年月日
    	-- local date=Util:lua_string_split(userdatainit["birthday"],"/")
    	-- local years=self.Perinformation:getChildByTag(87)
    	-- local month=self.Perinformation:getChildByTag(88)
    	-- local day=self.Perinformation:getChildByTag(89)
    	-- years:setString(date[1])
    	-- years:setString(date[2])
    	-- years:setString(date[3])
end
function PerInformationLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	--local activitypoints=LocalData:Instance():getactivitypoints_callback()
	local tag=sender:getTag()
	if tag==244 then --城市
		self:fun_city(  )
	elseif tag==245 then --生日
		self:fun_birthday(  )
	elseif tag==49 then 
		self.birthday:removeFromParent()
	elseif tag==59 then 
		self.adress:removeFromParent()
	elseif tag==83 then 
		self:savedata()   --  保存个人信息数据发送Http
	elseif tag==97 then 
		self.Perinformation:removeFromParent()
	end
end
function PerInformationLayer:savedata( )
	local  userdata=LocalData:Instance():get_user_data()
	local  loginname=userdata["loginname"]
	local  nickname=userdata["nickname"]
	local  provinceid=1  
	local  provincename="山东"
	local  cityid=1
	local  cityname="青岛"
	local  birthday = "2015-03-12"
	local  gender="1"
	local  imageurl=" "
	Server:Instance():setuserinfo({loginname=loginname,nickname=nickname,provinceid=provinceid,provincename
		=provincename,cityid=cityid,cityname=cityname,birthday=birthday,gender=gender,imageurl=imageurl}) 
end
function PerInformationLayer:fun_birthday(  )
	self.birthday = cc.CSLoader:createNode("Birthday.csb")
    	self:addChild(self.birthday)
    	local birthday_back=self.birthday:getChildByTag(174):getChildByTag(49)
    	birthday_back:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	--年 
    	local birthday_scrollview=self.birthday:getChildByTag(174):getChildByTag(170)
    	local birthday_years=birthday_scrollview:getChildByTag(175)
            local height=birthday_years:getContentSize().height   
            local width=birthday_years:getContentSize().width
            local birthday_years_y= birthday_years:getPositionY()
            self.qq=height
            local  table_years={}
    	for i=1,130 do	
    	     local  cell = birthday_years:clone() 
                 table_years[i]=cell
    	     cell:setTag(i)
    	     cell:addTouchEventListener(function(sender, eventType  )
		if sender:getPositionY()< self.qq*4 -50 or   sender:getPositionY()> self.qq*4 +50 then
                           
                            for i=1,#table_years do
                                 table_years[i]:setPositionY(table_years[i]:getPositionY()- table_years[i]:getPositionY()%self.qq)
                            end
		
		-- print("减肥的快捷方式的发生的",sender:getTag())
		end
	     end)
    	     birthday_scrollview:addTouchEventListener(function(sender, eventType  )
		if eventType ~= ccui.TouchEventType.ended then
		         return
	           end
	           print("就是地方建设的快捷方式的")
	     end)
    	     


    	     cell:setPositionY(birthday_years_y-i*height)
    	     if i >=125 then
    	     	cell:setString("")
    	     else
    	     	cell:setString(tostring(2016-i))
    	     end

    	     birthday_scrollview:addChild(cell)
    	      
    	end






    	--月
    	local birthday_scrollview2=self.birthday:getChildByTag(174):getChildByTag(171)
    	local birthday_month=birthday_scrollview2:getChildByTag(176)
            -- local height_month=birthday_month:getContentSize().height   
             local birthday_month_y= birthday_month:getPositionY()
    	for i=1,11 do	
    	     local  cell_month = birthday_month:clone()  
    	     cell_month:setPositionY(birthday_month_y-i*height)
    	    if i<9 then
    	    	 cell_month:setString("0" .. tostring(i+1))
    	    else
    	    	 cell_month:setString(tostring(i+1))
    	    end
    	    

    	     birthday_scrollview2:addChild(cell_month)
    	      
    	end
    	--日
    	local birthday_scrollview3=self.birthday:getChildByTag(174):getChildByTag(173)
    	local birthday_daty=birthday_scrollview3:getChildByTag(177)
            --local height=birthday_years:getContentSize().height   
            local birthday_daty_y= birthday_daty:getPositionY()
    	for i=1,31 do	
    	     local  cell_daty = birthday_daty:clone()  
    	     cell_daty:setPositionY(birthday_daty_y-i*height)
    	     if i <9 then
    	     	cell_daty:setString("0" .. tostring(i+1))
    	     else
    	     	cell_daty:setString(tostring(i+1))
    	     end

    	     birthday_scrollview3:addChild(cell_daty)
    	      
    	end
end
function PerInformationLayer:fun_city(  )
	self.adress = cc.CSLoader:createNode("Adress.csb")
    	self:addChild(self.adress)
    	local city_back=self.adress:getChildByTag(52):getChildByTag(59)
    	city_back:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
end
function PerInformationLayer:onEnter()
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self,
                       function()
                      		print("个人信息初始化")
                      end)
	 NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self,
                       function()
                      		print("个人信息修改")
                      end)
end

function PerInformationLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self)
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self)
end

return PerInformationLayer

















