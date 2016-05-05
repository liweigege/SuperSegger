function varargout = modifyConstValuesGUI(varargin)
% MODIFYCONSTVALUESGUI MATLAB code for modifyConstValuesGUI.fig
%      MODIFYCONSTVALUESGUI, by itself, creates a new MODIFYCONSTVALUESGUI or raises the existing
%      singleton*.
%
%      H = MODIFYCONSTVALUESGUI returns the handle to a new MODIFYCONSTVALUESGUI or the handle to
%      the existing singleton*.
%
%      MODIFYCONSTVALUESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODIFYCONSTVALUESGUI.M with the given input arguments.
%
%      MODIFYCONSTVALUESGUI('Property','Value',...) creates a new MODIFYCONSTVALUESGUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before modifyConstValuesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to modifyConstValuesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help modifyConstValuesGUI

% Last Modified by GUIDE v2.5 04-May-2016 18:34:41

% Begin initialization code - DO NOT EDIT

global settings;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @modifyConstValuesGUI_OpeningFcn, ...
    'gui_OutputFcn',  @modifyConstValuesGUI_OutputFcn, ...
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

% --- Executes just before modifyConstValuesGUI is made visible.
function modifyConstValuesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to modifyConstValuesGUI (see VARARGIN)
global settings;

handles.output = hObject;
set(handles.figure1, 'units', 'normalized', 'position', [0.1 0.1 0.8 0.8])
load_listbox(handles)
handles.directory.String = 'Image filename';

settings.data = [];
settings.phaseImage = [];
settings.axisFlag = 0;
settings.loadDirectory = [];
settings.handles = handles;
initialize_all(handles)

guidata(hObject, handles);
updateUI(handles);

% UIWAIT makes modifyConstValuesGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = modifyConstValuesGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in try_const.
function try_const_Callback(hObject, eventdata, handles)
% hObject    handle to try_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dirname = (handles.directory.String);
if ~strcmp(dirname(end-3:end), '.tif')
    errordlg('Please select an image');
end
tryDifferentConstants(dirname, []);


