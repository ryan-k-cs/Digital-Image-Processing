function output_img = bilateralFilter(input_img, filter_size, sigma_d, sigma_r)
    % input_img: 输入图像，灰度图像或彩色图像
    % filter_size: 滤波器的大小，通常是一个奇数，例如 5
    % sigma_d: 空间域的标准差，控制邻域的影响范围
    % sigma_r: 灰度域的标准差，控制像素值的相似度

    [rows, cols, channels] = size(input_img);
    
    % 将输入图像转换为 double 类型
    input_img = double(input_img);
    
    % 初始化输出图像
    output_img = zeros(size(input_img));
    
    % 为每个通道处理
    half_size = floor(filter_size / 2);
    
    for c = 1:channels
        for i = 1 + half_size : rows - half_size
            for j = 1 + half_size : cols - half_size
                % 初始化权重
                weight_sum = 0;
                filtered_pixel = 0;
                
                % 遍历滤波器大小
                for m = -half_size:half_size
                    for n = -half_size:half_size
                        % 获取邻域像素
                        ni = i + m;
                        nj = j + n;
                        
                        % 计算空间权重（基于距离）
                        spatial_weight = exp(-((m^2 + n^2) / (2 * sigma_d^2)));
                        
                        % 计算灰度权重（基于像素值差异）
                        color_weight = exp(-((input_img(i,j,c) - input_img(ni,nj,c))^2 / (2 * sigma_r^2)));
                        
                        % 计算总的权重
                        weight = spatial_weight * color_weight;
                        
                        % 累加加权像素值
                        filtered_pixel = filtered_pixel + input_img(ni, nj, c) * weight;
                        weight_sum = weight_sum + weight;
                    end
                end
                
                % 计算输出像素值
                output_img(i, j, c) = filtered_pixel / weight_sum;
            end
        end
    end
    
    % 转换回 uint8 类型
    output_img = uint8(output_img);
end
