#import "ASMObserverSwarm.h"
#import <simtoolsgui.h>
#import "Parameters.h"

#include <misc.h>

@implementation ASMObserverSwarm

+ createBegin: aZone 
{
  ASMObserverSwarm *obj;
  id <ProbeMap> probeMap;

  obj = [super createBegin: aZone];
  obj->displayFrequency = 3;

  probeMap = [EmptyProbeMap createBegin: aZone];
  [probeMap setProbedClass: [self class]];
  probeMap = [probeMap createEnd];
 
  [probeMap addProbe: [probeLibrary getProbeForVariable: "displayFrequency"
				    inClass: [self class]]];
  [probeMap addProbe: [probeLibrary getProbeForMessage: 
		      "writeSimulationParams" inClass: [self class]]];
  [probeMap addProbe: [probeLibrary getProbeForMessage: 
		      "toggleDataWrite" inClass: [self class]]];

  //The member functions that allow you to print a graph. 
#if 0
  [probeMap addProbe: [probeLibrary getProbeForMessage: 
		      "printPriceGraph" inClass: [self class]]];
  [probeMap addProbe: [probeLibrary getProbeForMessage: 
		      "printVolumeGraph" inClass: [self class]]];
  //  [probeMap addProbe: [probeLibrary getProbeForMessage: 
  //	      "printDeviationGraph" inClass: [self class]]];
  [probeMap addProbe: [probeLibrary getProbeForMessage: 
		      "printRelWealthHisto" inClass: [self class]]];
#endif
  [probeLibrary setProbeMap: probeMap For: [self class]];

  return obj;
}

#if 0
- printPriceGraph
{
  [globalTkInterp eval: 
    "%s postscript output priceDump.eps -maxpect yes -decorations no",
    [priceGraph getWidgetName]];
  return self;
}


- printVolumeGraph
{
  [globalTkInterp eval: 
    "%s postscript output volumeDump.eps -maxpect yes -decorations no",
    [volumeGraph getWidgetName]];
  return self;
}

- printDeviationGraph
{
  [globalTkInterp eval: 
    "%s postscript output deviationDump.eps -maxpect yes -decorations no",
    [deviationGraph getWidgetName]];
  return self;
}


- printRelWealthHisto
{
  [globalTkInterp eval: 
    "%s postscript output relWealthDump.eps -maxpect yes -decorations no",
    [relativeWealthHisto getWidgetName]];
  return self;
}
#endif

- createEnd 
{
  return [super createEnd];
}


- buildObjects 
{
  int numagents;
  ASMModelParams * asmModelParams = [(id)arguments getModelParams];
  BFParams * bfParams = [(id)arguments getBFParams];

  [super buildObjects];

  //asmModelSwarm = [[ASMModelSwarm createBegin: self ] createEnd];
  
  asmModelSwarm = [ASMModelSwarm create: self];
  
  [asmModelSwarm setParamsModel: asmModelParams BF: bfParams];

  CREATE_ARCHIVED_PROBE_DISPLAY (asmModelParams);
  CREATE_ARCHIVED_PROBE_DISPLAY (self);


  [controlPanel setStateStopped];
  [asmModelSwarm buildObjects];

  // numagents = [asmModelSwarm getNumBFagents];
  numagents = asmModelParams->numBFagents;
  position = xcalloc (numagents, sizeof (double));
  wealth = xcalloc (numagents, sizeof (double));
  //cash = xcalloc (numagents, sizeof (double));
  relativeWealth = xcalloc (numagents, sizeof (double));

  priceGraph = [EZGraph create: self setTitle: "Price v. time"
			setAxisLabelsX: "time" Y: "price"
			setWindowGeometryRecordName: "priceGraph"];
  [priceGraph enableDestroyNotification: self
	      notificationMethod: @selector (_priceGraphDeath_:)];
  [priceGraph createSequence: "actual price" 
	      withFeedFrom: [asmModelSwarm getWorld]
	      andSelector: M(getPrice)];
  [priceGraph createSequence: "risk neutral price"
	      withFeedFrom: [asmModelSwarm getWorld]
	      andSelector: M(getRiskNeutral)];
  

  volumeGraph = [EZGraph create: self setTitle: "Volume v. time"
			setAxisLabelsX: "time" Y: "volume"
			setWindowGeometryRecordName: "volumeGraph"];
  
  [volumeGraph createSequence: "actual price"
	       withFeedFrom: [asmModelSwarm getSpecialist]
	       andSelector: M(getVolume)];
  
  [priceGraph enableDestroyNotification: self
	      notificationMethod: @selector (_volumeGraphDeath_:)];

  positionHisto = [Histogram createBegin: [self getZone]];
  SET_WINDOW_GEOMETRY_RECORD_NAME (positionHisto);
  [positionHisto setBinCount: numagents];
  positionHisto = [positionHisto createEnd];

  [positionHisto setWidth: 500 Height: 250];
  [positionHisto hideLegend];
  [positionHisto setTitle: "Agent Position"];
  [positionHisto setAxisLabelsX: "agents" Y: "position"];
  [positionHisto pack];

  //Again, you can add this back.
  //cashHisto = [Histo create: [self getZone]];
  //[cashHisto setWidth: 500 Height: 250];
  //[cashHisto setNumPoints: numagents  Labels: NULL  Colors: NULL];
  //[globalTkInterp eval: "%s legend configure -mapped no", 
  //		  [cashHisto getWidgetName]];
  //[cashHisto title: "Agent Cash Holdings"];
  //[cashHisto axisLabelsX: "agents" Y: "cash holding"];
  //[cashHisto pack];

  relativeWealthHisto = [Histogram createBegin: [self getZone]];
  SET_WINDOW_GEOMETRY_RECORD_NAME (relativeWealthHisto);
  [relativeWealthHisto setBinCount: numagents];
  relativeWealthHisto = [relativeWealthHisto createEnd];

  [relativeWealthHisto setWidth: 500 Height: 250];
  [relativeWealthHisto hideLegend];
  [relativeWealthHisto setTitle: "Relative Wealth of Agents"];
  [relativeWealthHisto setAxisLabelsX: "agents" Y: "relative wealth"];
  [relativeWealthHisto pack];

  //Only interesting to compare multiple agents.
  //deviationGraph = [Graph createBegin: [self getZone]];
  //SET_WINDOW_GEOMETRY_RECORD_NAME (deviationGraph);
  //deviationGraph = [deviationGraph createEnd];
 
  //[deviationGraph setTitle: "Mean Abs Dev of Different Agents"];
  //[deviationGraph setAxisLabelsX: "time" Y: "mean abs dev/actual p+d"];
  //[deviationGraph setRangesYMin: 0.0 Max: 200.0];
  //[deviationGraph pack];

  
  //deviationData = [deviationGraph createElement];
  //[[deviationData setLabel: "BF"] setColor: "green"];

  //deviationAverager = [Averager createBegin: [self getZone]];
  //[deviationAverager setCollection: [asmModelSwarm getAgentList]];
  //[deviationAverager setProbedSelector: M(getDeviation)];
  //deviationAverager = [deviationAverager createEnd];
      
  //deviationGrapher = [ActiveGraph createBegin: [self getZone]];
  //[deviationGrapher setElement: deviationData];
  //[deviationGrapher setDataFeed: deviationAverager];
  //[deviationGrapher setProbedSelector: M(getAverage)];
  //deviationGrapher = [deviationGrapher createEnd];
    
  return self;
}

