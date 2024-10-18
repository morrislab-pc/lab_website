# Joystick Error

The error you're encountering (`pygame.error: Invalid joystick device number`) suggests that OpenSesame (via **pygame**) is unable to properly detect the joystick device, either because the device number is incorrect or because the joystick isn't being recognized by your system.

Here are some steps to troubleshoot and resolve the issue:

### 1. **Check if the Joystick is Properly Connected**:
   - Ensure that your joystick is connected to the computer and that the system is recognizing it as an input device.
   - On macOS, go to **System Information** (under the Apple menu), click on **USB** or **Bluetooth** (depending on how your joystick is connected), and verify if the joystick is listed there.

### 2. **Test Joystick Detection in Pygame**:
   - You can use a simple Python script to check whether **pygame** is correctly detecting the joystick.

   Try running the following code in an OpenSesame inline script (or in a separate Python environment) to see how many joysticks pygame detects:

   ```python
   import pygame
   pygame.init()
   
   # Get the number of joysticks
   joystick_count = pygame.joystick.get_count()
   print(f"Number of joysticks detected: {joystick_count}")
   
   if joystick_count > 0:
       # Loop through joysticks and print their names
       for i in range(joystick_count):
           joystick = pygame.joystick.Joystick(i)
           joystick.init()
           print(f"Joystick {i}: {joystick.get_name()}")
   else:
       print("No joysticks detected.")
   ```

   This script will output how many joysticks are detected and display their names. If no joysticks are detected, the issue might be with the connection or driver support on macOS.

### 3. **Check the Device Number**:
   - Joystick devices are indexed starting from **0** in pygame. Ensure that you are using the correct device number when initializing the joystick in OpenSesame. If there is only one joystick connected, the device number should be `0`.
   - Double-check that you are passing the correct device number in your OpenSesame script or joystick configuration.

### 4. **Ensure Compatibility of Joystick**:
   - Some joysticks may not be fully compatible with pygame, particularly on macOS. Try testing the joystick with another application that supports it to make sure it's functioning correctly outside of OpenSesame.

### 5. **Update Pygame and OpenSesame**:
   - Ensure that both OpenSesame and pygame are up to date, as older versions may have bugs or limited support for certain hardware.

### 6. **Try a Different USB Port** (if applicable):
   - If your joystick is USB-connected, try plugging it into a different port. Some USB devices are finicky about specific ports, especially on macOS.

### 7. **Reinitialize the Joystick**:
   - If OpenSesame or pygame encounters an error initializing the joystick, you can try explicitly reinitializing the joystick within the script. For example:

   ```python
   import pygame
   pygame.joystick.quit()  # Quit the joystick module first
   pygame.joystick.init()  # Then reinitialize
   ```

### 8. **Test with a Simple OpenSesame Joystick Example**:
   - Create a minimal OpenSesame experiment that only uses joystick input and test if it works on its own. This might help narrow down if the issue is specific to your main experiment's complexity or a broader issue with joystick handling.

### Summary:
1. Ensure the joystick is properly connected and recognized by the system.
2. Use a Python script to check joystick detection in pygame.
3. Confirm you are using the correct joystick device number.
4. Test the joystick in other programs to ensure it is functioning properly.
5. Update OpenSesame and pygame to the latest versions.

Let me know how it goes, or if you'd like help with any of these steps!

---

# Trouble shooting pygame
If macOS recognizes the joystick but **pygame** (and therefore OpenSesame) does not, the issue is likely related to how **pygame** interacts with macOS or the joystick drivers. Pygame on macOS can sometimes have trouble detecting certain hardware due to compatibility issues.

Here are a few troubleshooting steps to resolve this:

### 1. **Check Pygame Version**:
   - Ensure you're using an up-to-date version of **pygame**, as older versions might have issues with device detection on macOS.

   You can check your **pygame** version by running the following in an inline script or Python terminal:

   ```python
   import pygame
   print(pygame.version.ver)
   ```

   If the version is outdated, you may need to upgrade it. For OpenSesame, it may be tricky to update pygame within the app, so consider running OpenSesame in a **virtual environment** where you can manually control dependencies.

### 2. **Try Reinitializing Pygame**:
   Sometimes, pygame needs to be reinitialized for device detection to work. You can try this approach by forcing pygame to quit and reinitialize its joystick module.

   ```python
   import pygame
   pygame.joystick.quit()
   pygame.joystick.init()

   joystick_count = pygame.joystick.get_count()
   print(f"Number of joysticks detected: {joystick_count}")
   ```

   See if reinitializing helps pygame detect the joystick.

