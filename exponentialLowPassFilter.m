function output_img = exponentialLowPassFilter(input_img, D0)
    % input_img: 输入的彩色图像
    % D0: 截止频率，控制低通滤波器的频率范围
    
 % 判断输入图像是否为灰度图或彩色图像
    if size(input_img, 3) == 1
        % 如果是灰度图像，直接处理
        output_img = applyExponentialLowPassFilter(input_img, D0);
    else

    % 分离RGB通道
    R = input_img(:,:,1);  % 红色通道
    G = input_img(:,:,2);  % 绿色通道
    B = input_img(:,:,3);  % 蓝色通道
    
    % 对每个通道应用指数低通滤波
    R_filtered = applyExponentialLowPassFilter(R, D0);
    G_filtered = applyExponentialLowPassFilter(G, D0);
    B_filtered = applyExponentialLowPassFilter(B, D0);
        % 合并处理后的通道
    output_img = cat(3, R_filtered, G_filtered, B_filtered);
    end
end

function output_channel = applyExponentialLowPassFilter(channel, D0)
    % 对单个通道应用指数低通滤波
    
    % 获取图像尺寸
    [rows, cols] = size(channel);
    
    % 计算频域的中心点
    u0 = floor(rows / 2);
    v0 = floor(cols / 2);
    
    % 进行傅里叶变换并将图像移到频域中心
    F = fftshift(fft2(double(channel)));
    
    % 构建指数低通滤波器
    H = zeros(rows, cols);
    for u = 1:rows
        for v = 1:cols
            D = sqrt((u - u0)^2 + (v - v0)^2);  % 距离频域中心的距离
            H(u, v) = exp(-D / D0);  % 指数低通滤波器的频率响应
        end
    end
    
    % 应用指数低通滤波器
    F_filtered = F .* H;
    
    % 进行逆傅里叶变换，返回处理后的图像
    img_filtered = ifft2(ifftshift(F_filtered));
    
    % 取实部并转换为uint8类型
    output_channel = uint8(real(img_filtered));
end
