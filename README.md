# Source
All code and material is drawn from http://artstkmkt.sourceforge.net 
This repo is a conversion of the CVS repository available at that address. 

# Purpose
SFI-ASM is a captivating, enigmatic thing. My interest is first the  preservation of the historical artifact, second the understanding of them model, and third the understanding of the academic-historical context of the model's creation.  
To that end, this repository tracks the source code through all of the releases I can find, and will try to modify the code and codify its environment sufficiently s.t. it can be built on a well specified VM.

# SFI-ASM
The Sante Fe Institute Artificial Stock Market is a description of a agent-based model of a stock market.  It has been realized in a few different implementations, which this repository aims to collect and enhance. 

The model itself was first described by Palmer et al. (1994)

## Artstkmkr

```
Group/Project Resource Page lists all resources available for this project.
Several articles* have been published using the Artificial Stock Market model. The model simulates prices & trade levels in a market made up of "artificial adaptive agents." This is a prototype example of a "complex system" and is thought to illustrate the benefits of simulation modeling.

This page is dedicated to the revision/updating/enhancement of the Swarm version of the ASM. The first objective was to bring the ASM code--as released in April, 2000, with the version label 2.0--up to date and into conformance with Swarm programming style and recommendations for Swarm 2.1. That was achieved with ASM-2.2, which represents a substantially reworked and enhanced version of the model. Actually, ASM-2.2 went a bit further than that, because it (optionally) uses some hdf5 data storage features that were supported only in Swarm after 2.1.1 (prerelease snapshots of Swarm-2.2). The next step, ASM-2.4, includes the addition of a number of new features, including serialization (ability to stop and restart a model). ASM-2.4 now performs, as far as Thomas Badegruber and I can tell, in a way that replicates the original Santa Fe Stock Market. See the Swarm community links page for release info.

In case you wonder what a Swarm program looks like while it runs, I have a directory of screenshots!, such as screenshots/asm-20000530.gif . The newest version, ASM-2.4, looks like this: screenshots/asm-20030606.png on my RedHat Linux system.
```

# References 
Arthur, W. Brian, John H. Holland, Blake LeBaron, Richard G. Palmer, and Paul Tayler. "Asset pricing under endogenous expectations in an artificial stock market." Available at SSRN 2252 (1996).

Ehrentreich, Norman. "A corrected version of the santa fe institute artificial stock market model." Complexity (2003).

Ehrentreich, Norman. Agent-based modeling: The Santa Fe Institute artificial stock market model revisited. Vol. 602. Springer Science & Business Media, 2007.

LeBaron, Blake, W. Brian Arthur, and Richard Palmer. "Time series properties of an artificial stock market." Journal of Economic Dynamics and control 23, no. 9 (1999): 1487-1516.

LeBaron, Blake. "Building the Santa Fe artificial stock market." Physica A (2002).

Palmer, Richard G., W. Brian Arthur, John H. Holland, Blake LeBaron, and Paul Tayler. "Artificial economic life: a simple model of a stockmarket." Physica D: Nonlinear Phenomena 75, no. 1 (1994): 264-274.


