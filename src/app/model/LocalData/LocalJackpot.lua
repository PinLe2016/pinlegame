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

function LocalData:set_getgoldspoolbyid(getgoldspoolbyid)
	self.getgoldspoolbyid=getgoldspoolbyid
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
