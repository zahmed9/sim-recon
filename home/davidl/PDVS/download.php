<?php

include_once("config.php");

$DEBUG = 0;

//------------------------ Access Database --------------------------
$link = mysql_connect($MYSQL_HOST, $MYSQL_USER, $MYSQL_PASSWORD) or die(mysql_error());
mysql_select_db($MYSQL_DATABASE) or die(mysql_error());

$fileid = $_REQUEST["fileid"];

// Get mime type
$query = "SELECT mime_type,filename FROM files WHERE fileid=\"$fileid\"";
$mysql_result = mysql_query($query) or die (mysql_error());
$row = mysql_fetch_array($mysql_result);
$filename = $row["filename"];
$mime_type = $row["mime_type"];
if($mime_type == "")$mime_type = "text/plain";

// Replace the header sent to the browser to tell it the data type and filename
header('Content-type: $mime_type'); 
header("Content-Disposition: attachment; filename=\"$filename\"");

// Get this file from database and send to browser
include_once("file_utilities.php");
print GetFile($fileid);

?>
