--
-- Author: peter
-- Date: 2016-06-17 14:46:23
--
--查询好友列表
function LocalData:setfriendlist(setfriendlist)
	self.setfriendlist=setfriendlist
end

function LocalData:getfriendlist()
	return self.setfriendlist or nil
end

--领取好友升级奖励积分&金币
function LocalData:set_reward_friend(reward_friend)
	self.reward_friend=reward_friend
end

function LocalData:get_reward_friend()
	return self.reward_friend or nil
end

--查询好友升级奖励金币列表
function LocalData:set_reward_friend_list(reward_friend_list)
	self.reward_friend_list=reward_friend_list
end

function LocalData:get_reward_friend_list()
	return self.reward_friend_list or nil
end