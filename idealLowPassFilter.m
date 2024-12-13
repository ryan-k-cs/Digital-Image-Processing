function output_img = idealLowPassFilter(input_img, cutoff_frequency)
    % input_img: 输入图像，灰度图像或彩色图像
    % cutoff_frequency: 截止频率（高于该频率的信号将被滤除）

    % 如果是彩色图像，分离 RGB 通道
    if size(input_img, 3) == 3
        R = input_img(:, :, 1);  % 红色通道
        G = input_img(:, :, 2);  % 绿色通道
        B = input_img(:, :, 3);  % 蓝色通道
        % 对每个通道分别进行处理
        R_filtered = idealLowPassFilterSingleChannel(R, cutoff_frequency);
        G_filtered = idealLowPassFilterSingleChannel(G, cutoff_frequency);
        B_filtered = idealLowPassFilterSingleChannel(B, cutoff_frequency);
        
        % 合并处理后的通道
        output_img = cat(3, R_filtered, G_filtered, B_filtered);
    else
        % 如果是灰度图像，直接进行处理
        output_img = idealLowPassFilterSingleChannel(input_img, cutoff_frequency);
    end
end

function output_img = idealLowPassFilterSingleChannel(input_img, cutoff_frequency)
    % 对单通道图像进行理想低通滤波

    [rows, cols] = size(input_img);

    % 进行离散傅里叶变换
    img_dft = fft2(double(input_img));

    % 将频谱移到中心
    img_dft_shifted = fftshift(img_dft);

    % 创建理想低通滤波器
    [X, Y] = meshgrid(1:cols, 1:rows);
    centerX = floor(cols / 2) + 1;
    centerY = floor(rows / 2) + 1;
    
    % 计算每个频率点到中心的距离
    distance = sqrt((X - centerX).^2 + (Y - centerY).^2);
    
    % 创建滤波器，距离小于截止频率的部分为1，其它部分为0
    H = double(distance <= cutoff_frequency);
    
    % 将滤波器应用于频谱
    img_dft_filtered = img_dft_shifted .* H;
    
    % 进行逆傅里叶变换，得到滤波后的图像
    img_dft_inv_shifted = ifftshift(img_dft_filtered);
    output_img = real(ifft2(img_dft_inv_shifted));
    
    % 将输出图像转换回uint8类型
    output_img = uint8(output_img);
end
