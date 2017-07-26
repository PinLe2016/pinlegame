--
-- Author: peter
-- Date: 2016-05-31 10:49:44
---获取金币奖池列表
--pagesize 否 每页显示数据 int
--pageno 否 页号 第一页为1


function Server:getgoldspoollist(params)
       local _params = params
       self._adownerid=params.adownerid
    self:request_http("getgoldspoollist" , _params ); 
end


function Server:getgoldspoollist_callback()
        dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取奖池专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldspoollist(self.data)--保存数据
    if self._adownerid ~= "" then
         NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST)
         return
    end
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.JACKPOTLIST_POST)
   
end
---获取金币奖池的广告列表  1
function Server:getgoldspooladlist(activityid)
       local _params ={}
       _params={
            goldspoolid=activityid
   }
       -- dump(_params)
   
    self:request_http("getgoldspooladlist" , _params ); 
end


function Server:getgoldspooladlist_callback()
       dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取奖池专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldspoollistbale(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.ACTIVITYYADLIST_LAYER_IMAGE)  --这个已经废了JACKPOTLIST_INFOR_POST
   
end

--3.6.3获取指定金币奖池详情(命令：getgoldspoolbyid)   2
--goldspoolid 是 金币奖池ID  String  GUID
function Server:getgoldspoolbyid(activityid)
       local _params ={}
       _params={
            goldspoolid=activityid
   }
   
    self:request_http("getgoldspoolbyid" , _params ); 
end


function Server:getgoldspoolbyid_callback()
       -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取奖池专区列表失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldspoolbyid(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST)
   
end

--3.6.4 获取最近10次金币奖池金币奖励接口(getrecentgoldslist)
--count 是 获得多少个 ints
function Server:getrecentgoldslist(count)
       local _params ={}
       _params={
            count=count
   }
   
    self:request_http("getrecentgoldslist" , _params ); 
end


function Server:getrecentgoldslist_callback()
      -- dump(self.data)
    if self.data.err_code~=0  then
         self:show_float_message("获取最近10次金币奖池金币奖励失败:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_getrecentgoldslist(self.data)--保存数据
    --NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.RECENTGOLDSLIST_POST)
   
end

 --3.6.5获取用户金币奖池随机金币奖励（命令：getgoldspoolrandomgolds）
 --goldspoolid  是 金币奖池ID  string
 --usedoublecard  否 是否使用增倍卡 Integer 1是使用，不填或者其他数字代表不使用
function Server:getgoldspoolrandomgolds(goldspoolid,usedoublecard,points)

       local _params ={}
       _params={
            usedoublecard=usedoublecard,
            points=points,
            goldspoolid=goldspoolid,
   }
   -- dump(_params)
   
    self:request_http("getgoldspoolrandomgolds" , _params ); 
end


function Server:getgoldspoolrandomgolds_callback()
      -- dump(self.data)
    if self.data.err_code~=0  then

        self:show_float_message("" .. self.data.err_msg)

        return
    end
    LocalData:Instance():set_getgoldspoolrandomgolds(self.data)--保存数据
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS)
   
end
--目的是给另一个场景传递信息
function Server:sceneinformation()
  print("5545645645644")
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.BACKSUPPOR)
     
end
--领取金币奖池广告链接金币
function Server:setgoldspooladurlreward(adid )
       local _params ={}
       _params={
            adid =adid 
   }
   
    self:request_http("setgoldspooladurlreward" , _params ); 
end


function Server:setgoldspooladurlreward_callback()
      -- dump(self.data)
    if self.data.err_code~=0  then
         self:show_float_message("领取金币奖池广告链接金币:" .. self.data.err_msg)
        return
    end
end

--  3.6.7   获得某一金币奖池上一场的奖励信息
function Server:getgoldspoolreward(goldspoolid)
       local _params ={}
       _params={
            goldspoolid=goldspoolid
   }
   
    self:request_http("getgoldspoolreward" , _params ); 
end
function Server:getgoldspoolreward_callback()
      dump(self.data)
    if self.data.err_code~=0  then
         self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldspoolreward(self.data)--保存数据
    NotificationCenter:Instance():PostNotification("GETGOLDSPOOLREWARD")
   
end
--  首页好友助力榜
function Server:getfriendhelplist(_type)
       local _params ={}
       _params={
            _type=_type
   }
   
    self:request_http("getfriendhelplist" , _params ); 
end


function Server:getfriendhelplist_callback()
       -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("获取奖池专区列表失败:" .. self.data.err_msg)
        return
    end
    -- LocalData:Instance():set_getgoldspoolbyid(self.data)--保存数据
    -- NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST)
   
end




