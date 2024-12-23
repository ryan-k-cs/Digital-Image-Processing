% 直方图均衡化
function equalized_img = histogramEqualization(gray_img)
    % 检查输入是否为灰度图
    if size(gray_img, 3) > 1
        error('输入必须是灰度图！');
    end

    % 获取图像大小和总像素数
    [rows, cols] = size(gray_img);
    num_pixels = rows * cols;

    % 计算灰度直方图
    hist = computeHistogram(gray_img);

    % 计算累计分布函数 (CDF)
    cdf = zeros(1, 256);
    cdf(1) = hist(1); % 第一个值等于直方图的第一个值
    for i = 2:256
        cdf(i) = cdf(i-1) + hist(i);
    end

    % 归一化累计分布函数，使其映射到 [0, 255]
    cdf_min = min(cdf(cdf > 0)); % 最小的非零值
    cdf_normalized = round((cdf - cdf_min) / (num_pixels - cdf_min) * 255);

    % 应用直方图均衡化映射规则
    equalized_img = zeros(rows, cols, 'uint8'); % 初始化均衡化后的图像
    for i = 1:rows
        for j = 1:cols
            equalized_img(i, j) = cdf_normalized(gray_img(i, j) + 1);
        end
    end
end
