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
	local user_head=cc.UserDefault:getInstance():getStringForKey("user_head","png/httpgame.pinlegame.comheadheadicon_7.jpg")
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
	local _key=cc.UserDefault:getInstance():getStringForKey("Points",0)
	return _key 
end
--  拼图步数
function LocalData:setTheycount(count)
	cc.UserDefault:getInstance():setStringForKey("count",count)
end

function LocalData:getTheycount()
	local _key=cc.UserDefault:getInstance():getStringForKey("count","100")
	return _key 
end
--拼图时间
function LocalData:setpuzzletime(time)
	cc.UserDefault:getInstance():setStringForKey("time" ,time)
end

function LocalData:getpuzzletime()
	local _key=cc.UserDefault:getInstance():getStringForKey("time","100")
	return _key
end
--  获取音效
function LocalData:set_getconfig(getconfig)
	self.getconfig=getconfig
	local _list = getconfig["list"]
	local _list1=_list[1]["sataus"]
	local _list2=_list[2]["sataus"]

	local bool_music=false
	local bool_sound=false
	if tonumber(_list1)==0 then
		bool_music=true
	end

	if tonumber(_list2)==0 then
		bool_sound=true
	end

	
	LocalData:Instance():set_music(bool_sound)
	LocalData:Instance():set_music_hit(bool_music)
end

function LocalData:get_getconfig()
	return self.getconfig or nil
end
-- 设置音效
-- function LocalData:set_setconfig(setconfig)
-- 	self.setconfig=setconfig
-- end

-- function LocalData:get_setconfig()
-- 	return self.setconfig or nil
-- end


----成长树相关接口

--3.9.1 获取成长树列表接口
function LocalData:set_gettreelist(gettreelist)
	self.gettreelist=gettreelist
end

function LocalData:get_gettreelist()
	return self.gettreelist or nil
end

--3.9.2 好友列表接口（命令：gettreefriendlist）
function LocalData:set_gettreefriendlist(gettreefriendlist)
	self.gettreefriendlist=gettreefriendlist
end

function LocalData:get_gettreefriendlist()
	return self.gettreefriendlist or nil
end

--3.9.3 背包接口（命令：gettreegameitemlist）
function LocalData:set_gettreegameitemlist(gettreegameitemlist)
	self.gettreegameitemlist=gettreegameitemlist
end

function LocalData:get_gettreegameitemlist()
	return self.gettreegameitemlist or nil
end
--  浇水
function LocalData:set_setseedwater(_setseedwater)
	self._setseedwater=_setseedwater
end

function LocalData:get_setseedwater()
	return self._setseedwater or nil
end
--  施肥
function LocalData:set_setseedmanure(_setseedmanure)
	self._setseedmanure=_setseedmanure
end

function LocalData:get_setseedmanure()
	return self._setseedmanure or nil
end
--收获
function LocalData:set_setseedreward(_setseedreward)
	self._setseedreward=_setseedreward
end

function LocalData:get_setseedreward()
	return self._setseedreward or nil
end

--收获
function LocalData:set_share_title(_setseedreward)
	local title=Util:lua_string_split(_setseedreward,"@")
	dump(title)
	self.share_title={
			title=title[1],
			content=title[2]
		}
	dump(self.share_title)
end

function LocalData:get_share_title()
	if not self.share_title then
		self.share_title={
			title="玩拼乐，赚现金！",
			content="玩拼乐，赚现金！"
		}
	end
	return self.share_title 
end














