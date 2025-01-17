function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1); %手写数字个数
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
yNum = zeros(m, num_labels); %5000 * 10的0矩阵
%每一行中为1的那一项就是手写数字对应实际数字
for i = 1:m
    yNum(i, y(i)) = 1;
end
%通过前向传播计算出最后的激活值
a1 = X;

z2 = (Theta1 * [ones(m, 1) a1]')'; % size(z2) = (5000, 25)
a2 = sigmoid(z2); 

z3 = (Theta2 * [ones(m, 1) a2]')'; %size(z3) = (5000, 10)
a3 = sigmoid(z3);
%计算代价函数的值
for i = 1:m
    J = J + (-yNum(i, :) * log(a3(i, :))' - (1. - yNum(i, :)) * log(1. - a3(i, :))');
end
%第一部分的size过程为 (1 * 10) * (10 * 1) = 1 * 1
%第二部分的size过程和第一步一样
J = J / m

%自己写的憨憨东西，最后算出来的值是0.38448，初步分析应该是计算步骤太多，计算过程中的误差被放大了
%实际是因为矩阵中的有一列全是1，这一列是偏置单元，不应该把这一列加入计算，theta1只应该取400列，而不是401列，
%theta2只应该取25列，而不是26列
% %加入正则化项
% for i = 1:hidden_layer_size
%     sum_theta1 = sum_theta1 + sum(Theta1(i,:).^2);
% end
% 
% for i = 1: num_labels
%     sum_theta2 = sum_theta2 + sum(Theta2(i, :).^2);
% end
% 
% regular_item = lambda * 1 /(2 * m) * (sum_theta1 + sum_theta2);
% J = J + regular_item;

%大佬写的代码
t1 = Theta1(:, 2:end);
t2 = Theta2(:, 2:end);

regularization = lambda / (2 * m) * (sum(sum(t1 .^ 2)) + sum(sum(t2 .^ 2)));

J = J + regularization;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%

%5000 * 10
d3 = a3 - yNum;

%5000 * 25
d2 = (d3 * Theta2(:, 2:end)) .* sigmoidGradient(z2);

%10 * 26 Theta2_grad
a2_with_a0 = [ones(m, 1) a2];

D2 = d3' * a2_with_a0;

Theta2_grad = D2 / m;

a1_with_a0 = [ones(m, 1) a1];

D1 = d2' * a1_with_a0;

Theta1_grad = D1 / m;
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
regularization_Theta1 = lambda / m * [zeros(size(Theta1, 1), 1) Theta1(:, 2:end)];

Theta1_grad = Theta1_grad + regularization_Theta1;

regularization_Theta2 = lambda / m * [zeros(size(Theta2, 1), 1) Theta2(:, 2:end)];

Theta2_grad = Theta2_grad + regularization_Theta2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