### 3. **Check Pygame's macOS Compatibility**:
   - Pygame’s joystick module may not fully support certain joysticks or may have issues on macOS. Some joysticks may require additional software or drivers to work properly with pygame on macOS.
   - You could also check the [pygame GitHub issues page](https://github.com/pygame/pygame/issues) for known issues with macOS and joysticks.

### 4. **Test with a Different Backend**:
   OpenSesame can use different backends for input handling. You can try switching to a different backend to see if that resolves the issue:
   
   - In OpenSesame, go to **Tools → Preferences → General**.
   - Change the **Backend** to `xpyriment` or `legacy` instead of `psycho` or `pygame`.
   - Test if this resolves the joystick detection issue.

### 5. **Use a Different Python Environment**:
   If the problem persists, you can try running **OpenSesame** from a Python virtual environment where you have more control over the versions of pygame and other dependencies.

   Here's a rough outline of how you could set this up:

   1. Install a Python virtual environment:
      - In your terminal:
        ```bash
        python3 -m venv my_openesame_env
        source my_openesame_env/bin/activate
        ```
   
   2. Install the latest version of **pygame**:
      - After activating the environment:
        ```bash
        pip install pygame
        ```

   3. Install **OpenSesame** inside the environment and test if it recognizes the joystick.

### 6. **Test with a Different Joystick**:
   If possible, test with another joystick to see if the issue is specific to your joystick model. Some joystick devices are not fully supported by pygame on macOS.

### 7. **Use Game Controller Utility**:
   - If pygame continues to not detect your joystick, consider installing a third-party joystick mapping utility for macOS (like **Game Controller** or **Joystick Mapper**). These can sometimes help bridge the gap between macOS and applications like pygame by remapping joystick inputs to something the system or pygame can recognize.

### Summary of Steps:
1. **Ensure your pygame is up to date**.
2. **Reinitialize pygame's joystick module**.
3. **Check pygame's macOS compatibility** and potentially switch OpenSesame's backend.
4. **Test in a different Python environment** where you have control over dependencies.
5. **Try a different joystick** or use joystick mapping software on macOS.

If none of these steps resolve the issue, it might indicate a deeper compatibility issue between pygame and the specific joystick you are using on macOS. In that case, external joystick remapping software could be a viable workaround. Let me know how it goes!

---

# How to open a python terminal

To open a Python terminal (also known as a Python **interactive shell** or **REPL**) on macOS, follow these steps:

### 1. **Open the Terminal Application**:
   - You can find the **Terminal** application in macOS by doing the following:
     - Click on the **Spotlight** search icon (magnifying glass) in the top-right corner of the screen or press `Cmd + Space`.
     - Type "Terminal" and press **Enter**.
     - The Terminal application will open.

### 2. **Check if Python is Installed**:
   - By default, macOS comes with Python 2.x installed, but you may want to use Python 3.x. To check if Python 3 is installed, type the following command in the terminal:
     ```bash
     python3 --version
     ```
   - If Python 3 is installed, it will display something like `Python 3.x.x`.

   - If you don’t have Python 3 installed, you can install it via **Homebrew** (see below).

### 3. **Launch Python (3.x)**:
   - To start a Python 3 terminal session, type:
     ```bash
     python3
     ```
   - This will open the Python interactive shell. You will see something like this:
     ```
     Python 3.x.x (default, ... , ...)
     >>> 
     ```

   - You can now start typing Python commands in this interactive shell.

### 4. **Exit the Python Terminal**:
   - To exit the Python terminal, simply type:
     ```python
     exit()
     ```
   - Then press **Enter**.

### Installing Python 3 (if not already installed):
If you don't have Python 3 installed, you can easily install it via **Homebrew**, a popular package manager for macOS. Here’s how:

1. **Install Homebrew (if you don’t have it)**:
   - Open the Terminal and run the following command to install Homebrew:
     ```bash
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```

2. **Install Python 3**:
   - Once Homebrew is installed, run the following command to install Python 3:
     ```bash
     brew install python
     ```

3. **Verify Installation**:
   - After the installation completes, verify that Python 3 is installed by running:
     ```bash
     python3 --version
     ```

You should now be able to open the Python terminal by typing `python3` in the Terminal, and you're ready to run Python code on your Mac!

Let me know if you run into any issues!

---

# Determining python version

It seems like Python 3.11 has been installed, but your system is still using Python 3.10 as the default version. This can happen if the older version is still set as the primary `python3` command in your system's path.

Here’s how you can check and configure your system to use Python 3.11 as the default version:

### Step-by-Step Guide to Set Python 3.11 as Default:

#### 1. **Check Installed Python Versions**:
First, check which versions of Python are installed and their paths by running:

```bash
ls /usr/local/bin/python3*
```

This will list the Python 3 versions installed, such as `/usr/local/bin/python3.10` and `/usr/local/bin/python3.11`.

#### 2. **Manually Specify Python 3.11**:
To directly use Python 3.11, type:

```bash
python3.11 --version
```

This will confirm that Python 3.11 is installed and working.

#### 3. **Change Default Python 3 to Python 3.11**:
To make Python 3.11 the default when you run the `python3` command, you can update the symbolic link (symlink) to point to Python 3.11.

1. First, find out where Python 3 is located by typing:

   ```bash
   which python3
   ```

   This should show a path like `/usr/local/bin/python3`.

2. Now, update the symlink to point to Python 3.11:

   ```bash
   sudo ln -sf /usr/local/bin/python3.11 /usr/local/bin/python3
   ```

   This command forces the `python3` symlink to point to Python 3.11.

3. After updating the symlink, check the version again:

   ```bash
   python3 --version
   ```

   It should now show Python 3.11.

#### 4. **Ensure pip3 is Using Python 3.11**:
When you install packages using `pip3`, make sure it corresponds to Python 3.11. You can check the pip3 version with:

```bash
pip3 --version
```

If it is not using Python 3.11, you can similarly create a symlink for `pip3`:

```bash
sudo ln -sf /usr/local/bin/pip3.11 /usr/local/bin/pip3
```

### Alternative: Using `pyenv` (Optional)
If you are dealing with multiple Python versions often, you can consider using a version manager like **pyenv** to handle multiple installations more easily.

Here’s how you can install and manage Python versions using `pyenv`:

1. Install `pyenv` via Homebrew:

   ```bash
   brew install pyenv
   ```

2. Install Python 3.11 via `pyenv`:

   ```bash
   pyenv install 3.11.x
   ```

3. Set Python 3.11 as the default:

   ```bash
   pyenv global 3.11.x
   ```

This will make sure Python 3.11 is the default version in your terminal session.

### Summary:
- Use `python3.11 --version` to confirm Python 3.11 is installed.
- Update the `python3` symlink to point to Python 3.11 by using `sudo ln -sf`.
- Ensure `pip3` is using Python 3.11 as well.

Let me know if you encounter any issues during these steps!

---

It looks like you have multiple Python versions installed, and the system is using an older or different version when you run `python3`. You can adjust the symlink so that `python3` points to **Python 3.11** and ensure that it's the default Python 3 version on your system.

### Steps to Set Python 3.11 as Default:

1. **Check Current Python Version**:
   Before proceeding, let's check the current version that `python3` points to:

   ```bash
   which python3
   ```

   This will show the path, which may be `/usr/local/bin/python3`. It might still be pointing to an older version like Python 3.10.

2. **Update the Python 3 Symlink**:
   We need to update the symlink so that when you type `python3`, it points to Python 3.11.

   Run the following command to update the symlink:

   ```bash
   sudo ln -sf /usr/local/bin/python3.11 /usr/local/bin/python3
   ```

   This will force `python3` to link to `python3.11`.

3. **Check the Python 3 Version**:
   After updating the symlink, verify that `python3` is now pointing to Python 3.11 by running:

   ```bash
   python3 --version
   ```

   You should see output similar to:

   ```
   Python 3.11.x
   ```

4. **Update `pip3` to Use Python 3.11**:
   You'll also want to make sure that `pip3` (Python's package installer) is using Python 3.11. You can update the `pip3` symlink similarly:

   ```bash
   sudo ln -sf /usr/local/bin/pip3.11 /usr/local/bin/pip3
   ```

   Now check the version of `pip3`:

   ```bash
   pip3 --version
   ```

   It should show something like:

   ```
   pip 22.x.x from /usr/local/lib/python3.11/site-packages (python 3.11)
   ```

