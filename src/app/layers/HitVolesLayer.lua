--   打地鼠
--  2016-11-15
local HitVolesLayer = class("HitVolesLayer", function()
    return display.newLayer("HitVolesLayer")
end)

 function HitVolesLayer:ctor(params)  

         self.fragment_table={}
         self.fragment_table_tow={}
         self.target_table={
                  {target=nil,_randdate=nil},
                  {target=nil,_randdate=nil},
                  {target=nil,_randdate=nil}
          }
         
        self.countdown_time =27    --  设置倒计时
        self.dishu_time=self.countdown_time
        self:setNodeEventEnabled(true)--layer添加监听

        self.filename=params.filename
        self.adid=params.adid
        self.s = cc.Director:getInstance():getWinSize()
        self.rand_Date =nil --记录选中容器数据
        --  设置分数 锤子 老鼠  金币 TAG值
        self.kTagSprite1  =  1
        self.kTagSprite2  =  2
        self.kTagSprite3  =  3
        self.kTagSprite4  =  4
        self.kTagSprite5  =  5
        self.LabelAtlasTest = {}  -- 分数
        self.jia_score=0
        self.dishu_adid=params.dishu_adid
        self.Issecond=params.Issecond

        self.layerPlay=nil

        self.curr_tag=0--连击同一个对象标记TAG 初始为0
        self.curr_tag1=0

        --  拆分块数
        self.row=3
        self.col=4
        --  设置图片大小
        self.img_width=750
        self.img_height=1000
        local dishuk_table={}

        self.scheduler = cc.Director:getInstance():getScheduler()  --  

        local dex=1
        print("打地鼠是第几次",self.Issecond)
        if self.Issecond==1 then
         dex=2
        end
        
        --数值表
        self.color_Mode={
                {color_type="png/dadishu-02-guodong-5.png",time=3/dex,score=1},     --  +1积分  
                {color_type="png/dadishu-02-guodong-7.png",time=2/dex,score=4},      --  +4积分  
                {color_type="png/dadishu-02-guodong-1.png",time=3/dex,score=3},       --  +3积分  
                {color_type="png/dadishu-02-guodong-8.png",time=1/dex,score=1},         --  +1积分  
                {color_type="png/dadishu-02-guodong-6.png",time=1.5/dex,score=0},         --   不加分
                {color_type="png/dadishu-02-guodong-4.png",time=1.2/dex,score=10},          --  +10积分    

                {color_type="png/dadishu-02-guodong-3.png",time=3/dex,score=-1},        --  -3  时间  
                {color_type="png/dadishu-02-guodong-2.png",time=3/dex,score=-2},            --   +3时间 
                {color_type="png/dadishu-02-guodong-9.png",time=6/dex,score=-3}               --  -6时间   
        }   

     self:fun_init()
     self:refresh_table()  --图片拆分
     self:createPlayLayer()  --  初始化
     self:fun_score( )  --  分数
     self.m_time = 0

