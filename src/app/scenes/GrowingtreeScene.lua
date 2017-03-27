--
-- Author: peter
-- Date: 2017-02-25 09:57:50
--  成长树 
local GrowingtreeScene = class("GrowingtreeScene", function()
            return display.newScene("GrowingtreeScene")
end)
function GrowingtreeScene:ctor()
       self:setNodeEventEnabled(true)--layer添加监听
       self.floating_layer = require("app.layers.FloatingLayer").new()
       self.floating_layer:addTo(self,100000)
       self.back_playerid=nil
       self.list_seedstatus={"干旱","正常","成熟","收获","死亡"}  --  记住是从0 开始的
       self.zh_state={"普通种子","中级种子","高级种子","钻石种子","惊喜种子","普通化肥","中级化肥","高级化肥"}
       self.zh_stateimage1={"chengzhangshu-zhongzi-chu-1.png","chengzhangshu-zhongzi-zhong-1.png","chengzhangshu-zhongzi-gao-1.png","chengzhangshu-zhongzi-zuan-1.png","chengzhangshu-zhongzi-xi-1.png","chengzhangshu-huafei-chuji.png","chengzhangshu-huafei-zhongji.png","chengzhangshu-huafei-gaoji.png"}
       self.zh_stateimage2={"chengzhangshu-zhongzi-chu-1.png","chengzhangshu-zhongzi-zhong-1.png","chengzhangshu-zhongzi-gao-1.png","chengzhangshu-zhongzi-zuan-1.png","chengzhangshu-zhongzi-xi-1.png","chengzhangshu-huafei-chuji.png","chengzhangshu-huafei-zhongji.png","chengzhangshu-huafei-gaoji.png"}
       self.lv_table={2,2,3,3,4,4,5,6,6,7,8}
       self.pt_table={}  --  8个坑的表
       self.pt_tag_table=0  --  默认标记0 
       self._type_str_text=   nil
      self._obj_act=nil
       self.pv=  nil
       self._deng_hua=0
       self.is_friend=false
       self._feied_count=1
       self._Lv_text=nil
       self._Lv_text1=nil
       self._friend_employees_type=1
       --  定时器
       self.count_time=0
       self.secondOne=0
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
              self:update(dt)
            end)

       self.back_seedplant_seedmanure=" "  --  区别是种植接口还是施肥接口
       self:init()
       Server:Instance():gettreefriendlist(7,1,1)
       Server:Instance():gettreelist(self.back_playerid)--   成长树初始化接口     
       self.pt_tag_obj=nil  
end
--  在添加好友后刷新数据
function GrowingtreeScene:fun_refresh_friend( )
              if self.pv then
                self.pv:setVisible(false)
              end
              self._friend_employees_type=1
              Server:Instance():gettreefriendlist(7,1,1)
end
function GrowingtreeScene:init(  )
	
	self.Growingtree = cc.CSLoader:createNode("Growingtree.csb");
    	self:addChild(self.Growingtree)
      --self:fun_harvest_act(self.Growingtree,200,300)
      self.left_image=self.Growingtree:getChildByTag(645) 
      self.left_image:setLocalZOrder(100)
      self.left_image:setTouchEnabled(true)
      self.right_image=self.Growingtree:getChildByTag(644) 
      self.right_image:setLocalZOrder(100)
      self.right_image:setTouchEnabled(true)
      self.touch_image=self.Growingtree:getChildByTag(966) 

      self._deng_act=self.Growingtree:getChildByTag(2679)
      self._deng_act_img=self._deng_act:getChildByTag(2616)
      self._deng_act_img:loadTexture("png/chengzhangshu-zhong-di-suo.png")
      self._deng_act:setVisible(false)
       self.roleAction = cc.CSLoader:createTimeline("Growingtree.csb")
       self.Growingtree:runAction(self.roleAction)
       self.roleAction:setTimeSpeed(1.0)
       self.roleAction:gotoFrameAndPlay(0,40, true)
      --  初始化 加经验
      self._score2 =   ccui.TextAtlas:create(tostring("0"),"png/guoshiplist.png", 30, 42, "0")--
      self._score2 :setAnchorPoint(1,0.5)
      self._score2 :setVisible(false)
      self._score2:setRotation(90)
       --self._score2:setPosition(320, 480)
      self.Growingtree:addChild(self._score2 ,1,1086)
      local dishu_jia=cc.Sprite:create("png/chengzhangshu-shuihu-jiahao-.png")
      dishu_jia:setPosition(-15, 20)
      self._score2 :addChild(dishu_jia)

      self.gold_dishu_jia=cc.Sprite:create("png/chengzhangshu-touxiang-jingyan-icon.png")
      self.gold_dishu_jia:setScale(1.5)
      self.gold_dishu_jia:setPosition(-50, 20)
      self._score2 :addChild(self.gold_dishu_jia)


      --  初始化 加经验
      -- self._score3 =   ccui.TextAtlas:create(tostring("0"),"png/guoshiplist.png", 30, 42, "0")--
      -- self._score3 :setAnchorPoint(1,0.5)
      -- self._score3 :setVisible(false)
      -- self._score3:setRotation(90)
      --  --self._score2:setPosition(320, 480)
      -- self.Growingtree:addChild(self._score3 ,1,1086)
      -- local dishu_jia1=cc.Sprite:create("png/chengzhangshu-shuihu-jiahao-.png")
      -- dishu_jia1:setPosition(-15, 20)
      -- self._score3 :addChild(dishu_jia1)

      -- self.gold_dishu_jia1=cc.Sprite:create("png/chengzhangshu-touxiang-jingyan-icon.png")
      -- self.gold_dishu_jia1:setScale(1.5)
      -- self.gold_dishu_jia1:setPosition(-50, 20)
      -- self._score3 :addChild(self.gold_dishu_jia1)


      --  初始化果实收获数量
      self._score1 =   ccui.TextAtlas:create(tostring("0"),"png/guoshiplist.png", 30, 42, "0")--
      self._score1 :setAnchorPoint(1,0.5)
      self._score1 :setVisible(false)
      self._score1:setRotation(90)
      -- self._score1:setPosition(320, 480)
      self.Growingtree:addChild(self._score1 ,1,1086)
      local dishu_number=cc.Sprite:create("png/chengzhangshu-shuihu-jiahao-.png")
      dishu_number:setPosition(-15, 20)
      self._score1 :addChild(dishu_number)

      local dishu_number_zhong=cc.Sprite:create("png/chengzhangshu-zhongzi-0.png")  --种子
      dishu_number_zhong:setPosition(-50, 20)
      self._score1 :addChild(dishu_number_zhong)
    	for i=1,8 do
    		self.pt_table[i]=self.Growingtree:getChildByTag(3248+i):getChildByTag(103+i)  -- 8个坑
    	end


      self._fertilization_template=self.Growingtree:getChildByTag(5391)  -- 施肥信息模板
	self.back_bt=self.Growingtree:getChildByTag(84)  -- 返回
	self.back_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	            	return
	             end 
                  if self.is_friend   then
                      self.back_playerid=nil
                      self.is_friend=false
                      Server:Instance():gettreelist(self.back_playerid)
                      self.friend_growingtree_checkbox:setVisible(true)
                      self._feied_count=1
                      return
                  end
                  
		Util:scene_control("MainInterfaceScene")
	end)

      self.back_huijia_bt=self.Growingtree:getChildByTag(1557)  -- 回家
      self.back_huijia_bt:setScale(1.5)
      self.back_huijia_bt:setTouchEnabled(false)
      self.back_huijia_bt:addTouchEventListener(function(sender, eventType  )
                  if eventType ~= ccui.TouchEventType.ended then
                    return
                   end 
                      if self.is_friend   then
                       

                      self:fun_move_act_yun(self.left_image,self.left_image:getPositionY())
                        self:fun_move_act_yun(self.right_image,self.right_image:getPositionY())
                        
                          self.back_playerid=nil
                          self._deng_act:setVisible(false)
                          self.is_friend=false
                          Server:Instance():gettreelist(self.back_playerid)
                          self.friend_growingtree_checkbox:setVisible(true)
                          self._feied_count=1
                          self.back_huijia_bt:setVisible(false)
                          self.back_bt:setVisible(true)
                          if self.back_playerid  ==  nil then
                                self._growingtreeNode:setPositionX(0)
                                self.friend_growingtree_checkbox:setPositionY( self._spdt-40)
                                self.friend_growingtree_checkbox:setSelected(true) 
                                self._friend_employees_type=1
                                 if self.pv then
                                          self.pv:setVisible(true)
                                end
                        end
                          return
                      end
      end)
    	self._growingtreeNode=self.Growingtree:getChildByTag(56)  -- 好友列表栏
    	self.friend_growingtree_checkbox=self._growingtreeNode:getChildByTag(163)  --  好友按钮
    	self.friend_growingtree_checkbox:setTouchEnabled(true)
      self._spdt=self.friend_growingtree_checkbox:getPositionY()
      self._growingtreeNode:setPositionX(0)
      self.friend_growingtree_checkbox:setSelected(true)
      self.friend_growingtree_checkbox:setPositionY(self.friend_growingtree_checkbox:getPositionY() -40)
    	self.friend_growingtree_checkbox:addEventListener(function(sender, eventType  )
                           if eventType == ccui.CheckBoxEventType.selected then
                                  self._growingtreeNode:setPositionX(0)
                                 
                                  -- local  move1=cc.MoveTo:create(1, cc.p( 0,self._growingtreeNode:getPositionY() ) )
                                  -- self._growingtreeNode:stopAllActions()
                                  -- self._growingtreeNode:runAction(move1)

                                  self.friend_growingtree_checkbox:setPositionY(self.friend_growingtree_checkbox:getPositionY() -40)
                                  self._friend_employees_type=1
                                  Server:Instance():gettreefriendlist(7,1,1)
                                  -- for i=1,8 do
                                  --   self.pt_table[i]:setTouchEnabled(false)
                                  -- end
                           elseif eventType == ccui.CheckBoxEventType.unselected then
                                  self._growingtreeNode:setPositionX(-220)
                                  self.friend_growingtree_checkbox:setPositionY(self._spdt)
                                  -- for i=1,8 do
                                  --   self.pt_table[i]:setTouchEnabled(true)
                                  -- end
                                  if self.pv then
                                    self.pv:setVisible(false)
                                  end
                           end
            end)

    	local add_friend_bt=self._growingtreeNode:getChildByTag(281)  -- 添加好友
	add_friend_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	end)
	
	  local z_bt=self._growingtreeNode:getChildByTag(41)  --左移一格
	 z_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local y_bt=self._growingtreeNode:getChildByTag(42)  --右移一格
	 y_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	  end)

	  local zt_bt=self._growingtreeNode:getChildByTag(43)  --左移一列
	 zt_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local yt_bt=self._growingtreeNode:getChildByTag(44)  --右移一列
	 yt_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refriend_bt=self._growingtreeNode:getChildByTag(46)  --邀请好友按钮
	 refriend_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	  end)

       local refresh_bt=self._growingtreeNode:getChildByTag(45)  --刷新好友
     refresh_bt:addTouchEventListener(function(sender, eventType  )
               self:touch_Nodecallback(sender, eventType)
      end)

	  local Myfriend_bt=self._growingtreeNode:getChildByTag(52)  --我的好友按钮
	 Myfriend_bt:getChildByTag(54):setBright(false)
	 Myfriend_bt:setBright(false)
       self.curr_brightnode=Myfriend_bt--记录当前高亮

	 Myfriend_bt:addTouchEventListener(function(sender, eventType  )
	           self:fun_callback(sender, eventType)
	  end)

	  local Myemployees_bt=self._growingtreeNode:getChildByTag(53)  --我的员工按钮
	 Myemployees_bt:addTouchEventListener(function(sender, eventType  )
	           self:fun_callback(sender, eventType)
	  end)

	 self.FruitinformationNode = self.Growingtree:getChildByTag(2489)  --Node  种子信息   界面
       --  种子信息界面
      self._fruitinformation_bg=self.FruitinformationNode:getChildByTag(2424)

	 self.ListNode=self.Growingtree:getChildByTag(779):getChildByTag(733)  --种子和化肥列表
       self._type_str_text=self.ListNode:getChildByTag(975)  -- 类型
	 local backNode_bt=self.ListNode:getChildByTag(974)  -- 返回
	backNode_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	            	return
	             end 
		self.ListNode:setVisible(false)
            self.pt_tag_table=0
		self.friend_growingtree_checkbox:setTouchEnabled(true)

	end)
      self.backpack_list=self.ListNode:getChildByTag(1691)
      --self.backpack_list:setRotation(90)
      self.backpack_list:setItemModel(self.backpack_list:getItem(0))
      self.backpack_list:removeAllItems()

      self:function_touchlistener(true)

