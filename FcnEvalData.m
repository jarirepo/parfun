classdef FcnEvalData < event.EventData
    properties
        hParam; % affected pfparam object        
    end
    methods
        function obj = FcnEvalData(hParam)
            obj@event.EventData();
            obj.hParam = hParam;
        end
    end
end