end
function HitVolesLayer:fun_init(  )
   self.HitVolesLayer = cc.CSLoader:createNode("HitVolesLayer.csb")
   self:addChild(self.HitVolesLayer) 
   self.Sample_figure=self.HitVolesLayer:getChildByTag(1463) --样图
   self.labelAtlas=self.HitVolesLayer:getChildByTag(1461) --分数
   self.labelAtlas:setVisible(false)

   self.dishu_loadingbar=self.HitVolesLayer:getChildByTag(1464)-- 时间进度条
   self.dishu_po_score=self.HitVolesLayer:getChildByTag(1951)-- 分数位置
   self.stop_bg=self.HitVolesLayer:getChildByTag(542)-- 暂停
   self.stop_bg:setLocalZOrder(100)

    local _back=self.HitVolesLayer:getChildByTag(1460)--返回
      _back:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
                 return
          end
            self.stop_bg:setVisible(true)
             self.scheduler:unscheduleScriptEntry(self.schedulHandle)

      end)
      local rules_bt=self.HitVolesLayer:getChildByTag(345)--规则
      rules_bt:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
                 return
          end
            self:fun_rules()    
            self.scheduler:unscheduleScriptEntry(self.schedulHandle)
      end)
      local continue_bt=self.stop_bg:getChildByTag(550)--继续
      continue_bt:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
                 return
          end
            self.stop_bg:setVisible(false)
             self.schedulHandle =  self.scheduler:scheduleScriptFunc(function(dt)
                        self:callback(1)
                end, 1.0, false) 
      end)
      local exit_bt=self.stop_bg:getChildByTag(549)--退出游戏
      exit_bt:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
                 return
          end
            Util:scene_control("GoldprizeScene")
      end)

       local getconfig=LocalData:Instance():get_getconfig()
        local _list = getconfig["list"]
        local _list1=_list[1]["sataus"]
        local _list2=_list[2]["sataus"]

      local sound_bt1=self.stop_bg:getChildByTag(551)--音效
       sound_bt1:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            LocalData:Instance():set_music(true)
                            Server:Instance():setconfig(_list[2]["itemsId"],0)  --  获取后台音效
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                            LocalData:Instance():set_music(false)
                            Server:Instance():setconfig(_list[2]["itemsId"],1)  --  获取后台音效

                        end
            end)
       local music_bt=self.stop_bg:getChildByTag(552)--音乐
        music_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            LocalData:Instance():set_music_hit(true)
                             Server:Instance():setconfig(_list[1]["itemsId"],0)  -- 
                             Util:player_music_hit("MENUMUSIC",true )
                            audio.resumeMusic()

                     elseif eventType == ccui.CheckBoxEventType.unselected then
                            LocalData:Instance():set_music_hit(false)
                            Server:Instance():setconfig(_list[1]["itemsId"],1)
                             audio.pauseMusic()
                     end
            end)


          if tonumber(_list1) == 0 then  --o 开  1  关闭
              music_bt:setSelected(true)
              audio.resumeMusic()
          else
              music_bt:setSelected(false)
              audio.pauseMusic()
          end
          if tonumber(_list2) == 0 then  --o 开  1  关闭
              sound_bt1:setSelected(true)
              audio.resumeAllSounds()
          else
              sound_bt1:setSelected(false)
              audio.pauseAllSounds()
          end



      self.congratulations=self.HitVolesLayer:getChildByTag(189)-- 恭喜获得
       self.congratulations:setLocalZOrder(100)
      self.congratulations_text =self.congratulations:getChildByTag(193)

  
end
--  图片拆分
 function HitVolesLayer:refresh_table()

   self.sf_x=self.Sample_figure:getPositionX()
   self.sf_y=self.Sample_figure:getPositionY()
