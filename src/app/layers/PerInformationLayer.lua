LocalData:Instance():get_userdata()
--
local PerInformationLayer = class("PerInformationLayer", function()
            return display.newScene("PerInformationLayer")
end)
function PerInformationLayer:ctor()--params
       self:setNodeEventEnabled(true)--layer添加监听
       -- Server:Instance():getuserinfo() -- 初始化数据
       self.head_index=100 -- 初始化
       self.main_leve={0,500,1500,8000,15000,40000,80000,150000,400000,80000,2000000,5000000}
     --self:init()
       self.secondOne = 0
       self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
                self:update(dt)
        end)

       --获取城市定位
       
       --手机归属请求
       Server:Instance():getusercitybyphone()--手机归属

       self:add_init()
end
--新增的个人信息界面
function PerInformationLayer:add_init(  )
             self.fragment_sprite  = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
             self.fragment_sprite:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
             self:addChild(self.fragment_sprite)
     
              self.showinformation = cc.CSLoader:createNode("showinformation.csb")
              self:addChild(self.showinformation)
              self:move_layer(self.showinformation)
              
                 local  userdata=LocalData:Instance():get_user_data() --用户数据
                 local  userdatainit=LocalData:Instance():get_getuserinfo() --初始化个人信息

                 local userdt = LocalData:Instance():get_userdata()--
                 if userdatainit["birthday"] or userdatainit["birthday"] ~= "" then
                     userdt["birthday"]=userdatainit["birthday"]
                 else
                     userdt["birthday"]=tonumber(645379200)
                 end
                 
                 userdt["cityid"]=userdatainit["cityid"]
                 userdt["cityname"]=userdatainit["cityname"]
                 userdt["gender"]=userdatainit["gender"]
                 if userdatainit["gender"] == nil then
                     userdt["gender"]=1
                 end
                 
                 userdt["nickname"]=userdatainit["nickname"]
                 userdt["provincename"]=userdatainit["provincename"]  
                 userdt["districtame"]=userdatainit["districtame"]
                 userdt["registertime"]=userdatainit["registertime"]  
                if userdt["provincename"] == nil  then
                    local phone_location=LocalData:Instance():getusercitybyphone()--获取手机号信息
                    if phone_location["provincename"] then
                            userdt["provincename"]=phone_location["provincename"]
                            userdt["cityname"]=phone_location["cityname"]
                            userdt["districtame"]=""
                    else
                       userdt["provincename"]="北京"
                        userdt["cityname"]="北京"
                        userdt["districtame"]="海淀区"
                    end
                end 
                  LocalData:Instance():set_userdata(userdt)
                local haerd=userdatainit["imageUrl"]
                    self.image_head1=self.showinformation:getChildByTag(1401)  --头像
                      self._index=string.sub(haerd,-5,-5)--string.sub(tostring((self:chaifen(userdt["imageUrl"])),"."),1,1)
                    -- dump(LocalData:Instance():get_user_head())
                    -- dump(tonumber(self._index))
                   
                    local haer=LocalData:Instance():get_user_head()   --string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index))
                     -- dump(haer)
                    userdt["registertime"]=userdatainit["registertime"]  
                    -- xin LocalData:Instance():set_userdata(userdt)
                    self.image_head1:loadTexture(haer)--(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))
                    


                    self._Pname1=self.showinformation:getChildByTag(1402) --名字Dphone_text
                    -- dump(userdt["nickname"])
                    local nickname=userdata["loginname"]
                    local nick_sub=string.sub(nickname,1,3)
                    nick_sub=nick_sub.."****"..string.sub(nickname,8,11)
                    --dump(userdt)
                    if userdt["nickname"]~="" then
                        nick_sub=userdt["nickname"]
                    end
                    self._Pname1:setString(nick_sub)
                   local _question=self.showinformation:getChildByTag(1820)   --问号
                   _question:setVisible(false)
                    local golds=self.showinformation:getChildByTag(1413)   --金币
                    golds:setString(userdt["golds"])
                    local rankname=self.showinformation:getChildByTag(1414)   --等级
                    rankname:setString("LV."  ..   userdt["grade"])

                    local LV_name=self.showinformation:getChildByTag(1819)   --等级
                     LV_name:setString(userdt["rankname"])
                     local loadingbar=self.showinformation:getChildByTag(1817)-- 等级进度条
                   --local jindu=tonumber(userdt["points"]) /  self.main_leve[tonumber(userdt["grade"])+2]  *  100 --self.main_leve[+1]/5000000 *100
                   local jindu=tonumber(userdt["points"]) /  self.main_leve[tonumber(userdt["grade"])+1]  *  100
                   loadingbar:setPercent(jindu)

                   
                    local registereday=self.showinformation:getChildByTag(1412)  --注册日期
                    registereday:setString(tostring(os.date("%Y",userdt["registertime"])))
                     local registereday1=self.showinformation:getChildByTag(123)  --注册日期
                    registereday1:setString("-"  ..   tostring(os.date("%m",userdt["registertime"])))
                     local registereday2=self.showinformation:getChildByTag(124)  --注册日期
                    registereday2:setString("-"  .. tostring(os.date("%d",userdt["registertime"])))
                    self.genderman1=self.showinformation:getChildByTag(1403)  --性别
                    self.genderman1_image=self.showinformation:getChildByTag(202)  --性别图片
                   
                    if userdt["gender"]==0 then    --0女1男2未知
                        self.genderman1:setString("女")
                        self.genderman1_image:loadTexture("png/IcnFemale.png")
                    elseif userdt["gender"]==1 then
                        self.genderman1:setString("男")
                        self.genderman1_image:loadTexture("png/IcnMale.png")
                    else
                        self.genderman1:setString(" ")
                    end  
        --初始化年月日
                local date=Util:lua_string_split(os.date("%Y/%m/%d",userdt["birthday"]),"/")
                self.date_years1=self.showinformation:getChildByTag(1404)
                self.date_years1:setString(date[1] .. "-" ..  date[2] .. "-" .. date[3] )
       

                 self._provincename1=self.showinformation:getChildByTag(1405)
                 local area=""
                 if userdt["districtame"] then
                     area=userdt["districtame"]
                 end
               
                 -- dump(userdt["cityname"])
                 if userdt["provincename"] then
                     self._provincename1:setString(userdt["provincename"] .. "-" .. userdt["cityname"] .. "-" .. area)
                     if area  == "" then
                         self._provincename1:setString(userdt["provincename"] .. "-" .. userdt["cityname"] )
                     end
                 end
                 

                local back_bt=self.showinformation:getChildByTag(1399)  --返回
                back_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_back(sender, eventType)
                 end)

                local Modify_bt=self.showinformation:getChildByTag(1410)  --修改
                Modify_bt:addTouchEventListener(function(sender, eventType  )
                      if eventType ~= ccui.TouchEventType.ended then
                            return
                        end
                     self:init()
                     self:head()
                 end)

                 local mail_bt=self.showinformation:getChildByTag(190)  --填写邮件信息
                mail_bt:addTouchEventListener(function(sender, eventType  )
                       if eventType ~= ccui.TouchEventType.ended then
                            sender:setScale(0.8)
                            return
                        end
                     sender:setScale(1)
                     Server:Instance():getconsignee({functionparams=""})
                 end)
            --  新增加的绑定微信
            self.per_ListView=self.showinformation:getChildByTag(1821)--  绑定列表
            self.per_ListView:setVisible(false)
            self.per_ListView:setItemModel(self.per_ListView:getItem(0))
            for i=2,2 do  --self.tablecout+
                        self.per_ListView:pushBackDefaultItem()
                        local  cell = self.per_ListView:getItem(i-1)
                        local Panel_image=cell:getChildByTag(1824)
                        Panel_image:loadTexture("png/shenfen-xiao.png")
                        local Panel_text=cell:getChildByTag(1825)
                        Panel_text:setString("身份证认证")
            end
