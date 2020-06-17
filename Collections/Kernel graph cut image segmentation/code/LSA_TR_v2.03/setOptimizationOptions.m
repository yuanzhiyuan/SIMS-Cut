function optOptions = setOptimizationOptions(numRows, numCols, myString)

    optOptions.numNodes = numRows*numCols;
    optOptions.numRows = numRows;
    optOptions.numCols = numCols;
    optOptions.myString = myString;
    
    % fast trust region params
    optOptions.MAX_LAMBDA_LAGRANGIAN = 1e5;
    optOptions.LAMBDA_LAGRANGIAN = 0.1; 
    optOptions.LAMBDA_LAGRANGIAN_RESTART = 0.1; 
    optOptions.PRECISION_COMPARE_GEO_LAMBDA = 1e-9; % used to compare GEO lambda in parametric maxflow
    optOptions.LAMBDA_MULTIPLIER = 2;% used for jumps in backtracking;
    optOptions.REDUCTION_RATIO_THRESHOLD = 0.25;%0.25; % used to decide whether to increase or decrease lambda using the multiplier
    optOptions.distance = 'eucledian'; %'hamming'
        
    % output and visualization
    optOptions.SHOW_FLAG = true;
    
    
end