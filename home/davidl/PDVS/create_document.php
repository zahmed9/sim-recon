<?php
include("header.php");
include_once("file_utilities.php");

switch($_REQUEST["submit_button"]){
	case "Create Document":
		CreateDocument();
		break;
	default:
		CreateDocumentForm();
}

?>
<p></p>
<center><A href="index.php"><h3>Return to Home Page</h3></A></center>
<?php

include("footer.php");
?>


<?php
//--------------------
// CreateDocumentForm
//--------------------
function CreateDocumentForm()
{
	global $creators;
	
	$nfiles = 5;

	?>
	<center>
	<h1>Create a new document</h1>
	<p></p>

	<form enctype="multipart/form-data" method="post">
	<table border="0">
	<TR>
		<TD align="right">Creator (you):</TD>
		<TD><input type="text" name="creator" width="50">
			OR <font size="-1">select from this list</font>
			<SELECT name="creator_menu">
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
		<TD><input type="text" name="title" width="80"></TD>
	</TR>
	<TR>
		<TD align="right">Description:</TD>
		<TD><textarea name="description" cols="80" rows="10"></textarea></TD>
	</TR>

	<TR><TD colspan="2" height="20"></TD></TR>

	<TR>
		<TD rowspan="<?=$nfiles?>" width="300" align="right">
			These are to specify files you wish to upload. Together, they
			will form your document. If you only need 1, just specify that one
		</TD>
		<TD align="center"><input name="userfile[]" type="file"></TD>
	</TR>
	<?php
	for($i=1;$i<$nfiles;$i++){
		?>
		<TR><TD align="center"><input name="userfile[]" type="file"></TD></TR>
		<?php
	}
	?>

	<TR><TD colspan="2" height="20"></TD></TR>

	<TR>
		<TD colspan="2" align="center" height="50">
			<input type="submit" name="submit_button" value="Create Document">
		</TD>
	</TR>
	</table>
	</form>
	</center>
	<?php
}

//--------------------
// CreateDocument
//--------------------
function CreateDocument()
{
	global $MAX_FILES_PER_DOCUMENT;

	// Insert new row in documents table
	$creator = mysql_escape_string($_REQUEST["creator"]);
	if($_REQUEST["creator_menu"] != "")$creator = $_REQUEST["creator_menu"];
	$title = mysql_escape_string($_REQUEST["title"]);
	$description = mysql_escape_string($_REQUEST["description"]);
	$query = "INSERT INTO documents (creator,title,description,version,created) ";
	$query .= "VALUES(\"$creator\",\"$title\",\"$description\",\"1\",NOW())";
	mysql_query($query) or die(mysql_error());
	$id = mysql_insert_id();
	
	$name = sprintf("d%03d-v%02d", $id, 1);
	?>
	Created document <b><?=$name?></b> with title "<?=$title?>"
	<p></p>
	<table>
	
	<?php

	// Loop over files
	for($i=0;$i<$MAX_FILES_PER_DOCUMENT;$i++){
		$original_filename = $_FILES['userfile']['name'][$i];
		$tmpname = $_FILES['userfile']['tmp_name'][$i];
		$size = $_FILES['userfile']['size'][$i];

		if(!is_uploaded_file($tmpname))continue;
		
		$fileid = AddFileToDocument($id, 1, $original_filename, $creator, $size, $tmpname);

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
