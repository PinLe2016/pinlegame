--
-- Author: peter
-- Date: 2017-06-19 14:45:05
--新版大转盘
--3.6.8 获得大转盘的奖励列表（命令：getfortunewheelrewards）
function Server:getfortunewheelrewards(_goldcost)
       local _params ={}
       _params={
            goldcost=_goldcost
   }
    self:request_http("getfortunewheelrewards" , _params ); 
end


function Server:getfortunewheelrewards_callback()
       --dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getfortunewheelrewards(self.data)--保存数据
    NotificationCenter:Instance():PostNotification("GAME_GETFORTUNEWHEELREWARDS")  
   
end
--3.6.9  获取最近10次大转盘奖励接口(getrecentfortunewheelrewardlist)
function Server:getrecentfortunewheelrewardlist()
       local _params ={}
       _params={
          -- count=_count
   }
    self:request_http("getrecentfortunewheelrewardlist" , _params ); 
end


function Server:getrecentfortunewheelrewardlist_callback()
       dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getrecentfortunewheelrewardlist(self.data)--保存数据
    NotificationCenter:Instance():PostNotification("GAME_GETRECENTFORTUNEWHEELREWARDLIST")  
   
end
--3.6.10  获取大转盘随机奖励接口(getfortunewheelrandomreward)
function Server:getfortunewheelrandomreward()
       local _params ={}
       _params={
          -- count=_count
   }
    self:request_http("getfortunewheelrandomreward" , _params ); 
end


function Server:getfortunewheelrandomreward_callback()
       dump(self.data)
    if self.data.err_code~=0  then
        self:show_float_message( self.data.err_msg)
        return
    end
    LocalData:Instance():set_getfortunewheelrandomreward(self.data)--保存数据
    NotificationCenter:Instance():PostNotification("GAME_GETFORTUNEWHEELRANDOMREWARD")  
   
end