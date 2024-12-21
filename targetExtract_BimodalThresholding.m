function [result] =targetExtract_BimodalThresholding(I)
    % BimodalThresholding 使用基于双峰直方图的阈值化方法
    % 输入：
    %   I - 输入图像，可以是彩色图像或灰度图像
    %
    % 输出：
    %   result - 处理后的二值化图像（前景为1，背景为0）
    
    % 检查输入图像是否为彩色图像，如果是，转换为灰度图像
    if size(I, 3) == 3
        I = rgb_to_gray(I);
    end
    
    % 基于双峰分布的直方图选择阈值
    [thresh, hist1] = BimodalThreshold(I);

    % 执行阈值化操作
    % result = I > thresh;
    binary_mask = I > thresh;

   % 如果输入图像是彩色图像，则扩展二值掩码到三通道
    if size(I, 3) == 3
        % 创建一个与原图像大小相同的矩阵，保持原图的目标区域，背景设置为零
        extracted_img = I;  % 复制原图
        extracted_img(repmat(~binary_mask, [1, 1, 3])) = 0;  % 背景部分设为黑色
    else
        % 对于灰度图像，直接使用二值掩码进行处理
        extracted_img = I;
        extracted_img(~binary_mask) = 0;  % 背景部分设为零
    end
    
    result = extracted_img;

end

function [thresh, hist1] = BimodalThreshold(I)
    % BimodalThreshold 使用基于双峰直方图的阈值化方法
    % 输入：
    %   I - 输入灰度图像
    %
    % 输出：
    %   thresh - 阈值
    %   hist1  - 归一化的直方图

    % 计算图像的直方图
    hist1 = computeHistogram(I);
    hist2 = hist1;
    iter = 0;

    % 迭代平滑过程，直到满足条件
    while true
        [is, peak] = Bimodal(hist1);
        if is == 0
            hist2(1) = (hist1(1)*2 + hist1(2)) / 3;
            for j = 2:255
                hist2(j) = (hist1(j-1) + hist1(j) + hist1(j+1)) / 3;
            end
            hist2(256) = (hist1(255) + hist1(256)*2) / 3;
            hist1 = hist2;
            iter = iter + 1;
            if iter > 1000
                break;
            end
        else
            break;
        end
    end

    % 找到双峰的低谷并计算阈值
    [trough, pos] = min(hist1(peak(1):peak(2)));
    thresh = pos + peak(1);
end


function [is, peak] = Bimodal(histgram)
    % Bimodal 检测直方图中的双峰
    % 
    % 输入：
    %   histgram - 输入的直方图
    %
    % 输出：
    %   is - 返回1表示检测到双峰，0表示未检测到
    %   peak - 双峰的峰值索引

    count = 0;
    for j = 2:255
        if histgram(j-1) < histgram(j) && histgram(j+1) < histgram(j)
            count = count + 1;
            peak(count) = j;
            if count > 2
                is = 0;
                return;
            end
        end
    end
    if count == 2
        is = 1;
    else
        is = 0;
    end
end
