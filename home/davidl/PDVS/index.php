<?php
include("header.php");

ShowMostRecent();

SearchForm();

include("footer.php");
?>

<?php
//----------------
// ShowMostRecent
//----------------
function ShowMostRecent()
{
	global $documents;

	?>
	<h3>Most recent uploads</h3>
	<p></p>
	<table border="0">
	<?php
	for($i=0;$i<10;$i++){
		$doc = $documents[$i];
		$id = $doc["id"];
		$version = $doc["version"];
		$name = sprintf("d%03d-v%02d", $id, $version);
		$title = $doc["title"];
		$date = date("F j Y h:i:s A",$doc["modified"]);
		$creator = $doc["creator"];
		
		if($id<1)break;
		?>
		<TR>
				<TD align="left"><?=$name?></TD>
				<TD width="20"></TD>
				<TD align="left"><A href="showdocument.php?id=<?=$id?>&version=<?=$version?>"><?=$title?></A></TD>
				<TD width="20"></TD>
				<TD align="left"><A href="search.php?submitter=<?=$creator?>"><?=$creator?></A></TD>
		</TR>
		<?php		
	}
	?>
	</table>
	<?php
}

//----------------
// SearchForm
//----------------
function SearchForm()
{
	global $submitters;
	?>	
	
	<p></p>
	<center>
	<hr width="75%">
	<h2>Search Documents</h2>
	</center>

	<center>
	<table border="5" bordercolor="#909010">
	<TR><TD align="right">
	
	<!---------------- Search By Document number -------------->
	<form enctype="multipart/form-data" method="post" action="search.php">
	<table border="0">
	<TR>
		<TD align="right">Document ID <font size="-1">(e.g. d003)</font>:</TD>
		<TD>
			<input type="text" size="10" name="name">
		</TD>
		<TD colspan="2" align="center" height="50">
			<input type="submit" name="submit_button" value="Search By Document ID">
		</TD>
	</TR>
	</table>
	</form>
	</center>
	
	</TD></TR>
	<TR><TD align="right">

	<!---------------- Search By Submitter -------------->
	<form enctype="multipart/form-data" method="post" action="search.php">
	<table border="0">
	<TR>
		<TD align="right">Submitters:</TD>
		<TD>
			<SELECT name="submitter">
				<?php
				foreach($submitters AS $submitter){
					?>
					<OPTION value="<?=$submitter?>"><?=$submitter?></OPTION>
					<?php
				}
				?>
			</SELECT>
		</TD>
		<TD colspan="2" align="center" height="50">
			<input type="submit" name="submit_button" value="Search By Submitter">
		</TD>
	</TR>
	</table>
	</form>
	</center>
	
	</TD></TR>
	<TR><TD align="right">

	<!---------------- Search By Title -------------->
	<center>
	<form enctype="multipart/form-data" method="post" action="search.php">
	<table border="0">
	<TR>
		<TD align="right">Title (enter whole or partial title):</TD>
		<TD>
			<input type="text" size="24" name="title">
		</TD>
		<TD colspan="2" align="center" height="50">
			<input type="submit" name="submit_button" value="Search By Title">
		</TD>
	</TR>
	</table>
	</form>
	
	</TD></TR>
	</table>
	
	</center>
	
	<?php
}

?>