end
--新增加的邮件界面
function PerInformationLayer:fun_mail(  )
        local _getconsignee = LocalData:Instance():get_getconsignee()--保存数据

        self.Receivinginformation = cc.CSLoader:createNode("Receivinginformation.csb")
        self:addChild(self.Receivinginformation)
           local move = cc.MoveTo:create(0.5, cc.p(0,0))
        self.Receivinginformation:runAction(cc.Sequence:create(move))
        local back_bt=self.Receivinginformation:getChildByTag(220):getChildByTag(234)  --返回
        back_bt:addTouchEventListener(function(sender, eventType  )
              self:touch_back(sender, eventType)
         end)
        local determine_bt=self.Receivinginformation:getChildByTag(220):getChildByTag(235)  --确定
        determine_bt:addTouchEventListener(function(sender, eventType  )
              self:touch_back(sender, eventType)
         end)
        self.ads_bg=self.Receivinginformation:getChildByTag(119)
        self.ads_bg:setVisible(false)
        local ads_bt=self.Receivinginformation:getChildByTag(220):getChildByTag(227)  --所在地区
        ads_bt:setVisible(true)
        if self.ads_bg:isVisible() then
            ads_bt:setTouchEnabled(false)
        else
            ads_bt:setTouchEnabled(true)
        end
        ads_bt:addTouchEventListener(function(sender, eventType  )
              self:touch_back(sender, eventType)
         end)
        
        local false_bt=self.Receivinginformation:getChildByTag(119):getChildByTag(146)  --取消选择地址
        false_bt:addTouchEventListener(function(sender, eventType  )
              self:touch_back(sender, eventType)
         end)
        local true_bt=self.Receivinginformation:getChildByTag(119):getChildByTag(147)  --确定选择地址
        true_bt:addTouchEventListener(function(sender, eventType  )
              self:touch_back(sender, eventType)
         end)
         local em_bg=self.Receivinginformation:getChildByTag(220)
         local name_field=em_bg:getChildByTag(229)
         local phone_field=em_bg:getChildByTag(230)
         local adm_field=em_bg:getChildByTag(231)
         local name_g=em_bg:getChildByTag(225)
         --name_g:setVisible(false)
         local phone_g=em_bg:getChildByTag(226)
         --phone_g:setVisible(false)
         local adm_g=em_bg:getChildByTag(228)
         --adm_g:setVisible(false)

--新增的邮件box控件
    local res = " "--res/png/gerenxinxi-shang-1.png"
    local width = 300
    local height = 30
    
    self.name_text_mail = ccui.EditBox:create(cc.size(width,height),res)
    em_bg:addChild(self.name_text_mail)
    self.name_text_mail:setPosition(cc.p(name_field:getPositionX(),name_field:getPositionY()))--( cc.p(130,438 ))  
    self.name_text_mail:setPlaceholderFontColor(cc.c3b(250, 250, 250))

    if _getconsignee["name"] == "" then
        self.name_text_mail:setPlaceHolder("您的姓名")
    else
        self.name_text_mail:setPlaceHolder( tostring(_getconsignee["name"]))
    end
    
    self.name_text_mail:setAnchorPoint(0,0.5)  
    self.name_text_mail:setMaxLength(11)

    self.phone_text_mail = ccui.EditBox:create(cc.size(width,height),res)
    em_bg:addChild(self.phone_text_mail)
    self.phone_text_mail:setPosition(cc.p(phone_field:getPositionX(),phone_field:getPositionY()))--( cc.p(130,438 ))  
    self.phone_text_mail:setPlaceholderFontColor(cc.c3b(250, 250, 250))
     if _getconsignee["phone"] == "" then
        self.phone_text_mail:setPlaceHolder("您的手机号")
    else
        self.phone_text_mail:setPlaceHolder( tostring(_getconsignee["phone"]))
    end

    self.phone_text_mail:setAnchorPoint(0,0.5)  
    self.phone_text_mail:setMaxLength(11)

    local res1 = "  "--res/png/gerenxinxi-xia-kuang-da.png"
    local width1 = 300
    local height1 = 89

    self.ads_text_mail = ccui.EditBox:create(cc.size(width1,height1),res1)
    self.ads_text_mail:setFont("Arial",20)
    self.ads_text_mail:setPlaceholderFont("Arial",20)
    em_bg:addChild(self.ads_text_mail)
    self.ads_text_mail:setPosition(cc.p(adm_field:getPositionX(),adm_field:getPositionY()))--( cc.p(130,323 ))  
    self.ads_text_mail:setPlaceholderFontColor(cc.c3b(250, 250, 250))





    if _getconsignee["address"] == "" then
         self.ads_text_mail:setPlaceHolder("详细地址")
    else

        self.ads_text_mail:setText(_getconsignee["address"])
    end
    self.diqu=self.Receivinginformation:getChildByTag(220):getChildByTag(233)
    if _getconsignee["provincename"]  then 

        self.diqu:setPlaceHolder(tostring(_getconsignee["provincename"])  ..   tostring(_getconsignee["cityname"]))
    end
    self.ads_text_mail:setAnchorPoint(0,0.5) 
    --self.ads_text_mail:setContentSize(300,40)  
    -- self.ads_text_mail:setFontSize(0.2)
     --self.ads_text_mail:setFontName("Arial")
    --  self.ads_text_mail:setFontSize(5)
    -- self.ads_text_mail:setMaxLength(100)

        self.mail_h=0
        self.mail_dex=0
     --省
        local province_scrollview=self.Receivinginformation:getChildByTag(119):getChildByTag(149)
        -- local province_text=province_scrollview:getChildByTag(95)
          
        -- local adress_province_y= province_text:getPositionY()

        self.adress_province_Itempicker=self:add_addItemPickerData(province_scrollview,cc.size(130, 200))
        self.Receivinginformation:getChildByTag(119):addChild(self.adress_province_Itempicker)

        --市
        local city_scrollview=self.Receivinginformation:getChildByTag(119):getChildByTag(150)
        -- local city_text=city_scrollview:getChildByTag(96)

        self.adress_city_Itempicker=self:add_addItemPickerData(city_scrollview,cc.size(230, 200))
        self.adress_city_Itempicker:setPositionX(self.adress_city_Itempicker:getPositionX())
        self.Receivinginformation:getChildByTag(119):addChild(self.adress_city_Itempicker)

        --区
        local area_scrollview=self.Receivinginformation:getChildByTag(119):getChildByTag(151)
        -- local area_text=area_scrollview:getChildByTag(97)
        
        self.adress_conty_Itempicker=self:add_addItemPickerData(area_scrollview,cc.size(200, 200))
        self.adress_conty_Itempicker:setPositionX(self.adress_conty_Itempicker:getPositionX()+20)
        self.Receivinginformation:getChildByTag(119):addChild(self.adress_conty_Itempicker)


        --如果获取定位信息，优先级最高，如果没有获取定位信息获取 手机号归属
        self.province="1"
        self.city="2"

        self.conty="1"


        self.province_index=-1
        self.city_index=-1

        -- if _getconsignee["provincename"]  then 
        --     self.province=tostring(_getconsignee["provincename"])
        --     self.city=tostring(_getconsignee["cityname"])
        -- else
            local phone_location=LocalData:Instance():getusercitybyphone()--获取手机号信息
 
            if phone_location then
                print("手机归属")
                self.province=phone_location["provincename"]
                self.city=phone_location["cityname"]
            end
            -- self.conty="1"
        -- end


        self.city_data=Util:read_json("res/city.json")

        self:fun_Province()
        -- self:fun_City()
        -- self:fun_Conty()
        self:scheduleUpdate()

