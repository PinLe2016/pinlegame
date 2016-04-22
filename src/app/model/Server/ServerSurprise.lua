--
-- Author: peter
-- Date: 2016-04-22 13:25:00
--
--惊喜吧数据传输接口

--3.5.1 获取活动专区列表

--status	是	要获取的数据状态	String	0未开始1已开始2已结束3全部
function Server:getsactivitieslist(status)
    local params = {}
    params={
            status=status
        }
    self:request_http("getsactivitieslist" , params ); 
end


function Server:getsactivitieslist_callback()
    if self.data.err_code~=0  then
        self:show_float_message("获取活动专区列表失败:" .. self.data.err_msg)
        return
    end

    LocalData:Instance():set_save_user_data(self.data)--保存玩家数据
    self:show_float_message("获取活动专区列表")
end


--获取指定活动详情  activitieid	是	活动ID	String	GUID
function Server:getactivitybyid(activityid )
    local params = {}
    params={
            activityid=activityid
        }
    self:request_http("getsactivitieslist" , params ); 
end


function Server:getactivitybyid_callback()
    if self.data.err_code~=0  then
        self:show_float_message("获取指定活动详情失败:" .. self.data.err_msg)
        return
    end

    LocalData:Instance():set_save_user_data(self.data)--保存玩家数据
    self:show_float_message("获取指定活动详情")
end