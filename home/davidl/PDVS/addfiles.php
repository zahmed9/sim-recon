<?php
include("header.php");

include_once("file_utilities.php");

switch($_REQUEST["submit_button"]){
	case "Add Files":
		AddFiles($_REQUEST["id"], $_REQUEST["version"]);
		break;
	default:
		AddFilesForm($_REQUEST["id"], $_REQUEST["version"]);
}

?>
<p></p>
<center><A href="showdocument.php?id=<?=$_REQUEST["id"]?>"><h3>Return to Document Page</h3></A></center>
<?php

include("footer.php");
?>

<?php
//-----------------
// AddFilesForm
//-----------------
function AddFilesForm($id, $version)
{
	global $submitters;
	$nfiles = 5;

	// Get all info for this document
	$query = "SELECT * FROM documents WHERE id=\"$id\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$doc = mysql_fetch_array($mysql_result);
	if($version=="")$version = $doc["version"];
	$creator = $doc["creator"];
	
	// Get all files for this version
	$query = "SELECT * from files WHERE id=\"$id\" AND version=\"$version\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	while($row = mysql_fetch_array($mysql_result))$files[] = $row;

	// Get all version numbers for this document
	$query = "SELECT version from files WHERE id=\"$id\" ";
	$query .= "AND version!=\"$version\" GROUP BY version ORDER BY version DESC";
	$mysql_result = mysql_query($query) or die(mysql_error());
	while($row = mysql_fetch_array($mysql_result))$versions[] = $row["version"];

	?>
	<center>
	<h1>Add Files To <?=$doc["title"]?></h1>
	<i>version <?=$version?></i>
	</center>
	<p></p>
	
	Description:
	<center>
	<table border="1">
	<TR>
		<TD width="500"><?=$doc["description"]?></TD>
	</TR>
	</table>
	</center>
	<p></p>
	
	<form enctype="multipart/form-data" method="post">
	<table bordercolor="green" border="5">
	<TR><TD>
	
	<table border="0" width="100%">
		<TR><TD colspan="4" align="center"><font size="+2"><b>Existing files in this version:</b></font></TD></TR>
		<TR><TD colspan="4" height="10"></TD></TR>

		<TR>
			<TH align="left">File:</TH>
			<TH align="left">Size:</TH>
			<TH align="left">Submitter:</TH>
			<TH align="left">Uploaded:</TH>
		</TR>
		
		<TR>
			<TD height="3" bgcolor="#101010"></TD>
			<TD height="3" bgcolor="#101010"></TD>
			<TD height="3" bgcolor="#101010"></TD>
			<TD height="3" bgcolor="#101010"></TD>
		</TR>
		
		<?php
		foreach($files AS $file){
			$filename = $file["filename"];
			$size = $file["size"];
			$submitter = $file["submitter"];
			$uploaded = $file["created"];
			$fileid = $file["fileid"];
			?>
			<TR>
				<TD><A href="download.php?fileid=<?=$fileid?>"><?=$filename?></A></TD>
				<TD><?=$size?></TD>
				<TD><?=$submitter?></TD>
				<TD><?=$uploaded?></TD>
			</TR>
			<?php
		}
		?>

		<TR><TD colspan="4" height="20"></TD></TR>
		<TR><TD colspan="4" align="center"><font size="+2"><b>Files to add to this version:</b></font></TD></TR>
		<TR><TD colspan="4" height="4" bgcolor="#901090"></TD></TR>

		<TR>
			<TD align="right" colspan="2">Submitter (you):</TD>
			<TD colspan="2">
				<input type="text" name="submitter" value="<?=$creator?>" width="50">
				OR <font size="-1">select from this list</font>
				<SELECT name="submitter_menu">
					<OPTION value=""></OPTION>
					<?php
					foreach($submitters AS $submitter){
						?>
						<OPTION value="<?=$submitter?>"><?=$submitter?></OPTION>
						<?php
					}
					?>
				</SELECT>
			</TD>
		</TR>

		<?php
		for($i=1;$i<$nfiles;$i++){
			?>
			<TR><TD colspan="4" align="center"><input name="userfile[]" type="file"></TD></TR>
			<?php
		}

		?>

		<TR>
			<TD colspan="4" align="center" height="50">
				<input type="submit" name="submit_button" value="Add Files">
			</TD>
		</TR>
	</table>
	
	</TD></TR>
	</table>
	</form>
	<p></p>
	
	Other versions of this document:
	<?php
	foreach($versions AS $v){
		?>
		<A href="showdocument.php?id=<?=$id?>&version=<?=$v?>"><?=sprintf("v%02d",$v)?></A>,
		<?php
	}
	?>
	<p></p>

	<center>	
	<A href="updatedocument.php?id=<?=$id?>">Update This Document</A>
	</center>
	<?php
}

//--------------------
// AddFiles
//--------------------
function AddFiles($id, $version)
{
	global $MAX_FILES_PER_DOCUMENT;

	// Insert new row in documents table
	$submitter = $_REQUEST["submitter"];
	if($_REQUEST["submitter_menu"] != "")$submitter = $_REQUEST["submitter_menu"];

	// Get all info for this document
	$query = "SELECT * FROM documents WHERE id=\"$id\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$doc = mysql_fetch_array($mysql_result);
	$title = $_REQUEST["title"];
	
	$name = sprintf("d%03d-v%02d", $id, $version);
	?>
	Document <b><?=$name?></b> with title "<?=$title?>"
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

	<?php
}

?>
