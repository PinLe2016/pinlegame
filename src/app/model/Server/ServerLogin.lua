

--获取连接请求

function Server:set_login_url(url)
	
	self.login_url="http://www.url.com/url/Default.aspx?"
end


function Server:is_first_game()
    return cc.UserDefault:getInstance():getBoolForKey("first_game",true)
end

--根据版本获取登陆注册信息
function Server:version_login_url()

    self:request_version("version_login_url")

end

function Server:version_login_url_callback()
   dump(self.data)
   self.login_url=self.data

   --测试接口
   -- self:create_username_user("18210582992","111111")
   -- self:login("18210582992","111111")
   -- Server:Instance():getsactivitieslist("1")
end



--注册
function Server:reg(username,password)

    local channel_code = PINLE_CHANNEL_ID
    local platform=device.platform
    local device_id = cc.UserDefault:getInstance():getStringForKey("device_id")
    if platform=="mac" then platform="IOS" end
    local params = {}

    params={
            loginname=username,
            deviceid = device_id,
            nickname="...",
            password=crypto.md5(password),
            latitude=55000000,
            longtitude=660000000,
            systemtype=platform,
            ip="192.168.0.0",
            origin="0",
        }
        dump(params)
    self:request_http("reg" , params ); 
end


function Server:reg_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("注册失败:" .. self.data.err_msg)

        return
    end

    LocalData:Instance():set_user_data(self.data)--保存玩家数据
    self:show_float_message("注册成功")
   -- end
     -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
end
function Server:prompt( content )
    self:show_float_message(tostring(content))
end

--登陆
function Server:login(username,password)
    print("开始"..username..password)
    local platform=device.platform
    local device_id = cc.UserDefault:getInstance():getStringForKey("device_id")
    if platform=="mac" then platform="IOS" end
    if platform=="android" then platform="ANDROID" end
    local params = {}
    params={
            loginname=username,
            deviceid = device_id,
            nickname="...",
            password=crypto.md5(password),
            latitude=55000000,
            longtitude=660000000,
            systemtype=platform,
            ip="192.168.0.0",
            origin="0",
        }
        -- dump( json.encode(params))
        local data=json.encode(params)
        print("----",tostring(data))
         -- self:show_float_message("测试:"..tostring(params.systemtype))
     self:request_http("login" , params); 
end


function Server:login_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("账号密码登录失败:" .. self.data.err_msg)
         -- local a=FloatingLayer:Instance():floatingLayer_init(self.data.err_msg)
         -- display.addChild(a)
        return
    end
       
   LocalData:Instance():set_user_data(self.data)--保存玩家数据

    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.SURPRIS_SCENE)
    -- 3.5.1 Server:Instance():getactivitylist("1")通过
    -- 3.5.2 Server:Instance():getactivitybyid("86e2c414-b26a-48dc-8c6d-682544289d84") 通过
    -- 3.5.3 Server:Instance():getranklistbyactivityid("86e2c414-b26a-48dc-8c6d-682544289d84",20)通过
    -- 3.5.4 Server:Instance():getactivityadlist("86e2c414-b26a-48dc-8c6d-682544289d84")通过
   -- 3.5.7  Server:Instance():getactivitypoints("86e2c414-b26a-48dc-8c6d-682544289d84")通过
    --3.5.9  Server:Instance():getactivitypointsdetail("86e2c414-b26a-48dc-8c6d-682544289d84")--通过
    --3.5.10 Server:Instance():getactivitywinners("86e2c414-b26a-48dc-8c6d-682544289d84")

    
end


--忘记密码

function Server:changepassword(username,new_password)
    local params = {}
     params={
            loginname=username,
            password=crypto.md5(new_password)
        }
        dump(params)
    self:request_http("changepassword" , params); 
end

function Server:changepassword_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("修改密码失败:" .. self.data.err_msg)
        return
    end
    self:show_float_message("修改密码成功")
    dialogdetermine=1-- 修改密码成功
    -- LocalData:Instance():set_user_data(self.data)--保存玩家数据
end



--3.2.13 发送短信验证码

--type    是   请求类型    String  1注册 2修改密码
--phone   是   手机号码    String  
--code    是   验证码 String  


function Server:sendmessage(type,phone,code)
    local params = {}
     params={
            type=type,
            phone=phone,
            code=code,
        }
    self:request_http("sendmessage" , params); 
end

function Server:sendmessage_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("账号密码登录失败:" .. self.data.err_msg)
        return
    end
     LocalData:Instance():set_sendmessage(self.data)--
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.REGISTRATIONCODE)
end


--3.7.1 版本检查
--devicetype  是   设备类型    String  IOS、ANDROID、OTHER
--versioncode 是   版本号 String  

function Server:getversion()
    local params = {}
    local version=LocalData:Instance():get_version()
     params={
            devicetype="ios",--device.platform,
            versioncode="3.0",
        }
    self:request_http("getversion" , params); 
end

function Server:getversion_callback()
    -- dump(self.data)
    -- if self.data.err_code~=0  then
    --     self:show_float_message("版本检查:" .. self.data.err_msg)
    --     return
    -- end
    
    -- LocalData:Instance():set_version(self.data["versioncode"])--保存玩家数据
    LocalData:Instance():set_version_date(self.data)--保存玩家数据

    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.VERRSION)
end

function Server:mall(username,password)
    print("开始"..username..password)
    local params = {}
    params={
            loginname=username,
            password=crypto.md5(password),
        }
        local hp="http://play.pinlegame.com/P_default.aspx?" ..  "id="  .. params.loginname  ..  "&md5="  ..  params.password  ..  "&w=640&h=1136" 
        return  hp
end




















