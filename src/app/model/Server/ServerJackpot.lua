--
-- Author: peter
-- Date: 2016-05-31 10:49:44
---获取金币奖池列表
--pagesize 否 每页显示数据 int
--pageno 否 页号 第一页为1


function Server:getgoldspoollist(params)
       local _params = params
       dump(_params)
   
    self:request_http("getgoldspoollist" , _params ); 
end


function Server:getgoldspoollist_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取奖池专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldspoollist(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end
---获取金币奖池的广告列表
function Server:getgoldspooladlist(activityid)
       local _params ={}
       _params={
            goldspoolid=activityid
   }
       dump(_params)
   
    self:request_http("getgoldspooladlist" , _params ); 
end


function Server:getgoldspooladlist_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取奖池专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldspoollistbale(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST)
   
end
