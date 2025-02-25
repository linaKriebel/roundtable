include "lex_lesseq.mzn";

enum TOPICS;

int: registrations;

int: tables; % number of (physical) tables per round
int: chairs; % number of (physical) chairs per table
int: rounds;

int: roundtables = tables * rounds;
int: seats = tables * chairs * rounds;

set of int: PERSON = 1..registrations;
set of int: TABLE = 1..roundtables;
set of int: SEAT = 1..seats;
set of int: ROUND = 1..rounds;

set of int: PERSON0 = 0..registrations; % dummy person 0 for free seats

array[TABLE] of TOPICS: topic; % topic of the table
array[TABLE] of ROUND: round; % round in which the table takes place
array[SEAT] of TABLE: suite; % table to which each seat belongs
 
array[PERSON, TOPICS] of 0..1: signup;

array[PERSON] of string: name; % people's names

% assignment variables
array[SEAT] of var PERSON0: participant;
var int: violations;

% ----- CONSTRAINTS -----

% each person should get a chair on each topic they signed up for
constraint violations = sum(p in PERSON, t in TOPICS where signup[p,t] = 1)(sum(c in SEAT where participant[c] = p)(topic[suite[c]] = t) = 0);

% each person has to get a chair on each topic they signed up for -- this can not be fulfilled in most cases and makes the whole problem unsolvable
%constraint forall(p in PERSON, t in TOPIC where signup[p,t] = 1)(sum(c in SEAT where participant[c] = p)(topic[suite[c]] = t) = 1);

% a person can only join a topic once
constraint forall(p in PERSON, t in TOPICS where signup[p,t] = 1)(sum(c in SEAT where participant[c] = p)(topic[suite[c]] = t) <= 1);

% a person can not get a chair for a topic they did not sign up for
constraint forall(p in PERSON, c in SEAT where participant[c] = p)(signup[p, topic[suite[c]]] = 1);

% each table needs at least 3 people or no one
constraint forall(t in TABLE)(sum(c in SEAT where suite[c] = t)(participant[c] > 0) >= 3 \/ sum(c in SEAT where suite[c] = t)(participant[c] > 0) = 0);

% persons cannot be on tables that take place in the same round
constraint forall(p in PERSON) (not exists(c1, c2 in SEAT where c1 < c2 /\ participant[c1] = p /\ participant[c2] = p)(round[suite[c1]] = round[suite[c2]]));

% ----- make it faster -----
constraint symmetry_breaking_constraint(lex_lesseq(participant, reverse(participant)));


solve minimize violations;