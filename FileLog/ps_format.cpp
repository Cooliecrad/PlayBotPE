#include "ps_format.h"

#include <sstream>
#include <vector>

#ifndef is_digit
#define is_digit(x) (x >= '0' && x <= '9')
#endif

using namespace std;

string ps_format::__ps_format_string(const char* format,
                                     const vector<const char*>& args)
{
    stringstream ss;

    // 将字符串格式拷贝进去
    int index = 0;
    while (format[index])
    {
        if (format[index] == '%' && is_digit(format[index+1]))
        { // 如果是位置标记，读取完整位置标记
            ss.write(format, index); // 拷贝参数之前的字符串
            index++; // 读取标记
            int num = atoi(format+index)-1;
            if (num < args.size() && num >= 0) // 存在该参数
                ss << args[num];
            else ss << ' ';

            while (is_digit(format[index])) index++; //跳过数字部分
            format += index;
            index = 0;
        } else index++;
    }
    ss << format; // 拷贝剩下的部分
    return ss.str();
}