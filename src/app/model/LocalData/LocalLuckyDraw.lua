--
-- Author: peter
-- Date: 2017-06-19 14:48:08
--  新版大转盘
function LocalData:set_getfortunewheelrewards(getfortunewheelrewards)
	self.getfortunewheelrewards=getfortunewheelrewards
end

function LocalData:get_getfortunewheelrewards()
	return self.getfortunewheelrewards or nil
end
function LocalData:set_getrecentfortunewheelrewardlist(getrecentfortunewheelrewardlist)
	self.getrecentfortunewheelrewardlist=getrecentfortunewheelrewardlist
end

function LocalData:get_getrecentfortunewheelrewardlist()
	return self.getrecentfortunewheelrewardlist or nil
end
function LocalData:set_getfortunewheelrandomreward(getfortunewheelrandomreward)
	self.getfortunewheelrandomreward=getfortunewheelrandomreward
end

function LocalData:get_getfortunewheelrandomreward()
	return self.getfortunewheelrandomreward or nil
end