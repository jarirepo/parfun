classdef parfunset < handle
% parfunset Representing a set of parameterized functions (parfun objects)
    properties (SetAccess = private)
        x = [];
        F = [];
        pfcn = parfun.empty;   % an array of parfun objects
    end    
    events
        Modified
    end    
    methods
        function obj = parfunset(x, pfdata)
            % pfdata - a cell array with function handle given as @(x)fun in
            % the first column and an parameter array containing parfun 
            % objects that are associated with the function.
            if isnumeric(x)
                x = x(:);
                obj.x = x;
            else
                error('Input X must numeric')
            end
            
            if iscell(pfdata)
                nfcn = size(pfdata,1);
                N = length(x);
                obj.F = zeros(N,nfcn);
                obj.F(:) = NaN;
                
                % loop through the cell array to create the function
                % handles. Each function is assigned a number which refer
                % to an column index into the F array holding the evaluated 
                % functions.
                
                for i=1:nfcn
%{                    
                    It seems like using eval will destroy the function
                    handle ...
                    
                    hFcn = pfdata{i,1};    % handle in the form: @(x)fun
                    fstr = func2str(hFcn)
                    % create a function handle of the form:
                    % @(x)fun(x,params)
                    % get name of independent variable
                    xstr = regexp(func2str(hFcn),'(?<=\()\S','match','once');
                    params = pfdata{i,2};                       
                    %fstr = sprintf('%s(%s,params)',fstr,xstr);
                    %hFcn = str2func(fstr)
                    eval(['hFcn = ' sprintf('%s(%s,params)',fstr,xstr)]);
                    % create parfun object for this function
                    obj.pfcn(i) = parfun(i,x,hFcn,params);
%}
                    % function handle in the form: @(x)fun(x,params)
                    hFcn = pfdata{i,1};    
                    params = pfdata{i,2};         
                    
                    % create parfun object for this function
                    obj.pfcn(i) = parfun(i,x,hFcn,params);                      
                    
                    % write function values into F
                    obj.F(:,i) = obj.pfcn(i).y;
                    
                    % add listener to the 'ValueChanged' event of class parfun
                    addlistener(obj.pfcn(i),'ValueChanged',...
                        @(src,evt)parfunset.handleValueChange(obj,src,evt));                    
                end                                
            end
        end
        
        function update(obj, n, y)
            % Writes parametric function values Y into F(:,n)
            obj.F(:,n) = y;
        end
    end
    
    methods (Static)
        function handleValueChange(obj, src, evtdata, varargin)
            % obj - parfunset object (which received the notification)
            % src - parfun object (which sent the notification)
            % evtdata - FcnEvalData object with a reference hParam to the
            %           parameter that whas changed            
            obj.update(src.n, src.y);   % updates data array F            
            p = evtdata.hParam;          
            fprintf(1,'Parameter <%s> changed to %f in function %d\n', ...
                p.name, p.value, src.n);
            % notify listeners about the change in one of the parameters
            notify(obj,'Modified');
        end        
    end
    
end
