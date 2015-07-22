# MSMQReadWrite
Powershell scripts to read/write from/to MSMQ

**ReadQueue.ps1 -queueName \<queueName\>**

will read messages from the \<queueName\> and will allow you to save selected
messages to a file on disk (SavedMessages.txt)

**WriteQueue.ps1 -queueName \<queueName\> [-fileName \<fileName\>]**

will write messages from \<fileName\> (or if unspecified from SavedMessages.txt)
onto the specified \<queueName\>
