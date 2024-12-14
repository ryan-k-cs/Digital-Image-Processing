function edgeImg = sobelEdgeDetection(img)
    % 检查输入图像是否为彩色图像，若是则转换为灰度图像
    if size(img, 3) == 3
        img = rgb2gray(img);  % 如果是彩色图像，则转换为灰度图
    end
    
    % 将图像转换为 double 类型，便于计算
    img = double(img);
    
    % 定义Sobel算子的两个卷积核（模板）
    Gx = [-1 0 1; -2 0 2; -1 0 1];  % 水平梯度
    Gy = [-1 -2 -1; 0 0 0; 1 2 1];  % 垂直梯度
    
    % 获取图像的大小
    [rows, cols] = size(img);
    
    % 初始化梯度幅值图像
    edgeImg = zeros(rows, cols);
    
    % 对每个像素进行Sobel算子卷积操作（排除边缘部分）
    for i = 2:rows-1
        for j = 2:cols-1
            % 提取当前像素周围的3x3区域
            region = img(i-1:i+1, j-1:j+1);
            
            % 计算水平和垂直方向的梯度
            Gx_val = sum(sum(region .* Gx));  % 水平梯度
            Gy_val = sum(sum(region .* Gy));  % 垂直梯度
            
            % 计算梯度幅值（边缘强度）
            edgeImg(i, j) = sqrt(Gx_val^2 + Gy_val^2);
        end
    end
    
    % 将结果限制在 [0, 255] 范围内，并转换为 uint8 类型
    edgeImg = uint8(mat2gray(edgeImg) * 255);
end
