--  新版惊喜吧  活动详情

local SurpriseNode_Detail = class("SurpriseNode_Detail", function()
            return display.newLayer("SurpriseNode_Detail")
end)

function SurpriseNode_Detail:ctor(params)
       self:setNodeEventEnabled(true)
       --  初始化界面
       self:fun_init()
       
       -- Server:Instance():getactivitybyid(params.id,0)  --  详情
       -- Server:Instance():getactivityadlist(params.id)
end

function SurpriseNode_Detail:fun_init( ... )
	self.DetailsOfSurprise = cc.CSLoader:createNode("DetailsOfSurprise.csb");
	self:addChild(self.DetailsOfSurprise)
      self.XQ_bg=self.DetailsOfSurprise:getChildByName("XQ_bg")
      self.LH_bg=self.XQ_bg:getChildByName("LH_bg")
      --  初始化分数
      local LH_score_1=self.LH_bg:getChildByName("LH_score_1")
      local LH_score_2=self.LH_bg:getChildByName("LH_score_2")
      local LH_score_3=self.LH_bg:getChildByName("LH_score_3")
      self:fun_score(LH_score_1,self.LH_bg)
      self:fun_score(LH_score_2,self.LH_bg)
      self:fun_score(LH_score_3,self.LH_bg)
      --  初始化老虎机
      self:fun_Slot_machines_init()
      self:fun_touch_bt()
      --  好友列表初始化
      self:fun_friend_list_init()
end

--老虎机
function SurpriseNode_Detail:fun_Slot_machines_init( ... )
   self. _table={}
    for i=1,3 do
        local score=self.LH_bg
        local pox_1=self.LH_bg:getChildByName("LH_img_1"):getPositionX()
        local poy_1=self.LH_bg:getChildByName("LH_img_1"):getPositionY()
        local pox_2=self.LH_bg:getChildByName("LH_img_2"):getPositionX()
        local pox_3=self.LH_bg:getChildByName("LH_img_3"):getPositionX()
        self.laoHuJi1 = cc.LaoHuJiDonghua:create()--cc.CustomClass:create()
        local msg = self.laoHuJi1:helloMsg()
        release_print("customClass's msg is : " .. msg)
        self.laoHuJi1:setDate("DetailsiOfSurprise/LH_Plist", "DetailsiOfSurprise/JXB_YX_S_", 10,cc.p(pox_1+127*(i-1) ,poy_1) );
        self.laoHuJi1:setStartSpeed(20);
        score:addChild(self.laoHuJi1);
        self._table[i]=self.laoHuJi1
    end
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
      --开始按钮
      local LH_began=self.XQ_bg:getChildByName("LH_began")
      LH_began:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
               return
          end
        self:fun_Slot_machines()
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
          
end
--  好友列表
function SurpriseNode_Detail:fun_friend_list_init( ... )
        local  Friend_Node=self.DetailsOfSurprise:getChildByName("Friend_Node")
        local XQ_Friend_bg=Friend_Node:getChildByName("XQ_Friend_bg")
         local XQ_FD_LIST_Back=XQ_Friend_bg:getChildByName("XQ_FD_LIST_Back")
        XQ_FD_LIST_Back:setVisible(false)
        XQ_Friend_bg:setTouchEnabled(false)
        --更多好友
      local XQ_FD_LIST_More_Bg=XQ_Friend_bg:getChildByName("XQ_FD_LIST_More_Bg")
      local XQ_FD_LIST_More_Bt=XQ_FD_LIST_More_Bg:getChildByName("XQ_FD_LIST_More_Bt")
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
      end)
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
      end)
        self.XQ_FD_LIST=XQ_Friend_bg:getChildByName("XQ_FD_LIST")
        self.XQ_FD_LIST:setItemModel(self.XQ_FD_LIST:getItem(0))
        self.XQ_FD_LIST:removeAllItems()
        --测试
        self:fun_friend_list_data()
end
function SurpriseNode_Detail:fun_friend_list_data( ... )
        for i=1,50 do
          self.XQ_FD_LIST:pushBackDefaultItem()
          local  cell = self.XQ_FD_LIST:getItem(i-1)
        end
end
--成绩分数 
function SurpriseNode_Detail:fun_score( _obj,PaObj)
    local dishu_score = ccui.TextAtlas:create()
    dishu_score:setPosition(cc.p(_obj:getPositionX(),_obj:getPositionY()))  
    dishu_score:setProperty( "333","DetailsiOfSurprise/JXB_YX_15.png", 18, 21, "0")  --tostring(self.friendlist_num["friendcount"]),
    PaObj:addChild(dishu_score) 
    dishu_score:setAnchorPoint(0,0.5)
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




