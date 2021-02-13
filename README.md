# AmongUs-ModDownloader
Among us Mod downloader and installer

1. enter a github project, exemple : https://github.com/[User-Name]/[project-name]

what the code do is :
1. check at 3 differents folder if "among us" exist
2. ask you which mod you want to download
3. check on the github page source code if it find a match with and [.zip|.rar|.7z] and the user input before
4. download the compressed file
5. download 7zip if you don't have it
6. unzip the compressed file with 7zip (because powershell can't extract rar files)
7. create a shortcut
8. delete 7zip if you had to download it
