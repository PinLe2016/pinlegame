--
-- Author: peter
-- Date: 2016-06-02 10:39:24
--
--
-- Author: peter
-- Date: 2016-05-09 16:51:38
--   奖池界面
local JackpotLayer = class("JackpotLayer", function()
            return display.newLayer("JackpotLayer")
end)
--标题 活动类型 
function JackpotLayer:ctor(params)
         self.id=params.id
         Server:Instance():getgoldspooladlist(self.id)  --
         Server:Instance():getgoldspoolbyid(self.id)

         self:setNodeEventEnabled(true)--layer添加监听

         self.secondOne = 0
         self.time=0
          self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
            self:update(dt)
      end)
end
function JackpotLayer:init(  )

  	  self.JackpotScene = cc.CSLoader:createNode("JackpotScene.csb")
        self:addChild(self.JackpotScene)
        
        self.advertiPv=self.JackpotScene:getChildByTag(151)
        local advertiPa=self.advertiPv:getChildByTag(152)

        local  list_table=LocalData:Instance():get_getgoldspoollistbale()
        
        local  jaclayer_data=list_table["ads"]
        self.advertiPv:addEventListener(function(sender, eventType  )
                 if eventType == ccui.PageViewEventType.turning then
                   print("开心")
                    -- local  _id=jaclayer_data[1]["adid"]
                    -- Util:scene_controlid("GameScene",{adid=_id,type="audition",image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})
                    -- LocalData:Instance():set_actid({act_id=_id,image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})--保存数据
                end
        end)

        local _advertiImg=advertiPa:getChildByTag(155)
        _advertiImg:loadTexture(tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":")))--
        if #jaclayer_data>=2 then
             for i=2,#jaclayer_data do
                  local  call=advertiPa:clone() 
                  local advertiImg=call:getChildByTag(155)
                  advertiImg:loadTexture(tostring(Util:sub_str(jaclayer_data[i]["imgurl"], "/",":")))--
                  self.advertiPv:addPage(call)   --
            end
        end
       
        --self.PageView_head:scrollToPage(self._index)   --拿到需要索引的图
        
         local left_bt=self.JackpotScene:getChildByTag(154)  --减
         left_bt:setTouchSwallowEnabled(true)
         left_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex()-1)
              
        end)
        local right_bt=self.JackpotScene:getChildByTag(153)  --加
        right_bt:setTouchSwallowEnabled(true)
        right_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                 self.advertiPv:scrollToPage(self.advertiPv:getCurPageIndex()+1)
                
        end)
         local back=self.JackpotScene:getChildByTag(137)  --返回
         back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
                   self:removeFromParent()
                
        end)

          self:information()
          self:audition()

end
function JackpotLayer:information( )
             local  list_table=LocalData:Instance():get_getgoldspoolbyid()

             local title=self.JackpotScene:getChildByTag(138)  --标题
             title:setString(list_table["title"])

             local gold=self.JackpotScene:getChildByTag(140)  --剩余金币
             gold:setString(list_table["remaingolds"])

             self.car_num=self.JackpotScene:getChildByTag(33)  --翻倍卡数量
             self._carnum=tonumber(list_table["doublecardamount"])  
             self.car_num:setString(self._carnum)


             self.began_bt=self.JackpotScene:getChildByTag(46)  --开始
             self.began_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
             self.end_bt=self.JackpotScene:getChildByTag(155)  --结束
             self.end_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)

             local ordinary_bt=self.JackpotScene:getChildByTag(44)  --普通
             ordinary_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
              local special_bt=self.JackpotScene:getChildByTag(45)  --翻倍
             special_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
              local obtain_bt=self.JackpotScene:getChildByTag(47)  --获取参与卷
             obtain_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)

             self.be_num=self.JackpotScene:getChildByTag(999)  --参与卷
             self.playcardamount=tonumber(list_table["playcardamount"])
             self.be_num:setString(list_table["playcardamount"])
             self.coolingtime=list_table["coolingtime"]
             self.is_double = 1  --  1  是普通   2  是翻倍

end

function JackpotLayer:touch_callback( sender, eventType )
      if eventType ~= ccui.TouchEventType.ended then
         return
      end
      local tag=sender:getTag()
      if tag==46 then --开始
             self:act_began( )   
      elseif tag==44 then
            self.is_double=1
            print("普通")
      elseif tag==45 then
            if self._carnum>0 then
               print("翻倍",self._carnum)
               self._carnum=self._carnum-1
               self.is_double=2
            end
            print("翻倍卡不足")
            self.is_double=2 -- 测试
            self.car_num:setString(tostring(self._carnum) )
      elseif tag==155 then  --劲舞团结束
             self:fun_win()
      elseif tag==47 then  --获取参与卷
             local  list_table=LocalData:Instance():get_getgoldspoollistbale()
             local  jaclayer_data=list_table["ads"]
              local  _id=jaclayer_data[1]["adid"]
              Util:scene_controlid("GameScene",{adid=_id,type="audition",image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})
              LocalData:Instance():set_actid({act_id=_id,image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})--保存数

      end
