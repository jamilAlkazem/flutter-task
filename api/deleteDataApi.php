<?php

include 'databaseConnect.php';

if (isset($_POST["userId"])) {
  $userId = mysqli_real_escape_string($conn, $_POST['userId']);
  $x = ['status' => 'false'];
  $sql = "delete from data where userId='" . $userId . "'";
  if ($conn->query($sql) === TRUE) {
    $x['status'] = 'success';
  } else {
    $x['status'] = 'fail';

  }

  echo $x['status'];
}

$conn->close();
