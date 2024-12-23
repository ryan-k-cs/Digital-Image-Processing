function output_img = piecewiseLinearTransform(input_img)
    % 输入：
    %   input_img: 输入图像（灰度或彩色）
    % 输出：
    %   output_img: 经过分段线性变换后的灰度图像

    % 检查是否为彩色图像，如果是则转换为灰度图
    if size(input_img, 3) == 3
        input_img = rgb_to_gray(input_img);
    end

    % 将输入图像转换为双精度数组
    input_img = double(input_img);

    % 动态生成控制点：5个点
    num_points = 5;  % 控制点数量
    x_points = linspace(0, 255, num_points);  % 灰度值等间隔分布
    y_points = [0, 50, 180, 220, 255];        % 自定义输出灰度值映射关系

    % 初始化输出图像
    [rows, cols] = size(input_img);
    output_img = zeros(rows, cols);

    % 对每个像素进行分段线性插值
    for i = 1:rows
        for j = 1:cols
            pixel_value = input_img(i, j);  % 当前像素值
            % 找到当前像素所在的分段
            for k = 1:(num_points - 1)
                if pixel_value >= x_points(k) && pixel_value <= x_points(k + 1)
                    % 线性插值计算
                    x1 = x_points(k);
                    y1 = y_points(k);
                    x2 = x_points(k + 1);
                    y2 = y_points(k + 1);
                    output_img(i, j) = y1 + (pixel_value - x1) * (y2 - y1) / (x2 - x1);
                    break;
                end
            end
        end
    end

    % 转换为 uint8 格式输出
    output_img = uint8(output_img);
end