function load_listbox(handles)
[possibleConstants] = getConstantsList();
[sorted_names,sorted_index] = sortrows({possibleConstants.resFlag}');
handles.file_names = sorted_names;
handles.sorted_index = sorted_index;
set(handles.constants_list,'String',handles.file_names,...
	'Value',1)



% --- Executes on selection change in constants_list.
function constants_list_Callback(hObject, eventdata, handles)
% hObject    handle to constants_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns constants_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from constants_list
getValuesFromConst(handles)

function getValuesFromConst(handles)
global settings;
resValue = get(handles.constants_list,'Value');
res = handles.constants_list.String{resValue};
CONST = loadConstantsNN (res,0);
handles.cut_intensity.Value = CONST.superSeggerOpti.CUT_INT;
handles.max_wid.Value = CONST.superSeggerOpti.MAX_WIDTH ;
handles.mask_th2.Value = CONST.superSeggerOpti.THRESH2;
handles.mask_th1.Value = CONST.superSeggerOpti.THRESH1 ;
handles.magic_thresh.Value = CONST.superSeggerOpti.MAGIC_THRESHOLD;
handles.magic_radius.Value = CONST.superSeggerOpti.MAGIC_RADIUS ;
handles.max_width_regOpt.String = CONST.regionOpti.MAX_WIDTH;
handles.maxLengRegOpti.String = CONST.regionOpti.MAX_LENGTH ;

update_text_values (handles)
settings.CONST = CONST;


% --- Executes during object creation, after setting all properties.
function constants_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to constants_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function directory_Callback(hObject, eventdata, handles)
% hObject    handle to directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directory as text
%        str2double(get(hObject,'String')) returns contents of directory as a double


% --- Executes during object creation, after setting all properties.
function directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resValue = get(handles.constants_list,'Value');
res = handles.constants_list.String{resValue};
CONST = loadConstantsNN (res,0);
CONST.superSeggerOpti.CUT_INT = handles.cut_intensity.Value;
CONST.superSeggerOpti.MAX_WIDTH = handles.max_wid.Value;
CONST.superSeggerOpti.THRESH2 = handles.mask_th2.Value;
CONST.superSeggerOpti.THRESH1 = handles.mask_th1.Value;
CONST.superSeggerOpti.MAGIC_THRESHOLD = handles.magic_thresh.Value;
CONST.superSeggerOpti.MAGIC_RADIUS = handles.magic_radius.Value;
CONST.regionOpti.MAX_WIDTH = handles.max_width_regOpt.Value;
CONST.regionOpti.MAX_LENGTH = handles.maxLengRegOpti.Value;
[FileName,PathName,~] = uiputfile('newConstantsName.mat');
if FileName~=0
    save([PathName,FileName], '-struct', 'CONST');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over constants_list.
function constants_list_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to constants_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function image_folder_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to image_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[imageName,directoryName , ~] = uigetfile('*.tif', 'Pick an image file');
handles.directory.String = [directoryName,filesep,imageName];
settings.phaseImage = imread(handles.directory.String);
axes(handles.viewport);
imshow(settings.phaseImage,[]);


function updateUI(handles)
global settings;
showSegDataPhase(settings.data, handles.viewport);
if numel(handles.viewport.Children) > 0
    set(handles.viewport.Children(1),'ButtonDownFcn',@imageButtonDownFcn);
hold on;
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function magic_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to magic_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = hObject.Value;
hObject.Value = round(val);
handles.magic_val.String = num2str(hObject.Value);


% --- Executes during object creation, after setting all properties.
function magic_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magic_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function cut_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to cut_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = hObject.Value;
hObject.Value = round(val);
handles.cut_int_text.String = num2str(handles.cut_intensity.Value);



% --- Executes during object creation, after setting all properties.
function cut_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function mask_th1_Callback(hObject, eventdata, handles)
% hObject    handle to mask_th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = hObject.Value;
hObject.Value = round(val);
handles.mask_th1_text.String = num2str(hObject.Value);

% --- Executes during object creation, after setting all properties.
function mask_th1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask_th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function update_text_values (handles)

handles.magic_val.String = num2str(handles.magic_thresh.Value);
handles.magic_rad_text.String = num2str(handles.magic_radius.Value);
handles.cut_int_text.String = num2str(handles.cut_intensity.Value);
handles.mask_th1_text.String = num2str(handles.mask_th1.Value);
handles.mask_th2_text.String = num2str(handles.mask_th2.Value);
handles.max_wid_text.String = num2str(handles.max_wid.Value);


% --- Executes on slider movement.
function mask_th2_Callback(hObject, eventdata, handles)
% hObject    handle to mask_th2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = hObject.Value;
hObject.Value = round(val);
handles.mask_th2_text.String = num2str(hObject.Value);


% --- Executes during object creation, after setting all properties.
function mask_th2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mask_th2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function magic_radius_Callback(hObject, eventdata, handles)
% hObject    handle to magic_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = round(hObject.Value);
hObject.Value =val;
handles.magic_rad_text.String = num2str(hObject.Value);

% --- Executes during object creation, after setting all properties.
function magic_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to magic_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function min_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to min_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = hObject.Value;
hObject.Value = round(val);
handles.min_thresh_text.String = num2str(hObject.Value);


% --- Executes during object creation, after setting all properties.
function min_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function max_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function max_wid_Callback(hObject, eventdata, handles)
% hObject    handle to max_wid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(hObject.Value);
hObject.Value=val;
handles.max_wid_text.String = num2str(hObject.Value);

% --- Executes during object creation, after setting all properties.
function max_wid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_wid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    set(hObject,'Max',50,'Min',5)
    hObject.Value = get(hObject,'Min');
    handles.max_wid_text.String = num2str(hObject.Value);
end



% --- Executes on slider movement.
function max_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to max_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(hObject.Value);
hObject.Value=val;
handles.max_thresh_text.String = num2str(hObject.Value);
guidata(hObject,handles);


function initialize_all (handles)
% magic thresh
set(handles.magic_thresh,'Max',30,'Min',0)
set(handles.magic_thresh,'SliderStep',[0.1 1])

% magic radius
set(handles.magic_radius,'Max',50,'Min',1)
set(handles.magic_radius,'SliderStep',[0.1 1])


% cut_intensity
set(handles.cut_intensity,'Max',150,'Min',10)
set(handles.cut_intensity,'SliderStep',[0.1 1])

% mask_th1
set(handles.mask_th1,'Max',100,'Min',10)
set(handles.mask_th1,'SliderStep',[0.1 1])

% mask_th2
set(handles.mask_th2,'Max',100,'Min',0)
set(handles.mask_th2,'SliderStep',[0.1 1])

% maximum width
set(handles.max_wid,'Max',30,'Min',5)
disp(get(handles.max_wid,'Max'))
set(handles.max_wid,'SliderStep',[0.1 1])

getValuesFromConst(handles)


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global settings;
resValue = get(handles.constants_list,'Value');
res = handles.constants_list.String{resValue};
CONST = loadConstantsNN (res,0);
CONST.superSeggerOpti.CUT_INT = handles.cut_intensity.Value;
CONST.superSeggerOpti.MAX_WIDTH = handles.max_wid.Value;
CONST.superSeggerOpti.THRESH2 = handles.mask_th2.Value;
CONST.superSeggerOpti.THRESH1 = handles.mask_th1.Value;
CONST.superSeggerOpti.MAGIC_THRESHOLD = handles.magic_thresh.Value;
CONST.superSeggerOpti.MAGIC_RADIUS = handles.magic_radius.Value;
settings.CONST = CONST;

imageName = handles.directory.String;
if numel(imageName)<3 || ~strcmp(imageName(end-3:end), '.tif')
    image_folder_ClickedCallback([],[],handles);
end
phaseIm = imread(handles.directory.String);
settings.data = superSeggerOpti(phaseIm,[],0,CONST);
guidata(hObject, handles);
updateUI(handles);



function max_width_regOpt_Callback(hObject, eventdata, handles)
% hObject    handle to max_width_regOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_width_regOpt as text
%        str2double(get(hObject,'String')) returns contents of max_width_regOpt as a double




% --- Executes during object creation, after setting all properties.
function max_width_regOpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_width_regOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maxLengRegOpti_Callback(hObject, eventdata, handles)
% hObject    handle to maxLengRegOpti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxLengRegOpti as text
%        str2double(get(hObject,'String')) returns contents of maxLengRegOpti as a double

% --- Executes during object creation, after setting all properties.
function maxLengRegOpti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxLengRegOpti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on mouse press over axes background.
function imageButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to viewport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settings;
updateUI(settings.handles);
point = round(eventdata.IntersectionPoint(1:2));
if isempty(settings.data)
    errordlg('Press find segments first');
end
if ~isfield(settings.data,'regs')
    settings.data = intMakeRegs( settings.data, settings.CONST, [], [] );
end

data = settings.data;
ss = size(data.phase);
tmp = zeros([51,51]);
tmp(26,26) = 1;
tmp = 8000-double(bwdist(tmp));
rmin = max([1,point(2)-25]);
rmax = min([ss(1),point(2)+25]);
cmin = max([1,point(1)-25]);
cmax = min([ss(2),point(1)+25]);
rrind = rmin:rmax;
ccind = cmin:cmax;
pointSize = [numel(rrind),numel(ccind)];
tmp = tmp(26-point(2)+rrind,26-point(1)+ccind).*data.mask_cell(rrind,ccind);
[~,ind] = max( tmp(:) );

[sub1, sub2] = ind2sub( pointSize, ind );
ii = data.regs.regs_label(sub1-1+rmin,sub2-1+cmin);
hold on;
plot( sub2-1+cmin, sub1-1+rmin, 'o', 'MarkerFaceColor', 'g' );


if ii ~=0
    settings.handles.width_length_image.String =  (['length : ', num2str(data.regs.info(ii,1)), ...
        ' max width : ',  num2str(data.regs.info(ii,4))]);
else
    disp ('empty')
end


% --------------------------------------------------------------------
function help_button_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

message = ({'SuperSeggerOpti - Modifying Constants Module'
    '------------------------------------------------------------'
    '   '
    '   '
    'Magic Threshold: Intensities below this are set to 0, so that intensity differences within a cell region are minimized.'
    '   '
    'Magic Radius: radius for the contrast enhancing filter (proportional to the width of the cell)'
    '   '
    'Mask thresh1: intensity threshold used for background mask to separate cell clumps and background'
    '   '
    'Mask thresh2: intensity threshold used for background mask to separate regions between cell'
    '   '
    'Max width: Width threshold for the iterative segment refinement.More segments are added to the regions whose short axis is greater than this number. All other masked regions are assumed to be correctly defined as a cell.'
    '   '
    'Find segments : Identifies segments usings the chosen constants and values in the sliders'
    '   '
    'Min length region optimization : Cells with length smaller than this are considered for further optimization'
    '   '
    'Max width region optimization : Cells with width larger than this are considered for further optimization'
    '   '
    });

msgbox(message,'HELP');