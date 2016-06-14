#include "lua_ItemPicker.hpp"
#include "ItemPicker.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_ItemPicker_ItemPicker_clearItems(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_clearItems'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_clearItems'", nullptr);
            return 0;
        }
        cobj->clearItems();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:clearItems",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_clearItems'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_setOffsetLayout(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_setOffsetLayout'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ItemPicker:setOffsetLayout");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_setOffsetLayout'", nullptr);
            return 0;
        }
        cobj->setOffsetLayout(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:setOffsetLayout",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_setOffsetLayout'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_setPickerPointPos(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_setPickerPointPos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Vec2 arg0;

        ok &= luaval_to_vec2(tolua_S, 2, &arg0, "ItemPicker:setPickerPointPos");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_setPickerPointPos'", nullptr);
            return 0;
        }
        cobj->setPickerPointPos(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:setPickerPointPos",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_setPickerPointPos'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_setContSize(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_setContSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Size arg0;

        ok &= luaval_to_size(tolua_S, 2, &arg0, "ItemPicker:setContSize");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_setContSize'", nullptr);
            return 0;
        }
        cobj->setContSize(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:setContSize",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_setContSize'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_getCellPos(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_getCellPos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_getCellPos'", nullptr);
            return 0;
        }
        int ret = cobj->getCellPos();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:getCellPos",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_getCellPos'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_setParameter(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_setParameter'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::Size arg0;
        int arg1;

        ok &= luaval_to_size(tolua_S, 2, &arg0, "ItemPicker:setParameter");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ItemPicker:setParameter");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_setParameter'", nullptr);
            return 0;
        }
        cobj->setParameter(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:setParameter",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_setParameter'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_pushBackItem(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_pushBackItem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::ui::Widget* arg0;

        ok &= luaval_to_object<cocos2d::ui::Widget>(tolua_S, 2, "ccui.Widget",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_pushBackItem'", nullptr);
            return 0;
        }
        cobj->pushBackItem(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:pushBackItem",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_pushBackItem'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_remedyItemPos(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_remedyItemPos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_remedyItemPos'", nullptr);
            return 0;
        }
        cobj->remedyItemPos();
        return 0;
    }
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "ItemPicker:remedyItemPos");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_remedyItemPos'", nullptr);
            return 0;
        }
        cobj->remedyItemPos(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:remedyItemPos",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_remedyItemPos'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_getCellLayout(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ItemPicker*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ItemPicker_ItemPicker_getCellLayout'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Size arg0;

        ok &= luaval_to_size(tolua_S, 2, &arg0, "ItemPicker:getCellLayout");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_getCellLayout'", nullptr);
            return 0;
        }
        cocos2d::ui::Layout* ret = cobj->getCellLayout(arg0);
        object_to_luaval<cocos2d::ui::Layout>(tolua_S, "ccui.Layout",(cocos2d::ui::Layout*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:getCellLayout",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_getCellLayout'.",&tolua_err);
#endif

    return 0;
}
int lua_ItemPicker_ItemPicker_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ItemPicker",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_create'", nullptr);
            return 0;
        }
        ItemPicker* ret = ItemPicker::create();
        object_to_luaval<ItemPicker>(tolua_S, "ItemPicker",(ItemPicker*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ItemPicker:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_create'.",&tolua_err);
#endif
    return 0;
}
int lua_ItemPicker_ItemPicker_constructor(lua_State* tolua_S)
{
    int argc = 0;
    ItemPicker* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ItemPicker_ItemPicker_constructor'", nullptr);
            return 0;
        }
        cobj = new ItemPicker();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"ItemPicker");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ItemPicker:ItemPicker",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_ItemPicker_ItemPicker_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_ItemPicker_ItemPicker_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ItemPicker)");
    return 0;
}

int lua_register_ItemPicker_ItemPicker(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ItemPicker");
    tolua_cclass(tolua_S,"ItemPicker","ItemPicker","ccui.ScrollView",nullptr);

    tolua_beginmodule(tolua_S,"ItemPicker");
        tolua_function(tolua_S,"new",lua_ItemPicker_ItemPicker_constructor);
        tolua_function(tolua_S,"clearItems",lua_ItemPicker_ItemPicker_clearItems);
        tolua_function(tolua_S,"setOffsetLayout",lua_ItemPicker_ItemPicker_setOffsetLayout);
        tolua_function(tolua_S,"setPickerPointPos",lua_ItemPicker_ItemPicker_setPickerPointPos);
        tolua_function(tolua_S,"setContSize",lua_ItemPicker_ItemPicker_setContSize);
        tolua_function(tolua_S,"getCellPos",lua_ItemPicker_ItemPicker_getCellPos);
        tolua_function(tolua_S,"setParameter",lua_ItemPicker_ItemPicker_setParameter);
        tolua_function(tolua_S,"pushBackItem",lua_ItemPicker_ItemPicker_pushBackItem);
        tolua_function(tolua_S,"remedyItemPos",lua_ItemPicker_ItemPicker_remedyItemPos);
        tolua_function(tolua_S,"getCellLayout",lua_ItemPicker_ItemPicker_getCellLayout);
        tolua_function(tolua_S,"create", lua_ItemPicker_ItemPicker_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ItemPicker).name();
    g_luaType[typeName] = "ItemPicker";
    g_typeCast["ItemPicker"] = "ItemPicker";
    return 1;
}
TOLUA_API int register_all_ItemPicker(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_ItemPicker_ItemPicker(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

