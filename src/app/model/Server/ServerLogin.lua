

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
   -- 清空邮件
	   Util:removeDirectory("mails")
	   cc.UserDefault:getInstance():getStringForKey("last_mail_id" , "0")
       cc.UserDefault:getInstance():setStringForKey("uid" , self.data.uid)
       cc.UserDefault:getInstance():setStringForKey("guest_id" , self.data.guest_id)
       cc.UserDefault:getInstance():flush()
       self:show_float_message("注册成功")
   -- end
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
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

    cc.UserDefault:getInstance():setStringForKey("uid" , self.data.uid)
    cc.UserDefault:getInstance():setStringForKey("guest_id" , self.data.guest_id)
    cc.UserDefault:getInstance():flush()
    LocalData:Instance():set_server_list(self.data)--保存服务器列表
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_USERNAME, self.data)
end



--修改密码
function Server:change_password(username,old_password,new_password)

    local username,password =self:get_username_password()
    --需要参数 uid ,server_id,cid
    local channel_code = TANK_CHANNEL_ID
        local params = {
            channel_code = channel_code,
            username=username,
            old_password=crypto.md5(old_password),
            new_password=crypto.md5(new_password)
        }
    self:request_http("change_password" , params , true); 
end


function Server:change_password_callback()
    -- dump(self.data)
    if self.data.stats=="error"  then
        self:show_float_message("修改密码失败:" .. self.data.msg)
        return
    end
    self:save_username_password(tostring(self.params.username),tostring(self.params.new_password))--本地保存用户名，密码

    self:show_float_message("修改密码成功")
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
end

--忘记密码
function Server:forgot_password(username,mail_address)
    -- local openid = cc.UserDefault:getInstance():getStringForKey("openid")
    print("------feg---",username,mail_address)
    --需要参数 uid ,server_id,cid
    local channel_code = TANK_CHANNEL_ID
        local params = {
            channel_code = channel_code,
            username=username,
            mail_address=mail_address
        }
    self:request_http("forgot_password" , params , true); 
end


function Server:forgot_password_callback()
    dump(self.data)
    if self.data.stats=="error"  then
        self:show_float_message("申请找回密码失败:" .. self.data.msg)
        return
    end
    self:show_float_message("提交申请成功")
end


--上传用户服务器
function Server:save_server_login()
    --需要参数 uid ,server_id,cid
    local server_cid=cc.UserDefault:getInstance():getStringForKey("server_cid","")
    local server_id=cc.UserDefault:getInstance():getStringForKey("server_id","")
    local uid=cc.UserDefault:getInstance():getStringForKey("uid","")
        local params = {
            uid = uid,
            server_id=server_id,
            cid=server_cid
        }
    if server_cid=="" then return  end  

    self:request_http("save_server_login" , params , true); 
end

function Server:set_server_login_data(server_data)
    cc.UserDefault:getInstance():setStringForKey("server_cid",server_data.cid)
    cc.UserDefault:getInstance():setStringForKey("server_id",server_data.id)
    cc.UserDefault:getInstance():flush()
end

function Server:save_server_login_callback()
    if self.data.stats=="error"  then
        self:show_float_message("保存失败:" .. self.data.msg)
        return
    end
end


--绑定OPEN_ID(第三方)
function Server:bind_open_id()
    local open_id = cc.UserDefault:getInstance():getStringForKey("openid")
    local guest_id=self:is_guest_login()
    --需要参数 uid ,server_id,cid
    local channel_code = TANK_CHANNEL_ID
        local params = {
            -- channel_code = channel_code,
            open_id=open_id,
            guest_id=guest_id
        }
    self:request_http("bind_open_id" , params , true); 
end


function Server:bind_open_id_callback()
    -- dump(self.data)
    if self.data.stats=="error"  then
        self:show_float_message("绑定OPEN_ID失败:" .. self.data.msg)
        return
    end
end

--绑定账号
function Server:bind_username(username,password)
    local guest_id= cc.UserDefault:getInstance():getStringForKey("guest_id")
    --需要参数 uid ,server_id,cid
    local channel_code = TANK_CHANNEL_ID
        local params = {
            guest_id=guest_id,
            username=username,
            password=crypto.md5(password)
        }
    self:request_http("bind_username" , params , true); 
end


function Server:bind_username_callback()
    -- dump(self.data)
    print("---bangding ----",self.params.username,self.params.password)
    if self.data.stats=="error"  then
        self:show_float_message("绑定账号失败:" .. self.data.msg)
        return
    end
    self:save_username_password(self.params.username,self.params.password)--本地保存用户名，密码

    self:show_float_message("绑定账号成功")
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_USERNAME, self.data)
end


--绑定邮箱
function Server:bind_mail(username,mail_address)
    local guest_id= cc.UserDefault:getInstance():getStringForKey("guest_id")
    --需要参数 uid ,server_id,cid
    local channel_code = TANK_CHANNEL_ID
        local params = {
            guest_id=guest_id,
            username=username,
            mail_address=mail_address
        }
    self:request_http("bind_mail" , params , true); 
end


function Server:bind_mail_callback()
    -- dump(self.data)
    print("---bangding ----",self.params.username,self.params.mail_address)
    if self.data.stats=="error"  then
        self:show_float_message("绑定邮箱失败:" .. self.data.msg)
        return
    end
    self:show_float_message("绑定邮箱成功")
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GET_SERVERLIST_BY_REFRESH)
end



function Server:save_username_password(username,password)
    dump(password)
    cc.UserDefault:getInstance():setStringForKey("username",username)
    cc.UserDefault:getInstance():setStringForKey("password",password)
    cc.UserDefault:getInstance():flush()
end

function Server:get_username_password()

   local  user_name=cc.UserDefault:getInstance():getStringForKey("username","")
   local pass_word=cc.UserDefault:getInstance():getStringForKey("password","")

   return user_name,pass_word
end


