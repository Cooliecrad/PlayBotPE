/**
* @brief 足球机器人常用常量补充
* @note 单位:cm
*/
#ifndef __BOT_CONSTANTS_H__
#define __BOT_CONSTANTS_H__

namespace BotConstants {
    static const int BOT_NUMBER = 6; // 机器人总数
    static const float BOT_RADIUS = 9.; // 机器人半径（单位cm）
    static const float BOT_GET_BALL_DIST = BOT_RADIUS*1.2; // 认为机器人拿到球的距离
    static const float BOT_SPEED = 30.; // 机器人移动速度（单位：cm）
    static const int FRAME_RATE = 60; // 视觉系统帧率
    static const float IN_POS = 1; // 认为到达了目标地点
};

#endif