% 指数变换
function expImg = expTransform(grayImg)
    grayImg = double(grayImg);
    c = 255 / (exp(max(grayImg(:)) / 255) - 1); % 指数常数
    expImg = uint8(c * (exp(grayImg / 255) - 1));
end
