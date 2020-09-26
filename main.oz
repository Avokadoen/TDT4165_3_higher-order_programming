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
            % TODO: find out how to get 'and' inn if to avoid rounding error
            if D >= 0.0 then
                local 
                    SqrtResult = {Sqrt D}
                    TwoA = 2.0 * A
                in
                    RealSol = true
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
                RealSol = false
            end
        end
    end

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
        {System.showInfo 'Testing A = 2.0, B = 1.0, C = 2.0'}
        {System.show {QuadraticEquation A B C RealSol X1 $ }}
        {System.show {QuadraticEquation A B C RealSol $  X2}}
        {System.show {QuadraticEquation A B C $       X1 X2}}
    end

    {Exit 0}
end
