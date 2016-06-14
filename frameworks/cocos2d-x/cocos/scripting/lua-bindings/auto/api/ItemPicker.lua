
--------------------------------
-- @module ItemPicker
-- @extend ScrollView
-- @parent_module cc

--------------------------------
-- 
-- @function [parent=#ItemPicker] clearItems 
-- @param self
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] setOffsetLayout 
-- @param self
-- @param #int offset
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] setPickerPointPos 
-- @param self
-- @param #vec2_table pos
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] setContSize 
-- @param self
-- @param #size_table size
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] getCellPos 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] setParameter 
-- @param self
-- @param #size_table cellContent
-- @param #int _cont
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] pushBackItem 
-- @param self
-- @param #ccui.Widget item
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] remedyItemPos 
-- @param self
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] getCellLayout 
-- @param self
-- @param #size_table size
-- @return Layout#Layout ret (return value: ccui.Layout)
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] create 
-- @param self
-- @return ItemPicker#ItemPicker ret (return value: ItemPicker)
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] onTouchMoved 
-- @param self
-- @param #cc.Touch touch
-- @param #cc.Event unusedEvent
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] onTouchEnded 
-- @param self
-- @param #cc.Touch touch
-- @param #cc.Event unusedEvent
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] update 
-- @param self
-- @param #float dt
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] onTouchCancelled 
-- @param self
-- @param #cc.Touch touch
-- @param #cc.Event unusedEvent
        
--------------------------------
-- Changes the size that is widget's size<br>
-- param contentSize A content size in `Size`.
-- @function [parent=#ItemPicker] setContentSize 
-- @param self
-- @param #size_table contentSize
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] onTouchBegan 
-- @param self
-- @param #cc.Touch touch
-- @param #cc.Event unusedEvent
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#ItemPicker] ItemPicker 
-- @param self
        
return nil
