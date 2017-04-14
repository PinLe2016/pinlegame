--
-- Author: peter
-- Date: 2016-11-29 15:43:36
--   财富榜
local RichlistLayer = class("RichlistLayer", function()
            return display.newScene("RichlistLayer")
end)

local http_number=20
--标题 活动类型 
function RichlistLayer:ctor()
       self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
	self:setNodeEventEnabled(true)--layer添加监听
	self.tablecout=0
	self.RichlistLayer = cc.CSLoader:createNode("RichlistLayer.csb")
	self:addChild(self.RichlistLayer)
	
	self.number_pages=1  --  页数
	self._type=0   --  类型
	Server:Instance():getgoldsranklist(http_number,self.number_pages,self._type)  ---pagesize 每页显示数据  pageno页号  type 0日榜、1周榜、2月榜、3年榜 


            local back_bt=self.RichlistLayer:getChildByTag(1027)--返回
            back_bt:addTouchEventListener(function(sender, eventType  )
                                    if eventType ~= ccui.TouchEventType.ended then
		                return
		            end
		           --display.replaceScene(require("app.scenes.MainInterfaceScene"):new())
               Util:scene_control("MainInterfaceScene")
               Util:all_layer_backMusic()
                        end)

            self.rank_list=self.RichlistLayer:getChildByTag(858)
            -- self.rank_list:addScrollViewEventListener((function(sender, eventType  )
            --           if eventType  ==6 then
                        -- self.number_pages=self.number_pages+1
                        -- Server:Instance():getgoldsranklist(5,self.number_pages,self._type)   --下拉刷新功能
      --                            return
      --                 end
    	 -- end))

               local day_bt=self.RichlistLayer:getChildByTag(747):getChildByTag(748)-- 日
    	   day_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
                end))

    	   local weeks_bt=self.RichlistLayer:getChildByTag(747):getChildByTag(749)--周
    	   weeks_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
                end))

    	   local month_bt=self.RichlistLayer:getChildByTag(747):getChildByTag(750)--月
    	   month_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
                end))

    	   local years_bt=self.RichlistLayer:getChildByTag(747):getChildByTag(751)--年
    	   years_bt:addTouchEventListener((function(sender, eventType  )
                     self:list_btCallback(sender, eventType)
                end))
         day_bt:setBright(false)
        self.curr_bright=day_bt--记录当前高亮

            self.rank_list:setItemModel(self.rank_list:getItem(0))
            self.rank_list:removeAllItems()

end
function RichlistLayer:list_btCallback( sender, eventType )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getTag()
               if self.curr_bright:getTag()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)
               self.tablecout=0
              if tag==748 then 
              	self.number_pages=1  --  页数
	            self._type=0   --  类型
              	Server:Instance():getgoldsranklist(http_number,self.number_pages,self._type)
              	self.rank_list:removeAllItems()
              elseif tag==749 then
              	self.number_pages=1  --  页数
	            self._type=1   --  类型
              	Server:Instance():getgoldsranklist(http_number,self.number_pages,self._type)
              	self.rank_list:removeAllItems()
              elseif tag==750 then
              	self.number_pages=1  --  页数
	            self._type=2   --  类型
              	Server:Instance():getgoldsranklist(http_number,self.number_pages,self._type)
              	self.rank_list:removeAllItems()
              elseif tag==751 then
              	self.number_pages=1  --  页数
	            self._type=3   --  类型
              	Server:Instance():getgoldsranklist(http_number,self.number_pages,self._type)
              	self.rank_list:removeAllItems()

              end
              self.curr_bright=sender
 end
