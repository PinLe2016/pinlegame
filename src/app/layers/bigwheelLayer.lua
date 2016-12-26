--
-- Author: peter
-- Date: 2016-10-12 17:19:13

--  大转盘
local bigwheelLayer = class("bigwheelLayer", function()
            return display.newScene("bigwheelLayer")
end)



function bigwheelLayer:pushFloating(text)
    if is_resource then
        self.floating_layer:showFloat(text)  
        
    else
        if self.barrier_bg then 
            self.barrier_bg:setVisible(false)
        end
        self.floating_layer:showFloat(text)
    end
end 

function bigwheelLayer:push_buffer(is_buffer)

       self.floating_layer:show_http(is_buffer) 
       
end 
function bigwheelLayer:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end

function bigwheelLayer:ctor(params)
      self.IF_VOER=false
        print("IF_VOER1 ",self.IF_VOER)
	self:setNodeEventEnabled(true)--layer添加监听     
	self.floating_layer = require("app.layers.FloatingLayer").new()
	self.floating_layer:addTo(self,100000)
	print("--fe-----")
	self.m_turnBg=nil
	self.m_turnArr=nil
	self.m_pBg=nil
	self.m_pElliRtt_1=nil
	self.m_pElliRtt_2=nil
	self.m_pCircle_1=nil
	self.m_pCircle_2=nil
  self.star_over_time=1--记录星星结束时间

	self.fragment_table={ }
      self.Points=params.Points
	self.x_rand=nil
	self._rand=nil
	self.gridNumer=12    --   一共的格子数
	self.gridAngle=360/self.gridNumer   --   每个格子的度数
	self.adid=params.id
      self.choose=params.choose  --  1p拼图   2   打地鼠

	self.count=0
      self.CheckBox_volume=0
      print("广告图",params.image_name)
       local  _rd=tonumber(math.random(1,5))
      local _table=LocalData:Instance():get_setgamerecord()--保存数据
      dump(_table)
          print("哈哈","  ",_rd)
	 if params.image_name then
                self.image_name=params.image_name
      end
      LocalData:Instance():set_user_img(self.image_name)
      self.addetailurl=params.addetailurl

    self.id=params.id
    self.adownerid=params.adownerid  
    self.goldspoolcount=params.goldspoolcount
    -- Server:Instance():getrecentgoldslist(10)
    LocalData:Instance():set_user_oid(self.id)
    self._rewardgold=0
     self.cotion_gold={}
     self._table={
         {gold_b=1,gold_e=10},
         {gold_b=50,gold_e=200},
         {gold_b=1000,gold_e=1000},
         {gold_b=20,gold_e=50},
         {gold_b=15,gold_e=20},
         {gold_b=10,gold_e=15},
         {gold_b=50,gold_e=200},
         {gold_b=10,gold_e=15},
         {gold_b=5,gold_e=10},
         {gold_b=20,gold_e=50},
         {gold_b=500,gold_e=500},
         {gold_b=10,gold_e=15}
     }     
     self._Rtrue =  0  
      if self.choose==1 then  --  拼图
         self:function_puzzle()
      else
        self:function_HitVolesEnd()
      end
        --转盘随机数出现
     
      if tonumber(self.Points) > 250  then
         self:fun_bigrandom()
      elseif tonumber(LocalData:Instance():getpuzzletime())  < 7  then    --  时间小于7秒
           self:fun_bigrandom()

      elseif _rd   ==3  or  _rd   ==2  or  _rd   ==4    then   --60%  概率
           local _table=LocalData:Instance():get_setgamerecord()--保存数据
           dump(_table)
           local goldspool=_table["goldspool"]
            if tonumber(goldspool["coolingtime"]) ==  -1  or   tonumber(goldspool["getcardamount"])== 0 then    
              return
            end
           self:fun_bigrandom()
         
      end
      
end
--   转盘随机数出现
function bigwheelLayer:fun_bigrandom( )
        self._Rtrue=1
        local function stopAction()
                self:function_bigwheel()
       end
      local callfunc = cc.CallFunc:create(stopAction)
     self:runAction(cc.Sequence:create(cc.DelayTime:create(self.star_over_time*0.4),callfunc  ))
