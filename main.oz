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
    {System.showInfo 'See comments for answer of Task 1b'}
    % Procedural abstraction is useful for countless reasons. One of the main reasons is to avoid
    % duplicate code. Duplicate code is bad as it can lead to unnecessary bugs as you copy your code around in your codebase. 
    % It becomes harder to maintain as changes to the code blocks are required multiple places in your codebase instead of in the procedure block.
    % Procedural abstraction is also useful for encapsulation, and opens for the possibility to use the countless patterns
    % that utilize procedures. Recursion, Currying (https://en.wikipedia.org/wiki/Currying), etc …
    % Function pointers are also very useful. Example of a good use-case is input bindings. 
    % The program can have a set of bindable procedures, and then the user can configure which keys
    % that points to which procedure.   


    % Task 1c) What is the difference between a procedure and a function?
    {System.showInfo 'See comments for answer of Task 1c'}
    % Procedures is a companion feature with functions in OZ. It *seems* one should use functions 
    % when you are making something that should take in data, and return a produced output.
    % Functions are in other words reserved for pure function oriented code. 
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
    % Example of no internal side effect could be a procedure that creates a file 
    % and does not report the outcome of the operation  

    {System.showInfo '\nTask 2'}
    {System.showInfo 'Running {MyList.sum [1 2 3 4 5]}: '#{MyList.sum [1 2 3 4 5]}}

    {System.showInfo '\nTask 3abc, please see comments in source code'}
    % Task 3b: Relevant comments is under and in list.oz in the RightFold function
    local 
        % Here we define variable 'Sum' to the given anonymous function 
        Sum =   fun {$ Head Other} 
                    Head + Other
                end

        % Here we define variable 'Length' to the given anonymous function 
        Length =    fun {$ Head Other}
                        1 + Other
                    end

        TestList = [0 1 2 3 4]
    in 
        {System.show 'Running RightFold with '#TestList}
        {System.showInfo 'Running RightFold with sum: '#{MyList.rightFold TestList Sum 0}}
        {System.showInfo 'Running RightFold with length: '#{MyList.rightFold TestList Length 0}}
    end

    {System.showInfo '\nTask 3d, please see comments in source code'}
    % For Sum and Length it does not matter, even with negative values
    % Sum: (5 + (2 + (-4 + 4))) ==  (((5 + 2) + -4) + 4) == 7
    % Length: (((1 + 1) + 1) + 1) == (1 + (1 + (1 + 1))) == 4 

    {System.showInfo '\nTask 3e, please see comments in source code'}
    % For product you would want 1 as U 
    % {Product [1 2 3]} = (1 * (2 * (3 * 1))) = 6

    {System.showInfo '\nTask 4'}
    fun {Quadratic A B C}
        fun {$ X}
            % We return a function that keeps A B C in it's scope, and takes a new
            % variable X
            A * {Pow X 2} + B * X + C 
        end
    end
    {System.showInfo 'Running {{Quadratic 3 2 1} 2}: '#{{Quadratic 3 2 1} 2}}

    {System.showInfo '\nTask 5a'}
    fun {LazyNumberGenerator StartValue}
        local 
            % A local function that will simply call the main
            % function with incremental start value
            fun {InternalLazy}
                {LazyNumberGenerator (StartValue + 1)}
            end
        in
            % The function returns a tuple that holds the value that the function was supplied
            % It also holds the pointer to our internal function. This allows callers
            % of LazyNumberGenerator to call the returned tuple .2 value to increment 
            % 
            lazynumbergenerator(StartValue InternalLazy)
        end
    end
    {System.showInfo 'Running {LazyNumberGenerator 0}.1: '#{LazyNumberGenerator 0}.1}
    {System.showInfo 'Running {{LazyNumberGenerator 0}.2}.1: '#{{LazyNumberGenerator 0}.2}.1}
    {System.showInfo 'Running {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1: '#{{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1}
    
    {System.showInfo '\nTask 5b, please see comments in source code'}
    % Please see comments in LazyNumberGenerator definition.

    % One limitation of this abstraction is performance in a lot of use cases.
    % i.e If you want to repeatedly loop from 1 to 1000 you will create a lot
    % of extra garbage as we construct a tuple and a closjure for each iteration
    % if the language don't utilize certain optimization, it will also do
    % a lot of unnecessary stack allocation as this is something that happens each
    % time a program enters a function.

    % Another limitation of *this specific* implementation is that iterating large amounts
    % is very verbose.  

    {System.showInfo '\nTask 6a, please see comments in source code'}
    % No, my current implementation is not tail recursive:
    % fun {Sum L}
    %     case L of Head|Tail then
    %         Head + {Sum Tail}
    %     else
    %         0
    %     end
    % end 
    % If we call Sum with [1 2 3 4], we get the following
    % 1 + {Sum [2 3 4]}
    % 1 + 2 + {Sum [3 4]}
    % 1 + 2 + 3 + {Sum [4]}
    % 1 + 2 + 3 + 4 + {Sum nil|}
    % 1 + 2 + 3 + 4 + 0
    % 1 + 2 + 3 + 4
    % 1 + 2 + 7
    % 1 + 9
    % 10
    % Notice the pyramid shape as we grow our expression, this
    % can be very bad if you want to run your code at scale.
    % to fix this we can defined sum as i have with MyList.SumTR
    % which can be found in list.oz. It has the following definition:
    % fun {SumTR L}
    %     local 
    %         fun {Go Sum L}
    %             case L of Head|Tail then
    %                 {Go Head + Sum Tail}
    %             else
    %                 Sum
    %             end
    %         end
    %     in 
    %         {Go 0 L}
    %     end
    % end
    % If we call SumTR on [1 2 3 4], we get the following
    % {Go 0 [1 2 3 4]}
    % {Go 1 [2 3 4]}
    % {Go 3 [3 4]}
    % {Go 6 [4]}
    % {Go 10 nil|}
    % + unwinding with 10 (which some/most language compilers can optimize away)
    {System.showInfo 'Running {MyList.sumTR [1 2 3 4]}: '#{MyList.sumTR [1 2 3 4]}}
    
    {System.showInfo '\nTask 6b, please see comments in source code'}
    % The benefit here is performance, mainly in memory useage, but as I said,
    % it can help the compiler do further optimizations i.e avoid stack hammering with stack frames

    {System.showInfo '\nTask 6c, please see comments in source code'}
    % Yes, and no. You can benefit without further optimizations done by the compiler
    % as the memory useage can be reduces. You will still get problems with 
    % blowing your stack among other things if the compiler is not capable of utilizing tail recursion
    % optimizations. 

    % So in other words: the major gains from tail recursion comes from the compilers 
    % optimizing the output code, but not all gains comes from the just compiler.
    {Exit 0}
end
