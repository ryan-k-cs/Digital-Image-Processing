function lbp = computeLBP(image)
    % computeLBP 计算图像的LBP特征图
    % 输入：
    %   image - 输入的图像，可以是彩色图像或灰度图像
    % 输出：
    %   lbp - 计算得到的LBP特征图

    % 如果是彩色图像，先转换为灰度图像
    if size(image, 3) == 3
        image = rgb_to_gray(image);
    end

    % 获取图像的尺寸
    [N, M] = size(image);
    lbp = zeros(N, M);  % 初始化LBP特征图

    % 对每个像素计算LBP值（不处理边缘）
    for j = 2:N-1
        for i = 2:M-1
            % 获取当前像素周围8个邻域的坐标
            neighbor = [j-1 i-1; j-1 i; j-1 i+1; j i+1; j+1 i+1; j+1 i; j+1 i-1; j i-1];
            count = 0;
            % 遍历邻域像素并计算LBP值
            for k = 1:8
                if image(neighbor(k,1), neighbor(k,2)) > image(j, i)
                    count = count + 2^(8 - k);
                end
            end
            lbp(j, i) = count;  % 将计算得到的LBP值赋给特征图
        end
    end

    lbp = uint8(lbp);  % 将结果转换为无符号8位整数

end
