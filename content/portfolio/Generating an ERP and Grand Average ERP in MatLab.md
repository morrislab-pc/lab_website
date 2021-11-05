# Generating an individual ERP in MatLab
In depth explanations for each step can be found in *EEG Methods for the Psychological Sciences* beginning on page 68.
### Loading the Data
1. Invoke EEGlab in MatLab by typing eeglab at the command prompt and press enter
2. When the EEGlab GUI appears, load a dataset
    * File>Import Data>Using EEGlab functions and plugins>From Neuroscan .CNT file
      * Navigate to the One Drive for the lab and select the cnt file from the participant of interest. Click ‘Open’.

### Segmentation and Baseline Correction
##### Prepare the EEG structure for compatibility with ERPlab
3. ERPLAB>Eventlist>Create EEG EVENTLIST
    * Click ‘CREATE’
    * When the *Dataset info -- pop_newset()* dialog appears, click ‘Overwrite in memory’ and then click ‘Ok’.

##### Assign events to bins in accordance with the criteria specified in the BDF file
4. ERPLAB>Assign Bins (Binlister)
    * When the *BINLISTER GUI* dialog appears, click the ‘Browse’ button under the heading *Load Bin Descriptor File from*. Select the corresponding BDF file for the chosen project (e.g., ‘m15_bdf’) and click ‘Run’.
    * When the *Dataset info -- pop_newset()* dialog appears, click ‘Overwrite in memory’ and then click ‘Ok’.

##### Save the modified file
5. File>Save current dataset as
    * Choose a filename that reflects the application of the BDF

##### Extract Segments of data with respect to the events/bins
6. ERPLAB>Extract Bin-based epochs
    * When the *EXTRACT BINEPOCHS GUI* appears, adjust the *Bin-based epoch time range* to ‘-200 1000’ and adjust the *Baseline Correction* to ‘Pre’. Then click ‘RUN’.
    * When the *Dataset info -- pop_newset()* dialog appears, click ‘Overwrite in memory’ and then click ‘Ok’.

### Artifact Rejection
##### Detect segments containing artifacts with ERPlab
7. ERPLAB>Artifact Detection in epoched data>Simple voltage threshold
    * When the *Extreme Values* dialog appears, adjust the voltage limits to ‘-100 100’. Set the *Channel(s)* field to ‘7:27’ and click ‘Accept’.
    * Two new windows should appear. In the *Scroll channel activities* dialog, review the selections and click ‘Cancel’ to close the window. In the *Dataset info -- pop_newset()* dialog, click ‘Overwrite in memory’ and then click ‘Ok’.
8. File>Save current dataset as
    * Name the file in such a way as to indicate the stage of the data analysis

Having removed potential artifacts, the next step is to compute the ERP from the sample of data segments
### Subject Averaging
##### Computing subject averages with ERPlab
9. ERPLAB>Compute Averaged ERPs
    * When the *EEGSET -> ERPset Averager* dialog appears, select the option to ‘Exclude epochs marked during artifact detection’ and click ‘RUN’.
    * When the *Save Erpset GUI* dialog appears, select ‘Create a new erpset’ and enter a name for the erpset in the corresponding field. Click ‘OK’.

##### Plot the ERP for a single channel with ERPlab
10. ERPLAB>Plot ERP Waveforms
    * When the *ERP Plotting GUI* dialog appears, select a channel in the *Channels to plot field* (e.g., ‘0z’) or select the ‘all channels’ box to view all channels at once. Leave all other default selections and click ‘PLOT’.

##### Be sure to save the current ERPset
11. ERPLAB>Save current ERPset as

Repeat these steps for all individual datasets from each subject and condition before computing the Grand Average ERP.


# Generating a Grand Average ERP
One the pre-processing and erpset generation have been completed for all of the individual datasets, the ERPs from each subject and condition are averaged together to create a ‘grand-average’ ERP.
### Select the files to be averaged
1. ERPLAB>Average Across ERPsets (Grand Average)
    * When the *GRAND AVERAGER GUI* appears, select the ‘From ERPset files’ option and click ‘Add Erpset’. This will open a file browser that can be used to navigate the directory containing the ERPset files created. Select all ERPs from the project of interest.
    * Select the ‘Compute point-by-point standard error of the mean’ option and leave all other default selections. Click ‘RUN’ to generate the grand average.
    * When the *Save Erpset GUI* dialog appears, select ‘Create a new erpset’ and then enter a suitable name for the grand average. Also select ‘Save ERP as’ and enter a similar name for the file that will be saved to disk. Click ‘OK’.

Steps for different ways to visualize the Grand Average ERP can be found in *EEG Methods for the Psychological Sciences* beginning on page 80.
