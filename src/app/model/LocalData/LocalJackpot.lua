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


function LocalData:set_user_time(userdata)
	cc.UserDefault:getInstance():setStringForKey("userid" ,userdata)
end

function LocalData:get_user_time()
	local user_head=cc.UserDefault:getInstance():getStringForKey("userid","0")
	return user_head or nil
end
function LocalData:set_user_oid(userid)
	cc.UserDefault:getInstance():setStringForKey("userid" ,userid)
end

function LocalData:get_user_oid()
	local user_id=cc.UserDefault:getInstance():getStringForKey("userid"," ")
	return user_id or nil
end
function LocalData:set_user_adownerid(adownerid)
	cc.UserDefault:getInstance():setStringForKey("adownerid" ,adownerid)
end

function LocalData:get_user_adownerid()
	local adownerid=cc.UserDefault:getInstance():getStringForKey("adownerid"," ")
	return adownerid or nil
end





