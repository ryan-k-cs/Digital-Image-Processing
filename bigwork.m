function varargout = bigwork(varargin)
% BIGWORK MATLAB code for bigwork.fig
%      BIGWORK, by itself, creates a new BIGWORK or raises the existing
%      singleton*.
%
%      H = BIGWORK returns the handle to a new BIGWORK or the handle to
%      the existing singleton*.
%
%      BIGWORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIGWORK.M with the given input arguments.
%
%      BIGWORK('Property','Value',...) creates a new BIGWORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bigwork_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bigwork_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bigwork

% Last Modified by GUIDE v2.5 24-Dec-2024 01:12:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bigwork_OpeningFcn, ...
                   'gui_OutputFcn',  @bigwork_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before bigwork is made visible.
function bigwork_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bigwork (see VARARGIN)

% Choose default command line output for bigwork
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bigwork wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = bigwork_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
% 选择图片按钮
function pushbutton1_Callback(hObject, eventdata, handles)
    [filename, path] = uigetfile({'*.jpg;*.png'}, '请选择一张图片');
     % 如果用户没有取消选择，filename 和 path 不为空
    if filename ~= 0
        % 构建完整的文件路径
        fullpath = fullfile(path, filename);        
        % 读取图片
        img = imread(fullpath);

        % 去除路径末尾的斜杠（如果有的话）
        if path(end) == filesep
            path = path(1:end-1);  % 移除末尾的斜杠
        end
        
        % 使用 strsplit 通过文件分隔符分割路径，并获取最后一部分作为文件夹名称
        path_parts = strsplit(path, filesep);
        parent_dir_name = path_parts{end};  % 获取最后一部分，即文件夹名

        
        % 将图片存储在 handles 结构中，以便其他回调函数可以访问
        handles.img = img; % 将图片保存在 handles 结构中的 img 字段
        handles.source_img = img;
        handles.parent_dir_name = parent_dir_name; % 将父目录保存在 handles 结构中的 parent_dir 字段
        guidata(hObject, handles); % 更新 handles


         % 在 text25 控件中显示分类
        set(handles.text25, 'String', parent_dir_name); 

        % 在 GUI 的 axes 控件中显示图片
        axes(handles.axes1);  % 将当前的 axes 设置为 axes1
        imshow(img);          % 显示图片


        % 转为灰度图
        grayImage = rgb_to_gray(img);
        axes(handles.axes11);
        imshow(grayImage);


        % 显示灰度直方图
        axes(handles.axes3);
        hist = computeHistogram(grayImage);
        bar(0:255, hist); % 绘制直方图
        xlim([0 255]);
        % title('灰度直方图');
        xlabel('灰度值');
        ylabel('像素数');



         % --- 直方图均衡化 ---
        % 对灰度图进行均衡化
        equalizedImage = histogramEqualization(grayImage);

        % 显示均衡化后的灰度图
        axes(handles.axes4);
        imshow(equalizedImage);
        % title('直方图均衡化后的图像');

        % 显示均衡化后的直方图
        axes(handles.axes5);
        equalizedHist = computeHistogram(equalizedImage);
        bar(0:255, equalizedHist);
        xlim([0 255]);
        % title('均衡化后的直方图');
        xlabel('灰度值');
        ylabel('像素数');

        % 保存灰度图到 handles
        handles.zhifangtugrayImage = grayImage;
        guidata(hObject, handles); % 更新 handles 数据

        


    else
        % 如果没有选择文件，显示消息
        disp('未找到图片');
    end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
    % 检查是否加载了图像
    if ~isfield(handles, 'img') || isempty(handles.img)
        errordlg('请先选择一张图片！', '错误');
        return;
    end

    % 获取复选框状态
    isResizeChecked = get(handles.checkbox2, 'Value');  % 判断是否进行缩放
    isRotateChecked = get(handles.checkbox3, 'Value');  % 判断是否进行旋转
    isShearChecked = get(handles.checkbox4, 'Value');   % 判断是否进行错切
    isAddNoiseChecked = get(handles.checkbox7, 'Value');  % 判断是否选择加噪
    isFilterChecked = get(handles.checkbox8, 'Value'); % 判断是否进行滤波（复选框）
    isMirrorChecked = get(handles.checkbox9, 'Value'); % 判断是否进行镜像
    isContrastChecked = get(handles.checkbox10, 'Value');  % 判断是否勾选对比度增强
    isEdgeExtractionChecked = get(handles.checkbox11, 'Value');  % 判断是否进行边缘提取
    isTargetExtractionChecked = get(handles.checkbox12, 'Value');  % 判断是否进行目标提取
    isGeometricTransformationChecked = get(handles.checkbox14, 'Value'); % 判断是否进行几何变换

     % 获取镜像类型（水平或垂直）
    if isMirrorChecked
        mirrorType = get(handles.popupmenu3, 'Value'); % 获取下拉框的值，1为水平镜像，2为垂直镜像
    else
        mirrorType = 0; % 如果没有勾选镜像，设置为0
    end

    % 获取缩放倍数（如果需要）
    kx = str2double(get(handles.edit1, 'String')); % 宽度缩放倍数
    ky = str2double(get(handles.edit3, 'String')); % 高度缩放倍数
    
    % 获取旋转角度（如果需要）
    angle = str2double(get(handles.edit2, 'String')); % 旋转角度

    % 获取错切因子（如果需要）
    shearFactorx = str2double(get(handles.edit4, 'String')); % 错切因子
    shearFactory = str2double(get(handles.edit5, 'String')); % 错切因子

    
    % 获取噪声类型（高斯噪声或椒盐噪声）
    isGaussianNoise = get(handles.radiobutton2, 'Value');  % 高斯噪声
    isSaltAndPepperNoise = get(handles.radiobutton3, 'Value');  % 椒盐噪声
    % 获取滤波器大小（用于均值滤波和中值滤波）
    filterSize = str2double(get(handles.edit6, 'String')); 

     % 获取选择的对比度增强类型
    isLinear = get(handles.radiobutton11, 'Value');  % 判断是否选择线性变换
    isLogarithmic = get(handles.radiobutton12, 'Value');  % 判断是否选择对数变换
    isExponential = get(handles.radiobutton13, 'Value');  % 判断是否选择指数变换
    isPiecewiseLinear = get(handles.radiobutton18,'Value'); % 判断是否选择分段线性变换
    % 获取算子类型
    isRobertChecked = get(handles.radiobutton14, 'Value');  % 判断是否选择Robert算子
    isPrewittChecked = get(handles.radiobutton15, 'Value'); % 判断是否选择Prewitt算子
    isSobelChecked = get(handles.radiobutton16, 'Value');   % 判断是否选择Sobel算子
    isLaplaceChecked = get(handles.radiobutton17, 'Value'); % 判断是否选择拉普拉斯算子

    isKMean = get(handles.radiobutton21, 'Value');% 判断是否选择聚类分割
    isWaterRegion = get(handles.radiobutton22,'value');
    isBimodalThresholding = get(handles.radiobutton23,'value');

    % 图像初始化
    img = handles.img;

    % 根据复选框状态进行不同操作



     % 如果选择了边缘提取并且选择了Robert算子
    if isEdgeExtractionChecked
        if isRobertChecked
            % 执行Robert算子的边缘提取
            img = robertEdgeDetection(img);
        elseif isPrewittChecked
            % 执行Prewitt算子的边缘提取
            img = prewittEdgeDetection(img);
        elseif isSobelChecked
            % 执行Sobel算子的边缘提取
            img = sobelEdgeDetection(img);
        elseif isLaplaceChecked
            % 执行拉普拉斯算子的边缘提取
            img = laplaceEdgeDetection(img);
        
        else
            errordlg('请先选择边缘提取方法！', '错误');
            return;
        end
    end



    % 如果勾选了对比度增强
    if isContrastChecked
        % 根据用户选择的增强方式调用相应的函数
        if size(img, 3) == 3
            img = rgb2gray(img); % 转换为灰度图像
        end

        if isLinear
            % 调用线性对比度增强函数
            img = linearTransform(img);

        elseif isLogarithmic
            % 调用对数变换函数
            img = logTransform(img);

        elseif isExponential
            % 调用指数变换函数
            img = expTransform(img);
        elseif isPiecewiseLinear
            % 调用分段线性灰度变换函数
            img = piecewiseLinearTransform(img);
            % img = threeSegmentLinearTransform(img);

        else
            % 如果没有选择有效的增强方式
            errordlg('请先选择对比度增强类型！', '错误');
            return;
        end
    end






    if isAddNoiseChecked
        % 如果选择了加噪声
        if isGaussianNoise
            % 添加高斯噪声
            m = str2double(get(handles.edit13,'String'));
            v = str2double(get(handles.edit14,'String'));
            img = addGaussianNoise(img, m,v);
        elseif isSaltAndPepperNoise
            % 添加椒盐噪声
            d = str2double(get(handles.edit15,'String'));
            img = addSaltAndPepperNoise(img, d);
        else
            % 如果没有选择噪声类型，弹出警告
            errordlg('请先选择噪声类型！', '错误');
            return;
        end
    end

    % 如果选择了滤波
    if isFilterChecked
        % 判断选择的滤波类型
        if get(handles.radiobutton4, 'Value')  % 如果选择均值滤波
            if isnan(filterSize) || filterSize <= 0
                errordlg('请输入有效的滤波器大小！', '错误');
                return;
            end
            % 执行均值滤波
            img = meanFilter(img, filterSize);
        elseif get(handles.radiobutton7, 'Value')  % 如果选择中值滤波
            if isnan(filterSize) || filterSize <= 0
                errordlg('请输入有效的滤波器大小！', '错误');
                return;
            end
            % 执行中值滤波
            img = medianFilter(img, filterSize);

        elseif get(handles.radiobutton5, 'Value')  % 如果选择高斯滤波
            if isnan(filterSize) || filterSize <= 0
                errordlg('请输入有效的滤波器大小！', '错误');
                return;
            end
            % 获取标准差（假设你有一个输入框获取sigma值）
            sigma = str2double(get(handles.edit7, 'String')); % 获取标准差
            % 执行高斯滤波
            img = gaussianFilter(img, filterSize, sigma);

        elseif get(handles.radiobutton6, 'Value')  % 如果选择双边滤波
            if isnan(filterSize) || filterSize <= 0
                errordlg('请输入有效的滤波器大小！', '错误');
                return;
            end
            % 获取双边滤波的参数
            sigma_d = str2double(get(handles.edit8, 'String'));  % 获取空间域的标准差
            sigma_r = str2double(get(handles.edit9, 'String'));  % 获取灰度域的标准差
            
            % 执行双边滤波
            img = bilateralFilter(img, filterSize, sigma_d, sigma_r);

        elseif get(handles.radiobutton8, 'Value')  % 如果选择理想低通滤波
            % 获取截止频率
            cutoffFreq = str2double(get(handles.edit10, 'String'));
            % 执行理想低通滤波
            img = idealLowPassFilter(img, cutoffFreq);
        elseif get(handles.radiobutton9, 'Value')  % 如果选择指数低通滤波
            % 获取截止频率
            D0 = str2double(get(handles.edit10, 'String'));
            % 执行指数低通滤波
            img = exponentialLowPassFilter(img, D0);
            elseif get(handles.radiobutton10, 'Value')  % 如果选择模糊均值滤波
                % 调用 fuzzy_average_filter
                img = fuzzy_average_filter(img, filterSize);



        else
            % 如果没有选择滤波类型，弹出警告
            errordlg('请先选择滤波类型！', '错误');
            return;
        end
    end
    if isGeometricTransformationChecked
        if isMirrorChecked
            % 如果选择了镜像
            if mirrorType == 1
                % 水平镜像
                img = horizontal_flip(img);
            elseif mirrorType == 2
                % 垂直镜像
                img = vertical_flip(img);
            end
        end

        if isRotateChecked
            % 如果选择了旋转
            if isnan(angle)
                errordlg('请输入有效的旋转角度！', '错误');
                return;
            end
            img = rotateImage(double(img), angle);
        end


        if isShearChecked
            % 如果选择了错切
            if isnan(shearFactorx)||isnan(shearFactory)
                errordlg('请输入有效的错切因子！', '错误');
                return;
            end
            img = shearImageRGB(double(img), shearFactorx,shearFactory);
        end


        if isResizeChecked
            % 如果选择了缩放
            if isnan(kx) || isnan(ky) || kx <= 0 || ky <= 0
                errordlg('请输入有效的缩放倍数（正数）！', '错误');
                return;
            end
            % img = bilinearResize(double(img), kx, ky);
            img = resizeColorImage(img, kx, ky);
        end
    end

    handles.processed_img = img;
    guidata(hObject, handles);  % 更新handles


    % 如果选择了目标提取
    if isTargetExtractionChecked && isKMean
        [mask,img] = targetExtraction_KMeans(img);
        handles.target_img = img;  % 将结果存储到handles结构体中
        guidata(hObject, handles);  % 更新handles数据
    end

    if isTargetExtractionChecked && isWaterRegion
        img = targetExtract_WatershedRegion(img);
        handles.target_img = img;  % 将结果存储到handles结构体中
        guidata(hObject, handles);  % 更新handles数据
    end


    if isTargetExtractionChecked && isBimodalThresholding
        img = targetExtract_BimodalThresholding(img);
        handles.target_img = img;  % 将结果存储到handles结构体中
        guidata(hObject, handles);  % 更新handles数据
    end
    
    
    % 显示结果
    axes(handles.axes2); % 指定显示在 axes2
    imshow(img, []);
    title('处理结果');





