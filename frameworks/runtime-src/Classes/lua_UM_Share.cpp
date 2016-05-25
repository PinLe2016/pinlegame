#include "lua_UM_Share.hpp"
#include "UM_Share.hpp"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_UM_Share_UM_Share_init(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_init'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_create(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_create'", nullptr);
            return 0;
        }
        UM_Share* ret = UM_Share::create();
        object_to_luaval<UM_Share>(tolua_S, "UM_Share",(UM_Share*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UM_Share:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_create'.",&tolua_err);
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
        tolua_function(tolua_S,"init",lua_UM_Share_UM_Share_init);
        tolua_function(tolua_S,"create", lua_UM_Share_UM_Share_create);
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