### Removing Unused Python Versions (Optional):

If you're not using some of the older Python versions, you can remove them to simplify your system and avoid confusion:

1. List all the installed Python versions:

   ```bash
   ls /usr/local/bin/python3*
   ```

2. To remove older versions, you can delete the binaries manually. For example, to remove Python 3.4, you can run:

   ```bash
   sudo rm /usr/local/bin/python3.4
   sudo rm /usr/local/bin/python3.4-config
   ```

   Repeat for any other versions you want to remove (e.g., Python 3.5, 3.4, etc.).

### Summary:
- Update the `python3` symlink to point to `/usr/local/bin/python3.11` using `ln -sf`.
- Ensure `pip3` also points to Python 3.11 by updating its symlink.
- Optionally, clean up older Python versions if you're no longer using them.

Let me know if this helps or if you need further assistance!

---

# Anaconda/Miniconda

The output `/Users/jmorris/miniconda3/bin/python3` indicates that your system is using the **Miniconda** (or Anaconda) Python environment as the default when you type `python3`. This is typical if you've installed Miniconda or Anaconda, as they adjust the system path to prioritize the Python version managed by Conda.

If you want to use the **Python 3.11** version from `/usr/local/bin`, you have a couple of options:

### Option 1: Use Python 3.11 Directly without Modifying Conda
You can always explicitly call **Python 3.11** by typing its full path:

