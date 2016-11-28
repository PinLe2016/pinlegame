--   打地鼠
--  2016-11-15
local HitVolesLayer = class("HitVolesLayer", function()
    return display.newLayer("HitVolesLayer")
end)

 function HitVolesLayer:ctor(params)
    --  建立3D  
      -- cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION3_D);
      -- self:setRotation3D({x=-25,y=0,z=0})   

         self.fragment_table={}
         self.target_table={
                  {target=nil,_randdate=nil},
                  {target=nil,_randdate=nil},
                  {target=nil,_randdate=nil}
          }
         
        self.countdown_time =20    --  设置倒计时
        self.dishu_time=20
        self:setNodeEventEnabled(true)--layer添加监听

        self.filename=params.filename
        self.adid=params.adid
        self.s = cc.Director:getInstance():getWinSize()
        self.rand_Date =nil --记录选中容器数据
        --  设置分数 锤子 老鼠  金币 TAG值
        self.kTagSprite2  =  2
        self.kTagSprite3  =  3
        self.kTagSprite4  =  4
        self.kTagSprite5  =  5
        self.LabelAtlasTest = {}  -- 分数
        self.jia_score=0

        self.layerPlay=nil

        self.curr_tag=0--连击同一个对象标记TAG 初始为0
        self.curr_tag1=0

        --  拆分块数
        self.row=3
        self.col=4
        --  设置图片大小
        -- self.img_width=750
        -- self.img_height=1000
        local dishuk_table={}

        self.scheduler = cc.Director:getInstance():getScheduler()  --  
        --数值表
        self.color_Mode={
                {color_type="png/dadishu-02-guodong-1.png",time=3,score=1},       
                {color_type="png/dadishu-02-guodong-2.png",time=2,score=4},
                {color_type="png/dadishu-02-guodong-3.png",time=3,score=3},
                {color_type="png/dadishu-02-guodong-4.png",time=1,score=1},
                {color_type="png/dadishu-02-guodong-5.png",time=1.5,score=0},
                {color_type="png/dadishu-02-guodong-6.png",time=3.5,score=10},

                {color_type="png/dadishu-02-guodong-7.png",time=3,score=-1},
                {color_type="png/dadishu-02-guodong-8.png",time=3,score=-1},
                {color_type="png/dadishu-02-guodong-9.png",time=6,score=-1}
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

    local _back=self.HitVolesLayer:getChildByTag(1460)--返回
      _back:addTouchEventListener(function(sender, eventType  )
           if eventType ~= ccui.TouchEventType.ended then
                 return
          end
            self.scheduler:unscheduleScriptEntry(self.schedulHandle)
            Util:scene_control("GoldprizeScene")
      end)

  
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
    -- layer:setScale(0.7)--(0.703)
     self.content_size=self.Sample_figure:getContentSize()
     dump(self.content_size)
    self.HitVolesLayer:addChild(layer,3) 
   for i=1,row do
        for j=1,col do
            local fragment_sprite =display.newSprite()--cc.Sprite:create()
            fragment_sprite:setTexture(cache)
            fragment_sprite:setScaleX(0.703)
            fragment_sprite:setScaleY(0.703)

            fragment_sprite:setAnchorPoint(0.5, 0.5)
            --新增加
            -- local po={}
            -- po.width=self.img_width
            -- po.height=  self.img_height   --self.s.height
           
            local rect = cc.rect((i-1)*self.content_size.width/row, (j-1)*self.content_size.height/col, self.content_size.width/row-3, self.content_size.height/col-3)
            
            fragment_sprite:setTextureRect(rect)
            fragment_sprite:setPosition(70+(i-1)*self.content_size.width*0.7/row, 400 +(3-j)*self.content_size.height*0.7/col)--设置图片显示的部分
            layer:addChild(fragment_sprite)
            fragment_sprite:setTag(#self.fragment_table + 1)
            self.fragment_table[#self.fragment_table + 1] = fragment_sprite

            local function onTouchEnded(x,y)
                self:hammerAction(x,y)
                if self:checkClision(x,y) then
                    self:step()  --  分数增加
                end
            end


            fragment_sprite:setTouchEnabled(true)
            fragment_sprite:setTouchSwallowEnabled(false)
            fragment_sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                        -- 触摸识别
                                 if event.name == "began" then
                                         return onTouchEnded(event.x,event.y)
                                  end
              end)
  

            end  
       end  
end


--  初始点击事件
function HitVolesLayer:createPlayLayer()
    self.layerPlay =cc.Layer:create()
    --self.layerPlay:setScale(0.5)
    self.HitVolesLayer:addChild(self.layerPlay,4) 
    -- 初始化 地鼠   锤子   金币
    local spriteVole = cc.Sprite:create()
    local spriteHammer = cc.Sprite:create()  
    spriteHammer:setAnchorPoint(cc.p(0.5,0.5))

    local spriteCoins = cc.Sprite:create()
    local  _score= cc.Sprite:create()
    self.layerPlay:addChild(spriteVole, 0, self.kTagSprite3)
    self.layerPlay:addChild(spriteHammer, 0, self.kTagSprite4)
    self.layerPlay:addChild(spriteCoins, 0, self.kTagSprite5)
    self.layerPlay:addChild(_score, 0, self.kTagSprite2)

    self.schedulHandle =  self.scheduler:scheduleScriptFunc(function(dt)
            self:callback(1)
    end, 1.0, false)   --(callback, 1.0, false)

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
--地鼠钻地动画定时器回调函数
function HitVolesLayer:callback(dt)

         self.countdown_time=self.countdown_time-1
         self:fun_loadingbar()
         -- if self.countdown_time <= 0 then
             
         --      Server:Instance():setgamerecord(self.adid)    --  打完地鼠上传的数据
         --     --NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS)
         --     self.scheduler:unscheduleScriptEntry(self.schedulHandle)
         --     return
         -- end
        
        for i=1,#self.target_table do
            if self.target_table[i]["target"]==nil then
                              
                                local donghua=self.fragment_table[math.random(#self.fragment_table)]
                                local   _rand=self.color_Mode[math.random(9)]--
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
              local waves = cc.Waves:create(1, cc.size(10, 10), 10, 5, true, true);
              local  liquid = cc.Liquid:create(1, cc.size(10, 10), 2, 5.0);  
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


    node:runAction(action)
   
end
--检测碰撞
function HitVolesLayer:checkClision(x,y)
      self.rand_Date=nil
       for i=1,#self.target_table do
            local sVole=self.target_table[i].target
            if sVole then

                local sHammer = self.layerPlay:getChildByTag(self.kTagSprite4)
                local rect   = sVole:getBoundingBox()

                local rect1   = sHammer:getBoundingBox()
                
                if cc.rectContainsPoint(rect, rect1) then
                         self.curr_tag=sVole:getTag()
                           -- if  self.rand_Date and   self.rand_Date["score"]==-1 then 
                               
                           --     self:act_time()
                           -- else
                             self:coinAction(x,y)
                          --end
                         self:coinAction(x,y)
                         self:Act_Waterpolo(sVole)
                         self.rand_Date=self.target_table[i]._randdate
                         return true
                end
            end

       end
        self.curr_tag=0
         return false
 end
 --  事件动画
function HitVolesLayer:act_time(  )
    local dishu_jia=cc.Sprite:create("png/dadishu-02-shizhong-1.png")
    self.layerPlay:addChild(dishu_jia)
    dishu_jia:setPosition(cc.p(display.x/2 ,display.y/2))  
    local  move2=cc.MoveTo:create(0.5, cc.p( display.x/2 ,display.y/2+30 ) )
     local function logSprRotation1(sender)
                     sender:removeFromParent()                    
     end
     local action1= cc.Sequence:create(move2,cc.CallFunc:create(logSprRotation1))
      dishu_jia:runAction(action1)


end
 --分数动画
function HitVolesLayer:coinAction(x1,y1)
    if self.jia_score==0 then
       return
    end
     local x=self.dishu_po_score:getPositionX()
     local  y=self.dishu_po_score:getPositionY()

    local  _score =   ccui.TextAtlas:create()--
    _score:setAnchorPoint(1,0.5)
    self.layerPlay:addChild(_score)
    local  move1=cc.MoveTo:create(0.5, cc.p( x,y+30 ) )
    _score:setPosition(cc.p(x,y))  
    if self.jia_score==0 then  --  因为打Plist  时候错位
       _score:setProperty(tostring(9),"png/dadishu_fenshu.png", 57, 77, "0")
    else
       _score:setProperty(tostring(self.jia_score-1),"png/dadishu_fenshu.png", 57, 77, "0")
    end
     
   
     local function logSprRotation(sender)
                     sender:removeFromParent()                    
     end
     local action = cc.Sequence:create(move1,cc.CallFunc:create(logSprRotation))
      _score:runAction(action)

    local dishu_jia=cc.Sprite:create("png/dadishu-02-jiahao.png")
    self.layerPlay:addChild(dishu_jia)
    dishu_jia:setPosition(cc.p(x-_score:getContentSize().width-20,y))  
    local  move2=cc.MoveTo:create(0.5, cc.p( x-_score:getContentSize().width-20,y+30 ) )
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
    if  self.curr_tag1~=self.curr_tag then 
        self.m_time=self.m_time+self.rand_Date["score"]
        self.jia_score=self.rand_Date["score"]
    else
         self.m_time = self.m_time +1
         self.jia_score=1
    end
   self.curr_tag1=self.curr_tag
    self.dishu_score:setProperty(tostring(self.m_time),"png/dadishufenshu.png", 24, 26, "0")  --
end
--增加幸运卡
function HitVolesLayer:add_reward( )
        self.Rewardvouchers = cc.CSLoader:createNode("Rewardvouchers.csb")
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
         if tonumber(goldspool["coolingtime"]) ==  -1 then
               jique:setVisible(false)
               jinyan:setVisible(true)
         else
               -- jique:setVisible(true)
               -- jinyan:setVisible(false)
               NotificationCenter:Instance():PostNotification(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS)  --发送消息  进入奖项详情 
               

         end
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
          local scene=GameScene.new({adid=self.pintuid,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=1})--拼图
          cc.Director:getInstance():replaceScene(scene)
          LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
             
     end

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
end






return   HitVolesLayer