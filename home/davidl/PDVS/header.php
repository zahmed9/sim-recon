<?php

include_once("config.php");

//------------------------ Access Database --------------------------
$link = mysql_connect($MYSQL_HOST, $MYSQL_USER, $MYSQL_PASSWORD) or die(mysql_error());
mysql_select_db($MYSQL_DATABASE) or die(mysql_error());

// Get list of creators
$query = "SELECT creator FROM documents GROUP BY creator ORDER BY creator";
$mysql_result = mysql_query($query) or die(mysql_error());
$creators = array();
while($row = mysql_fetch_array($mysql_result))$creators[] = $row["creator"];

// Get list of submitters
$query = "SELECT submitter FROM files GROUP BY submitter ORDER BY submitter";
$mysql_result = mysql_query($query) or die(mysql_error());
$submitters = array();
while($row = mysql_fetch_array($mysql_result))$submitters[] = $row["submitter"];

// Get List of documents
$query = "SELECT * FROM documents ORDER BY modified DESC";
$mysql_result = mysql_query($query) or die(mysql_error());
$documents = array();
while($row = mysql_fetch_array($mysql_result))$documents[] = $row;


?>
<HTML>
<HEAD>
<TITLE><?=$HTML_TITLE?></TITLE>
</HEAD>

<BODY background="white">
<center><h1><?=$HTML_TITLE?></h1></center>
<p></p>
<center>
<table border="0" width="75%">
	<?php
	$width = "50%";
	?>
	<TR>
		<TD align="center" width="<?=$width?>"><A href="index.php">Home</A></TD>
		<TD align="center" width="<?=$width?>"><A href="create_document.php">Create Document</A></TD>
	</TR>
</table>
<hr>