end
--打地鼠结束界面self.Points
function bigwheelLayer:function_HitVolesEnd(  )
             self.fragment_sprite1 = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
              self:addChild(self.fragment_sprite1,0)
               self.HitVolesEndLayer = cc.CSLoader:createNode("HitVolesEndLayer.csb")
               self.fragment_sprite1:addChild(self.HitVolesEndLayer)
               local  hit_bg=self.HitVolesEndLayer:getChildByTag(196)
               hit_bg:loadTexture("png/GRzhezhaoceng.png")
         



               local _advertiImg=self.HitVolesEndLayer:getChildByTag(201)  --  上面广告图
               local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
               print("广告图1",path  ..  self.image_name)
                _advertiImg:loadTexture(  self.image_name) 
               _advertiImg:addTouchEventListener(function(sender, eventType  )
                     if eventType ~= ccui.TouchEventType.ended then
                           sender:setScale(1)
                           return
                      end
                          sender:setScale(1.4)
                     self:fun_storebrowser()
               end)
                self:function_httpgold( self.HitVolesEndLayer,_advertiImg:getPositionX(),_advertiImg:getPositionY()-_advertiImg:getContentSize().height/2-80)
               local back=self.HitVolesEndLayer:getChildByTag(776)  --  返回
               back:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)
               local show=self.HitVolesEndLayer:getChildByTag(258)  --  炫耀
               show:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)
               local secondcount=self.HitVolesEndLayer:getChildByTag(256)  --  再来一局
               secondcount:addTouchEventListener(function(sender, eventType  )
                    self:fun_callback(sender, eventType)
               end)

               local labelAtlas=self.HitVolesEndLayer:getChildByTag(255) --分数
               labelAtlas:setVisible(false)
              local  dishu_score = ccui.TextAtlas:create()
              dishu_score:setAnchorPoint(0,0.5)
              dishu_score:setPosition(cc.p(labelAtlas:getPositionX(),labelAtlas:getPositionY()))  
              dishu_score:setProperty( tostring(self.Points),"png/dadishufenshu.png", 24, 26, "0")  --tostring(self.friendlist_num["friendcount"]),
              self.HitVolesEndLayer:addChild(dishu_score) 
              local _gamerecord=LocalData:Instance():get_setgamerecord()--保存数据
              local goldspool=_gamerecord["goldspool"]
              local ranking=self.HitVolesEndLayer:getChildByTag(272)  --  %数
              ranking:setString(goldspool["myscore"])
              self:star_action()
              --self:PintuEndAct(self.HitVolesEndLayer)

end


function bigwheelLayer:star_action()
       -- local layer=cc.LayerColor:create(cc.c4b(0,0,0,165))  
       --         self.HitVolesEndLayer:addChild(layer)
      -- 0-150一星
      -- 150-250二星
      -- 250以上三星
      -- 打地鼠时间
      -- 12秒以上一星
      -- 7秒－12秒二星
      -- 7秒以内三星
       local  xingnumber=0
       if self.choose==1 then
            if tonumber(LocalData:Instance():getpuzzletime()) >= 12  then
              xingnumber=1
            elseif tonumber(LocalData:Instance():getpuzzletime()) >= 0  and  tonumber(LocalData:Instance():getpuzzletime())<7 then
              xingnumber=3
            elseif tonumber(LocalData:Instance():getpuzzletime()) >= 7  and  tonumber(LocalData:Instance():getpuzzletime())<12 then
              xingnumber=2
             end       
      else
         if tonumber(self.Points) > 250  then
          xingnumber=3
        elseif tonumber(self.Points) >= 0  and  tonumber(self.Points)<=150 then
          xingnumber=1
        elseif tonumber(self.Points) > 150  and  tonumber(self.Points)<=250 then
          xingnumber=2
         end
      end

      self.star_over_time=xingnumber

              local point_buf={
                cc.p(186.50,1000),
                cc.p(320,1050),
                cc.p(459.50,1000)
              }

              local star_buf={}
            
              for i=1,xingnumber do
                local spr=display.newSprite("dadishu-wanfajieshao-xinxin.png")
                spr:setPosition(point_buf[i].x,point_buf[i].y-400)
                spr:setScale(10)
                spr:setVisible(false)
                self:addChild(spr)
                star_buf[i]=spr
                if i==1 then
                  spr:setRotation(45)
                elseif i==3 then
                  spr:setRotation(-45)
                end
                
              end

              local dex,time=1,0.4

              local function logSprRotation(sender)

                    local particle = cc.ParticleSystemQuad:create("starAni6.plist")
                     audio.playMusic("sound/effect/jieshu.mp3",false)
                    -- particle:setDuration(-1)
                    particle:setPosition(point_buf[dex])
                    self:addChild(particle)
                    dex=dex+1
                    if dex>#star_buf then return end
                      local scal =cc.ScaleTo:create(time,1)
                      local move=cc.MoveTo:create(time, point_buf[dex])
                      local action = cc.Sequence:create(cc.Spawn:create(scal,move),cc.CallFunc:create(logSprRotation))
                      star_buf[dex]:setVisible(true)
                      star_buf[dex]:runAction(action) 
              end
                
              local function logSprRotation1(sender)
                       if self._Rtrue==1 then
                         return
                       end
                       local particle2 = cc.ParticleSystemQuad:create("endingCoin2.plist")
                       particle2:setPosition(cc.p(display.cx,display.cy))
                       self:addChild(particle2)
                       audio.playMusic("sound/effect/jinbidiaoluo.mp3",false)

            end

            if conditions then
              --todo
            end
              
              local scal =cc.ScaleTo:create(time,1)
              local move=cc.MoveTo:create(time, point_buf[dex])
              local action = cc.Sequence:create(cc.Spawn:create(scal,move),cc.CallFunc:create(logSprRotation),cc.DelayTime:create(0.50),cc.CallFunc:create(logSprRotation1))
              -- self.HitVolesEndLayer:addChild(star_buf[dex])
              star_buf[dex]:setVisible(true)
              star_buf[dex]:runAction(action)           
                 
