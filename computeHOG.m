function [feature, image_hog_with_arrows] = computeHOG(Image, step, K)
    % computeHOG - 计算HOG特征并返回带有箭头的图像
    %
    % 语法: [feature, image_hog_with_arrows] = computeHOG(Image, step, K)
    %
    % 输入参数:
    %    Image - 输入的彩色或灰度图像
    %    step - HOG计算时的cell大小（步长）
    %    K - 梯度方向的数量（即直方图的分桶数）
    %
    % 输出参数:
    %    feature - HOG特征向量的单元数组
    %    image_hog_with_arrows - 带有HOG箭头的图像

    % 如果是彩色图像，则转换为灰度图
    if size(Image, 3) == 3
        Image_gray = rgb_to_gray(Image);
    else
        Image_gray = Image;
    end

    % 将图像转换为double类型
    Image_gray = double(Image_gray);

    [N, M] = size(Image_gray);
    Image_processed = sqrt(Image_gray);  % 对图像进行开根号操作

    % 计算梯度
    Hy = [-1 0 1];
    Hx = Hy';
    Gy = imfilter(Image_processed, Hy, 'replicate');
    Gx = imfilter(Image_processed, Hx, 'replicate');
    Grad = sqrt(Gx.^2 + Gy.^2);  % 计算梯度幅值
    Phase = atan2d(Gy, Gx);  % 计算梯度方向（度）
    Phase(Phase < 0) = Phase(Phase < 0) + 180;  % 将角度转换到[0, 180]范围内

    % HOG计算参数
    angle = 180 / K;  % 每个方向的角度大小
    numCellsX = floor(M / step);
    numCellsY = floor(N / step);
    Cell = cell(numCellsY, numCellsX);  % 预分配单元格数组

    % 计算HOG特征
    for i = 1:numCellsX
        for j = 1:numCellsY
            col_start = (i-1)*step + 1;
            col_end = i*step;
            row_start = (j-1)*step + 1;
            row_end = j*step;
            Gtmp = Grad(row_start:row_end, col_start:col_end);
            sumGrad = sum(Gtmp(:));
            if sumGrad == 0
                Gtmp_norm = Gtmp;
            else
                Gtmp_norm = Gtmp / sumGrad;  % 对每个cell的梯度进行归一化
            end
            Hist = zeros(1, K);  % 初始化梯度直方图
            for x = 1:step
                for y = 1:step
                    ang = Phase(row_start + y -1, col_start + x -1); 
                    if ang <= 180
                        bin = floor(ang / angle) + 1;
                        if bin > K  % 处理角度为180度的情况
                            bin = K;
                        end
                        Hist(bin) = Hist(bin) + Gtmp_norm(y, x);   
                    end
                end
            end
            Cell{j, i} = Hist;  % 存储每个cell的HOG特征
        end
    end

    % 特征提取
    feature = cell(1, (numCellsX-1)*(numCellsY-1));  % 初始化HOG特征向量的单元数组
    idx = 1;
    for i = 1:numCellsX-1
        for j = 1:numCellsY-1           
            f = [Cell{j, i} Cell{j, i+1} Cell{j+1, i} Cell{j+1, i+1}];
            f = f / sum(f);  % 归一化特征向量
            feature{idx} = f;  % 存储特征向量
            idx = idx + 1;
        end
    end

    % 准备输出图像，将原始图像转换为RGB格式
    % if size(Image, 3) == 1
    %     image_hog_with_arrows = cat(3, uint8(Image), uint8(Image), uint8(Image));  % 灰度图像转换为RGB
    % else
    %     image_hog_with_arrows = Image;
    % end
    image_hog_with_arrows = Image;

    % 初始化箭头线段列表
    lines = [];  % 每行是 [x1 y1 x2 y2]

    % 计算箭头的起点和方向
    for i = 1:numCellsX
        for j = 1:numCellsY
            Hist = Cell{j, i};

            % 将梯度直方图转换为HOG方向图
            for k = 1:K
                angle_start = (k - 1) * angle;  % 每个方向的起始角度
                angle_end = k * angle;          % 每个方向的结束角度
                intensity_k = Hist(k);         % 每个方向的强度
                if intensity_k == 0
                    continue;  % 跳过强度为0的方向
                end
                length = intensity_k * 25;      % 可以调节条的长度

                % 计算方向条的极坐标
                angle_center = (angle_start + angle_end) / 2;
                [dx, dy] = pol2cart(deg2rad(angle_center), length);  % 转换为笛卡尔坐标

                % 计算箭头的起点
                startX = (i - 0.5) * step;  % cell中心的x坐标
                startY = (j - 0.5) * step;  % cell中心的y坐标

                % 计算箭头的终点
                endX = startX + dx;
                endY = startY + dy;

                % 将箭头的起点和终点加入lines列表
                lines = [lines; startX, startY, endX, endY];
            end
        end
    end

    % 检查是否有箭头需要绘制
    if isempty(lines)
        disp('No arrows generated. Returning original image.');
        return;
    end

    % 使用 insertShape 批量绘制所有箭头
    % insertShape 需要图像为 uint8, uint16, int16, single 或 double
    % 支持 RGB 图像
    image_hog_with_arrows = insertShape(image_hog_with_arrows, 'Line', lines, 'Color', 'blue', 'LineWidth', 1);

end