end
--  头像信息
function GrowingtreeScene:fun_per(  )

   local gettreelist = LocalData:Instance():get_gettreelist()
  if self.back_playerid  ~=  nil then
              self.Growingtree:getChildByTag(380):setVisible(true)
              self.Growingtree:getChildByTag(581):setVisible(false)
              local experience_text=self.Growingtree:getChildByTag(380):getChildByTag(392)  --经验值
              experience_text:setString(gettreelist["treeExp"])

              local gold_text=self.Growingtree:getChildByTag(380):getChildByTag(393)  --金币值
              gold_text:setString(gettreelist["golds"])

              local diamond_text=self.Growingtree:getChildByTag(380):getChildByTag(394)  --钻石值
              diamond_text:setString(gettreelist["diamondnum"])

              local head_image=self.Growingtree:getChildByTag(380):getChildByTag(382)  --自己头像
              print("头像  ",tostring(Util:sub_str(gettreelist["imageUrl"], "/",":")))
              head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(gettreelist["imageUrl"], "/",":"))))

              local name_text=self.Growingtree:getChildByTag(380):getChildByTag(385)  --自己名字
              name_text:setString(gettreelist["nickname"])

              local Lv_img=self.Growingtree:getChildByTag(380):getChildByTag(384)  --等级
              Lv_img:setVisible(false)
              if self._Lv_text1==nil then
                self._Lv_text1 =   ccui.TextAtlas:create((tostring(gettreelist["treegrade"])),"png/treefontPlist.png", 12, 15, "0")
                self._Lv_text1:setPosition(cc.p(Lv_img:getPositionX(),Lv_img:getPositionY()))
                self._Lv_text1:setAnchorPoint(0,0.5)
                self.Growingtree:getChildByTag(380):addChild(self._Lv_text1)
              else
                self._Lv_text1:setProperty((tostring(gettreelist["treegrade"])),"png/treefontPlist.png", 12, 15, "0")
              end
              self._Lv_text1:setVisible(true)
                if self._Lv_text~=  nil then
                self._Lv_text:setVisible(false)
            end
              return
  end


   self.Growingtree:getChildByTag(380):setVisible(false)
   self.Growingtree:getChildByTag(581):setVisible(true)
   local experience_text=self.Growingtree:getChildByTag(581):getChildByTag(87)  --经验值
   experience_text:setString(gettreelist["treeExp"])

   local gold_text=self.Growingtree:getChildByTag(581):getChildByTag(88)  --金币值
   gold_text:setString(gettreelist["golds"])

   local diamond_text=self.Growingtree:getChildByTag(581):getChildByTag(89)  --钻石值
   diamond_text:setString(gettreelist["diamondnum"])

   local head_image=self.Growingtree:getChildByTag(581):getChildByTag(86)  --自己头像
   print("头像  ",tostring(Util:sub_str(gettreelist["imageUrl"], "/",":")))
   head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(gettreelist["imageUrl"], "/",":"))))

   local name_text=self.Growingtree:getChildByTag(581):getChildByTag(90)  --自己名字
   name_text:setString(gettreelist["nickname"])

      local Lv_img=self.Growingtree:getChildByTag(581):getChildByTag(3259)  --等级
      Lv_img:setVisible(false)
      if self._Lv_text==nil then
        self._Lv_text =   ccui.TextAtlas:create((tostring(gettreelist["treegrade"])),"png/treefontPlist.png", 12, 15, "0")
        self._Lv_text:setPosition(cc.p(Lv_img:getPositionX(),Lv_img:getPositionY()))
        self._Lv_text:setRotation(90)
        self._Lv_text:setAnchorPoint(0,0.5)
        self.Growingtree:addChild(self._Lv_text)
      else
        self._Lv_text:setProperty((tostring(gettreelist["treegrade"])),"png/treefontPlist.png", 12, 15, "0")
      end
      if self._Lv_text1~=  nil then
          self._Lv_text1:setVisible(false)
      end
       
       self._Lv_text:setVisible(true)

