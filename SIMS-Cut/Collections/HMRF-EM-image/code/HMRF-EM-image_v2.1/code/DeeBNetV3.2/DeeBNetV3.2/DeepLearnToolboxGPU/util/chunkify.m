function chunks = chunkify(chunksize,data)
%%CHUNKIFY extract minibatch index
% return row indexes for chunks of a given size 
[m,n] = size(data);
numchunks =ceil( m / chunksize);
batchstart = 1;
batchend   = chunksize;

for i = 1:numchunks
    if (batchend + chunksize) <= m
       chunks{i}.start  = batchstart;
       chunks{i}.end    = batchend;
    else
       chunks{i}.start  = batchstart;
       chunks{i}.end    = m;
    end
    batchstart = batchend +1;
    batchend   = batchstart + chunksize -1;
end
end