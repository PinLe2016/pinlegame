--
-- Author: Your Name
-- Date: 2015-12-11 16:44:27
--
--[[
	--登陆相关
]]


function LocalData:set_user_list(server_list)
	self.server_list=server_list
end

function LocalData:get_user_list()
	return self.server_list
end

--保存登陆数据
function LocalData:set_user_data(user_data)
	cc.UserDefault:getInstance():setStringForKey("user_data" ,json.encode(user_data))
end
function LocalData:get_user_data()
	local user_data=cc.UserDefault:getInstance():getStringForKey("user_data")
	return json.decode(user_data) or {}
end
