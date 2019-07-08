## POWERSHELL CONTENT LIBRARY UPLOADER V1.0
  
This script calls the Qlik Sense Engine API to upload files from a local folder to a content library. It is mainly intended to enable the hosting of local JSON, HTML or other REST files on the Qlik Sense server without configuring an additional webserver, with the additional benefit of being able to maintain a content library locally. 

The script first gets API info to establish a user session. Then the existing contentlibrary is emptied and the files in the local storages are reuploaded.

For this script to work, 3 variables need to be defined:
    
    1. $qsServer    -  The computer name or proxy path of your Qlik Sense server 
    2. $inputFolder -  The path to the folder that serves as input for the content library 
    3. $libname     -  The name of an already existing Qlik Sense content library that serves as the destination.

Feel free to make suggestions and ask questions!
