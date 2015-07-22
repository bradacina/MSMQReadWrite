param(
  [string]$queueName = $(throw "-queueName is required")
)

[Reflection.Assembly]::LoadWithPartialName("System.Messaging")

$queueName = '.\Private$\' + $queueName;
$queue = new-object System.Messaging.MessageQueue $queueName;
$utf8 = new-object System.Text.UTF8Encoding;

$msgs = $queue.GetAllMessages();
$msgs | % {$i = 1}{
  Clear-Host
  write-host ("Message #" + $i.ToString() + " out of " + $msgs.Count)
  write-host $utf8.GetString($_.BodyStream.ToArray())

  write-host "(n) Next message, (w) Write to file and go to next message, (q) Quit"

  $selection = [Console]::ReadKey($true)

  if ($selection.KeyChar -eq 'q') {
    break
  }

  if ($selection.KeyChar -eq 'w') {
    $utf8.GetString($_.BodyStream.ToArray()) | Out-File -Append "SavedMessages.txt"
    "==============" | Out-File -Append "SavedMessages.txt"
  }

  $i++;
};
