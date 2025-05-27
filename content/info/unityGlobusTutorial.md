---
author: "Emma Kealey"
date: "2023-05-09"
draft: false
image: img/unityInstructions/serverPhoto.jpeg
showonlyimage: false
title: Accessing and Navigating Unity with Globus
slug: accessing_unity
weight: 
---
  
  Our lab uses the URI Unity Cluster to store data and analyses. Here's a breakdown of accessing and navigating through the data with Globus

<!--more-->

Please note that in order to access the data stored on Unity, you'll need to request affiliate access to URI and be added to the lab's directory. Talk to Joanna or Emma for help with these steps!

#### General Access

The easiest way to access the data stored on Unity is through Globus as outlined below:

-   Navigate to app.globus.org

-   Select "University of Rhode Island" as your organization from the drop down menu and click *Continue*

-   Sign in with your Microsoft URI credentials

-   If prompted, authenticate with DUO or one of the other listed options

-   If this is your first time logging in, you'll be prompted to grant Globus access to your account. You may also be prompted to link accounts. This should be your only Globus account so click your URI email address and continue. Eventually, you should end up on the File Manager page like so:
  
  ![](/img/unityInstructions/globusHomePage.jpeg)

-   Search for "Unity" in the Collection search bar along the top of the screen. Click on the first result that appears (Unity Mapped Collection GCS):
  
  ![](/img/unityInstructions/globusUnitySearch.png)

-   By default, this will open your personal directory in Unity. The path should be something like "/home/[your URI email address]/". You can store personal documents here if needed. However, for the most part you'll want to work in the lab directory.

-   To access the lab directory, change the path to /work/pi_joanna_morris_uri_edu/ :

![](/img/unityInstructions/globusLabDirectoryPath.png)

-   You can now click on the Human Physiology Lab folder and browse through the lab directory!

#### Uploading / Download Files

To upload/ download/ sync files to or from your local computer and the lab directory, you'll need to install Globus Personal Connection. Google "Globus Personal Connection" and download the version for your operating system.

Once you have downloaded Globus Personal Connection, follow the instructions to install the program on your device and set up your local connection to your desktop.

After you have set up GPC, go back to your app.globus.org window and click on the double pane toggle in the top right corner:
  
  ![](/img/unityInstructions/globusPanels.png)

In the new panel that opens up, click on the *Collections* section and navigate to *Your Collections*. Select your local device from the list:
  
  ![](/img/unityInstructions/globusYourConnections.png)

Your home page should look like so with the lab directory on the left and your personal computer directory on the right:
  
  ![](/img/unityInstructions/globusLabPersonalDirectory.png)

Now that you have both directories loaded, you can start moving files. Start by selecting the files you'd like to upload from your personal directory. Click the checkbox next to each file/folder you'd like to upload:
  
  ![](/img/unityInstructions/globusPersonalFilesSelected.png)

After selecting the correct file(s), switch to the Unity pane and navigate to where you'd like the selected files to live in the Unity Cluster:

![](/img/unityInstructions/globusUnityLocationSelected.png)

Click *Transfer or Sync to...* from the middle menu. This should shift focus back to your personal half of the window.

[Optional] click on *Transfer & Timer Options* to open the modal menu. From this menu, you can adjust how files are synced / transferred, adjust the timing of the transfer, and give your transfer a name:

![](/img/unityInstructions/globusTransferTimerMenu.png)

Finally, click the blue Start button to start the transfer. You'll want to press Start fom the side where the files currently live:
  
  ![](/img/unityInstructions/globusStartTransfer.png)

Your job will start and continue on until it completes or errors out. Check out the Activity tab along the left hand menu for more information!
  
  #### Teams Files
  
  Oh the dreaded Teams files. If you're trying to upload files that currently live in Microsoft Teams, you may run into some trouble. Here's what I've learned so far:

You'll want to set up Teams to sync with your desktop automatically. This way, Globus Personal Connection can access the files via your desktop. Check out [this article](https://support.microsoft.com/en-us/office/sync-sharepoint-and-teams-files-with-your-computer-6de9ede8-5b6e-4503-80b2-6190f3354a88) for more information.

Sometime synced files still won't upload (boo Microsoft). In that case, your best bet is to download the files that are causing trouble and upload them directly from your desktop via Globus. You can check which files are specifically causing trouble by following the steps below:

1.  Go to the Activity tab from the left side Globus Menu:

![](/img/unityInstructions/globusActivityMenu.png)

2.  Click on one of the errors listed (file not found in the example)

![](/img/unityInstructions/globusActivityError.png)

3.  Open the *Event Log*

![](/img/unityInstructions/globusActivityEventLog.png)

4.  Click on one of the errors shown in the Event Log. Click *View Details* and identify the path of the problematic file:

![](/img/unityInstructions/globusErrorFilePath.png)

5.  Cancel the current Transfer and try reinitiating the transfer without that file.

6.  Download the problematic file to your desktop

7.  Try reuploading the problematic file from your desktop to Unity via Globus.
