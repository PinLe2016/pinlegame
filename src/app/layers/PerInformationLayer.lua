
--
local PerInformationLayer = class("PerInformationLayer", function()
            return display.newScene("PerInformationLayer")
end)
function PerInformationLayer:ctor()--params

       self:setNodeEventEnabled(true)--layer添加监听
       Server:Instance():getuserinfo() -- 初始化数据
       self.head_index=100 -- 初始化
     --self:init()
       self.secondOne = 0
       self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
                self:update(dt)
        end)

       --获取城市定位
       
       --手机归属请求
       Server:Instance():getusercitybyphone()--手机归属
end
function PerInformationLayer:init(  )
    --print("个人信息")
       self.Perinformation = cc.CSLoader:createNode("Perinformation.csb")
        self:addChild(self.Perinformation)
            
        self.birthday_bt=self.Perinformation:getChildByTag(26):getChildByTag(245)
        self.birthday_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
        local city_bt=self.Perinformation:getChildByTag(26):getChildByTag(244)
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
function  PerInformationLayer:city_init( )
         local userdt = LocalData:Instance():get_userdata()
         self._provincename=self.Perinformation:getChildByTag(90)
         self._provincename:setString(userdt["provincename"])
         self._cityname=self.Perinformation:getChildByTag(91)
         self._cityname:setString(userdt["cityname"])
         self._area=self.Perinformation:getChildByTag(92)
         self._area:setString(userdt["conty"])
end
--个人信息初始化
function PerInformationLayer:perinformation_init(  )

     local  userdata=LocalData:Instance():get_user_data() --用户数据
     local  userdatainit=LocalData:Instance():get_getuserinfo() --初始化个人信息
     -- dump(userdatainit)

     local userdt = LocalData:Instance():get_userdata()--
     userdt["birthday"]=userdatainit["birthday"]
     userdt["cityid"]=userdatainit["cityid"]
     userdt["cityname"]=userdatainit["cityname"]
     userdt["gender"]=userdatainit["gender"]
     -- userdt["golds"]=userdatainit["golds"]
     -- userdt["points"]=userdatainit["points"]
     userdt["provincename"]=userdatainit["provincename"]  
     userdt["conty"]=""
     LocalData:Instance():set_userdata(userdt)

    local  bg=self.Perinformation:getChildByTag(26)
    self.image_head=bg:getChildByTag(67)  --头像
        self._index=string.sub(tostring((self:chaifen(userdt["imageUrl"])),"."),1,1)
        self.image_head:loadTexture(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))
        local name=self.Perinformation:getChildByTag(68)  --名字
        name:setString(userdt["nickname"])
        local golds=self.Perinformation:getChildByTag(73)  --金币
        golds:setString(userdt["golds"])
        local rankname=self.Perinformation:getChildByTag(76)  --等级
        rankname:setString("LV." .. userdt["rankname"])

       
        local registereday=self.Perinformation:getChildByTag(86)  --注册日期
        registereday:setString(tostring(os.date("%Y年%m月%d日",userdt["registertime"])))
        self.genderman=self.Perinformation:getChildByTag(79)  --性别男
        self.gendergirl=self.Perinformation:getChildByName("CheckBox_2")  --getChildByTag(79)  --性别女
      
            --性别之间切换
            self.genderman:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.genderman:setSelected(true)
                            self.gendergirl:setSelected(false)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
            end)

            self.gendergirl: addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.genderman:setSelected(false)
                            self.gendergirl:setSelected(true)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
            end)
           


        if userdt["gender"]==0 then    --0女1男2未知
            self.genderman:setSelected(false)
            self.gendergirl:setSelected(true)
        elseif userdt["gender"]==1 then
            self.genderman:setSelected(true)
            self.gendergirl:setSelected(false)
        else
            self.genderman:setSelected(false)
            self.gendergirl:setSelected(false)
        end  
        --初始化年月日
        local date=Util:lua_string_split(os.date("%Y/%m/%d",userdt["birthday"]),"/")
        self.date_years=self.Perinformation:getChildByTag(87)
        self.date_month=self.Perinformation:getChildByTag(88)
        self.date_day=self.Perinformation:getChildByTag(89)
        self.date_years:setString(date[1])
        self.date_month:setString(date[2])
        self.date_day:setString(date[3])
        

        self:city_init()

