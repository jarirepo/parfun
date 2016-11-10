function [P,pfset] = parfun_example(autodisp)
% parfun_example    Evaluation of parameterized function set
% 
% Gives a general framework (based on the OOP-capabilities in MATLAB) to 
% define a set of parameterized functions. It allows an arbitrary number 
% of user-specified parameters to be associated with any number of 
% user-defined functions. The associated functions within the function set 
% is automatically evaluated and the result array updated whenever a 
% parameter value is changed. This is pretty much like changing a cell in 
% MS Excel where we get an immediate response to the change in any of the 
% input cells. The technique is demonstrated using a simple set  of 
% parameterized functions.
% 
% Inputs
%   autodisp - set to 1 to automatically display the evaluated function 
%              array F, Default: 0
%              If set to 1 you the array F is output for each of the 
%              functions which are associated with the modified parameter
% 
% Outputs:
% P - an array of PFPARAM objects
% pfset - a PARFUNSET object representing the parameterized function set
% 
% Usage:
%   Example with autodisp =0
% 
%   [P,pfset] = parfun_example(0)
% 
%   a = P(1).getHandle();
%   b = P(2).getHandle();
%   c = P(3).getHandle();
%   d = P(4).getHandle();
%   :
% 
%   Change parameter values can be done as follows:
%   a(1.2), disp(pfset.F)
%   b(4.5), disp(pfset.F)
%   c(6.1), disp(pfset.F)
%   d(.5),  disp(pfset.F)
%   :    

%{
    Conevntional evaluation of parameterized functions:

        |------------------|    |---------------|    |--------------|
    |-->| 1. Define Params |--->| 2. Evaluate   |--->| 3. Output    |--|
    |   | (modify params)  |    |    functions  |    |    results   |  |
    |   |------------------|    |---------------|    |--------------|  |
    |                                                                  |
    -------------------------------------------------------------------|
    Fig. 1:

    The PFPARAM, PARFUN and PARFUNSET classes allows to easily define a 
    set of parameterized functions, allowing an arbitrary number of 
    paramerers to be linked with an arbitrary number of functions.

    When the value for a specific parameter is changed, all functions 
    associated with this parameters will automatically get updated,
    not spending time on re-definining the function set. Only those
    functions associated with the changed parameter are updated and
    re-written into the results array.

       |---------------|     |--------------|
    -->| Modify param. |<--->| View results |
       |---------------|     |--------------|
    Fig. 2:

    This is pretty much like changing a cell in MS Excel where we get an
    immediate response to the change in the results.

    The technique is demonstrated using the following simple set of 
    parameterized functions.

      y1 = f1(x) = a*x + b*x
      y2 = f2(x) = a/2*x - 2*d*x
      y3 = f3(x) = a/2*x - 2*c*x + (b/5)*x.^2
      y2 = f4(x) = -3*c*x + d/2

    where x is the independent variable and {a,b,c,d} are adjustable
    numerical parameters. The functions are evaluated for x and stored in 
    an array F as:

        F(x) = [f1(x),f2(x),f3(x),f4(x)]

    For a given set of parameters, one would normally evaluate all 
    functions as follows:
    ----------------------------------------------------------------------
        a = 0; b = 1.5; c = -2; d = 5;
        hfcn = { @(x) a*x + b*x, ...
                 @(x) a/2*x - 2*d*x, ...
                 @(x) a/2*x - 2*c*x + (b/5)*x.^2,...
                 @(x) -3*c*x + d/2 };
        nfcn = length(hfcn);
        x = (0 :.5 : 10)';
        N = length(x);
        F = zeros(N,nfcn);
        for i=1:nfcn
            F(:,i) = hfcn{i}(x);
        end
        disp('F(x)='),disp(F)
    ----------------------------------------------------------------------
    To modify any of the parameters {a,b,c,d} one would in general have to
    repeat the process as shown in Fig. 2.

    Note in this example that a parameter can be associated with multiple 
    functions. Therefore, all functions are evaluated to ensure that all 
    functions that are related to the modified parameter are evaluated. 
    For larger function sets, in time-critical and possibly multi-threaded 
    applications, this might not be the most viable approach.

    This demo outputs the following:

        Initial F(x)=
            1.5000  -10.0000    4.3000    8.5000
            3.0000  -20.0000    9.2000   14.5000
            4.5000  -30.0000   14.7000   20.5000
            6.0000  -40.0000   20.8000   26.5000
            7.5000  -50.0000   27.5000   32.5000

        Parameter <a> changed to 1.500000 in function 3
        Parameter <a> changed to 1.500000 in function 2
        Parameter <a> changed to 1.500000 in function 1
            3.0000   -9.2500    5.0500    8.5000
            6.0000  -18.5000   10.7000   14.5000
            9.0000  -27.7500   16.9500   20.5000
           12.0000  -37.0000   23.8000   26.5000
           15.0000  -46.2500   31.2500   32.5000

        Parameter <b> changed to 2.750000 in function 3
        Parameter <b> changed to 2.750000 in function 1
            4.2500   -9.2500    5.3000    8.5000
            8.5000  -18.5000   11.7000   14.5000
           12.7500  -27.7500   19.2000   20.5000
           17.0000  -37.0000   27.8000   26.5000
           21.2500  -46.2500   37.5000   32.5000

        Parameter <c> changed to 3.100000 in function 4
        Parameter <c> changed to 3.100000 in function 3
            4.2500   -9.2500   -4.9000   -6.8000
            8.5000  -18.5000   -8.7000  -16.1000
           12.7500  -27.7500  -11.4000  -25.4000
           17.0000  -37.0000  -13.0000  -34.7000
           21.2500  -46.2500  -13.5000  -44.0000

        Parameter <d> changed to 5.050000 in function 4
        Parameter <d> changed to 5.050000 in function 2
            4.2500   -9.3500   -4.9000   -6.7750
            8.5000  -18.7000   -8.7000  -16.0750
           12.7500  -28.0500  -11.4000  -25.3750
           17.0000  -37.4000  -13.0000  -34.6750
           21.2500  -46.7500  -13.5000  -43.9750

    Version : 1.0
    Date    : 2016-11-10
    Author  : Jari Repo, University West, jari.repo@hv.se
%}    
    
