function noisy_img = addSaltAndPepperNoise(img, density)
    % 添加椒盐噪声
    % 输入：
    %   img - 原始图像（灰度或彩色图像）
    %   density - 噪声密度（范围 [0, 1]，例如 0.02 表示 2% 的像素添加噪声）
    % 输出：
    %   noisy_img - 加入椒盐噪声后的图像

    % 将图像转换为 double 类型，便于计算
    img = im2double(img);

    % 初始化噪声图像为原图像
    noisy_img = img;

    % 计算图像总像素数
    num_pixels = numel(img);

    % 计算盐噪声和椒噪声的像素数量
    num_salt = round(density * num_pixels / 2); % 盐噪声数量
    num_pepper = round(density * num_pixels / 2); % 椒噪声数量

    % 添加盐噪声（像素值设为1）
    salt_idx = randperm(num_pixels, num_salt); % 随机选择像素位置
    noisy_img(salt_idx) = 1;

    % 添加椒噪声（像素值设为0）
    pepper_idx = randperm(num_pixels, num_pepper); % 随机选择像素位置
    noisy_img(pepper_idx) = 0;

    % 转换回 uint8 类型输出
    noisy_img = im2uint8(noisy_img);
end
