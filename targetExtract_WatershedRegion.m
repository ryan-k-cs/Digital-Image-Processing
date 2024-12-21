function output_image = targetExtract_WatershedRegion(input_image)
    % 提取目标区域，输入是彩色图像，输出是目标区域
    % input_image: 输入的彩色图像
    % output_image: 输出的只包含目标区域，其他部分为黑色的图像
    
    % Step 1: 图像预处理
    image = im2double(rgb_to_gray(input_image)); % 将彩色图像转换为灰度图像
    hv = fspecial('prewitt');  % 水平方向的Prewitt滤波器
    hh = hv.';  % 垂直方向的Prewitt滤波器
    
    % 计算梯度
    gv = abs(imfilter(image, hv, 'replicate'));
    gh = abs(imfilter(image, hh, 'replicate'));
    g = sqrt(gv.^2 + gh.^2);  % 总梯度
    
    % 对梯度图像进行中值滤波
    g = medfilt2(g, [5, 5]);
    
    % Step 2: 分水岭变换
    L = watershed(g);  % 进行分水岭变换
    
    % Step 3: 提取目标区域
    num = max(L(:));  % 获取最大标签数，即区域数量
    
    % 计算每个区域的平均灰度值
    avegray = zeros(num, 1);
    for i = 1:num
        avegray(i) = mean(image(L == i));  % 计算每个区域的平均灰度值
    end
    
    % 合并相似灰度值的区域
    thresh = 0.3;
    [N, M] = size(L);
    for i = 2:M-1
        for j = 2:N-1
            if L(j, i) == 0  % 如果当前像素是分水岭边界
                neighbor = [L(j-1, i+1), L(j, i+1), L(j+1, i+1), L(j-1, i), L(j+1, i), ...
                            L(j-1, i-1), L(j, i-1), L(j+1, i-1)];
                neicode = unique(neighbor);  % 获取相邻区域的标签
                neicode = neicode(neicode ~= 0);  % 去除分水岭边界（标签为0的部分）
                neinum = length(neicode);  % 获取相邻区域的数量
                for n = 1:neinum - 1
                    for m = n + 1:neinum
                        if abs(avegray(neicode(m)) - avegray(neicode(n))) < thresh  % 如果灰度值差异小于阈值
                            L(L == neicode(m)) = neicode(n);  % 合并区域
                        end
                    end
                end
            end
        end
    end
    
    % 再次处理分水岭边界
    for i = 2:M-1
        for j = 2:N-1
            if L(j, i) == 0  % 如果当前像素是分水岭边界
                neighbor = [L(j-1, i+1), L(j, i+1), L(j+1, i+1), L(j-1, i), L(j+1, i), ...
                            L(j-1, i-1), L(j, i-1), L(j+1, i-1)];
                neicode = unique(neighbor);  % 获取相邻区域的标签
                neicode = neicode(neicode ~= 0);  % 去除分水岭边界（标签为0的部分）
                neinum = length(neicode);  % 获取相邻区域的数量
                if neinum == 1  % 如果只有一个相邻区域
                    L(j, i) = neicode(neinum);  % 将当前像素标记为唯一的相邻区域标签
                end
            end
        end
    end
    
    % Step 4: 提取目标区域
    target_area = (L > 1);  % 目标区域的标签大于1，排除分水岭边界
    
    % Step 5: 创建输出图像，将目标区域以外的部分设为黑色
    output_image = zeros(size(image));  % 初始化全黑的输出图像
    output_image(target_area) = image(target_area);  % 只保留目标区域
    
end
