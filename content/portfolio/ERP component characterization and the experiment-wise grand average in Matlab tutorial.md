# ERP component characterization and the experiment-wise grand average in Matlab tutorial
For in depth explanations and analysis of the GA_EW, topographic arrangement, and butterfly plot refer to *EEG Methods for the Psychological Sciences* beginning on page 80.

### Generating the experiment-wise grand average ERP (GA_EW) in ERPlab
##### Loading the data
1. ERPLAB>Load existing ERPset
  - select the grand average ERP generated from the dataset of interest (i.e., MORPH15)

##### Create an average across all conditions
2. ERPLAB>ERP Operations>ERP Bin Operations
  - When the *Bin Operation GUI* appears, create a new bin in addition to the existing ones for the given dataset. For example, MORPH 15 has 6 bins, so a 7th bin would be created.
  - For MORPH15 Type the following equation into the equation editor field at the top left of the *Bin Operation GUI*:
    - b7=(b1+b2+b3+b4+b5+b6)/6 label GA_EW
  - Adjust this equation accordingly for different datasets that have a different number of bins.
  - Select the ‘Modify existing ERPset (recursive updating)’ option under ‘Mode” and click ‘RUN’.

### Visualizing the GA_EW
##### Plot ERPs in topographic arrangement
3. ERPLAB>Plot ERP Waveforms
  - When the *ERP Plotting GUI* dialog appears enter ‘7:27’ in the ‘Channels to plot’ field. For MORPH15, enter ‘7’  in the ‘Bins to plot’ field or which bin is the GA_EW for that dataset. Enter ‘-200 500’ in the ‘Time range’ field and select the ‘Topographic’ option under ‘Style’. Leave all other default selections. Click ‘PLOT’.
  - Click 'OK' for the next two dialogs and the plot for the topographical arrangement of the channels for the GA_EW should appear

##### Butterfly Plot
4. Download ‘ERP_butterfly.m’ from the [EEG Methods Book Data Files](www.sagepub.co.uk/dickter) and make sure a copy of the file is in Matlab’s default directory.
5. Type the following into the Matlab command line for MORPH15. Adjust the numbers as needed for each particular dataset:
  - ERP_butterfly(ERP,7,[1:6],7:27,[-200 500])
  - Press ENTER and the new figure window should contain a butterfly plot of the GA_EW in the bottom panel and six topographical maps (one for each condition) in the top panel.
