---
date: '2021-11-10'
draft: false
image: img/info/BrainVision_Recorder.jpg
showonlyimage: false
title: Data Recording Procedures
weight: 0
slug: recording_procedures
---

To record brainwaves from participants we use the **BrainVision Recorder** software program from Brain Products.

<!--more-->


- You must start *Recorder* in administrator mode..

- Right-click on the *Recorder* icon and choose `Run as administrator`.

### The toolbar

- You can change the way the data are displayed by using the toolbar buttons:

  ![toolbar](/img/info/toolbar.png)
  
- From left to right the buttons are (1) `Start Monitoring` (2) `Impedence Check`, (3) `Generate square wave` (4) `Start Recording` (5) `Pause Recording` (6) `Stop Recording` (7) `Stop Monitoring` (8) `Zoom Out` (9) `Zoom In` (10) `Increase the scaling factor` (11) `Decrease the scaling factor` (12) `Decrease the number of channels shown` (13) `Increase the number of channels shown` (14) `Switch to the next group of channels` (15) `Switch to the prior group of channels` (16) `Baseline Correction in Display` (note only the baseline of the display is changed, and not the actual data)

  

###  `workspace` files 

- A **workspace** saves all amplifier-specific settings and some basic project settings. Workspace files have the extension `.rwksp`

- Open the default 32-channel workspace and edit it to create  a new workspace for **each project**. 

- In the `Data File Settings` dialog box... 

- ...the `Raw File Folder` setting specifies the destination directory for the EEG data. By default this is `C:\Vision\Raw Files`.  You should specify a **sub-directory** for each specific project, e.g. `C:\Vision\Raw Files\M21`

- The `Automatic Filename Generation` setting generates automatic file names consisting of a `Prefix` and `Counter`. 

  - The `prefix` is the same for all files recorded using the workspace.

  - The `counter` is incremented each time you save data. You can specify the length of the counter by entering a number between 4 and 10 to generate numbers from 4 to 10 digits long.

- The `Current Number` value specifies the **start number** of the counter.

- The `Next Resulting Filename` value shows  the name that results from the combination of the `prefix` and `counter` values.

- Do not change any settings in the  `Amplifier `, `Filter ` or `Segmentation\Averaging` dialog boxes



&nbsp;      




###  Checking Impedences and Recording Data

- To check if the amplifier is working properly click on the `Start Monitoring` button.

- If no errors are encountered, EEG waves appear in the Recorder window running from left to right.

- Note: At the end of the channel list there is a **scaling bar** that helps you to assess the signal size.