end
function GrowingtreeScene:fun_data()
  self._deng_act_img:loadTexture("png/chengzhangshu-1-touming.png")
    	for i=1,8 do
    		self.pt_table[i]:loadTexture("png/chengzhangshu-zhong-di-suo.png")
           self.pt_table[i]:getParent():loadTexture("png/chengzhangshu-zhong-di.png")
    		self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+498):setVisible(false)
            self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359):setVisible(false)
    	end

	 local gettreelist = LocalData:Instance():get_gettreelist()
	  self.z_treeid=gettreelist["list"][1]["treeid"]  --目前默认只有一棵树

	self:fun_per()
      
	local tree_seedlist = gettreelist["list"][1]["seedlist"]

      local _treegrade=0
	 if tonumber(gettreelist["treegrade"]) >= 0 then  --  缺等级表
            _treegrade=self.lv_table[tonumber(gettreelist["treegrade"])+1]
	 	for i=1,_treegrade do
    			self.pt_table[i]:setTouchEnabled(true)
                  if self.back_playerid  ~=  nil then
                    self.pt_table[i]:setTouchEnabled(false)
                  end

                  self._deng_act_img:loadTexture("png/chengzhangshu-1-touming.png")
    			-- self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+498):setString("可种植")
    			-- self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+498):setVisible(false)
                  self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359):loadTexture("png/chengzhangshu-zhongzi-0.png")
                  self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359):setVisible(true)
                  self:fun_move_act(self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359),self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359):getPositionX(),self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359):getPositionY())
                  if self.back_playerid  ~=  nil then
                    self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+359):setVisible(false)
                  end
    			self.pt_table[i]:loadTexture("png/chengzhangshu-1-touming.png")
    			self.pt_table[i]:addTouchEventListener(function(sender, eventType  )
			            if eventType ~= ccui.TouchEventType.ended then
			                return
			            end 
                    self._growingtreeNode:setPositionX(-220)
                              if self.pv then
                                    self.pv:setVisible(false)
                              end
                    self.friend_growingtree_checkbox:setPositionY(self._spdt)
                  self:fun_FruitinformationNode(sender:getParent():getPositionX(),sender:getParent():getPositionY(),false,-1) 
                  self.ListNode:setVisible(false)
                            --  if self.pt_tag_table   ~=   0 then
                            --       if   self.pt_tag_table ~=sender:getTag()  then    
                                             
                            --                    return
                            --       else
                            --                 self.friend_growingtree_checkbox:setTouchEnabled(true)
                            --                 self.pt_tag_table=0
                                            
                            --                 return
                            --       end
                            -- end
                            self._obj_act=sender
                             self._deng_act:setPosition(sender:getParent():getPositionX(),sender:getParent():getPositionY())
                             self._deng_act:setVisible(true)
                             self._deng_hua=sender:getTag()-103
                             self._deng_act_img:loadTexture("png/chengzhangshu-1-touming.png")
                           
                            self.pt_tag_table=sender:getTag()
                            self.friend_growingtree_checkbox:setTouchEnabled(false)   
			            print("种植")
                              self.back_seedplant_seedmanure="种植"  --  区别是种植接口还是施肥接口
                              self.pt_tag_obj=sender  --  选中目标对象 
                              Server:Instance():gettreegameitemlist(2 )  --1化肥 2种子 3化肥和种子
			            self.friend_growingtree_checkbox:setSelected(false)
			            self.friend_growingtree_checkbox:setTouchEnabled(false)
			            self.ListNode:setVisible(true)
                              self._type_str_text:setString("播种")
			            -- self._growingtreeNode:setPositionX(-220)(xin)
               --                if self.pv then
               --                      self.pv:setVisible(false)
               --                end
               --                self.friend_growingtree_checkbox:setPositionY(self._spdt)
			            sender:setTouchEnabled(false)
			            local function stopAction()
			    		sender:setTouchEnabled(true)
			    	end
			    	local callfunc = cc.CallFunc:create(stopAction)
			            self.Growingtree:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
			end)

    		end
	 end

	 local tree_seedlist = gettreelist["list"][1]["seedlist"]
	 if not tree_seedlist  or   #tree_seedlist  ==  0 then
	 	return
	 end
	 for i=1,#tree_seedlist do
	 	for j=1,8 do
	 		if tostring(tree_seedlist[i]["seedname"]) == tostring(self.zh_state[j]) then
                         if tostring(tree_seedlist[i]["seedstatus"]) ==  "2" and tonumber(tree_seedlist[i]["stolenamount"]) == 0 then
                                   self.pt_table[tree_seedlist[i]["seatcount"]]:getParent():loadTexture("png/chengzhangshu-zhong-di-yishou.png" )
	 			           self.pt_table[tree_seedlist[i]["seatcount"]]:setTouchEnabled(false)
                        elseif tostring(tree_seedlist[i]["seedstatus"]) ==  "2"  and  tonumber(tree_seedlist[i]["stolenamount"]) >0   then   --收获
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setString(tostring(tree_seedlist[i]["gainsamount"]))
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setVisible(false)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):loadTexture("png/chengzhangshu-shou-1.png")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):setVisible(true)
                              self:fun_move_act(self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359),self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):getPositionX(),self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):getPositionY())
                              self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/"  .. self.zh_stateimage2[j] )
	 			     --self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage2[j])
                        elseif  tostring(tree_seedlist[i]["seedstatus"]) ==  "4" or tostring(tree_seedlist[i]["seedstatus"]) ==  "3"  then  --  死亡
	 				self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/chengzhangshu-zhong-di-suo.png")
                              --self._deng_act_img:loadTexture("png/chengzhangshu-zhong-di-suo.png")
	 			elseif tostring(tree_seedlist[i]["seedstatus"]) ==  "0" then  --  干旱  浇水
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setString("可浇水")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setVisible(false)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):loadTexture("png/chengzhangshu-shuihu.png")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):setVisible(true)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/"  .. self.zh_stateimage1[j] )
                               --self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[j] )
                                self:fun_move_act(self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359),self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):getPositionX(),self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):getPositionY())
                        else
	 				self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/"  .. self.zh_stateimage1[j] )
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setVisible(false)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):setVisible(false)
	 			      --self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[j] )
               self:fun_move_act(self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359),self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):getPositionX(),self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):getPositionY())
                        end
	 			self.pt_table[tree_seedlist[i]["seatcount"]]:setTouchEnabled(true)
                       if tonumber(tree_seedlist[i]["seatcount"])  ==  self._deng_hua then
                          for p=1,8 do
                            if tostring(tree_seedlist[i]["seedname"])  ==self.zh_state[p]   then
                               self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[p] )
                            end
                          end
                       end
                        
                                                      

	 			self.pt_table[tree_seedlist[i]["seatcount"]]:addTouchEventListener(function(sender, eventType  )
				            if eventType ~= ccui.TouchEventType.ended then
				                return
				            end 
                  
                    self:fun_FruitinformationNode(sender:getParent():getPositionX(),sender:getParent():getPositionY(),false,-1) 
                    self.ListNode:setVisible(false)
                                   
                                    self._obj_act=sender
                                    self.friend_growingtree_checkbox:setTouchEnabled(false)
                                    self.pt_tag_table=sender:getTag()
                                    
                                    for z=1,#tree_seedlist do

                                      if tonumber(tree_seedlist[z]["seatcount"] )== sender:getTag()-103 then  --  所需要的TAG
                                            self.z_seedid= tree_seedlist[z]["seedid"]
                                            if tonumber(tree_seedlist[z]["seedstatus"] )==1 then  --  正常成长状态
                                               self:fun_FruitinformationNode(sender:getParent():getPositionX(),sender:getParent():getPositionY(),true,z)  --  只是测试
                                               self._deng_act:setPosition(sender:getParent():getPositionX(),sender:getParent():getPositionY())
                                               self._deng_act:setVisible(true)
                                               self._deng_hua=sender:getTag()-103
                                               for k=1,8 do
                                                  if tostring(tree_seedlist[i]["seedname"]) == tostring(self.zh_state[k]) then
                                                      self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[k] )
                                                      
                                                  end
                                                 
                                               end
                                                
                                               self:scheduleUpdate()
                                            elseif tonumber(tree_seedlist[z]["seedstatus"] )==2 then  --  收获
                                                         if tostring(tree_seedlist[z]["seedstatus"]) ==  "2" and tonumber(tree_seedlist[z]["stolenamount"]) == 0 then
                                                                       
                                                                        return
                                                         end
                                              Server:Instance():setseedreward(self.z_treeid,self.z_seedid)
                                              
                                              -- local _istouch=true
                                              --   self.floating_layer:fun_Grawpopup("作物已经收获,真的收获吗",function (sender, eventType)        
                                              --                   if eventType==1  and _istouch  then
                                              --                        print("收获")
                                              --                        _istouch=false
                                              --                        Server:Instance():setseedreward(self.z_treeid,self.z_seedid)
                                              --                   end                
                                              --   end)  
                                                self._deng_act:setPosition(sender:getParent():getPositionX(),sender:getParent():getPositionY())
                                               self._deng_act:setVisible(true)
                                               self._deng_hua=sender:getTag()-103
                                               for k=1,8 do
                                                  if tostring(tree_seedlist[i]["seedname"]) == tostring(self.zh_state[k]) then
                                                      self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[k] )
                                                  end
                                                 
                                               end

                                            elseif tonumber(tree_seedlist[z]["seedstatus"] )==0 then  --  干旱

                                                 self._deng_act:setPosition(sender:getParent():getPositionX(),sender:getParent():getPositionY())
                                               self._deng_act:setVisible(true)
                                               self._deng_hua=sender:getTag()-103
                                               for k=1,8 do
                                                  if tostring(tree_seedlist[i]["seedname"]) == tostring(self.zh_state[k]) then
                                                      self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[k] )
                                                  end
                                                 
                                               end

                                                 Server:Instance():setseedwater(self.z_treeid,self.z_seedid)
                                                 
                                                -- self.floating_layer:fun_Grawpopup("作物已经干旱,真的浇水吗",function (sender, eventType)
                                                --                 if eventType==1  then
                                                --                      print("浇水")
                                                                    
                                                --                      Server:Instance():setseedwater(self.z_treeid,self.z_seedid)
                                                --                 end                
                                                -- end)  
                                                else
                                                        self._deng_act:setPosition(sender:getParent():getPositionX(),sender:getParent():getPositionY())
                                                        self._deng_act:setVisible(true)
                                                        self._deng_hua=sender:getTag()-103
                                                         for k=1,8 do
                                                            if tostring(tree_seedlist[i]["seedname"]) == tostring(self.zh_state[k]) then
                                                                self._deng_act_img:loadTexture("png/"  .. self.zh_stateimage1[k] )
                                                            end
                                                           
                                                         end
                                            end
                                      end

                                    end
                                    
				            
				            sender:setTouchEnabled(false)
    		                        local function stopAction()
        				    		sender:setTouchEnabled(true)
        			            end
				           local callfunc = cc.CallFunc:create(stopAction)
				            self.Growingtree:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
				end)

	 		end
	 	end
	 end


