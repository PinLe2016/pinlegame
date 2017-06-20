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
    -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message(self.data.err_msg)
        NotificationCenter:Instance():PostNotification("xiugainicheng")
        return
    end
    --self:show_float_message("信息修改成功!")
    LocalData:Instance():set_userinfo(self.data)--保存数据
     NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.USERINFO_LAYER_IMAGE)
     Server:Instance():getuserinfo()
   
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
      --dump(self.data)
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
     -- dump(self.data)
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
     -- dump(self.data)
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
    -- dump(self.data)
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
function Server:setconsignee(name,phone,address)
    local params = {}
     params={
            name=name,
            phone=phone,
            address=address,
        }
    self:request_http("setconsignee" , params); 
end

function Server:setconsignee_callback()
    -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    NotificationCenter:Instance():PostNotification("setconsignee_call")

end

function Server:getconsignee()
    local params = {}
     params={
            
        }
    self:request_http("getconsignee" , params); 
end

function Server:getconsignee_callback()
    if self.data.err_code~=0  then
        self:show_float_message(self.data.err_msg)
        return
    end
   LocalData:Instance():set_getconsignee(self.data)
   NotificationCenter:Instance():PostNotification("getconsignee")

end




-------邮件系统

--3.4.8 获取公告消息（命令：getaffichelist ） type  默认1是邮件  2  是公告
function Server:getaffichelist (_pageno,_type)
    local params = {
     pagesize=7,
     pageno=_pageno,
     type=_type
}
 
    self:request_http("getaffichelist" , params); 
end

function Server:getaffichelist_callback()
       --dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
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
    -- dump(self.data)
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
    -- dump(self.data)
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
    -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message("玩家反馈:" .. self.data.err_msg)
        return
    end
    LocalData:Instance():set_setfeedback(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.FEEDBACK)
end
--3.2.20   获取玩家金币排行榜  pagesize 每页显示数据  pageno页号  type 0日榜、1周榜、2月榜、3年榜 
function Server:getgoldsranklist(pagesize,pageno,type)
      local params = {
                 pagesize=pagesize,
                 pageno=pageno,
                 type=type
            }

    self:request_http("getgoldsranklist" , params); 
end

function Server:getgoldsranklist_callback()
     -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getgoldsranklist(self.data)--保存玩家数据  AFFICHLIST
    NotificationCenter:Instance():PostNotification("RICHLIST")
end
--  获取音效  0开启  1关闭   （默认开启
function Server:getconfig()
      local params = {
                 
            }

    self:request_http("getconfig" , params); 
end

function Server:getconfig_callback()
     dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getconfig(self.data)--
    NotificationCenter:Instance():PostNotification("XINYUE")
end
--设置音效  0开启  1关闭
function Server:setconfig(itemsId ,status)
      local list={
                  {status=status,itemsId=itemsId}
               }
      local params = {
            list=list
                
            }

    self:request_http("setconfig" , params); 
end
function Server:setconfig_callback()
     -- dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getconfig(self.data)--
end




----成长树相关接口



--3.9.1 获取成长树列表接口（命令：gettreelist）
--friendplayerid  否 好友playerId  Guid  查看好友的成长树，为空时自己的成长树

function Server:gettreelist(friendplayerid)
      local params = {
              friendplayerid=friendplayerid
            }

    self:request_http("gettreelist" , params); 
end
function Server:gettreelist_callback()

    if self.data.err_code~=0  then
        --self:show_float_message( self.data.err_msg)
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        return
    end
    LocalData:Instance():set_gettreelist(self.data)--
    NotificationCenter:Instance():PostNotification("MESSAGE_GETTREELIST")
end

--3.9.2 好友列表接口（命令：gettreefriendlist）
--pagesize  是 每页显示数据  int 
--pageno  是 页号  Int 第一页为1
--type  是 好友类型  Int 1我的好友，2我的员工

function Server:gettreefriendlist(pagesize,pageno,type)
      local params = {
                pagesize=pagesize,
                pageno=pageno,
                type=type
            }

    self:request_http("gettreefriendlist" , params); 
end
function Server:gettreefriendlist_callback()
     -- dump(self.data)
    if self.data.err_code~=0  then
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        return
    end
    LocalData:Instance():set_gettreefriendlist(self.data)--
    NotificationCenter:Instance():PostNotification("MESSAGE_GETTREEFRIENDLIST")
end

--3.9.3 背包接口（命令：gettreegameitemlist）

function Server:gettreegameitemlist(type)  --1化肥 2种子 3化肥和种子
      local params = {
              type=type
            }

    self:request_http("gettreegameitemlist" , params); 
