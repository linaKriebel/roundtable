# roundtable
This is a small minizinc model to solve a simple assignment problem.

## scenario
People can sign up for three topics at a conference. Each topic will be discussed at a table that has six seats. In a round all topics are discussed at the same time. The rounds are held one after the other so that each topic will be discussed three times.

The task is to assign a number of people to the available seats of each table in each round following a few simple constraints. 

### constraints

1. A person can only be assigned to seat at a table at which a topic is discussed that they signed up for.
2. A person can not be assigned to a seat at a table at which a topic is discussed that they did not signed up for.
3. A person can only discuss a topic once.
4. A person can not sit at two or more tables that take place in the same round at once.
5. A table must have at least three participants or none.


## data format
In order to use this model you will have to enter your data in the data file following some basic rules:

- enter the number of topics, rounds and people as integer values
- enter the topic names as enum elements
- map each participant and the topics they signed up for in the signup matrix while 1 means "signed up" and 0 means "not signed up"
