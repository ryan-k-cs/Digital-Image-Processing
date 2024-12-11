% --- 直方图匹配函数 ---
function matchedImage = histogramMatching(sourceImage, targetImage)
    % 将图像转换为灰度图（如需要）
    if size(sourceImage, 3) == 3
        sourceImage = rgb2gray(sourceImage);
    end
    if size(targetImage, 3) == 3
        targetImage = rgb2gray(targetImage);
    end

    % 计算源图像和目标图像的灰度直方图及其累积分布函数 (CDF)
    sourceHist = computeHistogram(sourceImage);
    targetHist = computeHistogram(targetImage);

    sourceCdf = cumsum(sourceHist) / numel(sourceImage);
    targetCdf = cumsum(targetHist) / numel(targetImage);

    % 构建映射表，将源图像的灰度值映射到目标图像的灰度值
    mapping = zeros(256, 1, 'uint8');
    targetIndex = 1;
    for sourceIndex = 1:256
        while targetIndex < 256 && targetCdf(targetIndex) < sourceCdf(sourceIndex)
            targetIndex = targetIndex + 1;
        end
        mapping(sourceIndex) = targetIndex - 1;
    end

    % 根据映射表对源图像进行像素值替换
    matchedImage = mapping(double(sourceImage) + 1);
end