end


-- 拼图结束界面
function bigwheelLayer:function_puzzle(  )
              self.puzzleEndLayer = cc.CSLoader:createNode("puzzleEndLayer.csb")
              self:addChild(self.puzzleEndLayer)
              local time=self.puzzleEndLayer:getChildByTag(513)  --  时间
              time:setString(tostring(LocalData:Instance():getpuzzletime()) ..   "   秒")
              local count=self.puzzleEndLayer:getChildByTag(512)  --  步数
              count:setString(tostring(LocalData:Instance():getTheycount()))

              local _advertiImg=self.puzzleEndLayer:getChildByTag(356)  --  上面广告图
              local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
              _advertiImg:loadTexture(  self.image_name) 
              _advertiImg:addTouchEventListener(function(sender, eventType  )
                      if eventType ~= ccui.TouchEventType.ended then
                           sender:setScale(1)
                           return
                      end
                          sender:setScale(1.3)
                          self:fun_storebrowser()
             end)
              self:function_httpgold( self.puzzleEndLayer,_advertiImg:getPositionX(),_advertiImg:getPositionY()-_advertiImg:getContentSize().height/2-80)
            local back=self.puzzleEndLayer:getChildByTag(305)  --  返回
             back:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)
             local show=self.puzzleEndLayer:getChildByTag(756)  --  炫耀
             show:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)
             local secondcount=self.puzzleEndLayer:getChildByTag(755)  --  再来一局
             secondcount:addTouchEventListener(function(sender, eventType  )
                  self:fun_callback(sender, eventType)
             end)
             self:star_action()
             --self:PintuEndAct(self.puzzleEndLayer)

end
function bigwheelLayer:PintuEndAct(_obj)
           local node1 = cc.Sprite:create("png/youxizhong-1-tu.png")
           local _h=display.cy+180
           node1:setPosition(cc.p(-100,_h))
           _obj:addChild(node1)
           local speed=250
           local juli=node1:getContentSize().width
          --   local function stopAction()
          --     self:run_blades()
          -- end     
          --local callfunc = cc.CallFunc:create(stopAction)
          local pAction =cc.RotateBy:create(display.cx/speed,360*5)
          local ptAction = cc.MoveTo:create(display.cx/speed, cc.p(display.cx-juli/2-5, _h))
          node1:runAction(cc.Spawn:create(pAction,ptAction)) 

            local node2 = cc.Sprite:create("png/youxizhong-1-pin.png")
           node2:setPosition(cc.p(-100,_h))
           _obj:addChild(node2)

        --     local function stopAction()
        --       self:run_blades()
        -- end     
        --local callfunc = cc.CallFunc:create(stopAction)
        local pAction2 =cc.RotateBy:create(display.cx/speed,360*5)
        local ptAction2 = cc.MoveTo:create(display.cx/speed, cc.p(display.cx-juli*3/2-15, _h))
        node2:runAction(cc.Spawn:create(pAction2,ptAction2)) 

            local node3 = cc.Sprite:create("png/youxizhong-1-cheng.png")
           node3:setPosition(cc.p(display.cx *2  +100,_h))
           _obj:addChild(node3)

        --     local function stopAction()
        --       self:run_blades()
        -- end     
        -- local callfunc = cc.CallFunc:create(stopAction)
        local pAction3 =cc.RotateBy:create(display.cx/speed,360*5)
        local ptAction3 =cc.MoveTo:create(display.cx/speed, cc.p(display.cx+5+juli/2, _h))
        node3:runAction(cc.Spawn:create(pAction3,ptAction3)) 


            local node4 = cc.Sprite:create("png/youxizhong-1-gong.png")
           node4:setPosition(cc.p(display.cx *2  +100,_h))
           _obj:addChild(node4)

        --     local function stopAction()
        --       self:run_blades()
        -- end     
        -- local callfunc = cc.CallFunc:create(stopAction)
        local pAction4 =cc.RotateBy:create(display.cx/speed,360*5)
        local ptAction4 =cc.MoveTo:create(display.cx/speed, cc.p(display.cx+juli*3/2+15, _h))
        node4:runAction(cc.Spawn:create(pAction4,ptAction4)) 


