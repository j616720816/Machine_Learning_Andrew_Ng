function p = predictOneVsAll(all_theta, X)
%PREDICT Predict the label for a trained one-vs-all classifier. The labels 
%are in the range 1..K, where K = size(all_theta, 1). 
%  p = PREDICTONEVSALL(all_theta, X) will return a vector of predictions
%  for each example in the matrix X. Note that X contains the examples in
%  rows. all_theta is a matrix where the i-th row is a trained logistic
%  regression theta vector for the i-th class. You should set p to a vector
%  of values from 1..K (e.g., p = [1; 3; 1; 2] predicts classes 1, 3, 1, 2
%  for 4 examples) 

m = size(X, 1); %手写数字总的个数
num_labels = size(all_theta, 1); %有多少种数字

% You need to return the following variables correctly 
p = zeros(size(X, 1), 1);

% Add ones to the X data matrix
X = [ones(m, 1) X]; %预处理

% ====================== YOUR CODE HERE ======================
% Instructions: Complete the following code to make predictions using
%               your learned logistic regression parameters (one-vs-all).
%               You should set p to a vector of predictions (from 1 to
%               num_labels).
%
% Hint: This code can be done all vectorized using the max function.
%       In particular, the max function can also return the index of the 
%       max element, for more information see 'help max'. If your examples 
%       are in rows, then, you can use max(A, [], 2) to obtain the max 
%       for each row.
%       
index=0;
pre=zeros(num_labels,1); %存储每个样本对应数字1-10的预测值

for c=1:m,
  for d=1:num_labels,
    pre(d)=sigmoid(X(c,:)*(all_theta(d,:)')); %每一个手写数字与对应标签的参数相乘
  end
  [maxnum index]=max(pre);
  p(c)=index;   %找到该样本最大的预测值所对应的数字，作为实际预测值
end
% =========================================================================


end
