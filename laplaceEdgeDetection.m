function edgeImg = laplaceEdgeDetection(img)
    % 检查输入图像是否为彩色图像，若是则转换为灰度图像
    if size(img, 3) == 3
        img = rgb2gray(img);  % 如果是彩色图像，则转换为灰度图
    end
    
    % 将图像转换为 double 类型，便于计算
    img = double(img);
    
    % 定义拉普拉斯算子
    laplaceKernel = [0 1 0; 1 -4 1; 0 1 0];  % 拉普拉斯核
    
    % 获取图像的大小
    [rows, cols] = size(img);
    
    % 初始化梯度幅值图像
    edgeImg = zeros(rows, cols);
    
    % 对每个像素进行拉普拉斯算子卷积操作（排除边缘部分）
    for i = 2:rows-1
        for j = 2:cols-1
            % 提取当前像素周围的3x3区域
            region = img(i-1:i+1, j-1:j+1);
            
            % 计算拉普拉斯算子的响应
            edgeImg(i, j) = sum(sum(region .* laplaceKernel));
        end
    end
    
    % 对拉普拉斯算子的输出应用绝对值
    edgeImg = abs(edgeImg);
    
    % 将结果限制在 [0, 255] 范围内
    edgeImg = mat2gray(edgeImg) * 255;
    
    % 转换为 uint8 类型
    edgeImg = uint8(edgeImg);
end