end
--  结束界面返回按钮
function bigwheelLayer:fun_callback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                 sender:setScale(0.8)
                 return
            end
                sender:setScale(1)
            local tag=sender:getTag()
            if tag==201 then
               self:fun_storebrowser()
            elseif tag==356 then 
               self:fun_storebrowser()
            elseif tag==776 then 
               Util:scene_control("GoldprizeScene")
            elseif tag==258 then 
               print("炫耀")
               self.share=Util:share(1)
            elseif tag==256 then 
               -- GameScene = require("app.scenes.GameScene")--惊喜吧
               --  local scene=GameScene.new({adid= self.id,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose,Issecond=1})--拼图
               --  cc.Director:getInstance():replaceScene(scene)
               --  LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
                self:try_again()
            elseif tag==305 then 
               Util:scene_control("GoldprizeScene")
            elseif tag==756 then 
               print("炫耀")
               self.share=Util:share(1)
            elseif tag==755 then 
                local  _Issecond=0
                local getgoldspoolbyid  = LocalData:Instance():get_getgoldspoolbyid()--获得玩了几次数据
                if tonumber(getgoldspoolbyid["getcardamount"]) == 1 then
                  _Issecond=1
                end
                GameScene = require("app.scenes.GameScene")--惊喜吧
                local scene=GameScene.new({adid= self.id,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose,Issecond=_Issecond})--拼图
                cc.Director:getInstance():replaceScene(scene)
                LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
            end
end
--  大转盘界面
function bigwheelLayer:function_bigwheel( )
            self.bigwheelLayer = cc.CSLoader:createNode("bigwheelLayer.csb")
            self:addChild(self.bigwheelLayer)
            self.roleAction = cc.CSLoader:createTimeline("bigwheelLayer.csb")
            self.bigwheelLayer:runAction(self.roleAction)
            -- self.roleAction:setTimeSpeed(2)
            -- self.roleAction:gotoFrameAndPlay(0,60, true)  
            local  hit=self.bigwheelLayer:getChildByTag(41)  --  打地鼠
            local  deb=self.bigwheelLayer:getChildByTag(177)  --  拼图
            local  arrow=self.bigwheelLayer:getChildByTag(551)  --  拼图
            if self.choose==1 then  --  拼图
               deb:setVisible(true)
               arrow:setVisible(true)
               m_turnBg = self.bigwheelLayer:getChildByTag(177) --zhuanpan
               local  dipan =self.bigwheelLayer:getChildByTag(550)
               dipan:setVisible(true)
                       --风叶
            self._blades=self.bigwheelLayer:getChildByTag(177):getChildByTag(181)
            -- 灯
            self._lamp=self.bigwheelLayer:getChildByTag(177):getChildByTag(182)  
            -- self._Xscnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
            --                     if   self._Xscnum then
            --                          self:run_callback()
            --                     end 
            --   end,0.3, false)

            else
              deb:setVisible(false)
              m_turnBg = self.bigwheelLayer:getChildByTag(41) 
                      --风叶
            self._blades=self.bigwheelLayer:getChildByTag(41):getChildByTag(48)

            -- 灯
            self._lamp=self.bigwheelLayer:getChildByTag(41):getChildByTag(43)  
            -- self._Xscnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
            --                     if   self._Xscnum then
            --                          self:run_callback()
            --                     end 
            --   end,0.3, false)
            local fadein=cc.FadeIn:create(0.8)
            local fadeout=cc.FadeOut:create(0.8)
            
            self._lamp:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeout,fadein)))

            end
            self._Instead=self.bigwheelLayer:getChildByTag(99)
            self._Instead:setVisible(false)
                 --选中
            self._selected=self.bigwheelLayer:getChildByTag(46)
            self._selected:setVisible(false)

            self._prize=self.bigwheelLayer:getChildByTag(1303)
            self._prize:setVisible(false)
            self._prizetext=self._prize:getChildByTag(1307)
            self._prizebt=self._prize:getChildByTag(1311)
            self._prizebt:addTouchEventListener(function(sender, eventType  )
                  self:touch_callback(sender, eventType)
            end)
            
             -- local particle = cc.ParticleSystemQuad:create("big_3.plist")
             -- particle:setPosition(100, 100)
             --  m_turnBg:addChild(particle)

              --  local particle1 = cc.ParticleSystemQuad:create("big_1.plist")
              --  particle1:setPosition(50, 150)
              -- m_turnBg:addChild(particle1)
              --  local particle2 = cc.ParticleSystemQuad:create("big_2.plist")
              --  particle2:setPosition(50, 50)
              -- m_turnBg:addChild(particle2)

            -- m_turnBg
             
         self:run_blades()
         self:init(  )

