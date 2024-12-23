function output_img = medianFilter(input_img, filter_size)
    % input_img: 输入图像，灰度图像或彩色图像
    % filter_size: 滤波器的大小，例如3表示3x3的滤波器

    [rows, cols, channels] = size(input_img);

    % 转换为 double 类型，便于计算
    input_img = double(input_img);

    % 初始化输出图像
    output_img = zeros(size(input_img));

    % 计算滤波器的半径
    half_size = floor(filter_size / 2);

    % 遍历每个通道（支持彩色图像）
    for c = 1:channels
        for i = 1 + half_size : rows - half_size
            for j = 1 + half_size : cols - half_size
                % 提取当前窗口
                window = input_img(i-half_size:i+half_size, j-half_size:j+half_size, c);

                % 计算中值并赋值
                output_img(i, j, c) = median(window(:));
            end
        end
    end

    % 转换回 uint8 类型
    output_img = uint8(output_img);
end



% function output_img = medianFilter(input_img, filter_size)
%     % 快速中值滤波实现，使用 colfilt
%     input_img = double(input_img);
%     output_img = zeros(size(input_img));
%     for c = 1:size(input_img, 3)
%         % 使用 colfilt 高效计算中值滤波
%         output_img(:, :, c) = colfilt(input_img(:, :, c), [filter_size filter_size], 'sliding', @median);
%     end
%     output_img = uint8(output_img);
% end
