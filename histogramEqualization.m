% 直方图均衡化
function output_img = histogramEqualization(gray_img)
    % 计算图像的灰度直方图
    hist = computeHistogram(gray_img);
    
    % 计算累积分布函数 (CDF)
    cdf = cumsum(hist) / numel(gray_img);
    
    % 线性变换公式
    output_img = uint8(255 * cdf(double(gray_img) + 1));
end



% % --- 直方图均衡化函数 ---
% function equalizedImage = histogramEqualization(gray_img)
%     % 计算灰度直方图
%     hist = computeHistogram(gray_img);
% 
%     % 计算累积分布函数 (CDF)
%     cdf = cumsum(hist);
%     cdf = cdf / cdf(end); % 归一化到 [0, 1]
% 
%     % 将原始灰度值映射到均衡化后的灰度值
%     equalizedImage = uint8(zeros(size(gray_img)));
%     for i = 1:numel(gray_img)
%         equalizedImage(i) = round(cdf(gray_img(i) + 1) * 255);
%     end
% end