end
function Server:gettreegameitemlist_callback()
    -- dump(self.data)
    if self.data.err_code~=0  then
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        return
    end
    
    LocalData:Instance():set_gettreegameitemlist(self.data)--
    NotificationCenter:Instance():PostNotification("MESSAGE_GSTTREEGAMEITEMLIST")
end

--3.9.4 成长树种子种植接口（命令：setseedplant）
--treeid  是 成长树标识ID Guid  
--gameitemid  是 种子道具ID  GUID  

function Server:setseedplant(treeid,gameitemid,seatcount)
      local params = {
              treeid=treeid,
              gameitemid=gameitemid,
                seatcount=seatcount
            }

    self:request_http("setseedplant" , params); 
end
function Server:setseedplant_callback()
     --dump(self.data)
    if self.data.err_code~=0  then
       Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
       NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDPLANT_FALSE")
        return
    end
    --Server:Instance():Grawpopup_box_buffer("种植成功")

    -- LocalData:Instance():set_getconfig(self.data)--
    NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDPLANT")
end


--3.9.5 成长树种子浇水接口（命令：setseedwater）
--treeid  是 成长树标识ID Guid  
--seedid  是 种子标识ID  GUID  

function Server:setseedwater(treeid,seedid)
      local params = {
              treeid=treeid,
              seedid=seedid
            }

    self:request_http("setseedwater" , params); 
end
function Server:setseedwater_callback()
     --dump(self.data)
    if self.data.err_code~=0  then
        --self:show_float_message( self.data.err_msg)
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        return
    end
     LocalData:Instance():set_setseedwater(self.data)--
    --Server:Instance():Grawpopup_box_buffer("浇水成功")
    NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDWATER")
end

--3.9.6 成长树种子施肥接口（命令：setseedmanure）

--treeid  是 成长树标识ID Guid  
--seedid  是 种子标识ID  GUID  
--gameitemid  是 化肥道具编号  GUID  种子/化肥编号ID

function Server:setseedmanure(treeid,seedid,gameitemid)
      local params = {
              treeid=treeid,
              seedid=seedid,
              gameitemid=gameitemid
            }

    self:request_http("setseedmanure" , params); 
end
function Server:setseedmanure_callback()
     --dump(self.data)
    if self.data.err_code~=0  then
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDMANURE_FALSE")
        return
    end
    
    LocalData:Instance():set_setseedmanure(self.data)--
    --Server:Instance():Grawpopup_box_buffer("施肥成功")
    NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDMANURE")
end

--3.9.7 成长树种子收获/偷取接口（命令：setseedreward）
--treeid  是 成长树标识ID Guid  
--seedid  是 种子标识ID  GUID  


function Server:setseedreward(treeid,seedid)
      local params = {
              treeid=treeid,
              seedid=seedid

            }

    self:request_http("setseedreward" , params); 
end
function Server:setseedreward_callback()
     -- dump(self.data)
    if self.data.err_code~=0  then
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDREWARD_FALSE")
        return
    end
     LocalData:Instance():set_setseedreward(self.data)--
    --Server:Instance():Grawpopup_box_buffer("收获成功")
    NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDREWARD")
end

--3.9.8 成长树种子铲除接口（命令：setseedremove）
--treeid  是 成长树标识ID Guid  
--seedid  是 种子标识ID  GUID  


function Server:setseedremove(treeid,seedid)
      local params = {
              treeid=treeid,
              seedid=seedid

            }

    self:request_http("setseedremove" , params); 
end
function Server:setseedremove_callback()
     --dump(self.data)
    if self.data.err_code~=0  then
        Server:Instance():Grawpopup_box_buffer(self.data.err_msg)
        return
    end
    -- LocalData:Instance():set_getconfig(self.data)--
     --Server:Instance():Grawpopup_box_buffer("铲除成功")
     NotificationCenter:Instance():PostNotification("MESSAGE_SETSEEDREMOVE")
end


function Server:share_title() 
    local url="http://123.57.136.223:1033/shareinfo.aspx"
    local request = network.createHTTPRequest(function(event) self:share_title_callback(event,command) end, url , "GET")
    request:setTimeout(0.5)
    request:start()
end

function Server:share_title_callback(event , command)
    local ok = (event.name == "completed")
    local request = event.request

    if not ok then return end

    local code = request:getResponseStatusCode()

    if code ~= 200 then
        print("response status code : " .. code)
        return
    end

    local dataRecv = request:getResponseData()
     LocalData:Instance():set_share_title(dataRecv)
end

