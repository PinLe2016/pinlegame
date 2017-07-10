
--  新版惊喜吧  排行榜

local SurpriseRank = class("SurpriseRank", function()
            return display.newLayer("SurpriseRank")
end)

function SurpriseRank:ctor(params)
       self:setNodeEventEnabled(true)
       self.LV_hierarchy_table={"平民","骑士","勋爵","男爵","子爵","伯爵","侯爵","公爵","国王"}
       --  初始化界面
       self.SurpriseRank_id=params.id
       self.SurpriseRank_score=params.score
       self.SurpriseRank_mylevel=params.mylevel
       Server:Instance():getranklistbyactivityid(self.SurpriseRank_id,20)
       self:fun_init()
end

function SurpriseRank:fun_init( ... )
      self.SurpriseRank = cc.CSLoader:createNode("SurpriseRank.csb");
      self:addChild(self.SurpriseRank)
      self.SurpriseRank_BG=self.SurpriseRank:getChildByName("SurpriseRank_BG")
      self:fun_touch_bt()
      self:fun_rank_Information()
      --  好友列表初始化
      self:fun_friend_list_init()
end
function SurpriseRank:fun_rank_Information( ... )
         local SurpriseRank_number=self.SurpriseRank_BG:getChildByName("SurpriseRank_number")
         SurpriseRank_number:setString(self.SurpriseRank_mylevel)
         local SurpriseRank_SCORE=self.SurpriseRank_BG:getChildByName("SurpriseRank_SCORE")
         SurpriseRank_SCORE:setString(self.SurpriseRank_score)
end
function SurpriseRank:fun_touch_bt( ... )
     --  事件初始化
      --  返回按钮
      local SurpriseRank_back=self.SurpriseRank_BG:getChildByName("SurpriseRank_back")
            SurpriseRank_back:addTouchEventListener(function(sender, eventType  )
                  if eventType == 3 then
                          sender:setScale(1)
                          return
                      end
                      if eventType ~= ccui.TouchEventType.ended then
                          sender:setScale(1.2)
                      return
                      end
                      sender:setScale(1)
                      Util:all_layer_backMusic()
              self:removeFromParent()
      end)
    
end
--  好友列表
function SurpriseRank:fun_friend_list_init( ... )

        self.SurpriseRank_ListView=self.SurpriseRank:getChildByName("SurpriseRankNode"):getChildByName("SurpriseRank_ListView")
        self.SurpriseRank_ListView:setItemModel(self.SurpriseRank_ListView:getItem(0))
        self.SurpriseRank_ListView:removeAllItems()
        self.SurpriseRank_ListView:setInnerContainerSize(self.SurpriseRank_ListView:getContentSize())
end
function SurpriseRank:fun_friend_list_data( ... )
        local ranklistbyactivityid=LocalData:Instance():get_getranklistbyactivityid()
        -- dump(ranklistbyactivityid)
        local ranklist=ranklistbyactivityid["ranklist"]
        if #ranklist  ==  0 then
          return
        end
        --  好友
        for i=1,#ranklist do
          self.SurpriseRank_ListView:pushBackDefaultItem()
          local  cell = self.SurpriseRank_ListView:getItem(i-1)
          local rank_number=cell:getChildByName("rank_number")  
          local _bj=i
          if i>=9 then
            _bj=i
          end
          rank_number:setString(ranklist[i]["title"])
          --rank_number:setString(self.LV_hierarchy_table[10-_bj])
          local SurpriseRank_nickname=cell:getChildByName("SurpriseRank_nickname")
          SurpriseRank_nickname:setString(ranklist[i]["nickname"])
          local SurpriseRank_score=cell:getChildByName("SurpriseRank_score")
          SurpriseRank_score:setString(ranklist[i]["totalPoints"])
          local SurpriseRank_head=cell:getChildByName("SurpriseRank_head")
          local _index=string.match(tostring(Util:sub_str(ranklist[i]["headimageurl"], "/",":")),"%d")
          if not _index then
            SurpriseRank_head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(math.random(1,18))))
          else
            SurpriseRank_head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
          end
         -- SurpriseRank_head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
        end
end
function SurpriseRank:onEnter()
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE, self,
                       function()
                                  
                                self:fun_friend_list_data()
                      end)
end

function SurpriseRank:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.RANK_LAYER_IMAGE, self)
      
end

return SurpriseRank





