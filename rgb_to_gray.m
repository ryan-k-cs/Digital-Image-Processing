function gray_img = rgb_to_gray(img)
    % 检查输入图像是否是 RGB 图像
    if size(img, 3) ~= 3
        error('输入图像必须是RGB图像');
    end
    
    % 灰度 = 0.299 * R + 0.587 * G + 0.114 * B
    gray_img = 0.299 * double(img(:,:,1)) + 0.587 * double(img(:,:,2)) + 0.114 * double(img(:,:,3));
    
    % 转换为 uint8 类型
    gray_img = uint8(gray_img);
end
