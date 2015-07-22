param(
  [string]$queueName = $(throw "-queueName is required"),
  [string]$fileName = "SavedMessages.txt"
)

[Reflection.Assembly]::LoadWithPartialName("System.Messaging")

$queueName = '.\Private$\' + $queueName;

$content = Get-Content $filename

$messages = @()
$oneMsg = ""

$content | % {
  if ($_ -eq "==============") {
    $messages += $oneMsg
    $oneMsg = ""
  } else {
    $oneMsg += $_ + "`r`n"
  }
}

$msgLabel = 'Message label';
$queue = new-object System.Messaging.MessageQueue $queueName;
$utf8 = new-object System.Text.UTF8Encoding;

$messages | % {
  $tran = new-object System.Messaging.MessageQueueTransaction;
  $tran.Begin();
  $msgContent = $_;
  $msgBytes = $utf8.GetBytes($msgContent);

  $msgStream = new-object System.IO.MemoryStream;
  $msgStream.Write($msgBytes, 0, $msgBytes.Length);

  $msg = new-object System.Messaging.Message;
  $msg.BodyStream = $msgStream;
  $msg.Label = $msgLabel;
  $queue.Send($msg, $tran);
  $queue.Send($msg);

  $tran.Commit();
}
