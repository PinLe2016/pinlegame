--
-- Author: peter
-- Date: 2016-06-14 14:53:52
--
--用户所有数据

function LocalData:set_userdata(userdata)
	cc.UserDefault:getInstance():setStringForKey("user_data" ,json.encode(userdata))
end

function LocalData:get_userdata()
	local user_data=cc.UserDefault:getInstance():getStringForKey("user_data")
	return json.decode(user_data) or nil
end


--16获取玩家手机归属地

function LocalData:set_getusercitybyphone(getusercity)
	self.getusercity=getusercity
end

function LocalData:getusercitybyphone()
	-- dump(self.getusercity)
	return self.getusercity or nil
end

