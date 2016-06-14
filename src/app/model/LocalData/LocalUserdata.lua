--
-- Author: peter
-- Date: 2016-06-14 14:53:52
--
--用户所有数据

function LocalData:set_userdata(userdata)
	self.userdata=userdata
end

function LocalData:get_userdata()
	return self.userdata
end
