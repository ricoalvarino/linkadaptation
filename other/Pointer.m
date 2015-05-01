classdef Pointer < handle
    %POINTER simulates a pointer to an object
    % For example, if Clas is a value class, you can use this class as
    %
    % point1 = pointer(Clas());
    % point2.prop1 = 100
    % point1.prop1 //Will return 100
    %
    % Note that it is not possible to create a pointer to an already
    % instantiated object.
    properties
        obj
    end
    methods
        function a = pointer(o)
           a.obj = o; 
        end
    end
end