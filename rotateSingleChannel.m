% 旋转单通道图像的函数（包括优化的双线性插值）
function g = rotateSingleChannel(f, angle)
    [srcH, srcW] = size(f);  % 获取输入图像的尺寸
    theta = deg2rad(angle);   % 角度转换为弧度
    
    % 计算旋转后的图像尺寸
    cornerx = [0, srcW-1, srcW-1, 0];
    cornery = [0, 0, srcH-1, srcH-1];
    
    newcornerx = cornerx * cos(theta) + cornery * sin(theta); % 旋转后的四个角的x坐标
    newcornery = -cornerx * sin(theta) + cornery * cos(theta); % 旋转后的四个角的y坐标
    
    minx = min(newcornerx); % 新图像的最小x坐标
    miny = min(newcornery); % 新图像的最小y坐标
    
    dstH = ceil(max(newcornery) - miny + 1); % 目标图像的高度
    dstW = ceil(max(newcornerx) - minx + 1); % 目标图像的宽度
    
    % 创建新的空白图像
    g = zeros(dstH, dstW);
    
    % 旋转图像并应用双线性插值
    for newx = 1:dstW
        for newy = 1:dstH
            % 将新图像坐标转换为原图像坐标
            oldx = (newx - 1 + minx) * cos(theta) - (newy - 1 + miny) * sin(theta);
            oldy = (newx - 1 + minx) * sin(theta) + (newy - 1 + miny) * cos(theta);
            
            if oldx < 1 || oldy < 1 || oldx > srcW || oldy > srcH
                g(newy, newx) = 255;  % 超出原图范围，设为白色（255）
            else
                % 双线性插值
                x1 = floor(oldx); x2 = ceil(oldx);
                y1 = floor(oldy); y2 = ceil(oldy);
                
                % 确保不超出图像边界
                x1 = max(1, x1); x2 = min(srcW, x2);
                y1 = max(1, y1); y2 = min(srcH, y2);
                
                % 获取插值所需的四个像素
                Q11 = f(y1, x1);
                Q12 = f(y1, x2);
                Q21 = f(y2, x1);
                Q22 = f(y2, x2);
                
                % 双线性插值
                a = oldx - x1;
                b = oldy - y1;
                g(newy, newx) = (1-a)*(1-b)*Q11 + a*(1-b)*Q12 + (1-a)*b*Q21 + a*b*Q22;
            end
        end
    end
    
    % 确保图像像素值在有效范围内
    g = uint8(min(max(g, 0), 255));  % 裁剪到[0, 255]之间
end