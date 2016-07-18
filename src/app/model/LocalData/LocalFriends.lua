--
-- Author: peter
-- Date: 2016-06-17 14:46:23
--
--查询好友列表
function LocalData:setfriendlist(setfriendlis)
	self.setfriendlis=setfriendlis
end

function LocalData:getfriendlist()
	return self.setfriendlis or nil
end

--领取好友升级奖励积分&金币
function LocalData:set_reward_friend(reward_friend)
	self.reward_friend=reward_friend
	-- dump(self.reward_friend)
end

function LocalData:get_reward_friend()
	-- dump(self.reward_friend)
	return self.reward_friend or nil
end

--查询好友升级奖励金币列表
function LocalData:set_reward_friend_list(reward_friend_list)
	self.reward_friend_list=reward_friend_list
end

function LocalData:get_reward_friend_list()
	return self.reward_friend_list or nil
end

--查询邀请好友奖励配置列表接口
function LocalData:set_reward_setting_list(reward_setting)
	self.reward_setting=reward_setting
end

function LocalData:get_reward_setting_list()
	return self.reward_setting or nil
end


--领取邀请好友奖励接口
function LocalData:set_friend_reward_setting(set_friend_reward)
	self.set_friend_reward=set_friend_reward
end

function LocalData:get_friend_reward_setting()
	return self.set_friend_reward or nil
end
--一键领取
function LocalData:set_reward_of_friends_levelup(levelup)
	self.levelup=levelup
end

function LocalData:get_reward_of_friends_levelup()
	return self.levelup or nil
end




















