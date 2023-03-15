function AUC = CoarsenRank(data, ground_truth, a, tau, M)
data = data(:,2:end);
n_item = max(max(data)); % the number of items
n_data = size(data,1);  % the size of sample

alpha = repmat(a, n_item, 1);% initial parameters for scores,
theta = alpha(:,1) ./ alpha(:,2);
auc = []; 

%% Rank index generation
Idx = Coarsen_idx(data, n_item);
for iter = 1: M  % repeat the experiments M times
    %% Expectation Step
    delta = Coarsen_Exp(data, theta);
    
    %% Maximum Step
    theta = Coarsen_Max(Idx, alpha, delta, tau);
    
    %% calculate the accuracy
    auc(iter) = calc_auc(ground_truth, theta);
    Log_likelihood(iter) = Log_likelihood_Evaluation(data, theta);
    theta = 5 * theta / sum(theta);
end

AUC = mean(auc(end-5: end));