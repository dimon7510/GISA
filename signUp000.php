<?php

if(isset($_GET)) {

$userName = base64_decode ($_GET["userName"]);
$passWord =  base64_decode ($_GET["password"]);
$firstName =  base64_decode ($_GET["firstName"]);
$lastName =  base64_decode ($_GET["lastName"]);
$caltransID =  base64_decode ($_GET["caltransID"]);
$phone =  base64_decode ($_GET["phone"]);
$email =  base64_decode ($_GET["email"]);
}

$servername = "localhost";
$username = "id9279745_gisauser";
$password = "drakon1975gisa";
$dbname = "id9279745_gisa";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$result = array();

//retrive caltranse ID to check if entry exists
$queryCaltrnsID = "SELECT * FROM EMPLOYEE WHERE CaltransID =  '$caltransID' ";
$dbResultID = $conn->query($queryCaltrnsID);
//return database error if entry query error
if (!$dbResultID ){
	//echo "query failed";
	$result["result"] = 403;
	$result["message"] = mysqli_error($conn);
	echo json_encode($result);
	mysqli_free_result($dbResultID);
	exit();
}


//Retrive username if username is free
$queryUserName = "SELECT * FROM EMPLOYEE WHERE  UserName = '$userName' ";
$dbResultUserName = $conn->query($queryUserName);
	//return database error if entry query error
if (!$dbResultUserName ){
	//echo "query failed";
	$result["result"] = 403;
	$result["message"] = mysqli_error($conn);
	echo json_encode($result);
	mysqli_free_result($dbResultUserName);
	exit();
}


//check if caltrans ID exists
$caltransIDResult = array();
$caltransIDResult = mysqli_fetch_array($dbResultID);
if ($caltransIDResult != NULL){
	//echo "query failed";
	$result["result"] = 405;
	$result["message"] = "caltrans ID exists in system";
	echo json_encode($result);
	mysqli_free_result($dbResultID);
	exit();
}



//check if username exists
$usernameResult = array();
$usernameResult = mysqli_fetch_array($dbResultUserName);
if ($usernameResult != NULL){
	//echo "query failed";
	$result["result"] = 406;
	$result["message"] = "username is taken. ";
	echo json_encode($result);
	mysqli_free_result($dbResultUserName);
	exit();
}


$sql = "INSERT INTO EMPLOYEE (CaltransID, FirstName, LastName , Phone, Email,Username, Password)
VALUES ('$caltransID', '$firstName', '$lastName', '$phone', '$email', '$userName', '$passWord')";

if ($conn->query($sql) == TRUE) {
	$result["result"] = 200;
	$result["message"] = "Account created successfully";
	echo json_encode($result);
    mysqli_free_result($dbResultUserName);
} else {
	$result["result"] = 403;
	$result["message"] = mysqli_error($conn);
	echo json_encode($result);
	mysqli_free_result($dbResultUserName);
	exit();
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


