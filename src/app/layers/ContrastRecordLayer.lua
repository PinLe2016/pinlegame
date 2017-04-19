--
-- Author: peter
-- Date: 2016-05-09 16:51:21
--
local ContrastRecordLayer = class("ContrastRecordLayer", function()
            return display.newLayer("ContrastRecordLayer")
end)
--标题 头像 名字 排名  等级
function ContrastRecordLayer:ctor(params)
       self.id=params.id--activityid
       self.title=params.title--标题
       self.head=params.head--hero 头像
       self.name=params.name -- hero名称
       self.rank=params.rank --hero 排名
       self.level=params.level --hero 等级
       self.heroid=params.heroid --hero ID 
       self.allscore=params.allscore --总积分
       self._type=params._type
      self.phyimage=params.phyimage
       Server:Instance():getactivitypointsdetail(self.id,self.heroid)  --对比排行榜HTTP
       self:setNodeEventEnabled(true)--layer添加监听
       self.leve_instructions={"伯爵","大公","公爵","国王","侯爵","男爵","平民","亲王","骑士","王储","勋爵","子爵",}
      
       self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        self:addChild(self.fragment_sprite)

  self.ContrastRecordLayer = cc.CSLoader:createNode("ContrastRecordLayer.csb");
      self:addChild(self.ContrastRecordLayer)

      self:move_layer(self.ContrastRecordLayer)
       --Server:Instance():getactivitybyid(self.id,1)
       
end
function ContrastRecordLayer:move_layer(_layer)
     local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end
function ContrastRecordLayer:init(  )

        

    	local activitybyid=LocalData:Instance():get_getactivitybyid()
      local userdt = LocalData:Instance():get_userdata()--
    	local oneallntegral=self.ContrastRecordLayer:getChildByTag(119)
	oneallntegral:setString(activitybyid["mypoints"])--我的积分

	local heroallntegral=self.ContrastRecordLayer:getChildByTag(120)
	heroallntegral:setString(self.allscore)--hero总积分

    	local title_text=self.ContrastRecordLayer:getChildByTag(104)--标题
      title_text:setString(self.title)

      local level_text=self.ContrastRecordLayer:getChildByTag(105)--等级
      level_text:setString(self.allscore)--(userdt["grade"])

       local level_image=self.ContrastRecordLayer:getChildByTag(98):getChildByTag(972)--等级
       for j=1,#self.leve_instructions do
              if self.leve_instructions[j]  == tostring(self.level)  then
                 level_image:loadTexture(string.format("png/dengji_%d.png", j))
              end
       end

      local name_text=self.ContrastRecordLayer:getChildByTag(106)--名称  rankname
      name_text:setString(self.name)--(userdt["nickname"])

      local rank_text=self.ContrastRecordLayer:getChildByTag(107)--排名
      rank_text:setString(self.rank)--(activitybyid["myrank"])

      local dengji_text=self.ContrastRecordLayer:getChildByTag(101)--等级
      dengji_text:setString(userdt["rankname"])

      local head_image=self.ContrastRecordLayer:getChildByTag(108)--头像
      head_image:loadTexture(LocalData:Instance():get_user_head())--(self.head)
	
      local _back=self.ContrastRecordLayer:getChildByTag(121)-- 返回
      _back:addTouchEventListener(function(sender, eventType  )
                 self:touch_callback(sender, eventType)
        end)
    	self.rank_list=self.ContrastRecordLayer:getChildByTag(109)--排行榜列表
      self.rank_list:setItemModel(self.rank_list:getItem(0))
      self.rank_list:removeAllItems()
	self:ContrastRecord_init()
end
function ContrastRecordLayer:touch_callback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                    return
            end
            local tag=sender:getTag()
            if tag==121 then --返回
               self:removeFromParent()
               Util:all_layer_backMusic()
            end
               
        
end

