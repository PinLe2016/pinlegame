--
-- Author: peter
-- Date: 2016-05-23 10:48:37
--
function LocalPerInformation:set_userinfo(getuserinfo)
	self.getuserinfo=getuserinfo
end
function LocalPerInformation:get_userinfo()
	return self.getuserinfo or {}
end
function LocalPerInformation:set_userinfoinit(getuserinfo)
	self.getuserinfo=getuserinfo
end
function LocalPerInformation:set_userinfoinit()
	return self.getuserinfo or {}
end
