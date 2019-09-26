<?php

# Delay by a few seconds to simulate slower load
echo date('h:i:s') . "\n";
sleep(2);
echo date('h:i:s') . "\n";

# Print out all headers
$headers = getallheaders();
foreach($headers as $key=>$val){
  echo $key . ': ' . $val . '<br>';
}

# Print pod hostname
echo gethostname();
?>

<br/>
