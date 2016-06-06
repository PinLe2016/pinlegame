
--
local PerInformationLayer = class("PerInformationLayer", function()
            return display.newScene("PerInformationLayer")
end)
function PerInformationLayer:ctor()--params

       self:setNodeEventEnabled(true)--layer添加监听
       Server:Instance():getuserinfo() -- 初始化数据
       self.head_index=100 -- 初始化
     --self:init()

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
            local head_bt=self.Perinformation:getChildByTag(26):getChildByTag(67)  --头像
            head_bt:addTouchEventListener(function(sender, eventType  )
                        self:touch_callback(sender, eventType)
            end)
    	self:perinformation_init()

end
--个人信息初始化
function PerInformationLayer:perinformation_init(  )

	local  userdata=LocalData:Instance():get_user_data() --用户数据

	local  bg=self.Perinformation:getChildByTag(26)
	self.image_head=bg:getChildByTag(67)  --头像
            self._index=string.sub(tostring((self:chaifen(userdata["imageUrl"])),"."),1,1)
    	self.image_head:loadTexture(tostring(Util:sub_str(userdata["imageUrl"], "/",":")))
    	local name=self.Perinformation:getChildByTag(68)  --名字
    	name:setString(userdata["nickname"])
    	local golds=self.Perinformation:getChildByTag(73)  --金币
    	golds:setString(userdata["golds"])
    	local rankname=self.Perinformation:getChildByTag(76)  --等级
    	rankname:setString("LV." .. userdata["rankname"])

    	local  userdatainit=LocalData:Instance():get_getuserinfo() --初始化个人信息
    	local registereday=self.Perinformation:getChildByTag(86)  --注册日期
    	registereday:setString(tostring(os.date("%Y年%m月%d日",userdatainit["registertime"])))
    	self.genderman=self.Perinformation:getChildByTag(79)  --性别男
    	self.gendergirl=self.Perinformation:getChildByTag(80)  --性别女
            --性别之间切换
            self.genderman:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.genderman:setSelected(true)
                            self.gendergirl:setSelected(false)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
            end)

            self.gendergirl:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.genderman:setSelected(false)
                            self.gendergirl:setSelected(true)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
            end)


    	if userdatainit["gender"]==0 then    --0女1男2未知
    		self.genderman:setSelected(false)
    		self.gendergirl:setSelected(true)
    	elseif userdatainit["gender"]==1 then
    		self.genderman:setSelected(true)
    		self.gendergirl:setSelected(false)
    	else
    		self.genderman:setSelected(false)
    		self.gendergirl:setSelected(false)
    	end  
    	--初始化年月日
    	local date=Util:lua_string_split(os.date("%Y/%m/%d",userdatainit["birthday"]),"/")
    	self.date_years=self.Perinformation:getChildByTag(87)
    	self.date_month=self.Perinformation:getChildByTag(88)
    	self.date_day=self.Perinformation:getChildByTag(89)
    	self.date_years:setString(date[1])
    	self.date_month:setString(date[2])
    	self.date_day:setString(date[3])
 

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
            elseif tag==67 then 
                        self:head()
	end
end
function PerInformationLayer:head( )
        self.head_csb = cc.CSLoader:createNode("Head.csb")
        self:addChild(self.head_csb)
        local head_back=self.head_csb:getChildByTag(21):getChildByTag(25)
        head_back:addTouchEventListener(function(sender, eventType  )
                 self:head_callback(sender, eventType)
        end)
        local head_true=self.head_csb:getChildByTag(21):getChildByTag(24)
        head_true:addTouchEventListener(function(sender, eventType  )
                 self:head_callback(sender, eventType)
        end)
        self.PageView_head=self.head_csb:getChildByTag(21):getChildByTag(26)
        self.PageView_head:addEventListener(function(sender, eventType  )
                 if eventType == ccui.PageViewEventType.turning then
                    self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex())
                    self.head_index=tostring(self.PageView_head:getCurPageIndex())
                end
        end)
        local Panel=self.PageView_head:getChildByTag(27)
        for i=1,15 do
            local  call=Panel:clone() 
            local head_image=call:getChildByTag(86)
            head_image:loadTexture( "httpgame.pinlegame.comheadheadicon_" .. tostring(i) .. ".jpg")--初始化头像
            self.PageView_head:addPage(call)   --添加头像框
        end
        self.PageView_head:scrollToPage(self._index)   --拿到需要索引的图

        local head_reduce=self.head_csb:getChildByTag(21):getChildByTag(23)  --减
        head_reduce:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex()-1)
                self.head_index=tostring(self.PageView_head:getCurPageIndex())

        end)
        local head_add=self.head_csb:getChildByTag(21):getChildByTag(22)  --加
        head_add:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex()+1)
                self.head_index=tostring(self.PageView_head:getCurPageIndex())
        end)

end
function PerInformationLayer:head_callback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                    return
            end
            local tag=sender:getTag()
            if tag==25 then --返回
                self.head_csb:removeFromParent()
            elseif tag==24 then
                self.image_head:loadTexture(tostring("httpgame.pinlegame.comheadheadicon_" .. self.head_index .. ".jpg"))
                self.head_csb:removeFromParent()
            end
end
function PerInformationLayer:savedata( )
            local  gender="2"  --默认无
            if self.genderman:isSelected() then
                gender="true"
            elseif self.gendergirl:isSelected() then
                gender="false"
            end
	local  userdata=LocalData:Instance():get_user_data()
	local  loginname=userdata["loginname"]
	local  nickname=userdata["nickname"]  
	local  provincename="山东"
	local  cityid=1
	local  cityname="青岛"
	local  birthday =tostring(self.date_years:getString() .. self.date_month:getString() .. self.date_day:getString()) 
            local  provinceid=1 
            local  imageurl=self._index
            if self.head_index==100 then
                 imageurl= tostring(self._index) --
            else
                 imageurl=self.head_index  --"httpgame.pinlegame.comheadheadicon_" .. self.head_index .. ".jpg"
            end
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
  --   	     cell:addTouchEventListener(function(sender, eventType  )
		-- if sender:getPositionY()< birthday_years_y-self.qq*4 -50 or   sender:getPositionY()> birthday_years_y-self.qq*4 +50 then
  --                           local  www= math.abs(sender:getPositionY()-(birthday_years_y-self.qq*4)) 
  --                           print("减肥的快捷方式的发生的",sender:getPositionY())
  --                           -- for i=1,#table_years do
  --                           --      table_years[i]:setPositionY(table_years[i]:getPositionY()- www)
  --                           -- end
		-- end
	 --     end)
  --   	     birthday_scrollview:addTouchEventListener(function(sender, eventType  )
		-- if eventType ~= ccui.TouchEventType.ended then
		--          return
	 --           end
	 --           print("就是地方建设的快捷方式的")
	 --     end)
    	     


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
                      		self:init()
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
--拆分头像
function PerInformationLayer:trim (s) 
  return (string.gsub(s, "^%s*(.-)%s*$", "%1")) 
end 

function PerInformationLayer:chaifen(str)
        local index,b = string.find(str, '_');
        local strname = ' ';
        local dwnum = 0;
        if index then
                dwnum = string.sub(str, index+1,-1);
                strname = string.sub(str,1,index-1);
                strname = self:trim(strname)
        end
        return  dwnum 
end
return PerInformationLayer

















