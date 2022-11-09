---
date: '2021-11-10'
draft: false
image: img/info/BrainVision_Recorder.jpg
showonlyimage: false
title: Data Recording Procedures
weight: 0
slug: recording_procedures
---

To record brainwaves from participants we use the *BrainVision Recorder* software program from Brain Products.

<!--more-->


* You must start *Recorder* in administrator mode..

* Right-click on the *Recorder* icon and choose `Run as administrator`.


* A **workspace** saves all amplifier-specific settings and some basic project settings. Workspace files have the extension `.rwksp`

* Open the default 32-channel workspace and edit it to create  a new workspace for **each project**. 

* In  the `Data File Settings` dialog box, the `Raw File Folder` setting specifies the destination directory for the EEG data. 

* By default this is `C:\Vision\Raw Files`.  You should specify a **sub-directory** for each specific project, e.g. `C:\Vision\Raw Files\M21`

* The `Automatic Filename Generation` setting generates automatic file names consisting of a `Prefix` and `Counter`. 

* The prefix is the same for all files recorded using the workspace.

* The counter is incremented each time you save data. You can specify the length of the counter by entering a number between 4 and 10

### Part I: Checking Impedences and Recording Data

* To check if the amplifier is working properly click on the `eye` button.

* If no errors are encountered, EEG waves appear in Recorder window running from left to right.

* Note: At the end of the channel list there is a **scaling bar** that helps you to assess the signal size.
