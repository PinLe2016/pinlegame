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
        self:show_float_message("保存用户数据失败:" .. self.data.err_msg)
        return
    end
    self:show_float_message("信息修改成功!")
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
    dump(self.data)
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
        self:show_float_message(self.data.err_msg)
        return
    end
    self:show_float_message("签到成功！！！")
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




--3.2.16获取玩家手机归属地
function Server:getusercitybyphone()
    local params = {}
     -- params={
     --        type=type,
     --        phone=phone,
     --        code=code,
     --    }
    self:request_http("getusercitybyphone" , params); 
end

function Server:getusercitybyphone_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取玩家手机归属地:" .. self.data.err_msg)
        return
    end

    LocalData:Instance():set_getusercitybyphone(self.data)--保存玩家数据
end



--3.2.1 修改玩家收货地址(命令：setconsignee)
--name  是   收货姓名    String
--phone 否   收货电话    String  
--provinceid    否   省份编号    String  String
--cityid    否   城市编号    String  String
--address   否   详细地址    String  
function Server:setconsignee(name,phone,provinceId,cityId,address,provincename,cityname)
    local params = {}
     params={
            name=name,
            phone=phone,
            provinceId=provinceId,
            cityId=cityId,
            address=address,
            provincename=provincename,
            cityname=cityname
        }
    self:request_http("setconsignee" , params); 
end

function Server:setconsignee_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("修改玩家收货地址:" .. self.data.err_msg)
        return
    end
    self:show_float_message("保存成功！")
    -- LocalData:Instance():set_getusercitybyphone(self.data)--保存玩家数据
end






















