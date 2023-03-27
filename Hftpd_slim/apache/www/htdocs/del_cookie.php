<?php
   setcookie( "user", "", time()- 60, "/","", 0);
?>
<html>
   <head>
      <title>Deleting Cookies with PHP</title>
   </head>
   
   <body>
      <?php echo "Cookie deleted!" ?>
   </body>
   
</html>