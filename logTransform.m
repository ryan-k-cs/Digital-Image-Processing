% 对数变换
function logImg = logTransform(grayImg)
    grayImg = double(grayImg);
    c = 255 / log(1 + max(grayImg(:))); % 对数常数
    logImg = uint8(c * log(1 + grayImg));
end
