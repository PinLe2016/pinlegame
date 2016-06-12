--
-- Author: peter
-- Date: 2016-04-22 13:25:00
--
--惊喜吧数据传输接口

--3.5.1 获取活动专区列表

--status	是	要获取的数据状态	String	0未开始1已开始2已结束3我的惊喜
function Server:getactivitylist(status,pageno)
    local params = {}
    params={
            status=status ,
            pageno=pageno
        }
    self:request_http("getactivitylist" , params ); 
end


function Server:getactivitylist_callback()
       dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取活动专区列表失败:" .. self.data.err_msg)
        return
    end
    -- print("6------------")
    LocalData:Instance():set_getactivitylist(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE)
end


--3.5.2 获取指定活动详情  activitieid	是	活动ID	String	GUID
function Server:getactivitybyid(activityid )
    local params = {}
    params={
            activityid=activityid
        }
    self:request_http("getactivitybyid" , params ); 
end


function Server:getactivitybyid_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动详情失败:" .. self.data.err_msg)
        return
    end
     LocalData:Instance():set_getactivitybyid(self.data)--保存数据
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE)
end


-- 3.5.3 获取活动的排行榜(命令:getranklistbyactivityid）--true排行榜
function Server:getranklistbyactivityid(activitieid,count)
    local params = {}
    params={
            activitieid=activitieid,
            count=count,
        }
    self:request_http("getranklistbyactivityid" , params ); 
end


function Server:getranklistbyactivityid_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取活动的排行榜失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getranklistbyactivityid(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE)
end


--3.5.4  获取指定活动的广告列表(命令：getactivityadlist)
function Server:getactivityadlist(activityid )
    local params = {}
    params={
            activityid =activityid ,
        }
    self:request_http("getactivityadlist" , params ); 
end


function Server:getactivityadlist_callback()
    dump(self.data)
    if  self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getactivityadlist(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.ACTIVITYYADLIST_LAYER_IMAGE)
    
end

--3.5.5  生成通关订单
--loginname   是   玩家账号    String   
--goodsid    是   礼品编号    String 
--postage   是   到付或金币抵扣包邮   int 0到付，1一千金币抵扣    
function Server:setorder(goodsid,postage)     
    local params = {}
    local login_info=LocalData:Instance():get_user_data()

    params={
            goodsid =goodsid ,
            postage =postage ,
            loginname =login_info["loginname"] ,
        }
    self:request_http("setorder" , params ); 
end


function Server:setorder_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    self:show_float_message("获取指定活动的广告列表")
end


--3.5.6   获取活动排行榜单 (分页)
--activityid        活动ID    string
--pageindex 是   当前页码编号  Int
--  排行榜
function Server:getrankinglistofactivies(activityid,pageindex)
    local params = {}
    params={
            activityid =activityid ,
            pageindex =pageindex ,
            -- loginname =login_info["loginname"] ,
        }
    self:request_http("getrankinglistofactivies" , params ); 
end


function Server:getrankinglistofactivies_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():setrankinglistofactivies_callback(self.data)
end

--3.5.7   获取用户活动老虎机积分（命令：getactivitypoints）
function Server:getactivitypoints(activityid)
    local params = {}
    params={
            activityid =activityid,
        }
    self:request_http("getactivitypoints" , params ); 

end

function Server:getactivitypoints_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getactivitypoints(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.LAOHUJI_LAYER_IMAGE)
end


--3.5.8   获取最近10次日常拼图金币奖励红包接口
function Server:getrecentgoldslist(count)
    local params = {}
    params={
            count =count,
        }
    self:request_http("getrecentgoldslist" , params ); 
end

function Server:getrecentgoldslist_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    self:show_float_message("获取指定活动的广告列表")
end


--3.5.9   获取活动积分详细列表接口(命令：getactivitypointsdetail)
--activityid    是   活动编号    String  
--playerloginname 否   要对比的玩家登录名   String  如果不传此参数则只取玩家本人的积分详细
--排行榜中的对比排行榜  和个人积分
function Server:getactivitypointsdetail(activityid,playerloginname)
    local params = {}
    params={
            activityid =activityid,
            playerloginname =playerloginname,
        }
    self:request_http("getactivitypointsdetail" , params ); 
end

function Server:getactivitypointsdetail_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getactivitypointsdetail(self.data)--保存数据
    if self.data["playerpointslist"] then
        NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE)
    end
      NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.ONERECORD_LAYER_IMAGE)
end


--3.5.10   获取活动获奖名单接口（命令：getactivitywinners）
--activityid    是   活动编号    String
function Server:getactivitywinners(activityid)

    local params = {}
    params={
            activityid =activityid,
        }

    self:request_http("getactivitywinners" , params ); 
end

function Server:getactivitywinners_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    self:show_float_message("获取指定活动的广告列表")
    LocalData:Instance():set_getactivitywinners(self.data)--保存数据
end

-- 3.5.11   获取活动奖品详细列表接口
-- activityid    是   活动编号    String
function Server:getactivityawards(activityid)
    local params = {}
    params={
            activityid =activityid,
        }
    self:request_http("getactivityawards" , params ); 
end

function Server:getactivityawards_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动的广告列表失败:" .. self.data.err_msg)
        return
    end
    self:show_float_message("获取指定活动的广告列表")
end

-- 3.5.12   验证惊喜吧活动码接
-- code 是   活动码 String
function Server:validateactivitycode(code)
    local params = {}
    params={
            code =code,
        }
    self:request_http("validateactivitycode" , params ); 
end

function Server:validateactivitycode_callback()
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("活动码失败")
        return
    end
    self:show_float_message("活动码成功")
    -- self:show_float_message("获取指定活动的广告列表")
end

--记录游戏数据 3.3.3 --校检完成
--type 0,表示奖池类型和惊喜吧类型，1 专题活动类型
--adid    广告编号    String  Guid
--imageid   是   比赛使用的图片编号   String  Guid
function Server:setgamerecord(adid,imageid)
    -- MD5_KEY="PINLEGAMERECORD"
    local settingid="FE9ABC0E-CEE5-4F11-9BC3-16E0EE4A342C"
    -- if tonumber(type)==1 then
    --     settingid="850E3EB7-1C39-4328-ABB7-76DF387DEA77"
    -- end
    local params = {}
    params={
            gamesettingid=settingid,
            adid=adid,
            imageid="9D2E7A7B-369C-4719-B4D8-0A4EBC5DDE57",--imageid,
            starttime=os.time(),
            finishtime=os.time(),
            steps="steps1",
            time="54"

        }
    self:request_http("setgamerecord" , params ); 
end


function Server:setgamerecord_callback()
    -- MD5_KEY="PINLEGAME"
    dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("拼图上传数据失败:" .. self.data.err_msg)
        return
    end
     LocalData:Instance():set_setgamerecord(self.data)--保存数据
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GAMERECORD_POST)
end























