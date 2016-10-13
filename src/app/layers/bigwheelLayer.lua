--
-- Author: peter
-- Date: 2016-10-12 17:19:13

--  大转盘
local bigwheelLayer = class("bigwheelLayer", function()
            return display.newLayer("bigwheelLayer")
end)
function bigwheelLayer:ctor()
	self:setNodeEventEnabled(true)--layer添加监听
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
	self.gridNumer=6    --   一共的格子数
	self.gridAngle=360/self.gridNumer   --   每个格子的度数
	self:init(  )
	print("真的吗")
       
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
	    
	    m_pBg = cc.Sprite:create("LotteryTurn/bg_big.png");
	    m_pBg:setPosition(cc.p(bgSize.width / 2,bgSize.height / 2));
	    self:addChild(m_pBg);
	    
	
	    --添加转盘
	    m_turnBg = cc.Sprite:create("LotteryTurn/turn_bg.png");
	    m_turnBg:setPosition(cc.p(bgSize.width / 2,bgSize.height / 2));
	    m_pBg:addChild(m_turnBg);

	    --添加指针
	    local  arrNor = cc.Sprite:create("LotteryTurn/turn_arrow.png");
	    local  arrSel = cc.Sprite:create("LotteryTurn/turn_arrow.png");
	    arrSel:setColor(cc.c3b(190,190,190));
	    self.m_turnArr= cc.MenuItemSprite:create(arrNor, arrSel)   	   
	    self.m_turnArr:registerScriptTapHandler(menuCallback)
	    self.m_turnArr:setPosition(cc.p(bgSize.width / 2,bgSize.height * 0.557));
	    self.m_turnArr:setScale(0.7);
	    local  pMenu = cc.Menu:create(self.m_turnArr);
	    pMenu:setPosition(cc.p(0,0));
	    m_pBg:addChild(pMenu);
	    
	    --添加中奖之后的简单界面
	    local  awardLayer = cc.LayerColor:create(cc.c4b(0,0,0,100), 0,0)
	    awardLayer:setTag(100);
	    m_pBg:addChild(awardLayer,10);
	    awardLayer:setVisible(false);

end

function bigwheelLayer:touch_btCallback( sender, eventType )
            if eventType ~= ccui.TouchEventType.ended then
                return
            end 
           local tag=sender:getTag()
           if tag==141 then  --返回
           	 
           end  
end

function bigwheelLayer:onEnter()
   
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self,
  --                      function()
                               
  --                     end)
  
end

function bigwheelLayer:onExit()
     -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.GETTASKLIST, self)
     
     
     	
end


return bigwheelLayer