end
function PerInformationLayer:touch_callback( sender, eventType )
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    --local activitypoints=LocalData:Instance():getactivitypoints_callback()
    local tag=sender:getTag()
    if tag==244 then --城市
        self:fun_city_info(  )
    elseif tag==245 then --生日
        self:fun_birthday(  )
    elseif tag==49 then 
                 if self.birthday then
                   
                    self.birthday:removeFromParent()
                 end
        
    elseif tag==59 then
                 if self.adress then
                    self:unscheduleUpdate()
                       self.adress:removeFromParent()
                 end
        
    elseif tag==83 then 
        self:savedata()   --  保存个人信息数据发送Http
    elseif tag==61 then   --个人信息主界面显示城市
        self:_savecity(  )
    elseif tag==48 then 
        self:_savetime()

    elseif tag==97 then 
                 if self.Perinformation then
                       --self.Perinformation:removeFromParent()
                       self:removeFromParent()
                 end
        
            elseif tag==67 then 
                        self:head()
    end
end
function PerInformationLayer:_savetime(  )
         
    local birthday_year=2016-self.birthday_Itempicker:getCellPos()--年
    local birthday_month=self.birthday_month_Itempicker:getCellPos()+1--月
    local birthday_day=self.birthday_daty_Itempicker:getCellPos()+1--日

    self.date_years:setString(birthday_year)
    self.date_month:setString(birthday_month)
    self.date_day:setString(birthday_day)

     self.birthday:removeFromParent()

end
function PerInformationLayer:_savecity(  )

         local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]
         local json_conty=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["areas"]

         local province=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["name"]--获取省份选择

         local city=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["name"] --获取城市选择
         local conty=json_conty[tonumber(self.adress_conty_Itempicker:getCellPos()+1)]["name"]---获取区选择

          local userdt = LocalData:Instance():get_userdata()--
          userdt["conty"]=conty  --自己保存的区

         self._provincename:setString(province) 
         self._cityname:setString(city) 
         self._area=self.Perinformation:getChildByTag(92)
          self:unscheduleUpdate()
         self.adress:removeFromParent()
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
                if  self.head_csb then
                    self.head_csb:removeFromParent()
               end
                
            elseif tag==24 then
                self.image_head:loadTexture(tostring("httpgame.pinlegame.comheadheadicon_" .. self.head_index .. ".jpg"))
                 if  self.head_csb then
                    self.head_csb:removeFromParent()
                end
               
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
    local  provincename=self._provincename:getString() 
    local  cityid=1
    local  cityname=self._cityname:getString() 
    --提交日期  和头像  时候  修改后  后台返回不变
    
    local  birthday_time =
    {
        day =self.date_day:getString(),
        month=self.date_month:getString(),
        year=self.date_years:getString()  
    } 
    -- 

    local birthday=Util:dateTotimestamp(birthday_time)
    print("birthday  ",birthday)
            local  provinceid=1 
            local  imageurl=self._index
            if self.head_index==100 then
                 imageurl= tostring(self._index) --
            else
                 imageurl=self.head_index  --"httpgame.pinlegame.comheadheadicon_" .. self.head_index .. ".jpg"
            end
    local params={
            loginname=loginname,
            nickname=nickname,
            provinceid=provinceid,
            provincename=provincename,
            cityid=cityid,
            cityname=cityname,
            birthday=birthday,
            gender=gender,
            imageurl=imageurl
        }
        dump(params)
    Server:Instance():setuserinfo(params) 
