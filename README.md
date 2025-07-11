# lsp-macos-pks

LSP repository to build packages for macOS.

This repository provides the logic to build packages of lsp-plugins
for macOS for Apple Silicon based Macs.

# macOS Installation Notice
The .pkg installer is not signed. The result, macOS will block it from running the first time.

To proceed with the installation:

1. Attempt to Open the .pkg File Once <br>
Double-click the .pkg file. macOS will show a message that the app cannot be opened because it is from an unidentified developer.
Click Cancel to close the message.

2. Go to System Settings<br>
Open System Settings → Privacy & Security.

3. Allow the Blocked Installer<br>
Scroll down to the Security section. You will see a message saying that the installer was blocked.
Click "Allow Anyway".

4. Re-open the Installer<br>
Open the .pkg file again. You will now have the option to proceed by clicking Open and entering your password if prompted.

![image](https://github.com/Marvo2011/lsp-macos-pkg/blob/master/res/doc/Installer-1.png)

![image](https://github.com/Marvo2011/lsp-macos-pkg/blob/master/res/doc/Installer-2.png)
