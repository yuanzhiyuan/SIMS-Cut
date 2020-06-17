function [currLabeling, E] = optimizeWithBK(BKhandle, numRows, numCols, dataCosts)
BK_SetUnary(BKhandle,dataCosts);
E = BK_Minimize(BKhandle);
currLabeling = reshape(double(BK_GetLabeling(BKhandle)), numRows, numCols);
end

