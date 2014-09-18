function sampdata = generate_data(bnet,num_samples)


% set random seed for reproducibility

stream = RandStream('mt19937ar');

RandStream.setGlobalStream(stream);


N = size(bnet.dnodes,2);


sampdata = cell(num_samples,N);


observedvalues = make_knowledge_model;

observedvalues = observedvalues.observed;

lowerrange = observedvalues(1);

upperrange = observedvalues(length(observedvalues));


% sample data one row at a time

for n=1:num_samples

 samp = sample_bnet(bnet);



 % keep all the sampled data

 % sampdata(n,1:N) = samp(1:N);



 % keep only the observed data

 sampdata(n, lowerrange:upperrange) = samp(lowerrange:upperrange);

end
