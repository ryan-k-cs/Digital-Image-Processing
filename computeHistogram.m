% 计算灰度直方图
function hist = computeHistogram(gray_img)
    if size(gray_img, 3) > 1
        error('输入必须是灰度图！');
    end

    hist = zeros(1, 256);
    for i = 1:numel(gray_img)
        hist(gray_img(i) + 1) = hist(gray_img(i) + 1) + 1;
    end
end