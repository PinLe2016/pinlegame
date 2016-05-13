--
-- Author: peter
-- Date: 2016-05-09 16:51:21
--
local ContrastRecordLayer = class("ContrastRecordLayer", function()
            return display.newLayer("ContrastRecordLayer")
end)
--标题 头像 名字 排名  等级
function ContrastRecordLayer:ctor()
       self.id=params.id--activityid
       self.title=params.title--标题
       self.head=params.head--hero 头像
       self.name=params.name -- hero名称
       self.rank=params.rank --hero 排名
       self.level=params.level --hero 等级
       self.heroid=params.heroid --hero ID 
       self.allscore=params.allscore --总积分

       Server:Instance():getactivitypointsdetail(self.id,self.heroid)  --对比排行榜HTTP
       self:setNodeEventEnabled(true)--layer添加监听

       
end
function ContrastRecordLayer:init(  )
	self.ContrastRecordLayer = cc.CSLoader:createNode("ContrastRecordLayer.csb");
    	self:addChild(self.ContrastRecordLayer)

    	local activitybyid=LocalData:Instance():get_getactivitybyid()
    	local oneallntegral=self.ContrastRecordLayer:getChildByTag(119)
	oneallntegral:setString(activitybyid["mypoints"])--我的积分

	local heroallntegral=self.ContrastRecordLayer:getChildByTag(120)
	heroallntegral:setString(self.allscore)--hero总积分

    	local title_text=self.ContrastRecordLayer:getChildByTag(104)--标题
            title_text:setString(self.title)

            local level_text=self.ContrastRecordLayer:getChildByTag(105)--等级
            level_text:setString(self.title)

            local name_text=self.ContrastRecordLayer:getChildByTag(106)--名称
            name_text:setString(self.level)

            local rank_text=self.ContrastRecordLayer:getChildByTag(107)--排名
            rank_text:setString(self.rank)

            local head_image=self.ContrastRecordLayer:getChildByTag(108)--头像
            head_image:loadTexture(self.head)
	
    	self.rank_list=self.ContrastRecordLayer:getChildByTag(109)--排行榜列表
            self.rank_list:setItemModel(self.rank_list:getItem(0))
            self.rank_list:removeAllItems()
      	self:ContrastRecord_init()
end
function ContrastRecordLayer:ContrastRecord_init(  )
	self.rank_list:removeAllItems()
	self.list_table=LocalData:Instance():getactivitypointsdetail_callback()
            local  mypointslist=self.list_table["mypointslist"]
            local  playerpointslist=self.list_table["playerpointslist"]
            local mynum=mypointslist[#mypointslist]["cycle "]
            local playernum=playerpointslist[#playerpointslist]["cycle "]
            local count=mynum >= playernum and mynum or playernum  
	for i=1,count do
		local  cell = self.rank_list:getItem(i-1)
		if mypointslist[i]["cycle "]  == i  then
			local one_integral=cell:getChildByTag(117)--积分
			one_integral:setString(mypointslist[i]["points"])
		else
			local one_integral=cell:getChildByTag(117)--积分
			one_integral:setString("0")
		end

		if playerpointslist[i]["cycle "]  == i  then
			local hero_integral=cell:getChildByTag(116)--积分
			hero_integral:setString(playerpointslist[i]["points"])
		else
			local hero_integral=cell:getChildByTag(116)--积分
			hero_integral:setString("0")
		end


		local name_text=cell:getChildByTag(115)--时间
		name_text:setString("第"  .. i  ..  "天")  --零时
	end

           
end
function ContrastRecordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self,
                       function()
                        self:init()
                      end)
end

function ContrastRecordLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self)
end

return ContrastRecordLayer