end


function PerInformationLayer:touch_back( sender, eventType )
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    --local activitypoints=LocalData:Instance():getactivitypoints_callback()
    local tag=sender:getTag()
    if tag==1399 then --返回
        if self.showinformation then
            if  tostring(LocalData:Instance():get_per())  ==  "1" then
                self.fragment_sprite:setVisible(false)
                 self:removeFromParent()
                 LocalData:Instance():set_per("0")
                 return
            end
            self:removeFromParent()
            Util:all_layer_backMusic()
            --Util:scene_control("MainInterfaceScene")
            
        end
    elseif  tag==1410 then
         self:init()

    elseif  tag==190 then
        Server:Instance():getconsignee({functionparams=""})
        -- self:fun_mail()
    elseif  tag==234 then
         if self.Receivinginformation then
            self:unscheduleUpdate()
            self.phone_text_mail=nil
             self.Receivinginformation:removeFromParent()
         end
    elseif  tag==235 then
         print("确定")
         if self.name_text_mail:isVisible() then
             self.name_text_mail:setVisible(false)
             self.phone_text_mail:setVisible(false)
            self.ads_text_mail:setVisible(false)
        else
             self.name_text_mail:setVisible(true)
             self.phone_text_mail:setVisible(true)
             self.ads_text_mail:setVisible(true)
         end
         
         self:save_mail(1)
    elseif  tag==227 then
         self.ads_bg:setVisible(true)
    elseif  tag==146 then
        self.ads_bg:setVisible(false)
    elseif  tag==147 then
        self:save_mail(2)
        self.ads_bg:setVisible(false)
         print("确定选择地址")
    end
end

-- cath 1 保存邮寄信息上传服务器
--      2 选择邮寄城市的确认
function PerInformationLayer:save_mail(cath)

    local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]

    local json_conty=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["areas"]

    local province=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["name"]--获取省份选择

    local city=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["name"] --获取城市选择


    local conty=""
    if next(json_conty) then
        conty=json_conty[tonumber(self.adress_conty_Itempicker:getCellPos()+1)]["name"]---获取区选择
    end
    


    local province_id=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["id"]--所选省份ID
    local city_id=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["id"]--所选城市ID

    --  dump(province_id)
    -- dump(city_id)
    --  dump(province)
    --  dump(city)
    --  dump(conty)

    if cath==1 then
        --服务器保存收货地址
       Server:Instance():setconsignee(self.name_text_mail:getText(),self.phone_text_mail:getText(),tostring(province_id),tostring(city_id),self.ads_text_mail:getText(),province,city)
          if self.Receivinginformation then
             self:unscheduleUpdate()
             self.phone_text_mail=nil
             self.Receivinginformation:removeFromParent()
          end

       return
    end
        --save_mail
    self.Receivinginformation:getChildByTag(220):getChildByTag(233):setPlaceHolder(province..city..conty)
    
end
function PerInformationLayer:move_layer(_layer)
     
    local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(1.5,cc.p(_layer:getPositionX(),curr_y))  
      local sque=transition.sequence({cc.EaseElasticOut:create(move)})
      _layer:runAction(sque)
end

function PerInformationLayer:init(  )
       
       -- self.fragment_sprite1  = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
       --   self.fragment_sprite1:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
       --   self:addChild(self.fragment_sprite1)
       self.Perinformation = cc.CSLoader:createNode("Perinformation.csb")
       self:addChild(self.Perinformation)
        local userdt = LocalData:Instance():get_userdata()
        local gold=self.Perinformation:getChildByTag(1884):getChildByTag(1886)  --  金币
         gold:setString(userdt["golds"])

       --self:move_layer(self.Perinformation)
       self._birthday_bt=self.Perinformation:getChildByTag(1882)  --  生日
        self._birthday_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
        self._adress_bt=self.Perinformation:getChildByTag(1883)  --   地址
        self._adress_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)

        self.birthday_bt=self.Perinformation:getChildByTag(26):getChildByTag(245)
        self.birthday_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
        local city_bt=self.Perinformation:getChildByTag(26):getChildByTag(244)
        city_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
        local true_bt=self.Perinformation:getChildByTag(83)  --确定
        self._turebut=true_bt
        true_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
        local back_bt=self.Perinformation:getChildByTag(97)  --返回
        back_bt:addTouchEventListener(function(sender, eventType  )
        self:touch_callback(sender, eventType)
    end)
            local head_bt=self.Perinformation:getChildByTag(26):getChildByTag(67)  --头像
            head_bt:setTouchEnabled(false)
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
         local  between=self.Perinformation:getChildByTag(26):getChildByTag(95)
         local area=""
         if userdt["districtame"] then
             area=userdt["districtame"]
         end
         self._area:setString(area)
         self._area:setVisible(true)
         if area== "" then
             self._area:setVisible(false)
             between:setVisible(false)
         end