end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    % 打开第二个页面
    % 获取存储在 handles 中的图片数据
    % 将 img 作为参数传递给 zhifangtu 函数
     % 获取当前界面中选择的图片
    if isfield(handles, 'img') && ~isempty(handles.img)
        img = handles.img; % 获取图片
        zhifangtu(img); % 打开 zhifangtu 界面，并传递图片
    else
        msgbox('请先选择一张图片！', '错误', 'error');
    end
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% 获取当前图像
    if isfield(handles, 'img')
        img = handles.img; % 从 handles 获取原始图像

        % 转换为灰度图（如需要）
        if size(img, 3) == 3
            grayImg = rgb2gray(img);
        else
            grayImg = img;
        end

        % 线性变换
        linearImg = linearTransform(grayImg);

        % 对数变换
        logImg = logTransform(grayImg);

        % 指数变换
        expImg = expTransform(grayImg);

        % 在新窗口中展示结果
        hFig = figure;
        set(hFig, 'Name', '对比度增强结果', 'NumberTitle', 'off'); % 修改窗口标题

        subplot(2, 2, 1);
        imshow(grayImg);
        title('原始图像');

        subplot(2, 2, 2);
        imshow(linearImg);
        title('线性变换');

        subplot(2, 2, 3);
        imshow(logImg);
        title('对数变换');

        subplot(2, 2, 4);
        imshow(expImg);
        title('指数变换');
    else
        errordlg('请先加载图像！', '错误');
    end
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end



% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
end



function edit6_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox7.加噪
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
end

% --- Executes on button press in checkbox8.滤波
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
end


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
end

function radiobutton3_Callback(hObject, eventdata, handles)
end

function radiobutton2_Callback(hObject, eventdata, handles)
end



function edit7_Callback(hObject, eventdata, handles)
end

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
end


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    % 检查是否已有处理后的图像
    if isfield(handles, 'processed_img')
        processed_img = handles.processed_img;
        % 如果是灰度图像，转换为三通道
        if size(processed_img, 3) == 1
            processed_img = repmat(processed_img, [1, 1, 3]);  % 复制灰度图像到三个通道
        end
        % 设置保存的路径
        image_save_path = 'D:/_laboratory/matlab_table/Digital-Image-Processing/processed_img.jpg';
        % 保存图片
        imwrite(processed_img, image_save_path);
        
        % model_path = 'checkpoints/checkpoint_epoch_19.pt';
        % model_path = 'D:\_laboratory\pythonProject\DIP\checkpoints\checkpoint_epoch_19.pt';
        % model_path = 'D:\_laboratory\pythonProject\DIP\checkpoints\checkpoint_epoch_19.pt';
        model_path = 'D:\_laboratory\matlab_table\Digital-Image-Processing\checkpoints\checkpoint_epoch_19.pt';
        model=py.importlib.import_module('model_pred');
        tic; % 开始计时
        res= model.predict_with_checkpoint(model_path,image_save_path);
        elapsedTime = toc; % 结束计时并获取耗时
        res = string(res);  % 将 Python 字符串转换为 MATLAB 字符串
        set(handles.text23,"String",res);
        set(handles.text43, 'String', [num2str(elapsedTime, '%.5f'), ' 秒']);

        % 获取 text25 的内容
        expected_result = get(handles.text25, "String");
        % 判断分类结果是否正确
        if strcmp(res, expected_result)
            set(handles.text38, "String", "识别正确");
            set(handles.text38, "ForegroundColor", [0 0 0]);  % 设置为黑色字体
        else
            set(handles.text38, "String", "识别错误");
            set(handles.text38, "ForegroundColor", [1 0 0]);  % 设置为红色字体
        end

    else
        msgbox('请先选择并处理图像！', '错误', 'error');
    end