end
function PerInformationLayer:fun_birthday(  )
        self.birthday = cc.CSLoader:createNode("Birthday.csb")
        self:addChild(self.birthday)
        local birthday_back=self.birthday:getChildByTag(174):getChildByTag(49)
            birthday_back:addTouchEventListener(function(sender, eventType  )
            self:touch_callback(sender, eventType)
       end)
        local _true=self.birthday:getChildByTag(174):getChildByTag(48)
            _true:addTouchEventListener(function(sender, eventType  )
            self:touch_callback(sender, eventType)
       end)

        --年 
        local birthday_scrollview=self.birthday:getChildByTag(174):getChildByTag(170)
        local birthday_years=birthday_scrollview:getChildByTag(175)


        local height=birthday_years:getContentSize().height   
        local width=birthday_years:getContentSize().width
        local birthday_years_y= birthday_years:getPositionY()
        self.qq=height
        
        table_years={}
        self.birthday_Itempicker=self:addItemPickerData(birthday_scrollview,birthday_years)
        self.birthday:getChildByTag(174):addChild(self.birthday_Itempicker)

        for i=1,70+7 do   
            local button =self.birthday_Itempicker:getCellLayout(cc.size(100,50))
            local cell=ccui.Text:create()
            cell:setFontSize(38);
            cell:setAnchorPoint(cc.p(0.0,0.0));
            cell:setColor(cc.c4b(255,0,255))
            cell:setPositionX(5)
            if i<70+5 and i-5>=0 then 
                cell:setString(tostring(2016-(i-5)))
            else
                cell:setString(".")
                cell:setOpacity(0)
            end
            dump(button:getContentSize())
            cell:setTag(i)
            button:addChild(cell)
            self.birthday_Itempicker:pushBackItem(button)
        end
        -- 

        --月
        local birthday_scrollview2=self.birthday:getChildByTag(174):getChildByTag(171)
        local birthday_month=birthday_scrollview2:getChildByTag(176)
            -- local height_month=birthday_month:getContentSize().height   
        local birthday_month_y= birthday_month:getPositionY()

        self.birthday_month_Itempicker=self:addItemPickerData(birthday_scrollview2,birthday_month)
        self.birthday:getChildByTag(174):addChild(self.birthday_month_Itempicker)
        for i=1,12+7 do   

            local button =self.birthday_month_Itempicker:getCellLayout(cc.size(100,50))

            local cell_month=ccui.Text:create()
            cell_month:setFontSize(38);
            cell_month:setAnchorPoint(cc.p(0.0,0.0));
            cell_month:setColor(cc.c4b(255,0,255))
            cell_month:setPositionX(20)
            cell_month:setTag(i)
            if i<12+5 and i-5>=0 then 
                if i<14 then
                     cell_month:setString("0" .. tostring(i-4))
                else
                     cell_month:setString(tostring(i-4))
                end
            else
                cell_month:setString(".")
                cell_month:setOpacity(0)
            end

            button:addChild(cell_month)
            self.birthday_month_Itempicker:pushBackItem(button)
        end


        --日
        local birthday_scrollview3=self.birthday:getChildByTag(174):getChildByTag(173)
        local birthday_daty=birthday_scrollview3:getChildByTag(177)
  
        local birthday_daty_y= birthday_daty:getPositionY()

        self.birthday_daty_Itempicker=self:addItemPickerData(birthday_scrollview3,birthday_daty)
        self.birthday:getChildByTag(174):addChild(self.birthday_daty_Itempicker)
        for i=1,31+7 do   
            local button =self.birthday_daty_Itempicker:getCellLayout(cc.size(100,50))

            local cell_day=ccui.Text:create()
            cell_day:setFontSize(38);
            cell_day:setAnchorPoint(cc.p(0.0,0.0));
            cell_day:setColor(cc.c4b(255,0,255))
            cell_day:setPositionX(20)

            if i<31+5 and i-5>=0 then 
                if i<14 then
                     cell_day:setString("0" .. tostring(i-4))
                else
                     cell_day:setString(tostring(i-4))
                end
            else
                cell_day:setString(".")
                cell_day:setOpacity(0)
            end
            button:addChild(cell_day)
             -- birthday_scrollview2:addChild(cell_month)
            self.birthday_daty_Itempicker:pushBackItem(button)
              
        end
        -- self:scheduleUpdate()
end


function  PerInformationLayer:addItemPickerData(scorll,size)

    local dex=0--960-display.height
    local picker =cc.ItemPicker:create()
    picker:setDirection(scorll:getDirection())
    picker:setContSize(cc.size(150, 400))--
    -- picker:setInnerContainerSize(cc.size(220,50*34))
    picker:setParameter(cc.size(100,50),8)
    picker:setPosition(scorll:getPositionX(),scorll:getPositionY())
    picker:setAnchorPoint(0,0)
    scorll:removeFromParent()
    
    return picker;
end

