function varargout = draft_VT(varargin)
% DRAFT_VT MATLAB code for draft_VT.fig
%      DRAFT_VT, by itself, creates a new DRAFT_VT or raises the existing
%      singleton*.
%
%      H = DRAFT_VT returns the handle to a new DRAFT_VT or the handle to
%      the existing singleton*.
%
%      DRAFT_VT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAFT_VT.M with the given input arguments.
%
%      DRAFT_VT('Property','Value',...) creates a new DRAFT_VT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before draft_VT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to draft_VT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help draft_VT

% Last Modified by GUIDE v2.5 07-Dec-2019 11:16:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @draft_VT_OpeningFcn, ...
                   'gui_OutputFcn',  @draft_VT_OutputFcn, ...
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


% --- Executes just before draft_VT is made visible.
function draft_VT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to draft_VT (see VARARGIN)

% Choose default command line output for draft_VT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes draft_VT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = draft_VT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_video.
function Load_video_Callback(hObject, eventdata, handles)
% hObject    handle to Load_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.mp4';'*.avi'; '*.mov'; '*.wmv'; '*.amv' ; '*.3gp'; '*.3g2';'*.ogg';'*.webm'},'select a video file');
completename = strcat(pathname,filename);

vidobj = VideoReader(completename);
handles.name = filename;
handles.video = completename;
handles.vidobj = vidobj;
guidata(hObject,handles)



% --- Executes on button press in Process.
function Process_Callback(hObject, eventdata, handles)
% hObject    handle to Process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filenaming = handles.name;

if isfolder('demo_data')
   rmdir('demo_data','s');
   mkdir('demo_data');
else
   mkdir('newDicomfolder');
end

%trackFile = './demo_data/demo_tracks.mat';
trackFile = strcat('./demo_data/demo_tracks_', filenaming, '.mat');

vidinp = handles.video;

%set some options, like max and min detection windows
model.maxsize = [250 250]; %max size of detected face
model.minsize = [70 70]; %min size of detected face
model.facedetect.imscale =1; %run at full resolution 
model.facedetect.sensitivity = 10; %lower numbers detect more faces


%track the video and visualise while tracking. Set visualise = false to
%turn off visualisation while tracking.
visualise = true;
% Set visualize flage as true
%[faceDet,faceTracks] = trackFaces(vidinp,model,trackFile,visualise);
% function [face_Det,face_Tracks] = trackFaces( videoname,fitModel,outFile,visualise )


    % initializes the face trakers array
face_Tracks = [];
    % same for face detectors (centroids ?)
face_Det = [];
h_img = []; %for visualisation only (image handle)

    %load video object
vidobj = handles.vidobj;
    
    %setup face detector -- Viola-Jones
fDetector = vision.CascadeObjectDetector(); % -- Cannot be changed (Viola-Jones core algo)
fDetector.MaxSize = round(model.maxsize*model.facedetect.imscale);% field containing max possible size
fDetector.MinSize = round(model.minsize*model.facedetect.imscale);%same with minimal size
fDetector.MergeThreshold = model.facedetect.sensitivity; % this looks like a sensitivity analysis tool
    
%setup trackers
trackers(1).maxID = 0; % this is a dynamic structure with two fields
trackers(1).numActive = 0; %same but second field
    
%get starting frame index based on current saved output and also
%tracker info
[startIndex,trackers] = getSavedIndex(trackFile); % calls the function getsavedindex 
% to start indexing tracks and/or prepare them fo be injectrd into the
% tracking algorithm. Also creates default track values when no outFile
    
%load the saved tracks
% this piece is relying on the previous function
if exist(trackFile,'file')
   load(trackFile);
end
    
%loop over frames and track (startindex being the departure)
  
for i = startIndex:vidobj.NumberOfFrames
    
% If remainder of the division of i and 1000 is null
% then print the number of active trackers 
    if mod(i,1000)==0
       fprintf('frame %d of %d, number of active trackers: %d\n',i,vidobj.NumberOfFrames,trackers(1).numActive);
    end    
    % eats one image
    image = read(vidobj,i);
        
    %track all previous faces to this frame
    [face_Det,face_Tracks,trackers] = track(face_Det,face_Tracks,trackers,image,i);
    % Once the trackers are updated 
    % the programs move face detection with bounding boxes
        
    %detect all faces
    facebboxes = detectFaces(fDetector,image);
        
    % when done, it mpoves to new faces detection
    % !!!!!!! THIS FUNCTION IS IN THE SAME FOLDER !!!!!!
    %start new tracks if we detect new faces
    [face_Det,face_Tracks,trackers] = addNewFaces(face_Det, face_Tracks,trackers,facebboxes,image,i);
        
    %save output every 1000 frames
    saveOutput(trackFile,face_Det,face_Tracks,trackers,vidobj.NumberOfFrames,i,1000); 
    
    axes(handles.axes1)
    %visualise
    if visualise
