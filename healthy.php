<?php
$server = "localhost";         # MySQL 伺服器
$dbuser = "root";       # 使用者帳號
$dbpassword = "1234NewPassWord!"; # 使用者密碼
$dbname = "sbtest";    # 資料庫名稱

# 連接 MySQL 資料庫
$connection = new mysqli($server, $dbuser, $dbpassword, $dbname);

# 檢查連線是否成功
if ($connection->connect_error) {
  $data = [ 'mysql_status' => 'ERROR'];
} else {
  $data = [ 'mysql_status' => 'OK'];
}

$connection->close();

header('Content-Type: application/json');
echo json_encode($data);
?>