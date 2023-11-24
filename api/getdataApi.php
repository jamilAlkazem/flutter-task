<?php

if (isset($_POST['userId'])) {
  include 'databaseConnect.php';
  $userId = mysqli_real_escape_string($conn, $_POST['userId']);


  $x = ['id' => '', 'name' => '', 'phone' => '', 'address' => '', 'birthday' => '', 'email' => ''];
  $sql = "SELECT * FROM data where userId='" . $userId . "'";
  $result = $conn->query($sql);
  while ($row = $result->fetch_assoc()) {
    $x = array('id' => $row['id'], 'name' => $row['name'], 'phone' => $row['phone'], 'address' => $row['address'], 'birthday' => $birthday = str_replace("-", "/", date("d-m-Y", strtotime($row['birthday']))), 'email' => $row['email']);
  }

  echo json_encode($x, JSON_UNESCAPED_UNICODE);
}