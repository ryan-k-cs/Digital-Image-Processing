function result = horizontal_flip(img)
    % 水平镜像：交换列
    result = img(:, end:-1:1, :);
end