end
--风叶旋转动画 
function bigwheelLayer:run_blades(  )
        local function stopAction()
              self:run_blades()
        end     
        local callfunc = cc.CallFunc:create(stopAction)
        self.pAction =cc.RotateBy:create(0.1,30)
        self.pAction1 = cc.DelayTime:create(0.07)
        self._blades:runAction(cc.Sequence:create(self.pAction,self.pAction1,callfunc)) 
end
function bigwheelLayer:run_callback(dt)
		self.count=self.count+1
		
		if self.count%2==0 then
			self._lamp:setVisible(false)            
		else
			self._lamp:setVisible(true)
		end
           
end
function bigwheelLayer:init(  )
        
	    local  bgSize = cc.Director:getInstance():getWinSize()
	    
	    m_pBg = cc.Sprite:create();
	    m_pBg:setPosition(cc.p(bgSize.width / 2,bgSize.height / 2));
	    self:addChild(m_pBg);
	    
	
	    --添加转盘
	    
          self.caideng = self.bigwheelLayer:getChildByTag(33)
          self.caideng:setVisible(false)

           local  list_table=LocalData:Instance():get_getgoldspoolbyid()
          self.volume_num = self.bigwheelLayer:getChildByTag(36)  --  翻倍卡
          self.volume_num:setString(list_table["doublecardamount"] )

          self.CheckBox = self.bigwheelLayer:getChildByTag(34)  --  卷
          self.CheckBox:addEventListener(function(sender, eventType  )
               if eventType == ccui.CheckBoxEventType.selected then
                     
               elseif eventType == ccui.CheckBoxEventType.unselected then
                       
                       if tonumber(self.volume_num:getString()) <=0 then
                            self.CheckBox:setSelected(true)
                            Server:Instance():prompt("您的幸运卡数量不够,通过邀请好友和签到可以快速获得呦~") 
                       end
               end
            end)


	    self.m_turnArr = self.bigwheelLayer:getChildByTag(44)
	    self.m_turnArr:addTouchEventListener(function(sender, eventType  )
	          self:touch_callback(sender, eventType)
	      end)
	     local  _back = self.bigwheelLayer:getChildByTag(130)  --  返回
	     _back:addTouchEventListener(function(sender, eventType  )
	          self:touch_callback(sender, eventType)
	      end)
       _back:setVisible(false)
	     -- local _advertiImg=self.bigwheelLayer:getChildByTag(128)  --  上面广告图
	     --  _advertiImg:loadTexture( self.image_name) 
      --    _advertiImg:addTouchEventListener(function(sender, eventType  )
      --               if eventType ~= ccui.TouchEventType.ended then
      --                     return
      --               end
      --               self:fun_storebrowser()
      --             end)

       -- local  list_table=LocalData:Instance():get_getgoldspoolbyid()
        local _title=self.bigwheelLayer:getChildByTag(133)  --  上面广告图
        _title:setString(tostring(list_table["title"]))

	     local  list_table=LocalData:Instance():get_getgoldspoollistbale()
                 local  jaclayer_data=list_table["adlist"]
	     -- local connection12=self.bigwheelLayer:getChildByTag(39):getChildByTag(129)   --连接
	     --   self.connection13=connection12
	     --  connection12:addTouchEventListener(function(sender, eventType  )
	     --              if eventType ~= ccui.TouchEventType.ended then
	     --                    return
	     --              end
	     --              self:fun_storebrowser()
      --             end)
	     -- local connection_gold=self.bigwheelLayer:getChildByTag(39):getChildByTag(129):getChildByTag(131)--  显示金币数
	     -- if jaclayer_data[1]["adurlgold"] then
	     --      connection_gold:setString("+" ..  tostring(jaclayer_data[1]["adurlgold"]))
	     -- else
	     --    connection12:setVisible(false)
	     --    connection_gold:setString("+0")
	     --  end
      --      if tostring(self.addetailurl)   ==   tostring(1) then
      --         connection12:setVisible(false)
      --      end

end