--  新增加
    self.row=3
    self.col=4
    local row ,col =self.row,self.col 
     local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
    local cache = cc.Director:getInstance():getTextureCache():addImage(path  ..  self.filename)
   
    local layer=cc.Layer:create()
    self.layerPlay=layer

        local function onTouchEnded(x,y)
              
                self:hammerAction(x,y)
                if self:checkClision(x,y) then
                  
                          self:step()  --  分数增加
               
                    
                end
     end


     self.HitVolesLayer:setTouchEnabled(true)  
    self.HitVolesLayer:setTouchSwallowEnabled(false)  
    self.HitVolesLayer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)  
    self.HitVolesLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event) 

             if event.name == "began" then  
               onTouchEnded(event.x,event.y)  
            end  
      
             return true  
    end)  


    -- local function onTouchEnded(x,y)
              
    --             self:hammerAction(x,y)
    --             if self:checkClision(x,y) then
                  
    --                       self:step()  --  分数增加
               
                    
    --             end
    --  end
    --  local  function onTouch(event,x,y)
    --   -- dump(event)
    --   if event=="began" then
    --     -- print("-----",x,y)
    --     onTouchEnded(x,y)
    --   end
       
    --  end

    -- layer:setTouchEnabled(true)
    -- layer:registerScriptTouchHandler(onTouch)
    -- dump(self.Sample_figure:getContentSize())

    -- layer:setScale(0.7)--(0.703)
    -- layer:setAnchorPoint(0,1)
    self.HitVolesLayer:addChild(layer,3) 
   for i=1,row do
        for j=1,col do
            local fragment_sprite =display.newSprite()--cc.Sprite:create()
            fragment_sprite:setAnchorPoint(0.0, 0.0)
            fragment_sprite:setTexture(cache)
            fragment_sprite:setScale(0.7)
            --新增加
            local po={}
            po.width=750--self.Sample_figure:getContentSize().width
            po.height=1000--  self.Sample_figure:getContentSize().height   --self.s.height
            self.content_size=cc.size(750,1000)--self.Sample_figure:getContentSize()
            local rect = cc.rect((i-1)*self.content_size.width/row, (j-1)*self.content_size.height/col, self.content_size.width/row-3, self.content_size.height/col-3)
            
            fragment_sprite:setTextureRect(rect)
            fragment_sprite:setPosition(57+(i-1)*self.content_size.width*0.7/row, 187+self.content_size.height*0.7/col+(3-j)*self.content_size.height*0.7/col)--设置图片显示的部分
            layer:addChild(fragment_sprite)
            fragment_sprite:setTag(#self.fragment_table + 1)
            self.fragment_table[#self.fragment_table + 1] = fragment_sprite
            self.fragment_table_tow[#self.fragment_table_tow + 1] = fragment_sprite

            end  
       end  
end
function HitVolesLayer:fun_rules(  )
    self.Hitrules = cc.CSLoader:createNode("Hitrules.csb")
    self:addChild(self.Hitrules)
      local _back=self.Hitrules:getChildByTag(291)--返回
      _back:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
                 return
          end
          if  self.Hitrules then
             self.schedulHandle =  self.scheduler:scheduleScriptFunc(function(dt)
                        self:callback(1)
                end, 1.0, false)   --(callback, 1.0, false)

               self.Hitrules:removeFromParent()
          end
           
      end)
end

--  初始点击事件
function HitVolesLayer:createPlayLayer()
    self.layerPlay =cc.Layer:create()
    --self.layerPlay:setScale(0.5)
    self.HitVolesLayer:addChild(self.layerPlay,4) 
    -- 初始化 地鼠   锤子   金币
    local spriteVole = cc.Sprite:create()
    local spriteHammer = cc.Sprite:create("png/dadishu-02-shou-01.png")  
    -- spriteHammer:setScale(0.3)
    spriteHammer:setAnchorPoint(cc.p(0.5,0.5))

    local spriteCoins = cc.Sprite:create()
     -- local mask = cc.CSLoader:createNode("masklayer.csb")--cc.Sprite:create("png/GRzhezhaoceng.png")
     -- mask:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
     -- mask:setVisible(false)
    local  _score= cc.Sprite:create()
    -- local countdown = cc.Sprite:create()
    self.layerPlay:addChild(spriteVole, 0, self.kTagSprite3)
    self.layerPlay:addChild(spriteHammer, 0, self.kTagSprite4)
    self.layerPlay:addChild(spriteCoins, 0, self.kTagSprite5)
    self.layerPlay:addChild(_score, 0, self.kTagSprite2)
    --self.layerPlay:addChild(mask, 0, 20)
   -- self.layerPlay:addChild(countdown, 0, self.kTagSprite1)
    self:fun_countdown_time()


    self._score2 =   ccui.TextAtlas:create(tostring(self.jia_score),"png/dadishu_fenshu.png", 57, 77, "0")--
    self._score2 :setAnchorPoint(1,0.5)
    self._score2 :setVisible(false)
    -- _score2:setPosition(320, 480)
    self.layerPlay:addChild(self._score2 ,1,1086)
    -- local  move1=cc.MoveTo:create(0.5, cc.p( x,y+180 ) )
    -- _score:setPosition(cc.p(x,y))

    local dishu_jia=cc.Sprite:create("png/dadishu-02-jiahao.png")
    dishu_jia:setPosition(-15, 35)
    self._score2 :addChild(dishu_jia)
    -- dishu_jia:setPosition(cc.p(x-_score:getContentSize().width-20,y))  
    -- local  move2=cc.MoveTo:create(0.5, cc.p( x-_score:getContentSize().width-20,y+180 ) )
    --  local function logSprRotation1(sender)
    --                  sender:removeFromParent()                    
    --  end
    --  local action1= cc.Sequence:create(move2,cc.CallFunc:create(logSprRotation1))
    --  dishu_jia:stopAllActions()
    --   dishu_jia:runAction(action1)
   

    return self.layerPlay

end
--检测进度条
function HitVolesLayer:fun_loadingbar(  )
       --  检测进度条
         if self.dishu_time<=self.countdown_time then
            self.dishu_loadingbar:setPercent(100)
        elseif self.countdown_time<0 then
            self.dishu_loadingbar:setPercent(0)
        else
          self.dishu_loadingbar:setPercent(self.countdown_time/self.dishu_time  *  100 )
         end

end
function HitVolesLayer:server_data(  )
     Server:Instance():setgamerecord(self.adid,1,self.m_time,100)    --  打完地鼠上传的数据
     LocalData:Instance():setPoints(self.m_time)
     --NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS)
     
end
--地鼠钻地动画定时器回调函数
function HitVolesLayer:callback(dt)

         self.countdown_time=self.countdown_time-1
         self:fun_loadingbar()
         if self.countdown_time <= 0 then
            --     local function stopAction()
            --                 self.congratulations:setVisible(false)
            --                 self:server_data()
            --     end
            --     audio.playMusic("sound/effect/hit_3.mp3",false)
            --   local callfunc = cc.CallFunc:create(stopAction)
            --   self.congratulations:stopAllActions()
            --  self.congratulations:runAction(cc.Sequence:create(cc.DelayTime:create(2),callfunc  ))
            --   self.congratulations:setVisible(true)--self.m_time
            -- self.congratulations_text:setString(tostring(self.m_time))
            self:server_data()
            self.scheduler:unscheduleScriptEntry(self.schedulHandle)
             return
         end
        
        for i=1,#self.target_table do
            if self.target_table[i]["target"]==nil then
                                local rand=math.random(#self.fragment_table_tow)
                                local donghua=self.fragment_table_tow[rand]
                                table.remove(self.fragment_table_tow,rand)

                                local   _rand=self.color_Mode[math.random(6)]--
                                self.target_table[i]["target"]=donghua
                                 self.target_table[i]["_randdate"]=_rand

                                local fragment_sprite = display.newSprite("png/dadishu-02-touming-yuan.png")
                                fragment_sprite:setPosition(cc.p(donghua:getContentSize().width*3/4,donghua:getContentSize().height*3/4))
                                -- fragment_sprite:setTag(#self.target_table)
                                fragment_sprite:setAnchorPoint(1,1)

                                local Water_polo = display.newSprite(_rand["color_type"])
                                Water_polo:setPosition(cc.p(fragment_sprite:getContentSize().width/2,fragment_sprite:getContentSize().height/2))
                                Water_polo:setAnchorPoint(0.5,0.5)
                                fragment_sprite:addChild(Water_polo)

                                local giction=cc.NodeGrid:create()
                                giction:addChild(fragment_sprite)
                                donghua:addChild(giction,100,2) 
                                -- giction:runAction(liquid);  

                                  local function CallFucnCallback3(sender)
                                       
                                        for i=1,#self.target_table do
                                            if self.target_table[i].target and sender:getTag()==self.target_table[i].target:getTag() then

                                                  if self.curr_tag==sender:getTag() then
                                                      self.curr_tag=0
                                                  end
                                                  table.insert(self.fragment_table_tow,self.target_table[i]["target"])
                                                   sender:getChildByTag(2):removeFromParent()
                                                   self.target_table[i]["target"]=nil
                                                  self.target_table[i]["_randdate"]=nil
                                            end
                                        end
                                end
                                local time=_rand["time"]
                                if time<0 then  time=2   end
                                local seq = cc.Sequence:create(cc.DelayTime:create(time),cc.CallFunc:create(CallFucnCallback3))
                                donghua:stopAllActions()
                                donghua:runAction(seq)
                    return
               end
        end
end

-- 水波动画
function HitVolesLayer:Act_Waterpolo(_fragment)  --_fragment   图

              audio.playSound("sound/effect/hit_2.mp3",false)
              local waves = cc.Waves:create(1, cc.size(10, 10), 10, 5, true, true);
              local  liquid = cc.Liquid:create(0.5, cc.size(10, 10), 2, 5.0);  
              _fragment:getChildByTag(2):stopAllActions()
                _fragment:getChildByTag(2):runAction(liquid);  
end


--手指动画
function HitVolesLayer:hammerAction(x,y)
    --创建动画序列
    local animation = cc.Animation:create()
    local number,name
    for i=0,1 do
      number = i 
      name = "png/dadishu-02-shou-0"..number..".png"
      animation:addSpriteFrameWithFile(name)
    end

    animation:setDelayPerUnit(0.3/3.0)
    animation:setRestoreOriginalFrame(true)

    local animate = cc.Animate:create(animation)
    local node = self.layerPlay:getChildByTag(self.kTagSprite4)
    -- node:setAnchorPoint(0.75,1.0)
    node:setVisible(true)
    local function logSprRotation(sender)
    node:setVisible(false)
    end
    local action = cc.Sequence:create(animate,animate:reverse(),cc.CallFunc:create(logSprRotation))

    node:setPosition(x,y)

    node:stopAllActions()
    node:runAction(action)
   
end
--检测碰撞
function HitVolesLayer:checkClision(x,y)
      self.rand_Date=nil
       for i=1,#self.target_table do
            local sVole=self.target_table[i].target
            if sVole then
                local rect   = sVole:getBoundingBox()
                if cc.rectContainsPoint(rect, cc.p(x, y)) then
                        self:Act_Waterpolo(sVole)
                         self.rand_Date=self.target_table[i]._randdate
                         self.curr_tag=sVole:getTag()
                           if     self.rand_Date["score"]==-1   then 
                               self.countdown_time=self.countdown_time-3
                          elseif self.rand_Date["score"]==-2  then
                              self.countdown_time=self.countdown_time+3
                               if self.countdown_time>self.dishu_time then
                                 self.countdown_time=self.dishu_time
                               end                            
                          elseif self.rand_Date["score"]==-3  then
                                self.countdown_time=self.countdown_time-6
                           else
                            self.jia_score=self.rand_Date["score"]
                            self:coinAction(x,y)
                          end
                         
                         
                         return true
                end
            end

       end
       -- audio.playMusic("sound/effect/hit_1.mp3",false)
        self.curr_tag=0
         return false
 end
 --分数动画
function HitVolesLayer:coinAction(x,y)
    -- if self.jia_score==0 then
    --    return
    -- end
     -- local x=self.dishu_po_score:getPositionX()
     -- local  y=self.dishu_po_score:getPositionY()

    
    self._score2 :setVisible(true)
     self._score2:setPosition(x, y)

    self._score2:setProperty(tostring(self.jia_score),"png/dadishu_fenshu.png", 57, 77, "0")
    
   
     local function logSprRotation(sender)
                     self._score2 :setVisible(false)                   
     end
     local  move1=cc.MoveTo:create(0.5, cc.p( x,y+180 ) )
     local action = cc.Sequence:create(move1,cc.CallFunc:create(logSprRotation))
     self._score2:stopAllActions()
     self._score2:runAction(action)

    
   
end
--  加时间动画
function HitVolesLayer:fun_acttime(  x,y)

    local dishu_jia=cc.Sprite:create("png/dadishu-02-shizhong-1.png")
    self.layerPlay:addChild(dishu_jia)
    local  bgSize = cc.Director:getInstance():getWinSize()
    dishu_jia:setPosition(cc.p(x,y ))  
    local  move2=cc.MoveTo:create(0.5, cc.p( x,y+40 ) )
     local function logSprRotation1(sender)
                     sender:removeFromParent()                    
     end
     local action1= cc.Sequence:create(move2,cc.CallFunc:create(logSprRotation1))
      dishu_jia:runAction(action1)


end
--  初始化分数
function HitVolesLayer:fun_score( )
    self.dishu_score = ccui.TextAtlas:create()
    self.dishu_score:setPosition(cc.p(self.labelAtlas:getPositionX(),self.labelAtlas:getPositionY()))  
    self.dishu_score:setProperty( "0","png/dadishufenshu.png", 24, 26, "0")  --tostring(self.friendlist_num["friendcount"]),
    self.HitVolesLayer :addChild(self.dishu_score) 
end
--  分数
function HitVolesLayer:step()
  --  if  self.curr_tag1~=self.curr_tag then 
        if tonumber(self.rand_Date["score"])  <=  -1 then
            self.m_time=self.m_time+0
             self.jia_score=0
        else
            self.m_time=self.m_time+self.rand_Date["score"]
             self.jia_score=self.rand_Date["score"]
        end
        
       
    -- else
    --      self.m_time = self.m_time +1
    --      self.jia_score=1
    -- end
   self.curr_tag1=self.curr_tag
    self.dishu_score:setProperty(tostring(self.m_time),"png/dadishufenshu.png", 24, 26, "0")  --
end
--增加幸运卡
function HitVolesLayer:add_reward( )
        self.Rewardvouchers = cc.CSLoader:createNode("Rewardvouchers.csb")
         self.Rewardvouchers :setVisible(false)
        self:addChild(self.Rewardvouchers,10000)
        local jique=self.Rewardvouchers:getChildByTag(421)
        local jinyan=self.Rewardvouchers:getChildByTag(102)
         self.began_bt=self.Rewardvouchers:getChildByTag(421):getChildByTag(425)  --立即参与
         self.began_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)

        self.again_bt=self.Rewardvouchers:getChildByTag(421):getChildByTag(426)  --再来一局
         self.again_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)


         self.jbegan_bt=self.Rewardvouchers:getChildByTag(102):getChildByTag(106)  --返回奖池
         self.jbegan_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)

        self.jagain_bt=self.Rewardvouchers:getChildByTag(102):getChildByTag(107)  --经验再来一局
         self.jagain_bt:addTouchEventListener(function(sender, eventType  )
                   self:touch_callback( sender, eventType )             
          end)

         local _table=LocalData:Instance():get_setgamerecord()--保存数据
         if   not _table["goldspool"] then
             return
         end
          local goldspool=_table["goldspool"]
         -- if tonumber(goldspool["coolingtime"]) ==  -1 then
         --       jique:setVisible(false)
         --       jinyan:setVisible(true)
         -- else
               -- jique:setVisible(true)
               -- jinyan:setVisible(false)
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS)  --发送消息  进入奖项详情 
               

        -- end
