<?php
include_once("header.php");
include_once("file_utilities.php");

switch($_REQUEST["submit_button"]){
	case "Update Document":
		UpdateDocument();
		break;
	default:
		UpdateDocumentForm();
}

include("footer.php");


//--------------------
// UpdateDocumentForm
//--------------------
function UpdateDocumentForm()
{
	global $creators;

	$id = $_REQUEST["id"];
	$name = sprintf("d%03d",$id);
	
	// Get document info
	$query = "SELECT * FROM documents WHERE id =\"$id\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$doc = mysql_fetch_array($mysql_result);
	$creator = $doc["creator"];
	$title = $doc["title"];
	$description = $doc["description"];
	$version = $doc["version"];
	
	// Get list of files
	$query = "SELECT * FROM files WHERE id =\"$id\" AND version=\"$version\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$files = array();
	while($row = mysql_fetch_array($mysql_result))$files[] = $row;
	$nfiles = count($files);

	?>
	<center>
	<h1>Update Document <?=$name?></h1>
	<h2><?=$title?></h2>
	<p></p>

	<form enctype="multipart/form-data" method="post">
	<table border="0">
	<TR>
		<TD align="right">Creator :</TD>
		<TD align="left"><?=$creator?></TD>
	</TR>
	<TR>
		<TD align="right">Submitter (you):</TD>
		<TD><input type="text" name="submitter" value="<?=$creator?>" width="50">
			OR <font size="-1">select from this list</font>
			<SELECT name="submitter_menu">
				<OPTION value=""></OPTION>
				<?php
				foreach($creators AS $creator){
					?>
					<OPTION value="<?=$creator?>"><?=$creator?></OPTION>
					<?php
				}
				?>
			</SELECT>
		</TD>
	</TR>
	<TR>
		<TD align="right">Document Title:</TD>
		<TD><input type="text" name="title" value="<?=$title?>" width="80"></TD>
	</TR>
	<TR>
		<TD align="right">Description:</TD>
		<TD><textarea name="description" cols="80" rows="10"><?=$description?></textarea></TD>
	</TR>

	<TR><TD colspan="2" height="20"></TD></TR>

	<TR>
		<TH align="left">Files from previous version(v<?=$version?>)</TH>
		<TH align="center">Files for this version</TH>
	</TR>

	<TR>
		<TD height="3" bgcolor="#901090"></TD>
		<TD height="3" bgcolor="#901090"></TD>
	</TR>

	<?php
	foreach($files AS $file){
		?>
		<TR>
			<TD align="left"><?=$file["filename"]?></TD>
			<TD align="center"><input name="userfile[]" type="file"></TD>		
		</TR>
		<?php
	}
	if(count($files)<1){
		?>
		<TR>
			<TD align="left"><?=$file["filename"]?></TD>
			<TD align="center"><input name="userfile[]" type="file"></TD>		
		</TR>
		<?php
	}
	?>

	<TR><TD colspan="2" height="20"></TD></TR>

	<TR>
		<TD colspan="2" align="center" height="50">
			<input type="submit" name="submit_button" value="Update Document">
		</TD>
	</TR>
	</table>
	</form>
	</center>
	<?php
}

//--------------------
// UpdateDocument
//--------------------
function UpdateDocument()
{
	global $MAX_FILES_PER_DOCUMENT;

	$id = $_REQUEST["id"];

	// Get old version number
	$query = "SELECT version FROM documents WHERE id=\"$id\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$row = mysql_fetch_array($mysql_result);
	$version = $row["version"]+1;

	// Update row in documents table
	$submitter = mysql_escape_string($_REQUEST["submitter"]);
	if($_REQUEST["submitter_menu"] != "")$submitter = $_REQUEST["submitter_menu"];
	$title = mysql_escape_string($_REQUEST["title"]);
	$description = mysql_escape_string($_REQUEST["description"]);
	$query = "UPDATE documents set title=\"$title\",description=\"$description\",version=\"$version\" ";
	$query .= "WHERE id=\"$id\"";
	mysql_query($query) or die(mysql_error());
	
	$name = sprintf("d%03d-v%02d", $id, $version);
	?>
	Updated document <b><?=$name?></b> with title "<?=$title?>"
	to version <?=sprintf("v%02d", $version)?>.
	<p></p>
	<table>
	
	<?php

	// Loop over files
	for($i=0;$i<$MAX_FILES_PER_DOCUMENT;$i++){
		$original_filename = $_FILES['userfile']['name'][$i];
		$tmpname = $_FILES['userfile']['tmp_name'][$i];
		$size = $_FILES['userfile']['size'][$i];

		if(!is_uploaded_file($tmpname))continue;
		
		$fileid = AddFileToDocument($id, $version, $original_filename, $submitter, $size, $tmpname);

		?>
		<TR>
			<TD align="left">Added "<?=$original_filename?>"</TD>
			<TD align="left">(<?=$size?> bytes)</TD>
			<TD align="left">to <b><?=$name?></b></TD>
		</TR>
		<?php
	}
	
	?>
	</table>
	<p></p>
	
	Go to <A href="showdocument.php?id=<?=$id?>">document page</A>

	<?php
}
?>
