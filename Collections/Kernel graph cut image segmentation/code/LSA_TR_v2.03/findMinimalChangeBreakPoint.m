function [bottomLambda, bottomLabeling, Ebottom_end] = findMinimalChangeBreakPoint(BKhandle,numRows, numCols, currLabeling, DCapprox, optOptions)
                                                                            
    % search for the maximal lambda that makes a change in the solution
    % this will guarantee that the change is minimal
    foundLambda = false;
    counter = 0;
    
    distUE = DCapprox.distUE;
    approxUE = DCapprox.approxUE;
    
   
        % lambda interval
    topLambda = optOptions.LAMBDA_LAGRANGIAN;
    % this is the solution for the top lambda
    [topLabeling, ~] = optimizeWithBK(BKhandle, numRows, numCols, topLambda * distUE + approxUE);
            
    % the idea is first to find large enough lambda that does not get any change
    % in the solution.
    % second use it as an upper bound in a binary search
    while any(double(topLabeling(:)) ~= currLabeling(:))
        topLambda = topLambda * optOptions.LAMBDA_MULTIPLIER;
        [topLabeling, Etop_end] = optimizeWithBK(BKhandle, numRows, numCols, topLambda * distUE + approxUE);
        disp(['looking for topLambda: ' num2str(topLambda) ' ' num2str(Etop_end)]);
    end
    
    bottomLambda = optOptions.PRECISION_COMPARE_GEO_LAMBDA;
    % this is the solution for the bottom lambda
    [bottomLabeling, Ebottom_end] = optimizeWithBK(BKhandle, numRows, numCols, bottomLambda * distUE + approxUE);
    

    % binary search for Lambda (that yields the solution with the smallest change)
    while ~foundLambda

        counter = counter + 1;

        % combine data cost of the bins with the distance from the current
        % solution

        % this is the solution for the middle lambda
        middleLambda = (topLambda + bottomLambda)/2;
        [middleLabeling, Emiddle_end] = optimizeWithBK(BKhandle, numRows, numCols, middleLambda * distUE + approxUE);

        if any(middleLabeling(:)~=topLabeling(:))
            bottomLambda = middleLambda;
            bottomLabeling = middleLabeling;
            Ebottom_end = Emiddle_end;
        elseif any(middleLabeling(:)~=bottomLabeling(:))
            topLambda = middleLambda;
            topLabeling = middleLabeling;
            Etop_end = Emiddle_end;
        else
            %disp('topLabeling == bottomLabeling!');
            foundLambda  = true;
        end
        if  (topLambda-bottomLambda) < optOptions.PRECISION_COMPARE_GEO_LAMBDA
             foundLambda = true;
        end
    end % while not found the correct lambda

    if optOptions.SHOW_FLAG
        disp(['Seg BINARY search: ' num2str(counter) ' iterations, minimal change Lambda: ' num2str(bottomLambda)]);
    end

end