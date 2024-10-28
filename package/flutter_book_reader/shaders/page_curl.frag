#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform vec4 iMouse;
uniform sampler2D image;

#define pi 3.14159265359
#define radius 0.07
#define shadowWidth 0.02
#define TRANSPARENT vec4(0.0, 0.0, 0.0, 0.0)

out vec4 fragColor;

float calShadow(vec2 targetPoint, float aspect){
    if (targetPoint.y>=1.0){
        return max(pow(clamp((targetPoint.y-1.0)/shadowWidth, 0.0, 0.9), 0.2), pow(clamp((targetPoint.x-aspect)/shadowWidth, 0.0, 0.9), 0.2));
    } else {
        return max(pow(clamp((0.0-targetPoint.y)/shadowWidth, 0.0, 0.9), 0.2), pow(clamp((targetPoint.x-aspect)/shadowWidth, 0.0, 0.9), 0.2));
    }
}

vec2 rotate(vec2 v, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c * v.x - s * v.y, s * v.x + c * v.y);
}

vec2 pointOnCircle(vec2 center, vec2 startPoint, float currentRadius, float arcLength, bool clockwise) {
    float theta = arcLength / currentRadius;

    vec2 startVec = startPoint - center;

    startVec = normalize(startVec);

    float rotationAngle = clockwise ? -theta : theta;
    vec2 rotatedVec = rotate(startVec, rotationAngle);

    vec2 endPoint = center + rotatedVec * currentRadius;
    return endPoint;
}