- priceGraphDeath_ : caller
{
  [priceGraph drop];
  priceGraph = nil;
  return self;
}

- volumeGraphDeath_ : caller
{
  [volumeGraph drop];
  volumeGraph = nil;
  return self;
}

- updateHistos
{
  id index;
  id agent;
  int i;
   
  index = [[asmModelSwarm getAgentList] begin: [self getZone]];
    
  for(i=0; (agent = [index next]); i++)
    {
      position[i] = [agent getAgentPosition];
      wealth[i] = [agent getWealth];
      //cash[i] = [agent getCash];
      relativeWealth[i] = wealth[i]/[asmModelSwarm getInitialCash];
      //profit[i] = [agent getProfit];
    }
  [index drop];
  [positionHisto drawHistogramWithDouble: position];
  //[cashHisto drawHistoWithDouble: cash];
  [relativeWealthHisto drawHistogramWithDouble: relativeWealth];

  return self;
}
   

- writeSimulationParams
{
  writeParams = 1;
  [[asmModelSwarm getOutput] writeParams: [(id) arguments getModelParams] BFAgent: [(id) arguments getBFParams] Time: [asmModelSwarm getModelTime]];
 
  return self;
}


- expostParamWrite
{
  // [asmModelSwarm initOutputForParamWrite];
  if (writeParams == 1)
    [[asmModelSwarm getOutput] writeParams: [(id) arguments getModelParams] BFAgent: [(id) arguments getBFParams] Time: getCurrentTime()]; 
  return self;
}


- (BOOL)ifParamWrite
{
  return writeParams;
}


-(BOOL) toggleDataWrite
{
   if(writeData != YES)
     {
       [[asmModelSwarm getOutput] prepareOutputFile];
	 writeData = YES;
     }
   else
     writeData = NO;

   return writeData;
}



- _writeRawData_
{
  if (writeData == YES)
    [[asmModelSwarm getOutput] writeData];
   fprintf(stderr,"getcurrent %ld modeltime %ld",getCurrentTime(),[asmModelSwarm getModelTime]);
  return self;
}



- buildActions 
{
  [super buildActions];

  [asmModelSwarm buildActions];

  displayActions = [ActionGroup create: [self getZone]];

  [displayActions createActionTo: self 
		    message: M(_writeRawData_)];
  [displayActions createActionTo: self             message: M(updateHistos)];
  [displayActions createActionTo: priceGraph    message: M(step)];
  //  [displayActions createActionTo: riskNeutralGrapher     message: M(step)];
  [displayActions createActionTo: volumeGraph    message: M(step)];
  //[displayActions createActionTo: deviationAverager     message: M(update)];
  //[displayActions createActionTo: deviationGrapher     message: M(step)];
  [displayActions createActionTo: probeDisplayManager      
		  message: M(update)];
  [displayActions createActionTo: actionCache message: M(doTkEvents)];

  displaySchedule = [Schedule createBegin: [self getZone]];
  [displaySchedule setRepeatInterval: displayFrequency];
  displaySchedule = [displaySchedule createEnd];
  [displaySchedule at: 0 createAction: displayActions];
 
  return self;
}

- activateIn: swarmContext 
{
  [super activateIn: swarmContext];
  [asmModelSwarm activateIn: self];

  [displaySchedule activateIn: self];

  return [self getSwarmActivity];
}

@end


