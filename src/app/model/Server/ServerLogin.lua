

function Server:get_login_url()
	
	return "http://www.pinlegame.com/geturl.aspx?os="
end


function Server:is_first_game()
    return cc.UserDefault:getInstance():getBoolForKey("first_game",true)
end





--注册
function Server:create_username_user(username,password)
  
        local params = {
            channel_code = channel_code,
            username=username,
            password=password_1
        }
    self:request_http("create_username_user" , params , true); 
end


function Server:create_username_user_callback()
    if self.data.stats=="error"  then
        self:show_float_message("注册失败:" .. self.data.msg)
        return
    end
       self:save_username_password(tostring(self.params.username),tostring(self.params.password))--本地保存用户名，密码
 
       self:show_float_message("注册成功")
   -- end
     -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
end


--登陆
function Server:get_server_list_by_username(username,password,is_input)
    local channel_code = TANK_CHANNEL_ID
    local password_1=crypto.md5(password)
    if is_input then
        password_1=password
    end
    -- local psssword=crypto.md5(psssword)
        local params = {
            channel_code = channel_code,
            username=username,
            password=password_1
        }
    self:request_http("get_server_list_by_username" , params , true); 
end


function Server:get_server_list_by_username_callback()
    if self.data.stats=="error"  then
        self:show_float_message("账号密码登录失败:" .. self.data.msg)
        -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
        return
    end
    -- self:show_float_message("登录成功")
    self:save_username_password(self.params.username,self.params.password)--本地保存用户名，密码
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_USERNAME, self.data)
end


