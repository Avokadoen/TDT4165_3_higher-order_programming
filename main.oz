functor
import
    Application(exit:Exit)
    System
    MyList at './list.ozf'  
define
    % TODO: This code is ugly :(
    proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
        local 
            % We precompute D to only do it once, and check if we
            % Should continue the calculation
            D = {Pow B 2.0} - 4.0 * A * C
        in
            RealSol = D >= 0.0
            % TODO: find out how to get 'and' inn if to avoid rounding error
            if RealSol then
                local 
                    SqrtResult = {Sqrt D}
                    TwoA = 2.0 * A
                in
                    X1 = (~B + SqrtResult) / TwoA

                    % NOTE: checking if float is 0 is bad practice, but I'm not really sure how to express 'and'
                    if D == 0.0 then
                        X2 = X1
                    else 
                        X2 = (~B - SqrtResult) / TwoA
                    end
                end
            else
                X1 = X2 = 0.0
            end
        end
    end

    {System.showInfo 'Task 1 a'}
    % Task 1a
    local
        RealSol 
        X1
        X2
        A = 2.0
        B = 1.0
        C = ~1.0
    in
        {System.showInfo 'Testing A = 2.0, B = 1.0, C = -1.0'}
        {System.show {QuadraticEquation A B C RealSol X1 $ }}
        {System.show {QuadraticEquation A B C RealSol $  X2}}
        {System.show {QuadraticEquation A B C $       X1 X2}}
    end

    % Task 1a
    local
        RealSol 
        X1
        X2
        A = 2.0
        B = 1.0
        C = 2.0
    in
        {System.showInfo '\nTesting A = 2.0, B = 1.0, C = 2.0'}
        {System.show {QuadraticEquation A B C RealSol X1 $ }}
        {System.show {QuadraticEquation A B C RealSol $  X2}}
        {System.show {QuadraticEquation A B C $       X1 X2}}
    end
    
    % Task 1b) Why are procedural abstractions useful?  Give at least two reasons
    
    % Procedures is a companion feature with functions in OZ. It *seems* one should use functions 
    % when you are making something that should take in data, and return a produced output.
    % Procedures in turn seem to fit when you want side effects or no internal effect.
    % Unlike OZ, C only has function. A C function signature looks like:
    % int max(int num1, int num2) { /* code */ }
    % But since you have type annotations, you can also express OZ procedures:
    % void max(int num1, int num2, int* out) { /* code */ }

    % So OZ's procedures are form of traditional functions where you have no explicit 
    % return value. But OZ's procedures brings some features to the table to justify 
    % separating between function and procedures. 
    %   - You can express which value you would like to extract as a return value like I did in task 1 a.
    %   - Procedures can be used as function pointers and/or lambdas/closures
    %     Example from documentation: 
    %     local 
    %         Max = proc {$ X Y Z}
    %                   if X >= Y then Z = X
    %                   else Z = Y end 
    %               end 
    %         X = 5
    %         Y = 10
    %         Z
    %     in 
    %       {Max X Y Z} {Browse Z}
    %     end    
    {Exit 0}
end