```bash
/usr/local/bin/python3.11
```

This ensures you’re using the system-installed Python 3.11 without changing anything in your Miniconda setup.

### Option 2: Temporarily Change to Use System Python 3.11
If you want to temporarily prioritize the system-installed Python 3.11 over the Conda environment in your terminal session, you can modify the `PATH` variable:

1. In your terminal, temporarily modify the `PATH`:

   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

2. Now, when you type `python3`, it will use Python 3.11 from `/usr/local/bin`:

   ```bash
   python3 --version
   ```

   You should see Python 3.11 as the output.

This change will only last for the current terminal session. If you open a new terminal, the Conda Python will be restored.

### Option 3: Permanently Prioritize System Python 3.11 over Conda
If you want to permanently prioritize Python 3.11 in your terminal, you can modify your shell configuration file (e.g., `.bashrc`, `.zshrc`, or `.bash_profile`, depending on your shell).

1. Open your shell configuration file:

   For **bash** (default shell on older macOS versions):
   ```bash
   nano ~/.bash_profile
   ```

   For **zsh** (default shell on newer macOS versions like Catalina and later):
   ```bash
   nano ~/.zshrc
   ```

2. Add the following line at the top of the file to prioritize `/usr/local/bin`:

   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

3. Save and close the file (`Ctrl+X`, then `Y`, then `Enter`).

4. Apply the changes by running:

   ```bash
   source ~/.bash_profile  # or ~/.zshrc for zsh
   ```

Now, when you open a new terminal, Python 3.11 will be prioritized over the Conda environment.

### Option 4: Use Conda to Manage Python 3.11
Alternatively, if you prefer to manage Python 3.11 through Miniconda/Anaconda, you can create a Conda environment with Python 3.11:

1. Create a new Conda environment with Python 3.11:

   ```bash
   conda create --name py311 python=3.11
   ```

2. Activate the environment:

   ```bash
   conda activate py311
   ```

3. Verify the Python version:

   ```bash
   python --version
   ```

   This will now be Python 3.11 within your Conda environment.

### Summary:
- **Option 1**: Directly call `/usr/local/bin/python3.11` to use Python 3.11 when needed.
- **Option 2**: Temporarily prioritize system Python by modifying the `PATH` for your session.
- **Option 3**: Permanently adjust your `PATH` to prioritize system Python 3.11 over Conda.
- **Option 4**: Use Conda to manage Python 3.11 within an environment.

Let me know which option you prefer or if you need further help with any of these!

----

# Use python 3.11 by default

The reason you're still seeing Python 3.10.9 when you type `which python3` is because your system is still prioritizing the **Miniconda environment** (`/Users/jmorris/miniconda3/bin/python3`) over the `/usr/local/bin/python3` symlink that you just updated. This happens because **Miniconda** modifies your `PATH` environment variable to give priority to its Python installation.

### Solution:

To make sure that your system uses `/usr/local/bin/python3` (Python 3.11) instead of Miniconda's Python by default, you can either:

### Option 1: Temporarily Use Python 3.11 in Your Current Session

To use Python 3.11 in the current session, modify the `PATH` variable:

1. **Modify `PATH`** temporarily:

   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

2. **Check Python Version**:

   ```bash
   python3 --version
   ```

This will work for the current terminal session, but once you open a new terminal, the Miniconda version will be back as the default.

### Option 2: Permanently Prioritize Python 3.11 Over Conda

To permanently ensure that Python 3.11 is used instead of Miniconda's Python, follow these steps:

1. **Edit Your Shell Configuration File**:

   If you are using **zsh** (the default shell in macOS Catalina and later), open your `.zshrc` file:

   ```bash
   nano ~/.zshrc
   ```

   If you are using **bash** (for older macOS versions or if you changed your shell), open your `.bash_profile`:

   ```bash
   nano ~/.bash_profile
   ```

2. **Add `/usr/local/bin` to the Beginning of the `PATH`**:

   Add the following line at the top of your file:

   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

   This ensures that `/usr/local/bin` is searched before Miniconda’s Python in the `PATH`.

3. **Save and Exit**:
   - For **nano**, press `Ctrl + X`, then `Y`, and then `Enter` to save the file.

4. **Apply the Changes**:

   After editing the file, apply the changes by running:

   ```bash
   source ~/.zshrc   # For zsh users
   source ~/.bash_profile  # For bash users
   ```

5. **Verify the Change**:

   Now, check which `python3` is being used:

   ```bash
   which python3
   ```

   It should now point to `/usr/local/bin/python3`, and when you check the version, it should show Python 3.11:

   ```bash
   python3 --version
   ```

### Option 3: Use Conda to Manage Python

If you prefer to keep using Miniconda/Anaconda as your main Python manager but want Python 3.11, you can create a Python 3.11 environment in Conda, as mentioned earlier:

1. **Create a Python 3.11 Environment**:

   ```bash
   conda create --name py311 python=3.11
   ```

2. **Activate the Environment**:

   ```bash
   conda activate py311
   ```

3. **Verify the Python Version**:

   ```bash
   python --version
   ```

   This will now be Python 3.11 within your Conda environment.

### Summary:
- Temporarily modify the `PATH` using `export PATH="/usr/local/bin:$PATH"` to use Python 3.11.
- Permanently modify the `PATH` in your shell configuration file (`~/.zshrc` or `~/.bash_profile`) to prioritize `/usr/local/bin`.
- Use Conda to create a Python 3.11 environment if you want to manage it through Miniconda.

Let me know if any of these solutions work for you or if you need further assistance!

---

# Using conda with Jupyterlab

The error you're seeing indicates that the `conda` command is not recognized within the JupyterLab notebook environment. This is because `conda` commands (like `conda activate`) work within a terminal or shell, not directly in a Jupyter notebook. 

### Solution:

To properly activate your Conda environment and use it within JupyterLab, follow these steps:

### Step 1: **Activate Conda in Your Terminal (Not in JupyterLab)**

1. Open your **Terminal** (not the JupyterLab notebook) and run:

   ```bash
   conda init zsh  # Use "bash" if you're using bash as your shell.
   ```

   This command will set up your shell to recognize the `conda activate` command.

2. **Restart the Terminal** for the changes to take effect.

3. **Activate the Conda environment** in the terminal:

   ```bash
   conda activate py311
   ```

### Step 2: **Add the Conda Environment as a Jupyter Kernel**

1. **Install `ipykernel`** in your Conda environment (if not installed already):

   ```bash
   conda install ipykernel
   ```

2. **Add the Conda environment to Jupyter** so that it appears as an option in JupyterLab:

   ```bash
   python -m ipykernel install --user --name py311 --display-name "Python 3.11 (py311)"
   ```

3. **Open JupyterLab**:

   Start JupyterLab from the terminal:

   ```bash
   jupyter lab
   ```

4. **Select the Python 3.11 Kernel**:
   - In JupyterLab, when you create a new notebook or open an existing one, you can now select the kernel corresponding to your Conda environment ("Python 3.11 (py311)").
   - Go to **Kernel → Change Kernel** in the notebook and select the "Python 3.11 (py311)" option.

### Step 3: **Test the Installation**:

1. Once you've selected the correct kernel in JupyterLab, try importing `pygame` and check its version to verify everything works:

   ```python
   import pygame
   print(pygame.version.ver)
   ```

### Summary:

1. **Run `conda init zsh` (or `bash` depending on your shell) in the terminal.**
2. **Restart your terminal and activate the Conda environment.**
3. **Add the Conda environment to JupyterLab with `ipykernel`.**
4. **Use the Conda environment as a kernel in JupyterLab.**

This should solve the issue. Let me know if you run into any trouble along the way!

---

# Using conda in the shell

The error you're seeing ("`ModuleNotFoundError: No module named 'pygame'`") means that **`pygame`** is not installed in the current Conda environment. Since you've decided to use the shell instead of JupyterLab, you can install `pygame` directly in your Conda environment by following these steps:

### Steps to Install `pygame` in the Conda Environment:

1. **Activate your Conda environment** (e.g., `py311`):
   
   In your terminal or shell, type:

   ```bash
   conda activate py311
   ```

   If this works correctly, your prompt should change to show that the `py311` environment is active.

2. **Install `pygame`** in the Conda environment using the `conda-forge` channel:

   Since `pygame` is available via the `conda-forge` channel, you can install it by running the following command:

   ```bash
   conda install -c conda-forge pygame
   ```

   This command installs `pygame` and its dependencies in the `py311` environment.

3. **Verify the Installation**:

   After the installation completes, verify that `pygame` is available by running the Python shell:

   ```bash
   python
   ```

   Then, in the Python interactive shell, type:

   ```python
   import pygame
   print(pygame.version.ver)
   ```

   This should display the version of `pygame` you just installed, confirming that it's available in the environment.

### If You Get Any Errors:
- If you get any errors during installation, make sure your Conda environment is correctly activated, and ensure you have internet access to download the package from the `conda-forge` channel.

Let me know if it works or if you run into any more issues!

# Installing `pygame` in the `conda` environment

It seems like there was some confusion in how the command was executed. The error you're seeing suggests that the `conda install` command was not recognized correctly, likely due to a syntax or command entry issue in the shell.

Let’s try the correct steps carefully to resolve the issue:

### Correct Steps to Install `pygame`:

1. **Activate Your Conda Environment**:
   First, ensure that your Conda environment (`py311`) is activated. In your terminal (not in Python), type:

   ```bash
   conda activate py311
   ```

   You should see the prompt change to indicate that the `py311` environment is now active.

