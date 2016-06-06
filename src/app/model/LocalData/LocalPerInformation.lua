--
-- Author: peter
-- Date: 2016-05-23 10:48:37
--
function LocalData:set_userinfo(setuserinfo)
	self.setuserinfo=setuserinfo
end
function LocalData:get_userinfo()
	return self.setuserinfo or {}
end
function LocalData:set_getuserinfo(getuserinfo)

	self.getuserinfo=getuserinfo
end
function LocalData:get_getuserinfo()
	return self.getuserinfo or {}
end
--签到
function LocalData:set_checkin(getcheckin)

	self.getcheckin=getcheckin
end
function LocalData:get_checkin()
	return self.getcheckin or {}
end
--签到历史
function LocalData:set_getcheckinhistory(getcheckinhistory)

	self.getcheckinhistory=getcheckinhistory
end
function LocalData:get_getcheckinhistory()
	return self.getcheckinhistory or {}
end