function bigwheelLayer:fun_began_start(  )

        self.caideng:setVisible(true)
        self.CheckBox:setTouchEnabled(false)
        self._blades:setVisible(true)
        self._selected:setVisible(false)
        self._Instead:setVisible(false)  --测试
        self.m_turnArr:setEnabled(false);


        local function CallFucnCallback3(sender)
                if self.x_rand~=0 then
                  
                  self:fun_began()
                end

        end

        local  pAction1 =cc.RotateTo:create(0.3,360)
        m_turnBg:runAction(cc.RepeatForever:create(cc.Sequence:create(pAction1,cc.CallFunc:create(CallFucnCallback3))))

end
function bigwheelLayer:fun_began(  )
        
        m_turnBg:stopAllActions()
        local function CallFucnCallback3(sender)
              self.caideng:setVisible(false)
               --self.m_turnArr:setEnabled(true);
               self._blades:setVisible(false)
               self._selected:setVisible(true)
               --self.bigwheelLayer:getChildByTag(130):setVisible(true)
               self._Instead:setVisible(false)
               self.CheckBox:setTouchEnabled(true)
               self._prize:setVisible(false)
               self:big_end(true,self.m_turnArr:getPositionX(),self.volume_num:getPositionY()-150,self.bigwheelLayer )
               self:fun_bigback(self.bigwheelLayer,m_turnBg:getPositionX()+m_turnBg:getContentSize().width/7*3*1.02,m_turnBg:getPositionY()+m_turnBg:getContentSize().height/7*3*1.02)
               

             --     local function stopAction()
             --            if self.bigwheelLayer then
             --             self.bigwheelLayer:removeFromParent()
             --           end
             --   end
             --  local callfunc = cc.CallFunc:create(stopAction)
             -- self:runAction(cc.Sequence:create(cc.DelayTime:create(2),callfunc  ))



        end
        self.caideng:setVisible(true)
        self.CheckBox:setTouchEnabled(false)
        self._blades:setVisible(true)
        self._selected:setVisible(false)
        self._Instead:setVisible(false)  --测试
        --m_turnBg:setVisible(false)  --测试
        -- self.x_rand=math.random(1,self.gridNumer)  --测试
        --防止多次点击
        self.m_turnArr:setEnabled(false);

	     table.insert(self.fragment_table,{_shuzi = self.x_rand})
	    local   _int = #self.fragment_table  
	    
	    if (_int>1)   then 
		        local  xin = self.fragment_table[_int-1]._shuzi
		        if (self.x_rand > xin)   then 
		            self.x_rand = self.x_rand - xin;
		        else
		            self.x_rand = self.gridNumer+  (self.x_rand - xin);
		        end
	    end
	    self._rand= (self.x_rand  *  self.gridAngle   ) ;
	    local  angleZ = self._rand + 1080--720;  
          local  pAction1 = cc.EaseExponentialOut:create(cc.RotateBy:create(8,1080+angleZ))
	    m_turnBg:runAction(cc.Sequence:create(pAction1,cc.CallFunc:create(CallFucnCallback3)))
        -- local  pAction2 = cc.RotateBy:create(3,self._rand)  --测试
        -- self._Instead:runAction(pAction2)

         


end
function bigwheelLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
      if tag==1311 then
          self._prize:setVisible(false)
      end
	if tag==44 then --开始
    print("IF_VOERkaisi ",self.IF_VOER)
      if tostring(self.IF_VOER)  ==  "true"  then
        self:try_again()
        return 
      end
      self.IF_VOER=true

      print("IF_VOERoooo",self.IF_VOER)
         if self.CheckBox:isSelected() then   --选中是关  
             self.CheckBox_volume=0
        else
            self.CheckBox_volume=1
            self.volume_num:setString(tostring(self.volume_num:getString()-1))
         end
         if tonumber(self.Points)==0 then
           self.Points=1
         end
      self:fun_began_start(  )
	     Server:Instance():getgoldspoolrandomgolds(self.adid,self.CheckBox_volume,self.Points)  --  转盘随机数

        local _table=LocalData:Instance():get_gettasklist()
        local tasklist=_table["tasklist"]
         for i=1,#tasklist  do 
               if  tonumber(tasklist[i]["targettype"])   ==  4   then
                    LocalData:Instance():set_tasktable(tasklist[i]["targetid"])
               end
         end


        if LocalData:Instance():get_tasktable() then
             Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
	     end
	      LocalData:Instance():set_tasktable(nil)--制空        
    elseif tag==130 then
    		Util:scene_control("GoldprizeScene")
    	 	if self._Xscnum then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._Xscnum)
    		end
	end
end