void main() {
    vec2 fragCoord = FlutterFragCoord().xy;

    float aspect = resolution.x / resolution.y;

    vec2 uv = fragCoord * vec2(aspect, 1.0) / resolution.xy;

    vec4 currentMouse = iMouse;

    if ((currentMouse.z == 0.0 && currentMouse.w == 0.0)||(currentMouse.x == 0&&currentMouse.y == 0)){
        fragColor = texture(image, uv * vec2(1.0 / aspect, 1.0));
        return;
    }

    vec2 cornerFrom = (currentMouse.w<resolution.y/2)?vec2(aspect, 0.0):vec2(aspect, 1.0);

    // 归一化鼠标坐标
    vec2 mouse = currentMouse.xy  * vec2(aspect, 1.0) / resolution.xy;
    vec2 testPoint = vec2(0.25, 0.5);

    // 鼠标位置跟左上角的距离大于aspect，才会发生翻页范围大于屏幕
    if (distance(mouse.xy, vec2(0.0, cornerFrom.y))>(aspect)){

        // 修复规则：
        // 1. 如果触摸点位置位于左上角向右下角60度的直线上，那么将触摸点改为半径aspect的那个弧线跟60度直线的交点，这个倒直接这么处理即可；
        // 2. 如果不在上述60度的直线上，那么取当前触摸点，跟60度直线的距离，与半径aspect的弧度的距离，这两者取较小值
        // 3. 获取到这个数值后，以触摸点对应在弧线上的映射点为基准，以获取到的数值为弧长进行弧度偏移，方向取触摸点位于基准线的上下来决定。

        vec2 startPoint = vec2(0.0, cornerFrom.y==0.0?0.0:1.0);
        vec2 vector = normalize(vec2(0.5, 0.5*tan(cornerFrom.y==0.0?pi/3:-pi/3))-startPoint);

        vec2 targetMouse = mouse.xy;

        vec2 v = targetMouse - startPoint;
        float proj_length = dot(v, vector);
        vec2 targetMouse_proj = startPoint + proj_length*vector;

        /// 距离基准直线的距离
        float base_line_distance = length(targetMouse_proj - targetMouse);
        /// 当前触摸点距离弧线距离
        float arc_distance = distance(targetMouse, startPoint) - aspect;
        // 取小值
        float actual_distance = min(abs(base_line_distance), abs(arc_distance));

        // 当前触摸点对应在弧线上的映射点
        vec2 currentMouse_arc_proj = startPoint+ normalize(mouse - startPoint)*aspect;

        vec2 newPoint_arc_proj = pointOnCircle(startPoint, currentMouse_arc_proj, aspect, actual_distance/2, cornerFrom.y==0.0?mouse.y<=tan(pi/3)*mouse.x:mouse.y<=1-tan(-pi/3)*mouse.x);

        // 根据最新计算结果，修正鼠标参数
        mouse = newPoint_arc_proj;
        currentMouse.xy = mouse * resolution.xy / vec2(aspect, 1.0);
    }

    // 鼠标方向的向量
    vec2 mouseDir = normalize(abs(cornerFrom* resolution.xy / vec2(aspect, 1.0)) - currentMouse.xy);
    // 翻页辅助计算点起点
    vec2 origin = clamp(mouse - mouseDir * mouse.x / mouseDir.x, 0.0, 1.0);

    // 鼠标辅助计算距离
    float mouseDist = distance(mouse, origin);
    if (mouseDir.x < 0.0) {
        mouseDist = distance(mouse, origin);
    }

    float proj = dot(uv - origin, mouseDir);
    float dist = proj - (mouse.x<0?-mouseDist:mouseDist);
    vec2 curlAxisLinePoint = uv - dist * mouseDir;

    // 让翻页页脚能跟随触摸点
    float actualDist = distance(mouse, cornerFrom);
    if (actualDist>=pi*radius) {
        float params = (actualDist-pi*radius)/2;
        curlAxisLinePoint += params * mouseDir;
        dist -=params;
    }

    // 设定基色
    fragColor = vec4(0.0, 0.0, 0.0, (1.0 - pow(clamp((dist)*pi, 0.0, 1.0), 0.6)));

    if (dist >= 0.0) {
        float theta = asin(dist / radius);
        vec2 p2 = curlAxisLinePoint + mouseDir * (pi - theta) * radius;
        vec2 p1 = curlAxisLinePoint + mouseDir * theta * radius;
        if (p2.x <= aspect && p2.y <= 1.0 && p2.x > 0.0 && p2.y > 0.0){
            uv = p2;
            fragColor = texture(image, uv * vec2(1.0 / aspect, 1.0));
            fragColor.rgb =mix(fragColor.rgb, vec3(1.0), 0.25);
            fragColor.rgb *= pow(clamp((radius - dist) / radius, 0.0, 1.0), 0.2);
        } else {
            uv = p1;
            if (p1.x <= aspect && p1.y <= 1.0 && p1.x > 0.0 && p1.y > 0.0){
                fragColor = texture(image, uv * vec2(1.0 / aspect, 1.0));
            }
            if (p2.x <= aspect+shadowWidth && p2.y <= 1.0+shadowWidth&& p2.x > 0.0-shadowWidth && p2.y > 0.0-shadowWidth){
                float shadow = calShadow(p2, aspect);
                fragColor = vec4(fragColor.r*shadow, fragColor.g*shadow, fragColor.b*shadow, fragColor.a);
            }
        }
    } else if (dist < 0.0) {
        vec2 p = curlAxisLinePoint + mouseDir * (abs(dist) + pi * radius);

        if (p.x <= aspect && p.y <= 1.0 && p.x > 0.0 && p.y > 0.0){
            uv = p;
            fragColor = texture(image, uv * vec2(1.0 / aspect, 1.0));
            fragColor.rgb =mix(fragColor.rgb, vec3(1.0), 0.25);
        } else {
            fragColor = texture(image, uv * vec2(1.0 / aspect, 1.0));
            if (p.x <= aspect+shadowWidth && p.y <= 1.0+shadowWidth&& p.x > 0.0-shadowWidth && p.y > 0.0-shadowWidth){
                float shadow = calShadow(p, aspect);
                fragColor = vec4(fragColor.r*shadow, fragColor.g*shadow, fragColor.b*shadow, fragColor.a);
            }
        }
    }

    //    if (distance(uv, vec2(0.0)) >(aspect-0.001)&&distance(uv, vec2(0.0))<(aspect+0.001)){
    //        fragColor = vec4(0.0,1.0,0.0,1.0);
    //    }
}