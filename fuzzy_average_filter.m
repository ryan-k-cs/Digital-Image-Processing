function result = fuzzy_average_filter(NoiseI, filterSize)
    % 输入：
    % NoiseI - 输入的噪声图像（可以是彩色图像）
    % filterSize - 邻域模板大小，模板为 (filterSize x filterSize)

    % 计算邻域模板的半径
    n = (filterSize - 1) / 2;

    % 将图像转换为 double 类型，方便计算
    NoiseI = im2double(NoiseI);

    % 获取图像的尺寸
    [height, width, channels] = size(NoiseI);

    % 扩展图像边界以便处理边缘像素
    hh = height + 2 * n;
    ww = width + 2 * n;
    ff = zeros(hh, ww, channels);

    % 将原图像填充到扩展后的图像中心
    ff(n+1:hh-n, n+1:ww-n, :) = NoiseI;

    % 初始化结果图像
    result = zeros(height, width, channels);

    % 对每个通道进行处理
    for c = 1:channels
        % 对每个像素进行模糊均值滤波
        for i = n+1:hh-n
            for j = n+1:ww-n
                % 提取当前邻域
                region = ff(i-n:i+n, j-n:j+n, c);

                % 计算当前像素与邻域像素的灰度差平方
                dd = (region - ff(i,j,c)).^2;

                % 计算方差估计
                bb = sum(dd(:)) / ((n*2+1)^2 - 1);

                % 计算权重矩阵
                dd = exp(-dd / bb) / bb;
                sumd = sum(dd(:)) - 1 / bb;

                % 加权求和
                weighted_sum = sum(sum(dd .* region)) - (1 / bb) * ff(i,j,c);

                % 存储结果
                result(i-n, j-n, c) = weighted_sum / sumd;
            end
        end
    end

    % 转换结果为 uint8，并返回
    result = uint8(result * 255);
end