end
--  背包列表
function GrowingtreeScene:fun_backpack_list(  )
          self.backpack_list:removeAllItems()
          local gettreegameitemlist=LocalData:Instance():get_gettreegameitemlist()
          dump(gettreegameitemlist)
          local _list=gettreegameitemlist["list"]
        

          if #_list == 0 then
            return
          end
          for i=1,#_list  do
              self.backpack_list:pushBackDefaultItem()
              local  cell = self.backpack_list:getItem(i-1)
              local name_text=cell:getChildByTag(1694)
              name_text:setString(tostring(_list[i]["name"]))
              local _score=cell:getChildByTag(3333)
              if tostring(_list[i]["count"])  ==  "n" then
                -- _score:setString(tostring(_list[i]["count"]))
              else
                local  digital_text =   ccui.TextAtlas:create((tostring(_list[i]["count"])),"png/treefontPlist.png", 12, 15, "0")
                digital_text:setPosition(cc.p(_score:getPositionX(),_score:getPositionY()))
                digital_text:setAnchorPoint(0.5,0.5)
                cell:addChild(digital_text)
                _score:setVisible(false)
              end
              
              --digital_text:setString(tostring(_list[i]["count"]))

              local bt=cell:getChildByName("Button_13")
              bt:setTag(i) 
              bt:addTouchEventListener(function(sender, eventType  )
                        if eventType ~= ccui.TouchEventType.ended then
                              return
                        end 
                        self.z_gameitemid=_list[sender:getTag()]["gameitemid"]
                        if tostring(self.back_seedplant_seedmanure)=="施肥"   then
                               --施肥接口
                              Server:Instance():setseedmanure(self.z_treeid,self.z_seedid,self.z_gameitemid)

                        elseif tostring(self.back_seedplant_seedmanure)=="种植" then
                              --  种植接口
                        Server:Instance():setseedplant(self.z_treeid,self.z_gameitemid,self.pt_tag_obj:getTag()-103)  --  种种子
                        end
                        
              end)
              local _image=cell:getChildByTag(1693)
              for j=1,8 do
                    if tostring(_list[i]["name"]) == self.zh_state[j] then
                      _image:loadTexture("png/" .. self.zh_stateimage1[j])
                    end
              end
               
          end
