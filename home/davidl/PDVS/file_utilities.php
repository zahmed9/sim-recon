<?php

//----------------------
// AddFileToDocument
//----------------------
function AddFileToDocument($id, $version, $filename, $submitter, $size, $tmpname)
{
	// Get mime type for uploaded file. PHP has an optional routine
	// called mime_content_type() that would do just what we need
	// here. However, it wasn't available on my installation so I'll
	// assume it's not standard. We use the standard unix "file" command
	// instead with options to print out mime types
	$mime_type = exec("file -i -b $tmpname");

	$query = "INSERT INTO files (id,version,filename,original_filename,submitter,size,mime_type,created) ";
	$query .= "VALUES(\"$id\",\"$version\",\"$filename\",\"$filename\",\"$submitter\",\"$size\",\"$mime_type\",NOW())";
	mysql_query($query) or die(mysql_error());
	$fileid = mysql_insert_id();	
	
	// To store the file safely and efficiently in the MySQL database
	// we need to compress and then encode the file.
	
	// Read entire file in
	$fd = fopen($tmpname,"r");
	$data = fread($fd,$size);
	fclose($fd);
	
	// Compress the data
	$compressed_data = gzcompress($data);
	
	// Encode in an ASCII based format
	$encoded_data = base64_encode($compressed_data);
	
	// Insert encoded file into filecontents table
	$query = "INSERT INTO filecontents (fileid,data,created) ";
	$query .= "VALUES(\"$fileid\",\"$encoded_data\",NOW())";
	mysql_query($query) or die(mysql_error());
		
	return $fileid;
}

//----------------------
// GetFile
//----------------------
function GetFile($fileid)
{
	$query = "SELECT data FROM filecontents WHERE fileid=\"$fileid\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$row = mysql_fetch_array($mysql_result);

	return gzuncompress(base64_decode($row["data"]));
}

?>