2. **Install `pygame`**:
   After the environment is activated, in the **terminal (shell)**, run the following command (ensure you're not inside the Python interpreter):

   ```bash
   conda install -c conda-forge pygame
   ```

   This will install `pygame` from the `conda-forge` channel.

3. **Check Installation**:
   Once the installation is complete, you can verify it by running Python and checking for the installed `pygame` module:

   1. In the terminal, type:

      ```bash
      python
      ```

   2. Once you're in the Python shell (you'll see `>>>`), try importing `pygame` and printing the version:

      ```python
      import pygame
      print(pygame.version.ver)
      ```

### If You Get Errors Related to Conda:

If you encounter a "command not found" error for `conda`, it might be that Conda hasn’t been initialized in your shell. You can fix this by running:

1. **Initialize Conda for zsh** (since you're using zsh):

   ```bash
   conda init zsh
   ```

   After this, restart your terminal, and then repeat the above steps to activate your environment and install `pygame`.

Let me know how it goes or if you encounter any additional issues!

---

# Conda environments
It sounds like the installation might not have been properly linked to the active environment. Let’s troubleshoot and fix this step by step:

### 1. **Check That You're in the Right Environment**:
First, confirm that you're in the correct Conda environment (`py311`) where you installed `pygame`.

In your terminal, type:

```bash
conda info --envs
```

This will list all your Conda environments. The one that is currently active will have an asterisk (`*`) next to it.

Ensure that `py311` is active. If it's not active, activate it with:

```bash
conda activate py311
```

### 2. **Reinstall `pygame` in the Active Environment**:
If the correct environment is active but `pygame` is still not found, try reinstalling `pygame` in that environment.

Run the following command to ensure `pygame` is properly installed:

```bash
conda install -c conda-forge pygame
```

### 3. **Verify the Installation Path of `pygame`**:
After installation, check where `pygame` is installed within your environment. You can list all installed packages in your environment by typing:

```bash
conda list
```

Look for `pygame` in the list to confirm that it has been installed.

### 4. **Launch Python and Import `pygame`**:
Now, start Python from within your active Conda environment and try importing `pygame`:

```bash
python
```

Once inside the Python shell, try the following:

```python
import pygame
print(pygame.version.ver)
```

If `pygame` still cannot be found, proceed with the next step.

### 5. **Check Python Version in the Active Environment**:
Sometimes, Conda environments can have multiple Python versions installed. Let’s make sure that your environment is using the correct Python version.

In your terminal, type:

```bash
python --version
```

Ensure that it’s the Python version you're expecting (in this case, Python 3.11).

### 6. **Check Python Path**:
If `pygame` still cannot be found, there may be a path issue. You can check where Python is running from by typing:

```bash
which python
```

This should show the path to Python within your Conda environment (something like `/Users/yourusername/miniconda3/envs/py311/bin/python`).

### 7. **Try Using pip (if conda still has issues)**:
If `pygame` still isn’t working via Conda, you can install it via `pip`:

1. Make sure you are in your Conda environment:

   ```bash
   conda activate py311
   ```

2. Then install `pygame` using `pip`:

   ```bash
   pip install pygame
   ```

3. Afterward, verify the installation again by launching Python and importing `pygame`.

Let me know how it goes after trying these steps!

---

# MacOS settings

If **pygame** isn't detecting your joystick on macOS, even though macOS itself recognizes it, this can be due to several potential issues, including compatibility between **pygame** and macOS, as well as specific driver support for the joystick. Here are some steps to troubleshoot and resolve the issue:

### 1. **Ensure Pygame's Joystick Module is Initialized Properly**:
Pygame requires that the joystick module be initialized before it can detect any devices. You can run the following code to ensure that the module is initialized and see if pygame detects any joysticks:

```python
import pygame

# Initialize all pygame modules
pygame.init()

# Initialize the joystick module
pygame.joystick.init()

# Get the number of joysticks
joystick_count = pygame.joystick.get_count()
print(f"Number of joysticks detected: {joystick_count}")

# List the names of all detected joysticks
for i in range(joystick_count):
    joystick = pygame.joystick.Joystick(i)
    joystick.init()
    print(f"Joystick {i} name: {joystick.get_name()}")
```

If the output says **0 joysticks detected**, pygame is still not able to recognize your joystick. Let’s proceed with further steps.

### 2. **Check Pygame Version**:
Older versions of **pygame** may not fully support certain joysticks on macOS. Make sure you have the latest version of pygame installed. To check your current version and update if necessary:

```bash
pip install --upgrade pygame
```

You can check the version of `pygame` you're using by typing:

```python
import pygame
print(pygame.version.ver)
```

### 3. **macOS Security and Privacy Settings**:
macOS has strict security and privacy settings, particularly around input devices like keyboards, mice, and joysticks. You may need to give permission to applications (such as Python) to access input devices.

1. **Open System Preferences** → **Security & Privacy**.
2. Go to the **Privacy** tab.
3. Select **Input Monitoring** from the list on the left.
4. Ensure that your terminal or Python environment (e.g., `Terminal`, `iTerm`, or `Python.app`) is checked in the list to allow input monitoring.

If the Python or terminal application isn’t listed, you may need to manually add it.

### 4. **Reinitialize the Joystick Module in Pygame**:
Sometimes, reinitializing the joystick module can help detect devices properly. You can do this explicitly with the following code:

```python
import pygame

# Quit and reinitialize the joystick module
pygame.joystick.quit()
pygame.joystick.init()

joystick_count = pygame.joystick.get_count()
print(f"Number of joysticks detected after reinit: {joystick_count}")
```

### 5. **Test with a Different Joystick**:
If possible, try using a different joystick to see if the issue is specific to the one you are currently using. Some joysticks may not be fully supported by pygame on macOS, especially those that require specific drivers.

### 6. **Try Running in a Different Backend**:
OpenSesame can use different backends to manage input devices. If you're using OpenSesame and pygame for your experiment, try switching to a different backend like **legacy** or **xpyriment**:

1. Go to **Tools** → **Preferences** → **General** in OpenSesame.
2. Change the **backend** to `legacy` or `xpyriment`.

This might help if the issue is with how pygame interacts with the joystick on macOS.

### 7. **Test the Joystick with Another Library**:
If pygame still doesn’t detect your joystick, try testing the joystick with a different Python library like **SDL2** (which pygame is built on) or **PyObjC** (which has better macOS-specific support).

### Example with PyObjC:

```bash
pip install pyobjc-framework-GameController
```

You can use the `GameController` framework to access joysticks and gamepads more natively on macOS.

### 8. **Try External Gamepad Mapping Tools**:
If pygame can't detect the joystick, try using a third-party tool that maps joystick inputs to keyboard or mouse actions. Tools like **GamePad Companion**, **Joystick Mapper**, or **ControllerMate** can sometimes bridge the gap between macOS and pygame.

### Summary:
1. **Ensure the joystick module is initialized** in pygame.
2. **Check macOS Security & Privacy settings** to allow Python or terminal apps to access input devices.
3. **Reinitialize the joystick module** in pygame.
4. **Try using a different joystick** to rule out device-specific issues.
5. **Switch to a different backend** in OpenSesame if applicable.
6. **Test the joystick with other libraries** like PyObjC if pygame fails.

Let me know if any of these steps help, or if you need further assistance!

---

# Set python 3.11 as default

To set **Conda** to use **Python 3.11** as the default in a particular environment, you need to either create a new Conda environment with Python 3.11 or update an existing environment to use Python 3.11. Here's how to do both:

### 1. **Create a New Conda Environment with Python 3.11**:

If you don't already have an environment with Python 3.11, you can create a new one:

```bash
conda create --name py311 python=3.11
```

- This will create a new environment called `py311` with Python 3.11.
- After the environment is created, you can activate it:

```bash
conda activate py311
```

Now, every time you activate this environment (`py311`), it will use Python 3.11 by default.

### 2. **Update an Existing Conda Environment to Python 3.11**:

If you already have an existing environment and you want to upgrade the Python version in that environment to 3.11, follow these steps:

1. **Activate the existing environment** you want to update (replace `your-env` with the environment name):

   ```bash
   conda activate your-env
   ```

2. **Update the environment to use Python 3.11**:

   ```bash
   conda install python=3.11
   ```

This will update Python in the current Conda environment to version 3.11. After updating, whenever you activate this environment, it will use Python 3.11.

### 3. **Set Conda to Always Use Python 3.11 in New Environments**:

If you want to make sure Conda always uses Python 3.11 by default when creating new environments, you can modify the Conda configuration:

1. Open your terminal and run the following command to create a Conda configuration file (if it doesn’t already exist):

   ```bash
   conda config --set default_python 3.11
   ```

2. Now, every time you create a new environment with `conda create --name new-env`, it will default to Python 3.11.

### 4. **Check Python Version in Conda Environment**:

After creating or updating an environment, you can verify the Python version by running:

```bash
python --version
```

This will show the Python version currently being used in the active Conda environment.

### Summary:
- **Create a new environment with Python 3.11**: `conda create --name py311 python=3.11`
- **Update an existing environment to Python 3.11**: `conda install python=3.11`
- **Set Python 3.11 as default for new environments**: `conda config --set default_python 3.11`

Let me know if this works for you or if you run into any issues!

In Conda, the asterisk (`*`) next to `base` in your environment list indicates that the **`base` environment** is currently the active one, but **it does not indicate the default environment**. By default, Conda activates the `base` environment when you open a terminal or a new shell.

If you want to make **`py311`** your default environment (i.e., the environment that automatically activates when you open a new terminal or start a new shell), you can modify your Conda settings to achieve this.

### Steps to Make `py311` the Default Environment:

1. **Deactivate Auto-Activation of Base Environment** (Optional):
   
   If you want to stop Conda from automatically activating the `base` environment every time you open a terminal, you can disable this feature by running:

   ```bash
   conda config --set auto_activate_base false
   ```

   This will prevent Conda from automatically activating `base`, and it will leave you in the system shell by default when you open a new terminal.

2. **Add Conda Initialization to Auto-Activate `py311`**:

   To make **`py311`** automatically activate whenever you open a terminal, you can add the activation command to your shell configuration file.

   ### For **zsh** (default shell on newer macOS versions like Catalina and later):
   - Open the `.zshrc` configuration file in an editor:

     ```bash
     nano ~/.zshrc
     ```

   - Add the following line at the bottom of the file to automatically activate the `py311` environment when a new terminal session starts:

     ```bash
     conda activate py311
     ```

   - Save and close the file (in **nano**, press `Ctrl+X`, then `Y`, then `Enter`).

   - Apply the changes by running:

     ```bash
     source ~/.zshrc
     ```

   ### For **bash** (if you're using the older bash shell):
   - Open the `.bash_profile` file:

     ```bash
     nano ~/.bash_profile
     ```

   - Add the same line at the bottom of the file:

     ```bash
     conda activate py311
     ```

   - Save, close, and apply the changes:

     ```bash
     source ~/.bash_profile
     ```

3. **Test the Changes**:
   
   Open a new terminal window or tab, and it should automatically activate the `py311` environment without needing to manually type `conda activate py311`.

### Summary:
- The asterisk (`*`) only indicates the currently active environment in your session, not the default.
- To change the default environment to `py311`, disable `base` auto-activation (`conda config --set auto_activate_base false`) and modify your shell configuration (`.zshrc` or `.bash_profile`) to auto-activate `py311`.

Let me know if you encounter any issues or need more assistance!

---

# Project specific environment Activation

There are a few considerations to keep in mind when setting **`py311`** (or any other environment) to automatically activate as your default Conda environment. Here are the pros and cons of doing this:

### **Pros**:
1. **Convenience**:
   - If you work primarily in the `py311` environment, auto-activating it saves you the step of having to manually activate it every time you open a terminal.

2. **Avoid Mistakes**:
   - You won't accidentally work in the `base` environment, which could lead to installing packages there that could conflict with Conda's system management packages or clutter your `base` environment.

### **Cons** / **Things to Keep in Mind**:

1. **Performance Overhead**:
   - Each time you open a new terminal, Conda will have to activate the environment. While this is generally quick, it may introduce a slight delay when starting new terminal sessions.

2. **Potential Conflicts with Other Projects**:
   - If you work on multiple projects that use different Conda environments (or no environment at all), automatically activating `py311` could lead to confusion. You might accidentally run a project in the `py311` environment when it was designed for a different environment.
   - In this case, you might need to deactivate the environment manually (`conda deactivate`) to switch to a different environment.

3. **Shell Script Complexity**:
   - If you use your terminal for multiple purposes (not just Python development), having Conda automatically activate a specific environment can sometimes interfere with other shell tasks or scripts that expect a different environment or no environment at all.
   
4. **Managing Multiple Conda Environments**:
   - If you regularly switch between environments for different projects, you may find it cumbersome to have `py311` automatically activate every time. In such cases, you might prefer to manually activate the environment as needed.

### **Alternative Solution**: Use Project-Specific Environment Activation

If you're managing multiple Python projects, an alternative approach would be to use **project-specific environments**. Instead of globally auto-activating `py311`, you can create a file in each project directory that will automatically activate the right environment when you enter that directory:

1. **Enable Conda Environment Detection**:
   - You can enable Conda's **environment auto-activation** feature. Conda will automatically activate the correct environment when you navigate to a directory that contains an `.env` file specifying the environment.

   To do this, run:

   ```bash
   conda config --set auto_activate_base false
   ```

2. **Create a `.conda-env` file**:
   - In the root directory of a project where you want to use `py311`, create a hidden file named `.conda-env` that contains the environment name:

     ```bash
     echo "py311" > .conda-env
     ```

   - Now, every time you navigate to that project directory in the terminal, Conda will automatically activate the `py311` environment.

### **Conclusion**:
If you primarily use the `py311` environment and do not switch between many projects, auto-activating the environment is convenient and has minimal downsides. However, if you work on multiple projects with different environments, it might be better to either manually activate environments or use project-specific environment activation.

Let me know if you'd like help setting up any of these alternatives!
