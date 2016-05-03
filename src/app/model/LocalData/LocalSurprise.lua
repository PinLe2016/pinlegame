--
-- Author: peter
-- Date: 2016-04-29 14:25:54
--
-- 获取活动专区列表
function LocalData:set_getactivitylist(getactivitylist)
	self.getactivitylist=getactivitylist
end
function LocalData:get_getactivitylist()
	return self.getactivitylist or {}
end

-- 获取指定活动详情
function LocalData:set_getactivitybyid(getactivitybyid)
	self.getactivitybyid=getactivitybyid
end
function LocalData:get_getactivitybyid()
	return self.getactivitybyid or {}
end


-- 获取活动的排行榜
function LocalData:set_getranklistbyactivityid(getranklistbyactivityid)
	self.getranklistbyactivityid=getranklistbyactivityid
end
function LocalData:get_getranklistbyactivityid()
	return self.getranklistbyactivityid or {}
end

--  获取指定活动的广告列表
function LocalData:set_getactivityadlist(getactivityadlist)
	self.getactivityadlist=getactivityadlist
end
function LocalData:get_getactivityadlist()
	return self.getactivityadlist or {}
end

-- 获取用户活动老虎机积分
function LocalData:set_getactivitypoints(getactivitypoints)
	self.getactivitypoints=getactivitypoints
end
function LocalData:get_getactivitypoints()
	return self.getactivitypoints or {}
end


-- 获取活动积分详细列表接口
function LocalData:set_getactivitypointsdetail(getactivitypointsdetail)
	self.getactivitypointsdetail=getactivitypointsdetail
end
function LocalData:get_getactivitypointsdetail()
	return self.getactivitypointsdetail or {}
end


-- 获取活动获奖名单接口
function LocalData:set_getactivitywinners(getactivitywinners)
	self.getactivitywinners=getactivitywinners
end
function LocalData:get_getactivitywinners()
	return self.getactivitywinners or {}
end












