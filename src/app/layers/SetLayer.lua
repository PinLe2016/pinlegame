--
-- Author: peter
-- Date: 2017-05-03 14:10:58
--
--
-- Author: peter
-- Date: 2016-08-18 11:02:04
--
--设置
local SetLayer = class("SetLayer", function()
            return display.newLayer("SetLayer")
end)
function SetLayer:ctor()
          self.floating_layer = require("app.layers.FloatingLayer").new()
          self.floating_layer:addTo(self,100000)
          self:setNodeEventEnabled(true)--layer添加监听

          
          self:fun_init_infor()

end
function SetLayer:fun_init_infor( )
            local fragment_sprite_bg = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
            self:addChild(fragment_sprite_bg)
            self.SetNode = cc.CSLoader:createNode("SetNode.csb")
            self:addChild(self.SetNode)

            self.SetNode:setScale(0.7)
            self.SetNode:setAnchorPoint(0.5,0.5)
            self.SetNode:setPosition(320, 568)
            -- local actionTo = cc.ScaleTo:create(0.3, 1.1)
            -- local actionTo1 = cc.ScaleTo:create(0.1, 1)
            -- self.SetNode:runAction(cc.Sequence:create(actionTo,actionTo1  ))
            Util:layer_action(self.SetNode,self,"open")

            self:set_touch()
            self:per_userdady()
            local getconfig=LocalData:Instance():get_getconfig()
        	local _list = getconfig["list"]
        	local _list1=_list[1]["sataus"]
        	local _list2=_list[2]["sataus"]

            --  音乐
            local btn_BgMusic=self.SetNode:getChildByName("CheckBox_1")
            btn_BgMusic:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
			LocalData:Instance():set_music_hit(true)
			audio.resumeMusic()
			Util:player_music_hit("GAMEBG",true )
			Server:Instance():setconfig(_list[1]["itemsId"],0)
                     elseif eventType == ccui.CheckBoxEventType.unselected then
			LocalData:Instance():set_music_hit(false)
			audio.pauseMusic()
			Server:Instance():setconfig(_list[1]["itemsId"],1)
                     end
            end)
            --  音效
            local btn_Voice=self.SetNode:getChildByName("CheckBox_2")
            btn_Voice:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            LocalData:Instance():set_music(true)
                            Server:Instance():setconfig(_list[2]["itemsId"],0)  --  获取后台音效
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             LocalData:Instance():set_music(false)
                            Server:Instance():setconfig(_list[2]["itemsId"],1)  --  获取后台音效
                     end
            end)
            --  震动
            local btn_Snake=self.SetNode:getChildByName("CheckBox_3")
            btn_Snake:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开")
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关")
                     end
            end)

        local getconfig=LocalData:Instance():get_getconfig()
        local _list = getconfig["list"]
        local _list1=_list[1]["sataus"]
        local _list2=_list[2]["sataus"]
        if tonumber(_list1) == 0 then  --o 开  1  关闭
           LocalData:Instance():set_music_hit(true)
            audio.resumeMusic()
           btn_BgMusic:setSelected(true)
           
        else
           btn_BgMusic:setSelected(false)
           LocalData:Instance():set_music_hit(false)
           audio.pauseMusic()
        end
         if tonumber(_list2) == 0 then  --o 开  1  关闭
           btn_Voice:setSelected(true)
           LocalData:Instance():set_music(true)
           audio.resumeAllSounds()
        else
            LocalData:Instance():set_music(false)
           btn_Voice:setSelected(false)
           audio.pauseAllSounds()
        end
end
function SetLayer:set_touch(  )
      --  返回
       local back=self.SetNode:getChildByName("Image_22")
                  back:addTouchEventListener(function(sender, eventType  )
                    if eventType == 3 then
                       sender:setScale(1)
                       return
                    end
                       if eventType ~= ccui.TouchEventType.ended then
                           sender:setScale(1.2)
                           return
                      end
                      -- local function stopAction()
                      -- self:removeFromParent()
                      -- end
                      -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
                      -- local actionTo1 = cc.ScaleTo:create(0.3, 0.7)
                      -- local callfunc = cc.CallFunc:create(stopAction)
                      -- self.SetNode:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
                      Util:layer_action(self.SetNode,self,"close")

                  end)

      local STGY_bt=self.SetNode:getChildByName("Image_59")
                  STGY_bt:addTouchEventListener(function(sender, eventType  )
                        if eventType == 3 then
                              sender:setScale(1)
                              return
                          end
                          if eventType ~= ccui.TouchEventType.ended then
                              sender:setScale(1.2)
                          return
                          end
                          sender:setScale(1)
                      local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
                     self:addChild(aboutdetailsLayer.new(0),1,12)
                  end)
	--  意见反馈
	 local btn_Feedback=self.SetNode:getChildByName("Button_2")
              btn_Feedback:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
                  self:addChild(aboutdetailsLayer.new(1),1,12)
              end)
              --  商务合作
	 local btn_Cooperation=self.SetNode:getChildByName("Button_3")
              btn_Cooperation:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
                  self:addChild(aboutdetailsLayer.new(2),1,12)
              end)
              --  点赞
	 local btn_Commend=self.SetNode:getChildByName("Button_4")
              btn_Commend:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   self:fun_storebrowser("https://www.baidu.com")
              end)
              --  注销
	 local btn_CheckOut=self.SetNode:getChildByName("Button_5")
              btn_CheckOut:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  self.floating_layer:showFloat("您确定要退出登录？",function (sender, eventType)
                                  if eventType==1 then
                                    LocalData:Instance():set_user_data(nil)
                                    Util:deleWeixinLoginDate()
                                    Util:scene_control("LoginScene")
                                  end
                            end)
              end)

end
-- 外部链接
function SetLayer:fun_storebrowser( _url)
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      self.Storebrowser:setTag(1314)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                  end
                  self:removeChildByTag(1314, true)
            end)
              self.share=cc.UM_Share:create()
              self.Storebrowser:addChild(self.share)
              self.share:add_WebView(tostring(_url),cc.size(store_size:getContentSize().width ,store_size:getContentSize().height),
               cc.p(store_size:getPositionX(),store_size:getPositionY()))
end
function SetLayer:per_userdady( )
	-- 头像
	 local sp_Icon=self.SetNode:getChildByName("Image_15")
	 print("···0",LocalData:Instance():get_user_head())
	 if LocalData:Instance():get_user_head() then
	            sp_Icon:loadTexture(LocalData:Instance():get_user_head())
	 end
	 --名字
	local userdt = LocalData:Instance():get_userdata()
	local  userdata=LocalData:Instance():get_user_data()
	local nickname=userdata["loginname"]
	local nick_sub=string.sub(nickname,1,3)
	nick_sub=nick_sub.."****"..string.sub(nickname,8,11)
	if userdt["nickname"]~="" then
		nick_sub=userdt["nickname"]
	end
	 local txt_Name=self.SetNode:getChildByName("Text_1")
	 txt_Name:setString(nick_sub)
	 --账号
	 local txt_Mobile=self.SetNode:getChildByName("Text_3")
	 txt_Mobile:setString(nickname)
end


function SetLayer:onEnter()
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        self:init()

                      end)
  
end

function SetLayer:onExit()
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
       
end


return SetLayer