end
--个人信息初始化
function PerInformationLayer:perinformation_init(  )

     local  userdata=LocalData:Instance():get_user_data() --用户数据
     local  userdatainit=LocalData:Instance():get_getuserinfo() --初始化个人信息

     local userdt = LocalData:Instance():get_userdata()--
     userdt["birthday"]=userdatainit["birthday"]
     userdt["cityid"]=userdatainit["cityid"]
     userdt["cityname"]=userdatainit["cityname"]
     userdt["gender"]=userdatainit["gender"]
     print("正是新别 ",userdatainit["gender"])
      if userdatainit["gender"]  ==  nil  then
         userdt["gender"]=1
     end
     userdt["nickname"]=userdatainit["nickname"]
     userdt["registertime"]=userdatainit["registertime"]
     userdt["provincename"]=userdatainit["provincename"]  
     userdt["districtame"]=userdatainit["districtame"] 
     if userdt["provincename"] == nil  then
            local phone_location=LocalData:Instance():getusercitybyphone()--获取手机号信息
            if phone_location then
                userdt["provincename"]=phone_location["provincename"]
                userdt["cityname"]=phone_location["cityname"]
                userdt["districtame"]=""
            end
      end 
     LocalData:Instance():set_userdata(userdt)  --必须打开

    local  bg=self.Perinformation:getChildByTag(26)
    self.image_head=bg:getChildByTag(67)  --头像
        -- self._index=string.sub(tostring((self:chaifen(userdt["imageUrl"])),"."),1,1)
        -- dump(LocalData:Instance():get_user_head())
        local haer=LocalData:Instance():get_user_head()   --string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index))
        self.image_head:loadTexture(haer)--(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))
        
        self.Dphone_text=self.Perinformation:getChildByTag(68)  --名字Dphone_text
        self.Dphone_text:setTouchEnabled(false)
        self.Dphone_text:setVisible(false)
        local res = " "--res/png/DLkuang.png
        local width = 265
        local height = 45
        --登陆
        self._Pname = ccui.EditBox:create(cc.size(width,height),res)
        self._Pname:setPlaceholderFontColor(cc.c3b(234,82,30))
        self._Pname:setFontColor(cc.c3b(234,82,30))
        self.Perinformation:addChild(self._Pname)
        self._Pname:setVisible(true)
        self._Pname:setPosition(cc.p(self.Dphone_text:getPositionX(),self.Dphone_text:getPositionY()))--( cc.p(107,77 ))  
       
        local nickname=userdata["loginname"]
        -- dump(nickname)
        local nick_sub=string.sub(nickname,1,3)
        nick_sub=nick_sub.."****"..string.sub(nickname,8,11)
        -- dump(userdt)
        if userdt["nickname"]~="" then
            if nick_sub~=userdt["nickname"] then
                self._Pname:setTouchEnabled(false)--只能修改一次
            end
            nick_sub=userdt["nickname"]
        end
        -- self._Pname:setPlaceHolder(nick_sub)
        self._Pname:setText(nick_sub)
        self._Pname:setAnchorPoint(0,0.5)  
        self._Pname:setMaxLength(6)

        --self._Pname:setString(userdt["nickname"])
        local golds=self.Perinformation:getChildByTag(73)  --金币
        golds:setString(userdt["golds"])
        local rankname=self.Perinformation:getChildByTag(76)  --等级
        rankname:setString( userdt["rankname"])

       
        local registereday=self.Perinformation:getChildByTag(86)  --注册日期
        registereday:setString(tostring(os.date("%Y",userdt["registertime"])))  --
        local registereday2=self.Perinformation:getChildByTag(192)  --注册日期
        registereday2:setString("-"  .. tostring(os.date("%m",userdt["registertime"])))  --
        local registereday3=self.Perinformation:getChildByTag(193)  --注册日期
        registereday3:setString("-"  .. tostring(os.date("%d",userdt["registertime"])))  --
        self.genderman=self.Perinformation:getChildByTag(79)  --性别男
        self.gendergirl=self.Perinformation:getChildByName("CheckBox_2")  --getChildByTag(79)  --性别女
      
            --性别之间切换
            self.genderman:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.genderman:setSelected(true)
                            self.gendergirl:setSelected(false)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             self.genderman:setSelected(false)
                             self.gendergirl:setSelected(true)
                     end
            end)

            self.gendergirl: addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.genderman:setSelected(false)
                            self.gendergirl:setSelected(true)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             self.genderman:setSelected(true)
                             self.gendergirl:setSelected(false)
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
        self.scall_years="1990"
        self.scall_month="06"
        self.scall_day="07"

        if userdt["birthday"]~="" then
            self.scall_years=tostring(date[1])
            self.scall_month=tostring(date[2])
            self.scall_day=tostring(date[3])
        end

        self:city_init()

end
function PerInformationLayer:touch_callback( sender, eventType )
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    --local activitypoints=LocalData:Instance():getactivitypoints_callback()
    local tag=sender:getTag()
    if tag==1883 then --城市
        self:fun_city_info(  )
    elseif tag==1882 then --生日
        self._Pname:setTouchEnabled(false)
        self:fun_birthday(  )
    elseif tag==169 then 
                self:_savetime()
                self._Pname:setTouchEnabled(true)
                
                 self:removeChildByTag(7878,true)
        
    elseif tag==51 then
                 self:_savecity(  )
                
                    self:unscheduleUpdate()
                       self:removeChildByTag(250, true)

               
        
    elseif tag==83 then 
         self._Pname:setVisible(false)
         self._turebut:setTouchEnabled(false)
         self:removeChildByTag(9888, true)
         local function stopAction()
                self._turebut:setTouchEnabled(true)
       end
      local callfunc = cc.CallFunc:create(stopAction)
      self._turebut:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
        self:savedata()   --  保存个人信息数据发送Http
    elseif tag==59 then   --个人信息主界面显示城市
                self:_savecity(  )
                self:unscheduleUpdate()
                self:removeChildByTag(250, true)
    elseif tag==49 then 
                self:_savetime()
                self._Pname:setTouchEnabled(true)
                 self:removeChildByTag(7878,true)
    elseif tag==97 then 
                 if self.Perinformation then
                    self._Pname=nil
                     --self.fragment_sprite1:setVisible(false)
                       self.Perinformation:removeFromParent()
                       

                 end
          
   elseif tag==67 then 
                 self._Pname:setVisible(false)
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
self.date_years1:setString(birthday_year .. "-" ..  birthday_month .. "-" .. birthday_day) 
     self.birthday:removeFromParent()