function  PerInformationLayer:add_addItemPickerData(scorll,size)

    local dex=0--960-display.height
    local picker =cc.ItemPicker:create()
    picker:setDirection(scorll:getDirection())
    picker:setContSize(size)--cc.size(150, 200)
    -- picker:setInnerContainerSize(cc.size(220,50*34))
    picker:setParameter(cc.size(size.width,40),5)--cc.size(140,40)
    picker:setPosition(scorll:getPositionX(),scorll:getPositionY())
    picker:setAnchorPoint(0,0)
    scorll:removeFromParent()
    
    return picker;
end



function PerInformationLayer:fun_city_info( )
        self.adress = cc.CSLoader:createNode("Adress.csb")
        self:addChild(self.adress)
        local city_back=self.adress:getChildByTag(52):getChildByTag(59)
        city_back:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
         local save=self.adress:getChildByTag(52):getChildByTag(61)
         save:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
        --省
        local province_scrollview=self.adress:getChildByTag(52):getChildByTag(62)
        local province_text=province_scrollview:getChildByTag(95)
          
        local adress_province_y= province_text:getPositionY()

        self.adress_province_Itempicker=self:add_addItemPickerData(province_scrollview,cc.size(100, 200))
        self.adress:getChildByTag(52):addChild(self.adress_province_Itempicker)

        --市
        local city_scrollview=self.adress:getChildByTag(52):getChildByTag(63)
        local city_text=city_scrollview:getChildByTag(96)

        self.adress_city_Itempicker=self:add_addItemPickerData(city_scrollview,cc.size(230, 200))
        self.adress_city_Itempicker:setPositionX(self.adress_city_Itempicker:getPositionX()-70)
        self.adress:getChildByTag(52):addChild(self.adress_city_Itempicker)

        --区
        local area_scrollview=self.adress:getChildByTag(52):getChildByTag(64)
        local area_text=area_scrollview:getChildByTag(97)
        
        self.adress_conty_Itempicker=self:add_addItemPickerData(area_scrollview,cc.size(200, 200))
        self.adress_conty_Itempicker:setPositionX(self.adress_conty_Itempicker:getPositionX())
        self.adress:getChildByTag(52):addChild(self.adress_conty_Itempicker)

        local  userdata=LocalData:Instance():get_getuserinfo()
        -- dump(userdata)
        --如果获取定位信息，优先级最高，如果没有获取定位信息获取 手机号归属
        self.province="1"
        self.city="2"
        self.conty="3"
        local pinle_location=cc.PinLe_platform:Instance()
        dump(pinle_location:getProvince())
        if pinle_location:getProvince()~= "" then --手机定位
            self.province=pinle_location:getProvince()
            self.city=pinle_location:getCity()
            self.conty=pinle_location:getCounty()
            -- print("111111--------")
        else
            --手机归属--缺少接口
            local phone_location=LocalData:Instance():getusercitybyphone()--获取手机号信息
            -- 
            dump(phone_location)
            self.province=phone_location["provincename"]
            self.city=phone_location["cityname"]
            self.conty="1"
        end
        dump(pinle_location:getProvince())
        dump(pinle_location:getCity())
        dump(pinle_location:getCounty())
        -- self.province=userdata["provincename"]
        -- self.city=userdata["cityname"]
        -- self.conty="崂山区"
        self.province_index=-1
        self.city_index=-1

        self.city_data=Util:read_json("res/city.json")

        self:fun_Province()
        -- self:fun_City()
        -- self:fun_Conty()
        self:scheduleUpdate()
end

function PerInformationLayer:fun_Province( ... )
    self.adress_province_Itempicker:clearItems()
    self.adress_province_Itempicker:removeAllChildren()

    local json_province=self.city_data["provinces"]
    local m_offset_cell=0
    for i=1,#json_province+4 do   

        local button =self.adress_province_Itempicker:getCellLayout(cc.size(100,40))
        local name
        if i<#json_province+3 and i-2>0 then 
            local cell_month=ccui.Text:create()
            cell_month:setFontSize(34)
            cell_month:setAnchorPoint(cc.p(0.5,0.0));
            cell_month:setColor(cc.c4b(255,0,255))
            cell_month:setPositionX(55)
            cell_month:setTag(i)

            button:addChild(cell_month)

            
            cell_month:setString(json_province[i-2]["name"])
            name=json_province[i-2]["name"]
           local pos = string.find(self.province, name)   
            if pos then
                m_offset_cell=i-3;
            end
        end

        
         self.adress_province_Itempicker:pushBackItem(button)
    end
    self.adress_province_Itempicker:setOffsetLayout(m_offset_cell)

