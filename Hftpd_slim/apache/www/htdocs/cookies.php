<?php
$cookie_name = "user";
$cookie_value = "Quang Nguyen";
setcookie($cookie_name, $cookie_value, time() + (86400 * 30), "/");
?>
<html>
<body>

<?php
if(!isset($_COOKIE[$cookie_name])) {
  echo "Cookie named '" . $cookie_name . "' is not set!";
} else {
  echo "Cookie '" . $cookie_name . "' is set!<br>";
  echo "Value is: " . $_COOKIE[$cookie_name]."<br><br>";
  echo "<a href='del_cookie.php'" . "> Delete cookie </a>" ;
}
?>

</body>
</html>
