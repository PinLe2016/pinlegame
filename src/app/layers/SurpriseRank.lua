
--  新版惊喜吧  排行榜

local SurpriseRank = class("SurpriseRank", function()
            return display.newLayer("SurpriseRank")
end)

function SurpriseRank:ctor(params)
       self:setNodeEventEnabled(true)
       --  初始化界面
       self:fun_init()
end

function SurpriseRank:fun_init( ... )
      self.SurpriseRank = cc.CSLoader:createNode("SurpriseRank.csb");
      self:addChild(self.SurpriseRank)
      self.SurpriseRank_BG=self.SurpriseRank:getChildByName("SurpriseRank_BG")
      self:fun_touch_bt()
      --  好友列表初始化
      self:fun_friend_list_init()
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
              self:removeFromParent()
      end)
    
          
end
--  好友列表
function SurpriseRank:fun_friend_list_init( ... )

        self.SurpriseRank_ListView=self.SurpriseRank:getChildByName("SurpriseRankNode"):getChildByName("SurpriseRank_ListView")
        self.SurpriseRank_ListView:setItemModel(self.SurpriseRank_ListView:getItem(0))
        self.SurpriseRank_ListView:removeAllItems()
        --测试
        self:fun_friend_list_data()
end
function SurpriseRank:fun_friend_list_data( ... )
        for i=1,50 do
          self.SurpriseRank_ListView:pushBackDefaultItem()
          local  cell = self.SurpriseRank_ListView:getItem(i-1)
        end
end
function SurpriseRank:onEnter()
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
  --                      function()
  --                                 self:data_init()
  --                     end)
end

function SurpriseRank:onExit()
      --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
      
end

return SurpriseRank