end
function JackpotLayer:act_began( )
       if self.playcardamount >0  and self.coolingtime==0 then
             print("拥有参与卷")
             self.playcardamount=self.playcardamount-1
             self.began_bt:setVisible(false)
             self:scheduleUpdate()
        end
        print("没有参与卷")
        self.be_num:setString(tostring(self.playcardamount))
        --测试
        self.began_bt:setVisible(false)
        self:scheduleUpdate() 
end
--劲舞团获取的金币
function JackpotLayer:fun_win(  )
            --  测试
             local userdt = LocalData:Instance():get_userdata()--用户数据
             local _randgolds={math.random(50,200),500,1000}
             local _percentage={0.0001,0.0004,0.9995}
            if self.is_double==1 then
                  userdt["golds"]=userdt["golds"]+math.random(1,20)  -- 普通
            elseif self.is_double==2 then    --99.95 50~200金币、0.04 500金币及  0.01   1000金币
                      local _x=self.progress_bt:getPositionX()
                      if _x>self.win_x- self.w_size*_percentage[1]   and   _x<self.win_x+self.w_size*_percentage[1]  then
                        userdt["golds"]=userdt["golds"]+_randgolds[3]
                      elseif _x>self.win_x- self.w_size*_percentage[2]    and   _x<self.win_x+self.w_size*_percentage[2]  then
                        userdt["golds"]=userdt["golds"]+_randgolds[2]
                      elseif _x>self.win_x- self.w_size*_percentage[3]    and   _x<self.win_x+self.w_size*_percentage[3]  then
                        userdt["golds"]=userdt["golds"]+_randgolds[1]
                      else
                        print("擦肩而过")
                      end
            end
           
            LocalData:Instance():set_userdata(userdt) --  保存数据

            self.began_bt:setVisible(true)
            self:unscheduleUpdate()
            --  冷却时间界面
            self:fun_cool()

end
--倒计时定时器
 function JackpotLayer:countdown()
           self._time=self._time-1
           self._countdown:setString(tostring(self._time))
           if self._time==0 then
              self.mask_bg2:setVisible(false) 
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器
           end
end
function JackpotLayer:fun_countdown( )
      self._scnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdown()
              end,1.0, false)
end
-- 冷却时间界面
function JackpotLayer:fun_cool(  )
     self.mask_bg2=self.JackpotScene:getChildByTag(50)  --冷却界面面板
     local back_mask=self.mask_bg2:getChildByTag(54)  --冷却界面返回
     back_mask:addTouchEventListener(function(sender, eventType  )
               self:cool_callback( sender, eventType )             
      end)
     local obtaingold_bt=self.mask_bg2:getChildByTag(53)  --冷却界面获取金币
     obtaingold_bt:addTouchEventListener(function(sender, eventType  )
               self:cool_callback( sender, eventType )             
      end)
     self._countdown=self.mask_bg2:getChildByTag(52)  --倒计时
     self._countdown:setString("30S")
     self._time=30
     self:fun_countdown( )
     self.mask_bg2:setVisible(true)
end

function JackpotLayer:cool_callback( sender, eventType)
      if eventType ~= ccui.TouchEventType.ended then
            return
      end
      local tag=sender:getTag()
      if tag==54 then --冷却返回
             self.mask_bg2:setVisible(false) 
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器

      elseif tag==53 then
         print("获取金币")
     
      end

end
--劲舞团
function JackpotLayer:audition(  )
      local progress_bg=self.JackpotScene:getChildByTag(40)  --滑动条
      self.w_size=progress_bg:getContentSize().width
      local win_kuang=self.JackpotScene:getChildByTag(152)  --中奖框
      self.win_x=win_kuang:getPositionX()
      self.progress_bt=self.JackpotScene:getChildByTag(41)   --移动小球
      self.position_x=self.progress_bt:getPositionX()
      self.po_x=self.progress_bt:getPositionX()+ self.w_size  
end
function JackpotLayer:update(dt)
      if self.progress_bt:getPositionX()>=self.po_x-5 then
         self.time=  -1
      elseif self.progress_bt:getPositionX()<=self.position_x then
         self.time= 1
      end
      self.progress_bt:setPositionX(self.progress_bt:getPositionX() +self.time )
     
end
--下载图片
function JackpotLayer:init_pic(  )
          local  list_table=LocalData:Instance():get_getgoldspoollistbale()
          local  jaclayer_data=list_table["ads"]
          for i=1,#jaclayer_data do
	          	local _table={}
	            _table["imgurl"]=jaclayer_data[i]["imgurl"]
         	            _table["max_pic_idx"]=#jaclayer_data
         	            _table["curr_pic_idx"]=i
                       Server:Instance():jackpotlayer_pic(jaclayer_data[i]["imgurl"],_table) --下载图片
          end
         

end
function JackpotLayer:back( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
          

end
function JackpotLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self,
                       function()
                       self:init_pic()
                      end)
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self,
                       function()
                      self:init()
                      end)
end

function JackpotLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self)
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self)
end


return JackpotLayer