end
function GrowingtreeScene:touch_Nodecallback( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
           end 
          local tag=sender:getTag() 
           if tag==281 then   
          	    -- print("添加好友")
                 local InvitefriendsLayer = require("app.layers.InvitefriendsLayer")  --邀请好友排行榜
                 self:addChild(InvitefriendsLayer.new(),1,13)
           elseif tag==41 then
           	   print("左移一格")
              self.pv:gotoPage(-1)
           	elseif tag==42 then
           	   -- print("右移一格")
      --           self.Scene =  ccs.SceneReader:getInstance():createNodeWithSceneFile("Scene.json")
      -- self:addChild(self.Scene)
               self.pv:gotoPage(1)

           	elseif tag==43 then
           	   -- print("左移一列")
               self.pv:gotoPage(-5)
           	elseif tag==44 then
           	   -- print("右移一列")
               self.pv:gotoPage(5)
           	elseif tag==46 then
           	   print("邀请好友")
               -- Util:share()
               local InvitefriendsLayer = require("app.layers.FriendrequestLayer")  --邀请好友排行榜
                self:addChild(InvitefriendsLayer.new({switch=1}),1,13)
            elseif tag==45 then
               print("刷新好友")
               if self.pv then
                  self.pv:setVisible(false)
               end
               self._feied_count=self._feied_count+1
               
               Server:Instance():gettreefriendlist(7,self._feied_count,self._friend_employees_type)
            end
 end 
 function GrowingtreeScene:fun_callback( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
           end 
          local tag=sender:getTag() 
          if self.curr_brightnode:getTag()==tag then
              return
          end
          self.curr_brightnode:setBright(true)
          self.curr_brightnode:getChildByTag(self.curr_brightnode:getTag()+2):setBright(true)
          sender:setBright(false)
          sender:getChildByTag(sender:getTag()+2):setBright(false)
          if tag==52 then   
          	 print("我的好友按钮")
             self._friend_employees_type=1
             Server:Instance():gettreefriendlist(7,1,1)
              if self.pv then
                self.pv:setVisible(false)
              end
          elseif tag==53 then
          	  print("我的员工按钮")
              if self.pv then
                  self.pv:setVisible(false)
                end
              self._feied_count=1
              self._friend_employees_type=2
              Server:Instance():gettreefriendlist(7,1,2)
               
         end
         self.curr_brightnode=sender
    
end
--  所谓的定时器
function GrowingtreeScene:update(dt)
      self.secondOne = self.secondOne+dt
      if self.secondOne <1 then return end
      self.secondOne=0
      self.count_time=1+self.count_time
       if tostring(self.seed_information)   ==  "false" then
         self:unscheduleUpdate()
        return
      end

       local _table  = Util:FormatTime_colon_bar(self.seed_information["seed_next_time"] -  self.count_time )
       if tonumber(self.seed_information["seed_next_time"]) <= 0 then
         Server:Instance():gettreelist(self.back_playerid)  --目的是刷新数据
         return
       end
      self.time_againtime:setString(tostring( _table[2] .. _table[3] .. _table[4] ))
      local par=(100-self.seed_information["seed_percentage"]  *  100)/(self.seed_information["seed_next_time"]-self.count_time)
      self.Loadingbar_infor:setPercent(self.seed_information["seed_percentage"]  *  100  +  par)
end

--  种子状态逻辑
function GrowingtreeScene:function_seed_state(dex)
  --seedstatus --0为干旱，1为正常，2为成熟，3为已收获  4死亡
  local back_seed_state={}
  local gettreelist = LocalData:Instance():get_gettreelist()
  local seedlist=gettreelist["list"][1]["seedlist"]

  back_seed_state["seedstatus"] =-1  --种子初始状态
  back_seed_state["seed_percentage"]=-1 --种子距离下一状态百分比
  back_seed_state["seed_next_time"]=-1 --种子距离下一状态时间
  back_seed_state["seed_image"]=nil  --图片
  back_seed_state["seedname"]=nil  --图片
  back_seed_state["dex"]=dex --  索引
  back_seed_state["tile_des"]="无"
  if dex ==  -1 then
    return  false
  end
  if not seedlist[dex]then
    return   
  end
  local nowtime=seedlist[dex]["nowtime"] +(os.time()-seedlist[dex]["nowtime"])
  -- dump(nowtime)
  -- dump(os.time()-seedlist[dex]["nowtime"])
  back_seed_state["seedname"]=seedlist[dex]["seedname"]
  for i=1,8 do
    if tostring(seedlist[dex]["seedname"])  ==  self.zh_state[i]  then

      back_seed_state["seed_image"] = self.zh_stateimage1[i]
    end
  end
-- drytime 种子干旱时间  deadtime 种子死亡时间  gaintime 种子成熟时间 planttime 种子种植时间 nowtime 当前时间

  if nowtime-seedlist[dex]["drytime"]<=0  then
    back_seed_state["seedstatus"] =1  
    back_seed_state["seed_percentage"]=(nowtime-seedlist[dex]["planttime"])/(seedlist[dex]["gaintime"]-seedlist[dex]["planttime"]) 
    back_seed_state["seed_next_time"]=seedlist[dex]["gaintime"]-nowtime 
    back_seed_state["tile_des"]="正常"
  end

  if nowtime-seedlist[dex]["drytime"]>=0 then
    back_seed_state["seedstatus"]=0
    back_seed_state["seed_percentage"]=(nowtime-seedlist[dex]["drytime"])/(seedlist[dex]["deadtime"]-seedlist[dex]["drytime"])
    back_seed_state["seed_next_time"]=seedlist[dex]["deadtime"]-nowtime
    --dump(seed_next_time)
    back_seed_state["tile_des"]="干旱"
  end

  if nowtime-seedlist[dex]["deadtime"]>=0 then
    back_seed_state["seedstatus"]=4
    back_seed_state["seed_next_time"]=0
    back_seed_state["tile_des"]="死亡"
  end

  if nowtime-seedlist[dex]["gaintime"]>=0 then
    back_seed_state["seedstatus"]=2
    back_seed_state["seed_next_time"]=0
    back_seed_state["tile_des"]="成熟"
  end
  --注 ：以收获3种子列表为Null 
  -- dump(seedlist[dex])
   --dump(back_seed_state)
  return back_seed_state

end
--  种子信息界面数据
function GrowingtreeScene:fun_FruitinformationNode( _x , _y,_isVis,_dex)
      self.count_time=0
      self.seed_information1=self:function_seed_state(_dex)

      local fruitinformation_bg=self._fruitinformation_bg
      self._fruitinformation_bg:setPosition(cc.p(_x+100,_y))
      self._fruitinformation_bg:setVisible(_isVis)
      if tostring(self.seed_information1)   ==  "false" then
        return
      end
 	self.seed_information=self.seed_information1
	local seedname=self._fruitinformation_bg:getChildByTag(2431) -- 种子名称
	seedname:setString(self.seed_information["seedname"])
	self.time_againtime=self._fruitinformation_bg:getChildByTag(2434)  --  结果时间
      local _table  = Util:FormatTime_colon_bar(self.seed_information["seed_next_time"]  )
      self.time_againtime:setString(tostring( _table[2] .. _table[3] .. _table[4] ))
      local tile_des=self._fruitinformation_bg:getChildByTag(2433)  --  状态名称
      --tile_des:setString(self.seed_information["tile_des"])
      self.Loadingbar_infor=self._fruitinformation_bg:getChildByTag(2429)  --  LoadingBar 
      self.Loadingbar_infor:setPercent(tonumber(self.seed_information["seed_percentage"])  * 100 )
      local _image=self._fruitinformation_bg:getChildByTag(2425)  --  样图
      _image:loadTexture("png/"  ..  self.seed_information["seed_image"])

	local remove=self._fruitinformation_bg:getChildByTag(1074)  --  铲除
	remove:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                               local _is=true
                               --Server:Instance():setseedremove(self.z_treeid,self.z_seedid)
                               self.floating_layer:fun_Grawpopup("作物还没有收获,真的铲除吗",function (sender, eventType)
                                              if eventType==1 and  _is  ==  true then
                                                   Server:Instance():setseedremove(self.z_treeid,self.z_seedid)
                                              end                
                              end)  
            end)

	local fertilization=self._fruitinformation_bg:getChildByTag(1075)  --  施肥
	fertilization:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                              
                              --Server:Instance():Grawpopup_box_buffer("化肥功能暂未开放，敬请期待。")
                              self.back_seedplant_seedmanure="施肥"   
                              Server:Instance():gettreegameitemlist(1 )    
                              self.ListNode:setVisible(true)
                              self._type_str_text:setString("施肥")
                              self:fun_FruitinformationNode(self._fertilization_template:getPositionX(),self._fertilization_template:getPositionY(),true,-1)       
            end)
			
end
--  整个界面具备touch事件
function GrowingtreeScene:function_touchlistener(_isTouch)
   local function onTouchEnded(x,y) 
                    self.ListNode:setVisible(false)
                    self.pt_tag_table=0
                    self.friend_growingtree_checkbox:setTouchEnabled(true)
                    self:fun_FruitinformationNode(1,1,false,-1)
                    self._deng_act:setVisible(false)
                    --self._growingtreeNode:setPositionX(-220)
                    -- for i=1,8 do
                    --   self.pt_table[i]:setTouchEnabled(true)
                    -- end
                    --  if self.pv then
                    --   self.pv:setVisible(false)
                    -- end
                    -- self.friend_growingtree_checkbox:setSelected(false) 
                    if self.back_playerid  ==  nil then
                                self._growingtreeNode:setPositionX(0)
                                self.friend_growingtree_checkbox:setPositionY( self._spdt-40)
                                self.friend_growingtree_checkbox:setSelected(true) 
                                self._friend_employees_type=1
                                 if self.pv then
                                          self.pv:setVisible(true)
                                end
                   end
                    
                                  --Server:Instance():gettreefriendlist(7,1,1)

   end
      self.Growingtree:setTouchEnabled(_isTouch)  
      self.Growingtree:setTouchSwallowEnabled(false)  
      self.Growingtree:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)  
      self.Growingtree:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event) 
               if event.name == "began" then  
                -- print("坐标")
                 onTouchEnded(event.x,event.y)  
               end  
               return true  
      end)  
end
--  收获动画
function GrowingtreeScene:fun_harvest_act( _obj,_x,_y )

  local dishu_jia1=cc.Sprite:create("png/jinbiba_jiazaitu2.jpg")
      dishu_jia1:setPosition(cc.p(200,300))
      _obj:addChild(dishu_jia1)
                 local bezier ={
                  
                  cc.p(_x+15, _y+21.5),
                  cc.p(_x+30, _y)
              }
           local bezierTo = cc.BezierTo:create(2, bezier)
           dishu_jia1:runAction(bezierTo)

