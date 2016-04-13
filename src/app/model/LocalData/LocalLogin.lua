--
-- Author: Your Name
-- Date: 2015-12-11 16:44:27
--
--[[
	--登陆相关
]]


function LocalData:set_server_list(server_list)
	self.server_list=server_list
end

function LocalData:get_server_list()
	return self.server_list
end