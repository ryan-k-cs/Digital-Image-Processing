function output_value = threeSegmentLinearTransform(input_value, a, b, c, d)
    % 三段线性灰度级变换
    % 输入:
    %   input_value: 输入像素值 (0-1 或 0-255)
    %   a, b: 分段阈值 (输入灰度值范围中的两个分段点)
    %   c, d: 输出灰度值范围对应的映射点
    % 输出:
    %   output_value: 经过三段线性变换后的像素值
    a=30/256; b=100/256; c=75/256; d=250/256;  %参数设置        
    if input_value < a 
        % 第一段 [0, a]
        output_value = input_value * c / a;
    elseif input_value < b
        % 第二段 [a, b]
        output_value = (input_value - a) * (d - c) / (b - a) + c;
    else
        % 第三段 [b, 1]
        output_value = (input_value - b) * (1 - d) / (1 - b) + d;
    end
end