end
--灯笼动画 
function GrowingtreeScene:function_lantern_act( _obj,x,y,_isVisb)
  local animation = cc.Animation:create()
  local name
  for i=2,3 do
    name = "png/chengzhangshu-zhong-di-"..i..".png"
    animation:addSpriteFrameWithFile(name)
  end
  animation:setDelayPerUnit(0.2)
  animation:setRestoreOriginalFrame(true)
  --创建动作
  local animate = cc.Animate:create(animation)
 self._zhong_spr = cc.Sprite:create()
 self._zhong_spr:setRotation(90)
  self._zhong_spr:setPosition(cc.p(x,y))
  self.Growingtree:addChild(self._zhong_spr)  --  直接在水壶上上面
  self._zhong_spr:setVisible(_isVisb)
  --  local function stopAction()
  --                   --self.Growingtree:getChildByTag(266):setRotation(90)   
  --  end
  -- local callfunc = cc.CallFunc:create(stopAction)   -- Repeat   RepeatForever
  local seq=cc.RepeatForever:create(cc.Sequence:create(animate))      --cc.Sequence:create(cc.RepeatForever:create(animate)) --,cc.DelayTime:create(0.8),callfunc)
  self._zhong_spr:stopAllActions()
  self._zhong_spr:runAction(seq)--(animate)

end

 --加经验动画
function GrowingtreeScene:coinAction(jin,x,y)
    print("动画",x,"  ",y)
    if tonumber(jin)  <=  0 then
     return
    end
    self._score2 :setVisible(true)
    self._score2:setPosition(x, y)
    self._score2:setProperty(tostring(jin),"png/guoshiplist.png", 30, 42, "0")
     local function logSprRotation(sender)
                     self._score2 :setVisible(false)                   
     end
     local  move1=cc.MoveTo:create(1, cc.p( x+180,y ) )
     local action = cc.Sequence:create(move1,cc.CallFunc:create(logSprRotation))
     self._score2:stopAllActions()
     self._score2:runAction(action)
end

 --加金币动画
function GrowingtreeScene:coinAction1(jin,x,y)
    if tonumber(jin)  <=  0 then
     return
    end
    local _score3 =   ccui.TextAtlas:create(tostring("0"),"png/guoshiplist.png", 30, 42, "0")--
      _score3 :setAnchorPoint(1,0.5)
      _score3 :setVisible(false)
      _score3:setRotation(90)
       --self._score2:setPosition(320, 480)
      self.Growingtree:addChild(_score3 ,1,1086)
      local dishu_jia1=cc.Sprite:create("png/chengzhangshu-shuihu-jiahao-.png")
      dishu_jia1:setPosition(-15, 20)
      _score3 :addChild(dishu_jia1)

      self.gold_dishu_jia1=cc.Sprite:create("png/chengzhangshu-touxiang-jingyan-icon.png")
      self.gold_dishu_jia1:setScale(1.5)
      self.gold_dishu_jia1:setPosition(-50, 20)
      _score3 :addChild(self.gold_dishu_jia1)

    _score3 :setVisible(true)
    _score3:setPosition(x, y)
    _score3:setProperty(tostring(jin),"png/guoshiplist.png", 30, 42, "0")
     local function logSprRotation(sender)
                     _score3 :setVisible(false)                   
     end
     local  move1=cc.MoveTo:create(1, cc.p( x+120,y ) )
     local action = cc.Sequence:create(move1,cc.CallFunc:create(logSprRotation))
     _score3:stopAllActions()
     _score3:runAction(action)
end

 --加经收获果实动画
function GrowingtreeScene:fun_harvest_number(_number,x,y)
    print("动画",x,"  ",y)
    -- if tonumber(_number)  <=  0 then
    --  return
    -- end

    self._score1 :setVisible(true)
    self._score1:setPosition(x, y)
    self._score1:setProperty(tostring(_number),"png/guoshiplist.png", 30, 42, "0")
     local function logSprRotation(sender)
                     self._score1 :setVisible(false)                   
     end
     local  move1=cc.MoveTo:create(1, cc.p( x-120,y ) )
     local action = cc.Sequence:create(move1,cc.CallFunc:create(logSprRotation))
     self._score1:stopAllActions()
     self._score1:runAction(action)
end
--  果实上下浮动动画
function GrowingtreeScene:fun_move_act(_obj,x,y)
     
     local  move1=cc.MoveTo:create(1, cc.p( x,y+6 ) )
     local  move2=cc.MoveTo:create(1, cc.p( x,y-2 ) )
     local action = cc.RepeatForever:create(cc.Sequence:create(move1,move2))
     _obj:stopAllActions()
     _obj:runAction(action)
end
function GrowingtreeScene:fun_move_act_yun(_obj,y)
  local _ps=0
     if y==0 then
       _ps=1136
      else
        _ps=0
     end
     self.back_huijia_bt:setTouchEnabled(false)
      local function stopAction()
         _obj:setPositionY(y)
          self.back_huijia_bt:setTouchEnabled(true)
      end 
      _obj:setPositionY(_ps)
      local callfunc = cc.CallFunc:create(stopAction)
     local  move1=cc.MoveTo:create(3, cc.p(_obj:getPositionX(),_ps ) )
     local  move2=cc.MoveTo:create(1, cc.p(_obj:getPositionX(),y ))
     local action = cc.Sequence:create(move2,callfunc)
     _obj:stopAllActions()
     _obj:runAction(action)
end

