% Begin initialization code - DO NOT EDIT
function varargout = vmatqatool(varargin)


    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @vmatqatool_OpeningFcn, ...
                       'gui_OutputFcn',  @vmatqatool_OutputFcn, ...
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


%% --- Executes just before vmatqatool is made visible.
function vmatqatool_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

    % Choose default command line output for vmatqatool
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

%% --- Outputs from this function are returned to the command line.
function varargout = vmatqatool_OutputFcn(hObject, eventdata, handles) 

    % Get default command line output from handles structure
    varargout{1} = handles.output;

   

%% --- Executes on button press in select_patient.
function select_patient_Callback(hObject, eventdata, handles) %#ok<*DEFNU>

    [path] = uigetdir('J:\PhysicsDosimetry\Eclipse TPS\Patient Specific QA');
    handles.path = strcat(path,'\');
    set(handles.patient_root_path,'string',handles.path);
    
    root_path = handles.path;
  
    TPS_filename = dir(strcat(root_path,'\','RD*.dcm'));
     RP_filename = dir(strcat(root_path,'\','RP*.dcm'));

     MC_filename = dir(strcat(root_path,'\','*.txt'));

     if length(MC_filename) > 1;
        MC_filename = dir(strcat(root_path,'\','mc*.txt'));
     end
 
        xcl_info = dir(strcat(root_path,'\','*.xls'));

         MC_file = strcat(root_path, MC_filename.name);
         set(handles.mc_okay_check,'string',MC_filename.name);
        TPS_file = strcat(root_path, TPS_filename.name);
         RP_file = strcat(root_path, RP_filename.name);
        xcl_file = strcat(root_path, xcl_info.name);
    
%                  [ MC ] = mapcheck_opener_V2( MC_file );
%     [ TPS_dose] = open_doseplane( TPS_file );
      [~,~,raw] = xlsread(xcl_file, 'MapPhan dose scaled', 'B3:D33');
   dose_scaling = double(cell2mat(raw(13,2)));
%        TPS_dose = TPS_dose*dose_scaling;
        
        ind_C = find(strcmp(raw,'CTX')==1);
        ind_D = find(strcmp(raw,'DTX')==1);
        ind_A = find(strcmp(raw,'AEX')==1);

        if isempty(ind_A) == 0
            machine_name = raw(ind_A);
        elseif isempty(ind_C) == 0
            machine_name = raw(ind_C);
        elseif isempty(ind_D) == 0
            machine_name = raw(ind_D);
        else
            machine_name = 'unknown';
        end         
        machine_name = char(machine_name);
    
    guidata(hObject, handles);

    function patient_root_path_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    


%% --- Executes on button press in select_destination.
function select_destination_Callback(hObject, eventdata, handles)

    [path] = uigetdir;
    handles.path = strcat(path,'\');
    set(handles.destination_root_path,'string',handles.path);
    guidata(hObject, handles);

function destination_root_path_Callback(hObject, eventdata, handles)

function destination_root_path_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
   

%% --- Executes on button press in upload_to_database.
function upload_to_database_Callback(hObject, eventdata, handles)

       root_path = get(handles.patient_root_path,'string'); 
     destination = get(handles.destination_root_path,'string'); 
          dbpath = get(handles.database_path,'string');
    TPS_filename = dir(strcat(root_path,'\','RD*.dcm'));
     RP_filename = dir(strcat(root_path,'\','RP*.dcm'));

     MC_filename = dir(strcat(root_path,'\','*.txt'));

     if length(MC_filename) > 1;
        MC_filename = dir(strcat(root_path,'\','mc*.txt'));
     end
 
        xcl_info = dir(strcat(root_path,'\','*.xls'));

         MC_file = strcat(root_path, MC_filename.name);
        TPS_file = strcat(root_path, TPS_filename.name);
         RP_file = strcat(root_path, RP_filename.name);
        xcl_file = strcat(root_path, xcl_info.name);

        data_input_gui(root_path, destination, MC_file, TPS_file, RP_file, xcl_file, dbpath);
        
        

%% --- Executes on button press in select_database_path.
function select_database_path_Callback(hObject, eventdata, handles)

    [filename, pathname] = uigetfile({'*.*'},'File Selector');
        handles.database = [pathname,filename];

    set(handles.database_path,'string',handles.database);

    guidata(hObject, handles);

function database_path_Callback(hObject, eventdata, handles)

function database_path_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    

%% --- Executes on button press in compute_gamma_analysis.
function compute_gamma_analysis_Callback(hObject, eventdata, handles)

   root_path = get(handles.patient_root_path,'string'); 
TPS_filename = dir(strcat(root_path,'\','RD*.dcm'));


 MC_filename = dir(strcat(root_path,'\','*.txt'));
 
 if length(MC_filename) > 1;
    MC_filename = dir(strcat(root_path,'\','mc*.txt'));
 end
 
    xcl_info = dir(strcat(root_path,'\','*.xls'));
     MC_file = strcat(root_path, MC_filename.name);
    TPS_file = strcat(root_path, TPS_filename.name);
    xcl_file = strcat(root_path, xcl_info.name);
    
              DTA = str2double(get(handles.DTA,'string'));
    dose_criteria = str2double(get(handles.pct_diff,'string'))/100;
        threshold = str2double(get(handles.pct_threshold,'string'))/100;
    
    
            if (get(handles.van_dyk,'Value') == get(handles.van_dyk,'Max'))
                van_dyk = 1; %ON
                van_dyk_disp = 'ON';
            else
                van_dyk = 2; %OFF
                van_dyk_disp = 'OFF';
            end

    
         [ MC ] = mapcheck_opener_V2( MC_file );
    [ TPS_dose] = open_doseplane( TPS_file );
      [~,~,raw] = xlsread(xcl_file, 'MapPhan dose scaled', 'B3:D33');
   dose_scaling = double(cell2mat(raw(13,2)));
       TPS_dose = TPS_dose*dose_scaling;
        
        ind_C = find(strcmp(raw,'CTX')==1);
        ind_D = find(strcmp(raw,'DTX')==1);
        ind_A = find(strcmp(raw,'AEX')==1);

        if isempty(ind_A) == 0
            machine_name = raw(ind_A);
%             MC = MC*(0.9856);
%             machine_name = 'AEX_scaled';
        elseif isempty(ind_C) == 0
            machine_name = raw(ind_C);
%             MC = MC*(1.0009);
%             machine_name = 'CTX_scaled';
        elseif isempty(ind_D) == 0
            machine_name = raw(ind_D);
%             MC = MC*(1.0196);
%             machine_name = 'DTX_scaled';
        else
            machine_name = 'unknown';
        end         
        machine_name = char(machine_name);

    [ gamma, ~, avg_dose_ratio, stdev_dose_ratio ] = gamma_analysis( TPS_dose, MC(2:end,2:end),DTA,dose_criteria,threshold,van_dyk ); 

    axes(handles.display_graph);
    cla
    imshow(TPS_dose,[min(min(TPS_dose)) max(max(TPS_dose))]);
    colormap(gray(32));
    colormap( 1 - colormap );
    freezeColors;
    hold on
    ind = find(gamma(:,1)>1);
    scatter(gamma(ind,3),gamma(ind,2),10,'r','fill')

    data_qaresults{1,2} = DTA;
    data_qaresults{1,1} = 'DTA';

    data_qaresults{2,2} = dose_criteria*100;
    data_qaresults{2,1} = 'Dose Criteria';

    data_qaresults{3,2} = threshold*100;
    data_qaresults{3,1} = 'Threshold';

    data_qaresults{4,2} = van_dyk_disp;
    data_qaresults{4,1} = 'Van Dyk';

    data_qaresults{5,2} = length(gamma(:,1));  %% Total amount of gamma points analyized
    data_qaresults{5,1} = '# Points';

        passed = find(gamma(:,1)<=1);
        num_pass = length(passed);
        pct_pass = roundn(num_pass/length(gamma(:,1))*100,-2);

    data_qaresults{6,2} = pct_pass;
    data_qaresults{6,1} = '% Pass';

    data_qaresults{7,2} = avg_dose_ratio;
    data_qaresults{7,1} = 'Dose Ratio';

    data_qaresults{8,2} = stdev_dose_ratio;
    data_qaresults{8,1} = 'DR StDev';

    data_qaresults{9,2} = dose_scaling;
    data_qaresults{9,1} = 'Dose Scaling';

    data_qaresults{10,2} = machine_name;
    data_qaresults{10,1} = 'Machine Name';

    set(handles.display_table,'data',data_qaresults,'ColumnName',{'Parameter','Value'})

function DTA_Callback(hObject, eventdata, handles)

function DTA_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pct_diff_Callback(hObject, eventdata, handles)

function pct_diff_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pct_threshold_Callback(hObject, eventdata, handles)

function pct_threshold_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function van_dyk_Callback(hObject, eventdata, handles)
    
    
    
    
%% --- Executes on button press in compute_plan_metrics.
function compute_plan_metrics_Callback(hObject, eventdata, handles)

          h = waitbar(0,'please wait...');
  root_path = get(handles.patient_root_path,'string'); 
RP_filename = dir(strcat(root_path,'\','RP*.dcm'));
    RP_file = strcat(root_path, RP_filename.name);

       info = dicominfo(RP_file);
   numbeams = info.FractionGroupSequence.Item_1.NumberOfBeams;

[ PLW, PM, PA, PAGW, PI, ~, ~, ~, ~, ~, ~, ~, ~, totalMU, ~, ~, ~, ~, ...
  modulation_type, field_size_X, field_size_Y, mech_stability ] = calc_fluence_map_V3(RP_file);  

data_planmetrics{1,1}  = numbeams;
data_planmetrics{1,2}  = PLW;
data_planmetrics{1,3}  = PA;
data_planmetrics{1,4}  = PM;
data_planmetrics{1,5}  = PI;
data_planmetrics{1,6}  = PAGW;
data_planmetrics{1,7}  = totalMU;
data_planmetrics{1,8}  = modulation_type;
data_planmetrics{1,9}  = field_size_X;
data_planmetrics{1,10} = field_size_Y;
data_planmetrics{1,11} = mech_stability.plan_mean_deg_MU;
data_planmetrics{1,12} = mech_stability.plan_bankA_mm_MU;
data_planmetrics{1,13} = mech_stability.plan_bankB_mm_MU;

data_planmetrics{1,14} = PI + 1*(((mech_stability.plan_bankA_mm_MU + mech_stability.plan_bankB_mm_MU)/2)*(mech_stability.plan_mean_deg_MU));



                  dbpath = get(handles.database_path,'string');
                username = '';
                     pwd = '';
                     obj = 'org.sqlite.JDBC';
                     URL = ['jdbc:sqlite:',dbpath];
                    conn = database(dbpath,username,pwd,obj,URL);    


eval(['query = fetch(conn,''SELECT patient_ID, dose_scaling, mean_target_dose,', ...
                                  'mean_target_gradient, mean_pneumbra_gradient, mean_lowdose_gradient, mean_lowdose_dose,',...
                                  'target_dose_diff, target_dose_stdev, target_dose_numpoints, pneumbra_dose_diff, pneumbra_dose_stdev,', ...
                                  'pneumbra_dose_numpoints, low_dose_diff, low_dose_stdev, low_dose_numpoints,',...
                                  'numbeams, PLW, PA, PAGW, PI, PM, totalMU, field_size_X, field_size_Y, degree_per_MU, bankA_mm_per_MU, bankB_mm_per_MU,',... 
                                  'dta, dose_criteria, threshold, numpts_analyzed, avg_dose_ratio, stdev_dose_ratio, gpr ',...
               'FROM RTplans ', ...
               'JOIN measurements ', ...
               'JOIN qa_results ', ...
               'JOIN planmetrics ', ...
               'JOIN dosemetrics ', ...
               'WHERE RTplanID = FK_RTplans_measurements ',...
               ' AND measurementID = FK_measurements_qa_results ',...
               ' AND measurementID = FK_measurements_dosemetrics ',...
               ' AND RTplanID = FK_RTplans_planmetrics ',...
               'AND van_dyk = "ON" ',...
               'AND modulation_type = "VMAT" ',...
               'AND machine_name = "CTX" ',...
               'AND threshold = 10 ',...
               'AND dta = 2 ',...
               'AND dose_criteria = 1 ',...
               ''');'])

data = cell2mat(query);

close(conn)

cla(handles.display_graph,'reset')
axes(handles.display_graph);
unfreezeColors;
cla
PI_leafspeed(:,1) = data(:,27).*data(:,26);
C0 = 1;
C1 = 3;
classifier_values(:,1) = C0.*(((data(:,21)))) + C1.*(PI_leafspeed(:,1));
x = data(:,35);
y = classifier_values(:,1);

scatter(x,y,'fill')
hold on
p = polyfit(y,x,1);
ynew = data_planmetrics{1,14};
xfit = polyval(p,ynew);
scatter(xfit,ynew,'r','fill');
xlabel('GPR (%)')
ylabel('Specifier Value')
data_planmetrics{1,15} = xfit;

data = transpose(data_planmetrics);
data(:,2) = data;

data{1,1} = 'Number of Beams';
data{2,1} = '% MU Large Leaves';
data{3,1} = 'Plan Area';
data{4,1} = 'Plan Modulation';
data{5,1} = 'Plan Irregularity';
data{6,1} = 'Plan Area Gantry Weighted';
data{7,1} = 'Total MU';
data{8,1} = 'Modulation Type';
data{9,1} = 'FS X';
data{10,1} = 'FS Y';
data{11,1} = 'MU/degree';
data{12,1} = 'Bank A mm/MU';
data{13,1} = 'Bank B mm/MU';
data{14,1} = 'Specifier Value';
data{15,1} = 'Estimated GPR';
            
set(handles.display_table,'data',data,'ColumnName',{'Parameter','Value'})
close(h)


%% --- Executes on button press in upload_plan_metrics_only.
function upload_plan_metrics_only_Callback(hObject, eventdata, handles)
    
       root_path = get(handles.patient_root_path,'string'); 
     destination = get(handles.destination_root_path,'string'); 
          dbpath = get(handles.database_path,'string');
     RP_filename = dir(strcat(root_path,'\','RP*.dcm'));
      
         RP_file = strcat(root_path, RP_filename.name);
         
     data_input_plan_only(root_path, destination, RP_file, dbpath)
     

%% --- Executes on button press in batch_upload_start.
function batch_upload_start_Callback(hObject, eventdata, handles)


   root_path = get(handles.batch_upload_path,'string'); 
 destination = get(handles.destination_root_path,'string'); 
      dbpath = get(handles.database_path,'string');
      
      data_input_gui_batch(root_path, destination, dbpath);
      
      
%% --- Executes on button press in select_batch_file_path.
function select_batch_file_path_Callback(hObject, eventdata, handles)

    [path] = uigetdir('J:\PhysicsDosimetry\Eclipse TPS\Patient Specific QA');
    handles.path = strcat(path,'\');
    set(handles.patient_root_path,'string',handles.path);
    guidata(hObject, handles);

function batch_upload_path_Callback(hObject, eventdata, handles)

function batch_upload_path_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in database_cleanup.
function database_cleanup_Callback(hObject, eventdata, handles)

    DatabaseCleanup
    



function scaling_factor_Callback(hObject, eventdata, handles)
% hObject    handle to scaling_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaling_factor as text
%        str2double(get(hObject,'String')) returns contents of scaling_factor as a double


% --- Executes during object creation, after setting all properties.
function scaling_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaling_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function machine_name_Callback(hObject, eventdata, handles)
% hObject    handle to machine_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of machine_name as text
%        str2double(get(hObject,'String')) returns contents of machine_name as a double


% --- Executes during object creation, after setting all properties.
function machine_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to machine_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end