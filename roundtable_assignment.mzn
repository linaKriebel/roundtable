include "lex_lesseq.mzn";

enum TOPIC;

int: topics;
int: rounds;

int: tables = rounds * topics;
int: chairs = tables * 6;

int: people;

set of int: PERSON = 1..people;
set of int: TABLE = 1..tables;
set of int: CHAIR = 1..chairs;
set of int: ROUND = 1..rounds;

set of int: PERSON0 = 0..people; % dummy person 0 for free chairs

array[TABLE] of TOPIC: topic; % topic of the table
array[TABLE] of ROUND: round; % round in which the table takes place

array[CHAIR] of TABLE: suite; % table to which each seat belongs
%constraint forall(t in 0..tables-1) (
    %forall(i in 1..6) (suite[t*6 + i] = t+1)); 

array[PERSON, TOPIC] of 0..1: signup;

array[PERSON] of string: name; % people's names

% assignment variables
array[CHAIR] of var PERSON0: participant;
var int: violations;

% ----- CONSTRAINTS -----

% each person should get a chair on each topic they signed up for
constraint violations = sum(p in PERSON, t in TOPIC where signup[p,t] = 1)(sum(c in CHAIR where participant[c] = p)(topic[suite[c]] = t) = 0);
%constraint forall(p in PERSON, t in TOPIC where signup[p,t] = 1)(sum(c in CHAIR where participant[c] = p)(topic[suite[c]] = t) = 1);

% a person can only join a topic once
constraint forall(p in PERSON, t in TOPIC where signup[p,t] = 1)(sum(c in CHAIR where participant[c] = p)(topic[suite[c]] = t) <= 1);

% a person can not get a chair for a topic they did not sign up for
constraint forall(p in PERSON, c in CHAIR where participant[c] = p)(signup[p, topic[suite[c]]] = 1);

% each table needs at least 3 people or no one
constraint forall(t in TABLE)(sum(c in CHAIR where suite[c] = t)(participant[c] > 0) >= 3 \/ sum(c in CHAIR where suite[c] = t)(participant[c] > 0) = 0);

% persons cannot be on tables that take place in the same round
constraint forall(p in PERSON) (not exists(c1, c2 in CHAIR where c1 < c2 /\ participant[c1] = p /\ participant[c2] = p)(round[suite[c1]] = round[suite[c2]]));

% ----- make it faster -----
constraint symmetry_breaking_constraint(lex_lesseq(participant, reverse(participant)));


solve minimize violations;