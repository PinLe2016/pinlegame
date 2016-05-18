#include "lua_PinLe_platform.hpp"
#include "PinLe_platform.hpp"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_PinLe_platform_PinLe_platform_getLocation(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_getLocation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_getLocation'", nullptr);
            return 0;
        }
        cobj->getLocation();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:getLocation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_getLocation'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_setProvince(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_setProvince'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PinLe_platform:setProvince");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_setProvince'", nullptr);
            return 0;
        }
        cobj->setProvince(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:setProvince",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_setProvince'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_setCity(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_setCity'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PinLe_platform:setCity");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_setCity'", nullptr);
            return 0;
        }
        cobj->setCity(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:setCity",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_setCity'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_getCounty(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_getCounty'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_getCounty'", nullptr);
            return 0;
        }
        std::string ret = cobj->getCounty();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:getCounty",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_getCounty'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_getCity(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_getCity'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_getCity'", nullptr);
            return 0;
        }
        std::string ret = cobj->getCity();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:getCity",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_getCity'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_getProvince(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_getProvince'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_getProvince'", nullptr);
            return 0;
        }
        std::string ret = cobj->getProvince();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:getProvince",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_getProvince'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_setCounty(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PinLe_platform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PinLe_platform_PinLe_platform_setCounty'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "PinLe_platform:setCounty");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_setCounty'", nullptr);
            return 0;
        }
        cobj->setCounty(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:setCounty",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_setCounty'.",&tolua_err);
#endif

    return 0;
}
int lua_PinLe_platform_PinLe_platform_Instance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"PinLe_platform",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_Instance'", nullptr);
            return 0;
        }
        PinLe_platform* ret = PinLe_platform::Instance();
        object_to_luaval<PinLe_platform>(tolua_S, "PinLe_platform",(PinLe_platform*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "PinLe_platform:Instance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_Instance'.",&tolua_err);
#endif
    return 0;
}
int lua_PinLe_platform_PinLe_platform_constructor(lua_State* tolua_S)
{
    int argc = 0;
    PinLe_platform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_PinLe_platform_PinLe_platform_constructor'", nullptr);
            return 0;
        }
        cobj = new PinLe_platform();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"PinLe_platform");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "PinLe_platform:PinLe_platform",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_PinLe_platform_PinLe_platform_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_PinLe_platform_PinLe_platform_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (PinLe_platform)");
    return 0;
}

int lua_register_PinLe_platform_PinLe_platform(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"PinLe_platform");
    tolua_cclass(tolua_S,"PinLe_platform","PinLe_platform","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"PinLe_platform");
        tolua_function(tolua_S,"new",lua_PinLe_platform_PinLe_platform_constructor);
        tolua_function(tolua_S,"getLocation",lua_PinLe_platform_PinLe_platform_getLocation);
        tolua_function(tolua_S,"setProvince",lua_PinLe_platform_PinLe_platform_setProvince);
        tolua_function(tolua_S,"setCity",lua_PinLe_platform_PinLe_platform_setCity);
        tolua_function(tolua_S,"getCounty",lua_PinLe_platform_PinLe_platform_getCounty);
        tolua_function(tolua_S,"getCity",lua_PinLe_platform_PinLe_platform_getCity);
        tolua_function(tolua_S,"getProvince",lua_PinLe_platform_PinLe_platform_getProvince);
        tolua_function(tolua_S,"setCounty",lua_PinLe_platform_PinLe_platform_setCounty);
        tolua_function(tolua_S,"Instance", lua_PinLe_platform_PinLe_platform_Instance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(PinLe_platform).name();
    g_luaType[typeName] = "PinLe_platform";
    g_typeCast["PinLe_platform"] = "PinLe_platform";
    return 1;
}
TOLUA_API int register_all_PinLe_platform(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_PinLe_platform_PinLe_platform(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

