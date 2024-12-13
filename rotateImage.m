% function g = rotateImage(f, angle)
%     % 获取输入图像的尺寸
%     [srcH, srcW, channels] = size(f);
% 
%     % 如果旋转角度是 0、90 或 270，可以直接优化处理
%     if angle == 0
%         g = f;  % 0°旋转，直接返回原图
%         g = uint8(min(max(g, 0), 255));  % 裁剪到[0, 255]之间
%         return;
%     elseif angle == 90
%         g = rot90(f);  % 90°旋转，可以使用 rot90 函数
%         g = uint8(min(max(g, 0), 255));  % 裁剪到[0, 255]之间
%         return;
%     elseif angle == 270
%         g = rot90(f, 3);  % 270°旋转，等同于逆时针旋转 90° 三次
%         g = uint8(min(max(g, 0), 255));  % 裁剪到[0, 255]之间
%         return;
%     end
% 
%     % 如果是彩色图像（有3个通道）
%     if channels == 3
%         % 分别提取RGB三个通道
%         R = f(:,:,1);
%         G = f(:,:,2);
%         B = f(:,:,3);
% 
%         % 对每个通道进行旋转
%         R = rotateSingleChannel(R, angle);
%         G = rotateSingleChannel(G, angle);
%         B = rotateSingleChannel(B, angle);
% 
%         % 合成新的RGB图像
%         g = cat(3, R, G, B);
%     else
%         % 如果是灰度图像
%         g = rotateSingleChannel(f, angle);
%     end
% end



function g = rotateImage(f, angle)
    % 获取输入图像的尺寸
    [srcH, srcW, channels] = size(f);
    
    % 如果是彩色图像（有3个通道）
    if channels == 3
        % 分别提取RGB三个通道
        R = f(:,:,1);
        G = f(:,:,2);
        B = f(:,:,3);
        
        % 对每个通道进行旋转
        R = rotateSingleChannel(R, angle);
        G = rotateSingleChannel(G, angle);
        B = rotateSingleChannel(B, angle);
        
        % 合成新的RGB图像
        g = cat(3, R, G, B);
    else
        % 如果是灰度图像
        g = rotateSingleChannel(f, angle);
    end
end