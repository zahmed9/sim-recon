<?php
include("header.php");

$start = 0;
$limit = 10;
$document_ids = array();
if($_REQUEST["page"]!="")$start = ($_REQUEST["page"]-1)*$limit;

// Some requests don't come from forms. Figure out what they're
// searching on
if($_REQUEST["submit_button"]==""){
	if($_REQUEST["submitter"]!="")$_REQUEST["submit_button"]="Search By Submitter";
	if($_REQUEST["title"]!="")$_REQUEST["submit_button"]="Search By Title";
	if($_REQUEST["name"]!="")$_REQUEST["submit_button"]="Search By Document ID";
}

$url = "search.php?";

switch($_REQUEST["submit_button"]){
	case "Search By Submitter":
		SearchBySubmitter($_REQUEST["submitter"]);
		break;
	case "Search By Title":
		SearchByTitle($_REQUEST["title"]);
		break;
	case "Search By Document ID":
		SearchByDocumentID($_REQUEST["name"]);
		break;
}



if($nrows<1){
	?>
	<i>No Matches Found</i>
	<?php
}else{
	?>
	<font size="+2"><i><?=$nrows?> Matches Found!</i></font>
	<p></p>
	<?php
}

?>
<center>
<table border="0">
<TR><TD colspan="5" height="5" bgcolor="#909090"></TD></TR>
<TR><TD colspan="5" height="5"></TD></TR>
<?php
foreach($document_ids AS $id){
	// Get all info for this document
	$query = "SELECT * FROM documents WHERE id=\"$id\"";
	$mysql_result = mysql_query($query) or die(mysql_error());
	$doc = mysql_fetch_array($mysql_result);
	$version = $doc["version"];
	$name = sprintf("d%03d-v%02d", $id, $version);
	$title = $doc["title"];
	$date = date("F j Y h:i:s A",$doc["modified"]);
	$creator = $doc["creator"];
		
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

$npages = sprintf("%d",$nrows/$limit +1);
$page = $start/$limit + 1;
?>

<TR><TD colspan="5" height="10"></TD></TR>

<TR>
	<TD colspan="5" align="center">
	<i>page <?=$page?> of <?=$npages?></i>:
	&nbsp &nbsp

	<?php
	for($p=1;$p<=$npages;$p++){
		?>
		<A href="<?=$url?>&page=<?=$p?>"><?=$p?></A>&nbsp
		<?php
	}
	?>
	</TD>
</TR>
</table>
</center>

<?php
include("footer.php");
?>

<?php
//------------------
// SearchByDocumentID
//------------------
function SearchByDocumentID($name)
{
	global $url;
	$url .= "name=$name";

	$N = sscanf($name,"d%03d-v%02d",$id, $version);
	if($N<1)$N = sscanf($name,"%d",$id);
	
	$query = "SELECT * FROM documents WHERE id=\"$id\"";
	SearchBy($query);
}

//------------------
// SearchBySubmitter
//------------------
function SearchBySubmitter($submitter)
{	
	global $url;
	$url .= "submitter=$submitter";

	$query = "SELECT * FROM files WHERE submitter=\"$submitter\" GROUP BY id";
	SearchBy($query);
}

//------------------
// SearchByTitle
//------------------
function SearchByTitle($title)
{
	global $url;
	$url .= "title=$title";

	$query = "SELECT * FROM documents WHERE title LIKE \"%$title%\"";
	SearchBy($query);
}

//------------------
// SearchBy
//------------------
function SearchBy($query)
{
	global $document_ids;
	global $start, $limit, $nrows;

	$mysql_result = mysql_query($query) or die(mysql_error());
	$nrows = mysql_num_rows($mysql_result);
	
	$query .= " LIMIT $start,$limit";
	$mysql_result = mysql_query($query) or die(mysql_error());
	while($row = mysql_fetch_array($mysql_result))$document_ids[] = $row["id"];
}

?>
