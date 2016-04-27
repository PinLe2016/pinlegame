

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
   -- dump(self.data)
   self.login_url=self.data

   --测试接口
   -- self:create_username_user("18210582992","111111")
   self:login("18210582992","111111")
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
    self:request_http("reg" , params ); 
end


function Server:reg_callback()
    -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("注册失败:" .. self.data.err_msg)

        return
    end

    LocalData:Instance():set_user_data(self.data)--保存玩家数据
    self:show_float_message("注册成功")
   -- end
     -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
end


--登陆
function Server:login(username,password)
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
    self:request_http("login" , params); 
end


function Server:login_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("账号密码登录失败:" .. self.data.err_msg)
        return
    end
    
    LocalData:Instance():set_user_data(self.data)--保存玩家数据
end


--修改密码 

function Server:changepassword(username,new_password)
    local params = {}
     params={
            loginname=username,
            password=crypto.md5(password)
        }
    self:request_http("changepassword" , params); 
end

function Server:changepassword_callback()
    if self.data.err_code~=0  then
        self:show_float_message("账号密码登录失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_user_data(self.data)--保存玩家数据
end



