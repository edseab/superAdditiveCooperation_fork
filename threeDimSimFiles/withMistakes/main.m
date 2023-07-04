/* Copyright 2023, Charles Efferson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

#import "ContGroupAgent.h"
#import "mt19937ar.h"

#import <stdio.h>
#import <stdlib.h>
#import <gsl/gsl_rng.h>
#import <gsl/gsl_randist.h>

int main(int argc, const char *argv[])  {

	gsl_rng *gen = gsl_rng_alloc(gsl_rng_mt19937);				// Allocate gsl_rng version of Mersenne twister.
	gsl_rng_set(gen,(unsigned)time(NULL));						// Seed gsl_rng version of Mersenne twister.
	init_genrand((unsigned)time(NULL));							// Seed standard Mersenne Twister.
	
	// Acquire or specify needed parameters for the simulations.
	int numAgents = 960;	
	int numGroups = 40; 										// Implies 40 groups of 24 each.
	int numGenerations = atoi(argv[1]);
	int numSims= atoi(argv[2]);
	
	double efficiencyFactor = atof(argv[3]);
	double exogenousFitness = atof(argv[4]);
	double weightEndoFitness = atof(argv[5]);
	double probInteractionIn = 1.0;
	int numInteractionsIn = atoi(argv[6]);
	double probInteractionOut = atof(argv[7]);
	int numInteractionsOut = 1;
	
	int groupConflictPossible = atoi(argv[8]);
	double controlConflictProb = atof(argv[9]);
	double conflictSensitivity = atof(argv[10]);
	int numGroupsMigrate = atoi(argv[11]); 						// The number of groups that move around per generation.  Must be even.  Controls cancellation effects at the group level.
	
	double probMutate = atof(argv[12]);
	double mutLatStepInitTransfer = 0.025;						// Mutations occur on a lattice to avoid truncation at the boundaries.  The lattice step with respect to initial transfer values.
	double mutLatStepIntercepts = 0.025;						// Mutations occur on a lattice to avoid truncation at the boundaries.  The lattice step with respect to the left and right intercepts for the response function.  
	int numAgentsMigratePerGroup = atoi(argv[13]);
	
	double probRecordDiffBtwnGroups = 0.0005;					// Probabilistic recording of differences (e.g. total fitness values) between paired groups.
	int printDisaggFinalPeriodSim = 1;
	int printAggOutput = 1; 
	int initCond = atoi(argv[14]); 								// 1 is allSelfishMin, 2 is allRandom, and 3 is allPerfRecMax. 
	int gameSelectionCoupled = atoi(argv[15]); 					// 1 means migration immediately precedes game play.  0 means migration immediately follows game play.
	
	// Various indices used for looping, etc.
	int i;					// Indexing for simulations.
	int j;					// Indexing for groups.
	int k;					// Indexing for agents within a group.
	int kPrime; 			// Indexing used for selection/reproduction linear search algorithm.
	int m;					// Indexing for algorithm managing the migration of agents in the metapopulation.
	int cFromGroup; 		// To record the group ID for group that wins a competition.  Used in the algorithm to replace agents in the losing group.
	int t;					// Indexing for generations.
	
	// Arrays used for recording migrants, groups, cumulative fitness distributions, etc.
	int numAgentsInGroup = numAgents / numGroups; 					// For indexing agents within each group.
	int indicesAgents[numGroups][numAgentsInGroup]; 				// For recording random permutations of the agent ID values, where permutations are performed separately for each group.
	int migrants[numGroups][numAgentsMigratePerGroup]; 				// For recording which agents migrate.
	int tempIndicesAgents[numAgentsInGroup];						// A temporary array for recording permutations of agents.  Used in various algorithms.
	int tempIndicesMigrants[numGroups * numAgentsMigratePerGroup]; 	// A temporary arrary for randomly shuffling migrants before redistributing them into the groups in the metapopulation.
	
	int indicesGroups[numGroups]; 									// For recording permutations of the groups for pairing groups.  
	int tempIndicesGroups[numGroups]; 								// For managing the group movement algorithm as groups move around and pair up in potentially new ways in the metapopulation.
	int migGroups[numGroupsMigrate];								// For sampling and shuffling groups to move around in the metapopulation.
	int tempMigGroups[numGroupsMigrate];							// A temporary array for the group movement algorithm.  
	
	double groupSumFitness[numGroups];								// For controlling inter-group competition and competition/selection within groups.  Specifically used to construct cumulative distributions of fitness values within each group.
	double groupRunningSum[numGroups];								// For constructing cumulative distributions of fitness values within each group.	
	int groupWinsConflict[numGroups];								// Variable with values from {0,1} for recording if group wins conflict.
	double tempRanNumUpdating;										// A temporary value for algorithm controlling competition/selection withing groups.
	
	
	// Maximum possible difference in aggregate payoffs between two groups.  Used to normalize differences in aggregate fitness values between paired groups.
	// One group has to be unconditionally selfish with in-group and unconditionally generous with out-group, while the other group has to be the opposite.  All individuals have to have both in-group and out-group interactions.
	double maxDiffGroupPayoffs = weightEndoFitness * ((double) numAgentsInGroup) * ((double) numInteractionsIn * (efficiencyFactor - (double) 1.0) + (double) numInteractionsOut * ((double) 1.0 + efficiencyFactor)); 
	
	
	// Sets parameter to nonsense value when inter-group competition is not possible.  This is just a computationally redundant safeguard.
	if (groupConflictPossible == 0)
	{	
		controlConflictProb = (double) -99.0;
	}
	
	
	// Initialize aggregate quantities for recording population dynamics.
	double meanInitTransferIn;						
	double meanIntLeftIn;
	double meanIntRightIn;
	double varInitTransferIn;
	double varIntLeftIn;
	double varIntRightIn;
	
	double meanInitTransferOut;						
	double meanIntLeftOut;
	double meanIntRightOut;
	double varInitTransferOut;
	double varIntLeftOut;
	double varIntRightOut;
	
	double meanFitness;								// Calculated with respect to the total fitness (exo + endo) for each agent in a generation.
	double varFitness;	
	
	double meanByGroupInitTransferIn[numGroups];	// Mean initTransferIn for each group.
	double varByGroupInitTransferIn[numGroups];		// Variance initTransferIn for each group.
	double varWithinInitTransferIn;					// Variance in initTransferIn within groups.
	double varBtwnInitTransferIn;					// Variance in initTransferIn between groups.
	double meanByGroupIntLeftIn[numGroups];			// Repeat logic for intercepts for ingroup response functions.
	double varByGroupIntLeftIn[numGroups];
	double varWithinIntLeftIn;
	double varBtwnIntLeftIn;
	double meanByGroupIntRightIn[numGroups];	
	double varByGroupIntRightIn[numGroups];
	double varWithinIntRightIn;
	double varBtwnIntRightIn;
	
	double meanByGroupInitTransferOut[numGroups];	// Mean initTransferOut for each group.
	double varByGroupInitTransferOut[numGroups];	// Variance initTransferOut for each group.
	double varWithinInitTransferOut;				// Variance in initTransferOut within groups.
	double varBtwnInitTransferOut;					// Variance in initTransferOut between groups.
	double meanByGroupIntLeftOut[numGroups];		// Repeat logic for intercepts for outgroup response functions.
	double varByGroupIntLeftOut[numGroups];
	double varWithinIntLeftOut;
	double varBtwnIntLeftOut;
	double meanByGroupIntRightOut[numGroups];	
	double varByGroupIntRightOut[numGroups];
	double varWithinIntRightOut;
	double varBtwnIntRightOut;
	
	double meanByGroupFitness[numGroups];			// Mean fitness for each group.
	double varByGroupFitness[numGroups];			// Variance fitness for each group.
	double varWithinFitness;						// Repeat variance partition logic.
	double varBtwnFitness;
	
	double stdDev = atof(argv[16]);		// std deviation for error distribution

	// Output file for disaggregated data for the final period/generation of each simulation.
	FILE *disaggFinalPeriodSim = fopen(argv[17],"w"); 
	if (printDisaggFinalPeriodSim == 1)
	{
		fprintf(disaggFinalPeriodSim,"sim	gen	agent	group	initTransferIn	intLeftIn	intRightIn	partnerIn	partnerInitTransferIn	partnerIntLeftIn	partnerIntRightIn	firstMoverIn	interactIn	numInteractionsIn	initTransferOut	intLeftOut	intRightOut	outGroup	partnerOut	partnerInitTransferOut	partnerIntLeftOut	partnerIntRightOut	firstMoverOut	interactOut	numInteractionsOut	fitnessIn	fitnessOut	fitness	fitnessAsCumProp	groupWinsConflict\n");
	}
	
	// Output file for aggregated data, recorded periodically, e.g. every 100 generations.
	FILE *aggPeriodic = fopen(argv[18],"w");
	if (printAggOutput == 1)
	{
		fprintf(aggPeriodic,"sim	gen	meanInitTransferIn	meanIntLeftIn	meanIntRightIn	varInitTransferIn	varIntLeftIn	varIntRightIn	varWithinInitTransferIn	varWithinIntLeftIn	varWithinIntRightIn	varBtwnInitTransferIn	varBtwnIntLeftIn	varBtwnIntRightIn	meanInitTransferOut	meanIntLeftOut	meanIntRightOut	varInitTransferOut	varIntLeftOut	varIntRightOut	varWithinInitTransferOut	varWithinIntLeftOut	varWithinIntRightOut	varBtwnInitTransferOut	varBtwnIntLeftOut	varBtwnIntRightOut	meanFitness	varFitness	varWithinFitness	varBtwnFitness\n");
	}
	
	// Output file to record the differences btwn pairs of groups.
	FILE *diffBetweenGroups = fopen(argv[19],"w"); 
	fprintf(diffBetweenGroups,"sim gen firstGroup	secondGroup	diffTotalResources	maxDiffGroupPayoffs	conflictOccurs\n");
	
	// Initialize agents and set a few key quantities that never change.
	ContGroupAgent *agent[numGroups][numAgentsInGroup];
	for (j = 0; j < numGroups; j++)
	{
		for (k = 0; k < numAgentsInGroup; k++)
		{
			agent[j][k] = [[ContGroupAgent alloc] init];
			[agent[j][k] setGroup: j];
			[agent[j][k] setExoFitness: exogenousFitness];
			[agent[j][k] setWeightEndoFitness: weightEndoFitness];
			[agent[j][k] setEfficiencyFactor: efficiencyFactor];
			[agent[j][k] setProbMutate: probMutate];
			[agent[j][k] setMutLatStepInitTransfer: mutLatStepInitTransfer];
			[agent[j][k] setMutLatStepIntercepts: mutLatStepIntercepts];
			[agent[j][k] setStdDev: stdDev];
		}
	}
	
	
	// Initialize migrantAgents, which is an array of objects used in the algorithm for the migration of agents in the metapopulation.
	ContGroupAgent *migrantAgents[numGroups * numAgentsMigratePerGroup];
	for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
	{
		migrantAgents[m] = [[ContGroupAgent alloc] init];
	}
	
	// Core simulation.
	for (i = 0; i < numSims; i++) // loop over simulations.
	{
		for (j = 0; j < numGroups; j++) // loop over groups to initialize simulation.
		{
			// For pairing groups for competition and out-group interactions and for managing group movement.  Initialize by recording group ID values in the corresponding locations in indicesGroups and tempIndicesGroups, a state that will not persist with indicesGroups as groups move.
			indicesGroups[j] = j;
			tempIndicesGroups[j] = j;
			
			// For the algorithm for group movement.
			if (j < numGroupsMigrate)
			{
				migGroups[j] = -99; 	// Nonsense values.  Populated with real values in the algorithm below.
				tempMigGroups[j] = -99; 	// Nonsense values.  Populated with real values in the algorithm below.
			}
			
			// Loop over agents within group to initialize phenotypes based on the initial conditions for the simulation.
			for (k = 0; k < numAgentsInGroup; k++)
			{
				if (initCond == 1)
				{
					[agent[j][k] setInitTransferIn: 0.0];
					[agent[j][k] setIntLeftIn: 0.0];
					[agent[j][k] setIntRightIn: 0.0];
					[agent[j][k] setInitTransferOut: 0.0];
					[agent[j][k] setIntLeftOut: 0.0];
					[agent[j][k] setIntRightOut: 0.0];
				}
				else if (initCond == 2)
				{
					[agent[j][k] assignRandomInitTransferIn];
					[agent[j][k] assignRandomInterceptsIn];
					[agent[j][k] assignRandomInitTransferOut];
					[agent[j][k] assignRandomInterceptsOut];
				}
				else if (initCond == 3)
				{
					[agent[j][k] setInitTransferIn: 1.0];
					[agent[j][k] setIntLeftIn: 0.0];
					[agent[j][k] setIntRightIn: 1.0];
					[agent[j][k] setInitTransferOut: 1.0];
					[agent[j][k] setIntLeftOut: 0.0];
					[agent[j][k] setIntRightOut: 1.0];
				}
				else
				{
					printf("You have a problem with the initial conditions.\n");
				}
					
				[agent[j][k] setMigrate: 0]; 				// This initializes only for t = 0.  The same initialization occurs at the beginning of every generation.  See below just insides t > 0 condition.
				[agent[j][k] setGroupMigrateFrom: -99];		// This initializes only for t = 0.  The same initialization occurs at the beginning of every generation.  See below just insides t > 0 condition.
				[agent[j][k] setGroupMigrateTo: -99];		// This initializes only for t = 0.  The same initialization occurs at the beginning of every generation.  See below just insides t > 0 condition.
			} // Close loop over agents.
		} // Close loop over groups.
		
		
		// Initialize temp array with agent ID values.
		for (k = 0; k < numAgentsInGroup; k++)
		{
			tempIndicesAgents[k] = k;
		}
				
		// Initialize temp array for migration of agents.
		for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
		{
			tempIndicesMigrants[m] = m;
		}
		
		
		// loop over generations.
		for (t = 0; t < numGenerations; t++)
		{
			cFromGroup = -1; // Initialize with value that will create an error if used without changing.
			
			if (t > 0)
			{
				// Begin new generation by updating strategies from temp* values and adding mutations to these strategies as inherited/transmitted at the end of the previous generation.  In effect, this finalizes reproduction, and this is why we treat this as the beginning of a new generation.
				for (j = 0; j < numGroups; j++)
				{
					for (k = 0; k < numAgentsInGroup; k++)
					{
						[agent[j][k] updatePhenotypeFromTempIn]; 	// Updating from temp for reproduction.
						[agent[j][k] updatePhenotypeFromTempOut]; 	// Updating from temp for reproduction.
						[agent[j][k] implementMutationsIn];			// Add mutations to ingroup strategies.
						[agent[j][k] implementMutationsOut];		// Add mutations to outgroup strategies.
						[agent[j][k] setMigrate:0];					// Re-initialize quantities that record agent migration.
						[agent[j][k] setGroupMigrateFrom: -99];
						[agent[j][k] setGroupMigrateTo: -99];
						
						[agent[j][k] setTempFitnessIn: 0.0];		// Re-initialize temp fitness values.
						[agent[j][k] setTempFitnessOut: 0.0];
						[agent[j][k] setTempFitness: 0.0];
					}
					
					// For the algorithm for group movement.
					if (j < numGroupsMigrate)
					{
						migGroups[j] = -99; 		// Nonsense values.  Populated with real values in the algorithm below.
						tempMigGroups[j] = -99; 	// Nonsense values.  Populated with real values in the algorithm below.
					}
				}  // At this point, a new generation is in place, but nothing has happened.
				
				
				// Group movement in the metapopulation.
				if (numGroupsMigrate > 0)
				{
					gsl_ran_choose(gen,tempMigGroups,numGroupsMigrate,tempIndicesGroups,numGroups,sizeof(int)); // Sample numGroupsMigrate values w/o replacement from tempIndicesGroups, assign to tempMigGroups.  Sampled values are locations in indicesGroups, where group IDs for groups that move are recorded.
					for (j = 0; j < numGroupsMigrate; j++)
					{
						migGroups[j] = indicesGroups[tempMigGroups[j]]; // Record the group ID from position tempMigGroups[j] of indicesGroups to position j of migGroups
					}
					gsl_ran_shuffle(gen,migGroups,numGroupsMigrate,sizeof(int)); // Shuffle migGroups before redistributing these specific group ID values in the metapopulation.
					for (j = 0; j < numGroupsMigrate; j++)
					{
						indicesGroups[tempMigGroups[j]] = migGroups[j]; // Record the group ID from position j of shuffled migGroups to position tempMigGroups[j] of indicesGroups, i.e. redistribute the specific groups sampled to move in the metapopulation.
					}
				}
				
				
				// Migration immediately precedes game play.
 				if (gameSelectionCoupled == 1)
				{
					// Migration algorithm.
					if (numAgentsMigratePerGroup > 0)
					{
						// Determine who enters the migrant pool by group ID.
						for (j = 0; j < numGroups; j++)
						{
							gsl_ran_shuffle(gen,tempIndicesAgents,numAgentsInGroup,sizeof(int));
							for (k = 0; k < numAgentsMigratePerGroup; k++)
							{
								migrants[j][k] = tempIndicesAgents[k]; // Specify and record locations with respect to the k dimension of the array agent for those who migrate in group j.
							}
						}
					
						for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
						{
							[migrantAgents[m] setInitTransferIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] initTransferIn]];
							[migrantAgents[m] setIntLeftIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intLeftIn]];
							[migrantAgents[m] setIntRightIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intRightIn]];
							[migrantAgents[m] setInitTransferOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] initTransferOut]];
							[migrantAgents[m] setIntLeftOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intLeftOut]];
							[migrantAgents[m] setIntRightOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intRightOut]];
							[migrantAgents[m] setGroup: (m / numAgentsMigratePerGroup)]; // Notice that group in this case refers to the group the focal agent just left to enter the migrant pool.
						}
					
						// Randomly redistribute migrants in the migrant pool back into groups in the metapopulation. 
						gsl_ran_shuffle(gen,tempIndicesMigrants,numGroups * numAgentsMigratePerGroup,sizeof(int));
						for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
						{
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempInitTransferIn: [migrantAgents[tempIndicesMigrants[m]] initTransferIn]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntLeftIn: [migrantAgents[tempIndicesMigrants[m]] intLeftIn]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntRightIn: [migrantAgents[tempIndicesMigrants[m]] intRightIn]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempInitTransferOut: [migrantAgents[tempIndicesMigrants[m]] initTransferOut]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntLeftOut: [migrantAgents[tempIndicesMigrants[m]] intLeftOut]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntRightOut: [migrantAgents[tempIndicesMigrants[m]] intRightOut]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setMigrate: 1];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setGroupMigrateFrom: [migrantAgents[tempIndicesMigrants[m]] group]];
							[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setGroupMigrateTo: (m / numAgentsMigratePerGroup)];						
						}
					
						// Complete migration algorithm.
						for (j = 0; j < numGroups; j++)
						{
							for (k = 0; k < numAgentsMigratePerGroup; k++)
							{
								[agent[j][migrants[j][k]] updatePhenotypeFromTempIn]; // Updating from temp to complete migration.
								[agent[j][migrants[j][k]] updatePhenotypeFromTempOut]; // Updating from temp to complete migration.
							}
						}
					}
				} // Close (gameSelectionCoupled == 1) condition.
			} // Close (t > 0) condition.
			
			
			// Out-group interactions.  Only runs if such interactions might actually occur.			
			if (probInteractionOut > 0.0)
			{
				// Permute indicesAgents for each group.  Permutations used for out-group pairings, i.e. agent ID at position k of indicesAgents in one group will be matched with agent ID in position k in the paired group. 
				for (j = 0; j < numGroups; j++)
				{
					gsl_ran_shuffle(gen,tempIndicesAgents,numAgentsInGroup,sizeof(int));
					for (k = 0; k < numAgentsInGroup; k++)
					{
						indicesAgents[j][k] = tempIndicesAgents[k];
					}
				}
			
				// Matching for out-group game play.
				for (j = 0; j < numGroups; j++)
				{
					for (k = 0; k < numAgentsInGroup; k++)
					{
						// Specific pairings for out-group game play.  Determine if out-group game play actually happens for each inter-group pair.
						if (j % 2 == 0)
						{
							if (((double) 1.0 - genrand_real2()) <= 0.5) // Determine which is first mover.
							{
								[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setFirstMoverOut: 1];
							}
							else
							{
								[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setFirstMoverOut: 0];
							}
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setOutGroup: indicesGroups[j+1]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerOut: indicesAgents[indicesGroups[j+1]][k]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerInitTransferOut: [agent[indicesGroups[j+1]][indicesAgents[indicesGroups[j+1]][k]] initTransferOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerIntLeftOut: [agent[indicesGroups[j+1]][indicesAgents[indicesGroups[j+1]][k]] intLeftOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerIntRightOut: [agent[indicesGroups[j+1]][indicesAgents[indicesGroups[j+1]][k]] intRightOut]];
							if (((double) 1.0 - genrand_real2()) <= probInteractionOut)
							{
								[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setInteractOut: 1];
								[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setNumInteractionsOut: numInteractionsOut];
							}
							else
							{
								[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setInteractOut: 0];
								[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setNumInteractionsOut: 0];
							}
						}
						else
						{
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setFirstMoverOut: (int) 1 - [agent[indicesGroups[j-1]][indicesAgents[indicesGroups[j-1]][k]] firstMoverOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setOutGroup: indicesGroups[j-1]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerOut: indicesAgents[indicesGroups[j-1]][k]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerInitTransferOut: [agent[indicesGroups[j-1]][indicesAgents[indicesGroups[j-1]][k]] initTransferOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerIntLeftOut: [agent[indicesGroups[j-1]][indicesAgents[indicesGroups[j-1]][k]] intLeftOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setPartnerIntRightOut: [agent[indicesGroups[j-1]][indicesAgents[indicesGroups[j-1]][k]] intRightOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setInteractOut: [agent[indicesGroups[j-1]][indicesAgents[indicesGroups[j-1]][k]] interactOut]];
							[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] setNumInteractionsOut: [agent[indicesGroups[j-1]][indicesAgents[indicesGroups[j-1]][k]] numInteractionsOut]];
						
						}
					}
				} // Close matching for out-group play.
			} // Close (probInteractionOut > 0.0) condition.
			
			
			// Outgroup fitness calculations are here, which allows us to copy fitness values from focal to partner before overwriting indicesAgents.  Outgroup game play with errors is embedded in the relevant method.
			if (probInteractionOut > 0.0 && probInteractionOut <= 1.0)
			{
				for (j = 0; j < (numGroups - 1); j = j + 2)
				{
					for (k = 0; k < numAgentsInGroup; k++)
					{
						[agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] calculateFitnessOut: gen]; // Use focal agent in group indicesGroups[j] to calculate fitness values for both agents in the outgroup pair => ensures errors are the same for both.
						[agent[indicesGroups[j+1]][indicesAgents[indicesGroups[j+1]][k]] setFitnessOut: [agent[indicesGroups[j]][indicesAgents[indicesGroups[j]][k]] partnerFitnessOut]]; // Copy the outgroup fitness for the focal agent's partner in indicesGroups[j+1] from focal agent to the focal agent's partner.
					}
				}
			}
			else if (probInteractionOut <= 0.0)
			{
				for (j = 0; j < (numGroups - 1); j = j + 2)
				{
					for (k = 0; k < numAgentsInGroup; k++)
					{
						[agent[j][k] setFitnessOut: 0.0];
						[agent[j+1][k] setFitnessOut: 0.0];
					}
				}
			}
			else
			{
				printf("You have a problem with outgroup fitness calculations, specifically probInteractionOut.\n");
			}
			
			
			// Permute indicesAgents again, separately for each group, to assign in-group pairings.  This ensures in-group pairings are independent of out-group pairings.
			for (j = 0; j < numGroups; j++)
			{
				gsl_ran_shuffle(gen,tempIndicesAgents,numAgentsInGroup,sizeof(int));
				for (k = 0; k < numAgentsInGroup; k++)
				{
					indicesAgents[j][k] = tempIndicesAgents[k];
				}
			}		
			
			
			// Matching for in-group game play.
			for (j = 0; j < numGroups; j++)
			{
				for (k = 0; k < numAgentsInGroup; k++)
				{	
					// Specific pairings for in-group game play.  Determine if in-group game play actually happens for each inter-group pair.  If so, set the associated number of (repeated) interactions.			
					if (k % 2 == 0)
					{
						[agent[j][indicesAgents[j][k]] setFirstMoverIn: 1];
						[agent[j][indicesAgents[j][k]] setPartnerIn: indicesAgents[j][k+1]];
						[agent[j][indicesAgents[j][k]] setPartnerInitTransferIn: [agent[j][indicesAgents[j][k+1]] initTransferIn]];
						[agent[j][indicesAgents[j][k]] setPartnerIntLeftIn: [agent[j][indicesAgents[j][k+1]] intLeftIn]];
						[agent[j][indicesAgents[j][k]] setPartnerIntRightIn: [agent[j][indicesAgents[j][k+1]] intRightIn]];
						if (((double) 1.0 - genrand_real2()) <= probInteractionIn)
						{
							[agent[j][indicesAgents[j][k]] setInteractIn: 1];
							[agent[j][indicesAgents[j][k]] setNumInteractionsIn: numInteractionsIn];
						}
						else
						{
							[agent[j][indicesAgents[j][k]] setInteractIn: 0];
							[agent[j][indicesAgents[j][k]] setNumInteractionsIn: 0];
						}
					}
					else 
					{
						[agent[j][indicesAgents[j][k]] setFirstMoverIn: 0];
						[agent[j][indicesAgents[j][k]] setPartnerIn: indicesAgents[j][k-1]];
						[agent[j][indicesAgents[j][k]] setPartnerInitTransferIn: [agent[j][indicesAgents[j][k-1]] initTransferIn]];
						[agent[j][indicesAgents[j][k]] setPartnerIntLeftIn: [agent[j][indicesAgents[j][k-1]] intLeftIn]];
						[agent[j][indicesAgents[j][k]] setPartnerIntRightIn: [agent[j][indicesAgents[j][k-1]] intRightIn]];
						[agent[j][indicesAgents[j][k]] setInteractIn: [agent[j][indicesAgents[j][k-1]] interactIn]];
						[agent[j][indicesAgents[j][k]] setNumInteractionsIn: [agent[j][indicesAgents[j][k-1]] numInteractionsIn]];
					}
				}
			} // Close matching for in-group game play.
			

			// Calculate fitness for ingroup interactions for both focal and partner, then copy from focal to partner => ensures same sequences of errors for both players in an interacting pair.  Ingroup game play with errors is embedded in the relevant method.
			for (j = 0; j < numGroups; j++)
			{
				for (k = 0; k < (numAgentsInGroup - 1); k = k + 2)
				{
					[agent[j][indicesAgents[j][k]] calculateFitnessIn: gen]; // Calculate ingroup fitness for both focal agent at indicesAgents[j][k] and focal agent's partner at indicesAgents[j][k+1]
					[agent[j][indicesAgents[j][k+1]] setFitnessIn: [agent[j][indicesAgents[j][k]] partnerFitnessIn]]; // Copy fitness from focal to focal's partner
					
					[agent[j][indicesAgents[j][k]] calculateFitness]; // Add up all fitness components (i.e. exogenous + ingroup + outgroup) for focal agent
					[agent[j][indicesAgents[j][k+1]] calculateFitness]; // Add up all fitness components (i.e. exogenous + ingroup + outgroup) for focal agent's partner
				}
			}
			
			
			// // Migration immediately follows game play.  Agents carry fitness values with them b/c they have already played the game(s) with in-group and (potentially) out-group partners.
			if (gameSelectionCoupled == 0)
			{
				// Migration algorithm.
				if (numAgentsMigratePerGroup > 0)
				{
					// Determine who enters the migrant pool by group ID.
					for (j = 0; j < numGroups; j++)
					{
						gsl_ran_shuffle(gen,tempIndicesAgents,numAgentsInGroup,sizeof(int));
						for (k = 0; k < numAgentsMigratePerGroup; k++)
						{
							migrants[j][k] = tempIndicesAgents[k]; // Specify and record locations with respect to the k dimension of the array agent for those who migrate in group j.
						}
					}
					
					for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
					{
						[migrantAgents[m] setInitTransferIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] initTransferIn]];
						[migrantAgents[m] setIntLeftIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intLeftIn]];
						[migrantAgents[m] setIntRightIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intRightIn]];
						[migrantAgents[m] setInitTransferOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] initTransferOut]];
						[migrantAgents[m] setIntLeftOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intLeftOut]];
						[migrantAgents[m] setIntRightOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] intRightOut]];
						[migrantAgents[m] setFitnessIn: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] fitnessIn]];
						[migrantAgents[m] setFitnessOut: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] fitnessOut]];
						[migrantAgents[m] setFitness: [agent[(m / numAgentsMigratePerGroup)][migrants[m / numAgentsMigratePerGroup][m % numAgentsMigratePerGroup]] fitness]];
						[migrantAgents[m] setGroup: (m / numAgentsMigratePerGroup)]; // Notice that group in this case refers to the group the focal agent just left to enter the migrant pool.
					}
					
					// Randomly redistribute migrants in the migrant pool back into groups in the metapopulation.
					gsl_ran_shuffle(gen,tempIndicesMigrants,numGroups * numAgentsMigratePerGroup,sizeof(int));
					for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
					{
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempInitTransferIn: [migrantAgents[tempIndicesMigrants[m]] initTransferIn]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntLeftIn: [migrantAgents[tempIndicesMigrants[m]] intLeftIn]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntRightIn: [migrantAgents[tempIndicesMigrants[m]] intRightIn]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempInitTransferOut: [migrantAgents[tempIndicesMigrants[m]] initTransferOut]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntLeftOut: [migrantAgents[tempIndicesMigrants[m]] intLeftOut]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempIntRightOut: [migrantAgents[tempIndicesMigrants[m]] intRightOut]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempFitnessIn: [migrantAgents[tempIndicesMigrants[m]] fitnessIn]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempFitnessOut: [migrantAgents[tempIndicesMigrants[m]] fitnessOut]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setTempFitness: [migrantAgents[tempIndicesMigrants[m]] fitness]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setMigrate: 1];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setGroupMigrateFrom: [migrantAgents[tempIndicesMigrants[m]] group]];
						[agent[(m / numAgentsMigratePerGroup)][migrants[(m / numAgentsMigratePerGroup)][m % numAgentsMigratePerGroup]] setGroupMigrateTo: (m / numAgentsMigratePerGroup)];						
					}
					
					// Complete migration algorithm.
					for (j = 0; j < numGroups; j++)
					{
						for (k = 0; k < numAgentsMigratePerGroup; k++)
						{
							[agent[j][migrants[j][k]] updatePhenotypeFromTempIn]; // Updating from temp to complete migration.
							[agent[j][migrants[j][k]] updatePhenotypeFromTempOut]; // Updating from temp to complete migration.
							[agent[j][migrants[j][k]] updateFitnessValuesFromTemp]; // Updating from temp to complete migration.
						}
					}
				}
			} // Close (gameSelectionCoupled == 0) condition.
			
			
			// Calculate total fitness over all individuals in a group.
			for (j = 0; j < numGroups; j++)
			{
				groupSumFitness[j] = 0.0;
				
				for (k = 0; k < numAgentsInGroup; k++)
				{
					groupSumFitness[j] += [agent[j][k] fitness];
				}
			}
			
			
			// Calculating fitness values as a cumulative proportion of the sum over all fitness values in the group.
			for (j = 0; j < numGroups; j++)
			{
				groupRunningSum[j] = [agent[j][0] fitness];
				[agent[j][0] setFitnessAsCumProp: groupRunningSum[j] / groupSumFitness[j]];
				for (k = 1; k < numAgentsInGroup; k++)
				{
					groupRunningSum[j] += [agent[j][k] fitness];
					[agent[j][k] setFitnessAsCumProp: groupRunningSum[j] / groupSumFitness[j]];
				}
			}
			

			// Inter-group competition.
			for (j = 0; j < numGroups; j = j + 2)
			{					
				if (((double) 1.0 - genrand_real2()) <= fabs((groupSumFitness[indicesGroups[j]] - groupSumFitness[indicesGroups[j+1]]) / maxDiffGroupPayoffs) / (controlConflictProb + fabs((groupSumFitness[indicesGroups[j]] - groupSumFitness[indicesGroups[j+1]]) / maxDiffGroupPayoffs)) && groupConflictPossible == 1) // Group competition occurs.
				{
					if (((double) 1.0 - genrand_real2()) <= probRecordDiffBtwnGroups)
					{
						fprintf(diffBetweenGroups,"%i	%i	%i	%i	%f	%f	%i\n", i, t, indicesGroups[j], indicesGroups[j+1], groupSumFitness[indicesGroups[j]] - groupSumFitness[indicesGroups[j+1]], maxDiffGroupPayoffs, 1);
					}
					
					if (((double) 1.0 - genrand_real2()) <= (double) 1.0 / ((double) 1.0 + exp((conflictSensitivity / maxDiffGroupPayoffs) * (groupSumFitness[indicesGroups[j+1]] - groupSumFitness[indicesGroups[j]])))) // Focal group (i.e. indicesGroups[j]) wins competition, and paired group loses.
					{
						groupWinsConflict[indicesGroups[j]] = 1;
						groupWinsConflict[indicesGroups[j+1]] = 0;
					}
					else // Focal group loses competition, and paired group wins.
					{
						groupWinsConflict[indicesGroups[j]] = 0;
						groupWinsConflict[indicesGroups[j+1]] = 1;
					}
				}
				else // Group competition does not occur.
				{
					if (((double) 1.0 - genrand_real2()) <= probRecordDiffBtwnGroups)
					{
						fprintf(diffBetweenGroups,"%i	%i	%i	%i	%f	%f	%i\n", i, t, indicesGroups[j], indicesGroups[j+1], groupSumFitness[indicesGroups[j]] - groupSumFitness[indicesGroups[j+1]], maxDiffGroupPayoffs, 0);
					}
					
					// There is no competition here, but we use these dummy variables later to control intra-demic updating.  Thus, we set them to 1.
					groupWinsConflict[indicesGroups[j]] = 1;
					groupWinsConflict[indicesGroups[j+1]] = 1;
				}
			} // Close inter-group competition.  Consequences not realized yet.  First, we record data => we record data before any reproduction occurs, whether reproduction to replace a vacant territory lost in an inter-group competition or reproduction within a group that did NOT lose an inter-group competition.
			
					
			
			// This records agent-level data in the final simulated period.
			if (printDisaggFinalPeriodSim == 1 && t == (numGenerations - 1))
			{
				for (j = 0; j < numGroups; j++)
				{
					for (k = 0; k < numAgentsInGroup; k++)
					{
						fprintf(disaggFinalPeriodSim,"%i	%i	%i	%i	%f	%f	%f	%i	%f	%f	%f	%i	%i	%i	%f	%f	%f	%i	%i	%f	%f	%f	%i	%i	%i	%f	%f	%f	%f	%i\n", i, t, k, j, [agent[j][k] initTransferIn], [agent[j][k] intLeftIn], [agent[j][k] intRightIn], [agent[j][k] partnerIn], [agent[j][k] partnerInitTransferIn], [agent[j][k] partnerIntLeftIn], [agent[j][k] partnerIntRightIn], [agent[j][k] firstMoverIn], [agent[j][k] interactIn], [agent[j][k] numInteractionsIn], [agent[j][k] initTransferOut], [agent[j][k] intLeftOut], [agent[j][k] intRightOut], [agent[j][k] outGroup], [agent[j][k] partnerOut], [agent[j][k] partnerInitTransferOut], [agent[j][k] partnerIntLeftOut], [agent[j][k] partnerIntRightOut], [agent[j][k] firstMoverOut], [agent[j][k] interactOut], [agent[j][k] numInteractionsOut], [agent[j][k] fitnessIn], [agent[j][k] fitnessOut], [agent[j][k] fitness], [agent[j][k] fitnessAsCumProp], groupWinsConflict[j]);
					}
				}
			}
			
			
			// This records aggregate-level data at regular intervals in time.
			if (printAggOutput == 1 && t % 100 == 0)
			{
				meanInitTransferIn = 0.0;
				meanIntLeftIn = 0.0;
				meanIntRightIn = 0.0;
				varInitTransferIn = 0.0;
				varIntLeftIn = 0.0;
				varIntRightIn = 0.0;
				
				meanInitTransferOut = 0.0;
				meanIntLeftOut = 0.0;
				meanIntRightOut = 0.0;
				varInitTransferOut = 0.0;
				varIntLeftOut = 0.0;
				varIntRightOut = 0.0;
				
				varWithinInitTransferIn = 0.0;
				varBtwnInitTransferIn = 0.0;	
				varWithinIntLeftIn = 0.0;
				varBtwnIntLeftIn = 0.0;	
				varWithinIntRightIn = 0.0;
				varBtwnIntRightIn = 0.0;
	
				varWithinInitTransferOut = 0.0;
				varBtwnInitTransferOut = 0.0;	
				varWithinIntLeftOut = 0.0;
				varBtwnIntLeftOut = 0.0;	
				varWithinIntRightOut = 0.0;
				varBtwnIntRightOut = 0.0;
	
				meanFitness = 0.0;
				varFitness = 0.0;								
				varWithinFitness = 0.0;
				varBtwnFitness = 0.0;
				
				for (j = 0; j < numGroups; j++)
				{
					meanByGroupInitTransferIn[j] = 0.0;
					varByGroupInitTransferIn[j] = 0.0;
					meanByGroupIntLeftIn[j] = 0.0;
					varByGroupIntLeftIn[j] = 0.0;
					meanByGroupIntRightIn[j] = 0.0;
					varByGroupIntRightIn[j] = 0.0;
					meanByGroupInitTransferOut[j] = 0.0;
					varByGroupInitTransferOut[j] = 0.0;
					meanByGroupIntLeftOut[j] = 0.0;
					varByGroupIntLeftOut[j] = 0.0;
					meanByGroupIntRightOut[j] = 0.0;
					varByGroupIntRightOut[j] = 0.0;
					meanByGroupFitness[j] = 0.0;
					varByGroupFitness[j] = 0.0;
					for (k = 0; k < numAgentsInGroup; k++)
					{
						meanInitTransferIn += [agent[j][k] initTransferIn];
						meanByGroupInitTransferIn[j] += [agent[j][k] initTransferIn];
						meanIntLeftIn += [agent[j][k] intLeftIn];
						meanByGroupIntLeftIn[j] += [agent[j][k] intLeftIn];
						meanIntRightIn += [agent[j][k] intRightIn];
						meanByGroupIntRightIn[j] += [agent[j][k] intRightIn];
						varInitTransferIn += pow([agent[j][k] initTransferIn],2);
						varByGroupInitTransferIn[j] += pow([agent[j][k] initTransferIn],2);
						varIntLeftIn += pow([agent[j][k] intLeftIn],2);
						varByGroupIntLeftIn[j] += pow([agent[j][k] intLeftIn],2);
						varIntRightIn += pow([agent[j][k] intRightIn],2);
						varByGroupIntRightIn[j] += pow([agent[j][k] intRightIn],2);
						
						meanInitTransferOut += [agent[j][k] initTransferOut];
						meanByGroupInitTransferOut[j] += [agent[j][k] initTransferOut];
						meanIntLeftOut += [agent[j][k] intLeftOut];
						meanByGroupIntLeftOut[j] += [agent[j][k] intLeftOut];
						meanIntRightOut += [agent[j][k] intRightOut];
						meanByGroupIntRightOut[j] += [agent[j][k] intRightOut];
						varInitTransferOut += pow([agent[j][k] initTransferOut],2);
						varByGroupInitTransferOut[j] += pow([agent[j][k] initTransferOut],2);
						varIntLeftOut += pow([agent[j][k] intLeftOut],2);
						varByGroupIntLeftOut[j] += pow([agent[j][k] intLeftOut],2);
						varIntRightOut += pow([agent[j][k] intRightOut],2);
						varByGroupIntRightOut[j] += pow([agent[j][k] intRightOut],2);
						
						meanFitness += [agent[j][k] fitness];
						meanByGroupFitness[j] += [agent[j][k] fitness];
						varFitness += pow([agent[j][k] fitness],2);
						varByGroupFitness[j] += pow([agent[j][k] fitness],2);
					}
					meanByGroupInitTransferIn[j] /= (double) numAgentsInGroup;
					meanByGroupIntLeftIn[j] /= (double) numAgentsInGroup;
					meanByGroupIntRightIn[j] /= (double) numAgentsInGroup;
					varByGroupInitTransferIn[j] = varByGroupInitTransferIn[j] / (double) numAgentsInGroup - pow(meanByGroupInitTransferIn[j],2);
					varByGroupIntLeftIn[j] = varByGroupIntLeftIn[j] / (double) numAgentsInGroup - pow(meanByGroupIntLeftIn[j],2);
					varByGroupIntRightIn[j] = varByGroupIntRightIn[j] / (double) numAgentsInGroup - pow(meanByGroupIntRightIn[j],2);
					
					meanByGroupInitTransferOut[j] /= (double) numAgentsInGroup;
					meanByGroupIntLeftOut[j] /= (double) numAgentsInGroup;
					meanByGroupIntRightOut[j] /= (double) numAgentsInGroup;
					varByGroupInitTransferOut[j] = varByGroupInitTransferOut[j] / (double) numAgentsInGroup - pow(meanByGroupInitTransferOut[j],2);
					varByGroupIntLeftOut[j] = varByGroupIntLeftOut[j] / (double) numAgentsInGroup - pow(meanByGroupIntLeftOut[j],2);
					varByGroupIntRightOut[j] = varByGroupIntRightOut[j] / (double) numAgentsInGroup - pow(meanByGroupIntRightOut[j],2);
					
					meanByGroupFitness[j] /= (double) numAgentsInGroup;
					varByGroupFitness[j] = varByGroupFitness[j] / (double) numAgentsInGroup - pow(meanByGroupFitness[j],2);
				}
				
				meanInitTransferIn /= (double) numAgents;
				meanIntLeftIn /= (double) numAgents;
				meanIntRightIn /= (double) numAgents;
				varInitTransferIn = varInitTransferIn / (double) numAgents - pow(meanInitTransferIn,2);
				varIntLeftIn = varIntLeftIn / (double) numAgents - pow(meanIntLeftIn,2);
				varIntRightIn = varIntRightIn / (double) numAgents - pow(meanIntRightIn,2);
				
				meanInitTransferOut /= (double) numAgents;
				meanIntLeftOut /= (double) numAgents;
				meanIntRightOut /= (double) numAgents;
				varInitTransferOut = varInitTransferOut / (double) numAgents - pow(meanInitTransferOut,2);
				varIntLeftOut = varIntLeftOut / (double) numAgents - pow(meanIntLeftOut,2);
				varIntRightOut = varIntRightOut / (double) numAgents - pow(meanIntRightOut,2);
				
				meanFitness /= (double) numAgents;
				varFitness = varFitness / (double) numAgents - pow(meanFitness,2);
				
				for (j = 0; j < numGroups; j++)
				{
					varWithinInitTransferIn += varByGroupInitTransferIn[j];
					varBtwnInitTransferIn += pow(meanByGroupInitTransferIn[j],2);
					varWithinIntLeftIn += varByGroupIntLeftIn[j];
					varBtwnIntLeftIn += pow(meanByGroupIntLeftIn[j],2);
					varWithinIntRightIn += varByGroupIntRightIn[j];
					varBtwnIntRightIn += pow(meanByGroupIntRightIn[j],2);
					
					varWithinInitTransferOut += varByGroupInitTransferOut[j];
					varBtwnInitTransferOut += pow(meanByGroupInitTransferOut[j],2);
					varWithinIntLeftOut += varByGroupIntLeftOut[j];
					varBtwnIntLeftOut += pow(meanByGroupIntLeftOut[j],2);
					varWithinIntRightOut += varByGroupIntRightOut[j];
					varBtwnIntRightOut += pow(meanByGroupIntRightOut[j],2);
					
					varWithinFitness += varByGroupFitness[j];
					varBtwnFitness += pow(meanByGroupFitness[j],2);
				}
				
				varWithinInitTransferIn /= (double) numGroups;
				varBtwnInitTransferIn = varBtwnInitTransferIn / (double) numGroups - pow(meanInitTransferIn,2);
				varWithinIntLeftIn /= (double) numGroups;
				varBtwnIntLeftIn = varBtwnIntLeftIn / (double) numGroups - pow(meanIntLeftIn,2);
				varWithinIntRightIn /= (double) numGroups;
				varBtwnIntRightIn = varBtwnIntRightIn / (double) numGroups - pow(meanIntRightIn,2);
				
				varWithinInitTransferOut /= (double) numGroups;
				varBtwnInitTransferOut = varBtwnInitTransferOut / (double) numGroups - pow(meanInitTransferOut,2);
				varWithinIntLeftOut /= (double) numGroups;
				varBtwnIntLeftOut = varBtwnIntLeftOut / (double) numGroups - pow(meanIntLeftOut,2);
				varWithinIntRightOut /= (double) numGroups;
				varBtwnIntRightOut = varBtwnIntRightOut / (double) numGroups - pow(meanIntRightOut,2);
				
				varWithinFitness /= (double) numGroups;
				varBtwnFitness = varBtwnFitness / (double) numGroups - pow(meanFitness,2);
				
				fprintf(aggPeriodic,"%i	%i	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f\n", i, t, meanInitTransferIn, meanIntLeftIn, meanIntRightIn, varInitTransferIn, varIntLeftIn, varIntRightIn, varWithinInitTransferIn, varWithinIntLeftIn, varWithinIntRightIn, varBtwnInitTransferIn, varBtwnIntLeftIn, varBtwnIntRightIn, meanInitTransferOut, meanIntLeftOut, meanIntRightOut, varInitTransferOut, varIntLeftOut, varIntRightOut, varWithinInitTransferOut, varWithinIntLeftOut, varWithinIntRightOut, varBtwnInitTransferOut, varBtwnIntLeftOut, varBtwnIntRightOut, meanFitness, varFitness, varWithinFitness, varBtwnFitness);
			} // close printAggOutput = 1
			

			// In what follows, the program finalizes between-group and within-group selection before looping back to start the next generation.
			
			
			// This replaces the agents in a group that lost a competition.
			if (groupConflictPossible == 1)
			{
				for (j = 0; j < numGroups; j++)
				{
					if (groupWinsConflict[indicesGroups[j]] == 0) // The group recorded at indicesGroups[j] lost in an inter-group competition.
					{
						if (j % 2 == 0) // The group recorded at indicesGroups[j] lost to the group recorded at indicesGroups[j+1].
						{
							cFromGroup = indicesGroups[j+1]; // The ID for the group that defeated the focal group.  The focal group will be repopulated by sampling from the winning group.
						}
						if (j % 2 == 1) // The group recorded at indicesGroups[j] lost to the group recorded at indicesGroups[j-1].
						{
							cFromGroup = indicesGroups[j-1]; // The ID for the group that defeated the focal group.  The focal group will be repopulated by sampling from the winning group.
						}
					
						// Here we sample from the winning group to replace agents in the losing group, where sampling is subject to selection among agents within the winning group.
						for (k = 0; k < numAgentsInGroup; k++)
						{
							// Sample for initTransferIn value for agent in position k in the losing group.	
							tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
							if (tempRanNumUpdating > 1.0)
							{
								tempRanNumUpdating = 1.0;
							}
							
							kPrime = 0;
							while (tempRanNumUpdating > [agent[cFromGroup][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
							{
								kPrime += 1;
							}
							
							[agent[indicesGroups[j]][k] setTempInitTransferIn: [agent[cFromGroup][kPrime] initTransferIn]];
							
							// Sample for intLeftIn value for agent in position k in the losing group.						
							tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
							if (tempRanNumUpdating > 1.0)
							{
								tempRanNumUpdating = 1.0;
							}
						
							kPrime = 0;
							while (tempRanNumUpdating > [agent[cFromGroup][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
							{
								kPrime += 1;
							}
						
							[agent[indicesGroups[j]][k] setTempIntLeftIn: [agent[cFromGroup][kPrime] intLeftIn]];
						
							// Sample for intRightIn value for agent in position k in the losing group.
							tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
							if (tempRanNumUpdating > 1.0)
							{
								tempRanNumUpdating = 1.0;
							}
						
							kPrime = 0;
							while (tempRanNumUpdating > [agent[cFromGroup][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
							{
								kPrime += 1;
							}
						
							[agent[indicesGroups[j]][k] setTempIntRightIn: [agent[cFromGroup][kPrime] intRightIn]];

							// Sample for initTransferOut value for agent in position k in the losing group.
							tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
							if (tempRanNumUpdating > 1.0)
							{
								tempRanNumUpdating = 1.0;
							}
						
							kPrime = 0;
							while (tempRanNumUpdating > [agent[cFromGroup][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
							{
								kPrime += 1;
							}
						
							[agent[indicesGroups[j]][k] setTempInitTransferOut: [agent[cFromGroup][kPrime] initTransferOut]];
					
							// Sample for intLeftOut value for agent in position k in the losing group.
							tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
							if (tempRanNumUpdating > 1.0)
							{
								tempRanNumUpdating = 1.0;
							}
						
							kPrime = 0;
							while (tempRanNumUpdating > [agent[cFromGroup][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
							{
								kPrime += 1;
							}
						
							[agent[indicesGroups[j]][k] setTempIntLeftOut: [agent[cFromGroup][kPrime] intLeftOut]];
							
							// Sample for intRightOut value for agent in position k in the losing group.
							tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
							if (tempRanNumUpdating > 1.0)
							{
								tempRanNumUpdating = 1.0;
							}
						
							kPrime = 0;
							while (tempRanNumUpdating > [agent[cFromGroup][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
							{
								kPrime += 1;
							}
					
							[agent[indicesGroups[j]][k] setTempIntRightOut: [agent[cFromGroup][kPrime] intRightOut]];
						} // close loop over agents
					} // close groupWinsConflict[indicesGroups[j]] == 0
				} // close loop over groups
			} // close (groupConflictPossible == 1) condition			
			
			
			// Selection/competition/reproduction within groups for all groups that either won a group competition or did not have a group competition.
			for (j = 0; j < numGroups; j++)
			{
				if (groupWinsConflict[indicesGroups[j]] == 1) // The group recorded at indicesGroups[j] either won in a group competition or did not have a group competition.
				{
					for (k = 0; k < numAgentsInGroup; k++)
					{
						// Sample initTransferIn value for replacing the agent in position k.
						tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
						if (tempRanNumUpdating > 1.0)
						{
							tempRanNumUpdating = 1.0;
						}
							
						kPrime = 0;
						while (tempRanNumUpdating > [agent[indicesGroups[j]][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
						{
							kPrime += 1;
						}
							
						[agent[indicesGroups[j]][k] setTempInitTransferIn: [agent[indicesGroups[j]][kPrime] initTransferIn]];
						
						// Sample intLeftIn value for replacing the agent in position k.
						tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
						if (tempRanNumUpdating > 1.0)
						{
							tempRanNumUpdating = 1.0;
						}
						
						kPrime = 0;
						while (tempRanNumUpdating > [agent[indicesGroups[j]][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
						{
							kPrime += 1;
						}
						
						[agent[indicesGroups[j]][k] setTempIntLeftIn: [agent[indicesGroups[j]][kPrime] intLeftIn]];
						
						// Sample intRightIn value for replacing the agent in position k.
						tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
						if (tempRanNumUpdating > 1.0)
						{
							tempRanNumUpdating = 1.0;
						}
						
						kPrime = 0;
						while (tempRanNumUpdating > [agent[indicesGroups[j]][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
						{
							kPrime += 1;
						}
						
						[agent[indicesGroups[j]][k] setTempIntRightIn: [agent[indicesGroups[j]][kPrime] intRightIn]];
					
						// Sample initTransferOut value for replacing the agent in position k.
						tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
						if (tempRanNumUpdating > 1.0)
						{
							tempRanNumUpdating = 1.0;
						}
						
						kPrime = 0;
						while (tempRanNumUpdating > [agent[indicesGroups[j]][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
						{
							kPrime += 1;
						}
						
						[agent[indicesGroups[j]][k] setTempInitTransferOut: [agent[indicesGroups[j]][kPrime] initTransferOut]];
					
						// Sample intLeftOut value for replacing the agent in position k.
						tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
						if (tempRanNumUpdating > 1.0)
						{
							tempRanNumUpdating = 1.0;
						}
						
						kPrime = 0;
						while (tempRanNumUpdating > [agent[indicesGroups[j]][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
						{
							kPrime += 1;
						}
						
						[agent[indicesGroups[j]][k] setTempIntLeftOut: [agent[indicesGroups[j]][kPrime] intLeftOut]];
					
						// Sample intRightOut value for replacing the agent in position k
						tempRanNumUpdating = (double) 1.0 - genrand_real2(); // Generates a number from (0,1].
						if (tempRanNumUpdating > 1.0)
						{
							tempRanNumUpdating = 1.0;
						}
						
						kPrime = 0;
						while (tempRanNumUpdating > [agent[indicesGroups[j]][kPrime] fitnessAsCumProp] && kPrime < numAgentsInGroup - 1)
						{
							kPrime += 1;
						}
					
						[agent[indicesGroups[j]][k] setTempIntRightOut: [agent[indicesGroups[j]][kPrime] intRightOut]];
					} // close loop over agents
				} // close groupWinsConflict[indicesGroups[j]] == 1
			} // close loop over groups
		} // close loop over generations		
	} // close loop over simulations
	
	// release agents
	for (j = 0; j < numGroups; j++)
	{
		for (k = 0; k < numAgentsInGroup; k++)
		{
			[agent[j][k] release];
		}
	}
	
	// release migrants
	for (m = 0; m < (numGroups * numAgentsMigratePerGroup); m++)
	{
		[migrantAgents[m] release];
	}

	int fclose(FILE *disaggFinalPeriodSim);
	int fclose(FILE *aggPeriodic);
	int fclose(FILE *diffBetweenGroups);
	
	gsl_rng_free(gen);

	return 0;
} // close main