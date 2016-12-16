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

function LocalData:set_user_head(userdata)
	-- dump(userdata)
	cc.UserDefault:getInstance():setStringForKey("user_head" ,userdata)
end

function LocalData:get_user_head()
	local user_head=cc.UserDefault:getInstance():getStringForKey("user_head","cre/httpgame.pinlegame.comheadheadicon_0.jpg")
	return user_head or nil
end
--16获取玩家手机归属地

function LocalData:set_getusercitybyphone(getusercity)
	self.getusercity=getusercity
end

function LocalData:getusercitybyphone()
	-- dump(self.getusercity)
	return self.getusercity or nil
end

----------邮件相关
function LocalData:set_getaffiche(getaffiche)
	--self.getaffiche=getaffiche
	if  not getaffiche then
	     self.getaffiche=getaffiche
	     return
	end
	if self.getaffiche then
		for k,v in pairs(getaffiche["affichelist"]) do

			table.insert(self.getaffiche["affichelist"],v)
		end
		return
	end
	self.getaffiche=getaffiche

end

function LocalData:get_getaffiche()
	-- dump(self.getusercity)
	return self.getaffiche or nil
end
--邮件详情
function LocalData:set_getaffichedetail(getaffichedetail)
	self.getaffichedetail=getaffichedetail
end

function LocalData:get_getaffichedetail()
	return self.getaffichedetail or nil
end
--删除邮件
function LocalData:set_delaffichebyid(delaffichebyid)
	self.delaffichebyid=delaffichebyid
end

function LocalData:get_delaffichebyid()
	return self.delaffichebyid or nil
end
--领取邮件奖励
function LocalData:set_getaffichereward(getaffichereward)
	self.getaffichereward=getaffichereward
end

function LocalData:get_getaffichereward()
	return self.getaffichereward or nil
end
--玩家反馈
function LocalData:set_setfeedback(_setfeedback)
	self._setfeedback=_setfeedback
end

function LocalData:get_setfeedback()
	return self._setfeedback or nil
end
--惊喜吧点击屏幕继续
function LocalData:set_continue(continue,key)
	cc.UserDefault:getInstance():setStringForKey(continue ,key)
end

function LocalData:get_continue(continue)
	local _key=cc.UserDefault:getInstance():getStringForKey(continue,key)
	return _key or nil
end
--完善信息
function LocalData:set_per(per)
	cc.UserDefault:getInstance():setStringForKey("per" ,per)
end

function LocalData:get_per()
	local _key=cc.UserDefault:getInstance():getStringForKey("per")
	return _key or nil
end
--获取玩家金币排行榜
function LocalData:set_getgoldsranklist(getgoldsranklist)
	self.getgoldsranklist=getgoldsranklist
end

function LocalData:get_getgoldsranklist()
	return self.getgoldsranklist or nil
end
--地鼠积分
--完善信息
function LocalData:setPoints(Points)
	cc.UserDefault:getInstance():setStringForKey("Points" ,Points)
end

function LocalData:getPoints()
	local _key=cc.UserDefault:getInstance():getStringForKey("Points")
	return _key or nil
end
--  拼图步数
function LocalData:setTheycount(count)
	cc.UserDefault:getInstance():setStringForKey("count",count)
end

function LocalData:getTheycount()
	local _key=cc.UserDefault:getInstance():getStringForKey("count")
	return _key or -1
end
--拼图时间
function LocalData:setpuzzletime(time)
	cc.UserDefault:getInstance():setStringForKey("time" ,time)
end

function LocalData:getpuzzletime()
	local _key=cc.UserDefault:getInstance():getStringForKey("time")
	return _key or -1
end
















