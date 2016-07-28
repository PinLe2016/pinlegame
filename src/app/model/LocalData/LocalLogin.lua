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
	LocalData:Instance():set_userdata(json.decode(user_data))--保存数据
	return json.decode(user_data) or nil
end

--版本号
function LocalData:set_version(user_version)
	cc.UserDefault:getInstance():setStringForKey("user_version" ,json.encode(user_version))
end
function LocalData:get_version()
	local user_version=cc.UserDefault:getInstance():getStringForKey("user_version","3.0")
	return user_version or "3.0"
end

function LocalData:set_version_date(version_date)
	self.version_date=version_date
end

function LocalData:get_version_date()
	return self.version_date or nil
end


function LocalData:set_music(_music)

	cc.UserDefault:getInstance():setBoolForKey("music" ,_music)
end

function LocalData:get_music()
	-- cc.UserDefault:getInstance():removeFile("music")
	local _music=cc.UserDefault:getInstance():getBoolForKey("music",true)
	dump(_music)
	return _music or true
end
--注册验证码
function LocalData:set_sendmessage(server_code)
	self.server_code=server_code
end

function LocalData:get_sendmessage()
	return self.server_code
end


















