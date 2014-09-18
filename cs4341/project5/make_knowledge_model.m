function bnet = make_knowledge_model()
% number of nodes
N = 10;

% variable names for the knowledge nodes (latent) and their node numbers

K1=1;
K2=2;
K3=3;
K4=4;
K5=5;

% variable names for the question nodes (observable) and their node numbers

Q1=6;
Q2=7;
Q3=8;
Q4=9;
Q5=10;

% topology is defined in a directed acyclic graph
dag = zeros(N,N);

dag(K1,K2) = 1;
dag(K2,K3) = 1;
dag(K3,K4) = 1;
dag(K4,K5) = 1;

dag(K1,Q1) = 1;
dag(K2,Q2) = 1;
dag(K3,Q3) = 1;
dag(K4,Q4) = 1;
dag(K5,Q5) = 1;

% equivalence classes specify which nodes share a single CPT
eclass = zeros(1,N);

% K1 gets a separate eclass because it has no parent (different CPT dimension)
% K1 CPT contains the prior probability
eclass(K1) = 1;

% all the other knowledge nodes share the same transition probabilities
eclass([K2 K3 K4 K5]) = 2;

% all question nodes share the same emission probabilities
eclass([Q1 Q2 Q3 Q4 Q5]) = 3;

% observed variables
obs = 6:10;

% all nodes modeled as binary variables
node_sizes = 2*ones(1,N);

% all nodes are discrete variables
discrete_nodes = 1:N;

bnet = mk_bnet(dag,node_sizes,'discrete',discrete_nodes,'observed',obs,'equiv_class',eclass);

% define the conditional probabilities of the equivalence classes
prior = 0.50;
learn = 0.14;
forget = 0.00;
guess = 0.20;
slip = 0.08;

% prior
bnet.CPD{1} = tabular_CPD(bnet, K1, 'CPT', [1-prior prior]);

% learn/forget
bnet.CPD{2} = tabular_CPD(bnet, K2, 'CPT', [1-learn forget learn 1-forget]);

% guess/slip
bnet.CPD{3} = tabular_CPD(bnet, Q1, 'CPT', [1-guess slip guess 1-slip]);

