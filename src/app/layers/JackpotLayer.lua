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

GameScene = require("app.scenes.GameScene")--惊喜吧

--标题 活动类型 
function JackpotLayer:ctor(params)
         self.is_cooltime=true
         self.id=params.id
         Server:Instance():getgoldspoolbyid(self.id)
         Server:Instance():getgoldspooladlist(self.id)  --
         Server:Instance():getrecentgoldslist(10)-- 中奖信息
         -- Server:Instance():getgoldspoolrandomgolds(self.id,1)

         self:setNodeEventEnabled(true)--layer添加监听
         self.is_bright=true
         self.secondOne = 0
         self.time=0
          self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
            self:update(dt)
      end)
end
function JackpotLayer:init(  )
        
        

  	  self.JackpotScene = cc.CSLoader:createNode("JackpotScene.csb")
        self:addChild(self.JackpotScene)
        self.roleAction = cc.CSLoader:createTimeline("JackpotScene.csb")
        self.JackpotScene:runAction(self.roleAction)
        self.roleAction:setTimeSpeed(5)
        self.goldanimation = cc.CSLoader:createNode("goldanimation.csb")
        self.goldanimation:setVisible(false)
        self:addChild(self.goldanimation)
        self.goldAction = cc.CSLoader:createTimeline("goldanimation.csb")
        self.goldanimation:runAction(self.goldAction)

         local reward_bt=self.JackpotScene:getChildByTag(777)  -- 是否选择幸运卡
        reward_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.is_double=1   --翻倍
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                            self.is_double=2  --普通
                            
                     end
        end)


        
        
         --新增加动画
         -- self.actdhua=self.JackpotScene:getChildByTag(229)  --金币动画界面
         -- self.actdhua:addTouchEventListener(function(sender, eventType  )
         --      self:touch_callback(sender, eventType)
         --  end)
         -- self._jinbi=self.actdhua:getChildByTag(277):getChildByTag(278)  --金币数量


         self.actdhua=self.goldanimation:getChildByTag(780)  --金币动画界面
         self.actdhua:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
          end)
         self._jinbi=self.actdhua:getChildByTag(781):getChildByTag(782)  --金币数量



         self.shuiguo1=self.JackpotScene:getChildByTag(771):getChildByTag(773)
         self.shuiguo1:setVisible(false)
         self.shuiguo2=self.JackpotScene:getChildByTag(771):getChildByTag(774)
         self.shuiguo2:setVisible(false)
         self.shuiguo3=self.JackpotScene:getChildByTag(771):getChildByTag(775)
         -- self.shuiguo3:setVisible(false)

         --self.actdhua:setVisible(false)


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
        local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
        _advertiImg:loadTexture(path..tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":")))--

        if #jaclayer_data>=2 then
             for i=2,#jaclayer_data do
                  local  call=advertiPa:clone() 
                  local advertiImg=call:getChildByTag(155)
                  advertiImg:loadTexture(tostring(Util:sub_str(jaclayer_data[i]["imgurl"], "/",":")))--
                  self.advertiPv:addPage(call)   
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
                   if self._slowdown then
                       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._slowdown)--停止水果机定时器
                   end
                   
        end)

         --中奖信息排行
        self._ListView=self.JackpotScene:getChildByTag(31):getChildByTag(35)--中奖信息排行
        self._ListView:setItemModel(self._ListView:getItem(0))
        self._ListView:removeAllItems()


          -- self:information()
          self:audition()
          self:wininformation()

end
--中奖信息排行
function  JackpotLayer:wininformation(  )
            self._ListView:removeAllItems() 
            local _table=LocalData:Instance():get_getrecentgoldslist()

            local goldslist=_table["goldslist"]
            if goldslist==0 then
               return
            end

             for i=1,#goldslist do
                  self._ListView:pushBackDefaultItem()
                  local  cell = self._ListView:getItem(i-1)
                  cell:setTag(i)
                  local name=cell:getChildByTag(38)
                  name:setString(goldslist[i]["nickname"])
                  local _gold=cell:getChildByTag(39)
                  _gold:setString(goldslist[i]["golds"])
          end

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

             self.ordinary_bt=self.JackpotScene:getChildByTag(44)  --普通
             self.ordinary_bt:setBright(false)
             self.curr_bright=self.ordinary_bt
             self.ordinary_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
              self.special_bt=self.JackpotScene:getChildByTag(45)  --翻倍
             self.special_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)
              local obtain_bt=self.JackpotScene:getChildByTag(47)  --获取参与卷
             obtain_bt:addTouchEventListener(function(sender, eventType  )
                       self:touch_callback( sender, eventType )             
              end)

             self.be_num=self.JackpotScene:getChildByTag(999)  --参与卷
             dump(list_table["playcardamount"])
             self.playcardamount=tonumber(list_table["playcardamount"])
             -- dump(list_table)
             dump(self.playcardamount)
             self.be_num:setString(list_table["playcardamount"])
             self.coolingtime=list_table["coolingtime"]   --  0 可以玩  -1  今天不能玩
             self.is_double = 2  --  1  是翻倍   2  不使用