end
    


function edit12_Callback(hObject, eventdata, handles)


end

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% 获取当前axes中的图像
        ax = handles.axes2;
        img = getimage(ax);  % 从axes中获取图像
        
        % 如果axes没有图像，提示用户
        if isempty(img)
            msgbox('No image to save!', 'Error', 'error');
            return;
        end
        
        % 打开保存文件对话框
        [file, path] = uiputfile({'*.png';'*.jpg';'*.tiff';'*.bmp'}, 'Save Image As');
        
        % 如果用户没有取消，保存图像
        if ischar(file)
            full_path = fullfile(path, file);
            imwrite(img, full_path);  % 保存图像
            disp(['Image saved as: ', full_path]);
        else
            disp('Save operation was cancelled.');
        end
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
 % 对源图像 (source_img) 和目标图像 (target_img) 进行LBP处理

    % 检查是否存在 source_img 和 target_img
    if isfield(handles, 'source_img') && isfield(handles, 'target_img')
        
        source_img = handles.source_img;
        target_img = handles.target_img;

        lbp_source = computeLBP(source_img);
        lbp_target = computeLBP(target_img);
        
         % 创建一个新的figure，并设置窗口名称
        figure('Name', 'LBP特征提取', 'NumberTitle', 'off'); % 设置窗口名称为 'LBP特征提取'
        
        % 显示源图像的LBP特征图
        subplot(1, 2, 1); 
        imshow(lbp_source);
        title('源图像 LBP 特征提取');
        
        % 显示目标图像的LBP特征图
        subplot(1, 2, 2); 
        imshow(lbp_target);
        title('目标图像 LBP 特征提取');

       
    else
        % 如果没有找到源图像或目标图像，则弹出提示
        msgbox('源图像或目标图像未找到！', '错误', 'error');
    end

