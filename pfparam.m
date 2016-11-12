classdef pfparam < handle
% pfparam Parameterized function parameter
% 
% pfparam Properties
%   name - parameter name
%   value - parameter value
%   description - short parameter description (optional)
%   unit - parameter unit (optional)
% 
% pfparam Methods
%   getHandle - returns a function handle to allow changing the parameter
%               value as for example, phi(10)
%   setValue - sets parameter value

% Version : 1.0
% Date    : 2016-11-10
% Author  : Jari Repo, University West, jari.repo@hv.se

    properties (SetObservable, AbortSet = true)
        value = NaN;
    end
    properties (SetAccess = private)
        name = '';
        description = '';
        unit = '';
    end
    methods
        function obj = pfparam(varargin)
            % Input: name, value [, description, unit]
            if nargin>1                
                if ischar(varargin{1}) && ~isempty(varargin{1})
                    obj.name = varargin{1};
                else
                    error('Input NAME must contain characters')
                end
                if isnumeric(varargin{2})
                    obj.value = varargin{2};
                else
                    error('Input VALUE must be numeric')
                end
                % check on description and unit
                if nargin>2
                    if ischar(varargin{3})
                        obj.description = varargin{3};
                    else
                        error('Input DESCRIPTION must be a ''char''')
                    end
                end
                if nargin>3
                    if ischar(varargin{4})
                        obj.unit = varargin{4};
                    else
                        error('Input UNIT must be a ''char''')
                    end
                end
            else
                error('Input NAME and VALUE are required')
            end
        end
        function set.value(obj, val)
            % change parameter value
            if isnumeric(val) && numel(val)==1
                obj.value = val;
            else
                error('Numeric and single-element input VAL is required')
            end
        end
        function val = get.value(obj)         
            val = obj.value;
        end
        function set.name(obj, val)   
            % sets parameter name
            val = strtrim(val);
            res = regexp(val,'^[_a-zA-Z]+\w*','match','once');
            if ~isempty(res)
                obj.name = val;
            else
                error('Invalid name')
            end
        end
        function set.description(obj, val)
            obj.description= strtrim(val);
        end
        function set.unit(obj, val)
            obj.unit = strtrim(val);
        end
        function h = getHandle(obj)            
            % return a function_handle, like a "function parameter"
            % For example:
            %
            %   param1 = pfparam('xmin',10);           
            %   phi = param1.getHandle()
            %   To change value of phi to 20, simply use, phi(20)            
            h = @(val) obj.setValue(val);            
        end        
        function setValue(obj, val)
            % setValue method to allow value to be changed by
            % function-handle
            if isnumeric(val) && numel(val)==1
                obj.value = val;
            else
                error('Numeric and single-element input VAL is required')
            end
        end
    end
end
