#include "BetterSkills_wrapper.h"

namespace BetterSkills {

    void __lua_toctype(lua_State *L, int index, bool& dst)
    {
        dst = lua_toboolean(L, index) != 0;
    }
    void __lua_toctype(lua_State *L, int index, lua_CFunction& dst)
    {
        dst = lua_tocfunction(L, index);
    }
    void __lua_toctype(lua_State *L, int index, int& dst)
    {
        dst = (int)lua_tointeger(L, index);
    }
    void __lua_toctype(lua_State *L, int index, char*& dst)
    {
        // 共享的缓冲区，减少反复的内存分配
        static size_t bf_size = 8;
        static char *buffer = (char*)malloc(bf_size*sizeof(char));

        // 获取指针和大小
        size_t str_len = 0;
        const char *ptr = lua_tolstring(L, index, &str_len);

        // 如果大小不够，重新分配
        if (str_len > bf_size)
        {
            bf_size = (size_t)(str_len * 1.5);
            free(buffer);
            buffer = (char*)malloc(bf_size*sizeof(char));
        }

        // 拷贝内容
        memcpy(buffer, ptr, str_len);
        dst = buffer;
    }
    void __lua_toctype(lua_State *L, int index, std::string& dst)
    {
        dst = std::string{ lua_tostring(L, index) };
    }
    void __lua_toctype(lua_State *L, int index, float& dst)
    {
        dst = (float)lua_tonumber(L, index);
    }
    void __lua_toctype(lua_State *L, int index, lua_Number& dst)
    {
        dst = lua_tonumber(L, index);
    }

    void __lua_ret_extractor(lua_State *L, bool value)
    {
        lua_pushboolean(L, value);
    }
    //void __lua_ret_extractor(lua_State *L, int value)
    //{
    //    lua_pushinteger(L, (lua_Integer)value);
    //}
    void __lua_ret_extractor(lua_State *L, lua_Integer value)
    {
        lua_pushinteger(L, value);
    }
    void __lua_ret_extractor(lua_State *L, const char* value)
    {
        lua_pushstring(L, value);
    }
    void __lua_ret_extractor(lua_State *L, const std::string& value)
    {
        lua_pushstring(L, value.c_str());
    }
    void __lua_ret_extractor(lua_State *L, float value)
    {
        lua_pushnumber(L, (lua_Number)value);
    }
    void __lua_ret_extractor(lua_State *L, lua_Number value)
    {
        lua_pushnumber(L, value);
    }

};