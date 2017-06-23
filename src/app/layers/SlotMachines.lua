--  新版惊喜吧  老虎机

local SlotMachines = class("SlotMachines", function()
            return display.newLayer("SlotMachines")
end)
_SlotMachines_id=nil
function SlotMachines:ctor(params)
       self.floating_layer = require("app.layers.FloatingLayer").new()
       self.floating_layer:addTo(self,100000)
       self.SlotMachinesgametimes=params.SlotMachinesgametimes
       self.SlotMachineslevelmax=params.SlotMachineslevelmax
       self.SlotMachineslevelmin=params.SlotMachineslevelmin
       self.SlotMachinesmylevel=params.SlotMachinesmylevel
       self.SlotMachinesscore=params.SlotMachinesscore
       self.SlotMachinesId=params.SlotMachinesId
       SlotMachines_id=params.SlotMachines_id
       self.LV_hierarchy_table={"平民","骑士","勋爵","男爵","子爵","伯爵","侯爵","公爵","国王"}
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
      self:fun_Initialize_infor()
end
--  初始化数据
function SlotMachines:fun_Initialize_infor( ... )
      self.slotlh_ldb=self.lh_bg:getChildByName("lh_ldb")  -- 进度条
      self.slotlh_ldb:setPercent(tonumber(self.SlotMachineslevelmin)  / tonumber(self.SlotMachineslevelmax)  *100)
      self.slotbumber=self.lh_bg:getChildByName("bumber") --  次数
      self.slotbumber:setString("剩余"  ..  tostring(self.SlotMachinesgametimes)  ..  "次")
      self.slotintegral=self.lh_bg:getChildByName("integral") --  积分
      self.slotintegral:setString(tostring(self.SlotMachinesscore))
      self.slotlevel=self.lh_bg:getChildByName("level") --  等级
      self.slotlevel:setString(tostring(self.SlotMachinesmylevel))
      self.slotlv_name1=self.lh_bg:getChildByName("lv_name1") --  进度条当前等级
      self.slotlv_name1:setString(tostring(self.SlotMachinesmylevel))
      self.slotlv_name2=self.lh_bg:getChildByName("lv_name2") --  下一等级
      local _lv=1
      for i=1,#self.LV_hierarchy_table do
        if tostring(self.LV_hierarchy_table) == tostring(self.SlotMachinesmylevel)  then
         _lv=i
        end
      end
      if _lv==#self.LV_hierarchy_table  then
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv])
      else
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv+1])
      end
      
end
--  刷新后数据
function SlotMachines:fun_Initialize_data( ... )
      local activitygame=LocalData:Instance():get_activitygame()
      self.slotlh_ldb:setPercent(tonumber(activitygame["levelminpoints"])  / tonumber(activitygame["levelmaxpoints"])  *100)
      self.slotbumber:setString("剩余"  ..  tostring(activitygame["remaintimes"])  ..  "次")
      self.slotintegral:setString(tostring(activitygame["totalpoints"]))
      self.slotlevel:setString(tostring(activitygame["level"]))
      self.slotlv_name1:setString(tostring(activitygame["level"]))
      local _lv=1
      for i=1,#self.LV_hierarchy_table do
        if tostring(self.LV_hierarchy_table) == tostring(activitygame["level"])  then
         _lv=i
        end
      end
      if _lv==#self.LV_hierarchy_table  then
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv])
      else
        self.slotlv_name2:setString(self.LV_hierarchy_table[_lv+1])
      end
      
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
function SlotMachines:fun_Slot_machines( _num,_point )
          --  self. _table={}
          -- self._table_number={}
          -- self._table_number_tag=1

        for i=1,#self. _table do
              self. _table[i]:startGo()
        end
        local  tempn = _num  

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
                           local function fun_stopGo2()
                              self:fun_Initialize_data()
                              self.hl_began:setTouchEnabled(true)
                              self:fun_PowerWindows(_point)
                           end
                           self:runAction( cc.Sequence:create(cc.DelayTime:create(2 ),cc.CallFunc:create(fun_stopGo2)))
                     end
                  end
                  self:runAction( cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(fun_stopGo1),cc.DelayTime:create(0.5)),3))
          end
          local actionTo = cc.ScaleTo:create(0.5, 1)
          self:runAction( cc.Sequence:create(cc.DelayTime:create(2 ),cc.CallFunc:create(fun_stopGo)))
end
function SlotMachines:fun_PowerWindows( _text )
  local PowerWindows = cc.CSLoader:createNode("PowerWindows.csb");
  self:addChild(PowerWindows)
  PowerWindows:setTag(123)
  local number=PowerWindows:getChildByName("number")
  number:setString(tostring(_text))
  local pwtrue=PowerWindows:getChildByName("Image_1")
            pwtrue:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                   self:removeChildByTag(123,true)
            end)
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
                      Server:Instance():getactivitybyid(SlotMachines_id,0)  --  详情

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
      self.hl_began=self.lh_bg:getChildByName("hl_began")
      self.hl_began:addTouchEventListener(function(sender, eventType  )
              if eventType == 3 then
                    sender:setScale(1)
                    return
                end
                if eventType ~= ccui.TouchEventType.ended then
                    sender:setScale(1.2)
                return
                end
                sender:setScale(1)
                -- if self.SlotMachinesgametimes<=0 then
                --     self.floating_layer:prompt_box("您的次数已经用完")
                --     return
                -- end
                self.hl_began:setTouchEnabled(false)
                Server:Instance():activitygame(self.SlotMachinesId)
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
  NotificationCenter:Instance():AddObserver("activitygame", self,
                       function()
                                  local activitygame=LocalData:Instance():get_activitygame()
                                  self:fun_Slot_machines(tonumber(activitygame["fruit"]),activitygame["points"])
                      end)
  NotificationCenter:Instance():AddObserver("activitygamefalse", self,
                       function()
                                  self.hl_began:setTouchEnabled(true)
                      end)
end

function SlotMachines:onExit()
  cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("DetailsiOfSurprise/LH_Plist.plist")
  NotificationCenter:Instance():RemoveObserver("activitygame", self)
  NotificationCenter:Instance():RemoveObserver("activitygamefalse", self)
      
end

return SlotMachines