%         h_img = vis(image,face_Det,trackers,i,h_img); %Observation of the stuff
        if isempty(h_img) %create figure and image plane
           h_img = imagesc(image);
        end
    
    % Bunch of visual parameters to include
        if numel(face_Det)>=i
           for b = 1:size(face_Det(i).bboxes,1)
               image = insertObjectAnnotation(image,'rectangle',face_Det(i).bboxes(b,:),sprintf('track: %d',face_Det(i).trackIDs(b)));
           end
           for b = 1:size(face_Det(i).bboxes,1)
               trackerID = find(cat(1,trackers(:).trackID)==face_Det(i).trackIDs(b));
               if ~isempty(trackerID)
                   plotPoints = cat(2,trackers(trackerID).points(:,1:2),2*ones(size(trackers(trackerID).points,1),1));
                   image = insertObjectAnnotation(image,'circle',plotPoints,' ','TextBoxOpacity',0,'Color','white');
               end
           end

        end
        set(h_img,'cdata',image);
        drawnow  
    end
%     axes(handles.axes1)
%     imshow(image, h_img);
end   
    %produce tracking structure from faceDet
 if isempty(face_Tracks)
    face_Tracks = dets2tracks(face_Det); % to comment
    frameID = vidobj.NumberOfFrames;
        %save(outFile,'faceDet','frameID','faceTracks'); % This line as
        %been commented as it was giving en error in the final script after
        %2 iterations
 end

handles.trackers = trackers;
handles.facedet = face_Det;
handles.matfile = trackFile;
guidata(hObject,handles)




% --- Executes on button press in Display.
function Display_Callback(hObject, eventdata, handles)
% hObject    handle to Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%trackers = handles.trackers;
faceDet = handles.facedet;
vidobj = VideoReader(handles.video);
if ~exist('trackID','var')
   load(handles.matfile);
   h_img = [];
   for i = 1:vidobj.NumberOfFrames
       img = read(vidobj,i);
       axes(handles.axes1);
       h_img = vis1(img,faceDet,i,h_img);
   end
else
   load(handles.matfile);
   h_img = [];
   for f = faceTracks(trackID).frameIDs
       id = find(faceDet(f).trackIDs==trackID);
       faceDet(f).bboxes = faceDet(f).bboxes(id,:);
       faceDet(f).trackIDs = faceDet(f).trackIDs(id);
   end
            
   for i = faceTracks(trackID).frameIDs
       img = read(vidobj,i); 
       axes(handles.axes1);
       h_img = vis1(img,faceDet,i,h_img);
   end
end
%visualiseFaceTracking(handles.video,handles.matfile);



% --- Executes on button press in SAVER.
function SAVER_Callback(hObject, eventdata, handles)
% hObject    handle to SAVER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
faceDet = handles.facedet;
vidobj = VideoReader(handles.video);

 writerObj = VideoWriter(strcat('./demo_data/demo_tracks_', handles.name));
 writerObj.FrameRate = 15;
 
 open(writerObj);
if ~exist('trackID','var')
   load(handles.matfile);
   h_img = [];
   for i = 1:vidobj.NumberOfFrames
       img = read(vidobj,i);
       axes(handles.axes1);
       h_img = vis1(img,faceDet,i,h_img);
       F = getframe(handles.axes1);
       %frame = im2frame(h_img{vidobj.NumberOfFrames});
       writeVideo(writerObj, F);
   end
else
   load(handles.matfile);
   h_img = [];
   for f = faceTracks(trackID).frameIDs
       id = find(faceDet(f).trackIDs==trackID);
       faceDet(f).bboxes = faceDet(f).bboxes(id,:);
       faceDet(f).trackIDs = faceDet(f).trackIDs(id);
   end
            
   for i = faceTracks(trackID).frameIDs
       img = read(vidobj,i); 
       axes(handles.axes1);
       h_img = vis1(img,faceDet,i,h_img);
       F = getframe(handles.axes1);
       %frame = im2frame(h_img{vidobj.NumberOfFrames});
       writeVideo(writerObj, F);
   end
end
close(writerObj);


% --- Executes on button press in Cleaner.
function Cleaner_Callback(hObject, eventdata, handles)
% hObject    handle to Cleaner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldername = handles.matfile;
if isfolder('demo_data')
   if isfile(foldername)
       delete(foldername);
       disp('file deleted ');
   else
       disp('there is no data to clean');
   end
else
   disp('there is no folder !');
end


% --- Executes on button press in Close_process_y_window.
function Close_process_y_window_Callback(hObject, eventdata, handles)
% hObject    handle to Close_process_y_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
clc;
delete(draft_VT);

