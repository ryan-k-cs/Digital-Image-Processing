function varargout = zhifangtu(varargin)
% ZHIFANGTU MATLAB code for zhifangtu.fig
%      ZHIFANGTU, by itself, creates a new ZHIFANGTU or raises the existing
%      singleton*.
%
%      H = ZHIFANGTU returns the handle to a new ZHIFANGTU or the handle to
%      the existing singleton*.
%
%      ZHIFANGTU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZHIFANGTU.M with the given input arguments.
%
%      ZHIFANGTU('Property','Value',...) creates a new ZHIFANGTU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zhifangtu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zhifangtu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zhifangtu

% Last Modified by GUIDE v2.5 11-Dec-2024 16:39:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zhifangtu_OpeningFcn, ...
                   'gui_OutputFcn',  @zhifangtu_OutputFcn, ...
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

% --- Executes just before zhifangtu is made visible.
function zhifangtu_OpeningFcn(hObject, eventdata, handles, varargin)
  % 检查是否有传入参数
    if ~isempty(varargin)
        img = varargin{1}; % 获取传入的图片
        handles.inputImage = img; % 保存到 handles 中
        
        % 显示原图
        axes(handles.axes1);
        imshow(img);

        % 转为灰度图
        grayImage = rgb_to_gray(img);
        axes(handles.axes2);
        imshow(grayImage);

        % % 显示灰度直方图
        % axes(handles.axes3);
        % imhist(grayImage);


        % 显示灰度直方图
        axes(handles.axes3);
        hist = computeHistogram(grayImage);
        bar(0:255, hist); % 绘制直方图
        xlim([0 255]);
        % title('灰度直方图');
        xlabel('灰度值');
        ylabel('像素数');


        %  % --- 直方图均衡化 ---
        % % 对灰度图进行均衡化
        % equalizedImage = histogramEqualization(grayImage);
        % 
        % % 显示均衡化后的灰度图
        % axes(handles.axes4);
        % imshow(equalizedImage);
        % title('直方图均衡化后的图像');

        % --- 直方图均衡化 ---
        % 对灰度图进行均衡化
        equalizedImage = histogramEqualization(grayImage);

        % 显示均衡化后的灰度图
        axes(handles.axes4);
        imshow(equalizedImage);
        % title('直方图均衡化后的图像');

        % 显示均衡化后的直方图
        axes(handles.axes11);
        equalizedHist = computeHistogram(equalizedImage);
        bar(0:255, equalizedHist);
        xlim([0 255]);
        % title('均衡化后的直方图');
        xlabel('灰度值');
        ylabel('像素数');


        


        % 保存灰度图到 handles
        handles.grayImage = grayImage;
        guidata(hObject, handles); % 更新 handles 数据
    else
        msgbox('未接收到图片数据，请返回主界面选择图片！', '错误', 'error');
    end

    % Choose default command line output for zhifangtu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zhifangtu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


end


% --- Outputs from this function are returned to the command line.
function varargout = zhifangtu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[filename, path] = uigetfile({'*.jpg;*.png'}, '请选择目标图像');
    if filename ~= 0
        % 加载目标图像
        fullpath = fullfile(path, filename);
        targetImage = imread(fullpath);
        
        % 保存目标图像到 handles 中
        handles.targetImage = targetImage;
        guidata(hObject, handles);
        
        % 显示目标图像在 axes9
        axes(handles.axes9);
        imshow(targetImage);
        % title('目标图像');
        
        axes(handles.axes13);
        hist = computeHistogram(rgb2gray(targetImage));
        bar(0:255, hist); % 绘制直方图
        xlim([0 255]);
        % title('灰度直方图');
        xlabel('灰度值');
        ylabel('像素数');

        



    else
        msgbox('未选择目标图像！', '错误', 'error');
    end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
 % 确保已加载源图像和目标图像
    if isfield(handles, 'grayImage') && isfield(handles, 'targetImage')
        sourceImage = handles.grayImage;  % 源图像
        targetImage = handles.targetImage;  % 目标图像

        % 进行直方图匹配
        matchedImage = histogramMatching(sourceImage, targetImage);
        
        % 在 axes10 中显示匹配后的图像
        axes(handles.axes10);
        imshow(matchedImage);
        % title('匹配后的图像');

        axes(handles.axes12);
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