# Original Readme (ASM-2.4):
```
Swarm ASM notes.  If you are looking for highlights, this
is the right spot.

Paul Johnson <pauljohn@ku.edu>

ASM-2.4 June 2003

This version requires Swarm-2.1.143 or newer. If you don't have 
that, you will have to disable serialization features and compile
without using HDF5 data output.

Thomas Badegruber <thomas.badegruber@uni-graz.at> visited here in
Kansas in March and then went to Boston to work with Blake
LeBaron. That re-energized me on this project.  Thomas is now a full
contributor to the CVS archive on Sourceforge.  We have made changes
to improve functionality, fix bugs, and make the genetic algorithm
code more easy to read and extend. And, perhaps most importantly, we
can now re-produce the finding that there is a major difference in the
usage of technical and fundamental bits when the agent use of the
genetic algorithm is made more frequent. That is to say, when agents
use the GA every 250 periods, they are substantially more likely to
use technical trading information than if they update every 1000
periods.  Because this behavior is now reproduced, we are confident
that the Swarm-ASM behaves in the same way in all substantial ways as
the Next/Objective-C models presented in the literature.

Functionality enhancements

* Graph showing usage of funamental bits, technical bits, and dummy
bits full model serialization.

* Serialization: Simulation can be saved in a "snapshot" and restarted.

* Parameter values have been reset to match the ones used in
publications.

* Uses enhancements in Swarm's EZGraph (changes introduced since
Swarm-2.1.1) to save output data as vectors in HDF5 files.  This
significantly enhances usage of output data files in statistical
analysis programs.

Bug fixes / code changes (see ChangeLog for details, or persue
the patch from ASM-2.2 to ASM-2.4.)

* closed memory leakes caused by use of probes in the getDouble()
function in BFParams.m.

* revised some of the scheduling apparatus to make the model run
faster.

* Fixed a misplaced bracked in BFagent's MakePool method.  This
was discovered and corrected by Thomas Badegruber. It significantly
affects the performance of the genetic algorithm over the long run.

* Coding for graphs and data output of hdf5 vectors for time plots
was reorganized, significanly simplifying the shift from GUI to nonGUI
models.  Look in Output.m


ASM-2.2 November 2001

This work was mainly aimed at documentation, inserting Autodoc markers
so I can build nicer looking documentation.

The only big substantive cleanup was in ASMModelSwarm.  I had been
avoiding this for a long time because the scheduling that was used was
very complicated and hard to understand.  I succeeded in a major
simplicification and cleanup and have verified the numerical results
are identical. This is explained in the beginning of ASMModelSwarm.m

There was also a "procedural" cleanup of the code in World.m.  The old
version had a lot of callocs and other memory magic because it was
keeping moving averages "by hand".  This has been changed. There is
now a MovingAverage class that is used to do that magic, so the code
in World.m is much easier to read.

There is much less low level math floating around.

SNAP3: ASM 20011024 October 2001

The aim has been to bring this model into convenient Swarm standards.
Actually, the real aim has been to make ASM an effective teaching tool
and an example of good simulation coding practice.  Part of that is a
modernization of the data handling, both the input of parameter
values, and record keeping of parameter values, as well as the saving
of data.  One of my pet peeves about Swarm is that we do not have a
standard, idiot proof way to keep records on the settings and results
are for a particular run.  We also don't have fool proof ways to
interate models and run simulations over again.  The first problem is
dealt with here in the Output class, and the second one is dealt with
by the creation of a Parameter class, where we could manage command
line parameters if we wanted to.

1. Inputting Parameter Values.

First, note the big parameter input file "asm.scm".  This has the
initial values for three classes, bfParams, asmModelParms, and
asmBatchParams.  This data is "called" to create the classes, you have
to stare at it a while to get used to it.  Where we used to have the
createBegin/createEnd routine for a class, now we've got this
different thing that creates a class and initializes its ivars for us,
like so

asmModelParams =[lispAppArchiver getWithZone: self key: "asmModelParams"])

The asmModelParms class is a new parameter-holding/setting class for
the values of the model level. The BFParams class is parameters used 
by the BFAgents.

The advantage of putting these parameter settings in separate files is
that those files can be edited and the model re-run without
recompiling the program.  I've never seen a working example, but it
seems logical enough a person could write a program to pump out an
.scm file, then run the model, then write the .scm file, run the
model, etc.

It is more within my background, instead, to pass command line
arguments to the model in order to vary parameters or get runs with
different seeds.  That's why I've introduced a Parameters class, which
can handle both command line arguments and it also orchestrates the
creation of objects for BFParams and ASMModelParams. If we ever wanted
to set command line parameters with this model, we would do it here.
  
Both BFParams and the ASMModelParams classes are created in the
Parameters class, and are then passed to the ASMObserverSwarm, and
then into model swarm.  I did this to keep the user interface
consistent with the original ASM-Swarm model.

2. Outputting Results.

I've done my best to consolidate and simplify all data writing into
the Output class. Simply put, nothing should get written unless Output
handles it.  

To show the possible data output tools, I have 3
different ways of saving the output time streams from the model.  All
three should be similar/equivalent representations of the numbers.

1) Text output of data streams.
2) HDF5 or LISP format output of object dumps from a "putShallow"
   call to a data archiver object. This dumps full snapshots of
   the world and the specialist into a LISP on hdf5 archive.
3) HDF5 output EZGraph which writes one vector per plotted line
   into an hdf5 file.

This code has a preprocessor flag to control the behavior of data
storage. If compile without any CPP flags, then the data files are
saved in the .scm format, which is "scheme".  Otherwise, use the flag
NO_LISP, and it uses hdf5 format. In Swarm, that means you type the
make command:

 make EXTRACPPFLAGS=-DNO_LISP

The buttons in the ASMObserverSwarm display turn on data saving.  Look
for "writeSimulationParams" and the other "toggleDataWrite".  These
were in the original ASM Swarm model, but I've replaced the
functionality with the newer storage methods.  The data is saved only
if you turn on the writeData option. If "toggleDataWrite" is empty or
false, hit that button and it shows "true". When the model runs,
output will be created. If you run the program in batch mode, it
automatically turns on the data writing.
 
Please note that if you want the simulation to save your parameter
values to a file, you can click the GUI button
"writeSimulationParams." If you push that button, the system writes
the parameter values into a file, such as

guiSettingsThu_Jun_28_23_48_00_2001.scm

if you did not compile with the NO_LISP flag.  Otherwise you get a
.hdf file.  One key change from the old ASM is that you can push that
button at time 0, and it will save a snap at that time, and any time
you stop the model, you can change parameters and punch the button
again, and it will also save a snapshot at quit time.  I believe this
works fine now, but it was a little tricky making sure the objects are
created in the right order and early enough to allow this to work.

Now, just a word about data formatting.  Because it is familiar and
compatible with existing programs, I often prefer to save data in raw
ASCII format.  In case you want text output, this shows you how to do it.
I think filenames that have the date in them are good to
help remember when they were originally created, for example.  It
creates an ASCII file, for example,

output.data_Thu_Jun_28_23_48_00_2001 

However, I understand the reasons others are pushing to use more
refined formats.  Many people are digging into hdf5 format for data
storage, and I've taken a look at that too.  I took the easy road and
just dumped the whole world and specialist class with swarm's
archiver. It seems to work great?!  The output file is called
something like

swarmDataArchiveFri_Jun_29_16_29_25_2001.hdf
or
swarmDataArchiveFri_Jun_29_16_22_59_2001.scm

You note here that output uses the current time and date to write the
output file names. Today I ran an example and ended up with these
three files of output:

output.dataWed_Oct_24_11_30_18_2001
swarmDataArchiveWed_Oct_24_11_30_18_2001.scm
hdfGraphWed_Oct_24_11_30_18_2001.hdf 





SNAP2: ASM 20000602 June 2, 2000
Thorough workover of BFagent class, creating three new classes (BitVector,
BFParams, and BFCast)  and a massive reorganization of BFagent itself.
See long comment in BFagent.m.




SNAP1: May 7, 2000
In ASM-new-snap1, I've removed the random.h and random.m from this
program, and replaced their functionality with Swarm library
calls. Contrary to the statements below, this program should now
behave like a Swarm app. Every time you run it,  you get the same
random seed, unless you use the command line switch or input a
randomSeed of your own.	



-------original readme follows
This is the port to Swarm of the original NeXTstep version of
the Brian Arthur, John Holland, Blake LeBaron, Richard Palmer, and
Paul Tayler Artificial Stock Market.  The port was done in the Summer
of 1996 and has been updated to include some recent adjustments in
Swarm in the Summer of 1997.  Regardless, there are a number of Swarm
advancements (e.g., EZGraph) that have not been utilized in the
current code.  It does include, however, the much needed and
appreciated -batchmode option.
	The port is a slimmer version of the original done in straight
Objective-C for the NeXTstep platform.  There is a non-graphic version
available from the authors, but the Swarm version should satisfy most
given the ease with which it can be altered.  The port was done by
Brandon Weber, a 1996 Summer intern.  For questions regarding the
Swarm ASM he can be contacted at weber@santafe.edu.  All other
questions regarding the original version, specific aspects of the
model, or published works should be directed to Richard Palmer at
palmer@santafe.edu.
	It should also be noted that this version includes only one
type of agent, the BFagent (bit forecasting agent), which learns via a
classifier system of John Holland.  It also has a built in Genetic
Algorithm.  Brandon Weber developed another agent, which learns using
an Artificial Neural Network.  The ANN itself is very simple, but
comparisons between the agent types are interesting.  The original
NeXTstep version contained several other types, all considerably more
simple-minded than the BFagent.  Part of the goal of this simulation
is that users develop their own agents.  For those who wish, they can
contact Brandon Weber for information on adding an agent (or for the
code that includes the ANNagent).  It is not difficult and only
requires additions to a select number of places in the code.
	I include a brief explanation of each of the programs modules.
This is by no means even remotely extensive, but should give some
sense of where things happen in the dense world of the ASM.  First it
would be wise to briefly explain what happens in the ASM.  Agents are
trading one asset but have the option of placing their money in what
is basically a bank account with a riskless return.  The agents make a
decision in each trading period how much to buy and sell based on
their prediction of the next period's price+dividend.  The dividend
process is AR(1) and the trading is managed by a Specialist that
attempts to match buys and sells.  How an agent predicts depends on
what type of agent it is.  As was mentioned, this release carries only
a bit-forecasting agent.  For specifics on the mathematics of the
asset model, one must see the published works of the above authors.  A
book is coming out shortly with the main paper on this simulation.
Contact Richard Palmer.  With that, the different objects are as
follows.

1) The Agent superclass (a swarmobject) has elements that all agent
types will have.  The BFagent is of type Agent, and any new agent that
might be developed would also be of type Agent.  This module includes
variables such as demand, initialcash, etc. and member functions such
as -prepareForTrading, -setInitialCash, +setAgentWorld, etc.  Since
all agents in this world are trading an asset, they all have these
types of functions and variables in common.

2) The BFagent is super complex.  Most of this code has not been
changed to be more Swarm friendly than the original version.  To
understand this agent you are encouraged to look at the published
material of the above authors or to direct specific questions at
Richard Palmer or Brandon Weber.  Basically each agent has a number of
equal in length bit-vectors of technical trading rules (where one bit
might be the rule, say, price is greater than the 20-day moving
average of price).  In other words, each vector represents some
collection of rules that a real trader might use.  In each trading
period these rules are compared with the world's bit-vector, which
includes all the possible trading rules.  The vectors that have all
its rules matching-up with the state of the world are considered
candidates for use in predicting price+dividend.  The one that has
been most successful in the past (i.e., has been able to best predict
the price+dividend) is used.  Over time the rules are morphed via
Genetic Algorithm and in turn better vectors are developed.

3) The World holds the big-bad bitvector of rules.  In turn it also
holds information on dividend (despite the fact that the Dividend
object generates the dividend payment) and price (despite the fact
that the Specialist object works to establish the price).  Whenever
the dividend is generated and the price is reached in a period the
World is given that information and it's its to keep for eternity.

4) The Dividend object simply controls the AR(1) process that
generates dividend payments.

5) The Specialist negotiates the trading of the asset. There are three
types of Specialist: the RE Specialist, or Rational Expectations
Specialist, the SP Specialist, or Slope Specialist, and the ETA
Specialist, or ETA Specialist (I forget the meaning of ETA, but it
will be explained).  The RE Specialist is meant only to check whether
this simulation will reach the typical Rational Expectations
equilibrium.  One point of this whole project is to check whether
seemingly real world behavior can be endogenously generated by
granting sufficient heterogeneity to agents that are based on a RE
framework.  But for this to even be testable the agents (when made to
be homogeneous) should come to a RE equilibrium.  The RE specialist is
used only for this purpose.  No matter the Specialist, each agent
reports to the Specialist how much it intends to buy, sell, or sell
short.  The RE specialist simply equalizes supply and demand should
they be different.  As a result the boring behavior we expect arises.
The SP Specialist also receives from the agents the slope of their
demand curves.  In turn the Specialist knows how to change the price
to best equalize supply and demand and can do this in one or two
iterations.  The ETA specialist changes the price using a parameter
incidentally called eta.  In each trading period there are several
iterations of this adjustment process until the difference between
supply and demand is sufficiently small.

6)  The ASMModelSwarm orchestrates this magic.  

7) The ASMObserverSwarm puts pretty pictures on the screen.  Note that
you have the option of printing all the graphs as well as writing data
and the simulation parameters.  To write the data you must click on
the -writeData button before the simulation begins or else nothing
will happen.  You can click on the -writeParams button at any time.
The parameters and data are written to a time-dated param.data and
output.data file respectively.  Note that the default setting for the
random seed in the window where you can set the parameters is zero.
This means that the seed is randomly generated.  If you want to repeat
a run you must write the params and use the random seed that you find
in the param.data_somedate_sometime file.

8) The writing of data and parameters is controlled by the Output
module.  Output knows learns the parameters in the ASMModelSwarm.  It
learns the price, dividend, etc. from the World.

9) ASMBatchSwarm controls the batch stuff.  To run just type 'asm
-batchmode'.  Note that to do this you need a batch.setup file which
includes the loggingFrequency and the experimentDuration.  These are
also set in the ASMBatchSwarm itself but can be changed in batch.setup
without recompiling.  The file that loads in the parameters is called
param.data.  When you click on -writeParams running in GUI mode the
file param.data_somedate_sometime is in the proper format to be a
param.data file that is loaded in batchmode.  In turn you can just
move param.data_somedate_sometime to param.data and you're good to run
the same simulation again in batchmode.  Also, when you run in
batchmode parameters and data are written to their respective
time-dated files automatically.

10) Random is one unfortunate holdover from the old version.  Last
summer (1996) there was not a double random generator so I stuck to
the original NeXTstep version's.  Now Swarm has one but I didn't have
time to make the changes.

11) Main is main.  You might wonder why the parameter writing is done
in here.  It is because this is the only way to assure that the params
are written at the end of the simulation.  This is done for two
reasons.  One is that the params can conceivably change throughout a
simulation and in turn they should be written at the end.  Second, of
you click on -writeParams before you say -go, it is also before an
instance of the object Output has been created.  Output must exist for
the params to be written.

This is cursory at best, but you are all probably better people than
me, so you can figure the rest out with the help of some strategically
placed questions to either Palmer or Weber.  Enjoy.
```
