--  新版惊喜吧  老虎机

local SlotMachines = class("SlotMachines", function()
            return display.newLayer("SlotMachines")
end)

function SlotMachines:ctor()
       self:setNodeEventEnabled(true)
       --  初始化界面
       self:fun_init()
       
end

function SlotMachines:fun_init( ... )
	self.SlotMachines = cc.CSLoader:createNode("SlotMachines.csb");
	self:addChild(self.SlotMachines)
	self.lh_bg=self.SlotMachines:getChildByName("lh_bg")
      -- --  初始化老虎机
      self:fun_Slot_machines_init()
       self:fun_touch_bt()
end

--老虎机
function SlotMachines:fun_Slot_machines_init( ... )
   self. _table={}
   self._table_number={}
   self._table_number_tag=1
    for i=1,3 do
        local score=self.lh_bg
        local pox_1=self.lh_bg:getChildByName("lh_score1"):getPositionX()
        local poy_1=self.lh_bg:getChildByName("lh_score1"):getPositionY()
        local pox_2=self.lh_bg:getChildByName("lh_score2"):getPositionX()
        local pox_3=self.lh_bg:getChildByName("lh_score3"):getPositionX()
        self.laoHuJi1 = cc.LaoHuJiDonghua:create()--cc.CustomClass:create()
        local msg = self.laoHuJi1:helloMsg()
        release_print("customClass's msg is : " .. msg)
        self.laoHuJi1:setDate("DetailsiOfSurprise/LH_Plist", "DetailsiOfSurprise/JXB_YX_S_", 10,cc.p(pox_1+127*(i-1) ,poy_1) );
        self.laoHuJi1:setStartSpeed(15);
        score:addChild(self.laoHuJi1);
        self._table[i]=self.laoHuJi1
    end
end
--  开始
function SlotMachines:fun_Slot_machines( _num )
          --  self. _table={}
          -- self._table_number={}
          -- self._table_number_tag=1

        for i=1,#self. _table do
              self. _table[i]:startGo()
        end
        local  tempn = 012  

         local function fun_stopGo()
		for i=1,#self. _table do
			local  stopNum = 0;
			if (tempn > 0)  then
				stopNum = tempn % 10;
				tempn = tempn / 10;
			end
                  table.insert(self._table_number,{number =  stopNum })
		end
                  local function fun_stopGo1()
                      self. _table[self._table_number_tag]:stopGo(self._table_number[#self. _table-(self._table_number_tag-1)].number);
                      self._table_number_tag=self._table_number_tag+1
                      if self._table_number_tag==4 then
                           self._table_number={}
                           self._table_number_tag=1
                     end
                  end
                  self:runAction( cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(fun_stopGo1),cc.DelayTime:create(0.5)),3))
          end
          local actionTo = cc.ScaleTo:create(0.5, 1)
          self:runAction( cc.Sequence:create(cc.DelayTime:create(2 ),cc.CallFunc:create(fun_stopGo)))

       

end
function SlotMachines:fun_touch_bt( ... )
     --  事件初始化
      --  返回按钮
      local lh_back=self.SlotMachines:getChildByName("lh_back")
            lh_back:addTouchEventListener(function(sender, eventType  )
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
      local lh_record=self.lh_bg:getChildByName("lh_record")
      lh_record:addTouchEventListener(function(sender, eventType  )
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
     
      --开始
      local hl_began=self.lh_bg:getChildByName("hl_began")
      hl_began:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                
                self:fun_Slot_machines(tonumber(math.random(1,8)  ..  math.random(1,8) .. math.random(1,8)))
      end)

       --帮助
      local help_bt=self.lh_bg:getChildByName("help_bt")
      help_bt:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                print("帮助")
      end)
      
          
end
function SlotMachines:onEnter()
   cc.SpriteFrameCache:getInstance():addSpriteFrames("DetailsiOfSurprise/LH_Plist.plist")
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
  --                      function()
  --                                 self:data_init()
  --                     end)
end

function SlotMachines:onExit()
  cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("DetailsiOfSurprise/LH_Plist.plist")
      --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
      
end

return SlotMachines