end
function PerInformationLayer:_savecity(  )

         local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]
         local json_conty=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["areas"]

         local province=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["name"]--获取省份选择

         local city=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["name"] --获取城市选择
         -- local conty=json_conty[tonumber(self.adress_conty_Itempicker:getCellPos()+1)]["name"]---获取区选择
         local city_id=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["id"]--所选城市ID
        local province_id=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["id"]--所选省份ID

         local conty=""
        if next(json_conty) then
            conty=json_conty[tonumber(self.adress_conty_Itempicker:getCellPos()+1)]["name"]---获取区选择
        end

          local userdt = LocalData:Instance():get_userdata()--
          userdt["conty"]=conty  --自己保存的区
         
         self._provincename:setString(" ") 
         self._cityname:setString(" ") 
         self._area:setString(" ") 

         if  self.city_present:isSelected() then   --待修改
             self._provincename:setString(self.city_now[1]) 
             self._cityname:setString(self.city_now[2]) 
             self._area:setString(self.city_now[3])
        elseif self.city_gps:isSelected() then  --带修改
             self._provincename:setString(self.province) 
             self._cityname:setString(self.city) 
             self._area:setString(self.conty) 
        elseif self.city_choose:isSelected() then
             self._provincename:setString(province) 
             self._cityname:setString(city) 
             self._area:setString(conty) 
         end
self._provincename1:setString(self._provincename:getString() .. "-" .. self._cityname:getString() .. "-" .. self._area:getString())
         
         local  userdata=LocalData:Instance():get_user_data()
         userdata["cityid"]=city_id
         userdata["provinceid"]=province_id
         LocalData:Instance():set_user_data(userdata)

          self:unscheduleUpdate()
         self.adress:removeFromParent()
