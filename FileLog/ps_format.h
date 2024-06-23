#ifndef __PS_FORMAT_H__
#define __PS_FORMAT_H__

#include <string>
#include <vector>

/**
 * @name Ptilopsis's format
 * @authors Cooliecrad & Ptilopsis
 * @brief c++实现的简单格式化字符串
 * @date 2024/1/23
 * @version 1.0.1
*/
namespace ps_format {
    // 一个用来比较的模板
    template<typename _Tp, typename _Up>
    using is_same_dek = std::is_same<typename std::decay<_Tp>::type, _Up>;
    /**
     * @brief 解包参数
    */

    // 解析c风格字符串
    inline void unpack_arg(std::vector<const char*>& res, const char* arg)
    {
        res.push_back(arg);
    }

    // 解析cpp风格字符串
    inline void unpack_arg(std::vector<const char*>& res,
                           const std::string& arg)
    {
        res.push_back(arg.c_str());
    }

    // 实际上这个模板不会被产生，如果产生了这个代码，应该会引发断言
    template<typename _Tp>
    inline void unpack_arg(std::vector<const char*>&res, const _Tp& arg) {}

    template<typename Arg>
    inline void unpack_args(std::vector<const char*>& res, const Arg& arg)
    {
        static_assert((  is_same_dek<Arg, std::string>::value
                      || (is_same_dek<Arg, const char*>::value
                      || is_same_dek<Arg, char*>::value)),
            "Invalid argument. Type must be 'char*', 'const char*' or 'std::string'.");
        unpack_arg(res, arg);
    }
    template<typename Arg, typename ... Args>
    inline void unpack_args(std::vector<const char*>& res,
                            const Arg& arg, const Args& ... args)
    {
        unpack_arg(res, arg); unpack_args(res, args ...);
    }
    std::string __ps_format_string(const char* format,
                                   const std::vector<const char*>& args);
};

/**
 * @brief 返回一个格式化字符串
 * @param format 使用位置参数的格式串，使用 "%"(数字) 来指定位置
 * @param args 参数，参数对应的位置从1开始。参数只能是char* 或者 std::string类型
 *             args会拷贝字符串指针，所以不需要保留源指针
 * @note 如果参数不存在，将会在原位留空。如果格式不正确，不会对格式串修改。下面是
 * 一个示例。其中，函数接收到的参数只有一个，为"str"。
 * @note 输入: "format %1%2%1 %.33 %"
 * @note 输出: "format str str %.33 %"
 * 
*/ 
template<typename ... Args>
std::string format_string(const char* format, const Args& ... args)
{
    std::vector<const char*> char_args;
    ps_format::unpack_args(char_args, args ...);
    return ps_format::__ps_format_string(format, char_args);
}
#endif