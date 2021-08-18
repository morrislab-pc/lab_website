#How to Conduct Independent Components Analysis (ICA)
**What is it?**
A method for correcting ocular artifacts using a blind source separation
technique to separate a set of independent signals from a set of mixed signals
In essence, ICA un-mixes the independent signals from the mixed signals so we
can better distinguish what we are looking for amidst the "noise". 

**How to Conduct it in Matlab EEGlab toolbox**
1. Load existing dataset -click File >> Import Data >> using EEGlag functions and plugins >> choose from __ (whichever file format dataset is in)
2. Inspect Raw data/filtered data: clock on PLot >> Channel Data (scroll) - visually inspect for ocular artifacts and inspect data in general 
3. Conduct ICA: Click on Tools >> Decompose Data by ICA >> click on runica >> then press ok - takes about 40 to 60 mimutes (more or less dependeing on dataset size)
4. When matlab says ICA is done click Edit >> Channel locations >> ok >> ok 
5. Click on plot >> component properties - when new window pops ip change the settings so it says 1:32 (32 being the total number of electrodes) on top and change 50 to 80 in the bottom - this tells matlab to plot all the electrodes in the ICA and to change the frequency in the x-axis to 80 so that we can visually inspect for line noise which usually peaks at 50 or 60hz
6. Click on Tools >> Classify components using IClabel >> labek components >> ok - this tells you the percentage of each artifact or component in your data 
7. Visually insepct each individual channel or electrode for ocular artifacts relying on both your own wisdom of artifacts and the IClabel 
8. Rejection time! Reject channels with ocular artifacts by clicking on the accept button (it turn red and say reject) >> ok 
9. Click on tools >> Remove components from data >> Plot single trial plots - enables you to see the change in the data (red before and black after)
10. Once you are satisfied with the ocular artifact rejection click accep and save the brand new ICA filtered dataset. 