end
function PerInformationLayer:head( )
        self._head_tag_biaoji={}
        self.head_csb = cc.CSLoader:createNode("Head.csb")
        self:addChild(self.head_csb,20)
        self.head_csb:setTag(9888)
        local  day_bg=self.head_csb:getChildByTag(1900):getChildByTag(1903)
        local   _size=day_bg:getContentSize()
        local  _tag=0
         for i=1, math.ceil(16/4) do
                for j=1,4 do

                       local _bg=day_bg:clone()
                       _bg:setTag(_tag)
                       _bg:setTouchEnabled(true)
                       _bg:addTouchEventListener(function(sender, eventType  )
                                 if eventType ~= ccui.TouchEventType.ended then
                                    return
                                end
                                self._index=sender:getTag()
                                self.image_head:loadTexture(string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index)))
                                self.image_head1:loadTexture(string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index)))
                                 LocalData:Instance():set_user_head(string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index)))
                                  local user_dt = LocalData:Instance():get_userdata()
                                  user_dt["imageUrl"]=string.format("httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index))
                                  LocalData:Instance():set_userdata(user_dt)
                                  for z=1,16 do
                                      self._head_tag_biaoji[z]:setVisible(false)
                                  end
                                  sender:getChildByTag(1902):setVisible(true)

                                --  if  self.head_csb then
                                --     self._Pname:setVisible(true)
                                --     self.head_csb:removeFromParent()
                                -- end

                      end)
                       local _head_image=_bg:getChildByTag(1901)
                       local _head_tag=_bg:getChildByTag(1902)
                      
                       table.insert(self._head_tag_biaoji,_head_tag) 
                       _head_tag:setVisible(false)
                       _head_image:loadTexture("png/httpgame.pinlegame.comheadheadicon_"  .. _tag .. ".jpg")
                       if tostring(LocalData:Instance():get_user_head()) ==  "png/httpgame.pinlegame.comheadheadicon_"  .. _tag .. ".jpg" then
                           _head_tag:setVisible(true)
                          
                       end
                        _bg:setPosition(cc.p(_bg:getPositionX()+(_size.width+9)*(j-1),_bg:getPositionY()-(_size.height+20)* math.ceil(i-1)))
                       self.head_csb:getChildByTag(1900):addChild(_bg)
                      _tag=_tag+1
                end
            end
            ------------------------------------------------废-----------------------------------
        local head_back=self.head_csb:getChildByTag(20)  --  :getChildByTag(25)
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
                    self._index=tostring(self.PageView_head:getCurPageIndex())
                end

        end)
        local Panel=self.PageView_head:getChildByTag(27)
        for i=1,15 do
            local  call=Panel:clone() 
            local head_image=call:getChildByTag(86)
            head_image:loadTexture( "png/httpgame.pinlegame.comheadheadicon_" .. tostring(i) .. ".jpg")--初始化头像
            self.PageView_head:addPage(call)   --添加头像框
        end

         local userdt12 = LocalData:Instance():get_userdata()
        local _index12=string.match(tostring(Util:sub_str(userdt12["imageUrl"], "/",":")),"%d%d")
        if _index12==nil then
          _index12=string.match(tostring(Util:sub_str(userdt12["imageUrl"], "/",":")),"%d")
        end

        self.PageView_head:scrollToPage(_index12)   --拿到需要索引的图

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
            if tag==20 then --返回
                if  self.head_csb then
                    self.head_csb:removeFromParent()
                     self._Pname:setVisible(true)
               end
                
            elseif tag==24 then  --string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index))
                self.image_head:loadTexture(string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index)))
                LocalData:Instance():set_user_head(string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index)))


                  local user_dt = LocalData:Instance():get_userdata()
                  user_dt["imageUrl"]=string.format("httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(self._index))
                  LocalData:Instance():set_userdata(user_dt)
                 if  self.head_csb then
                    self._Pname:setVisible(true)
                    self.head_csb:removeFromParent()
                end
               
            end
end
function PerInformationLayer:savedata( )
            local  gender="true"  --默认无
            if self.genderman:isSelected() then
                gender="true"
                self.genderman1:setString("男")
                self.genderman1_image:loadTexture("png/IcnMale.png")
            elseif self.gendergirl:isSelected() then
                gender="false"
                self.genderman1:setString("女")
                self.genderman1_image:loadTexture("png/IcnFemale.png")

            end
           --self.genderman1="  "
           if  self._provincename:getString() == "" then
               Server:Instance():show_float_message("请完善城市信息")
               return
           end

     local  userdata=LocalData:Instance():get_user_data()
    -- local  loginname= userdata["loginname"]
    -- local  nickname=self._Pname:getText()  
    -- userdata["nickname"]=nickname
    -- LocalData:Instance():set_user_data(userdata)
    -- self._Pname1=self._Pname:getText()
    --self._Pname1:setString(tostring(self._Pname:getText()))
    local  provincename=self._provincename:getString() 
    local  cityid=userdata["cityid"]
    local  districtid=1
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
    print("birthday  ",birthday,self._index)
    local  provinceid=userdata["provinceid"] 
    local  imageurl=self._index
            if self.head_index==100 then
                 imageurl= tostring(self._index) --
            else
                 imageurl=self.head_index  --"httpgame.pinlegame.comheadheadicon_" .. self.head_index .. ".jpg"
            end
    local params={
            loginname=loginname,
            nickname=self._Pname:getText(),  
            provinceid=provinceid,
            provincename=provincename,
            cityid=cityid,
            cityname=cityname,
            birthday=birthday,
            gender=gender,
            imageurl=imageurl,
            districtame=self._area:getString(),
            districtid=districtid,
        }
        --dump(params)
            local  userdatainit=LocalData:Instance():get_getuserinfo() --初始化个人信息
            userdatainit["birthday"]=birthday
            userdatainit["cityid"]=cityid
            userdatainit["cityname"]=cityname
            if tostring(gender)==tostring("true") then
               userdatainit["gender"]=1
            else
                userdatainit["gender"]=0
            end
            
            userdatainit["nickname"]=userdata["nickname"]
            userdatainit["provincename"]=provincename
            userdatainit["districtame"] =self._area:getString()
            -- dump(userdatainit)
            LocalData:Instance():set_getuserinfo(userdatainit)  --必须打开
            Server:Instance():setuserinfo(params) 

end
function PerInformationLayer:fun_birthday(  )
        self.birthday = cc.CSLoader:createNode("Birthday.csb")
        self:addChild(self.birthday)
        self.birthday:setLocalZOrder(7878)
           local move = cc.MoveTo:create(0.5,cc.p(0,0))
        self.birthday:runAction(cc.Sequence:create(move))

        local birthday_back=self.birthday:getChildByTag(169)      --  :getChildByTag(49)
            birthday_back:addTouchEventListener(function(sender, eventType  )
            self:touch_callback(sender, eventType)
       end)
        local _true=self.birthday:getChildByTag(174):getChildByTag(49)
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


        local  m_offset_birthday=0
        local name="1990"
        for i=1,70+4 do   
            local button =self.birthday_Itempicker:getCellLayout(cc.size(50,30))
            local cell=ccui.Text:create()
            cell:setFontSize(18);
            cell:setFontName("png/chuti.ttf")
            cell:setAnchorPoint(cc.p(0.0,0.0));
            cell:setColor(cc.c4b(107,173,205))
            cell:setPositionX(0)
            
            if i<70+3 and i-3>=0 then 
                cell:setString(tostring(2016-(i-3)))
                name=tostring(2016-(i-3))
            else
                name="-1"
                cell:setString(".")
                cell:setOpacity(0)
            end
            -- dump(button:getContentSize())
            local pos = string.find(self.scall_years, name)   
            if pos then
                m_offset_birthday=i-3;
                print("e  ",self.scall_years,name,m_offset_birthday)
            end

            cell:setTag(i)
            button:addChild(cell)
            self.birthday_Itempicker:pushBackItem(button)
        end
        self.birthday_Itempicker:setOffsetLayout(m_offset_birthday)
        -- 


        --月
        local birthday_scrollview2=self.birthday:getChildByTag(174):getChildByTag(171)
        local birthday_month=birthday_scrollview2:getChildByTag(176)
            -- local height_month=birthday_month:getContentSize().height   
        local birthday_month_y= birthday_month:getPositionY()

        self.birthday_month_Itempicker=self:addItemPickerData(birthday_scrollview2,birthday_month)
        self.birthday:getChildByTag(174):addChild(self.birthday_month_Itempicker)

        local  m_offset_month=0
        local name="04"
        for i=1,12+4 do   

            local button =self.birthday_month_Itempicker:getCellLayout(cc.size(50,30))

            local cell_month=ccui.Text:create()
            cell_month:setFontSize(18);
            cell_month:setAnchorPoint(cc.p(0.0,0.0));
            cell_month:setColor(cc.c4b(107,173,205))
            cell_month:setPositionX(0)
            cell_month:setTag(i)
            cell_month:setFontName("png/chuti.ttf")
            
            if i<12+3 and i-3>=0 then 
                if i<12 then
                     cell_month:setString("0" .. tostring(i-2))
                     name="0" .. tostring(i-2)
                else
                     cell_month:setString(tostring(i-2))
                     name=tostring(i-2)
                end
            else
                name="-1"
                cell_month:setString(".")
                cell_month:setOpacity(0)
            end

            local pos = string.find(self.scall_month, name)   
            if pos then
                m_offset_month=i-3;
            end
            button:addChild(cell_month)
            self.birthday_month_Itempicker:pushBackItem(button)
        end
        self.birthday_month_Itempicker:setOffsetLayout(m_offset_month)

        --日
        local birthday_scrollview3=self.birthday:getChildByTag(174):getChildByTag(173)
        local birthday_daty=birthday_scrollview3:getChildByTag(177)
  
        local birthday_daty_y= birthday_daty:getPositionY()

        self.birthday_daty_Itempicker=self:addItemPickerData(birthday_scrollview3,birthday_daty)
        self.birthday:getChildByTag(174):addChild(self.birthday_daty_Itempicker)
        local  m_offset_daty=0
        local name="04"
        for i=1,31+4 do   
            local button =self.birthday_daty_Itempicker:getCellLayout(cc.size(50,30))

            local cell_day=ccui.Text:create()
            cell_day:setFontSize(18);
            cell_day:setFontName("png/chuti.ttf")
            cell_day:setAnchorPoint(cc.p(0.0,0.0));
            cell_day:setColor(cc.c4b(107,173,205))
            cell_day:setPositionX(0)
            
            if i<31+3 and i-3>=0 then 
                if i<12 then
                     cell_day:setString("0" .. tostring(i-2))
                     name="0" .. tostring(i-2)
                else
                     cell_day:setString(tostring(i-2))
                     name=tostring(i-2)
                end
            else
                cell_day:setString(".")
                cell_day:setOpacity(0)
                name="-1"
            end

            local pos = string.find(self.scall_day, name)   
            if pos then
                m_offset_daty=i-3;
            end

            button:addChild(cell_day)
             -- birthday_scrollview2:addChild(cell_month)
            self.birthday_daty_Itempicker:pushBackItem(button)
              
        end
        self.birthday_daty_Itempicker:setOffsetLayout(m_offset_daty)
        -- self:scheduleUpdate()
end


function  PerInformationLayer:addItemPickerData(scorll,size)

    -- local dex=0--960-display.height
    -- local picker =cc.ItemPicker:create()
    -- picker:setDirection(scorll:getDirection())
    -- picker:setContSize(cc.size(150, 400))--
    -- -- picker:setInnerContainerSize(cc.size(220,50*34))
    -- picker:setParameter(cc.size(100,50),8)
    -- picker:setPosition(scorll:getPositionX(),scorll:getPositionY())
    -- picker:setAnchorPoint(0,0)
    -- scorll:removeFromParent()


     local dex=0--960-display.height
    local picker =cc.ItemPicker:create()
    picker:setDirection(scorll:getDirection())
    picker:setContSize(cc.size(70, 150))--cc.size(150, 200)
    -- picker:setInnerContainerSize(cc.size(220,50*34))
    picker:setParameter(cc.size(size.width,30),5)--cc.size(140,40)
    picker:setPosition(scorll:getPositionX(),scorll:getPositionY()+10)
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
    picker:setParameter(cc.size(size.width,35),4)--cc.size(140,40)
    picker:setPosition(scorll:getPositionX(),scorll:getPositionY())
    picker:setAnchorPoint(0,0)
    scorll:removeFromParent()
    
    return picker;
end



function PerInformationLayer:fun_city_info( )
        self.adress = cc.CSLoader:createNode("Adress.csb")
        self:addChild(self.adress)
        local move = cc.MoveTo:create(0.5,cc.p(0,0))
        self.adress:runAction(cc.Sequence:create(move))
        self.adress:setTag(250)
        self.adress:setLocalZOrder(100)

         self.city_present=self.adress:getChildByTag(131)  --当前城市按钮
         self.city_present:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.city_gps:setSelected(false)
                            self.city_choose:setSelected(false)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                              self.city_choose:setSelected(true)
                     end
            end)

         self.city_gps=self.adress:getChildByTag(132)  --定位城市
         self.city_gps:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                             self.city_present:setSelected(false)
                             self.city_choose:setSelected(false)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                            self.city_choose:setSelected(true)
                     end
            end)

         self.city_choose=self.adress:getChildByTag(133)  --选择城市
         self.city_choose:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                             self.city_present:setSelected(false)
                             self.city_gps:setSelected(false)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             self.city_choose:setSelected(true)
                     end
            end)


         
        



        local city_back=self.adress:getChildByTag(51)  --  :getChildByTag(59)
        city_back:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
         local save=self.adress:getChildByTag(52):getChildByTag(59)
         save:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
        --省
        local province_scrollview=self.adress:getChildByTag(52):getChildByTag(62)
        local province_text=province_scrollview:getChildByTag(95)
          
        local adress_province_y= province_text:getPositionY()

        self.adress_province_Itempicker=self:add_addItemPickerData(province_scrollview,cc.size(70, 140))
        self.adress:getChildByTag(52):addChild(self.adress_province_Itempicker)

        --市
        local city_scrollview=self.adress:getChildByTag(52):getChildByTag(63)
        local city_text=city_scrollview:getChildByTag(96)

        self.adress_city_Itempicker=self:add_addItemPickerData(city_scrollview,cc.size(140, 140))
        self.adress_city_Itempicker:setPositionX(self.adress_city_Itempicker:getPositionX())
        self.adress:getChildByTag(52):addChild(self.adress_city_Itempicker)

        --区
        local area_scrollview=self.adress:getChildByTag(52):getChildByTag(64)
        local area_text=area_scrollview:getChildByTag(97)
        
        self.adress_conty_Itempicker=self:add_addItemPickerData(area_scrollview,cc.size(70, 140))
        self.adress_conty_Itempicker:setPositionX(self.adress_conty_Itempicker:getPositionX())
        self.adress:getChildByTag(52):addChild(self.adress_conty_Itempicker)

        local  userdata=LocalData:Instance():get_getuserinfo()
        -- dump(userdata)
         local  userdatainit=LocalData:Instance():get_user_data() --用户数据
         -- dump(userdatainit)
        local city_curr=self.adress:getChildByTag(52):getChildByTag(130)
        local area=""
        if userdatainit["districtame"]  then

            area=userdatainit["districtame"]
        end

        local str=""

        if userdatainit["provincename"] then
            str=userdatainit["provincename"].."-" ..  userdatainit["cityname"] .. "-" .. area
        end

        if area == "" and userdatainit["provincename"] then
           str=userdatainit["provincename"].."-" ..  userdatainit["cityname"] 
        end

        city_curr:setString(str)
        self.city_now=Util:lua_string_split(str, "-")  --当前城市

        --如果获取定位信息，优先级最高，如果没有获取定位信息获取 手机号归属
        self.province="1"
        self.city="2"
        self.conty="3"
        local pinle_location=cc.PinLe_platform:Instance()
        -- dump(pinle_location:getProvince())
        if pinle_location:getProvince()~= "" then --手机定位
            self.province=pinle_location:getProvince()
            self.city=pinle_location:getCity()
            self.conty=pinle_location:getCounty()
            -- print("111111--------")
        else
            --手机归属--缺少接口
            local phone_location=LocalData:Instance():getusercitybyphone()--获取手机号信息
            -- 
            -- dump(phone_location)
            self.province=".."
            self.city="."
            if phone_location["provincename"] then
                print("手机归属")
                self.province=phone_location["provincename"]
                self.city=phone_location["cityname"]
            end
            
            
            self.conty="1"
        end
        -- self.province=".."
        -- dump(self.province)

        -- if self.province ~="1" then
        local city_gps=self.adress:getChildByTag(52):getChildByTag(58)
        city_gps:setString(self.province..self.city)
        -- end
        -- dump(pinle_location:getProvince())
        -- dump(pinle_location:getCity())
        -- dump(self.province)
        -- self.province=userdata["provincename"]
        -- self.city=userdata["cityname"]
        -- self.conty="崂山区"
        self.province_index=-1
        self.city_index=-1
        self.mail_h=0
        self.mail_dex=0

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
    for i=1,#json_province+3+self.mail_h do   

        local button =self.adress_province_Itempicker:getCellLayout(cc.size(60,35))
        local name
        if i<#json_province+3+self.mail_dex and i-2-self.mail_dex>0 then 
            local cell_month=ccui.Text:create()
            cell_month:setFontSize(18)
            cell_month:setAnchorPoint(cc.p(0,0));
            cell_month:setColor(cc.c4b(195,141,141))
            cell_month:setPositionX(-0.12)
            cell_month:setFontName("png/chuti.ttf")
            cell_month:setTag(i)

            button:addChild(cell_month)

            
            cell_month:setString(json_province[i-2-self.mail_dex]["name"])
            name=json_province[i-2-self.mail_dex]["name"]
            
           local pos = string.find(self.province, name)   
            if pos then
                m_offset_cell=i-3-self.mail_dex;
            end
        end

        
         self.adress_province_Itempicker:pushBackItem(button)
    end
    dump(m_offset_cell)
    self.adress_province_Itempicker:setOffsetLayout(m_offset_cell)

