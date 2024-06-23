#ifndef __BU_CONVERTS_H__
#define __BU_CONVERTS_H__

#include "PlayBotLib/worldmodel.h"

/**
* @brief 常用数据类型到字符串的转换，便于调试
*/

namespace BallUtils
{
    std::string to_string(const point2f& data);
};

#endif