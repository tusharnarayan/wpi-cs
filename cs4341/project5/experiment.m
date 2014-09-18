bnet = make_knowledge_model;
samples = generate_data(bnet, 500);
f_guess = zeros(6, 6);
f_slip = zeros(6, 6);
figure;
axis([0 1 0 1]);
hold on;
for i = 0:5
    guess = i*0.2;
    for j = 0:5
        slip = j*0.2;
        [f_guess(i+1, j+1), f_slip(i+1, j+1)] = fit_parameters(bnet, samples, guess, slip);
        plot([guess, f_guess(i+1, j+1)], [slip, f_slip(i+1, j+1)]);
        hold on;
    end
end