end
function JackpotLayer:vouchers(  )
         local _table=LocalData:Instance():get_setgamerecord()--保存数据
         local goldspool=_table["goldspool"]
         self.be_num:setString(goldspool["playcardamount"])
         self.playcardamount=tonumber(goldspool["playcardamount"])
end
function JackpotLayer:touch_callback( sender, eventType )

      local tag=sender:getTag()
     -- if eventType == 0 then
     --         if tag==46 then --开始
     --         self:act_began( )   
     --       end
     --  end

      if eventType ~= ccui.TouchEventType.ended then
         return
      end
      if self.curr_bright:getTag()==tag then
                  return
       end

      dump(tag)
      if tag==46 then --开始
              self:act_began( )   
      elseif tag==44 then
            self.curr_bright=sender
            self.is_double=2
            print("普通")
            self.ordinary_bt:setBright(true)
            self.special_bt:setBright(false)
      elseif tag==45 then
            if self._carnum>0 then
               self.curr_bright=sender
               print("翻倍",self._carnum)
               self._carnum=self._carnum-1
               self.is_double=1
               self.ordinary_bt:setBright(false)
               self.special_bt:setBright(true)
            end
             Server:Instance():prompt("翻倍卡不足")
            -- print("翻倍卡不足")
            -- self.is_double=2 -- 测试
            -- self.car_num:setString(tostring(self._carnum) )
      elseif tag==155 then  --劲舞团结束  测试动画 
                 --self.end_bt:setTouchEnabled(false)
                 -- print("wwqwerewar   ",self.roleAction:getCurrentFrame()%5)
                 -- print("wwqwerewar   ",self.roleAction:getCurrentFrame())
                 -- print("wwqwerewar   ",self.roleAction:getCurrentFrame()-self.roleAction:getCurrentFrame()%5)
                 -- self.roleAction:setCurrentFrame(self.roleAction:getCurrentFrame()-self.roleAction:getCurrentFrame()%5)
                 -- self.roleAction:pause()
                 self:fun_slowdown( )  --减速
             --     self.shuiguo1:setVisible(false)
             --     self.shuiguo2:setVisible(false)
             --     local _tablegods=LocalData:Instance():get_getgoldspoolrandomgolds()
             --     dump(_tablegods)
             --     --self._jinbi:setString("+"  ..  _tablegods["golds"])     
             -- --self:unscheduleUpdate()
             --    local function stopAction()
             --      self:fun_win()
             --      self.goldanimation:setVisible(false)
             --    end
             --  self.goldanimation:setVisible(true)
             --  self.goldAction:gotoFrameAndPlay(0,20, true)

              -- local callfunc = cc.CallFunc:create(stopAction)
              -- self.JackpotScene:runAction(cc.Sequence:create(cc.DelayTime:create(100),callfunc  ))
             
      elseif tag==47 then  --获取参与卷

             local  list_table=LocalData:Instance():get_getgoldspoollistbale()
             local  jaclayer_data=list_table["ads"]
              local  _id=jaclayer_data[1]["adid"]
              local scene=GameScene.new({adid=_id,type="audition",image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})
              cc.Director:getInstance():pushScene(scene)
              LocalData:Instance():set_actid({act_id=_id,image=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))})--保存数
      elseif tag==780 then
              self:fun_win()
              self.goldanimation:setVisible(false)
      end
      
end

