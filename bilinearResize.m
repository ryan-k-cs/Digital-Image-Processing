% 双线性插值函数
function g = bilinearResize(f, kx, ky)
    [srcH, srcW] = size(f);
    dstH = ceil(srcH * ky);
    dstW = ceil(srcW * kx);
    g = zeros(dstH, dstW);

    for dstX = 1:dstW
        for dstY = 1:dstH
            srcX = (dstX-1)/kx;
            srcY = (dstY-1)/ky;
            x = floor(srcX)+1;
            y = floor(srcY)+1;
            a = srcX - floor(srcX);
            b = srcY - floor(srcY);

            if x<srcW && y<srcH
                g(dstY,dstX) = f(y,x) + b*(f(y+1,x)-f(y,x)) + a*(f(y,x+1)-f(y,x)) + a*b*(f(y+1,x+1)+f(y,x) - f(y,x+1)-f(y+1,x));
            elseif x>= srcW && y<srcH % 左上角的点在右边界，只能在垂直方向插值
                g(dstY,dstX) = f(y,x) + b*(f(y+1,x)-f(y,x));
            elseif x<srcW && y>= srcH % 左上角的点在下边界，只能在水平方向插值
                g(dstY,dstX) = f(y,x) + a*(f(y,x+1)-f(y,x));
            else
                g(dstY,dstX) = f(y,x);
            end
        end
    end
end