classdef pfparam < handle
% pfparam Parameterized function parameter
% 
% pfparam Properties
%   name - parameter name
%   value - parameter value
% 
% pfparam Methods
%   getHandle - returns a function handle to allow changing the parameter
%               value as for example, phi(10)
%   setValue - sets parameter value

% Version : 1.0
% Date    : 2016-11-10
% Author  : Jari Repo, University West, jari.repo@hv.se

    properties (SetObservable, AbortSet = true)
        value;
    end
    properties (SetAccess = private)
        name;
    end
    properties (SetAccess = public)
        units;
        descr;
    end
    methods
        function obj = pfparam(varargin)
            if nargin>1
                if ischar(varargin{1}) && length(varargin{1})>0
                    obj.name = varargin{1};
                else
                    error('Input NAME must contain characters')
                end
                if isnumeric(varargin{2})
                    obj.value = varargin{2};
                else
                    error('Input VALUE must be numeric')
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
        function set.units(obj, val)
            obj.units = val;
        end
        function set.descr(obj, val)
            obj.descr = val;
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
