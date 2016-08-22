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
    --self:show_float_message("签到成功！！！")
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



-------邮件系统

--3.4.8 获取公告消息（命令：getaffichelist ）
function Server:getaffichelist (_pageno)
    local params = {
     pagesize=7,
     pageno=_pageno
}
 
    self:request_http("getaffichelist" , params); 
end

function Server:getaffichelist_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取邮件信息:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getaffiche(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.AFFICHLIST)
end
--3.4.9 获取公告详情
function Server:getaffichedetail(_messageid )
    local params = {
     messageid=_messageid
}
 
    self:request_http("getaffichedetail" , params); 
end

function Server:getaffichedetail_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取邮件详情:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getaffichedetail(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.AFFICHDETAIL)
end
--3.4.10  删除公告
function Server:delaffichebyid(_messageid )
            local   messageid={}
            messageid[1]=
            {
                 id=_messageid
            }

            local params = {
                 messageid=messageid
            }

    self:request_http("delaffichebyid" , params); 
end

function Server:delaffichebyid_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("删除邮件:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_delaffichebyid(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.DELAFFICHEBYID)
end
--3.4.11  领取公告奖励
function Server:getaffichereward(_messageid )
    local params = {
                messageid = _messageid

}
 
    self:request_http("getaffichereward" , params); 
end

function Server:getaffichereward_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("领取邮件奖励:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getaffichereward(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.TAFFICHEDETAIL)
end

--3.4.12  玩家反馈
function Server:setfeedback(params)
    local _params = params

    self:request_http("setfeedback" , _params); 
end

function Server:setfeedback_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("玩家反馈:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_setfeedback(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.FEEDBACK)
end












