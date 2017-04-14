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
      self.phyimage=params._img
      self._type=params._type
      self:setNodeEventEnabled(true)--layer添加监听
      local userdt = LocalData:Instance():get_userdata()
      Server:Instance():getranklistbyactivityid(self.id,self.count)  --排行榜HTTP
      self.leve_instructions={"伯爵","大公","公爵","国王","侯爵","男爵","平民","亲王","骑士","王储","勋爵","子爵",}

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
      local _activitybyid=LocalData:Instance():get_getactivitybyid()
      -- dump(userdt)
      local _name=self.RankinglistofactiviesLayer:getChildByTag(531) -- 名字
      _name:setString(userdt["nickname"])

       local _leve=self.RankinglistofactiviesLayer:getChildByTag(90) -- 等级
      --_leve:setString(userdt["rankname"])
      local _leveimage=self.RankinglistofactiviesLayer:getChildByTag(197)
       for j=1,#self.leve_instructions do
              if self.leve_instructions[j]  == tostring(userdt["rankname"])  then
                 _leveimage:loadTexture(string.format("png/dengji_%d.png", j))
              end
       end

      local _gold=self.RankinglistofactiviesLayer:getChildByTag(532) -- 积分  
      _gold:setString(_activitybyid["mypoints"])

      local _integral=self.RankinglistofactiviesLayer:getChildByTag(533) -- 排名
      _integral:setString(_activitybyid["myrank"])
      
      if tonumber(_activitybyid["remaintimes"]) > 0 then
        _integral:setString("/")
      end

      --_integral:setString("/")
       local _head=self.RankinglistofactiviesLayer:getChildByTag(529) --头像
       _head:loadTexture(LocalData:Instance():get_user_head())--(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))


    	rank_list=self.RankinglistofactiviesLayer:getChildByTag(71)--排行榜列表
    	rank_list:setItemModel(rank_list:getItem(0))
    	rank_list:removeAllItems()
      self:Rankinglistofactivies_init()
	
end

function RankinglistofactiviesLayer:Rankinglistofactivies_init()
          local login_info=LocalData:Instance():get_user_data()
          local _key=login_info["loginname"]
	    self.list_table=LocalData:Instance():get_getranklistbyactivityid()
          local  sup_data=self.list_table["ranklist"]
          if not sup_data then
            return
          end
           dump(#sup_data)
        rank_list:removeAllItems()
          for i=1, #sup_data do  --#sup_data
            rank_list:pushBackDefaultItem()
            print("12222  ",i)
            local  cell = rank_list:getItem(i-1)
            cell:setTag(i)
            
            cell:addTouchEventListener(function(sender, eventType  )

                                    self:onImageViewClicked(sender, eventType)
                        end)

             local act_head=cell:getChildByTag(78) --头像

            local _index=string.match(tostring(Util:sub_str(sup_data[i]["hearurl"], "/",":")),"%d")
             print("hhhhhhhhh    ",_index)
             --local path=cc.FileUtils:getInstance():getWritablePath().."res/png/"
            --act_head:loadTexture( path .. tostring(Util:sub_str(sup_data[i]["hearurl"], "/",":")))
            act_head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))

            local again_friend =cell:getChildByTag(477)  --添加好友
            again_friend:setTag(i)
            again_friend:addTouchEventListener(function(sender, eventType)
                    if eventType ~= ccui.TouchEventType.ended then
                          return
                    end
                    local _table={}
                     local table_list={}
                     _table["playerid"]=sup_data[sender:getTag()]["playerid"]
                     table_list[1]=_table
                     Server:Instance():setfriendoperation(table_list,0)
                     sender:setTouchEnabled(false)    
                      local function stopAction()
                          sender:setTouchEnabled(true)      
                    end
                    local callfunc = cc.CallFunc:create(stopAction)
                   sender:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
                    
            end)
            if sup_data[i]["tag"]   ==  1  then   --  1是好友  0  不是好友
                           again_friend:setVisible(false)
            end



            if tostring(sup_data[i]["playerid"])==tostring(_key)   then   
                 local my_img=cell:getChildByTag(527)--提示自己
                 my_img:setVisible(true)
                
                 act_head:loadTexture(LocalData:Instance():get_user_head())
            else
               local my_img=cell:getChildByTag(527)--提示自己
               my_img:setVisible(false)
            end
            local panel_bg=cell:getChildByTag(84)--活动图片
            -- panel_bg:loadTexture(self.image)

            local name_text=cell:getChildByTag(81)--昵称
            name_text:setString(tostring(sup_data[i]["nickname"]))

            local integral_tex=cell:getChildByTag(82)--总积分
            integral_tex:setString(tostring(sup_data[i]["totalPoints"]))

             local name_text=cell:getChildByTag(81)--昵称
            name_text:setString(tostring(sup_data[i]["nickname"]))

            local level_text=cell:getChildByTag(83) --等级
            --level_text:setString(tostring(sup_data[i]["title"]))

            local level_image=cell:getChildByTag(198) --等级

            for j=1,#self.leve_instructions do
              if self.leve_instructions[j]  == tostring(sup_data[i]["title"])  then
                 level_image:loadTexture(string.format("png/dengji_%d.png", j))
              end
            end

           

            local leve_head=cell:getChildByTag(77) --皇冠

            local ranking_tag=cell:getChildByTag(86)  --排名数字
            if i<4 then 
               ranking_tag:loadTexture(string.format("png/paihangbang-mingci-%d.png", i))
               leve_head:loadTexture(string.format("png/HD%d.png", i))
            else
                leve_head:setVisible(false)
                ranking_tag:setVisible(false)
                local ordinary_tag=cell:getChildByTag(87)
                ordinary_tag:setVisible(true)
                local _tag=ordinary_tag:getChildByTag(88)
                _tag:setString(tostring(i))
            end
          
          end
end
function RankinglistofactiviesLayer:back( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end

             Server:Instance():getactivitybyid(self.id,0)
             self:removeFromParent()
             Util:all_layer_backMusic()

end
function RankinglistofactiviesLayer:onImageViewClicked( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
          end
          if self._type==3  or   self._type==4 then
            return
          end
          local tag=sender:getTag()
          local  sup_data=self.list_table["ranklist"]
           local login_info=LocalData:Instance():get_user_data()
          local _key=login_info["loginname"]
          if tostring(sup_data[tag]["playerid"])==tostring(_key)   then
                return
          end
          self:addChild(require("app.layers.ContrastRecordLayer").new({title=self.title,head=sup_data[tag]["hearurl"],
                                    name=sup_data[tag]["nickname"],rank=sup_data[tag]["rank"],
                                    level=sup_data[tag]["title"],heroid=sup_data[tag]["playerid"],id=self.id,_type=self._type,
                                    allscore=sup_data[tag]["totalPoints"],phyimage=self.phyimage}))
end
function RankinglistofactiviesLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE, self,
                       function()
                        self:init()
                      end)
      NotificationCenter:Instance():AddObserver("FRIEND_SETFRIENDOPERATION", self,
                       function()
                        Server:Instance():promptbox_box_buffer("成功添加好友") 
                        Server:Instance():getranklistbyactivityid(self.id,self.count)
                      end)
end

function RankinglistofactiviesLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE, self)
       NotificationCenter:Instance():RemoveObserver("FRIEND_SETFRIENDOPERATION", self)
       cc.Director:getInstance():getTextureCache():removeAllTextures() 
end

return RankinglistofactiviesLayer