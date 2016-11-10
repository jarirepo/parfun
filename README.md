# parfun
Gives a general framework (based on the OOP-capabilities in MATLAB) to define a set of parameterized functions. 
It allows an arbitrary number of user-specified parameters to be associated with any number of user-defined functions. 
The associated functions within the function set is automatically evaluated and the result array updated whenever a 
parameter value is changed.

This is pretty much like changing a cell in MS Excel where we get an immediate response to the change in any of the input cells.

The technique is demonstrated using the following simple set of parameterized functions.

y1 = f1(x) = ax + bx
y2 = f2(x) = ax/2 - 2dx
y3 = f3(x) = ax/2 - 2cx + (b/5)x^2
y2 = f4(x) = -3cx + d/2

where x is the independent variable and {a,b,c,d} are adjustable numerical parameters. 
The functions are evaluated for x and stored in an array F as:

F(x) = [f1(x),f2(x),f3(x),f4(x)]

For a given set of parameters, one would normally evaluate all functions as follows:
------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------

To modify any of the parameters {a,b,c,d} one would in general have to repeat the 
process.

Note in this example that a parameter can be associated with multiple functions. 
Therefore, all functions are evaluated to ensure that all functions that are related 
to the modified parameter are evaluated. For larger function sets, in time-critical 
and possibly multi-threaded applications, this might not be the most viable approach.

1. Define parameters in the P array and set them to some initial value
P = [ pfparam('a',0), ...
      pfparam('b',1.5), ...
      pfparam('c',-2), ...
      pfparam('d',5) ...
];

2. Group the parameters
paramSet = { [ P(1), P(2)      ], ...
             [ P(1), P(4)      ], ...
             [ P(1), P(3),P(2) ],...
             [ P(3), P(4)      ] ...
};

3. Create a cell array PFDATA which completely defines the set of parameterized functions.    
   Remark 1. The same parameter references are used when creating PFDATA.
   Remark 2. The user-defined functions fcn1-4 are implemented elsewhere.
   
pfdata = {  @(x)fcn1(x,paramSet{1}), paramSet{1}; ...
            @(x)fcn2(x,paramSet{2}), paramSet{2}; ...
            @(x)fcn3(x,paramSet{3}), paramSet{3}; ...
            @(x)fcn4(x,paramSet{4}), paramSet{4} ...
};

5. Create parameterized function set
x = (1 : 5)';
pfset = parfunset(x, pfdata);

6. Modify some parameters and immediately view the updated data in pfdata.F
a = P(1).getHandle();
d = P(4).getHandle();

a(2),     disp(pfdata.F)
d(1.25),  disp(pfdata.F)

Note that we do not need to repat the full sequence of code by using this approach

See "parfun_example.m" for more details
