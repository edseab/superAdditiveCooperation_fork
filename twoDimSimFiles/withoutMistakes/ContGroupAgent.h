/* Copyright 2023, Charles Efferson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

#import <Foundation/Foundation.h>

@interface ContGroupAgent : NSObject {
	
	double initTransferIn;			// in-group case, agent's initial transfer, if first mover, during the initial interaction; normalized to be in the [0,1] interval
	double degreeIn;				// in-group case, degree of response
	double tempInitTransferIn; 		// in-group case, used for updating values at the end of each generation
	double tempDegreeIn;		 	// in-group case, same
	
	double initTransferOut;			// out-group case, agent's initial transfer, if first mover, during the initial interaction; normalized to be in the [0,1] interval
	double degreeOut;				// out-group case, degree of response
	double tempInitTransferOut; 	// out-group case, used for updating values at the end of each generation
	double tempDegreeOut;		 	// out-group case, same
	
	int partnerIn;					// in-group case, the index of the agent's partner
	double partnerInitTransferIn;	// in-group case, analogous to agent's initTransfer
	double partnerDegreeIn;			// in-group case, analogous to agent's degree
	
	int partnerOut;					// out-group case, the index of the agent's partner, i.e. the index for this out-group partner within the out-group partner's own group
	double partnerInitTransferOut;	// out-group case, analogous to agent's initTransfer
	double partnerDegreeOut;		// out-group case, analogous to agent's degree
	
	int group;						// agent's group index
	int outGroup;					// the group index for the agent's out-group
	
	int firstMoverIn;				// dummy indicating if agent is first mover for in-group pairing
	int firstMoverOut;				// dummy indicating if agent is first mover for out-group pairing
	
	int interactIn;					// a dummy indicating if an in-group interaction actually occurs
	int numInteractionsIn;			// the number of interactions focal has with an in-group partner
	int interactOut;				// a dummy indicating if an out-group interaction actually occurs
	int numInteractionsOut;			// the number of interactions focal has with an out-group partner
	
	double efficiencyFactor; 		// the gains from (back)transferring
	double fitnessIn;				// fitness from potential interaction with in-group member
	double fitnessOut;				// fitness from potential interaction with out-group member
	double exoFitness;				// exogenous fitness for agent (and everyone else)
	double weightEndoFitness;		// weight on endogenous fitness for agent
	double fitness;					// (1 - weightEndoFitness) * exogenous fitness + weightEndoFitness * endogenous fitness for agent associated with all interactions being modeled
	double fitnessAsCumProp; 		// fitness as a cumulative proportion of the sum over all fitnesses in population; used for updating phenotypes
	
	double tempFitnessIn;			// used for migration algorithm when it comes after game play
	double tempFitnessOut;			// used for migration algorithm when it comes after game play
	double tempExoFitness;			// used for migration algorithm when it comes after game play
	double tempFitness;				// used for migration algorithm when it comes after game play
	
	double probMutate;					// probability of mutating in either of the three dimensions (i.e. initTransfer or degree)
	double mutLatStepInitTransfer;		// if a mutation occurs w.r.t. initTransfer, it's either up or down by this quantity
	double mutLatStepDegree;			// if a mutation occurs w.r.t. degree, it's either up or down by this quantity
	
	int migrate;						// a dummy indicating if agent migrated
	int groupMigrateFrom;				// idx for group of origin
	int groupMigrateTo;					// idx for group migrates to
}

// getters
-(double) initTransferIn;
-(double) degreeIn;
-(double) tempInitTransferIn;
-(double) tempDegreeIn;
-(double) initTransferOut;
-(double) degreeOut;
-(double) tempInitTransferOut;
-(double) tempDegreeOut;
-(int) partnerIn;
-(double) partnerInitTransferIn;
-(double) partnerDegreeIn;
-(int) partnerOut;
-(double) partnerInitTransferOut;
-(double) partnerDegreeOut;
-(int) group;
-(int) outGroup;
-(int) firstMoverIn;
-(int) firstMoverOut;
-(int) interactIn;
-(int) numInteractionsIn;
-(int) interactOut;
-(int) numInteractionsOut;
-(double) efficiencyFactor;
-(double) fitnessIn;
-(double) fitnessOut;
-(double) exoFitness;
-(double) weightEndoFitness;
-(double) fitness;
-(double) fitnessAsCumProp;
-(double) tempFitnessIn;
-(double) tempFitnessOut;
-(double) tempExoFitness;
-(double) tempFitness;
-(double) probMutate;
-(double) mutLatStepInitTransfer;
-(double) mutLatStepDegree;
-(int) migrate;
-(int) groupMigrateFrom;
-(int) groupMigrateTo;

// setters
-(void) setInitTransferIn: (double) initT_in;
-(void) setDegreeIn: (double) deg_in;
-(void) setTempInitTransferIn: (double) tInitT_in;
-(void) setTempDegreeIn: (double) tDeg_in;
-(void) setInitTransferOut: (double) initT_out;
-(void) setDegreeOut: (double) deg_out;
-(void) setTempInitTransferOut: (double) tInitT_out;
-(void) setTempDegreeOut: (double) tDeg_out;
-(void) setPartnerIn: (int) part_in;
-(void) setPartnerInitTransferIn: (double) partInitT_in;
-(void) setPartnerDegreeIn: (double) partDeg_in;
-(void) setPartnerOut: (int) part_out;
-(void) setPartnerInitTransferOut: (double) partInitT_out;
-(void) setPartnerDegreeOut: (double) partDeg_out;
-(void) setGroup: (int) gr;
-(void) setOutGroup: (int) gr_out;
-(void) setFirstMoverIn: (int) firstM_in;
-(void) setFirstMoverOut: (int) firstM_out;
-(void) setInteractIn: (int) interact_in;
-(void) setNumInteractionsIn: (int) numInteract_in;
-(void) setInteractOut: (int) interact_out;
-(void) setNumInteractionsOut: (int) numInteract_out;
-(void) setEfficiencyFactor: (double) eff;
-(void) setFitnessIn: (double) fit_in;
-(void) setFitnessOut: (double) fit_out;
-(void) setExoFitness: (double) exoFit;
-(void) setWeightEndoFitness: (double) wEndo;
-(void) setFitness: (double) fit;
-(void) setFitnessAsCumProp: (double) fitCumProp;
-(void) setTempFitnessIn: (double) tFitnessIn;
-(void) setTempFitnessOut: (double) tFitnessOut;
-(void) setTempExoFitness: (double) tExoFitness;
-(void) setTempFitness: (double) tFitness;
-(void) setProbMutate: (double) pMut;
-(void) setMutLatStepInitTransfer: (double) mStepInitT;
-(void) setMutLatStepDegree: (double) mStepDeg;
-(void) setMigrate: (int) mig;
-(void) setGroupMigrateFrom: (int) grMigFr;
-(void) setGroupMigrateTo: (int) grMigTo;
	
// procedural methods
-(void) assignRandomInitTransferIn;
-(void) assignRandomDegreeIn;
-(void) assignRandomInitTransferOut;
-(void) assignRandomDegreeOut;
-(void) calculateFitnessIn;
-(void) calculateFitnessOut;
-(void) calculateFitness;
-(void) updatePhenotypeFromTempIn;
-(void) updatePhenotypeFromTempOut;
-(void) updateFitnessValuesFromTemp;
-(void) implementMutationsIn;
-(void) implementMutationsOut;

@end