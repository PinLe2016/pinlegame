--
-- Author: peter
-- Date: 2016-05-23 10:45:26
--
--保存用户数据
function Server:setuserinfo(params)

       local _params = params   
    self:request_http("setuserinfo" , _params ); 
end


function Server:setuserinfo_callback()
    if self.data.err_code~=0  then
        self:show_float_message("获取活动专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_userinfo(self.data)--保存数据
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE)
   
end
--用户数据初始化
function Server:getuserinfo()
   
       local params = {}
    params={
           
        }
    self:request_http("getuserinfo" , params ); 
end


function Server:getuserinfo_callback()
    if self.data.err_code~=0  then
        self:show_float_message("获取活动专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getuserinfo(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE)
   
end

--签到
function Server:checkin()
   
       local params = {}
        params={
           
         }
    self:request_http("checkin" , params ); 
end
function Server:checkin_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取活动专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getcheckinhistory(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.CHECK_POST)
   
end
--签到历史
function Server:getcheckinhistory()
   
       local params = {}
        params={
           
         }
    self:request_http("getcheckinhistory" , params ); 
end
function Server:getcheckinhistory_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取活动专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getcheckinhistory(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST)
   
end

























