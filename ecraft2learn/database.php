<?php
class DB
{
  private $server;
  private $username;
  private $password;
  private $database;
  private $connection;
  private $connected;
  
  public function DB()
  {
    $this->server     = 'localhost';
    $this->username   = 'root';
    $this->password   = '';
    $this->database   = 'project';
    $this->connected  = false;
  }
  
  public function connect()
  {
    if( $this->connected )
      return $this->connection;
    
    $this->connection = new mysqli( $this->server, $this->username, $this->password, $this->database );
    
    if( $this->connection )
    {
      if( !$this->connection->connect_errno )
      {
        $this->connected = true;
        return $this->connection;
      }
    }
    
    return NULL;
  }
}
?>