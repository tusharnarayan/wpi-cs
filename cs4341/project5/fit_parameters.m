function [f_guess, f_slip] = fit_parameters(bnet, sampdata, guess, slip)

% values of the ground truth parameters that generate the data
t_prior = CPD_to_CPT(bnet.CPD{1});
t_prior = t_prior(2);

t_trans = CPD_to_CPT(bnet.CPD{2});
t_learn = t_trans(3);
t_forget = t_trans(2);

t_emit = CPD_to_CPT(bnet.CPD{3});
t_guess = t_emit(3);
t_slip = t_emit(2);

% intial values for EM parameter learning
i_prior = rand;
i_learn = rand;
i_forget = 0;
i_guess = guess;
i_slip = slip;

% prior
bnet.CPD{1} = tabular_CPD(bnet, bnet.rep_of_eclass(1), 'CPT', [1-i_prior i_prior]);

% learn/forget
bnet.CPD{2} = tabular_CPD(bnet, bnet.rep_of_eclass(2), 'CPT', [1-i_learn i_forget i_learn 1-i_forget]);

% guess/slip
bnet.CPD{3} = tabular_CPD(bnet, bnet.rep_of_eclass(3), 'CPT', [1-i_guess i_slip i_guess 1-i_slip]);

% initialize inference engine

engine = jtree_inf_engine(bnet);

% max iterations for EM parameter fitting
max_iter = 200;

% learn parameters

[bnet, LLtrace] = learn_params_em(engine, sampdata',max_iter);

% values of fit parameters
f_prior = CPD_to_CPT(bnet.CPD{1});
f_prior = f_prior(2);

f_trans = CPD_to_CPT(bnet.CPD{2});
f_learn = f_trans(3);
f_forget = f_trans(2);

f_emit = CPD_to_CPT(bnet.CPD{3});
f_guess = f_emit(3);
f_slip = f_emit(2);

fprintf('intial params:\t prior: %.3f, learn: %.3f, forget: %.3f, guess: %.3f, slip: %.3f\n',...
   i_prior, i_learn, i_forget, i_guess, i_slip);

fprintf('learned params:\t prior: %.3f, learn: %.3f, forget: %.3f, guess: %.3f, slip: %.3f\n',...
   f_prior, f_learn, f_forget, f_guess, f_slip);

fprintf('true params:\t prior: %.3f, learn: %.3f, forget: %.3f, guess: %.3f, slip: %.3f\n',...
   t_prior, t_learn, t_forget, t_guess, t_slip);

MAE = mean([abs(f_prior-t_prior) abs(f_learn-t_learn) abs(f_forget-t_forget) abs(f_guess-t_guess) abs(f_slip-t_slip)]);
fprintf('\nMean Absolute Error of parameter learning: %.4f\n',MAE);
