function [ EP, TaskParam ] = Parameters( OperationMode )
global S

if nargin < 1 % only to plot the paradigme when we execute the function outside of the main script
    OperationMode = 'Acquisition';
end

p = struct; % This structure will contain all task specific parameters, such as Timings and Graphics


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFY FROM HERE....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GoNogo

p.Conditions = {
    'free'  'go' 1
    'free'  'no' 1
    'right' 'go' 1
    'right' 'no' 1
    'up'    'go' 1
    'up'    'no' 1
    };

p.nRep = 40;

% % experimentor will choose DOWN or RIGHT
% p.Conditions = {
%     % cond        nFree  nHighReward nNowReward FreeHighAmounnt FreeLowAmount InstructedHighAmounnt InstructedLowAmounnt
%     'congruent'   20     20         20               +9         +1               +9                 +1
%     'incongruent' 20     20         20               +1         +9               +9                 +1
%     };


%% Timings

% all dur* are in seconds
p.dur_ActionSelection            = 2.300 + [-0.500 +0.500];

p.dur_FixationPeriod_MinimumStay = 0.100; % gaze
p.dur_FixationPeriod_Maximum     = 0.300 + [-0.100 +0.100]; % got to next trial

p.dur_TargetAppearance           = 0.500 + [-0.100 +0.100];

p.dur_ResponseCue_Go_MinimumStay = 0.200; % after, do Smiley HAPPY
p.dur_ResponseCue_Go_Maximum     = 0.700; % after, do Smiley BAD
p.dur_ResponseCue_Go_Smiley      = 0.030;

p.dur_ResponseCue_No_MinimumStay = 0.700; % after, do Smiley HAPPY
p.dur_ResponseCue_No_Maximum     = 0.700; % after, do Smiley BAD
p.dur_ResponseCue_No_Smiley      = 0.030;

p.dur_InterTrailInterval         = 6.000 + [-0.500 +0.500];


%% Debugging

switch OperationMode
    case 'FastDebug'
        p.nRep = 1;
    case 'RealisticDebug'
        p.nRep = 1;
    case 'Acquisition'
        % pass
    otherwise
        error('mode ?')
end


%% Graphics
% graphic parameters are in a sub-function because they are common across tasks

p = TASK.Graphics( p );


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... TO HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p.nTrial = sum(cell2mat(p.Conditions(:,3))) * p.nRep;


%% Build planning

% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};

% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for iBlock = 1 : p.nRep

    cond = Shuffle(p.Conditions,2);

    for c = 1 : size(cond,1)
        EP.AddEvent({ [cond{c,1} '_' cond{c,2}] NextOnset(EP) 12})
    end

end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));

EP.BuildGraph();


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargin < 1

    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )

    EP.Plot();

end


%% Save

TaskParam = p;

S.EP        = EP;
S.TaskParam = TaskParam;


end % function
