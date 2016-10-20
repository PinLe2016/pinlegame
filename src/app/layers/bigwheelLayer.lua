--
-- Author: peter
-- Date: 2016-10-12 17:19:13

--  大转盘
local bigwheelLayer = class("bigwheelLayer", function()
            return display.newScene("bigwheelLayer")
end)

local IF_VOER=false

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
	self:setNodeEventEnabled(true)--layer添加监听     
	self.floating_layer = FloatingLayerEx.new()
	self.floating_layer:addTo(self,100000)
	print("--fe-----")
	self.m_turnBg=nil
	self.m_turnArr=nil
	self.m_pBg=nil
	self.m_pElliRtt_1=nil
	self.m_pElliRtt_2=nil
	self.m_pCircle_1=nil
	self.m_pCircle_2=nil
	self.fragment_table={ }
	self.x_rand=nil
	self._rand=nil
	self.gridNumer=12    --   一共的格子数
	self.gridAngle=360/self.gridNumer   --   每个格子的度数
	self.adid=params.id
	self.count=0

	 if params.image_name then
                self.image_name=params.image_name
             end

    self.id=params.id
    self.adownerid=params.adownerid  
    self.goldspoolcount=params.goldspoolcount
    -- Server:Instance():getrecentgoldslist(10)
    LocalData:Instance():set_user_oid(self.id)


	self.bigwheelLayer = cc.CSLoader:createNode("bigwheelLayer.csb")
            self:addChild(self.bigwheelLayer)
            self.roleAction = cc.CSLoader:createTimeline("bigwheelLayer.csb")
            self.bigwheelLayer:runAction(self.roleAction)
            self.roleAction:setTimeSpeed(7)
            self.roleAction:gotoFrameAndPlay(0,120, true)
           
          	--风叶
          	self._blades=self.bigwheelLayer:getChildByTag(41):getChildByTag(48)
          	--选中
          	self._selected=self.bigwheelLayer:getChildByTag(46)

            -- 灯
            self._lamp=self.bigwheelLayer:getChildByTag(41):getChildByTag(43)  
            self._Xscnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                if   self._Xscnum then
                                   self:run_callback()
                                end
                                
              end,0.5, false)


             self._rewardgold=0

             self.cotion_gold={}
             self._table={
             {gold_b=5,gold_e=10},
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

	self:init(  )

       
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
        

        	 local function menuCallback()

		     self.x_rand=math.random(1,self.gridNumer)
		     print("随机是几  ", self.x_rand)
		     table.insert(self.fragment_table,{_shuzi = self.x_rand})
		    -- kk.push_back(x_rand);
		    local   _int = #self.fragment_table  --kk.size();
		    --print("需要几  ",self.x_rand,"   ",#self.fragment_table);
		    --防止多次点击
		    self.m_turnArr:setEnabled(false);
		    if (_int>1)   then 
			        local  xin = self.fragment_table[_int-1]._shuzi--kk.at(_int-2);
			        --print("ziyun  ","   ",self.x_rand  ,  "   ",xin);
			        if (self.x_rand > xin)   then 
			            self.x_rand = self.x_rand - xin;
			        else
			            self.x_rand = self.gridNumer+  (self.x_rand - xin);
			        end
		    end
		    --print("需要几111   ",self.x_rand);
		    self._rand= (self.x_rand  *  self.gridAngle   ) ;-- +rand() % 60;
		    local  angleZ = self._rand + 720;  --// +
		    local  pAction = cc.EaseExponentialOut:create(cc.RotateBy:create(4,angleZ));
		    m_turnBg:runAction(cc.Sequence:create(pAction))--,cc.CallFunc::create(CC_CALLBACK_0(LotteryTurnTest::onTurnEnd,this)),NULL));
			 
             end



	    local  bgSize = cc.Director:getInstance():getWinSize()
	    
	    m_pBg = cc.Sprite:create();
	    m_pBg:setPosition(cc.p(bgSize.width / 2,bgSize.height / 2));
	    self:addChild(m_pBg);
	    
	
	    --添加转盘
	    m_turnBg = self.bigwheelLayer:getChildByTag(41) --cc.Sprite:create("LotteryTurn/turn_bg.png");
	    self.m_turnArr = self.bigwheelLayer:getChildByTag(44)
	    self.m_turnArr:addTouchEventListener(function(sender, eventType  )
	          self:touch_callback(sender, eventType)
	      end)
	     local  _back = self.bigwheelLayer:getChildByTag(130)  --  返回
	     _back:addTouchEventListener(function(sender, eventType  )
	          self:touch_callback(sender, eventType)
	      end)
       _back:setVisible(false)
	     local _advertiImg=self.bigwheelLayer:getChildByTag(128)  --  上面广告图
	      _advertiImg:loadTexture( self.image_name) 
        local  list_table=LocalData:Instance():get_getgoldspoolbyid()
        local _title=self.bigwheelLayer:getChildByTag(133)  --  上面广告图
        _title:setString(tostring(list_table["title"]))

	     local  list_table=LocalData:Instance():get_getgoldspoollistbale()
                 local  jaclayer_data=list_table["adlist"]
	     local connection12=self.bigwheelLayer:getChildByTag(39):getChildByTag(129)   --连接
	       self.connection13=connection12
	      connection12:addTouchEventListener(function(sender, eventType  )
	                  if eventType ~= ccui.TouchEventType.ended then
	                        return
	                  end
	                  self:fun_storebrowser()
                  end)
	     local connection_gold=self.bigwheelLayer:getChildByTag(39):getChildByTag(129):getChildByTag(131)--  显示金币数
	     if jaclayer_data[1]["adurlgold"] then
	          connection_gold:setString("+" ..  tostring(jaclayer_data[1]["adurlgold"]))
	     else
	        connection12:setVisible(false)
	        connection_gold:setString("+0")
	      end

	    --添加中奖之后的简单界面
	    local  awardLayer = cc.LayerColor:create(cc.c4b(0,0,0,100), 0,0)
	    awardLayer:setTag(100);
	    m_pBg:addChild(awardLayer,10);
	    awardLayer:setVisible(false);

