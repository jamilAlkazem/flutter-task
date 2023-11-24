<?php

include 'databaseConnect.php';

if (isset($_POST["name"])) {
  $userId = mysqli_real_escape_string($conn, $_POST['userId']);
  $name = mysqli_real_escape_string($conn, $_POST['name']);
  $email = mysqli_real_escape_string($conn, $_POST['email']);
  $phone = mysqli_real_escape_string($conn, $_POST['phone']);
  $birthday = mysqli_real_escape_string($conn, $_POST['birthday']);
  $address = mysqli_real_escape_string($conn, $_POST['address']);
  $birthday = str_replace("/", "-", $birthday);
  $birthday = date("Y-m-d", strtotime($birthday));
  $x = ['status' => 'false'];
  $sql = "select email from data where userId='" . $userId . "'";
  $result = $conn->query($sql);
  if ($result->num_rows > 0) {
    $sql = "UPDATE data set name = '$name' ,email = '$email' ,phone = '$phone' ,birthday = '$birthday' ,address = '$address' WHERE  userId='" . $userId . "'";
    if ($conn->query($sql) === TRUE) {
      $x['status'] = 'success';
    } else {
      $x['status'] = 'fail';
    }
  } else {
    $sql = "INSERT INTO `data` VALUES (NULL,'$userId','$name', '$email', '$phone', '$birthday', '$address')";
    if ($conn->query($sql) === TRUE) {
      $x['status'] = 'success';
    } else {
      $x['status'] = 'fail';
    }
  }

  echo json_encode($x, JSON_UNESCAPED_UNICODE);
}

$conn->close();
