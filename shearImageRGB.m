% function output_img = shearImageRGB(img, k_x, k_y)
%     % img 已经是 double 类型的图像，k_x 和 k_y 为错切因子
% 
%     [rows, cols, channels] = size(img);
% 
%     % 计算错切变换矩阵
%     S = [1, k_x, 0;
%          k_y, 1 + k_x * k_y, 0;
%          0, 0, 1];
% 
%     % 计算新的图像尺寸，原图四个角的变换坐标
%     corners = [1, 1, 1;
%                cols, 1, 1;
%                cols, rows, 1;
%                1, rows, 1]';
%     new_corners = S * corners;
% 
%     % 找出新的图像边界
%     min_x = floor(min(new_corners(1, :)));
%     max_x = ceil(max(new_corners(1, :)));
%     min_y = floor(min(new_corners(2, :)));
%     max_y = ceil(max(new_corners(2, :)));
% 
%     % 计算新图像的尺寸
%     new_cols = max_x - min_x + 1;
%     new_rows = max_y - min_y + 1;
% 
%     % 初始化输出图像，背景设置为黑色 (0)
%     output_img = zeros(new_rows, new_cols, channels);  % 设置为黑色背景
% 
%     % 逆向映射并使用双线性插值
%     for i = 1:new_rows
%         for j = 1:new_cols
%             % 计算新图像中的实际坐标
%             x_new = j + min_x - 1;
%             y_new = i + min_y - 1;
% 
%             % 构建目标坐标向量
%             dest_coord = [x_new; y_new; 1];
% 
%             % 计算原始坐标（逆变换）
%             inv_S = inv(S);
%             src_coord = inv_S * dest_coord;
%             x_src = src_coord(1);
%             y_src = src_coord(2);
% 
%             % 双线性插值
%             if x_src >= 1 && x_src <= cols && y_src >= 1 && y_src <= rows
%                 % 找到四个邻近的整数像素坐标
%                 x1 = max(1, floor(x_src));  % 边界处理
%                 x2 = min(cols, ceil(x_src));  % 边界处理
%                 y1 = max(1, floor(y_src));  % 边界处理
%                 y2 = min(rows, ceil(y_src));  % 边界处理
% 
%                 % 获取四个邻近像素的值
%                 Q11 = img(y1, x1, :);
%                 Q21 = img(y1, x2, :);
%                 Q12 = img(y2, x1, :);
%                 Q22 = img(y2, x2, :);
% 
%                 % 计算插值权重
%                 wx = x_src - x1;
%                 wy = y_src - y1;
% 
%                 % 双线性插值公式
%                 interp_val = (1 - wx) * (1 - wy) * Q11 + wx * (1 - wy) * Q21 + (1 - wx) * wy * Q12 + wx * wy * Q22;
% 
%                 % 将插值结果赋值给输出图像
%                 output_img(i, j, :) = interp_val;
%             else
%                 % 对于图像外部的区域，可以选择填充为背景色，白色
%                 output_img(i, j, :) = 255;
%             end
%         end
%     end
%     output_img = uint8(output_img);
% end



function output_img = shearImageRGB(img, k_x, k_y)
    % 输入：img - 原始图像 (double类型)
    %        k_x, k_y - 错切因子
    % 输出：output_img - 错切后的图像 (uint8类型)

    % 获取图像尺寸
    [rows, cols, channels] = size(img);

    % 计算新的图像尺寸
    new_cols = round(cols + abs(k_x) * rows);
    new_rows = round(rows + abs(k_y) * cols);

    % 初始化输出图像
    output_img =zeros(new_rows, new_cols, channels);

    % 错切变换公式
    for x = 1:new_cols
        for y = 1:new_rows
            % 逆变换计算原始坐标
            x_src = (x - 1 - k_x * (y - 1)) / (1 - k_x * k_y); 
            y_src = (y - 1 - k_y * (x - 1)) / (1 - k_x * k_y);

            % 如果计算得到的坐标在原图像范围内，则进行插值
            if x_src >= 1 && x_src <= cols && y_src >= 1 && y_src <= rows
                for c = 1:channels
                    % 双线性插值
                    x1 = floor(x_src); x2 = ceil(x_src);
                    y1 = floor(y_src); y2 = ceil(y_src);

                    % 边界检查
                    x1 = max(1, x1); x2 = min(cols, x2);
                    y1 = max(1, y1); y2 = min(rows, y2);

                    % 获取插值所需的四个像素
                    Q11 = img(y1, x1, c);
                    Q12 = img(y1, x2, c);
                    Q21 = img(y2, x1, c);
                    Q22 = img(y2, x2, c);

                    % 计算插值权重
                    a = x_src - x1;
                    b = y_src - y1;

                    % 双线性插值公式
                    value = (1 - a) * (1 - b) * Q11 + a * (1 - b) * Q12 + (1 - a) * b * Q21 + a * b * Q22;
                    output_img(y, x, c) = value;
                end
            else
                % 如果坐标超出原图像范围，填充为白色
                output_img(y, x, :) = 255;
            end
        end
    end

    % 将输出图像转换为 uint8 类型
    output_img = uint8(output_img);
end

