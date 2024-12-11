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

% Last Modified by GUIDE v2.5 10-Dec-2024 21:48:43

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
        
        % 将图片存储在 handles 结构中，以便其他回调函数可以访问
        handles.img = img; % 将图片保存在 handles 结构中的 img 字段
        guidata(hObject, handles); % 更新 handles

        % 在 GUI 的 axes 控件中显示图片
        axes(handles.axes1);  % 将当前的 axes 设置为 axes1
        imshow(img);          % 显示图片
    else
        % 如果没有选择文件，显示消息
        disp('未找到图片');
    end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
