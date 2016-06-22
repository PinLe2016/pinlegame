--
-- Author: peter
-- Date: 2016-05-09 16:52:14
--
local RankinglistofactiviesLayer = class("RankinglistofactiviesLayer", function()
            return display.newLayer("RankinglistofactiviesLayer")
end)
function RankinglistofactiviesLayer:ctor(params)
      self.id=params.id
      self.count=params.count
      self.image=params.image
      self.title=params.title
      self:setNodeEventEnabled(true)--layer添加监听
      local userdt = LocalData:Instance():get_userdata()
      Server:Instance():getranklistbyactivityid(self.id,self.count)  --排行榜HTTP

end
function RankinglistofactiviesLayer:init(  )

	self.RankinglistofactiviesLayer = cc.CSLoader:createNode("RankinglistofactiviesLayer.csb");
    	self:addChild(self.RankinglistofactiviesLayer)

      local title_text=self.RankinglistofactiviesLayer:getChildByTag(67)--标题
      title_text:setString(self.title .. "排行榜")

      local back_bt=self.RankinglistofactiviesLayer:getChildByTag(69)--返回
      back_bt:addTouchEventListener(function(sender, eventType  )
                                    self:back(sender, eventType)
                        end)

      --  新增加的功能
      local userdt = LocalData:Instance():get_userdata() 
      local _name=self.RankinglistofactiviesLayer:getChildByTag(531) -- 名字
      _name:setString(userdt["nickname"])

      local _gold=self.RankinglistofactiviesLayer:getChildByTag(532) -- 金币
      _gold:setString(userdt["golds"])

      local _integral=self.RankinglistofactiviesLayer:getChildByTag(533) -- 积分
      _integral:setString(userdt["points"])
      
       local _head=self.RankinglistofactiviesLayer:getChildByTag(529) --头像
       _head:loadTexture(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))


    	rank_list=self.RankinglistofactiviesLayer:getChildByTag(71)--排行榜列表
    	rank_list:setItemModel(rank_list:getItem(0))
    	rank_list:removeAllItems()
      self:Rankinglistofactivies_init()
	
end

function RankinglistofactiviesLayer:Rankinglistofactivies_init()
	    self.list_table=LocalData:Instance():get_getranklistbyactivityid()
          local  sup_data=self.list_table["ranklist"]
          if not sup_data then
            return
          end
           dump(sup_data)
        rank_list:removeAllItems()
          for i=1, #sup_data do  --#sup_data
            rank_list:pushBackDefaultItem()

            local  cell = rank_list:getItem(i-1)
            cell:setTag(i)
            cell:addTouchEventListener(function(sender, eventType  )
                                    self:onImageViewClicked(sender, eventType)
                        end)

            local panel_bg=cell:getChildByTag(84)--活动图片
            -- panel_bg:loadTexture(self.image)

            local name_text=cell:getChildByTag(81)--昵称
            name_text:setString(tostring(sup_data[i]["nickname"]))

            local integral_tex=cell:getChildByTag(82)--总积分
            integral_tex:setString(tostring(sup_data[i]["totalPoints"]))

             local name_text=cell:getChildByTag(81)--昵称
            name_text:setString(tostring(sup_data[i]["nickname"]))

            local level_text=cell:getChildByTag(83) --等级
            level_text:setString(tostring(sup_data[i]["title"]))

            local act_head=cell:getChildByTag(78) --头像
            act_head:loadTexture(tostring(Util:sub_str(sup_data[i]["hearurl"], "/",":")))
          end
end
function RankinglistofactiviesLayer:back( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            self:removeFromParent()

end
function RankinglistofactiviesLayer:onImageViewClicked( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
          end
          local tag=sender:getTag()
          local  sup_data=self.list_table["ranklist"]
          self:addChild(ContrastRecordLayer.new({title=self.title,head=sup_data[tag]["hearurl"],
                                    name=sup_data[tag]["nickname"],rank=sup_data[tag]["rank"],
                                    level=sup_data[tag]["title"],heroid=sup_data[tag]["id"],id=self.id,
                                    allscore=sup_data[tag]["totalPoints"]}))
end
function RankinglistofactiviesLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE, self,
                       function()
                        self:init()
                      end)
end

function RankinglistofactiviesLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE, self)
end

return RankinglistofactiviesLayer