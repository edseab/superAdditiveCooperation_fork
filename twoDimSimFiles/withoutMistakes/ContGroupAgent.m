/* Copyright 2023, Charles Efferson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

#import "ContGroupAgent.h"
#import "mt19937ar.h"
#import <stdlib.h>


@implementation ContGroupAgent

// getters
-(double) initTransferIn
{
	return initTransferIn;
}

-(double) degreeIn
{
	return degreeIn;
}

-(double) tempInitTransferIn
{
	return tempInitTransferIn;
}

-(double) tempDegreeIn
{
	return tempDegreeIn;
}

-(double) initTransferOut
{
	return initTransferOut;
}

-(double) degreeOut
{
	return degreeOut;
}

-(double) tempInitTransferOut
{
	return tempInitTransferOut;
}

-(double) tempDegreeOut
{
	return tempDegreeOut;
}

-(int) partnerIn 
{
	return partnerIn;
}

-(double) partnerInitTransferIn
{
	return partnerInitTransferIn;
}

-(double) partnerDegreeIn
{
	return partnerDegreeIn;
}

-(int) partnerOut
{
	return partnerOut;
}

-(double) partnerInitTransferOut
{
	return partnerInitTransferOut;
}

-(double) partnerDegreeOut
{
	return partnerDegreeOut;
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

-(double) mutLatStepDegree
{
	return mutLatStepDegree;
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


// setters
-(void) setInitTransferIn: (double) initT_in
{
	initTransferIn = initT_in;
}
 
-(void) setDegreeIn: (double) deg_in
{
	degreeIn = deg_in;
}

-(void) setTempInitTransferIn: (double) tInitT_in
{
	tempInitTransferIn = tInitT_in;
}

-(void) setTempDegreeIn: (double) tDeg_in
{
	tempDegreeIn = tDeg_in;
}

-(void) setInitTransferOut: (double) initT_out
{
	initTransferOut = initT_out;
}

-(void) setDegreeOut: (double) deg_out
{
	degreeOut = deg_out;
}

-(void) setTempInitTransferOut: (double) tInitT_out
{
	tempInitTransferOut = tInitT_out;
}

-(void) setTempDegreeOut: (double) tDeg_out
{
	tempDegreeOut = tDeg_out;
}

-(void) setPartnerIn: (int) part_in;
{
	partnerIn = part_in;
}

-(void) setPartnerInitTransferIn: (double) partInitT_in
{
	partnerInitTransferIn = partInitT_in;
}

-(void) setPartnerDegreeIn: (double) partDeg_in
{
	partnerDegreeIn = partDeg_in;
}

-(void) setPartnerOut: (int) part_out;
{
	partnerOut = part_out;
}

-(void) setPartnerInitTransferOut: (double) partInitT_out
{
	partnerInitTransferOut = partInitT_out;
}

-(void) setPartnerDegreeOut: (double) partDeg_out
{
	partnerDegreeOut = partDeg_out;
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

-(void) setMutLatStepDegree: (double) mStepDeg
{
	mutLatStepDegree = mStepDeg;
}

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

-(void) assignRandomDegreeIn
{
	int numLatticeSteps = (double) 2.0 / mutLatStepDegree + (double) 1.0;
	
	degreeIn = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepDegree + (double) -1.0;
	if (degreeIn < -1.0)
	{
		degreeIn = -1.0;
	}
	if (degreeIn > 1.0)
	{
		degreeIn = 1.0;
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

-(void) assignRandomDegreeOut
{
	int numLatticeSteps = (double) 2.0 / mutLatStepDegree + (double) 1.0;
	
	degreeOut = (ceil((double) numLatticeSteps * ((double) 1.0 - genrand_real2())) - (double) 1.0) * mutLatStepDegree + (double) -1.0;
	if (degreeOut < -1.0)
	{
		degreeOut = -1.0;
	}
	if (degreeOut > 1.0)
	{
		degreeOut = 1.0;
	}
}
	
-(void) calculateFitnessIn
{
	double focalBeh;
	double partnerBeh;
	int n;

	if (degreeIn >= 0.0 && partnerDegreeIn >= 0.0) // both players escalate
	{
		if (numInteractionsIn >= 1)
		{
			if (firstMoverIn == 1)
			{
				focalBeh = initTransferIn;
				partnerBeh = ((double) 1.0 - partnerDegreeIn) * focalBeh + partnerDegreeIn;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
		
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						focalBeh = ((double) 1.0 - degreeIn) * partnerBeh + degreeIn;
						partnerBeh = ((double) 1.0 - partnerDegreeIn) * focalBeh + partnerDegreeIn;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferIn;
				focalBeh = ((double) 1.0 - degreeIn) * partnerBeh + degreeIn;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
		
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						partnerBeh = ((double) 1.0 - partnerDegreeIn) * focalBeh + partnerDegreeIn;
						focalBeh = ((double) 1.0 - degreeIn) * partnerBeh + degreeIn;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessIn = 1.0; // Retain endowment if no in-group interaction occurs
		}
	}
	else if (degreeIn >= 0.0 && partnerDegreeIn < 0.0) // focal escalates, partner de-escalates
	{
		if (numInteractionsIn >= 1)
		{
			if (firstMoverIn == 1)
			{
				focalBeh = initTransferIn;
				partnerBeh = ((double) 1.0 + partnerDegreeIn) * focalBeh;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						focalBeh = ((double) 1.0 - degreeIn) * partnerBeh + degreeIn;
						partnerBeh = ((double) 1.0 + partnerDegreeIn) * focalBeh;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferIn;
				focalBeh = ((double) 1.0 - degreeIn) * partnerBeh + degreeIn;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						partnerBeh = ((double) 1.0 + partnerDegreeIn) * focalBeh;
						focalBeh = ((double) 1.0 - degreeIn) * partnerBeh + degreeIn;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessIn = 1.0; // Retain endowment if no in-group interaction occurs
		}		
	}
	else if (degreeIn < 0.0 && partnerDegreeIn >= 0) // focal de-escalates, partner escalates
	{
		if (numInteractionsIn >= 1)
		{
			if (firstMoverIn == 1)
			{
				focalBeh = initTransferIn;
				partnerBeh = ((double) 1.0 - partnerDegreeIn) * focalBeh + partnerDegreeIn;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						focalBeh = ((double) 1.0 + degreeIn) * partnerBeh;
						partnerBeh = ((double) 1.0 - partnerDegreeIn) * focalBeh + partnerDegreeIn;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferIn;
				focalBeh = ((double) 1.0 + degreeIn) * partnerBeh;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						partnerBeh = ((double) 1.0 - partnerDegreeIn) * focalBeh + partnerDegreeIn;
						focalBeh = ((double) 1.0 + degreeIn) * partnerBeh;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessIn = 1.0; // Retain endowment if no in-group interaction occurs
		}		
	}
	else // both players de-escalate
	{
		if (numInteractionsIn >= 1)
		{
			if (firstMoverIn == 1)
			{
				focalBeh = initTransferIn;
				partnerBeh = ((double) 1.0 + partnerDegreeIn) * focalBeh;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						focalBeh = ((double) 1.0 + degreeIn) * partnerBeh;
						partnerBeh = ((double) 1.0 + partnerDegreeIn) * focalBeh;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferIn;
				focalBeh = ((double) 1.0 + degreeIn) * partnerBeh;
				fitnessIn = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsIn > 1)
				{
					for (n = 1; n < numInteractionsIn; n++)
					{
						partnerBeh = ((double) 1.0 + partnerDegreeIn) * focalBeh;
						focalBeh = ((double) 1.0 + degreeIn) * partnerBeh;
						fitnessIn += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessIn = 1.0; // Retain endowment if no in-group interaction occurs
		}		
	}
}

-(void) calculateFitnessOut
{
	double focalBeh;
	double partnerBeh;
	int n;

	if (degreeOut >= 0.0 && partnerDegreeOut >= 0.0) // both players escalate
	{
		if (numInteractionsOut >= 1)
		{
			if (firstMoverOut == 1)
			{
				focalBeh = initTransferOut;
				partnerBeh = ((double) 1.0 - partnerDegreeOut) * focalBeh + partnerDegreeOut;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
		
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						focalBeh = ((double) 1.0 - degreeOut) * partnerBeh + degreeOut;
						partnerBeh = ((double) 1.0 - partnerDegreeOut) * focalBeh + partnerDegreeOut;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferOut;
				focalBeh = ((double) 1.0 - degreeOut) * partnerBeh + degreeOut;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
		
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						partnerBeh = ((double) 1.0 - partnerDegreeOut) * focalBeh + partnerDegreeOut;
						focalBeh = ((double) 1.0 - degreeOut) * partnerBeh + degreeOut;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessOut = 1.0; // Retain endowment if no out-group interaction occurs
		}
	}
	else if (degreeOut >= 0.0 && partnerDegreeOut < 0.0) // focal escalates, partner de-escalates
	{
		if (numInteractionsOut >= 1)
		{
			if (firstMoverOut == 1)
			{
				focalBeh = initTransferOut;
				partnerBeh = ((double) 1.0 + partnerDegreeOut) * focalBeh;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						focalBeh = ((double) 1.0 - degreeOut) * partnerBeh + degreeOut;
						partnerBeh = ((double) 1.0 + partnerDegreeOut) * focalBeh;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferOut;
				focalBeh = ((double) 1.0 - degreeOut) * partnerBeh + degreeOut;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						partnerBeh = ((double) 1.0 + partnerDegreeOut) * focalBeh;
						focalBeh = ((double) 1.0 - degreeOut) * partnerBeh + degreeOut;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessOut = 1.0; // Retain endowment if no out-group interaction occurs
		}		
	}
	else if (degreeOut < 0.0 && partnerDegreeOut >= 0) // focal de-escalates, partner escalates
	{
		if (numInteractionsOut >= 1)
		{
			if (firstMoverOut == 1)
			{
				focalBeh = initTransferOut;
				partnerBeh = ((double) 1.0 - partnerDegreeOut) * focalBeh + partnerDegreeOut;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						focalBeh = ((double) 1.0 + degreeOut) * partnerBeh;
						partnerBeh = ((double) 1.0 - partnerDegreeOut) * focalBeh + partnerDegreeOut;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferOut;
				focalBeh = ((double) 1.0 + degreeOut) * partnerBeh;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						partnerBeh = ((double) 1.0 - partnerDegreeOut) * focalBeh + partnerDegreeOut;
						focalBeh = ((double) 1.0 + degreeOut) * partnerBeh;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessOut = 1.0; // Retain endowment if no out-group interaction occurs
		}		
	}
	else // both players de-escalate
	{
		if (numInteractionsOut >= 1)
		{
			if (firstMoverOut == 1)
			{
				focalBeh = initTransferOut;
				partnerBeh = ((double) 1.0 + partnerDegreeOut) * focalBeh;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						focalBeh = ((double) 1.0 + degreeOut) * partnerBeh;
						partnerBeh = ((double) 1.0 + partnerDegreeOut) * focalBeh;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
			else 
			{
				partnerBeh = partnerInitTransferOut;
				focalBeh = ((double) 1.0 + degreeOut) * partnerBeh;
				fitnessOut = (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
			
				if (numInteractionsOut > 1)
				{
					for (n = 1; n < numInteractionsOut; n++)
					{
						partnerBeh = ((double) 1.0 + partnerDegreeOut) * focalBeh;
						focalBeh = ((double) 1.0 + degreeOut) * partnerBeh;
						fitnessOut += (double) 1.0 - focalBeh + efficiencyFactor * partnerBeh;
					}
				}
			}
		}
		else
		{
			fitnessOut = 1.0; // Retain endowment if no out-group interaction occurs
		}		
	}
}

-(void) calculateFitness
{
	fitness = ((double) 1.0 - weightEndoFitness) * exoFitness + weightEndoFitness * (fitnessIn + fitnessOut);		
}

-(void) updatePhenotypeFromTempIn
{
	initTransferIn = tempInitTransferIn;
	degreeIn = tempDegreeIn;
}

-(void) updatePhenotypeFromTempOut
{
	initTransferOut = tempInitTransferOut;
	degreeOut = tempDegreeOut;
}

-(void) updateFitnessValuesFromTemp
{
	fitnessIn = tempFitnessIn;
	fitnessOut = tempFitnessOut;
	fitness = tempFitness;
}

-(void) implementMutationsIn
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
	
	// degreeIn
	if (degreeIn <= -1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			degreeIn = (double) -1.0 + mutLatStepDegree;
		}
	}
	else if (degreeIn >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			degreeIn = (double) 1.0 - mutLatStepDegree;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				degreeIn += mutLatStepDegree;
				if (degreeIn > 1.0)
				{
					degreeIn = 1.0;
				}
			}
			else
			{
				degreeIn -= mutLatStepDegree;
				if (degreeIn < -1.0)
				{
					degreeIn = -1.0;
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
	
	// degreeOut
	if (degreeOut <= -1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			degreeOut = (double) -1.0 + mutLatStepDegree;
		}
	}
	else if (degreeOut >= 1.0)
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate / (double) 2.0)
		{
			degreeOut = (double) 1.0 - mutLatStepDegree;
		}
	}
	else
	{
		if (((double) 1.0 - genrand_real2()) <= probMutate)
		{
			if (((double) 1.0 - genrand_real2()) <= 0.5)
			{
				degreeOut += mutLatStepDegree;
				if (degreeOut > 1.0)
				{
					degreeOut = 1.0;
				}
			}
			else
			{
				degreeOut -= mutLatStepDegree;
				if (degreeOut < -1.0)
				{
					degreeOut = -1.0;
				}
			}
		}
	}
}

@end