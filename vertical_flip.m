function result = vertical_flip(img)
    % 垂直镜像：交换行
    result = img(end:-1:1, :, :);
end
