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
       self.lv_table={2,3,3,4,4,5,6,6,7,8}
       self.pt_table={}  --  8个坑的表
       self.pt_tag_table=0  --  默认标记0 
       self._type_str_text=   nil
       self.scroll_listview=  nil
       self.is_friend=false
       --  定时器
       self.count_time=0
       self.secondOne=0
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
              self:update(dt)
            end)

       self.back_seedplant_seedmanure=" "  --  区别是种植接口还是施肥接口
       self:init()
       Server:Instance():gettreelist(self.back_playerid)--   成长树初始化接口     
       self.pt_tag_obj=nil  
      -- self:ve()
end
function GrowingtreeScene:ve(  )
              self.ceshi = cc.CSLoader:createNode("ceshi.csb");
              self:addChild(self.ceshi)


              self.PageView_head=self.ceshi:getChildByTag(3135)
               self.PageView_head:setRotation(90)
              local Panel=self.PageView_head:getChildByTag(3136)
               for i=1,7 do
                    local  call=Panel:clone() 
                    self.PageView_head:addPage(call)
                  end


end
function GrowingtreeScene:init(  )
	
	self.Growingtree = cc.CSLoader:createNode("Growingtree.csb");
    	self:addChild(self.Growingtree)

    	for i=1,8 do
    		self.pt_table[i]=self.Growingtree:getChildByTag(3248+i):getChildByTag(103+i)  -- 8个坑
    	end
      self._fertilization_template=self.Growingtree:getChildByTag(5391)  -- 施肥信息模板
	local back_bt=self.Growingtree:getChildByTag(84)  -- 返回
	back_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	            	return
	             end 
                  if self.is_friend   then
                      self.back_playerid=nil
                      self.is_friend=false
                      Server:Instance():gettreelist(self.back_playerid)
                      self.friend_growingtree_checkbox:setVisible(true)
                      return
                  end
                  
		Util:scene_control("MainInterfaceScene")
	end)

    	self._growingtreeNode=self.Growingtree:getChildByTag(56)  -- 好友列表栏
    	self.friend_growingtree_checkbox=self._growingtreeNode:getChildByTag(163)  --  好友按钮
    	self.friend_growingtree_checkbox:setTouchEnabled(true)

    	self.friend_growingtree_checkbox:addEventListener(function(sender, eventType  )
                           if eventType == ccui.CheckBoxEventType.selected then
                                  self._growingtreeNode:setPositionX(0)
                                  Server:Instance():gettreefriendlist(20,1,1)
                                  for i=1,8 do
                                    self.pt_table[i]:setTouchEnabled(false)
                                  end
                           elseif eventType == ccui.CheckBoxEventType.unselected then
                                  self._growingtreeNode:setPositionX(-220)
                                  for i=1,8 do
                                    self.pt_table[i]:setTouchEnabled(true)
                                  end
                                  if self.scroll_listview then
                                    self.scroll_listview:setVisible(false)
                                  end
                           end
            end)

    	local add_friend_bt=self._growingtreeNode:getChildByTag(281)  -- 添加好友
	add_friend_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	end)
	
	  local refresh_bt=self._growingtreeNode:getChildByTag(41)  --左移一格
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self._growingtreeNode:getChildByTag(42)  --右移一格
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self._growingtreeNode:getChildByTag(43)  --左移一列
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self._growingtreeNode:getChildByTag(44)  --右移一列
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self._growingtreeNode:getChildByTag(46)  --邀请好友按钮
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
function GrowingtreeScene:fun_data()
	
    	for i=1,8 do
    		self.pt_table[i]:loadTexture("png/chengzhangshu-zhong-di-suo.png")
    		self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+498):setVisible(false)
    	end

	 local gettreelist = LocalData:Instance():get_gettreelist()
	  self.z_treeid=gettreelist["list"][1]["treeid"]  --目前默认只有一棵树

	 local experience_text=self.Growingtree:getChildByTag(87)  --经验值
	 experience_text:setString(gettreelist["treeExp"])

	 local gold_text=self.Growingtree:getChildByTag(88)  --金币值
	 gold_text:setString(gettreelist["golds"])

	 local diamond_text=self.Growingtree:getChildByTag(89)  --钻石值
	 diamond_text:setString(gettreelist["diamondnum"])

	 local head_bt=self.Growingtree:getChildByTag(85)  --自己头像框按钮
	 head_bt:setTouchEnabled(false)
	 head_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	           print("自己头像框按钮")
	  end)

	 local head_image=self.Growingtree:getChildByTag(86)  --自己头像
	 print("头像  ",tostring(Util:sub_str(gettreelist["imageUrl"], "/",":")))
	 head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(gettreelist["imageUrl"], "/",":"))))

	 local name_text=self.Growingtree:getChildByTag(90)  --自己名字
	 name_text:setString(gettreelist["nickname"])

      local Lv_img=self.Growingtree:getChildByTag(3259)  --等级
      Lv_img:setVisible(false)
      local  Lv_text =   ccui.TextAtlas:create((tostring(gettreelist["treegrade"])),"png/treefontPlist.png", 12, 15, "0")
      Lv_text:setPosition(cc.p(Lv_img:getPositionX(),Lv_img:getPositionY()))
      Lv_text:setRotation(90)
      Lv_text:setAnchorPoint(0,0.5)
      self.Growingtree:addChild(Lv_text)



	local tree_seedlist = gettreelist["list"][1]["seedlist"]

      local _treegrade=0
	 if tonumber(gettreelist["treegrade"]) > 0 then  --  缺等级表
            _treegrade=self.lv_table[tonumber(gettreelist["treegrade"])]
	 	for i=1,_treegrade do
    			self.pt_table[i]:setTouchEnabled(true)

    			self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+498):setString("可种植")
    			self.pt_table[i]:getChildByTag(self.pt_table[i]:getTag()+498):setVisible(true)
    			self.pt_table[i]:loadTexture("png/chengzhangshu-zhongzi-0.png")
    			self.pt_table[i]:addTouchEventListener(function(sender, eventType  )
			            if eventType ~= ccui.TouchEventType.ended then
			                return
			            end 
                             if self.pt_tag_table   ~=   0 then
                                  if   self.pt_tag_table ~=sender:getTag()  then    
                                             
                                               return
                                  else
                                            self.friend_growingtree_checkbox:setTouchEnabled(true)
                                            self.pt_tag_table=0
                                            
                                            return
                                  end
                            end
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
			            self._growingtreeNode:setPositionX(-220)
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
     dump(tree_seedlist)
	 if not tree_seedlist  or   #tree_seedlist  ==  0 then
	 	return
	 end
	 for i=1,#tree_seedlist do
	 	for j=1,8 do
	 		if tostring(tree_seedlist[i]["seedname"]) == tostring(self.zh_state[j]) then
	 			if tostring(tree_seedlist[i]["seedstatus"]) ==  "2"  then   --收获
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setString("可收获")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setVisible(false)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):loadTexture("png/chengzhangshu-shou-1.png")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):setVisible(true)
	 				self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/"  .. self.zh_stateimage2[j] )
	 			elseif  tostring(tree_seedlist[i]["seedstatus"]) ==  "4" or tostring(tree_seedlist[i]["seedstatus"]) ==  "3"  then  --  死亡
	 				self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/chengzhangshu-zhong-di-suo.png")
	 			elseif tostring(tree_seedlist[i]["seedstatus"]) ==  "0" then  --  干旱  浇水
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setString("可浇水")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setVisible(false)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):loadTexture("png/chengzhangshu-shuihu.png")
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+359):setVisible(true)
                              self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/"  .. self.zh_stateimage1[j] )
                        else
	 				self.pt_table[tree_seedlist[i]["seatcount"]]:loadTexture("png/"  .. self.zh_stateimage1[j] )
                              self.pt_table[tree_seedlist[i]["seatcount"]]:getChildByTag(self.pt_table[tree_seedlist[i]["seatcount"]]:getTag()+498):setVisible(false)
	 			      
                        end
	 			self.pt_table[tree_seedlist[i]["seatcount"]]:setTouchEnabled(true)
                        
	 			self.pt_table[tree_seedlist[i]["seatcount"]]:addTouchEventListener(function(sender, eventType  )
				            if eventType ~= ccui.TouchEventType.ended then
				                return
				            end 
                                    if self.pt_tag_table   ~=   0 then
                                          if   self.pt_tag_table ~=sender:getTag()  then
                                                       
                                                       return
                                          else
                                                    self.friend_growingtree_checkbox:setTouchEnabled(true)
                                                    self.pt_tag_table=0
                                                     for w=1,#tree_seedlist do
                                                           if tonumber(tree_seedlist[w]["seatcount"] )== sender:getTag()-103 then
                                                                self:fun_FruitinformationNode(sender:getParent():getPositionX(),sender:getParent():getPositionY(),false,w) 
                                                                self:unscheduleUpdate()
                                                          end
                                                      end
                                                    
                                                    return
                                          end

                                    end
                                    self.friend_growingtree_checkbox:setTouchEnabled(false)
                                    self.pt_tag_table=sender:getTag()
                                    -- print("种植1")
                                   dump(tree_seedlist)
                                    for z=1,#tree_seedlist do
                                      if tonumber(tree_seedlist[z]["seatcount"] )== sender:getTag()-103 then  --  所需要的TAG
                                            self.z_seedid= tree_seedlist[z]["seedid"]
                                            if tonumber(tree_seedlist[z]["seedstatus"] )==1 then  --  正常成长状态
                                               self:fun_FruitinformationNode(sender:getParent():getPositionX(),sender:getParent():getPositionY(),true,z)  --  只是测试
                                               self:scheduleUpdate()
                                            elseif tonumber(tree_seedlist[z]["seedstatus"] )==2 then  --  收获
                                              local _istouch=true
                                                self.floating_layer:fun_Grawpopup("作物已经收获,真的收获吗",function (sender, eventType)
                                                               
                                                                if eventType==1  and _istouch  then
                                                                     print("收获")
                                                                     _istouch=false
                                                                     Server:Instance():setseedreward(self.z_treeid,self.z_seedid)
                                                                end                
                                                end)  
                                            elseif tonumber(tree_seedlist[z]["seedstatus"] )==0 then  --  干旱
                                 
                                                self.floating_layer:fun_Grawpopup("作物已经干旱,真的浇水吗",function (sender, eventType)
                                                                if eventType==1  then
                                                                     print("浇水")
                                                                    
                                                                     Server:Instance():setseedwater(self.z_treeid,self.z_seedid)
                                                                end                
                                                end)  

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
                        print("开始")
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
          	    print("添加好友")
                 local InvitefriendsLayer = require("app.layers.InvitefriendsLayer")  --邀请好友排行榜
                 self:addChild(InvitefriendsLayer.new(),1,13)
           elseif tag==41 then
           	   print("左移一格")
           	elseif tag==42 then
           	   print("右移一格")
           	elseif tag==43 then
           	   print("左移一列")
           	elseif tag==44 then
           	   print("右移一列")
           	elseif tag==46 then
           	   print("邀请好友")
               Util:share()
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
             Server:Instance():gettreefriendlist(20,1,1)
              if self.scroll_listview then
                self.scroll_listview:setVisible(false)
              end
          elseif tag==53 then
          	  print("我的员工按钮")
              Server:Instance():gettreefriendlist(20,1,2)
               if self.scroll_listview then
                  self.scroll_listview:setVisible(false)
                end
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
   dump(back_seed_state)
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
      tile_des:setString(self.seed_information["tile_des"])
      self.Loadingbar_infor=self._fruitinformation_bg:getChildByTag(2429)  --  LoadingBar 
      self.Loadingbar_infor:setPercent(tonumber(self.seed_information["seed_percentage"])  * 100 )
      local _image=self._fruitinformation_bg:getChildByTag(2425)  --  样图
      _image:loadTexture("png/"  ..  self.seed_information["seed_image"])

	local remove=self._fruitinformation_bg:getChildByTag(1074)  --  铲除
	remove:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                               self.floating_layer:fun_Grawpopup("作物还没有收获,真的铲除吗",function (sender, eventType)
                                              if eventType==1 then
                                                   Server:Instance():setseedremove(self.z_treeid,self.z_seedid)
                                              end                
                              end)  
            end)

	local fertilization=self._fruitinformation_bg:getChildByTag(1075)  --  施肥
	fertilization:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                              print("施肥")
                              self.back_seedplant_seedmanure="施肥"  --  区别是种植接口还是施肥接口
                              Server:Instance():gettreegameitemlist(1 )  --  施肥接口
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
                    self._growingtreeNode:setPositionX(-220)
                    for i=1,8 do
                      self.pt_table[i]:setTouchEnabled(true)
                    end
                     if self.scroll_listview then
                      self.scroll_listview:setVisible(false)
                    end
                    self.friend_growingtree_checkbox:setSelected(false) 
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
function GrowingtreeScene:onEnter()
 --初始化成长树
  NotificationCenter:Instance():AddObserver("MESSAGE_GETTREELIST", self,
                       function()
                       	--Server:Instance():Grawpopup_box_buffer("成功施肥")--测试
			self:fun_data()
                      end)
  --好友列表
  NotificationCenter:Instance():AddObserver("MESSAGE_GETTREEFRIENDLIST", self,
                       function()  
                              self:fun_UIListView()
                      end)
  --背包列表
  NotificationCenter:Instance():AddObserver("MESSAGE_GSTTREEGAMEITEMLIST", self,
                       function()  
                              self:fun_backpack_list()
                              
                      end)
  --种植成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDPLANT", self,
                       function()  
                              Server:Instance():gettreelist(self.back_playerid)
                              self.pt_tag_table=0
                              self.ListNode:setVisible(false)
                      end)
  --种植不成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDPLANT_FALSE", self,
                       function()  
                              
                              self.ListNode:setVisible(false)
                      end)
  --施肥成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDMANURE", self,
                       function()  
                              Server:Instance():gettreelist(self.back_playerid)
                              self.ListNode:setVisible(false)
                              self:fun_FruitinformationNode(1,1,false,1)
                              self.pt_tag_table=0
                      end)
  --施肥不成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDMANURE_FALSE", self,
                       function()  
                              
                              self.ListNode:setVisible(false)

                      end)
  --  收获成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREWARD", self,
                       function()  
                              self.pt_tag_table=0
                              Server:Instance():gettreelist(self.back_playerid)

                      end)
  --  收获不成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREWARD_FALSE", self,
                       function()  
                              
                              self.pt_tag_table=0

                      end)
  --浇水成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDWATER", self,
                       function()  
                              
                              Server:Instance():gettreelist(self.back_playerid)
                      end)
  --铲除成功
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREMOVE", self,
                       function()  
                              self:fun_FruitinformationNode(1,1,false,1)
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
  self.back_playerid=data["playerid"]
  ScrollViewMenu=require("app.scenes.ScrollViewMenu")
  local function touchEvent(sender,eventType)
                         
                if eventType == ccui.TouchEventType.ended then
                            print("button模板")
                end
            end
            local _image= string.lower(tostring(Util:sub_str(data["imageUrl"], "/",":")))  
            local _name=data["nickname"]
            local _lv=data["playergrade"]

            GREEN_SMALL_BTN_IMG = {
          normal = "png/chengzhangshu-1-touxiang-kuang-1-1.png",
          pressed = "png/chengzhangshu-1-touxiang-kuang-2-1.png",
          disabled = "png/chengzhangshu-1-touxiang-kuang-1-1.png"
      }

      local button = require("app.scenes.ScrollViewMenu").new(GREEN_SMALL_BTN_IMG)
      :onButtonClicked(function(event)
                            self.is_friend=true
                            --LocalData:Instance():set_gettreelist(nil)
                             Server:Instance():gettreelist(self.back_playerid)
                             self._growingtreeNode:setPositionX(-220)
                            if self.scroll_listview then
                              self.scroll_listview:setVisible(false)
                            end
                            self.friend_growingtree_checkbox:setSelected(false)   
                            self.friend_growingtree_checkbox:setVisible(false)           
             end)
             --ScrollViewMenu() --ccui.Button:create()
      button:setRotation(90)
            button:setTouchEnabled(true)
            -- button:loadTextures("png/chengzhangshu-di-1-haoyou-3.png", "png/chengzhangshu-di-1-haoyou-2.png", "")
            -- button:setPosition(cc.p(200,280))
            -- button:addTouchEventListener(touchEvent)
            --self:addChild(button)
            -- local  _image = cc.Sprite:create("png/chengzhangshu-di-1-haoyou-1.png")
            -- button:onButtonClicked(function(event) end)

            local  _image = cc.Sprite:create("png/"  ..  _image)
            _image:setPosition(button:getContentSize().width/2,button:getContentSize().height/2)
            _image:setScale(0.65)
            button:addChild(_image,-1,10)

            local name=ccui.Text:create()
            name:setColor(cc.c3b(0,0,0))
            name:setFontSize(18)
            --name:setString("拼乐")
            name:setString(tostring(_name))
            name:setPosition(button:getContentSize().width/2,-40)
            button:addChild(name,1,20)

            local Lv_text=ccui.Text:create()
            Lv_text:setColor(cc.c3b(0,0,0))
            --Lv_text:setString("等级")
            Lv_text:setFontSize(18)
            Lv_text:setString(tostring(_lv))
            Lv_text:setPosition(button:getContentSize().width/5,button:getContentSize().height)
            button:addChild(Lv_text,1,30)

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