function ContrastRecordLayer:ContrastRecord_init(  )
	self.rank_list:removeAllItems()
	self.list_table=LocalData:Instance():get_getactivitypointsdetail()
            local  mypointslist=self.list_table["mypointslist"]
            local  playerpointslist=self.list_table["playerpointslist"]
            local playernum=0
            local mynum=0
            if #playerpointslist==0 then
               playernum=0
            else
               playernum=playerpointslist[#playerpointslist]["cycle"]
            end
            if #mypointslist==0 then
              mynum=0
            else
              mynum=mypointslist[#mypointslist]["cycle"]
            end
            
            local count=mynum >= playernum and mynum or playernum  
            print("时间 ",count)
	for i=1,count do
            self.rank_list:pushBackDefaultItem()
		local  cell = self.rank_list:getItem(i-1)
            local retroactive_bt=cell:getChildByName("Button_2")            --getChildByTag(909)  --补签
            retroactive_bt:setTag(i)
            retroactive_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                end

                  local _activitybyid=LocalData:Instance():get_getactivitybyid()
                  local userdt = LocalData:Instance():get_userdata()
                  self._tag=sender:getTag()
       
                 print("金币数 "  ,tonumber(userdt["golds"]) ,"   ",  tonumber(_activitybyid["betgolds"]))
                 self.p_point=0
                 for i=1,#mypointslist do
                    if mypointslist[i]["cycle"] == self._tag   then
                       self.p_point= mypointslist[i]["points"]
                    end
                 end
                 print("dsfs  ",self.p_point)
                 if tonumber(userdt["golds"])  -    tonumber(_activitybyid["betgolds"]) -30  <  0  and  tonumber(self.p_point)  == 0  then
                  Server:Instance():prompt("金币不足，无法参与活动，快去奖池屯点金币吧！")
                  return
                 end
                  if tonumber(userdt["golds"])  -    tonumber(_activitybyid["betgolds"])   <  0    and  tonumber(self.p_point)  ~= 0 then
                  Server:Instance():prompt("金币不足，无法参与活动，快去奖池屯点金币吧！")
                  return
                 end
                --Server:Instance():getactivitybyid(self.id,self.cycle)
                
                local   PhysicsScene  = require("app.scenes.PhysicsScene")   
                local scene=PhysicsScene.new({id=self.id,cycle=self._tag,heroid=0,phyimage=self.phyimage})
                cc.Director:getInstance():pushScene(scene)

            end)


            if #mypointslist ~=0  then

                  local one_integral=cell:getChildByTag(117)--积分

                         --one_integral:setVisible(false)--xin
                         -- self.labelAtlas1 = ccui.TextAtlas:create()
                         -- self.labelAtlas1:setPosition(cc.p(one_integral:getPositionX(),one_integral:getPositionY()))  
                         -- cell:addChild(self.labelAtlas1) 
                         -- self.labelAtlas1:setProperty(2222, "png/cou.png", 26, 35, "0")
             
                 for j=1,#mypointslist do 
                     


                        if mynum  ~=0 and tonumber(mypointslist[j]["cycle"]) == i then
                              
                                one_integral:setString(mypointslist[j]["points"])--xin
                                if tonumber(mypointslist[j]["remaintimes"])  <   0 or   tonumber(mypointslist[j]["remaintimes"])  ==   0  then
                                       retroactive_bt:setVisible(false)
                                end
                                if j==#mypointslist then
                                   retroactive_bt:setVisible(false)
                                end 
                                 -- self.labelAtlas1:setString(tostring(mypointslist[j]["points"]))   --setProperty(mypointslist[j]["points"], "png/cou.png", 26, 35, "0")
                                  --   --11 xin
                                  break
                        else
                                one_integral:setString("0")  --xin
                          
                               --self.labelAtlas1:setString("0")  

                        end

                  end
            else
                  local one_integral=cell:getChildByTag(117)--积分
                  one_integral:setString("0")
         
                   -- one_integral:setVisible(false)--xin
                   -- local labelAtlas1 = ccui.TextAtlas:create()
                   -- labelAtlas1:setPosition(cc.p(one_integral:getPositionX(),one_integral:getPositionY()))  
                   -- labelAtlas1:setProperty(0, "png/cou.png", 26, 35, "0")
                   -- cell:addChild(labelAtlas1) 


            end
           



		if #playerpointslist ~=0  then
      
         local hero_integral=cell:getChildByTag(116)--积分
                              -- hero_integral:setVisible(false)
                               --hero_integral:setString(playerpointslist[k]["points"])
                               -- local labelAtlas = ccui.TextAtlas:create()
                               -- labelAtlas:setProperty(0, "png/cou.png", 26, 35, "0")
                               -- labelAtlas:setPosition(cc.p(hero_integral:getPositionX(),hero_integral:getPositionY()))  
                               -- cell:addChild(labelAtlas) 

                  for k=1,#playerpointslist do
                   

              
                         if playernum ~= 0 and playerpointslist[k]["cycle"]  == i  then
                                  hero_integral:setString(playerpointslist[k]["points"])
                             
                               break
                         else
                                -- local hero_integral=cell:getChildByTag(116)--积分
                                -- hero_integral:setString("0")
                                 --local hero_integral=cell:getChildByTag(116)--积分
                                 --hero_integral:setVisible(false)
                                 hero_integral:setString("0")
                                 -- local labelAtlas = ccui.TextAtlas:create()
                                 -- labelAtlas:setProperty(2, "png/cou.png", 26, 35, "0")
                                 -- labelAtlas:setPosition(cc.p(hero_integral:getPositionX(),hero_integral:getPositionY()))  
                                 -- cell:addChild(labelAtlas) 


                         end
                  end
           else
            -- local hero_integral=cell:getChildByTag(116)--积分
            --   hero_integral:setString("0")

               local hero_integral=cell:getChildByTag(116)--积分
               --hero_integral:setVisible(false)
               hero_integral:setString("0")
               -- local labelAtlas = ccui.TextAtlas:create()
               -- labelAtlas:setProperty(0, "png/cou.png", 26, 35, "0")
               -- labelAtlas:setPosition(cc.p(hero_integral:getPositionX(),hero_integral:getPositionY()))  
               -- cell:addChild(labelAtlas) 

          end
           
         
		


		local name_text=cell:getChildByTag(115)--时间
            local _ble={"月","周","天","天"}--年0  月1  周2  日  整点   热门5  （整点和热门没有）
            if self._type<3 then
                    local  tpy=_ble[tonumber(self._type)+1]
                    name_text:setString("第"  .. i  ..  tpy)
            elseif self._type==5 then
                    name_text:setString("第"  .. i  ..  "天")   --热门
            else
                     name_text:setString("第"  .. i  ..  "天")  --零时
             end
	end

           
end
function ContrastRecordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self,
                       function()
                        -- print("ffefe排行榜")
                        self:init()
                      end)
  -- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self,
  --                      function()
  --                       print("sdkfjdsfds将对方是否觉得撒客服")
  --                        local PhysicsScene = require("app.scenes.PhysicsScene")   
  --                       local scene=PhysicsScene.new({id=self.id,cycle=self._tag,heroid=0,phyimage=self.phyimage})
  --                      cc.Director:getInstance():pushScene(scene)

                      
  --                     end)

end

function ContrastRecordLayer:onExit()
     	  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CONTRASRECORD_LAYER_IMAGE, self)
        --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.DETAILS_LAYER_IMAGE, self)
        cc.Director:getInstance():getTextureCache():removeAllTextures() 
end

return ContrastRecordLayer


