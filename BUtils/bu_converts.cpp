#include "bu_converts.h"

#include <sstream>
#include <string>

using namespace std;

string BallUtils::to_string(const point2f& data)
{
    stringstream ss;
    ss << '(' << std::to_string(data.x) << ',' << std::to_string(data.y) << ')';
    return ss.str();
}