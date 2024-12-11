% 线性变换函数
function linearImg = linearTransform(grayImg)
    minVal = double(min(grayImg(:)));
    maxVal = double(max(grayImg(:)));
    % 线性变换公式：标准化到 [0, 255]
    linearImg = uint8(255 * (double(grayImg) - minVal) / (maxVal - minVal));
end
