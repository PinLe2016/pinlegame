#include "lua_UM_Share.hpp"
#include "UM_Share.hpp"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_UM_Share_UM_Share_initWithShare(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_initWithShare'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:initWithShare");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_initWithShare'", nullptr);
            return 0;
        }
        bool ret = cobj->initWithShare(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:initWithShare",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_initWithShare'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_shareWithIos(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_shareWithIos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:shareWithIos");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_shareWithIos'", nullptr);
            return 0;
        }
        cobj->shareWithIos(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:shareWithIos",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_shareWithIos'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_shareMenuItemClick(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_shareMenuItemClick'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Ref* arg0;

        ok &= luaval_to_object<cocos2d::Ref>(tolua_S, 2, "cc.Ref",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_shareMenuItemClick'", nullptr);
            return 0;
        }
        cobj->shareMenuItemClick(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:shareMenuItemClick",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_shareMenuItemClick'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_shareWithAndroid(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_shareWithAndroid'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:shareWithAndroid");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_shareWithAndroid'", nullptr);
            return 0;
        }
        cobj->shareWithAndroid(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:shareWithAndroid",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_shareWithAndroid'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_createWithShare(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:createWithShare");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_createWithShare'", nullptr);
            return 0;
        }
        UM_Share* ret = UM_Share::createWithShare(arg0);
        object_to_luaval<UM_Share>(tolua_S, "UM_Share",(UM_Share*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UM_Share:createWithShare",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_createWithShare'.",&tolua_err);
#endif
    return 0;
}
int lua_UM_Share_UM_Share_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_constructor'", nullptr);
            return 0;
        }
        cobj = new UM_Share();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UM_Share");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:UM_Share",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_UM_Share_UM_Share_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UM_Share)");
    return 0;
}

int lua_register_UM_Share_UM_Share(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UM_Share");
    tolua_cclass(tolua_S,"UM_Share","UM_Share","cc.Layer",nullptr);

    tolua_beginmodule(tolua_S,"UM_Share");
        tolua_function(tolua_S,"new",lua_UM_Share_UM_Share_constructor);
        tolua_function(tolua_S,"initWithShare",lua_UM_Share_UM_Share_initWithShare);
        tolua_function(tolua_S,"shareWithIos",lua_UM_Share_UM_Share_shareWithIos);
        tolua_function(tolua_S,"shareMenuItemClick",lua_UM_Share_UM_Share_shareMenuItemClick);
        tolua_function(tolua_S,"shareWithAndroid",lua_UM_Share_UM_Share_shareWithAndroid);
        tolua_function(tolua_S,"createWithShare", lua_UM_Share_UM_Share_createWithShare);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UM_Share).name();
    g_luaType[typeName] = "UM_Share";
    g_typeCast["UM_Share"] = "UM_Share";
    return 1;
}
TOLUA_API int register_all_UM_Share(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_UM_Share_UM_Share(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

