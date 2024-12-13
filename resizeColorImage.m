% function resizedImg = resizeColorImage(img, kx, ky)
%     % 获取图像的三个颜色通道
%     redChannel = img(:,:,1);
%     greenChannel = img(:,:,2);
%     blueChannel = img(:,:,3);
% 
%     % 对每个通道分别进行缩放
%     resizedRed = bilinearResize(redChannel, kx, ky);
%     resizedGreen = bilinearResize(greenChannel, kx, ky);
%     resizedBlue = bilinearResize(blueChannel, kx, ky);
% 
%     % 确保每个通道的像素值在合理范围
%     resizedRed = mat2gray(resizedRed);   % 对 double 类型进行归一化，范围 [0, 1]
%     resizedGreen = mat2gray(resizedGreen);
%     resizedBlue = mat2gray(resizedBlue);
% 
% 
% 
%     % 合并三个缩放后的通道
%     resizedImg = cat(3, resizedRed, resizedGreen, resizedBlue);
% end


function resizedImg = resizeColorImage(img, kx, ky)
    % 判断输入图像是否为彩色图像
    if size(img, 3) == 3
        % 获取图像的三个颜色通道
        redChannel = img(:,:,1);
        greenChannel = img(:,:,2);
        blueChannel = img(:,:,3);
        
        % 对每个通道分别进行缩放
        resizedRed = bilinearResize(redChannel, kx, ky);
        resizedGreen = bilinearResize(greenChannel, kx, ky);
        resizedBlue = bilinearResize(blueChannel, kx, ky);
        
        % 确保每个通道的像素值在合理范围
        resizedRed = mat2gray(resizedRed);   % 对 double 类型进行归一化，范围 [0, 1]
        resizedGreen = mat2gray(resizedGreen);
        resizedBlue = mat2gray(resizedBlue);

        % 合并三个缩放后的通道
        resizedImg = cat(3, resizedRed, resizedGreen, resizedBlue);
    else
        % 对灰度图像进行缩放
        resizedImg = bilinearResize(img, kx, ky);

        % 确保图像像素值在合理范围
        resizedImg = mat2gray(resizedImg);   % 对 double 类型进行归一化，范围 [0, 1]
    end
end
