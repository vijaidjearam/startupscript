# Variables that needs to be changed when forking the Repo:
- Registryrunonce.ps1 -> $repopath = "https://raw.githubusercontent.com/vijaidjearam/startupscript/master/" change the value according to your Repo
- registry_run_once_install_win_with_recovery.ps1 -> $repopath = "https://raw.githubusercontent.com/vijaidjearam/startupscript/master/" change the value according to your Repo
- Autounattend-WinEdu.xml -> change the value in the Run synchronous command according to you Repo

  ```
  				<RunSynchronousCommand wcm:action="add">
					<Order>1</Order>
					<Path>powershell -NoLogo -Command &quot;(new-object System.Net.WebClient).DownloadFile(&apos;https://raw.githubusercontent.com/vijaidjearam/startupscript/master/registryrunonce.ps1&apos;, &apos;c:\windows\temp\header.ps1&apos;)&quot;</Path>
				</RunSynchronousCommand>  
  ```
-  repeat the same steps for all the Autounattend-xml
# To create custom windows USB
- Download windows ISO via media creation tool (make sure you download 64 bit image)
- Copy provisioning-win-edu or provisioning-win-pro and autounattend.xml(UEFI or MBR) to the root of the usb.
- Launch the provisioning-win-edu or provisioning-win-pro according to your needs.
- Wait for the process to complete.
- If everything goes right with out error your usb would be good to go... :joy:

# To create custom windows ISO
- Download windows ISO via media creation tool (make sure you download 64 bit image)
- Decompress the ISO to a folder and copy provisioning-win-edu or provisioning-win-pro and autounattend.xml(UEFI or MBR) to the root of the folder.
- Launch the provisioning-win-edu or provisioning-win-pro according to your needs.
- Wait for the process to complete.
- If everything goes right the custom script is injected to setupcomplete.cmd and the next step is to create the iso
- Go to Bootable-Windows-ISO-Creator-master folder and execute the bootable_windows_iso_creator.bat.
- The oscdimg folder contains all the necessary file to create the bootable ISO.







