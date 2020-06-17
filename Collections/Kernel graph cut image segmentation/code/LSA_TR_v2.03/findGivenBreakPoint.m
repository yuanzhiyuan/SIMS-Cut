function [labeling, E] = findGivenBreakPoint(BKhandle,numRows, numCols, DCapprox, optOptions)
    
    approxUE = DCapprox.approxUE;
    distUE = DCapprox.distUE;
    
    % this is the solution 
    [labeling, E] = optimizeWithBK(BKhandle, numRows, numCols, approxUE + optOptions.LAMBDA_LAGRANGIAN*distUE);

      

end