function GrowingtreeScene:onEnter()
 --初始化成长树
  NotificationCenter:Instance():AddObserver("MESSAGE_GETTREELIST", self,
                       function()
                       	--Server:Instance():Grawpopup_box_buffer("成功施肥")--测试
			     self:fun_data()
                        local function stopAction()
                                Util:player_music_hit("PERSONALCHAGE",true )         
                        end
                        local callfunc = cc.CallFunc:create(stopAction)
                       self:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))

                      end)
  --好友列表
  NotificationCenter:Instance():AddObserver("MESSAGE_GETTREEFRIENDLIST", self,
                       function()  
                              -- self:fun_UIListView()
                               local gettreefriendlist=LocalData:Instance():get_gettreefriendlist()
                               local _list=gettreefriendlist["list"]
                               -- if #_list ==  0 and self._friend_employees_type==1 then
                               --    self.pv:setVisible(true)
                               --     return
                               -- end
                              self:createPageView()
                      end)
  --背包列表
  NotificationCenter:Instance():AddObserver("MESSAGE_GSTTREEGAMEITEMLIST", self,
                       function()  
                              self:fun_backpack_list()
                              self._growingtreeNode:setPositionX(-220)
                              if self.pv then
                                    self.pv:setVisible(false)
                              end
                    self.friend_growingtree_checkbox:setPositionY(self._spdt)
                              
                      end)
  --种植成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDPLANT", self,
                       function()  
                              Server:Instance():gettreelist(self.back_playerid)
                              self.pt_tag_table=0
                              self.ListNode:setVisible(false)
                              self._deng_act:setVisible(false)
                              self._growingtreeNode:setPositionX(0)
                              self.friend_growingtree_checkbox:setPositionY( self._spdt-40)
                              self.friend_growingtree_checkbox:setSelected(true) 
                              self._friend_employees_type=1
                               if self.pv then
                                        self.pv:setVisible(true)
                              end


                      end)
  --种植不成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDPLANT_FALSE", self,
                       function()  
                              self.pt_tag_table=0
                              self.ListNode:setVisible(false)
                      end)
  --施肥成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDMANURE", self,
                       function()  
                              local _setseedmanure=LocalData:Instance():get_setseedmanure()--
                               local jin=0
                              if #_setseedmanure["rewardlist"]  >0  then
                                      for i=1,#_setseedmanure["rewardlist"] do
                                          if _setseedmanure["rewardlist"][i]["type"]   ==  0    then  --  0经验  1  金币
                                            jin=_setseedmanure["rewardlist"][i]["reward"]
                                          self.gold_dishu_jia:setTexture("png/chengzhangshu-touxiang-jingyan-icon.png")
                                          elseif _setseedmanure["rewardlist"][i]["type"]   ==  1 then
                                             jin=_setseedmanure["rewardlist"][i]["reward"]
                                            self.gold_dishu_jia:setTexture("png/chengzhangshu-touxiang-jingbi-icon.png")
                                          end
                                        end
                              
                              end
                              self._deng_act_img:loadTexture("png/chengzhangshu-1-touming.png")
                              Server:Instance():gettreelist(self.back_playerid)
                              self.ListNode:setVisible(false)
                              self:fun_FruitinformationNode(1,1,false,-1)
                              self.pt_tag_table=0
                              self:coinAction(jin,self._obj_act:getParent():getPositionX()   ,self._obj_act:getParent():getPositionY()-30)
                              self._obj_act=nil

                              --self._deng_act:setVisible(false)
                              self._growingtreeNode:setPositionX(0)
                              self.friend_growingtree_checkbox:setPositionY( self._spdt-40)
                              self.friend_growingtree_checkbox:setSelected(true) 
                              self._friend_employees_type=1
                               if self.pv then
                                        self.pv:setVisible(true)
                              end
                      end)
  --施肥不成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDMANURE_FALSE", self,
                       function()  
                              self:fun_FruitinformationNode(1,1,false,-1)
                              self.ListNode:setVisible(false)

                                if self.back_playerid  ==  nil then
                                            self._growingtreeNode:setPositionX(0)
                                            self.friend_growingtree_checkbox:setPositionY( self._spdt-40)
                                            self.friend_growingtree_checkbox:setSelected(true) 
                                            self._friend_employees_type=1
                                             if self.pv then
                                                      self.pv:setVisible(true)
                                            end
                               end
                             
                      end)
  --  收获成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREWARD", self,
                       function()  
                              local _setseedreward=LocalData:Instance():get_setseedreward()--
                               local jin=0
                               local num=0
                               self._deng_act_img:loadTexture("png/chengzhangshu-zhong-di-suo.png")

                              if  _setseedreward["rewardlist"] and #_setseedreward["rewardlist"]  >0  then
                                -- if self.back_playerid  ~=  nil then
                                --      num=_setseedreward["stolengainsamountperPlayer"]
                                -- else
                                     num=_setseedreward["rewardamount"]
                                --end
                                 

                                      for i=1,#_setseedreward["rewardlist"] do
                                           if _setseedreward["rewardlist"][i]["type"]   ==  0    then  --  0经验  1  金币
                                            jin=_setseedreward["rewardlist"][i]["reward"]
                                          
                                          self:coinAction1(jin,self._obj_act:getParent():getPositionX()  ,self._obj_act:getParent():getPositionY()-30)
                                          self.gold_dishu_jia1:setTexture("png/chengzhangshu-touxiang-jingyan-icon.png")
                                          -- elseif _setseedreward["rewardlist"][i]["type"]   ==  1 then
                                          --    jin=_setseedreward["rewardlist"][i]["reward"]
                                           
                                          --   self:coinAction1(jin,self._obj_act:getParent():getPositionX()-100  ,self._obj_act:getParent():getPositionY()-30)
                                          --    self.gold_dishu_jia1:setTexture("png/chengzhangshu-touxiang-jingbi-icon.png")
                                          -- elseif _setseedreward["rewardlist"][i]["type"]   ==  2 then  --  道具
                                          --    jin=_setseedreward["rewardlist"][i]["reward"]
                                           
                                          --   self:coinAction1(jin,self._obj_act:getParent():getPositionX()-150  ,self._obj_act:getParent():getPositionY()-30)
                                          --  self.gold_dishu_jia1:setTexture("png/chengzhangshu-touxiang-zuanshi-icon.png")
                                          end
                                        end
                              
                              end

                              self.pt_tag_table=0
                              Server:Instance():gettreelist(self.back_playerid)
                              --self:coinAction(jin,self._obj_act:getParent():getPositionX()  ,self._obj_act:getParent():getPositionY()-30)
                              self:fun_harvest_number(num,self._obj_act:getParent():getPositionX()  ,self._obj_act:getParent():getPositionY()-30)
                              self._obj_act=nil

                      end)
  --  收获不成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREWARD_FALSE", self,
                       function()  
                              
                              self.pt_tag_table=0

                      end)
  --浇水成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDWATER", self,
                       function()  
                              local _setseedwater= LocalData:Instance():get_setseedwater()--
                              local jin=0
                              if #_setseedwater["rewardlist"]  >0  then
                                      for i=1,#_setseedwater["rewardlist"] do
                                          if _setseedwater["rewardlist"][i]["type"]   ==  0    then  --  0经验  1  金币
                                            jin=_setseedwater["rewardlist"][i]["reward"]
                                          self.gold_dishu_jia:setTexture("png/chengzhangshu-touxiang-jingyan-icon.png")
                                          elseif _setseedwater["rewardlist"][i]["type"]   ==  1 then
                                             jin=_setseedwater["rewardlist"][i]["reward"]
                                            self.gold_dishu_jia:setTexture("png/chengzhangshu-touxiang-jingbi-icon.png")
                                          end
                                        end

                              end
                             self._deng_act_img:loadTexture("png/chengzhangshu-1-touming.png")
                              Server:Instance():gettreelist(self.back_playerid)
                              self:coinAction(jin,self._obj_act:getParent():getPositionX()  ,self._obj_act:getParent():getPositionY()-30)
                              self._obj_act=nil
                      end)
  --铲除成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREMOVE", self,
                       function()  
                        self._deng_act_img:loadTexture("png/chengzhangshu-1-touming.png")
                              self:fun_FruitinformationNode(1,1,false,-1)
                              self.pt_tag_table=0
                              self:unscheduleUpdate()
                              Server:Instance():gettreelist(self.back_playerid)
                              
                      end)
end

function GrowingtreeScene:onExit()
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GETTREELIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GETTREEFRIENDLIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GSTTREEGAMEITEMLIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDPLANT", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDMANURE", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDMANURE_FALSE", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDPLANT_FALSE", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDREWARD", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDWATER", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDREMOVE", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDREWARD_FALSE", self)
      
      cc.Director:getInstance():getTextureCache():removeAllTextures() 
     	
end

function GrowingtreeScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 
function GrowingtreeScene:push_buffer(is_buffer)
	print("·push_buffer··,",is_buffer)
        self.floating_layer:show_http(false) 
end 
function GrowingtreeScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end 
function GrowingtreeScene:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function GrowingtreeScene:Grawpopup_buffer(prompt_text)
       self.floating_layer:fun_Grawpopup(prompt_text) 
