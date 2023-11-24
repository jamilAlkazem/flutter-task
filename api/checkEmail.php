<?php

include 'databaseConnect.php';


if (isset($_POST["email"])) {
  $email = mysqli_real_escape_string($conn, $_POST['email']);
  $userId = mysqli_real_escape_string($conn, $_POST['userId']);


  $sql = "select email from data where email='" . $email."' and userId != '" . $userId."'";
  $result = $conn->query($sql);
  if ($result->num_rows > 0) {
    echo '* email is already taken';
  } else {
    echo 'emailNotExist';
  }
}

$conn->close();