end

function PerInformationLayer:fun_City()
    
    self.adress_city_Itempicker:clearItems()
    self.adress_city_Itempicker:removeAllChildren()
    dump(tonumber(self.adress_province_Itempicker:getCellPos()))

    local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]
    dump(json_city)
    if #json_city==0 then
        return
    end
    -- local json_city=self.city_data["provinces"][29]["citys"]
    -- dump(json_city)
    local m_offset_cell=0
    for i=1,#json_city+4 do   

        local button =self.adress_city_Itempicker:getCellLayout(cc.size(230,40))
        local name
        if i<#json_city+3 and i-2>0 then 
            local cell_month=ccui.Text:create()
            cell_month:setFontSize(22)
            cell_month:setAnchorPoint(cc.p(0.5,0.0));
            cell_month:setColor(cc.c4b(255,0,255))
            cell_month:setPositionX(140)
            cell_month:setTag(i)

            button:addChild(cell_month)

            
            cell_month:setString(json_city[i-2]["name"])
            name=json_city[i-2]["name"]
           local pos = string.find(self.city, name)   
            if pos then

                m_offset_cell=i-3;
            end
        end

        self.adress_city_Itempicker:pushBackItem(button)
    end
    dump(m_offset_cell)
    self.adress_city_Itempicker:setOffsetLayout(m_offset_cell)
end

function PerInformationLayer:fun_Conty()
    self.adress_conty_Itempicker:clearItems()
    self.adress_conty_Itempicker:removeAllChildren()

    local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]
    -- local json_city=self.city_data["provinces"][29]["citys"]
    if #json_city==0 then
        return
    end
    local json_conty=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["areas"]
    if #json_conty==0 then
        return
    end
    -- local json_conty=json_city[8]["areas"]
    -- dump(self.adress_city_Itempicker:getCellPos())
    -- dump(json_conty)
    local m_offset_cell=0
    for i=1,#json_conty+4 do   

        local button =self.adress_conty_Itempicker:getCellLayout(cc.size(170,40))
        local name
        if i<#json_conty+3 and i-2>0 then 
            local cell_month=ccui.Text:create()
            cell_month:setFontSize(22)
            cell_month:setAnchorPoint(cc.p(0.0,0.0));
            cell_month:setColor(cc.c4b(255,0,255))
            cell_month:setPositionX(20)
            cell_month:setTag(i)

            button:addChild(cell_month)

            
            cell_month:setString(json_conty[i-2]["name"])
            name=json_conty[i-2]["name"]
           local pos = string.find(self.conty, name)   
            if pos then
                m_offset_cell=i-3;
            end
        end

        self.adress_conty_Itempicker:pushBackItem(button)
    end
    self.adress_conty_Itempicker:setOffsetLayout(m_offset_cell)
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

function PerInformationLayer:update(dt)
    self.secondOne = self.secondOne+dt
    if self.secondOne <0.5 then return end
    self.secondOne=0
    local is_change=false
    if self.province_index~=self.adress_province_Itempicker:getCellPos() then
        self:fun_City()
        self.province_index=self.adress_province_Itempicker:getCellPos()
        is_change=true
        print("111----",self.city_index,self.adress_city_Itempicker:getCellPos())
    end

    if self.city_index~= self.adress_city_Itempicker:getCellPos() or is_change then
         self:fun_Conty()
         self.city_index=self.adress_city_Itempicker:getCellPos()

    end

end

--城市相关数据保存
function PerInformationLayer:about_city_http_date()

    local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]
    local json_conty=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["areas"]

    local province=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["name"]--获取省份选择
    
    local city=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["name"] --获取城市选择
    -- dump(json_conty)
    local conty=json_conty[tonumber(self.adress_conty_Itempicker:getCellPos()+1)]["name"]---获取区选择


    dump(province)
    dump(city)
    dump(conty)
end

--生日相关数据保存
function PerInformationLayer:about_birthday_http_date()
    local birthday_year=2016-self.birthday_Itempicker:getCellPos()--年
    local birthday_month=self.birthday_month_Itempicker:getCellPos()+1--月
    local birthday_day=self.birthday_daty_Itempicker:getCellPos()+1--日

    dump(birthday_year)
    dump(birthday_month)
    dump(birthday_day)
end

return PerInformationLayer

