end
function bigwheelLayer:fun_began(  )
	  local function CallFucnCallback3(sender)
                       self.m_turnArr:setEnabled(true);
                       self._blades:setVisible(false)
                       self._selected:setVisible(true)
                       self.bigwheelLayer:getChildByTag(130):setVisible(true)

               end
               --self.roleAction:gotoFrameAndPlay(0,120, true)  --   风页转动
               self._blades:setVisible(true)
               self._selected:setVisible(false)
	 -- self.x_rand=math.random(1,self.gridNumer)
	    
	     table.insert(self.fragment_table,{_shuzi = self.x_rand})
	    -- kk.push_back(x_rand);
	    local   _int = #self.fragment_table  --kk.size();
	    --print("需要几  ",self.x_rand,"   ",#self.fragment_table);
	    --防止多次点击
	    self.m_turnArr:setEnabled(false);
	    if (_int>1)   then 
		        local  xin = self.fragment_table[_int-1]._shuzi--kk.at(_int-2);
		        --print("ziyun  ","   ",self.x_rand  ,  "   ",xin);
		        if (self.x_rand > xin)   then 
		            self.x_rand = self.x_rand - xin;
		        else
		            self.x_rand = self.gridNumer+  (self.x_rand - xin);
		        end
	    end
	    --print("需要几111   ",self.x_rand);
	    self._rand= (self.x_rand  *  self.gridAngle   ) ;-- +rand() % 60;
	    local  angleZ = self._rand + 720;  --// +
	    local  pAction = cc.EaseExponentialOut:create(cc.RotateBy:create(4,angleZ));
	    m_turnBg:runAction(cc.Sequence:create(pAction,cc.CallFunc:create(CallFucnCallback3)))
end
function bigwheelLayer:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==44 then --开始
      if IF_VOER then
        self:try_again()
        return 
      end
      IF_VOER=true
	   Server:Instance():getgoldspoolrandomgolds(self.adid,0)  --  转盘随机数
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
    self.floating_layer:showFloat("再来一局？",function (sender, eventType)
                                  if eventType==1 then


                                          local _tablegods=LocalData:Instance():get_getgoldspoolrandomgolds()
                                          dump(_tablegods)
                                          if  tonumber(_tablegods["getcardamount"] )== 0 then
                                              LocalData:Instance():set_user_pintu("1")
                                              self.floating_layer:show_http("今日获得金币机会已经用完啦,继续拼图只能获得积分") 

                                              return

                                          end

                                          GameScene = require("app.scenes.GameScene")--惊喜吧
                                          local scene=GameScene.new({adid= self.id,type="audition",image="",adownerid=self.adownerid,goldspoolcount=self.goldspoolcount,choose=1})--拼图
                                          cc.Director:getInstance():pushScene(scene)
                                          LocalData:Instance():set_actid({act_id=self._dtid,image=" "})--保存数
                                          -- self.end_bt:setVisible(true)
                                  end
                            end)
end

--  网页链接
function bigwheelLayer:fun_storebrowser(  )
      if tostring(self.addetailurl)   ==   tostring(1)   then
        return
      end
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end
              if self.Storebrowser then
                self.Storebrowser:removeFromParent()
                if self._rewardgold==1 then
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
                 local  list_table=LocalData:Instance():get_getgoldspoollistbale()
                 local  jaclayer_data=list_table["adlist"]
                Server:Instance():setgoldspooladurlreward(jaclayer_data[1]["adid"])--  奖励金币
                if self.connection13  then
                 self.connection13:setVisible(false)
                end
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


function bigwheelLayer:onEnter()
   self.x_rand=7
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self,
                       function()
                       	local _gold=LocalData:Instance():get_getgoldspoolrandomgolds()
                               for i=1,#self._table do
                               	if _gold["golds"]>=self._table[i]["gold_b"] and _gold["golds"]<=self._table[i]["gold_e"] then
                               		table.insert(self.cotion_gold,i)
                               	end
                               end
                               self.x_rand=self.cotion_gold[math.random(1,#self.cotion_gold)]
                               self:fun_began()
                      end)
  
end

function bigwheelLayer:onExit()
     NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.POOL_RANDOM_GOLDS, self)
     
end


return bigwheelLayer