--再来一局提示
function bigwheelLayer:try_again()
    -- self.floating_layer:showFloat("再来一局？",function (sender, eventType)
    --                               if eventType==1 then

                                          self.IF_VOER=false
                                          local _tablegods=LocalData:Instance():get_getgoldspoolrandomgolds()
                                          -- dump(_tablegods)
                                          dump(_tablegods["getcardamount"])
                                          if  tonumber(_tablegods["getcardamount"])== 0 then

                                              LocalData:Instance():set_user_pintu("1")
                                              self.floating_layer:showFloat("今日获得金币机会已经用完啦,继续只能获得积分",function (sender, eventType)
                                                if eventType==1 then
                                                       GameScene = require("app.scenes.GameScene")--惊喜吧
                                                      local scene=GameScene.new({adid= self.id,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose,Issecond=1})--拼图
                                                      cc.Director:getInstance():replaceScene(scene)
                                                      LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
                                                      return
                                                end
                                                self.IF_VOER=true
                                              end)  
                                              self.floating_layer:showFloat("今日获得金币机会已经用完啦,继续拼图只能获得积分") 

                                              return

                                          end
                                          local  _Issecond=0
                                          if tonumber(_tablegods["getcardamount"]) == 1 then
                                            _Issecond=1
                                          end

                                          GameScene = require("app.scenes.GameScene")--惊喜吧
                                          local scene=GameScene.new({adid= self.id,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=self.choose,Issecond=_Issecond})--拼图
                                          cc.Director:getInstance():replaceScene(scene)
                                          LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
                                          self.end_bt:setVisible(true)
                                  --end

                            -- end)
end

--  网页链接
function bigwheelLayer:fun_storebrowser(  )
  print("网页链接",self.addetailurl)
      if tostring(self.addetailurl)   ==   tostring(1)   or  tostring(self.addetailurl) == ""  then
         return
      end
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
      local  list_table=LocalData:Instance():get_getgoldspoollistbale()
      local  jaclayer_data=list_table["adlist"]
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                  end
                  if self.Storebrowser then
                        self.Storebrowser:removeFromParent()
                        if self._rewardgold==1  and   jaclayer_data[1]["adurlgold"] then
                           self:goldact()
                        end
                    
                  end
            end)

              local webview = cc.WebView:create()
              self.Storebrowser:addChild(webview)
              webview:setVisible(true)
              webview:setScalesPageToFit(true)
              webview:loadURL(tostring(self.addetailurl))
              webview:setContentSize(cc.size(store_size:getContentSize().width   ,store_size:getContentSize().height  )) -- 一定要设置大小才能显示
              webview:reload()
              webview:setPosition(cc.p(store_size:getPositionX(),store_size:getPositionY())) 
              if self._rewardgold==0 then
                         Server:Instance():setgoldspooladurlreward(jaclayer_data[1]["adid"])--  奖励金币
                        if self.connection13   and    jaclayer_data[1]["adurlgold"]  then
                              self.connection13:setVisible(false)
                        end
                else
                         self.connection13:setVisible(false)
              end
              self._rewardgold=self._rewardgold+1

end
function bigwheelLayer:goldact(  )
            
            self._laohujigoldact = cc.CSLoader:createNode("laohujigoldact.csb")
            self:addChild(self._laohujigoldact)
            local laohujigoldaction = cc.CSLoader:createTimeline("laohujigoldact.csb")
            self._laohujigoldact:runAction(laohujigoldaction)
            laohujigoldaction:setTimeSpeed(0.5)
            laohujigoldaction:gotoFrameAndPlay(0,50, false)



            local function stopAction()
                 if self._laohujigoldact then
                    self._laohujigoldact:removeFromParent()
                 end
           end
          local callfunc = cc.CallFunc:create(stopAction)
         self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),callfunc  ))

end

  function bigwheelLayer:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	      self.secondOne=0
                  self.time=1+self.time
           
  end
  -- 具体获得金币数