end
function HitVolesLayer:touch_callback( sender, eventType )
          local tag=sender:getTag()

      if eventType ~= ccui.TouchEventType.ended then
         return
      end
      if tag==425 then --立即参与

          if self.Rewardvouchers then
              self.Rewardvouchers:removeFromParent()
          end
              cc.Director:getInstance():popScene()
              Server:Instance():getgoldspoolbyid(LocalData:Instance():get_user_oid())
              Server:Instance():sceneinformation()            
      elseif tag==426 then   --再来一局
         local _table=LocalData:Instance():get_actid()--保存数
         local scene=GameScene.new({adid=_table["act_id"],type="audition",image=_table["image"]})
         cc.Director:getInstance():popScene()
         cc.Director:getInstance():pushScene(scene)
       elseif tag==106 then   --返回奖池
           if self.Rewardvouchers then
              self.Rewardvouchers:removeFromParent()
          end
         
           Util:scene_control("GoldprizeScene")     --  返回奖池首图列表
          
       elseif tag==107 then   --再来一局
     
         GameScene = require("app.scenes.GameScene")--惊喜吧
          local scene=GameScene.new({adid=self.dishu_adid,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=2})--拼图
          cc.Director:getInstance():replaceScene(scene)
         -- LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
             
     end

end

--  倒计时动画
function HitVolesLayer:fun_countdown_time(  )
      local node = cc.CSLoader:createNode("battlestart.csb")
      local action = cc.CSLoader:createTimeline("battlestart.csb")
      action:setTimeSpeed(0.25)
      node:runAction(action)
      action:gotoFrameAndPlay(0,80,false)

      local function stopAction()
             if  node then
                     node:removeFromParent()
                     self.schedulHandle =  self.scheduler:scheduleScriptFunc(function(dt)
                        self:callback(1)
                    end, 1.0, false)   --(callback, 1.0, false)
              end
      end

       local callfunc = cc.CallFunc:create(stopAction)
      node:runAction(cc.Sequence:create(cc.DelayTime:create(6),callfunc  ))
      self:addChild(node)

end


function HitVolesLayer:onEnter()

              NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self,
                       function()
                        print("接到请求")
                              
                               self:add_reward( )
                      end)

end

function HitVolesLayer:onExit()

                NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GAMERECORD_POST, self)
                cc.Director:getInstance():getTextureCache():removeAllTextures() 
end






return   HitVolesLayer