function RichlistLayer:init(  )
       self.tablecout=0
	self.goldsranklist=LocalData:Instance():get_getgoldsranklist()
	self.ranklist=self.goldsranklist["ranklist"]
	self.rich_num=self.RichlistLayer:getChildByTag(482):getChildByTag(586)  --  财富数字
	self.rich_num:setString(tostring(self.goldsranklist["golds"]))
	self.rank_num=self.RichlistLayer:getChildByTag(482):getChildByTag(587)  --  排名

	self.rank_num:setString(tostring(self.goldsranklist["rank"]))

	self.head=self.RichlistLayer:getChildByTag(482):getChildByTag(1026)-- 头像
            self.head:loadTexture(LocalData:Instance():get_user_head())
            self.name=self.RichlistLayer:getChildByTag(482):getChildByTag(485)-- 名字
            local userdt = LocalData:Instance():get_userdata()
	local  userdata=LocalData:Instance():get_user_data()
	local nickname=userdata["loginname"]
	local nick_sub=string.sub(nickname,1,3)
	nick_sub=nick_sub.."****"..string.sub(nickname,8,11)
            if userdt["nickname"]~="" then
                nick_sub=userdt["nickname"]
	end
	self.name:setString(nick_sub)

	self.sup_data_num= #self.ranklist
	 for i=1,#self.ranklist do
	          	self.rank_list:pushBackDefaultItem()
	          	local  cell = self.rank_list:getItem(self.ranklist[#self.ranklist]["rankindex"]-#self.ranklist-1+i)--(i-1)
	            local name_text=cell:getChildByTag(866)--昵称
                        name_text:setString(tostring(self.ranklist[i]["nickname"]))
                        local gold_text=cell:getChildByTag(867)--金币
                        gold_text:setString(tostring(self.ranklist[i]["golds"]))
                        gold_text:setPosition(gold_text:getPositionX()-40, gold_text:getPositionY())
                        local rank_image=cell:getChildByTag(865)--排名  image
                        local rank_text=cell:getChildByTag(868)--排名


                         local function touchEvent(sender,eventType)
                              
                              if eventType == ccui.TouchEventType.ended then
                                          sender:setTouchEnabled(false)
                                         local _table={}
                                         local table_list={}
                                         _table["playerid"]=self.ranklist[sender:getTag()]["playerid"]
                                         table_list[1]=_table
                                         Server:Instance():setfriendoperation(table_list,0)
                                          local function stopAction()
                                                sender:setTouchEnabled(true)      
                                          end
                                          local callfunc = cc.CallFunc:create(stopAction)
                                         sender:runAction(cc.Sequence:create(cc.DelayTime:create(1),callfunc  ))
                              end
                        end
                        local button = ccui.Button:create()
                        button:setTag(i)
                        button:setTouchEnabled(true)
                        button:loadTextures("png/tianjiahaoyou-tianjia-dikuang.png", "png/tianjiahaoyou-tianjia-dikuang-liang.png", "")
                        button:setPosition(cc.p(gold_text:getPositionX()+80, gold_text:getPositionY()))
                        button:addTouchEventListener(touchEvent)
                        cell:addChild(button)
                        local  child = cc.Sprite:create("png/tianjiahaoyou-tianjia-dikuang-jiahao.png")
                        child:setPosition(child:getContentSize().width/2+5,button:getContentSize().height/2 )
                        button:addChild(child)
                        if self.ranklist[i]["tag"]   ==  1  then   --  1是好友  0  不是好友
                           button:setVisible(false)
                        end



                        if 4>tonumber(self.ranklist[i]["rankindex"]) then
                        	rank_image:loadTexture(string.format("png/PH_%d.png", self.ranklist[i]["rankindex"]))
                        else
                        	rank_image:setVisible(false)
                        	rank_text:setString(tostring(self.ranklist[i]["rankindex"]))
                        end
                         local _head=cell:getChildByTag(864) --头像
	            local _index=string.match(tostring(Util:sub_str(self.ranklist[i]["imageurl"], "/",":")),"%d")
	            _head:loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))

          end
           if tonumber(self.tablecout)~=0 then
             self.rank_list:jumpToPercentVertical(110)
           else
             self.rank_list:jumpToPercentVertical(0)
          end

          self.tablecout=self.sup_data_num


          

end
function RichlistLayer:onEnter()
  --Util:player_music_hit("PERSONALCHAGE",true )    
	NotificationCenter:Instance():AddObserver("RICHLIST", self,
                       function()
                        self:init()
                      end)
    NotificationCenter:Instance():AddObserver("FRIEND_SETFRIENDOPERATION", self,
                         function()
                          Server:Instance():promptbox_box_buffer("成功添加好友") 
                          Server:Instance():getgoldsranklist(http_number,self.number_pages,self._type)
                         self.rank_list:removeAllItems()
                        end)


end

function RichlistLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver("RICHLIST", self)
        NotificationCenter:Instance():RemoveObserver("FRIEND_SETFRIENDOPERATION", self)
        cc.Director:getInstance():getTextureCache():removeAllTextures()     
end

function RichlistLayer:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
       --self.barrier_bg:setVisible(false)
       --self.kuang:setVisible(false)
   else
    --self.barrier_bg:setVisible(false)
  --self.kuang:setVisible(false)
       self.floating_layer:showFloat(text) 
   end
end 

function RichlistLayer:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
end 
function RichlistLayer:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end 
function RichlistLayer:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end


return RichlistLayer