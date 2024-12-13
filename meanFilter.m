function output_img = meanFilter(input_img, filter_size)
    % 创建均值滤波器
    kernel = ones(filter_size) / (filter_size^2);  % 创建一个均值滤波核
    
    % 将输入图像转换为 double 类型，防止溢出
    input_img = double(input_img);
    
    % 对图像进行卷积操作
    if size(input_img, 3) == 1
        % 如果是灰度图像，直接使用conv2
        output_img = conv2(input_img, kernel, 'same');
    else
        % 如果是彩色图像，对每个通道进行卷积操作
        output_img = zeros(size(input_img));
        for c = 1:size(input_img, 3)
            output_img(:, :, c) = conv2(input_img(:, :, c), kernel, 'same');
        end
    end
    
    % 将结果转换回 uint8 类型（如果输入是 uint8 类型）
    output_img = uint8(output_img);
end
