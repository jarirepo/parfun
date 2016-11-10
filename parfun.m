classdef parfun < handle
% parfun Parameterized function
% 
% Connects a user-defined function hFcn with pfparam objects representing
% the function input parameters.
% 
% parfun Properties
%   n       - function number 1,2,...
%   x       - discrete grid used in function evaluation
%   hFcn    - handle to user-defined anonymous function (single-variable)
%   params  - an array with references to pfparam objects
% 
% parfun Events
%   ValueChanged
% 
% parfun Methods
%   update
%   parfun.handleValueChange

% Version : 1.0
% Date    : 2016-11-10
% Author  : Jari Repo, University West, jari.repo@hv.se

    properties (SetAccess = private)
        n = NaN;          % function number
        x = []; 
        y = [];             % evaluate function
        hFcn = function_handle.empty;
        params = pfparam.empty;
    end        
    events
        ValueChanged
    end
    methods
%         function obj = parfun(num, x, hFcn, params)
        function obj = parfun(n, x, hFcn, params)            
            if nargin>0               
                if isa(params,'pfparam')                    
                    obj.n = n;
                    obj.x = x;
                    obj.y = hFcn(x);    % -> evaluate function
                    obj.hFcn = hFcn;
                    obj.params = params;
                    % Note that obj is added to the argument list as the 
                    % first object passed to the event handler in order to 
                    % not "get stuck" in a static method.
%                     addlistener(params,'value','PostSet',...
%                         @(src,evt)parfun.handleValueChange(obj,src,evt,n,x,hFcn)); 
                    addlistener(params,'value','PostSet',...
                        @(src,evt)parfun.handleValueChange(obj,src,evt)); 
                else
                    error('pfparam objects are required')
                end
            end
        end        
        function update(obj)
            obj.y = obj.hFcn(obj.x);
        end
    end
    
    methods (Static)
        function handleValueChange(hObj, hSrc, evtdata, varargin)  
            % hObj - parfun object
            switch hSrc.Name
                case 'value'
                    hObj.update();
%{                    
                    fprintf(1,'Parameter <%s> changed to %f in function %d\n', ...
                        evtdata.AffectedObject.name, ...
                        evtdata.AffectedObject.value, ...
                        hObj.n);       
             
                    notify(hObj,'ValueChanged');                    
%}                    
                    % This will pass the pfparam object and the function
                    % column index as additional notification data
                    notify(hObj,'ValueChanged',FcnEvalData( evtdata.AffectedObject ));                    
            end
        end       
    end
end
