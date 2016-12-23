--
-- Author: peter
-- Date: 2016-12-16 17:57:38
--
--修改密码
local ChangepasswordLayer = class("ChangepasswordLayer", function()
            return display.newLayer("ChangepasswordLayer")
end)

function ChangepasswordLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听
            
            self:init()
           
            
end

function ChangepasswordLayer:init(  )
      local  userdata = LocalData:Instance():get_user_data()
      self.loginname=userdata["loginname"]

       self.changepassword= cc.CSLoader:createNode("ChangepasswordLayer.csb")
       self:addChild(self.changepassword)

       local _loginname=self.changepassword:getChildByTag(498)   --   手机号
       _loginname:setString(tostring(self.loginname))
       self.back_bt=self.changepassword:getChildByTag(208)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self._bt=self.changepassword:getChildByTag(206)   --   提交
       self._bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self._oldpassword1=self.changepassword:getChildByTag(78)   --   旧密码
       self._password2=self.changepassword:getChildByTag(79)   --   新密码
       self.again_password3=self.changepassword:getChildByTag(80)   --   再次新密码
      self._oldpassword1:setVisible(false)
      self._password2:setVisible(false)
      self.again_password3:setVisible(false)
      local res = "  "--res/png/DLkuang.png"
      local width = 200
      local height = 27

      self._oldpassword = ccui.EditBox:create(cc.size(width,height),res)
      self.changepassword:addChild(self._oldpassword )
      self._oldpassword :setPosition(cc.p(self._oldpassword1:getPositionX(),self._oldpassword1:getPositionY()))--( cc.p(130,380 ))  
      self._oldpassword :setPlaceHolder("请输入原密码")
      self._oldpassword :setAnchorPoint(0.5,0.6)  
      self._oldpassword :setMaxLength(18)
      self._oldpassword :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)

      self._password = ccui.EditBox:create(cc.size(width,height),res)
      self.changepassword:addChild(self._password )
      self._password :setPosition(cc.p(self._password2:getPositionX(),self._password2:getPositionY()))--( cc.p(130,380 ))  
      self._password :setPlaceHolder("请输入新密码")
      self._password :setAnchorPoint(0.5,0.6)  
      self._password :setMaxLength(18)
      self._password :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)


      self.again_password = ccui.EditBox:create(cc.size(width,height),res)
      self.changepassword:addChild(self.again_password )
      self.again_password :setPosition(cc.p(self.again_password3:getPositionX(),self.again_password3:getPositionY()))--( cc.p(130,380 ))  
      self.again_password :setPlaceHolder("再次输入新密码")
      self.again_password :setAnchorPoint(0.5,0.6)  
      self.again_password :setMaxLength(18)
      self.again_password :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)



end


function ChangepasswordLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==208 then
          	self:removeFromParent()
          elseif tag==206 then
            self:pass()
          end
         
end
function ChangepasswordLayer:pass( )
                  local _oldpassword=self._oldpassword:getText()--getString()     
                  local _password=self._password:getText()--getString()
                  local again_password=self.again_password:getText()--getString()   
                  print("修改密码",_oldpassword," ",_password," ",again_password)
                  if _password  ~= again_password    then
                      Server:Instance():prompt("两次密码输入不一样")
                            return
                  end
                  if (_oldpassword=="请输入原密码请"  or  _oldpassword== "")  or  (_password=="请输入新密码"  or  _password== "")  or  (again_password=="再次输入新密码"  or  again_password== "") then  --
                            Server:Instance():prompt("请您完善信息")
                            return
                  end

                Server:Instance():changepassword(self.loginname,_password," ",2,_oldpassword)  --(1  忘记密码)
end


function ChangepasswordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function ChangepasswordLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 
end


return ChangepasswordLayer