--劲舞团减速
 function JackpotLayer:slowdown()
               self.slowdown_num=self.slowdown_num-0.1
               self.roleAction:setTimeSpeed(self.slowdown_num)
               if self.slowdown_num<=0.1 then
                     self.slowdown_num=0.15
                      local _tablegods=LocalData:Instance():get_getgoldspoolrandomgolds()
                     if self.roleAction:getCurrentFrame()+2>self.glodreward[tostring(_tablegods["golds"])]  and  self.roleAction:getCurrentFrame()-2<self.glodreward[tostring(_tablegods["golds"])] then
                            self.roleAction:gotoFrameAndPause(self.glodreward[tostring(_tablegods["golds"])])
                            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._slowdown)--停止定时器
                            self.shuiguo1:setVisible(false)
                            self.shuiguo2:setVisible(false)
                           
                           --self._jinbi:setString("+"  ..  _tablegods["golds"])     
                           --self:unscheduleUpdate()
                          local function stopAction()
                            self:fun_win()
                            self.goldanimation:setVisible(false)
                          end
                        -- self.goldanimation:setVisible(true)
                        -- self.goldAction:gotoFrameAndPlay(0,20, true)
                         local function removeThis()
                           self:fun_win()
                           self.goldanimation:setVisible(false)
                        end
                         self.shuiguo3:runAction( cc.Sequence:create(cc.Blink:create(3, 3),cc.CallFunc:create(removeThis)))


                     end

                  -- self.roleAction:gotoFrameAndPause(self.roleAction:getCurrentFrame()-self.roleAction:getCurrentFrame()%5)
                  -- cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._slowdown)--停止定时器
                 

               end
              
                
end
function JackpotLayer:fun_slowdown( )
      self.glodreward ={["7"]=0,["10"]=5,["1000"]=10,["5"]=15,["15"]=20,["50"]=25,["20"]=30,["200"]=35,
                                ["9"]=40,["711"]=45,["500"]=50,["6"]=55,["19"]=60,["14"]=65,["16"]=70,["100"]=75}
      

      print("就将计就计",self.glodreward[tostring(7)])
      self.slowdown_num=3
      self._slowdown=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:slowdown()
              end,0.1, false)
end

function JackpotLayer:act_began( )
       self.cunum=0
       self.end_bt:setTouchEnabled(true)
       if self.is_cooltime==false then
           self:fun_cool(  )
            return
       end
       if self.playcardamount<=0 then
           Server:Instance():prompt("参与卷不够，请您充值")
           return
       end
        if self.coolingtime==-1 then
           Server:Instance():prompt("冷却时间不够，请等待")
           return
       end
      
        if self.playcardamount >0  and self.coolingtime~=-1 then
             print("拥有参与卷")
             self.is_cooltime=false
        
             self.playcardamount=self.playcardamount-1
             self.began_bt:setVisible(false)
             -- self:scheduleUpdate()
            self.roleAction:gotoFrameAndPlay(self.roleAction:getCurrentFrame(),75, true)
            --  if  self.cunum==0 then
            --       
            -- else
            --    self.roleAction:resume()
            --  end
             

             self.roleAction:setTimeSpeed(5)
             Server:Instance():getgoldspoolrandomgolds(self.id,self.is_double)
             self.be_num:setString(tostring(self.playcardamount))
             self.shuiguo1:setVisible(true)
             self.shuiguo2:setVisible(true)
             return
        end
        print("没有参与卷")
         
        --测试
        -- self.began_bt:setVisible(false)
        -- self:scheduleUpdate() 
        -- Server:Instance():getgoldspoolrandomgolds(self.id,self.is_double)
        --获取随机金币个数
        
end
--劲舞团获取的金币
function JackpotLayer:fun_win(  )
            --  测试
             local userdt = LocalData:Instance():get_userdata()--用户数据
             dump(userdt)
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
            --  self:unscheduleUpdate()
            --  冷却时间界面
            self:fun_cool()

end
--倒计时定时器
 function JackpotLayer:countdown()
           self._time=self._time-1
           self._countdown:setString(tostring(self._time))
           if self._time==0 then
              self.is_cooltime=true
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
            --   self.acthua:setVisible(true)
            --   self.roleAction:gotoFrameAndPlay(0,60, false)
            --   if self.roleAction:getEndFrame()~=60 then
            --       print("12223")
            --       self.acthua:setVisible(false)
                  
            -- end
     
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
      if self.progress_bt:getPositionX()>=self.po_x-45 then
         self.time=  -15
      elseif self.progress_bt:getPositionX()<=self.position_x then
         self.time= 15
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
NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST, self,
                       function()
                                self:information()
                      end)
NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self,
                       function()
                               self:vouchers(  )
                                print("劲舞团")
                      end)
  --劲舞团开启停止后返回的后台随机金币数量
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self,
                       function()
                         local random_golds= LocalData:Instance():get_getgoldspoolrandomgolds()
                         dump(random_golds)
                      end)
end

function JackpotLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLIST_INFOR_POST, self)
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.JACKPOTLISTPIC_INFOR_POST, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self)
        NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GOLDSPOOLBYID_POST, self)
        NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self)
end


return JackpotLayer