end

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
 % 检查是否存在 source_img 和 target_img
    if isfield(handles, 'source_img') && isfield(handles, 'target_img')
        
        source_img = handles.source_img;
        target_img = handles.target_img;
        step =16;
        K =9;
        % 对源图像进行 HOG 特征提取
        [feature_source, image_hog_source] = computeHOG(source_img,step,K);
        [feature_target, image_hog_target] = computeHOG(target_img,step,K);



        % HOG 特征提取显示
        figure('Name', 'HOG特征提取', 'NumberTitle', 'off'); 
        subplot(1, 2, 1);
        imshow(image_hog_source,[]);
        title('源图像 HOG 特征提取');

        subplot(1, 2, 2);
        imshow(image_hog_target,[]);
        title('目标图像 HOG 特征提取');



    else
        % 如果没有找到源图像或目标图像，则弹出提示
        msgbox('源图像或目标图像未找到！', '错误', 'error');
    end
end


% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21
end


% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton22
end


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
[filename, path] = uigetfile({'*.jpg;*.png'}, '请选择目标图像');
    if filename ~= 0
        % 加载目标图像
        fullpath = fullfile(path, filename);
        targetImage = imread(fullpath);
        
        % 保存目标图像到 handles 中
        handles.targetImage = targetImage;
        guidata(hObject, handles);
        
        % 显示目标图像在 axes9
        axes(handles.axes6);
        imshow(targetImage);
        % title('目标图像');
        
        axes(handles.axes7);
        hist = computeHistogram(rgb2gray(targetImage));
        bar(0:255, hist); % 绘制直方图
        xlim([0 255]);
        % title('灰度直方图');
        xlabel('灰度值');
        ylabel('像素数');

        
        % 保存目标图像到 handles 中
        handles.zhifangtutargetImage = targetImage;
        guidata(hObject, handles);



    else
        msgbox('未选择目标图像！', '错误', 'error');
    end
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
 % 确保已加载源图像和目标图像
    if isfield(handles, 'zhifangtugrayImage') && isfield(handles, 'zhifangtutargetImage')
        sourceImage = handles.zhifangtugrayImage;  % 源图像
        targetImage = handles.zhifangtutargetImage;  % 目标图像

        % 进行直方图匹配
        matchedImage = histogramMatching(sourceImage, targetImage);
        
        % 在 axes10 中显示匹配后的图像
        axes(handles.axes8);
        imshow(matchedImage);
        % title('匹配后的图像');

        axes(handles.axes9);
        hist = computeHistogram(matchedImage);
        bar(0:255, hist); % 绘制直方图
        xlim([0 255]);
        % title('灰度直方图');
        xlabel('灰度值');
        ylabel('像素数');



    else
        msgbox('请先选择源图像和目标图像！', '错误', 'error');
    end
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
end

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
end

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
