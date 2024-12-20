% function extracted_img = targetExtraction(input_img)
%     % Step 1: 灰度化 (如果输入图像已经是灰度图像，可以跳过)
%     gray_img = rgb_to_gray(input_img);
% 
%     % Step 2: 高斯平滑
%     smoothed_img = gaussianFilter(gray_img, 5, 1.0);  % 使用自定义的高斯滤波
% 
%     % Step 3: 使用Otsu算法进行阈值分割
%     threshold = otsu_threshold_custom(smoothed_img);
%     binary_img = smoothed_img > threshold;  % 将图像二值化
% 
%     % Step 4: 连通域分析，提取最大连通域（假设鸟是最大的目标）
%     labels = connected_components(binary_img);
%     bird_mask = (labels == 1);  % 假设最大的连通域是鸟的区域
% 
%     % Step 5: 应用掩膜到原始彩色图像
%     extracted_img = apply_mask(input_img, bird_mask);
% end
% 
% % Otsu阈值分割
% function threshold = otsu_threshold_custom(input_img)
%     [counts, gray_levels] = imhist(input_img);
%     total_pixels = sum(counts);
%     prob = counts / total_pixels;
%     sum_total = sum(gray_levels .* prob);
% 
%     max_var = 0;
%     threshold = 0;
%     for t = 1:length(counts)-1
%         prob1 = sum(prob(1:t));
%         prob2 = sum(prob(t+1:end));
%         mean1 = sum(gray_levels(1:t) .* prob(1:t)) / prob1;
%         mean2 = sum(gray_levels(t+1:end) .* prob(t+1:end)) / prob2;
%         var_between = prob1 * prob2 * (mean1 - mean2)^2;
%         if var_between > max_var
%             max_var = var_between;
%             threshold = gray_levels(t);
%         end
%     end
% end
% 
% % 连通域分析
% function labels = connected_components(binary_img)
%     [rows, cols] = size(binary_img);
%     labels = zeros(rows, cols);  % 创建标签矩阵
%     current_label = 1;
% 
%     for i = 1:rows
%         for j = 1:cols
%             if binary_img(i, j) == 1 && labels(i, j) == 0
%                 labels = flood_fill(binary_img, labels, i, j, current_label);
%                 current_label = current_label + 1;
%             end
%         end
%     end
% end
% 
% % 连通域标记（Flood Fill算法）
% function labels = flood_fill(binary_img, labels, x, y, label)
%     [rows, cols] = size(binary_img);
%     stack = [x, y];
%     while ~isempty(stack)
%         pixel = stack(end, :);
%         stack(end, :) = [];
%         i = pixel(1);
%         j = pixel(2);
%         if i > 0 && i <= rows && j > 0 && j <= cols && binary_img(i, j) == 1 && labels(i, j) == 0
%             labels(i, j) = label;
%             stack = [stack; i+1, j; i-1, j; i, j+1; i, j-1];  % 添加邻居像素
%         end
%     end
% end
% 
% % 应用掩膜到原始图像
% function output_img = apply_mask(input_img, mask)
%     % 将掩膜应用到彩色图像
%     [rows, cols, channels] = size(input_img);
%     output_img = zeros(rows, cols, channels, 'uint8');  % 初始化输出图像
%     for c = 1:channels
%         channel = input_img(:,:,c);
%         channel(~mask) = 0;  % 将非目标区域设置为黑色
%         output_img(:,:,c) = channel;
%     end
% end






function [birdMask, extracted_img] = targetExtraction(I)
    % targetExtraction 对鸟类图片进行目标提取
    %
    % 输入：
    %   I - 输入图像，可以是彩色图像或灰度图像
    %
    % 输出：
    %   birdMask - 二值掩码，前景（鸟类）为1，背景为0
    %   extracted_img - 应用掩码后的彩色图像，背景为黑色，前景为原色


    % 检查输入图像是否为彩色图像，如果是，转换为 Lab 颜色空间
    if size(I, 3) == 3
        I_lab = rgb2lab(I);
    else
        I_lab = I;
    end

    % 将图像重塑为二维矩阵，每行是一个像素的特征
    if size(I_lab, 3) == 3
        pixels = reshape(I_lab, [], 3);
    else
        pixels = double(I_lab(:));
    end

    % 设置聚类数目为2（前景和背景）
    K = 2;

    % 应用 K-means 聚类
    fprintf('正在进行 K-means 聚类，请稍候...\n');
    [cluster_idx, ~] = kmeans(pixels, K, 'Replicates', 10, 'MaxIter', 400);

    % 将聚类结果重新转换为图像格式
    clusterImage = reshape(cluster_idx, size(I,1), size(I,2));

    % 显示聚类结果供用户选择前景类别
    figure;
    imshow(label2rgb(clusterImage));
    title('K-means 聚类结果');

    % 让用户点击图像中的一个点以选择前景类别
    disp('请点击鸟类所在的区域以选择前景类别...');
    [x, y] = ginput(1);
    x = round(x);
    y = round(y);

    % 获取点击点的类别
    selectedCluster = clusterImage(y, x);

    % 创建二值掩码
    birdMask = clusterImage == selectedCluster;

    % 填充前景区域中的孔洞
    birdMask = imfill(birdMask, 'holes');

    % 移除小的噪声区域
    birdMask = bwareaopen(birdMask, 500);

    % 关闭聚类结果图像
    close(gcf);

    % 应用掩膜到原始彩色图像
    if size(I, 3) == 3
        extracted_img = I;
        extracted_img(repmat(~birdMask, [1, 1, 3])) = 0;
    else
        % 对于灰度图像，直接将非目标区域设置为0
        extracted_img = I;
        extracted_img(~birdMask) = 0;
    end

end



