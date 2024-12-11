% 直方图匹配（规定化）
function output_img = histogramSpecification(gray_img, target_hist)
    % 计算源图像的累积分布函数 (CDF)
    source_hist = computeHistogram(gray_img);
    source_cdf = cumsum(source_hist) / numel(gray_img);
    
    % 目标图像的累积分布函数 (CDF)
    target_cdf = cumsum(target_hist) / numel(target_hist);
    
    % 进行直方图匹配
    output_img = gray_img;
    for i = 1:256
        [~, idx] = min(abs(source_cdf(i) - target_cdf));
        output_img(gray_img == i - 1) = idx - 1;
    end
end
