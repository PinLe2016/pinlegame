--
-- Author: peter
-- Date: 2016-06-17 09:11:36
--
--好友接口相关文件


--3.2.9 好友添加/删除/通过验证
--friendPlayerID	是	好友ID	String	GUID
--type	是	操作类型	String	1.添加 0.删除 2.通过好友


function Server:setfriend(friendplayerid,type)
       local params = {}
    params={
            friendplayerid=friendplayerid,
            type=type
        }
   
    self:request_http("setfriend" , params ) 
end


function Server:setfriend_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("好友添加/删除/通过验证:" .. self.data.err_msg)
        return
    end
    -- LocalData:Instance():set_getgoldspoollist(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end


--3.2.10 查询好友列表

function Server:getfriendlist()
       local params = {}
    params={
            -- friendPlayerID=friendPlayerID ,
            -- type=type
        }
   
    self:request_http("getfriendlist" , params ) 
end


function Server:getfriendlist_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("查询好友列表:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():setfriendlist(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end


--3.2.14 设置邀请码
--invitecode	是	邀请码	String
function Server:setinvitecode(invitecode)
       local params = {}
    params={
            invitecode=invitecode ,
            -- type=type
        }
   
    self:request_http("setinvitecode" , params ) 
end


function Server:setinvitecode_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("设置邀请码:" .. self.data.err_msg)
        return
    end
    -- LocalData:Instance():set_getgoldspoollist(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end


--3.2.15 领取好友升级奖励积分&金币
--invitecode	是	邀请码	String
function Server:get_reward_of_friends_levelup()
       local params = {}
    -- params={
    --         invitecode=invitecode ,
    --         -- type=type
    --     }
   
    self:request_http("get_reward_of_friends_levelup" , params ) 
end


function Server:get_reward_of_friends_levelup_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("领取好友升级奖励积分&金币:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_reward_friend(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end

--3.2.16 查询好友升级奖励金币列表

function Server:get_reward_friend_list()
       local params = {}
    -- params={
    --         invitecode=invitecode ,
    --         -- type=type
    --     }
   
    self:request_http("get_reward_friend_list" , params ) 
end


function Server:get_reward_friend_list_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("查询好友升级奖励金币列表:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_reward_friend_list(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end