% check on the inputs
if ~exist('autodisp')
    autodisp = 1;
end

% 1. Define parameters in the P array and set them to some initial value
P = [ pfparam('a',0), ...
      pfparam('b',1.5), ...
      pfparam('c',-2), ...
      pfparam('d',5) ...
];
  
% 2. Group the parameters
%   In this example, 
%       y1 is associated with   'a','b'         -->     P(1),P(2)
%       y2          "           'a','d'         -->     P(1),P(4)
%       y3          "           'a','c','b'     -->     P(1),P(3),P(2)
%       y4          "           'c','d'         -->     P(3),P(4)   
paramSet = { [ P(1), P(2)      ], ...
             [ P(1), P(4)      ], ...
             [ P(1), P(3),P(2) ],...
             [ P(3), P(4)      ] ...
};

% 3. Create function handles for each function y1-y4 which are defined
% elsewhere (see end of this file). Note that the parameter references 
% will be added to the argument list of the anonymous functions
hfcns = { @(x) fcn1(x, paramSet{1}),...
          @(x) fcn2(x, paramSet{2}),...
          @(x) fcn3(x, paramSet{3}),...
          @(x) fcn4(x, paramSet{4}) ...
};

% 4 Create a cell array PFDATA which completely defines the set of 
%   parameterized functions. Note that the same parameter references are
%   used in PFDATA.
pfdata = {  hfcns{1}, paramSet{1}; ...
            hfcns{2}, paramSet{2}; ...
            hfcns{3}, paramSet{3}; ...
            hfcns{4}, paramSet{4}...
};
        
%{
It is also possible to define PFDATA directly as

pfdata = {  @(x)fcn1(x,paramSet{1}), paramSet{1}; ...
            @(x)fcn2(x,paramSet{2}), paramSet{2}; ...
            @(x)fcn3(x,paramSet{3}), paramSet{3}; ...
            @(x)fcn4(x,paramSet{4}), paramSet{4} ...
};
%}

% 5. Create parameterized function set
% create a column vector for the independent variable (x)
x = (1 : 5)';
pfset = parfunset(x, pfdata, autodisp);

% 6. Set callback to the PFSET 'Modified' event
if autodisp
    pfset.addlistener('Modified',@pfsetModified);
end

% --- Output F with evaluated functions ---
if autodisp
    disp('Initial F(x)=')
    disp(pfset.F)
end

% --- Change of parameter values ---

% Setting the parameter value directly as
% P(1).value = 1.25;
% P(4).value = 4.75;

% It is convenient to first convert the parameters in P into handles
%   a_ = P(1).getHandle();
%   b_ = P(2).getHandle();
%   c_ = P(3).getHandle();
%   d_ = P(4).getHandle();

for i=1:length(P)
    eval([P(i).name '_ = P(' num2str(i) ').getHandle();']);
end

% The parameters can now be modified as
% a_(1.5),    disp(pfset.F)
% b_(2.75),   disp(pfset.F)
% c_(3.1),    disp(pfset.F)
% d_(5.05),   disp(pfset.F)

% Remark: Having to specify the parameters twice seems a bit unncecessary, 
% but I could not find a way to extract the input parameters from the 
% anonymous functions.
end

function pfsetModified(obj, src, evtdata, varargin)
    % obj - parfunset object
%     varargin
    disp('F(x)=')
    disp(obj.F)
end

% --- User-defiend parameterized functions ---
% The parameters arrive in order specified in PFDATA
function y = fcn1(x,varargin)
    param = varargin{1};    % all parameters always arrive in varargin{1}
    a = param(1).value;
    b = param(2).value;
    y = a*x + b*x;
end
function y = fcn2(x,varargin)
    param = varargin{1};
    a = param(1).value;
    d = param(2).value;
    y = a/2*x - 2*d*x;
end
function y = fcn3(x,varargin)
    param = varargin{1};
    a = param(1).value;
    c = param(2).value;
    b = param(3).value;
    y = a/2*x - 2*c*x + (b/5)*x.^2; 
end
function y = fcn4(x,varargin)
    param = varargin{1};
    c = param(1).value;
    d = param(2).value;    
    y = -3*c*x + d/2;
end

% --- Helper functions ---
function anykey()
    disp('Any key to continue ...')
    pause
end