function GrowingtreeScene:fun_UIListView()
  --(display.width - 594) / 2

   local gettreefriendlist=LocalData:Instance():get_gettreefriendlist()
  self._list=gettreefriendlist["list"]

    self.scroll_node = display.newNode()
   local scroll_bound = cc.rect(14  ,display.cy-92,126, 610)--+display.cy-236  14
   -- end
   self.scroll_listview = cc.ui.UIListView.new({viewRect = scroll_bound,
                     direction = cc.ui.UIListView.DIRECTION_VERTICAL,
                     async = true,
                     --bgColor = cc.c4b(255,0, 0,200),
                     container = self.scroll_node})
   self.scroll_listview:setDelegate(handler(self, self.sourceDelegate))
   self.scroll_listview:onScroll(handler(self, self.scrollListener))
   self.scroll_listview:setPosition(15,0)--display.cy-236
   self.scroll_listview:addTo(self.Growingtree,100)
   self.scroll_listview:reload()

  
end

function GrowingtreeScene:sell()
  self.next_dex=self.next_dex+1
    self:layout_sub(1)
end 

function GrowingtreeScene:sellto()
  self.next_dex=self.next_dex+1
    self:layout_sub(-1)
end 


function GrowingtreeScene:scrollListener(event)
   
end


function GrowingtreeScene:sourceDelegate(listView, tag, idx)

   if cc.ui.UIListView.COUNT_TAG == tag then
     return #self._list--self.star_idx
   elseif cc.ui.UIListView.CELL_TAG == tag then
      local item
      item = self.scroll_listview:dequeueItem()
      
      local _list=self._list
 
      if not item then

        local node=self:function_template(_list[idx])
        item =  self.scroll_listview:newItem()
        item:addContent(node,3)
      else

         dialog_content = item:getContent()
         if dialog_content then
            self:function_button_Refresh(_list[idx],dialog_content)
         end 
      end

        item:setItemSize(122,126)
      return item
  end
