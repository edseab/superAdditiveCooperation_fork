/* Copyright 2023, Charles Efferson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

#import <Foundation/Foundation.h>
#import <gsl/gsl_rng.h>
#import <gsl/gsl_randist.h>

@interface ContGroupAgent : NSObject {
	
	double initTransferIn;			// in-group case, agent's initial transfer, if first mover, during the initial interaction; normalized to be in the [0,1] interval
	double intLeftIn;				// in-group case, the left intercept of the agent's response function, i.e. the action taken if the most recent action of the agent's partner was 0
	double intRightIn;				// in-group case, the right intercept of the agents response function, i.e. the action take in the most recent action of the agent's partner was 1 (the maximum)
	double expIn; 					// in-group case, controls shape of response function
	double tempInitTransferIn; 		// in-group case, used for updating values at the end of each generation
	double tempIntLeftIn;		 	// in-group case, same
	double tempIntRightIn;	 		// in-group case, same
	double tempExpIn;				// in-group case, same
	
	double initTransferOut;			// out-group case, agent's initial transfer, if first mover, during the initial interaction; normalized to be in the [0,1] interval
	double intLeftOut;				// out-group case, the left intercept of the agent's response function, i.e. the action taken if the most recent action of the agent's partner was 0
	double intRightOut;				// out-group case, the right intercept of the agents response function, i.e. the action take in the most recent action of the agent's partner was 1 (the maximum)
	double expOut;					// out-group case, controls shape of response function
	double tempInitTransferOut; 	// out-group case, used for updating values at the end of each generation
	double tempIntLeftOut;		 	// out-group case, same
	double tempIntRightOut;	 		// out-group case, same
	double tempExpOut;				// out-group case, same
	
	int partnerIn;					// in-group case, the index of the agent's partner
	double partnerInitTransferIn;	// in-group case, analogous to agent's initTransfer
	double partnerIntLeftIn;		// in-group case, analogous to agent's intLeft
	double partnerIntRightIn;		// in-group case, analogous to agent's intRight
	double partnerExpIn;			// in-group case, analogous to agent's exp
	
	int partnerOut;					// out-group case, the index of the agent's partner, i.e. the index for this out-group partner within the out-group partner's own group
	double partnerInitTransferOut;	// out-group case, analogous to agent's initTransfer
	double partnerIntLeftOut;		// out-group case, analogous to agent's intLeft
	double partnerIntRightOut;		// out-group case, analogous to agent's intRight
	double partnerExpOut;			// out-group case, analogous to agent's exp
	
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
	double partnerFitnessIn;		// record ingroup partner's fitness value at time of interaction => convenient way to couple a sequence of errors for two matched players in method for focal agent and then copy to partner => do not have to rewrite main.m extensively to add errors
	double partnerFitnessOut;		// record outgroup partner's fitness value at time of interaction => convenient way to couple a sequence of errors for two matched players in method for focal agent and then copy to partner => do not have to rewrite main.m extensively to add errors
	double exoFitness;				// exogenous fitness for agent (and everyone else)
	double weightEndoFitness;		// weight on endogenous fitness
	double fitness;					// (1 - weightEndoFitness) * exogenous fitness + weightEndoFitness * endogenous fitness for agent associated with all interactions being modeled
	double fitnessAsCumProp; 		// fitness as a cumulative proportion of the sum over all fitnesses in population; used for updating phenotypes
	
	double tempFitnessIn;			// used for migration algorithm when it comes after game play
	double tempFitnessOut;			// used for migration algorithm when it comes after game play
	double tempExoFitness;			// used for migration algorithm when it comes after game play
	double tempFitness;				// used for migration algorithm when it comes after game play
	
	double probMutate;					// probability of mutating in either of the three dimensions (i.e. initTransfer, intLeft, or intRight)
	double mutLatStepInitTransfer;		// if a mutation occurs w.r.t. initTransfer, it's either up or down by this quantity
	double mutLatStepIntercepts;		// if a mutation occurs w.r.t. intLeft or intRight, it's either up or down by this quantity
	double mutLatStepExp;				// if a mutation occurs w.r.t. exp, it's either up or down by this quantity
	
	int migrate;						// a dummy indicating if agent migrated
	int groupMigrateFrom;				// idx for group of origin
	int groupMigrateTo;					// idx for group migrates to
	
	double stdDev;						// std deviation for error distribution
}

// getters
-(double) initTransferIn;
-(double) intLeftIn;
-(double) intRightIn;
-(double) expIn;
-(double) tempInitTransferIn;
-(double) tempIntLeftIn;
-(double) tempIntRightIn;
-(double) tempExpIn;
-(double) initTransferOut;
-(double) intLeftOut;
-(double) intRightOut;
-(double) expOut;
-(double) tempInitTransferOut;
-(double) tempIntLeftOut;
-(double) tempIntRightOut;
-(double) tempExpOut;
-(int) partnerIn;
-(double) partnerInitTransferIn;
-(double) partnerIntLeftIn;
-(double) partnerIntRightIn;
-(double) partnerExpIn;
-(int) partnerOut;
-(double) partnerInitTransferOut;
-(double) partnerIntLeftOut;
-(double) partnerIntRightOut;
-(double) partnerExpOut;
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
-(double) partnerFitnessIn;
-(double) partnerFitnessOut;
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
-(double) mutLatStepIntercepts;
-(double) mutLatStepExp;
-(int) migrate;
-(int) groupMigrateFrom;
-(int) groupMigrateTo;
-(double) stdDev;

// setters
-(void) setInitTransferIn: (double) initT_in;
-(void) setIntLeftIn: (double) intL_in;
-(void) setIntRightIn: (double) intR_in;
-(void) setExpIn: (double) exp_in;
-(void) setTempInitTransferIn: (double) tInitT_in;
-(void) setTempIntLeftIn: (double) tIntL_in;
-(void) setTempIntRightIn: (double) tIntR_in;
-(void) setTempExpIn: (double) tExp_in;
-(void) setInitTransferOut: (double) initT_out;
-(void) setIntLeftOut: (double) intL_out;
-(void) setIntRightOut: (double) intR_out;
-(void) setExpOut: (double) exp_out;
-(void) setTempInitTransferOut: (double) tInitT_out;
-(void) setTempIntLeftOut: (double) tIntL_out;
-(void) setTempIntRightOut: (double) tIntR_out;
-(void) setTempExpOut: (double) tExp_out;
-(void) setPartnerIn: (int) part_in;
-(void) setPartnerInitTransferIn: (double) partInitT_in;
-(void) setPartnerIntLeftIn: (double) partIntL_in;
-(void) setPartnerIntRightIn: (double) partIntR_in;
-(void) setPartnerExpIn: (double) partExp_in;
-(void) setPartnerOut: (int) part_out;
-(void) setPartnerInitTransferOut: (double) partInitT_out;
-(void) setPartnerIntLeftOut: (double) partIntL_out;
-(void) setPartnerIntRightOut: (double) partIntR_out;
-(void) setPartnerExpOut: (double) partExp_out;
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
-(void) setPartnerFitnessIn: (double) p_fit_in;
-(void) setPartnerFitnessOut: (double) p_fit_out;
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
-(void) setMutLatStepIntercepts: (double) mStepInt;
-(void) setMutLatStepExp: (double) mStepExp;
-(void) setMigrate: (int) mig;
-(void) setGroupMigrateFrom: (int) grMigFr;
-(void) setGroupMigrateTo: (int) grMigTo;
-(void) setStdDev: (double) sd;
	
// procedural methods
-(void) assignRandomInitTransferIn;
-(void) assignRandomInterceptsIn;
-(void) assignRandomExpInBetween: (double) lowerBound and: (double) upperBound;
-(void) assignRandomInitTransferOut;
-(void) assignRandomInterceptsOut;
-(void) assignRandomExpOutBetween: (double) lowerBound and: (double) upperBound;
-(void) calculateFitnessIn: (gsl_rng *) r;
-(void) calculateFitnessOut: (gsl_rng *) r;
-(void) calculateFitness;
-(void) updatePhenotypeFromTempIn;
-(void) updatePhenotypeFromTempOut;
-(void) updateFitnessValuesFromTemp;
-(void) implementMutationsIn;
-(void) implementMutationsOut;

@end
