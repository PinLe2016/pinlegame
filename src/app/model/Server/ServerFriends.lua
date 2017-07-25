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
     -- dump(self.data)
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
     --dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("查询好友列表:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():setfriendlist(self.data)--保存数据
   -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.FRIENDLIST_POST)
   
end


--3.2.14 设置邀请码
--invitecode	是	邀请码	String--邀请好友
function Server:setinvitecode(invitecode)
       local params = {}
    params={
            invitecode=invitecode ,
            -- type=type
        }
    if invitecode=="" then
        self:show_float_message("邀请码不能为空")
        return
    end
    self:request_http("setinvitecode" , params ) 
end


function Server:setinvitecode_callback()

    if self.data.err_code~=0  then
        self:show_float_message("" .. self.data.err_msg)
        return
    end

    
    local fistname=LocalData:Instance():get_reward_setting_list()
    fistname["invitecode"]=tostring(self.params["invitecode"])
    LocalData:Instance():set_reward_setting_list(fistname)--保存数据

    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.STECODE)
   
end


--3.2.15 领取好友升级奖励积分&金币  一键领取
 --  
function Server:get_reward_of_friends_levelup()
       local params = {}
    -- params={
    --         invitecode=invitecode ,
    --         -- type=type
    --     }
   
    self:request_http("get_reward_of_friends_levelup" , params ) 
end


function Server:get_reward_of_friends_levelup_callback()
      -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("领取好友升级奖励积分&金币:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_reward_of_friends_levelup(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.FRIENDSLEVELUP)
   
end

--3.2.16 查询好友升级奖励金币列表   初始化未领取金币接口

function Server:get_reward_friend_list()
       local params = {}
    -- params={
    --         invitecode=invitecode ,
    --         -- type=type
    --     }
   
    self:request_http("get_reward_friend_list" , params ) 
end


function Server:get_reward_friend_list_callback()
      --dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("查询好友升级奖励金币列表:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_reward_friend_list(self.data)--保存数据
   NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.FRIENDLIST_POST)
   
end


--3.2.1 查询邀请好友奖励配置列表接口
--点击邀请有礼接口
function Server:get_friend_reward_setting_list()
       local params = {}
    -- params={
    --         invitecode=invitecode ,
    --         -- type=type
    --     }
   
    self:request_http("get_friend_reward_setting_list" , params ) 
end


function Server:get_friend_reward_setting_list_callback()
      --dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("查询好友升级奖励金币列表:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_reward_setting_list(self.data)--保存数据
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.INVITATION_POLITE)
   
end

--3.2.2 领取邀请好友奖励接口(命令：set_friend_reward_setting)
--Id  是   配置ID    GUID    和配置列表对应
function Server:set_friend_reward_setting(Id)
       local params = {}
    params={
            Id=Id,
            -- type=type
        }
   
    self:request_http("set_friend_reward_setting" , params ) 
end


function Server:set_friend_reward_setting_callback()
     -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("查询好友升级奖励金币列表:" .. self.data.err_msg)
        return
    end
    Server:Instance():getuserinfo()
    LocalData:Instance():set_friend_reward_setting(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end

---  3.10 好友系统

--3.10.1 查找好友接口（命令：getsearchfriendlist）
--pagesize    是   每页显示数据  int 
--pageno  是   页号  Int 第一页为1
--nickname    否   昵称  String  搜索需要输入的昵称


function Server:getsearchfriendlist(pagesize,pageno,nickname)
       local params = {}
    params={
            pagesize=pagesize,
            pageno=pageno,
            nickname=nickname
        }
   
    self:request_http("getsearchfriendlist" , params ) 
end


function Server:getsearchfriendlist_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("" .. self.data.err_msg)
        NotificationCenter:Instance():PostNotification("FRIEND_GETSEARCHFRIENDLIST_FALSE")
        return
    end
    LocalData:Instance():set_getsearchfriendlist(self.data)--保存数据
   NotificationCenter:Instance():PostNotification("FRIEND_GETSEARCHFRIENDLIST")
   
end


--3.10.2 好友添加/删除接口（命令：setfriendoperation）

--playerid    是   玩家编号    Guid    
--type    是   类型  Int 0添加  1删除

function Server:setfriendoperation(list,type)
       local params = {}
       
    params={
            list=list,
            type=type
        }
   
    self:request_http("setfriendoperation" , params ) 
end


function Server:setfriendoperation_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message(self.data.err_msg)
        return
    end
        NotificationCenter:Instance():PostNotification("FRIEND_SETFRIENDOPERATION")
   
   
end
--  首页好友助力榜
function Server:getfriendhelplist(_type)
       local _params ={}
       _params={
            type=_type
   }
   
    self:request_http("getfriendhelplist" , _params ); 
end


function Server:getfriendhelplist_callback()
        dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
     LocalData:Instance():set_getfriendhelplist(self.data)--保存数据
     NotificationCenter:Instance():PostNotification("getfriendhelplist")
   
end



























