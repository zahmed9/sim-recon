<?php
include("header.php");

ShowDocument($_REQUEST["id"], $_REQUEST["version"]);

include("footer.php");
?>

<?php
function ShowDocument($id, $version)
{
	// Get all info for this document
	$query = "SELECT * FROM documents WHERE id=\"$id\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$doc = mysql_fetch_array($mysql_result);
	if($version=="")$version = $doc["version"];
	
	// Get all files for this version
	$query = "SELECT * from files WHERE id=\"$id\" AND version=\"$version\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	while($row = mysql_fetch_array($mysql_result))$files[] = $row;

	// Get all version numbers for this document
	$query = "SELECT version from files WHERE id=\"$id\" ";
	$query .= "AND version!=\"$version\" GROUP BY version ORDER BY version DESC";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$versions = array();
	while($row = mysql_fetch_array($mysql_result))$versions[] = $row["version"];

	?>
	<center>
	<h1><?=$doc["title"]?></h1>
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
	
	<table bordercolor="green" border="5">
	<TR><TD  width="500">
	
	<table border="0">
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
	</table>
	
	</TD></TR>
	</table>
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
	<table border="0">
	<TR>
		<TD><A href="updatedocument.php?id=<?=$id?>">Update This Document</A></TD>
		<TD width="50"></TD>
		<TD><A href="addfiles.php?id=<?=$id?>&version=<?=$version?>">Add files to this version</A></TD>
	</TR>
	</table>
	</center>
	<?php
}

?>
