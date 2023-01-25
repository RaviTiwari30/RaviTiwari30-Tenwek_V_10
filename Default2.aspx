<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="lib/SpeechRecognizer.js"></script>
    <script type="text/javascript" src="Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" >
        function WriteToFile(data) {
            var Emp_Name = 'Mr. IT DOSE';
            var Emp_ID = 'EMP001';

            //var ris_path = "RIS:OpenForm?Test_ID=" + data + "&Investigation_Id=&Emp_Name=" + Emp_Name + "&Emp_ID=" + Emp_ID + "&AuthID=" + Emp_ID + "&Weblink=http://192.168.121.92:80/Prima/RIS.asmx";
            
            var ris_path = "RIS:OpenForm?Test_ID=LSHHI10370&Investigation_Id=&Emp_Name=Mr. IT DOSE&Emp_ID=EMP001&AuthID=EMP001&Weblink=http://localhost:12656/his/ris.asmx"

            window.location = ris_path;
            return;
        }
    </script>

     <script language="jscript">
         function goFullscreen() {
             // Must be called as a result of user interaction to work
             mf = document.getElementById("main_frame");
             mf.webkitRequestFullscreen();
             mf.style.display = "";
         }
         function fullscreenChanged() {
             if (document.webkitFullscreenElement == null) {
                 mf = document.getElementById("main_frame");
                 mf.style.display = "none";
             }
         }
         document.onwebkitfullscreenchange = fullscreenChanged;
         document.documentElement.onclick = goFullscreen;
         document.onkeydown = goFullscreen;
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
          <input type="button" value="abc" onclick="WriteToFile()" />
             <H1>Click anywhere or press any key to browse <u>w3schools</u> in fullscreen.</H1>
           <iframe id="main_frame" src="http://www.w3schools.com" style="width:100%;height:100%;border:none;display:none"></iframe>
        </div>
    </form>
</body>
</html>
