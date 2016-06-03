--
-- Author: peter
-- Date: 2016-05-31 10:53:20
--
function LocalData:set_getgoldspoollist(setuserinfo)
	self.setuserinfo=setuserinfo
end
function LocalData:get_getgoldspoollist()
	return self.setuserinfo or {}
end
function LocalData:set_getgoldspoollistbale(setuserinfo)
	self.setuserinfo=setuserinfo
end
function LocalData:get_getgoldspoollistbale()
	return self.setuserinfo or {}
end
