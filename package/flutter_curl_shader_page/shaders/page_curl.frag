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

    vec2 cornerFrom = vec2(aspect, currentMouse.y);

    // 归一化鼠标坐标
    vec2 mouse = currentMouse.xy  * vec2(aspect, 1.0) / resolution.xy;

    // 鼠标方向的向量
    vec2 mouseDir = normalize(abs(cornerFrom* resolution.xy / vec2(aspect, 1.0)) - currentMouse.xy);
    // 翻页辅助计算点起点
    vec2 origin = clamp(mouse - mouseDir * mouse.x / mouseDir.x, 0.0, 1.0);

    // 鼠标辅助计算距离
    float mouseDist = distance(mouse, origin);

    float proj = dot(uv - origin, mouseDir);
    float dist = proj - (mouse.x<0?-mouseDist:mouseDist);
    vec2 curlAxisLinePoint = uv - dist * mouseDir;

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