end

function PerInformationLayer:fun_City()
    
    self.adress_city_Itempicker:clearItems()
    self.adress_city_Itempicker:removeAllChildren()
    dump(tonumber(self.adress_province_Itempicker:getCellPos()))

    local json_city=self.city_data["provinces"][tonumber(self.adress_province_Itempicker:getCellPos()+1)]["citys"]
    -- dump(json_city)
    if #json_city==0 then
        return
    end
    -- local json_city=self.city_data["provinces"][29]["citys"]
    -- dump(json_city)
    local m_offset_cell=0
    for i=1,#json_city+3+self.mail_h do   

        local button =self.adress_city_Itempicker:getCellLayout(cc.size(140,35))
        local name
        if i<#json_city+3+self.mail_dex and i-2-self.mail_dex>0 then 
            local cell_month=ccui.Text:create()
            cell_month:setFontSize(15)
            cell_month:setAnchorPoint(cc.p(0.5,0));
            cell_month:setColor(cc.c4b(195,141,141))
            cell_month:setPositionX(67.91)
            cell_month:setFontName("png/chuti.ttf")
            cell_month:setTag(i)

            button:addChild(cell_month)

            
            cell_month:setString(json_city[i-2-self.mail_dex]["name"])
            name=json_city[i-2-self.mail_dex]["name"]
           local pos = string.find(self.city, name)   
            if pos then

                m_offset_cell=i-3-self.mail_dex;
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
    -- dump(json_city)
    if #json_city==0 then
        return
    end
    local json_conty=json_city[tonumber(self.adress_city_Itempicker:getCellPos()+1)]["areas"]
    if #json_conty==0 then
        return
    end
    -- dump(json_conty)
    -- local json_conty=json_city[8]["areas"]
    -- dump(self.adress_city_Itempicker:getCellPos())
    -- dump(json_conty)
    local m_offset_cell=0
    for i=1,#json_conty+3+self.mail_h do   

        local button =self.adress_conty_Itempicker:getCellLayout(cc.size(70,35))
        local name
        if i<#json_conty+3+self.mail_dex and i-2-self.mail_dex>0 then 
            local cell_month=ccui.Text:create()
            cell_month:setFontSize(15)
            cell_month:setAnchorPoint(cc.p(0,0));
            cell_month:setColor(cc.c4b(195,141,141))
            -- cell_month:setPositionX(207.86)
            cell_month:setFontName("png/chuti.ttf")
            cell_month:setTag(i)

            button:addChild(cell_month)

            
            cell_month:setString(json_conty[i-2-self.mail_dex]["name"])
            name=json_conty[i-2-self.mail_dex]["name"]
           local pos = string.find(self.conty, name)   
            if pos then
                m_offset_cell=i-3-self.mail_dex;
            end
        end

        self.adress_conty_Itempicker:pushBackItem(button)
    end
    self.adress_conty_Itempicker:setOffsetLayout(m_offset_cell)
