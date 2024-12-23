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