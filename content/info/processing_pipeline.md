---
title: "Data Processing Pipeline"
author: "Joanna Morris"
date: '2023-06-13'
draft: no
image: img/info/pipeline_2.jpg
showonlyimage: no
slug: data-processing-pipeline
---

The following presents an outline of the pre-processing pipeline. ERP data analysis involves many processing steps.

<!--more-->

 The order in which these steps should be performed [depends on whether a given processing step involves a *linear* or *nonlinear* operation](https://erpinfo.org/order-of-steps).  The following pipeline is adapted from those followed by a number of ERP labs with which I have collaborated in the past.

We use the MATLAB toolboxes EEGLAB and ERPLAB for processing our data.
[EEGLAB](https://sccn.ucsd.edu/eeglab/index.php) is an iteractive GUI-based Matlab toolbox for processing electrophysiological data. [ERPLAB](https://erpinfo.org/erplab) is a free, open-source Matlab package that extends EEGLAB’s capabilities for ERP processing, visualization, and analysis. Because ERPlab has been designed as a plug-in to EEGlab adding many useful analysis and visualization tools and meaning that many of its functions interact directly with the EEG data structure used by EEGlab.

* EEGLAB uses a data structure called `EEG` to store the EEG data and associated information from a single recording session. This structure is inherited and extended by ERPLAB, and an analogous structure called `ERP` is used by ERPLAB to store averaged ERP waveforms.  ERPLAB also uses an `EVENTLIST` structure that provides a link between the `EEG` and `ERP` structures. These data structures are at the core of the operation of ERPLAB. 

* EEGLAB defines the concept of a **dataset**, which is essentially a pointer to an [EEG structure](https://eeglab.org/tutorials/ConceptsGuide/Data_Structures.html#introduction). That is, many datasets can be loaded into EEGLAB, each of which contains the information from a previous instance of the EEG structure, but only one is "active" at a given time (and is accessed via the EEG structure).

* The  `filename.set` file is what EEGLAB calls a 'dataset'. It comprises the *metadata* for the EEG data. The associated file, `filename.fdt`, contains the actual EEG data points and must be present (but which is accessed indirectly). (**Note**:  In EEGLAB 2021 the default is now a *single* `.set` file that contains both the data (`.fdt` file) and the metadata (`.set` file). We will upgrade all the lab computers to EEGLAB 2021 in due course.  But note that you may have one file or two depending on which version of EEGLAB was being run at the time the dataset was created.)

* Each processing step typically operates on the current dataset, creates a new dataset based on some set of operations, and then makes the new dataset the current dataset.

* All of the loaded datasets are available from the Datasets menu (see screenshot below), which allows the user to select which dataset is the current dataset (and therefore available from the EEG structure).  This allows the user to apply a series of processing steps to a set of EEG data, save the intermediate steps as cached datasets (with or without storing them as files on disk) and then quickly move back and forth between them.

* ERPLAB uses a similar set of conventions to store and manipulate averaged ERP waveforms.

### Part I: Creating ERP files from EEG files

#### 1. Open MATLAB

* Double click on the MATLAB icon on the desktop

#### 2. Load the data

* Invoke EEGLAB by typing  `eeglab`  at the Matlab command prompt and pressing `ENTER`.


* Select  `File ➞ Import Data ➞ Using EEGLAB functions and plugins ➞ From Brain Vis. Rec. .vhdr file`

* Select the appropriate `.vhdr` file from your computer. This will import a `.vhdr` file into EEGLAB, where it becomes a *dataset*, with a `.set` file extension.

* IMPORTANT: If you change the name of the file after recording you will need to change the filename in the `.vhdr` and `.vmrk`  files to match the new filename.  You can do this easily using any text editor program.

* Leave the `Interval` option and `Channels` options blank. By default this will import all channels and all samples.

* When saving your file use the `BROWSE` button to navigate to the appropriate directory before saving

* Save your file as  `EID_S###` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`)

#### 3. Once you have imported the raw EEG, you should view it to make sure everything looks OK.

Select  `Plot > Channel data (scroll)`
  
* To see all the electrode traces you may need to remove the DC offset by selecting  `Display > Remove DC Offset`
  
*  To **increase** the scale of the voltage and hence decrease the size of the amplitudes on the screen, or to **decrease** the voltage scale and hence increase the size of the EEG amplitude on the screen you can enter a value into  “Scale” edit-text box value (you can also click on the ”-“ or "+" button) and press the Enter key to update the scrolling window.

* To adjust the time time range displayed select  `Settings >  Time range to display`  and enter the desired window length in seconds.
  

#### 4. Filter the data

* Filters are a form of controlled distortion. The more heavily you filter your data, the more you are distorting the data. However, mildly filtering the data removes a great deal of noise while causing minimal distortion, making it  worthwhile.  *In most cognitive experiments you will increase your statistical power by filtering the low frequencies with a cutoff of ~0.1 Hz and by filtering the high frequencies with a cutoff of ~30 Hz.*

* You should filter the continuous EEG data, **before epoching or artifact removal**. Filtering the continuous data minimizes the introduction of filtering artifacts at epoch boundaries.

* Use a bandpass filter of .1 (high pass) to 30 Hz (low pass). The default **IIR Butterworth** filter is best. Make sure `Remove mean value (DC bias) before filtering` and `Apply filter to segments defined by boundary events` are checked.

* Use either a **2nd** or **4th** order filter (12 or 24 dB/octave roll off). Higher order filters will cause more distortion in your data.

* Select  `ERPLAB > Filter and frequency tools > Filters for EEG data`.

* Save your file as  `EID_S###_TID_FLT.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered).

#### 5. Downsample the data 

* If the data are recorded at 500Hz or above, downsample the data to 200 Hz to save memory and disk storage. Make sure this is done **after** you filter, otherwise you can get **aliasing artifacts**. Downsampling makes the data files MUCH smaller, and things will run faster in subsequent processing steps.

* Select  `Tools > Change sampling rate`.

* Save your file as  `EID_S###_TID_FLT_RSP.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered, `RSP` = resampled).

#### 6.  Delete sections of the EEG that do not contain triggers

* It is sometimes useful to delete "crazy" sections of the continuous EEG (e.g., prior to performing ICA). Procedures for this are described on this page. Note that these procedures actually delete sections of data (as opposed to simply marking them for rejection). Note that you should not use these procedures for "ordinary" artifacts (eye blinks, etc.

* You can delete sections of the eeg by selecting  `Tools > Inspect/reject data by eye`

* To erase a selected portion of the data, drag the mouse across the time region of interest. You can mark multiple regions for rejection in this way. 

* To select portions of data that extend out of the plotting window,  drag the mouse over the new region and connect it to a previously marked region.

* To deselect a portion of the data, simply click on the selected region. 

* After marking portions of the data for rejection, press REJECT and a new data set will be created with the rejected data omitted.

* EEGLAB  inserts `boundary` events where data have been rejected,

* One strategy to remove data is to stack the data using the Stack button of the plot window (upper right corner) and display about 30 seconds of data. This makes it easy to spot and remove trigger-less stretches of data.

* Save your file as  `EID_S###_TID_FLT_RSP_TRM.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered, `RSP` = resampled, `TRM` = trimmed).


#### 6. Append the Channel Location file

Select  `Edit > Channel locations`

* EEGLAB and ERPLAB require electrode coordinates for conducting ICA as well as for plotting topographic maps; you will get an error message if you try to plot a topographic map before you've added the coordinates.

* Click on `Plot 2-D` button to plot all the electrode locations and check for accuracy.  If any locations are missing,  use the `Look up locs` button to get the corresponding locations on BESA or MNI head model. This will add the coordinates to the current dataset.

#### 8. Conduct ICA

* Before beginning, watch the the first video of the ["ICA applied to EEG" video series](https://www.youtube.com/playlist?list=PLXc9qfVbMMN2uDadxZ_OEsHjzcRtlLNxc).

To conduct the ICA, select  `Tools > Decompose Data by ICA`.  This calls the function `pop_runica.m`.

* Make sure that `runica` is selected next to "ICA algorithm to use (click to select)"  then press `Ok`.

* As the ICA runs, You will see the text similar to the following in the MATLAB console:

```
Attempting to convert data matrix to double precision for more accurate ICA results.

Input data size [32,304838] = 32 channels, 304838 frames/nFinding 32 ICA components using extended ICA.
Kurtosis will be calculated initially every 1 blocks using 6000 data points.
Decomposing 297 frames per ICA weight ((1024)^2 = 304838 weights, Initial learning rate will be 0.001, block size 64.
Learning rate will be multiplied by 0.98 whenever angledelta >= 60 deg.
More than 32 channels: default stopping weight change 1E-7
Training will end when wchange < 1e-06 or after 512 steps.
Online bias adjustment will be used.
Removing mean of each channel ...
Final training data range: -12159.8 to 4680.14
Computing the sphering matrix...
Starting weights are the identity matrix ...
Sphering the data ...
Beginning ICA training ... first training step may be slow ...
step 1 - lrate 0.000029, wchange 12.07665233, angledelta  0.0 deg
step 2 - lrate 0.000029, wchange 185.22499819, angledelta  0.0 deg
step 3 - lrate 0.000029, wchange 186.96261176, angledelta 99.5 deg
step 4 - lrate 0.000028, wchange 0.09312261, angledelta 106.8 deg
step 5 - lrate 0.000027, wchange 0.56251145, angledelta 69.7 deg
.
.
.
step 198 - lrate 0.000000, wchange 0.00000207, angledelta 103.7 deg
step 199 - lrate 0.000000, wchange 0.00000240, angledelta 120.3 deg
step 200 - lrate 0.000000, wchange 0.00000078, angledelta 109.2 deg
Sorting components in descending order of mean projected variance ...
Scaling components to RMS microvolt
eeg_checkset: recomputing the ICA activation matrix ...
Done.
```
* Wait until `Done` appears in the console window.  If you need to interrupt the process, you can do so by pressing the `interrupt` button which appears in a separate window ![interrupt button](/img/tutorials/interrupt.png)

* The entire process may take anywhere from 5 minutes to an hour depending on the size of the dataset.

* When MATLAB says ICA is done click on `Tools > Classify components using IClabel > Label Components > OK` . This tells you the percentage of each artifact or component in your data

* Label artifact components by clicking on `Classify components using IClabel > Flag components as artifacts`. 
Double check artifact components flagged for rejection by clicking on `Inspect\label components by map`.

* Click on `Tools > Remove components from data > Plot single trials`. This enables you to see the change in the data (red before and black after)

* Once you are satisfied with the ocular artifact rejection click `Accept` and save your file as  `EID_S###_TID_FLT_RSP_TRM_ICA.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied)

#### 9. Re-reference the data

* EEG recordings measure differences in electrical potentials between two points (Voltages) and are usually expressed in units of microvolts (μV). The signal displayed at any channel is the difference in electrical potential to some other recording site, generally the ground electrode.

* EEG amplification systems use differential amplifiers which use three electrodes to record activity: an **active electrode** (A), a **reference electrode** (R), and a **ground electrode** (G). The differential amplifier amplifies the difference between the AG voltage and the RG voltage (AG minus RG). Electrical activity picked up by the amplifier’s ground circuit will be the same for the AG and RG voltages and will therefore be eliminated by the subtraction.

* The reference itself is not displayed as a channel in your data. Changing the reference offline after recording is called **re-referencing**. The idea behind re-referencing is to express the voltage at the EEG scalp channels with respect to another, new reference. It can be composed of any recorded channel or an average of several channels. This ultimate reference for your data will also affect your analysis.

* Typically you want the reference site to be *equidistant from all electrodes*, in order to not establish a hemispheric bias. In our case, we want to set the reference as an average of `TP9` and `TP10` (the recording reference).

* To re-reference the data select  `ERPLAB > EEG Channel operations`

* The channel operations GUI will then pop up. You can type equations directly into the channel operations GUI or load in a `.txt` file.

* Click on `Load list` and load the file called [`reref_eq_pc.txt`](/files/reref_eq_pchpl.txt)(Right-click or control-click on the link to download the file).  The equations from the `.txt` file will appear in the equations window. Then hit `RUN`.

* Make sure the `Create new dataset` radio button is checked. The `Modify existing dataset` option does *recursive updating* and `Create new dataset` does *non-recursive updating*.  For re-referencing data, always use the `Create new dataset` option. Keep in mind the syntax for the two options is slightly different. For merely adding channels to the bottom of a list, modifying the data set is fine.

* To save the re-referenced data set go to `File > Save current data set as…`

* Save your file as  `EID_S###_TID_FLT_RSP_TRM_ICA_REF.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced)

#### 10. Replace *one* bad channel (optional)

Select  `ERPLAB > EEG Channel operations`

* Clear any existing equations.

* We use a spherical spline interpolation that takes into account all of the electrode sites (i.e., using EEGLAB's `eeg_interp` function). To do this with EEG Channel Operations, you must first make sure that your dataset contains electrode location information (not just the name, but the 3-D coordinates). You would then use the `chinterpol` function in your Channel Operations equation. For example, to replace channel 12 with interpolated values, you would write an equation like this: `nch12 = chinterpol`

* Create a new dataset by checking `Create new dataset` radio button.

* To create a record for each subject of which channels were interpolated, you should *save the equations with a filename that indicates* ***which subject*** these equations are for. Use the following filneame template: `EID_S###_TID_int_eqs.txt` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`)

* Save your file as  `EID_S###_TID_FLT_RSP_TRM_ICA_REF(_INT).set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced, (`INT`= interpolated)).

#### 11.  Replace *more than one* bad channel 

* If there is **MORE THAN ONE BAD CHANNEL** you will need to do *selective EEG channel interpolation* via the command `Selective EEG Channel Interpolation` using the command line interface.

* This is is a modified version of EEGLAB's EEG channel interpolation function `eeg_interp.m` to allow the user to ignore a set of electrodes for interpolating bad channels

* The inputs to the function are:

    `eeg_in` - EEGLAB `EEG` data structure to interpolate

	`replace_chans` - array of channels to replace via interpolation

	`ignored_chans` - array of channels to ignore as input for interpolation`

* The output of the function is an EEGLAB `EEG` data structure.

* Example Use

      eeglab;

      %% Load test dataset
      data_filename = 'S1_Chan.set';
      data_filepath = './data/;
      eeg_in = pop_loadset('filename', data_filename, 'filepath', data_filepath);s

      %% Process data
      replace_chans     = [1 2 3];                        % Replace these channels via interpolation
      ignored_chans     = [4 5 6 7 8 9 10 11   14 15 16]; % Interpolate using electrodes 12 & 13
      eeg_out_selective = erplab_selective_eeg_interp(eeg_in, replace_chans, ignored_chans);`

* To create a record for each subject of which channels were interpolated, you should *save the equations with a filename that indicates* ***which subject*** these equations are for. Use the following filneame template: `EID_S###_TID_int_eqs.txt` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`)

* Save your file as  `EID_S###_TID_FLT_RSP_ICA_REF(_INT).set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced, (`INT`= interpolated)).

#### 12. Create the Event List

* Select  `ERPLAB > EventList > Create EEG EVENTLIST`

* ERPLAB uses the term 'event code' to refer to the code that marks the onset of an event in the EEG. 

* An `EVENTLIST` is a simple and compact structure created by ERPLAB that contains information about all of the events in an EEG structure (typically stimuli and responses)

* It can be very convenient to have this information stored separately from the EEG data (e.g., for behavioral analyses); the `EVENTLIST` structure can be saved as a text file as well as being appended onto the relevant `EEG` structure, allowing it to be saved and loaded along with the EEG structure).

* Do not change the default settings (i.e. add -99 for boundary codes, and create numeric equivalents for nonnumeric codes)

* It can be useful to save each participant’s event list file as a text file to your hard drive to enable changing event codes by hand if you need to for some reason.

* Save the Eventlist to a text file as `EID_S###_TID_ELS.txt`

* Save your dataset as  `EID_S###_TID_FLT_RSP_TRM_ICA_REF(_INT)_ELS.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID;`FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced, (`INT`= interpolated), `ELS` = eventlist attached).

#### 13. Assign Bins

* Select `ERPLAB > Assign bins (BINLISTER)`

* In most experiments, you will need to specify the mapping between events and bins. This involves creating a **bin descriptor file** (BDF), a text file that provides an abstract description of the events that will be averaged together.  For example, you can specify that Bin 3 will consist of targets that were preceded by a non-target and followed 200-1500 ms later by a left-hand button-press response.  This step can also be configured to extract reaction times, which are saved in the `bdf` field of the `EVENTLIST` structure and can be exported to a text file.

* Use Matlab's built-in text editor or Notepad++ to create the bdf file; other text editors may insert hidden characters that will cause problems. We recommend using a `.txt` file extension.

* Each bin descriptor contains three lines.The first line gives the **bin number**. The bins must be listed in ascending order starting with bin 1. The second line gives a **written description of the bin**, which will be used for things like labeling waveforms when the data are plotted.  The third line provides the **criteria for determining whether a given event should be assigned to that bin**. It is conventional, but not necessary, to place a blank line between the end of one bin descriptor and the beginning of the next.

* Each set of curly brackets ("{ }") defines an event.  The event following the dot is the time-locking event, and the preceding and following sets of curly brackets define the events that must precede and follow the time-locking event.

        bin 1
        Target followed by correct response
        .{100}

* You can also specify a range of stimuli for each bin

        bin 1
        Related High
        .{1-50}{250}

        bin 2
        Related Low
        .{51-100}{250}


* A good documentation for bdf syntax for ERPLAB can be found here: [Assigning Events to  Bins with BINLISTER: Tutorial](https://github.com/lucklab/erplab/wiki/Assigning-Events-to-Bins-with-BINLISTER:-Tutorial)

* Find and select the bin descriptor file you created for your experiment.

* Check `Read the eventlist from the current dataset`, select `Write the results to the current dataset`, select `Warn if bins have already been assigned`, and select `Transfer the eventlist info to EEG.event`.

  ##### 12.1 Save the binned eventlist  

* Save the binned Eventlist to a text file as `EID_S###_TID_ELS_BIN.txt` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`)

* Click `Run`.

  ##### 12.2 Save the dataset

*  Save your file as  `EID_S###_TID_FLT_RSP_TRM_ICA_REF(_INT)_ELS_BIN.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID;`FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced, (`INT`= interpolated), `ELS` = eventlist attached, `BIN` = bins defined).

#### 14. Epoch data

* Select `ERPLAB > Extract bin-based epochs`

* A window will pop up asking how much time around each event code you want to keep in each epoch. Your choice here will depend on your experiment. For most experiments *-200 through 1000* will be acceptable, but there may be reasons that you want to look at longer (or shorter) time windows after the trigger onset, depending on your experiment design or research question.

* Leave `pre-stimulus baseline` as the default correction.

* Save your dataset as  `EID_S###_TID_FLT_RSP_TRM_ICA_REF(_INT)_ELS_BIN_EPC.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID;`FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced, (`INT`= interpolated), `ELS` = eventlist attached, `BIN` = bins defined, `EPC` = epochs created).

#### 15. Perform artifact detection to reject bad epochs

* Given the use of ICA decomposition, we should have eliminated most eyeblinks so at the stage we are only rejecting epochs with other types of artifact such as rigourous muscle movement which should be rare

* Select `ERPLAB > Artifact detection in epoched data > Simple voltage threshold`

* A voltage value of ±75 or ±100 should screen out most large artifacts and leave the good EEG untouched. Run this only on the scalp channels.

* A window with the EEG will pop up with bad trials highlighted in yellow, and the offending channels highlighted in red. Scroll through the final flagged dataset and make sure it’s rejecting the right trials and keeping the good trials. If things are not working (that is, if bad trials are getting through or good trials are being rejected), change the thresholds accordingly and re-run detection until you find a threshold that works correctly.

* Save your dataset as  `EID_S###_TID_FLT_RSP_TRM_ICA_REF(_INT)_ELS_BIN_EPC_ARJ.set` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID;`FLT` = filtered, `RSP` = resampled, `TRM` = trimmed, `ICA` = ica applied, `REF` = re-referenced, (`INT`= interpolated), `ELS` = eventlist attached, `BIN` = bins defined, `EPC` = epochs created, `ARJ` = artefact rejected).

####  16. Save Artifact Rejection Summary

* You will also want to **save the artifact detection results** as a text file to your hard drive. You will need this to identify which individuals need to be excluded from data analysis (e.g., anyone with more than 30% rejected trials in any one condition).

* You will also need to report the average number of trials rejected across participants in each condition when you write your experiment up for publication. The text file will help you do this.

* Select  `ERPLAB > Summarize artifact detection > Summarize EEG artifacts in a table`

* Save your artifact detection results as  `EID_S###_TID_ARJ_SUM.txt` (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`; `TID` = 3-letter task ID; `ARJ_SUM` = artifact rejection summary )


#### 17. Average the ERPs

* Select   `ERPLAB > Compute averaged ERPs`

* Keep the default settings

* Save the erp file as `EID_S###.erp`, (`EID` = 3-letter experiment ID; `S###` = S plus 3-digit subject number e.g. `S008`, `S019`).


### Part II: Measuring Latencies from the ERP files

Measuring amplitudes and latencies with the ERP Measurement Tool

* Select `ERPLAB > ERP Measurement Tool`

* **Measurements are carried out on the `.erp` file, *not* the `.set` file.**

* You can either measure a currently open file (`Current ERPset` or `From ERPset Menu`) or enter a list of files (including paths) to measure (`From ERPset files`).

* To measure more than one file choose `From ERPset files` and list the files that you want to measure in the window below.  Save the list as a text file for future use.

* You can also load a pre-existing list of `.erp` files to measure using the `Load list` button.

* For `Measurement Type` choose `Mean amplitude between two fixed latencies`

* List the bins and channels you want to measure.  This would typically be all bins and all scalp channels (not the eye or mastoid channels).  However, there may be a reason to measure only a subset of bins. For example, in a lexical decision task, you may not want to measure the responses to non-words.

* For `Between latencies`  enter the beginning and end times in ms of the measurement window.  For example for the N400 you might want to enter `300 500`

* For `Baseline period` choose `Pre`

* Choose `One measurement per line (long format)`

* Save output file as `EID_#s_CN.txt`, e.g `M18_24_N400.txt` where `EID` = experiment ID, `#s` is the total number of subjects that have been run in the study, and `CN` is the component name e.g. N400, P300 etc.

### Part III: Generating a Grand Average ERP

* Once the pre-processing and erpset generation have been completed for all of the individual datasets, the ERPs from each subject and condition are averaged together to create a ‘grand-average’ ERP.

* Select the files to be averaged

 `ERPLAB` > `Average Across ERPsets` (Grand Average)

* When the *GRAND AVERAGER GUI* appears, select the `From ERPset files` option and click `Add Erpset`. This will open a file browser that can be used to navigate the directory containing the ERPset files created. Select all ERPs from the project of interest.

* Select the `Compute point-by-point standard error of the mean` option and leave all other default selections.

* Click `RUN` to generate the grand average.

* When the *Save Erpset GUI* dialog appears, select `Create a new erpset` and then enter a suitable name for the grand average. Also select `Save ERP as` and enter a similar name for the file that will be saved to disk. Click `OK`.

* Steps for different ways to visualize the Grand Average ERP can be found in [*EEG Methods for the Psychological Sciences* by Cheryl L. Dickter and Paul D Kieffaber](https://us.sagepub.com/en-us/nam/eeg-methods-for-the-psychological-sciences/book238043) beginning on page 80.


### Part IV: Analysing EEG data using Machine Learning

This is an approach that we will be exploring more in the coming year.

[Mahine Learning Approaches to Analyzing EEG Data](https://neuro.inf.unibe.ch/AlgorithmsNeuroscience/Tutorial_files/Introduction.html)
