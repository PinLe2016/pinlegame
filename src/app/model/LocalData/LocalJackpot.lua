--
-- Author: peter
-- Date: 2016-05-31 10:53:20
--
function LocalData:set_getgoldspoollist(getgoldspoollist)
	self.getgoldspoollist=getgoldspoollist
end
function LocalData:get_getgoldspoollist()
	return self.getgoldspoollist or {}
end
function LocalData:set_getgoldspoollistbale(getgoldspoollistbale)
	self.getgoldspoollistbale=getgoldspoollistbale
end
function LocalData:get_getgoldspoollistbale()
	return self.getgoldspoollistbale or {}
end

function LocalData:set_getgoldspoolbyid(getgoldspoolbyi)
	self.getgoldspoolbyid=getgoldspoolbyi
end
function LocalData:get_getgoldspoolbyid()
	return self.getgoldspoolbyid or {}
end

function LocalData:set_getrecentgoldslist(getrecentgoldslist)
	self.getrecentgoldslist=getrecentgoldslist
end
function LocalData:get_getrecentgoldslist()
	return self.getrecentgoldslist or {}
end


function LocalData:set_getgoldspoolrandomgolds(getgoldspoolrandomgolds)
	self.getgoldspoolrandomgolds=getgoldspoolrandomgolds
end
function LocalData:get_getgoldspoolrandomgolds()
	return self.getgoldspoolrandomgolds or nil
end


function LocalData:set_user_time(userid,userdata)
	cc.UserDefault:getInstance():setStringForKey(tostring(userid) ,userdata)
end

function LocalData:get_user_time(userkey)
	local user_head=cc.UserDefault:getInstance():getStringForKey(tostring(userkey),"0")
	return user_head or nil
end
-- function LocalData:set_user_id(userid)
-- 	cc.UserDefault:getInstance():setStringForKey(userid ,userid)
-- end

-- function LocalData:get_user_id()
-- 	local user_id=cc.UserDefault:getInstance():getStringForKey("userid"," ")
-- 	return user_id or nil
-- end



