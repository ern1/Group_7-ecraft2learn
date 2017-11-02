<?php
    session_start();
    $message = "";

    if(isset($_SESSION['logged_in']))
    {
        header("Location: index.php");
    }

    if(isset($_POST['username']) && isset($_POST['password']))
    {
        require_once('database.php');
        $conn = (new DB())->connect();

        /*$username = mysqli_real_escape_string($conn, $_POST['username']);
        $password = mysqli_real_escape_string($conn, $_POST['password']);*/
	    
	$username = $conn->real_escape_string($_POST["username"]);
	$password = $conn->real_escape_string($_POST["password"]);

        //Retrieves the (hashed) password from the database that matches the username
        if( $result = $conn->query("SELECT password FROM account WHERE username = '".$username."'") )
        {
		
            $row = $result->fetch_array();
            $hashed_password = $row['password'];  

            //Verifies the password input by the user against the hash from the database
            if(password_verify($password, $hashed_password)) 
            {
                $_SESSION['logged_in'] = $username;
                header("Location: index.php");
            }
            else 
            {
                $message = "Wrong username and/or password!";
            } 
            
        }
        else
        {
            $message = "Failed to log in.";
        }
        
        $conn->close();

    }
?>

<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    
    <title>eCraft2Learn - Login</title>
    <link rel="shortcut icon" href="images/eCraft2Learn-Favicon.png" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/login.css">
</head>

<body>
    <div class="container">
        <div class="panel">
            
            <div class="panel-heading" text-center"">
                <img id="logo" class="img-responsive" src="images/eCraft2Learn-icon.png">
            </div>
            
            <div class="panel-body">
                <form method="post" action="login.php">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" placeholder="enter username" name="username">
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" placeholder="enter password" name="password">
                    </div>
                    <button type="submit" class="btn btn-primary"> Login </button>
                    <p> <?php echo $message ?> </p>
                </form>
            </div>

        </div>  
    </div>
</body>
</html>
