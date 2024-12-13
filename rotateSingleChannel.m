% % 旋转单通道图像的函数
% function g = rotateSingleChannel(f, angle)
%     % 获取图像的高度和宽度
%     [srcH, srcW] = size(f);
% 
%     % 计算旋转的角度（转换为弧度）
%     theta = deg2rad(angle);
% 
%     % 计算旋转后的图像尺寸
%     cornerx = [0 srcW-1 srcW-1 0];
%     cornery = [0 0 srcH-1 srcH-1];
% 
%     newcornerx = cornerx * cos(theta) + cornery * sin(theta); % 旋转后的四个角的x坐标
%     newcornery = -cornerx * sin(theta) + cornery * cos(theta);% 旋转后的四个角的y坐标
% 
%     minx = min(newcornerx); % 新图像的最小x坐标
%     miny = min(newcornery); % 新图像的最小y坐标
% 
%     dstH = ceil(max(newcornery) - miny + 1);
%     dstW = ceil(max(newcornerx) - minx + 1);
% 
%     g = zeros(dstH, dstW);  % 创建新的空白图像
% 
%     % 旋转图像并应用双线性插值
%     for newx = 1:dstW
%         for newy = 1:dstH
%             oldx = (newx - 1 + minx) * cos(theta) - (newy - 1 + miny) * sin(theta);
%             oldy = (newx - 1 + minx) * sin(theta) + (newy - 1 + miny) * cos(theta);
% 
%             if oldx < 0 || oldy < 0 || oldx > srcW-1 || oldy > srcH-1
%                 g(newy, newx) = 255;  % 超出原图范围，设为255（白色）
%             else
%                 x = floor(oldx) + 1;
%                 y = floor(oldy) + 1;
%                 a = oldx - floor(oldx);
%                 b = oldy - floor(oldy);
% 
%                 if x <= 0 && y > 0 && y <= srcH
%                     g(newy, newx) = f(y, 1) + b * (f(y+1, 1) - f(y, 1));  % 左边界
%                 elseif y <= 0 && x <= srcW && x > 0
%                     g(newy, newx) = f(1, x) + a * (f(1, x+1) - f(1, x));  % 上边界
%                 elseif x >= srcW && y > 0 && y <= srcH
%                     g(newy, newx) = f(y, srcW) + b * (f(y+1, srcW) - f(y, srcW));  % 右边界
%                 elseif y >= srcH && x <= srcW && x > 0
%                     g(newy, newx) = f(srcH, x) + a * (f(srcH, x+1) - f(srcH, x));  % 下边界
%                 else
%                     g(newy, newx) = f(y, x) + b * (f(y+1, x) - f(y, x)) + a * (f(y, x+1) - f(y, x)) + a * b * (f(y+1, x+1) - f(y, x+1) - f(y+1, x) + f(y, x));
%                 end
%             end
%         end
%     end
%     % 确保图像像素值在有效范围内
%     g = uint8(min(max(g, 0), 255));  % 裁剪到[0, 255]之间
% end
% 



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