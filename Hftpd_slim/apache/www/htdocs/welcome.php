<html>
    <head>
    <style>
        #form_get{
            font-family: Arial,Helvetical, sans-serif;
            width: 60%;
            background-color:#FFE4B5;
        }
        #form_get td, #form_get td {
            padding:3px;
        }
        #form_post th {
            padding-top: 0px;
            padding-bottom: 0px;
        }
        #form_post{
            font-family: Arial,Helvetical, sans-serif;
            width: 60%;
            background-color:#E0FFFF;
        }
        #form_post td, #form_post td {
            padding:3px;
        }
        #form_post th {
            padding-top: 0px;
            padding-bottom: 0px;
        }
    </style>    
    </head>    
    <body>
        
        <form id="form_get" action="welcome_get.php" method="get">
            <table>
            <h3>GET request form</h2></td>
            <tr>  
                <td>Name:</td> <td><input type="text" name="name"></td>
            </tr>
            <tr>    
                <td>E-mail: </td> <td><input type="text" name="email"></td>
            </tr>    
            <td><input type="submit"></td>
            </table>
        </form>

        
        <form id="form_post"action="welcome_post.php" method="post">
        <table>
            <h3>POST request form</h2>
            <tr>
                <td>Name:</td> <td><input type="text" name="name"></td>
            </tr>
            <tr>    
                <td>E-mail: </td> <td><input type="text" name="email"></td>
            </tr>    
            <td><input type="submit"></td>
            </table>
        </form>
    </body>
</html>