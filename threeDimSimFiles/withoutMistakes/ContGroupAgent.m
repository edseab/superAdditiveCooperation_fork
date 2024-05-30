/* Copyright 2023, Charles Efferson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

#import "ContGroupAgent.h"
#import "mt19937ar.h"
#import <stdlib.h>
#import <math.h> // NEW added by Seabright for various functions.


@implementation ContGroupAgent


// getters
-(double) initTransferIn
{
	return initTransferIn;
}

-(double) intLeftIn
{
	return intLeftIn;
}

-(double) intRightIn
{
	return intRightIn;
}

-(double) tempInitTransferIn
{
	return tempInitTransferIn;
}

-(double) tempIntLeftIn
{
	return tempIntLeftIn;
}

-(double) tempIntRightIn
{
	return tempIntRightIn;
}

-(double) initTransferOut
{
	return initTransferOut;
}

-(double) intLeftOut
{
	return intLeftOut;
}

-(double) intRightOut
{
	return intRightOut;
}

-(double) PaybackParam   // NEW Added by Seabright
{
	return PaybackParam;
}

-(double) tempInitTransferOut
{
	return tempInitTransferOut;
}

-(double) tempIntLeftOut
{
	return tempIntLeftOut;
}

-(double) tempIntRightOut
{
	return tempIntRightOut;
}

-(int) partnerIn 
{
	return partnerIn;
}

-(double) partnerInitTransferIn
{
	return partnerInitTransferIn;
}

-(double) partnerIntLeftIn
{
	return partnerIntLeftIn;
}

-(double) partnerIntRightIn
{
	return partnerIntRightIn;
}

-(int) partnerOut
{
	return partnerOut;
}

-(double) partnerInitTransferOut
{
	return partnerInitTransferOut;
}

-(double) partnerIntLeftOut
{
	return partnerIntLeftOut;
}

-(double) partnerIntRightOut
{
	return partnerIntRightOut;
}

-(double) PartnerPaybackParam   // NEW Added by Seabright
{
	return PartnerPaybackParam;
}

-(int) group
{
	return group;
}

-(int) outGroup
{
	return outGroup;
}

-(int) firstMoverIn
{
	return firstMoverIn;
}

-(int) firstMoverOut
{
	return firstMoverOut;
}

-(int) interactIn
{
	return interactIn;
}

-(int) numInteractionsIn
{
	return numInteractionsIn;
}

-(int) interactOut
{
	return interactOut;
}

-(int) numInteractionsOut
{
	return numInteractionsOut;
}

-(double) efficiencyFactor
{
	return efficiencyFactor;
}

-(double) fitnessIn
{
	return fitnessIn;
}

-(double) fitnessOut
{
	return fitnessOut;
}

-(double) exoFitness
{
	return exoFitness;
}

-(double) weightEndoFitness
{
	return weightEndoFitness;
}

-(double) fitness
{
	return fitness;
}

-(double) fitnessAsCumProp
{
	return fitnessAsCumProp;
}

-(double) tempFitnessIn
{
	return tempFitnessIn;
}

-(double) tempFitnessOut
{
	return tempFitnessOut;
}

-(double) tempExoFitness
{
	return tempExoFitness;
}

-(double) tempFitness
{
	return tempFitness;
}

-(double) probMutate
{
	return probMutate;
}

-(double) mutLatStepInitTransfer
{
	return mutLatStepInitTransfer;
}

-(double) mutLatStepIntercepts
{
	return mutLatStepIntercepts;
}

-(int) mutLatMaxStepIntercepts // NEW Added by Seabright
{
	return mutLatMaxStepIntercepts;
}

-(int) migrate
{
	return migrate;
}

-(int) groupMigrateFrom
{
	return groupMigrateFrom;
}

-(int) groupMigrateTo
{
	return groupMigrateTo;
}

-(double) MaxAbsPaybackParam
{
	return MaxAbsPaybackParam;
}

-(double) mutLatStepPaybackParam
{
	return mutLatStepPaybackParam;
}


// setters
-(void) setInitTransferIn: (double) initT_in
{
	initTransferIn = initT_in;
}

-(void) setIntLeftIn: (double) intL_in
{
	intLeftIn = intL_in;
}

-(void) setIntRightIn: (double) intR_in
{
	intRightIn = intR_in;
}

-(void) setTempInitTransferIn: (double) tInitT_in
{
	tempInitTransferIn = tInitT_in;
}

-(void) setTempIntLeftIn: (double) tIntL_in
{
	tempIntLeftIn = tIntL_in;
}

-(void) setTempIntRightIn: (double) tIntR_in
{
	tempIntRightIn = tIntR_in;
}

-(void) setInitTransferOut: (double) initT_out
{
	initTransferOut = initT_out;
}

-(void) setIntLeftOut: (double) intL_out
{
	intLeftOut = intL_out;
}

-(void) setIntRightOut: (double) intR_out
{
	intRightOut = intR_out;
}

-(void) setPaybackParam: (double) PP                 // NEW Added by Seabright
{
	PaybackParam = PP;
}

-(void) setTempInitTransferOut: (double) tInitT_out
{
	tempInitTransferOut = tInitT_out;
}

-(void) setTempIntLeftOut: (double) tIntL_out
{
	tempIntLeftOut = tIntL_out;
}

-(void) setTempIntRightOut: (double) tIntR_out
{
	tempIntRightOut = tIntR_out;
}

-(void) setPartnerIn: (int) part_in;
{
	partnerIn = part_in;
}

-(void) setPartnerInitTransferIn: (double) partInitT_in
{
	partnerInitTransferIn = partInitT_in;
}

-(void) setPartnerIntLeftIn: (double) partIntL_in
{
	partnerIntLeftIn = partIntL_in;
}

-(void) setPartnerIntRightIn: (double) partIntR_in
{
	partnerIntRightIn = partIntR_in;
}

-(void) setPartnerPaybackParam: (double) PPP                 // NEW Added by Seabright
{
	PartnerPaybackParam = PPP;
}

-(void) setPartnerOut: (int) part_out;
{
	partnerOut = part_out;
}

-(void) setPartnerInitTransferOut: (double) partInitT_out
{
	partnerInitTransferOut = partInitT_out;
}

-(void) setPartnerIntLeftOut: (double) partIntL_out
{
	partnerIntLeftOut = partIntL_out;
}

-(void) setPartnerIntRightOut: (double) partIntR_out
{
	partnerIntRightOut = partIntR_out;
}

-(void) setGroup: (int) gr
{
	group = gr;
}

-(void) setOutGroup: (int) gr_out
{
	outGroup = gr_out;
}

-(void) setFirstMoverIn: (int) firstM_in
{
	firstMoverIn = firstM_in;
}

-(void) setFirstMoverOut: (int) firstM_out
{
	firstMoverOut = firstM_out;
}

-(void) setInteractIn: (int) interact_in
{
	interactIn = interact_in;
}

-(void) setNumInteractionsIn: (int) numInteract_in
{
	numInteractionsIn = numInteract_in;
}

-(void) setInteractOut: (int) interact_out
{
	interactOut = interact_out;
}

-(void) setNumInteractionsOut: (int) numInteract_out
{
	numInteractionsOut = numInteract_out;
}

-(void) setEfficiencyFactor: (double) eff
{
	efficiencyFactor = eff;
}

-(void) setFitnessIn: (double) fit_in
{
	fitnessIn = fit_in;
}

-(void) setFitnessOut: (double) fit_out
{
	fitnessOut = fit_out;
}

-(void) setExoFitness: (double) exoFit
{
	exoFitness = exoFit;
}

-(void) setWeightEndoFitness: (double) wEndo
{
	weightEndoFitness = wEndo;
}

-(void) setFitness: (double) fit
{
	fitness = fit;
}

-(void) setFitnessAsCumProp: (double) fitCumProp
{
	fitnessAsCumProp = fitCumProp;
	if (fitnessAsCumProp > 1.0)
	{
		fitnessAsCumProp = 1.0;
	}
}

-(void) setTempFitnessIn: (double) tFitnessIn
{
	tempFitnessIn = tFitnessIn;
}

-(void) setTempFitnessOut: (double) tFitnessOut
{
	tempFitnessOut = tFitnessOut;
}

-(void) setTempExoFitness: (double) tExoFitness
{
	tempExoFitness = tExoFitness;
}

-(void) setTempFitness: (double) tFitness
{
	tempFitness = tFitness;
}

-(void) setProbMutate: (double) pMut
{
	probMutate = pMut;
}

-(void) setMutLatStepInitTransfer: (double) mStepInitT
{
	mutLatStepInitTransfer = mStepInitT;
}

-(void) setMutLatStepIntercepts: (double) mStepInt
{
	mutLatStepIntercepts = mStepInt;
}

// NEW Added by Seabright
-(void) setMaxAbsPaybackParam: (double) maxAbsPP
{
	MaxAbsPaybackParam = maxAbsPP;
}

-(void) setmutLatStepPaybackParam: (double) mStepPP
{
	mutLatStepPaybackParam = mStepPP;
}

-(void) setMutLatMaxStepIntercepts: (int) mMaxStepInt
{
	mutLatMaxStepIntercepts = mMaxStepInt;
}

int NumSteps; // Declaring the integer number of steps that a mutant will take from their parent


-(void) setMigrate: (int) mig
{
	migrate = mig;
}

-(void) setGroupMigrateFrom: (int) grMigFr
{
	groupMigrateFrom = grMigFr;
}

-(void) setGroupMigrateTo: (int) grMigTo
{
	groupMigrateTo = grMigTo;
}

// Strategies
// Perfect reciprocity
double strat1[] = {0.0,1.0};
// Unconditional strategies
double strat2[] = {1.0,1.0};
double strat3[] = {0.0,0.0};
double strat4[] = {0.5,0.5};
// De-escalating strategies
double strat5[] = {0.0,0.9};
double strat6[] = {0.0,0.8};
double strat7[] = {0.0,0.7};
double strat8[] = {0.0,0.6};
double strat9[] = {0.0,0.5};
double strat10[] = {0.0,0.4};
double strat11[] = {0.0,0.3};
double strat12[] = {0.0,0.2};
double strat13[] = {0.0,0.1};
// Escalating strategies
double strat14[] = {0.1,1.0};
double strat15[] = {0.2,1.0};
double strat16[] = {0.3,1.0};
double strat17[] = {0.4,1.0};
double strat18[] = {0.5,1.0};
double strat19[] = {0.6,1.0};
double strat20[] = {0.7,1.0};
double strat21[] = {0.8,1.0};
double strat22[] = {0.9,1.0};
// Ambiguous strategies
double strat23[] = {0.1,0.9};
double strat24[] = {0.3,0.9};
double strat25[] = {0.5,0.9};
double strat26[] = {0.7,0.9};
double strat27[] = {0.1,0.7};
double strat28[] = {0.3,0.7};
double strat29[] = {0.5,0.7};
double strat30[] = {0.9,0.7};
double strat31[] = {0.1,0.5};
double strat32[] = {0.3,0.5};
double strat33[] = {0.7,0.5};
double strat34[] = {0.9,0.5};
double strat35[] = {0.1,0.3};
double strat36[] = {0.5,0.3};
double strat37[] = {0.7,0.3};
double strat38[] = {0.9,0.3};
double strat39[] = {0.3,0.1};
double strat40[] = {0.5,0.1};
double strat41[] = {0.7,0.1};
double strat42[] = {0.9,0.1};
// All strats together
double *strategies[] = {strat1,strat2,strat3,strat4,strat5,strat6,strat7,strat8,strat9,strat10,strat11,strat12,strat13,strat14,strat15,strat16,strat17,strat18,strat19,strat20,strat21,strat22,strat23,strat24,strat25,strat26,strat27,strat28,strat29,strat30,strat31,strat32,strat33,strat34,strat35,strat36,strat37,strat38,strat39,strat40,strat41,strat42};

int nstrats = sizeof(strategies)/sizeof(strategies[0]); // This needs to be the same as the total number of possible response functions
int mutant_strat; // declaring the randomly chosen response function that will be selected

// procedural methods
-(void) assignRandomInitTransferIn
{
	int numLatticeSteps = (double) 1.0 / mutLatStepInitTransfer + (double) 1.0;
	
	initTransferIn = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepInitTransfer;
	if (initTransferIn < 0.0)
	{
		initTransferIn = 0.0;
	}
	if (initTransferIn > 1.0)
	{
		initTransferIn = 1.0;
	}
}

-(void) assignRandomInterceptsIn
{
	int numLatticeSteps = (double) 1.0 / mutLatStepIntercepts + (double) 1.0;
	
	intLeftIn = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepIntercepts;
	if (intLeftIn < 0.0)
	{
		intLeftIn = 0.0;
	}
	if (intLeftIn > 1.0)
	{
		intLeftIn = 1.0;
	}
	
	intRightIn = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepIntercepts;
	if (intRightIn < 0.0)
	{
		intRightIn = 0.0;
	}
	if (intRightIn > 1.0)
	{
		intRightIn = 1.0;
	} 
}

-(void) assignRandomInitTransferOut
{
	int numLatticeSteps = (double) 1.0 / mutLatStepInitTransfer + (double) 1.0;
	
	initTransferOut = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepInitTransfer;
	if (initTransferOut < 0.0)
	{
		initTransferOut = 0.0;
	}
	if (initTransferOut > 1.0)
	{
		initTransferOut = 1.0;
	}
}

-(void) assignRandomInterceptsOut
{
	int numLatticeSteps = (double) 1.0 / mutLatStepIntercepts + (double) 1.0;
	
	intLeftOut = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepIntercepts;
	if (intLeftOut < 0.0)
	{
		intLeftOut = 0.0;
	}
	if (intLeftOut > 1.0)
	{
		intLeftOut = 1.0;
	}
	
	intRightOut = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepIntercepts;
	if (intRightOut < 0.0)
	{
		intRightOut = 0.0;
	}
	if (intRightOut > 1.0)
	{
		intRightOut = 1.0;
	} 
}
	
-(void) calculateFitnessIn // NEW by Seabright: changed the transfers to include the Payback, which is a function of the Payback Parameter and the amount escalated or de-escalated bu the partner's previous transfer.
{
	if (numInteractionsIn == 1) // No changes here because Payback Parameter is irrelevant to 2st interaction
	{
		if (firstMoverIn == 1)
		{
			fitnessIn = (double) 1.0 - initTransferIn + efficiencyFactor * (partnerIntLeftIn + (partnerIntRightIn - partnerIntLeftIn) * initTransferIn);
		}
		else 
		{
			fitnessIn = (double) 1.0 - (intLeftIn + (intRightIn - intLeftIn) * partnerInitTransferIn) + efficiencyFactor * partnerInitTransferIn;
		}
	}
	else if (numInteractionsIn > 1)
	{
		double focalBeh;
		double partnerBeh;
		int n;
		
		if (firstMoverIn == 1)
		{
			focalBeh = initTransferIn;
			partnerBeh = partnerIntLeftIn + (partnerIntRightIn - partnerIntLeftIn) * focalBeh;
			fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
		
			for (n = 1; n < numInteractionsIn; n++)
			{
				focalBeh = intLeftIn + (intRightIn - intLeftIn) * partnerBeh + PaybackParam * (partnerBeh - focalBeh); // NEW by Seabright: add payback to the transfer
				focalBeh = fmax(fmin(focalBeh, 1.0), 0.0); // NEW by Seabright constrain to be between 0 and 1
				partnerBeh = partnerIntLeftIn + (partnerIntRightIn - partnerIntLeftIn) * focalBeh + PartnerPaybackParam * (focalBeh - partnerBeh); // NEW by Seabright: add payback to the transfer
				partnerBeh = fmax(fmin(partnerBeh, 1.0), 0.0); // NEW by Seabright constrain to be between 0 and 1
				fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			}
		}
		else
		{
			partnerBeh = partnerInitTransferIn;
			focalBeh = intLeftIn + (intRightIn - intLeftIn) * partnerBeh;
			fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;

			for (n = 1; n < numInteractionsIn; n++)
			{
				partnerBeh = partnerIntLeftIn + (partnerIntRightIn - partnerIntLeftIn) * focalBeh + PartnerPaybackParam * (focalBeh - partnerBeh); // NEW by Seabright: add payback to the transfer
				partnerBeh = fmax(fmin(partnerBeh, 1.0), 0.0); // NEW by Seabright constrain to be between 0 and 1
				focalBeh = intLeftIn + (intRightIn - intLeftIn) * partnerBeh + PaybackParam * (partnerBeh - focalBeh); // NEW by Seabright: add payback to the transfer
				focalBeh = fmax(fmin(focalBeh, 1.0), 0.0); // NEW by Seabright constrain to be between 0 and 1
				fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			}
		}
	}
	else
	{
		fitnessIn = 1.0; // Retain endowment if no in-group interaction occurs.
	}
}

-(void) calculateFitnessOut
{
	if (numInteractionsOut == 1)
	{
		if (firstMoverOut == 1)
		{
			fitnessOut = (double) 1.0 - initTransferOut + efficiencyFactor * (partnerIntLeftOut + (partnerIntRightOut - partnerIntLeftOut) * initTransferOut);
		}
		else 
		{
			fitnessOut = (double) 1.0 - (intLeftOut + (intRightOut - intLeftOut) * partnerInitTransferOut) + efficiencyFactor * partnerInitTransferOut;
		}
	}
	else if (numInteractionsOut > 1)
	{
		double focalBeh;
		double partnerBeh;
		int n;
		
		if (firstMoverOut == 1)
		{
			focalBeh = initTransferOut;
			partnerBeh = partnerIntLeftOut + (partnerIntRightOut - partnerIntLeftOut) * focalBeh;
			fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
		
			for (n = 1; n < numInteractionsOut; n++)
			{
				focalBeh = intLeftOut + (intRightOut - intLeftOut) * partnerBeh;
				partnerBeh = partnerIntLeftOut + (partnerIntRightOut - partnerIntLeftOut) * focalBeh;
				fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			}
		}
		else
		{
			partnerBeh = partnerInitTransferOut;
			focalBeh = intLeftOut + (intRightOut - intLeftOut) * partnerBeh;
			fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;

			for (n = 1; n < numInteractionsOut; n++)
			{
				partnerBeh = partnerIntLeftOut + (partnerIntRightOut - partnerIntLeftOut) * focalBeh;
				focalBeh = intLeftOut + (intRightOut - intLeftOut) * partnerBeh;
				fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			}
		}
	}
	else
	{
		fitnessOut = 1.0; // Retain endowment if no out-group interaction occurs.
	}
}

-(void) calculateFitness
{
	fitness = ((double) 1.0 - weightEndoFitness) * exoFitness + weightEndoFitness * (fitnessIn + fitnessOut);		
}

-(void) updatePhenotypeFromTempIn
{
	initTransferIn = tempInitTransferIn;

	intLeftIn = tempIntLeftIn;
	intRightIn = tempIntRightIn;
	
}

-(void) updatePhenotypeFromTempOut
{
	initTransferOut = tempInitTransferOut;
	intLeftOut = tempIntLeftOut;
	intRightOut = tempIntRightOut;
}

-(void) updateFitnessValuesFromTemp
{
	fitnessIn = tempFitnessIn;
	fitnessOut = tempFitnessOut;
	fitness = tempFitness;
}

-(void) categoricalMutation // New by Seabright: The mutation function for the categorical strategies model
{
	// initTransferIn (same as in continuous version)
	if (initTransferIn <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			initTransferIn = mutLatStepInitTransfer;
		}
	}
	else if (initTransferIn >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			initTransferIn = (double) 1.0 - mutLatStepInitTransfer;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				initTransferIn += mutLatStepInitTransfer;
				if (initTransferIn > 1.0)
				{
					initTransferIn = 1.0;
				}
			}
			else
			{
				initTransferIn -= mutLatStepInitTransfer;
				if (initTransferIn < 0.0)
				{
					initTransferIn = 0.0;
				}
			}
		}
	}

	// intercepts
	if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
		mutant_strat = genrand_int32() % (nstrats-1); // random integer between 0 and 41
		intLeftIn = strategies[mutant_strat][0];
		intRightIn = strategies[mutant_strat][1];
		}
}

-(void) implementMutationsIn // NEW Added by Seabright: increased possible number of simultaneous mutation steps and implemented mutation for Payback Parameter
{
	// initTransferIn
	if (initTransferIn <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			initTransferIn = mutLatStepInitTransfer;
		}
	}
	else if (initTransferIn >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			initTransferIn = (double) 1.0 - mutLatStepInitTransfer;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				initTransferIn += mutLatStepInitTransfer;
				if (initTransferIn > 1.0)
				{
					initTransferIn = 1.0;
				}
			}
			else
			{
				initTransferIn -= mutLatStepInitTransfer;
				if (initTransferIn < 0.0)
				{
					initTransferIn = 0.0;
				}
			}
		}
	}
	
	// intLeftIn
	if (intLeftIn <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			NumSteps = (genrand_int32() % (mutLatMaxStepIntercepts))+1; // NEW Added by Seabright: Random integer between 1 and the max number of possible lattice steps for single mutation
			intLeftIn = mutLatStepIntercepts*NumSteps;
		}
	}
	else if (intLeftIn >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			NumSteps = (genrand_int32() % (mutLatMaxStepIntercepts))+1; // NEW Added by Seabright: Random integer between 1 and the max number of possible lattice steps for single mutation
			intLeftIn = (double) 1.0 - mutLatStepIntercepts*NumSteps;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			NumSteps = (genrand_int32() % (mutLatMaxStepIntercepts))+1; // NEW Added by Seabright: Random integer between 1 and the max number of possible lattice steps for single mutation

			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				
				intLeftIn += mutLatStepIntercepts*NumSteps;
				if (intLeftIn > 1.0)
				{
					intLeftIn = 1.0;
				}
			}
			else
			{
				intLeftIn -= mutLatStepIntercepts*NumSteps;
				if (intLeftIn < 0.0)
				{
					intLeftIn = 0.0;
				}
			}
		}
	}

	// intRightIn
	if (intRightIn <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			NumSteps = (genrand_int32() % (mutLatMaxStepIntercepts))+1; // NEW Added by Seabright: Random integer between 1 and the max number of possible lattice steps for single mutation
			intRightIn = mutLatStepIntercepts*NumSteps;
		}
	}
	else if (intRightIn >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			NumSteps = (genrand_int32() % (mutLatMaxStepIntercepts))+1; // NEW Added by Seabright: Random integer between 1 and the max number of possible lattice steps for single mutation
			intRightIn = (double) 1.0 - mutLatStepIntercepts*NumSteps;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			NumSteps = (genrand_int32() % (mutLatMaxStepIntercepts))+1; // NEW Added by Seabright: Random integer between 1 and the max number of possible lattice steps for single mutation

			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				intRightIn += mutLatStepIntercepts*NumSteps;
				if (intRightIn > 1.0)
				{
					intRightIn = 1.0;
				}
			}
			else
			{
				intRightIn -= mutLatStepIntercepts*NumSteps;
				if (intRightIn < 0.0)
				{
					intRightIn  = 0.0;
				}
			}
		}
	}

// PaybackParam:  NEW added by Seabright
	if (PaybackParam <= - MaxAbsPaybackParam)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			PaybackParam = mutLatStepPaybackParam - MaxAbsPaybackParam;
		}
	}
	else if (PaybackParam >= MaxAbsPaybackParam)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			PaybackParam = (double) MaxAbsPaybackParam - mutLatStepPaybackParam;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				PaybackParam += mutLatStepPaybackParam;
				if (PaybackParam > MaxAbsPaybackParam)
				{
					PaybackParam = MaxAbsPaybackParam;
				}
			}
			else
			{
				PaybackParam -= MaxAbsPaybackParam;
				if (PaybackParam < - MaxAbsPaybackParam)
				{
					PaybackParam = - MaxAbsPaybackParam;
				}
			}
		}
	}

}

-(void) implementMutationsOut
{
	// initTransferOut
	if (initTransferOut <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			initTransferOut = mutLatStepInitTransfer;
		}
	}
	else if (initTransferOut >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			initTransferOut = (double) 1.0 - mutLatStepInitTransfer;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				initTransferOut += mutLatStepInitTransfer;
				if (initTransferOut > 1.0)
				{
					initTransferOut = 1.0;
				}
			}
			else
			{
				initTransferOut -= mutLatStepInitTransfer;
				if (initTransferOut < 0.0)
				{
					initTransferOut = 0.0;
				}
			}
		}
	}
	
	// intLeftOut
	if (intLeftOut <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			intLeftOut = mutLatStepIntercepts;
		}
	}
	else if (intLeftOut >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			intLeftOut = (double) 1.0 - mutLatStepIntercepts;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				intLeftOut += mutLatStepIntercepts;
				if (intLeftOut > 1.0)
				{
					intLeftOut = 1.0;
				}
			}
			else
			{
				intLeftOut -= mutLatStepIntercepts;
				if (intLeftOut < 0.0)
				{
					intLeftOut = 0.0;
				}
			}
		}
	}

	// intRightOut
	if (intRightOut <= 0.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			intRightOut = mutLatStepIntercepts;
		}
	}
	else if (intRightOut >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			intRightOut = (double) 1.0 - mutLatStepIntercepts;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				intRightOut += mutLatStepIntercepts;
				if (intRightOut > 1.0)
				{
					intRightOut = 1.0;
				}
			}
			else
			{
				intRightOut -= mutLatStepIntercepts;
				if (intRightOut < 0.0)
				{
					intRightOut  = 0.0;
				}
			}
		}
	}
}

@end