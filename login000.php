<?php

if(isset($_GET)) {
$userName = base64_decode ($_GET["userName"]);
$passWord =  base64_decode ($_GET["password"]);
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


//check if username exists
$usernameResult = mysqli_fetch_array($dbResultUserName);
if ($usernameResult == NULL){
	//echo "query failed";
	$result["result"] = 404;
	$result["message"] = "Username is not registered ";
	echo json_encode($result);
	mysqli_free_result($dbResultUserName);
	exit();
}

//autentificate user
if (strcmp($usernameResult["Password"], md5($passWord))){
	$result["result"] = 200;
	$result["message"] = "You are logged in.";
	$result["ID"] = $usernameResult["CaltransID"];
	echo json_encode($result);
    mysqli_free_result($dbResultUserName);
} else {
	$result["result"] = 404;
	$result["message"] = "Password - Username combination incorrect.";
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


