<?php
	session_start();

	if(!isset($_SESSION['logged_in']))
	{
		header("Location: login.php");
	}
?>

<!DOCTYPE html>
<html>
<head>
	<title>Prototype</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
  <link rel="shortcut icon" href="images/eCraft2Learn-Favicon.png">

	<!-- Libraries CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metro/3.0.17/css/metro.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metro/3.0.17/css/metro-icons.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/metro/3.0.17/css/metro-colors.min.css">
	
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.min.css">

	<!-- Libraries JS -->
	<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.2.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/metro/3.0.17/js/metro.min.js"></script>
	
	<!-- Custom CSS and JS -->
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<script src="js/main.js"></script>
  
</head>
<body>

	<?php
	/* 
	READ ME
	The responsive grid is made by bootstraps .container, .container-fluid, .row and .col-*-* classes.
	Inside the bootstrap-columns the metro container-classes are used which then
	holds the seperate metro tiles: .tile-wide, .tile-square, .tile-small. 
	*/
	?>

	<div class="custom-container">

		<header class="row">
			<div class="col-xs-6">
				<div class="padding30 no-padding-bottom">
					<img class="hidden-xs" id="eCraftLogo" src="images/eCraft2Learn-icon.png">
					<img class="visible-xs-inline-block" src="images/eCraft2Learn-Favicon.png">
				</div>
				<div id="eCraftMotto" class="no-margin-top hidden-xs">
					<p>Digital Fabrication and Maker Movement in Education</p>
				</div>
			</div>

			<div class="col-xs-6">
				<div class="dropdown-button place-right margin40">
					<button class="button dropdown-toggle large-button primary">Menu</button>
					<ul class="split-content d-menu place-right" data-role="dropdown">
						<li><a href="#">Settings</a></li>
						<li><a href="logout.php">Log out</a></li>
					</ul>
				</div> 
			</div>
		</header> <!-- End row -->

		<div class="row">
    
		<?php
		require_once('database.php');
		
		// Connect to the database
		$conn = (new DB())->connect();
		
		// Get all the categories
		$categories = array();
		
		if( $result = $conn->query('SELECT * FROM `categoryview`') )
		{
			if( $result->num_rows > 0 )
			{
				while( $row = $result->fetch_array() )
					$categories[] = $row[ 0 ];
			}
		} 
		
		// Loop through all categories
		for( $i = 0; $i < sizeof( $categories ); $i++ )
		{
			// Printa a column for each category
			echo '<div class="col-xs-12 col-sm-6 col-md-4"><div class="tile-group flex-width no-margin"><span class="tile-group-title">' . $categories[ $i ] . '</span><div class="tile-container">';
			
			// Get tools for a specific category
			if( $prep = $conn->prepare( 'CALL GetToolsByCategory(?)' ) )
			{
				// Parameter for GetToolsByCategory is the category name
				$prep->bind_param( 's', $categories[ $i ] );
				$prep->execute();
				// Bind the result from the query to variables
				$prep->bind_result( $name, $caption, $info, $icon, $url, $size, $color );
				
				// Loop through all rows
				while( $prep->fetch() )
				{
					// Print a tile for each tool
					echo '<div class="' . $size . '" style="background-color:#'. $color .'" data-url="' . $url . '" data-info="' . $info . '">			
								<div class="tile-content iconic slide-up">	
									<span class="mif-question absolute-right-top margin5"></span>			
									<div class="slide">									
										<img class="icon" src="./images/' . $icon . '">
									</div>
									<div class="slide-over text-medium padding10" style="background-color:#'. $color . 'BB">' . $caption . '</div>
									<div class="tile-label">' . ( ( $size != 'tile-small' )? $name : '' ) . '</div>
								</div>
							</div>';
				}
				
				$prep->close();
			}
			
			// Close the column
			echo '</div></div></div>';
		}
		
		$conn->close();
		
		?>

		</div> <!-- End row -->
	</div> <!-- End custom container -->


  <!-- Bootstrap modal that that popups when pressing the more-info-questionsmark -->
	<div class="container-fluid">
	  <!-- Modal -->
	  <div class="modal fade" id="tool-help" role="dialog">
	    <div class="modal-dialog">
	   
	      <!-- Modal content-->
	      <div class="modal-content">
	        <div class="modal-header">
	          <button type="button" class="close" data-dismiss="modal">&times;</button>
	          <h4 class="modal-title" id="help-title">Title</h4>
	        </div>
	        <div class="modal-body" id="tool-help-info">
	          <p>The information text from the PHP-files</p>
	        </div>
	        <div class="modal-footer">
	          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	        </div>
	      </div> 
	    </div>
	  </div>  
	</div>


	<!-- Appending the iframe-modals to this container -->
	<div class=".container-fluid" id="iframe-container"></div>

 	<!-- Bottom tray-bar that contains the tile-buttons -->
	<div id="bottom-tray"></div>

	<!-- Button that shows/hides the tray -->
	<button class="btn btn-danger pull-right" id="btn-lock">HIDE</button>


</body>
</html>

