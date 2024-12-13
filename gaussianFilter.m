function output_img = gaussianFilter(input_img, filter_size, sigma)
    % input_img: 输入图像，可以是灰度图像或彩色图像
    % filter_size: 高斯滤波器的大小（例如3表示3x3的滤波器）
    % sigma: 高斯滤波器的标准差，决定了模糊程度

    [rows, cols, channels] = size(input_img);

    % 生成高斯滤波器核
    h = fspecial('gaussian', filter_size, sigma);

    % 对每个通道分别进行高斯滤波处理
    output_img = zeros(size(input_img));
    
    for c = 1:channels
        % 对每个通道应用高斯滤波
        output_img(:,:,c) = imfilter(input_img(:,:,c), h, 'same', 'replicate');
    end

    % 如果是彩色图像，结果需要转回 uint8 类型
    output_img = uint8(output_img); 
end