function bigwheelLayer:big_end(_istrue,x,y,_obj )
      local _gold=LocalData:Instance():get_getgoldspoolrandomgolds()
      self.fragment_sprite_bg = display.newSprite("png/zhuanpan-gongxihuode-jingbi-guang.png")
      self.fragment_sprite_bg:setPosition(cc.p(x,y))
      self.fragment_sprite_bg:setVisible(_istrue)
      _obj:addChild(self.fragment_sprite_bg)
      local fragment_sprite1 = display.newSprite("png/zhuanpan-gongxihuode-zi.png")
      self.fragment_sprite_bg:addChild(fragment_sprite1)
       fragment_sprite1:setPosition(cc.p(self.fragment_sprite_bg:getContentSize().width/2, self.fragment_sprite_bg:getContentSize().height   ))
      local fragment_sprite2 = display.newSprite("png/zhuanpan-gongxihuode-jingbi.png")
      self.fragment_sprite_bg:addChild(fragment_sprite2)
      fragment_sprite2:setPosition(cc.p(self.fragment_sprite_bg:getContentSize().width/2, self.fragment_sprite_bg:getContentSize().height/2 ))
      

      self.fragment_sprite_bg1 = display.newSprite("png/zhuanpan-gongxihuode-jingbi-1.png")
      self.fragment_sprite_bg1:setPosition(cc.p(self.fragment_sprite_bg:getContentSize().width/2, self.fragment_sprite_bg:getContentSize().height/2*0.4))
      self.fragment_sprite_bg:addChild(self.fragment_sprite_bg1)

       local alert = ccui.Text:create("RichText", "png/chuti.ttf", 30)
      alert:setString(tostring(_gold["golds"]))  --  获得金币
      alert:setPosition(cc.p(self.fragment_sprite_bg:getContentSize().width/2, self.fragment_sprite_bg:getContentSize().height/2*0.4))
      self.fragment_sprite_bg:addChild(alert)

end
function bigwheelLayer:fun_bigback( _obj,x,y )
        local textButton = ccui.Button:create()
      self.connection13=textButton
      textButton:setTouchEnabled(true)--
      textButton:loadTextures("png/dadishu-choujiang-1-1-guanbi-liang.png", "png/dadishu-choujiang-1-1-guanbi.png", "")
      textButton:setPosition(cc.p(x,y))
      textButton:addTouchEventListener(function(sender, eventType)
                    
                    if eventType == ccui.TouchEventType.ended then
                          _obj:removeFromParent()
                          if self._Xscnum then
                                  cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._Xscnum)
                          end

                          if self._Rtrue==1 then
                                  local particle2 = cc.ParticleSystemQuad:create("endingCoin2.plist")
                                 particle2:setPosition(cc.p(display.cx,display.cy))
                                 self:addChild(particle2)
                                 audio.playMusic("sound/effect/jinbidiaoluo.mp3",false)
                          end
                    end
            end)
      _obj:addChild(textButton)
end
--网页链接获得金币
function bigwheelLayer:function_httpgold( _obj,x,y )
      local textButton = ccui.Button:create()
      self.connection13=textButton
      textButton:setTouchEnabled(true)--
      textButton:loadTextures("png/shunliwancheng_13.png", "png/shunliwancheng_13.png", "")
      textButton:setPosition(cc.p(x,y))
      textButton:addTouchEventListener(function(sender, eventType)
                    if eventType ~= ccui.TouchEventType.ended then
                        sender:setScale(0.8)
                    elseif eventType == ccui.TouchEventType.ended then
                      sender:setScale(1)
                      self:fun_storebrowser()
                    end
            end)
      _obj:addChild(textButton)
      local jinbi_image = display.newSprite("png/Gjinbi.png")
      jinbi_image:setScale(0.6)
     jinbi_image:setPosition(cc.p(textButton:getContentSize().width/4, textButton:getContentSize().height /2*1.1  ))
     textButton:addChild(jinbi_image)
       local alert = ccui.Text:create("RichText", "png/chuti.ttf", 30)
       alert:setAnchorPoint(0,0.5)
      alert:setString("+20")  --  获得金币
      alert:setPosition(cc.p(textButton:getContentSize().width*0.45, textButton:getContentSize().height/2*1.1))
      textButton:addChild(alert)

        local  list_table=LocalData:Instance():get_getgoldspoollistbale()
        local  jaclayer_data=list_table["adlist"] 
         if jaclayer_data[1]["adurlgold"] then
            alert:setString("+" ..  tostring(jaclayer_data[1]["adurlgold"]))
       else
          textButton:setVisible(false)
          alert:setString("+0")
        end
           if tostring(self.addetailurl)   ==   tostring(1) then
              textButton:setVisible(false)
           end




end

function bigwheelLayer:onEnter()
   self.x_rand=0
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self,
                       function()
                       	local _gold=LocalData:Instance():get_getgoldspoolrandomgolds()
                               for i=1,#self._table do
                               	if _gold["golds"]>=self._table[i]["gold_b"] and _gold["golds"]<=self._table[i]["gold_e"] then
                               		table.insert(self.cotion_gold,i)
                               	end
                               end
                               self.x_rand=self.cotion_gold[math.random(1,#self.cotion_gold)]
                               Server:Instance():getgoldspoolbyid(LocalData:Instance():get_user_oid())
                               -- self:fun_began()
                              self._prizetext:setString(tostring(_gold["golds"]))
                      end)
  
end

function bigwheelLayer:onExit()
  
     NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self)
     
end


return bigwheelLayer