end


function GrowingtreeScene:fun_table(next_idx)

  local title_label = cc.ui.UILabel.new({text =next_idx,
                 size = 20,
                 align = TEXT_ALIGN_LEFT,
                 font = "Arial",
                 -- color=Util:ConvertStringToC3b("yellow"),
                 x=20,
                 y=0
         })
      -- title_label:setAnchorPoint(0.5,0.5)
      -- title_label:addTo(self , 101) 
      return title_label
end


function GrowingtreeScene:layout_sub(next_idx)
 
  local width, height = 0, 0
  local itemW, itemH = 0, 0
  local margin

  --calcate whole width height
  if cc.ui.UIScrollView.DIRECTION_VERTICAL == self.scroll_listview.direction then
    width = self.scroll_listview.viewRect_.width
    
    for i,v in ipairs(self.scroll_listview.items_) do
      itemW, itemH = v:getItemSize()
      itemW = itemW or 0
      itemH = itemH or 0

      height = height + itemH
    end
  end
  

  self.scroll_listview:setActualRect({x = self.scroll_listview.viewRect_.x,
    y = self.scroll_listview.viewRect_.y,
    width = width,
    height = height})
  self.scroll_listview.size.width = width
  self.scroll_listview.size.height = height

  local tempWidth, tempHeight = width, height
  if cc.ui.UIScrollView.DIRECTION_VERTICAL == self.scroll_listview.direction then
    itemW, itemH = 0, 0

    local content
    for i,v in ipairs(self.scroll_listview.items_) do
      itemW, itemH = v:getItemSize()
      itemW = itemW or 0
      itemH = itemH or 0

      tempHeight = tempHeight - itemH
      content = v:getContent()
      content:setAnchorPoint(0.5, 0.5)
      -- content:setPosition(itemW/2, itemH/2)
      self.scroll_listview:setPositionByAlignment_(content, itemW, itemH, v:getMargin())
      v:setPosition(self.scroll_listview.viewRect_.x,
        self.scroll_listview.viewRect_.y + tempHeight)
    end

  end


  self.scroll_listview.container:setPosition(0, (108*next_idx)-108)


end



return GrowingtreeScene



