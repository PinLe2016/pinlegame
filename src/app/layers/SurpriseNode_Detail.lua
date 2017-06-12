--  新版惊喜吧  活动详情

local SurpriseNode_Detail = class("SurpriseNode_Detail", function()
            return display.newLayer("SurpriseNode_Detail")
end)

function SurpriseNode_Detail:ctor(params)
       self:setNodeEventEnabled(true)
       --  初始化界面
       self:fun_init()
       
        Server:Instance():getactivitybyid(params.id,0)  --  详情
       -- Server:Instance():getactivityadlist(params.id)
end

function SurpriseNode_Detail:fun_init( ... )
	self.DetailsOfSurprise = cc.CSLoader:createNode("DetailsOfSurprise.csb");
	self:addChild(self.DetailsOfSurprise)
      self.XQ_bg=self.DetailsOfSurprise:getChildByName("XQ_bg")
      self.LH_bg=self.XQ_bg:getChildByName("LH_bg")
      self:fun_touch_bt()
      --  好友列表初始化
      self:fun_friend_list_init()
end

function SurpriseNode_Detail:fun_Slot_machines( ... )
   
        for i=1,#self. _table do
              self. _table[i]:startGo()
        end
        local  tempn = 123   
        for i=1,#self. _table do
            local  stopNum = 0;
            if (tempn > 0)  then
                stopNum = tempn % 10;
                tempn = tempn / 10;
            end
            (self. _table[#self. _table-(i-1)]):stopGo(stopNum);
        end

end
function SurpriseNode_Detail:fun_touch_bt( ... )
     --  事件初始化
      --  返回按钮
      local XQ_BACK=self.DetailsOfSurprise:getChildByName("XQ_BACK")
            XQ_BACK:addTouchEventListener(function(sender, eventType  )
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
      
       --  规则按钮
      local XQ_GZ=self.DetailsOfSurprise:getChildByName("XQ_GZ")
      XQ_GZ:addTouchEventListener(function(sender, eventType  )
            if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                print('规则')
      end)
      --排行榜
      local HL_list=self.XQ_bg:getChildByName("HL_list")
      HL_list:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                 local SurpriseRank = require("app.layers.SurpriseRank")  --关于拼乐界面  
                  self:addChild(SurpriseRank.new(),1,1)
      end)
      --好友助力
      local Friend_help=self.DetailsOfSurprise:getChildByName("Friend_help")
      Friend_help:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                print("好友助力")
      end)

       --奖项
      local award_bt=self.DetailsOfSurprise:getChildByName("award_bt")
      award_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                self:fun_winnersPreview()
      end)
       --开始
      local began_bt=self.DetailsOfSurprise:getChildByName("began_bt")
      began_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                 local SlotMachines = require("app.layers.SlotMachines")    
                self:addChild(SlotMachines.new(),1,1)
      end)
          
end
--  好友列表
function SurpriseNode_Detail:fun_friend_list_init( ... )
        local  Friend_Node=self.DetailsOfSurprise:getChildByName("Friend_Node")
        local XQ_Friend_bg=Friend_Node:getChildByName("XQ_Friend_bg")
         local XQ_FD_LIST_Back=XQ_Friend_bg:getChildByName("XQ_FD_LIST_Back")
         local XQ_FD_LIST_More_Bg=XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bg")
           local XQ_FD_LIST_More_Bt=XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bt")
        XQ_FD_LIST_Back:setVisible(false)
        XQ_Friend_bg:setTouchEnabled(false)
      
      --  关闭好友界面
      
      XQ_FD_LIST_Back:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                XQ_FD_LIST_Back:setVisible(false)
                XQ_FD_LIST_More_Bg:setVisible(true)
                Friend_Node:setPositionY(0)
                XQ_Friend_bg:setTouchEnabled(false)
                XQ_FD_LIST_More_Bt:setVisible(true)
      end)
      --  关闭好友界面
      
      XQ_FD_LIST_More_Bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                XQ_FD_LIST_Back:setVisible(true)
                XQ_FD_LIST_More_Bg:setVisible(false)
                Friend_Node:setPositionY(635)
                XQ_Friend_bg:setTouchEnabled(true)
                XQ_FD_LIST_More_Bt:setVisible(false)
      end)


        self.XQ_FD_LIST=XQ_Friend_bg:getChildByName("XQ_FD_LIST")
        self.XQ_FD_LIST:setItemModel(self.XQ_FD_LIST:getItem(0))
        self.XQ_FD_LIST:removeAllItems()
        --测试
        self:fun_friend_list_data()
end
function SurpriseNode_Detail:fun_friend_list_data( ... )
--  有没有好友图片
self.DetailsOfSurprise:getChildByName("Friend_Node"):getChildByName("XQ_Friend_bg"):getChildByName("no_friend_bg"):setVisible(false)
        for i=1,20 do
          self.XQ_FD_LIST:pushBackDefaultItem()
          local  cell = self.XQ_FD_LIST:getItem(i-1)
        end
end
--奖项
function SurpriseNode_Detail:fun_winnersPreview( ... )
      self.winnersPreview = cc.CSLoader:createNode("winnersPreview.csb");
      self.winnersPreview:setTag(1311)
      self:addChild(self.winnersPreview)
      local back=self.winnersPreview:getChildByName("back")
       back:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                self:removeChildByTag(1311, true)
      end)
        self.win_ListView=self.winnersPreview:getChildByName("win_ListView")
        self.win_ListView:setItemModel(self.win_ListView:getItem(0))
        self.win_ListView:removeAllItems()

        self:fun_winnersPreview_list_init()
end
function SurpriseNode_Detail:fun_winnersPreview_list_init( ... )
       for i=1,20 do
          self.win_ListView:pushBackDefaultItem()
          local  cell = self.win_ListView:getItem(i-1)
          local number=cell:getChildByName("number")
          number:setString(i)
          local prize=cell:getChildByName("prize")
          prize:setString(i ..  "等奖")
        end
end
function SurpriseNode_Detail:onEnter()
   cc.SpriteFrameCache:getInstance():addSpriteFrames("DetailsiOfSurprise/LH_Plist.plist")
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
  --                      function()
  --                                 self:data_init()
  --                     end)
end

function SurpriseNode_Detail:onExit()
  cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("DetailsiOfSurprise/LH_Plist.plist")
      --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
      
end

return SurpriseNode_Detail




