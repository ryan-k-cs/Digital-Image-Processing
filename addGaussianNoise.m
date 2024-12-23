function noisy_img = addGaussianNoise(img, mean, variance)
    % 添加高斯噪声
    % 输入：
    %   img - 原始图像（灰度或彩色图像）
    %   mean - 高斯噪声的均值
    %   variance - 高斯噪声的方差
    % 输出：
    %   noisy_img - 加入高斯噪声后的图像

    % 将图像转换为 double 类型，便于计算
    img = im2double(img);

    % 生成高斯噪声
    noise = sqrt(variance) * randn(size(img)) + mean;

    % 将噪声叠加到原图像
    noisy_img = img + noise;

    % 限制噪声图像的范围到 [0, 1]
    noisy_img = min(max(noisy_img, 0), 1);

    % 转换回 uint8 类型输出
    noisy_img = im2uint8(noisy_img);
end
