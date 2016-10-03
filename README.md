# EnergyBenchmarking-NoncompliantRecords

This work applies a methodology to improve data integrity and quality of benchmark data, applying the DataIQ tool developed for the New York City benchmark program and the 9-point Data Review developed by Washington DC’s benchmark program. Kansas City’s process merges the two tools to enable a single data integrity assessment process. The outcome of the assessment will be identification of data inaccuracies, and data cleaning and preparation for statistical analysis. Data accuracy refers to correctness of the values, such as missing or incorrect values. This is important because inaccurate data undermines statistical analyses, misrepresents the population sample, and can lead to false inferences.

The benchmark data is input into the EPA Portfolio Manager tool and digitally submitted to the city. Not all columns - such as person submitting, date, or time – need to be included in the dataset published by the City. Data required per the policy include:
•	Building id
•	Property address & contact information
•	Property type
•	GFA
•	Weather normalized Site EUI
•	Weather normalized Source EUI
•	Direct GHGs
•	Indirect GHGs
•	Indoor water use
•	Outdoor water use
•	Energy star score
•	Data accuracy

The benchmark data needs to be cleaned before being made public:
New York City’s Algorithm Adapted for Kansas City
1.	Missing address
2.	Missing or zero square footage
3.	Square footage under 10,000
4.	Missing Site Energy Use kBtu
5.	Missing Source Energy Use kBtu
6.	Missing Site Energy Use kBtu
7.	Missing Source Energy Use kBtu
8.	Missing Indoor Water Use All Water Sources kgal 
9.	Missing Outdoor Water Use All Water Sources kgal 
10.	Missing Indirect GHG Emissions Metric Tons CO2e
11.	Year Built before 1901

Washington DC’s Algorithm Adapted for Kansas City
1.	Merge files on Unique Identifier
2.	Remove duplicate entries
3.	Remove Missing or zero EUI