end
function GrowingtreeScene:function_template(data)
            ScrollViewMenu=require("app.scenes.ScrollViewMenu")
            local function touchEvent(sender,eventType)             
              if eventType == ccui.TouchEventType.ended then
                          print("button模板")
              end

            end
            -- local _image= string.lower(tostring(Util:sub_str(data["imageUrl"], "/",":")))  
            -- local _name=data["nickname"]
            -- local _lv=data["treegrade"]
              if tonumber(data["flag"]) ==  0 then  --  1是好友   0  是自己 
                  GREEN_SMALL_BTN_IMG = {
                normal = "png/chengzhangshu-1-touxiang-kuang-3-1.png",
                pressed = "png/chengzhangshu-1-touxiang-kuang-3-1.png",
                disabled = "png/chengzhangshu-1-touxiang-kuang-3-1.png"
            }
          else
            GREEN_SMALL_BTN_IMG = {
                normal = "png/chengzhangshu-1-touxiang-kuang-1-1.png",
                pressed = "png/chengzhangshu-1-touxiang-kuang-2-1.png",
                disabled = "png/chengzhangshu-1-touxiang-kuang-1-1.png"
            }
              end
            
            local button = require("app.scenes.ScrollViewMenu").new(GREEN_SMALL_BTN_IMG)
            :onButtonClicked(function(sender,event)
                          if tonumber(data["flag"])  ==  100  then
                                   local InvitefriendsLayer = require("app.layers.InvitefriendsLayer")  --邀请好友排行榜
                                    self:addChild(InvitefriendsLayer.new(),1,13)
                                  return
                          end
                        self.touch_image:setVisible(true)
                        self:fun_move_act_yun(self.left_image,self.left_image:getPositionY())
                        self:fun_move_act_yun(self.right_image,self.right_image:getPositionY())
                       --   local function stopAction()
                                
                       --  end
                       --  local callfunc = cc.CallFunc:create(stopAction)
                       -- self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),callfunc  ))

                         self.touch_image:setVisible(false)
                          self.is_friend=true
                          --LocalData:Instance():set_gettreelist(nil)
                          Server:Instance():gettreelist(data["playerid"])
                          self.back_playerid=data["playerid"]
                          self._growingtreeNode:setPositionX(-220)
                          self.friend_growingtree_checkbox:setPositionY(self._spdt)
                          if self.pv then
                          self.pv:setVisible(false)
                          end
                          self.back_huijia_bt:setVisible(true)
                          self.back_bt:setVisible(false)
                          self.friend_growingtree_checkbox:setSelected(false)   
                          self.friend_growingtree_checkbox:setVisible(false)   


            end)
            --ScrollViewMenu() --ccui.Button:create()
            button:setRotation(90)
            button:setTouchEnabled(true)
             if tonumber(data["flag"])  ==  100  then
                    local textButton = ccui.Button:create()
                    textButton:setTouchEnabled(false)
                    textButton:loadTextures("png/chengzhangshu-1-touxiang-kuang-1-1.png", "png/chengzhangshu-1-touxiang-kuang-2-1.png", "")
                    textButton:setPosition(cc.p(0, 0))
                    textButton:addTouchEventListener(touchEvent)
                    button:addChild(textButton)

                    local  friend_image_water = cc.Sprite:create("png/chengzhangshu-1-touxiang-kuang-tianjia.png")
                    friend_image_water:setPosition(0,15)  --  -10
                    button:addChild(friend_image_water)

                     local friend_name_text=ccui.Text:create()
                    friend_name_text:setColor(cc.c3b(160,105,5))
                    --Lv_text:setString("等级")
                    friend_name_text:setFontSize(20)
                    friend_name_text:setString("添加好友")
                    friend_name_text:setFontName("png/chuti.ttf")
                    friend_name_text:setPosition(0,-40)
                    button:addChild(friend_name_text)



                    return button
            end
            --dump(button:getContentSize())
             if tonumber(data["flag"]) ==  0 then 
                button:setTouchEnabled(false)
             end
            
              local _image_data= string.lower(tostring(Util:sub_str(data["imageUrl"], "/",":")))  --  头像
              local _name_data=data["nickname"]  -- 昵称
              local _lv_data=data["treegrade"]  --等级
              local _drycount_data=data["drycount"]  --水壶  0不是需要
              local _gaincount_data=data["gaincount"]  --收获 0不是需要


            local  _image = cc.Sprite:create("png/"..  _image_data)
            _image:setPosition(0,15 )
            _image:setScale(0.55)
            button:addChild(_image)

            local  _image_water = cc.Sprite:create("png/chengzhangshu-shuihu-xiao-di.png")
            _image_water:setPosition(18,-43)  --  -10
            button:addChild(_image_water)
            if tonumber(_drycount_data) > 0 then
              _image_water:setTexture("png/chengzhangshu-shuihu-xiao.png")
            end

            local  _image_reward = cc.Sprite:create("png/chengzhangshu-shou-1-xiao-di.png")
            _image_reward:setPosition(-18,-43)
            button:addChild(_image_reward)
            if tonumber(_gaincount_data)  >  0 then
              _image_reward:setTexture("png/chengzhangshu-shou-1-xiao.png")
            end

             local buttonScale9Sprite = cc.Sprite:create("png/chengzhangshu-1-touxiang-tiao.png")
            buttonScale9Sprite:setScale(2.7,1.5)
            --buttonScale9Sprite:setContentSize(cc.size(95,13))
            buttonScale9Sprite:setPosition(0,-17)
            button:addChild(buttonScale9Sprite)

            local  Lv_image = cc.Sprite:create("png/chengzhangshu--shuzi-LV.png")
            Lv_image:setPosition(-7,-16)
            button:addChild(Lv_image)

            local  Lv_text =   ccui.TextAtlas:create((tostring(_lv_data)),"png/treefontPlist.png", 12, 15, "0")
            Lv_text:setPosition(7,-16)
            Lv_text:setAnchorPoint(0,0.5)
            button:addChild(Lv_text)


            local name_text=ccui.Text:create()
            name_text:setColor(cc.c3b(163,35,0))
            --Lv_text:setString("等级")
            name_text:setFontSize(15)
            name_text:setString(tostring(_name_data))
            name_text:setFontName("png/chuti.ttf")
            name_text:setPosition(0,55)
            button:addChild(name_text)
            

            -- local  _image = cc.Sprite:create("png/"  ..  _image)
            -- _image:setPosition(button:getContentSize().width/2,button:getContentSize().height/2)
            -- _image:setScale(0.65)
            -- button:addChild(_image,-1,10)

            -- local name=ccui.Text:create()
            -- name:setColor(cc.c3b(0,0,0))
            -- name:setFontSize(18)
            -- --name:setString("拼乐")
            -- name:setString(tostring(_name))
            -- name:setPosition(button:getContentSize().width/2,-40)
            -- button:addChild(name,1,20)

            -- local Lv_text=ccui.Text:create()
            -- Lv_text:setColor(cc.c3b(0,0,0))
            -- --Lv_text:setString("等级")
            -- Lv_text:setFontSize(18)
            -- Lv_text:setString(tostring(_lv))
            -- Lv_text:setPosition(button:getContentSize().width/5,button:getContentSize().height)
            -- button:addChild(Lv_text,1,30)

            return button
end

function GrowingtreeScene:function_button_Refresh(data,button)
  local function touchEvent(sender,eventType)
                         
                if eventType == ccui.TouchEventType.ended then
                            print("button模板")
                end
            end
            local _image= string.lower(tostring(Util:sub_str(data["imageUrl"], "/",":")))  
            local _name=data["nickname"]
            local _lv=data["playergrade"]

            button:getChildByTag(10):setTexture("png/"  ..  _image)
            button:getChildByTag(20):setString(tostring(_name))
            button:getChildByTag(30):setString(tostring(_lv))
end


--list view  控件使用

function GrowingtreeScene:touchListener(event)
  
end


function GrowingtreeScene:createPageView()

    self.pv = require("app.scenes.UIPageViewVertical").new({
        viewRect = cc.rect(26,238,126,756) ,  --设置位置和大小
        -- viewRect = cc.rect(80,280,108,108) ,
        column = 1 , row = 1,  --列和行的数量 
        page_rect_num=6,
        contSize=cc.size(122,126),                 
        padding = {left = 0 , right = 0 , top = 0 , bottom = 0} , --整体的四周距离
        columnSpace = 0 , rowSpace = 0                                        --行和列的间距
    })
    :onTouch(handler(self,self.touchListener))
    :addTo(self.Growingtree)   --  self._growingtreeNode  Growingtree


  
     -- local  move1=cc.MoveTo:create(1, cc.p(246,0 ) )
     -- self.pv:stopAllActions()
     -- self.pv:runAction(move1)




     local gettreefriendlist=LocalData:Instance():get_gettreefriendlist()
    self._list=gettreefriendlist["list"]
--  等级排序
    local tmp = {}  
    for i=1,#self._list-1 do  
        for j=1,#self._list-i do  
            if self._list[j]["treegrade"] < self._list[j+1]["treegrade"]  then  
                tmp = self._list[j]  
                self._list[j] = self._list[j+1]  
                self._list[j+1] = tmp  
            end  
        end  
    end  
    
    for i = 1 , #self._list do
        local item = self.pv:newItem()
        local node=self:function_template(self._list[i])
        item:setContentSize(122, 126)
        item:addChild(node)      -- 为每个单独的item添加一个颜色图块
        self.pv:addItem(item)          --为pageview添加item
    end
    
    if #self._list<7   and   self._friend_employees_type==1  then
      local _shu={flag = 100}
      for i=#self._list +1 ,7 do
        local item = self.pv:newItem()
        local node=self:function_template(_shu)
        item:setContentSize(122, 126)
        item:addChild(node)      -- 为每个单独的item添加一个颜色图块
        self.pv:addItem(item) 
      end
    end
    self.pv:reload()    --需要重新刷新才能显示
          
end


return GrowingtreeScene



