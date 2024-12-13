% 指数变换
function expImg = expTransform(grayImg)
    grayImg = double(grayImg);
    c = 255 / (exp(max(grayImg(:)) / 255) - 1); % 指数常数
    expImg = uint8(c * (exp(grayImg / 255) - 1));
end

% function imgOut = expTransform(img)
%     % 将输入图像转换为double类型
%     img = double(img);
% 
%     % 获取图像的最小值和最大值
%     minVal = min(img(:));
%     maxVal = max(img(:));
% 
%     % 定义增强常数（可以根据图像的特性动态调整）
%     c = 10;  % 这是一个例子，可以根据需求调整
% 
%     % 动态增强：根据图像的灰度值来决定增强的程度
%     % 增强过程对暗部的区域应用较强的增强
%     imgOut = 1 - exp(-c * (img - minVal) / (maxVal - minVal)); 
% 
%     % 将结果限制在 [0, 1] 范围内
%     imgOut = mat2gray(imgOut);
% 
%     % 转换回 uint8 类型，适合显示
%     imgOut = uint8(imgOut * 255);
% end
