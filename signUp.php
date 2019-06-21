<?php

if(isset($_GET)) {

$userName = base64_decode($_GET["userName"]);
$password = base64_decode($_GET["password"]);
$firstName = base64_decode($_GET["firstName"]);
$lastName = base64_decode($_GET["lastName"]);
$caltransID = base64_decode($_GET["caltransID"]);
$phone = base64_decode($_GET["phone"]);
$email = base64_decode($_GET["email"]);
}

$servername = "sql301.byethost16.com";
$username = "b16_23684393";
$password = "drakon1975Gisa";
$dbname = "EMPLOYEE";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$sql = "INSERT INTO EMPLOYEE (FirstName, LastName, CaltransID, Phone, Email,Username, Password)
VALUES ($firstname, $lastName, $caltransID, $phone, $email, $userName, $password)";

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

/*
$query = 'SELECT * FROM EMPLOYEE WHERE playername="' . mysql_real_escape_string($playername) . '" or email="' . mysql_real_escape_string($loginid) . '"';
$dbresult = mysql_query($query, $link);

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}
*/

$conn->close();
/*
if (!$dbresult) {
//echo "query failed";
$result = array();
$result["result"] = 403;
$result["message"] = mysql_error();
echo json_encode($result);
mysql_free_result($dbresult);
exit;
}
*/
?>