end
function PerInformationLayer:onEnter()
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self,
                       function()
                            --self:init()
                            
                      end)
      NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.REG, self,
                       function()
                            if self._Pname then
                                 self._Pname:setVisible(true)
                            end
                            if  self.phone_text_mail then
                               self.phone_text_mail:setVisible(true)
                               self.ads_text_mail:setVisible(true)
                               self.name_text_mail:setVisible(true)
                            end
                            if self.Receivinginformation then
                                self:unscheduleUpdate()
                                self.Receivinginformation:removeFromParent()
                            end
                                  
                           
                      end)

     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self,
                       function()
                            print("个人信息修改")
                              if self.Perinformation then
                                   --self._Pname=nil

                            local  userdata=LocalData:Instance():get_user_data()
                            local  loginname= userdata["loginname"]
                            local  nickname=self._Pname:getText()  
                            userdata["nickname"]=nickname
                            self._Pname1:setString(tostring(self._Pname:getText()))
                            LocalData:Instance():set_user_data(userdata)
                            self._Pname=nil

                              self.Perinformation:removeFromParent()
                           end

                      end)
     NotificationCenter:Instance():AddObserver("xiugainicheng", self,
                       function()

                         local  userdata=LocalData:Instance():get_user_data()
                            local  loginname= userdata["loginname"]
                            print("大家快放假啊SD卡",tostring(userdata["nickname"]))
                            self._Pname:setText(tostring(userdata["nickname"]))  
                            self._Pname:setVisible(true)
                            print("大家快放假啊SD卡111",self._Pname:getText())
                            self._Pname1:setString(tostring(userdata["nickname"]))
                             self._Pname1:setVisible(true)
                           


                            
                      end)
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.EMAILADDRESS, self,
                       function()
                            self:fun_mail()
                      end)
end

function PerInformationLayer:onExit()
         NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self)
          NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.REG, self)
          NotificationCenter:Instance():RemoveObserver("xiugainicheng", self)

         NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE, self)
         NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.EMAILADDRESS, self)
         cc.Director:getInstance():getTextureCache():removeAllTextures() 
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
        -- print("111----",self.city_index,self.adress_city_Itempicker:getCellPos())
    end

    if self.city_index~= self.adress_city_Itempicker:getCellPos() or is_change then
         self:fun_Conty()
          -- print("1111----",self.city_index,self.adress_city_Itempicker:getCellPos())
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


    -- dump(province)
    -- dump(city)
    -- dump(conty)
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

















