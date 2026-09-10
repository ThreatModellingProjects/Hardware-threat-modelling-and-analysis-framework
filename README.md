# A threat modelling and analysis framework for hardware systems (Prolog implementation)

This repository implements the 25 derivation rules from the paper above [Published link here], in SWI-Prolog. It also has the facts in the paper's case study. This implementation shows that running it can reproduce the derivations in the case study section of the paper. 

This repository contains the following files:

- rules.pl: This contains the predicates and rules, which are defined in the paper. 
- case_study.pl - this contains the facts which are declared in the case study. 

# Instructions for verifying the paper's case study results. 
1. Download SWI-Prolog (https://www.swi-prolog.org/). 
2. Download rules.pl and case_study.pl into the same folder.
3. Open command prompt and navigate to that folder. 
4. Type in the command swipl -q -g run -t halt case_study.pl

This will output all of the derived predicates from the case study. 

# Instructions for modelling your own system using our derivation rules.
1. Create a copy of the case_study.pl file, and rename it to a file name of your choice e.g., cps_system.pl. 
2. Retain the first line for loading the rules. 
3. Change the facts to represent your own system. Ensure that you type in the parameters in lowercase. 
4. Run with the same command in command prompt: swipl -q -g run -t halt cps_system.pl.