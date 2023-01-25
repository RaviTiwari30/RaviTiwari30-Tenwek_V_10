<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<title> Hospedia 9.0 </title>
<!--Script Start-->
<script type="text/javascript" src="Scripts/jquery-1.7.1.min.js"></script>
<!--CSS Start-->
<link rel="stylesheet" href="Styles/supersized.css" type="text/css" media="screen" />
<link rel="stylesheet" href="Styles/Loginstyle.css" />
<link rel="stylesheet" href="Styles/media.css" />
<link rel="stylesheet" href="Scripts/LoginScript/component.css" />
<link rel="shortcut icon" href="Images/logoico.ico" type="image/x-icon" />
<script src="Scripts/LoginScript/modernizr.custom.js" type="text/javascript"></script>
	<script type="text/javascript">	   
		jQuery(function () {
			$('#<%=ddlCenterMaster.ClientID%>').focus();
		});
		function Validate()
		{
			if ($('#<%=ddlCenterMaster.ClientID%>').val() == "0")
			{
			    showerrormsg("Please Select Center");
				$('#<%=ddlCenterMaster.ClientID%>').focus();
				return false;
			}
			if ($('#<%=txtUserName.ClientID%>').val() == "")
			{
			    showerrormsg("Please Enter User Name");
				$('#<%=txtUserName.ClientID%>').focus();
				return false;
			}
			if ($('#<%=txtPassword.ClientID%>').val() == "")
			{
			    showerrormsg("Please Enter Password");
				$('#<%=txtPassword.ClientID%>').focus();
				return false;
			}
			return true;
		}
	    function showerrormsg(msg) {
	        $('#msgField').html('');
	        $('#msgField').append("<b>Alert<b> <br/>" + msg);
	        $(".alert").css('background-color', 'red');
	        $(".alert").removeClass("in").show();
	        $(".alert").delay(1500).addClass("in").fadeOut(1500);
	    }
	</script>

</head>
<body>
     <div class="alert fade" style="position: absolute; left: 45%; border-radius: 15px; z-index: 11111;top:10px">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
<div id="controls-wrapper" class="load-item">
	<div id="controls">
		<ul id="slide-list"></ul>
	</div>
</div>
<!--header-->
<div class="loginpage">
    <div class="logo"><a href="https://www.fortiscliniquedarne.com"> <img src="Images/CD logo-01.png" style="width:150px; display:none"/></a>
		</div>

</div>
   <div class="md-modal md-effect-1" id="modal-1">
			<div class="md-content">
	<div class="loginpad" style="background: url('Images/app-background.png');">
		<h6><asp:Label ID="lblClientFullName" runat="server" Font-Bold="true" Font-Size="X-Large"></asp:Label></h6>  
		<div class="logininnerpad">
			<div class="icelogo"><asp:Image ID="imgClientLogo" runat="server" Visible="false"  /></div>
			<h3><strong>Welcome, Please Login..</strong></h3><table>
				<tr style="text-align:center"><td style="text-align:center"></td>
					  <asp:Label ID="lblError" runat="server" Visible="False" ForeColor="Red"
			   EnableViewState="False" meta:resourcekey="lblErrorResource1"></asp:Label>
				</tr></table>
			<form id="form1" runat="server"><div>
				<table style="width:100%">
					<tr><td><b>Centre Name</b></td><td><asp:DropDownList ID="ddlCenterMaster" runat="server" CssClass="selectbox"></asp:DropDownList></td>
					</tr>
					<tr><td><b>User Name</b></td><td><asp:TextBox ID="txtUserName" runat ="server" CssClass="textbox" meta:resourcekey="txtUserNameResource1" AutoCompleteType="Disabled"></asp:TextBox></td></tr>
					<tr><td style="width:150px"><b>Password</b></td><td><asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" TextMode="Password" meta:resourcekey="txtPasswordResource1" AutoCompleteType="Disabled"></asp:TextBox></td></tr>
					<tr><td colspan="2"><asp:Button ID="btnLogin" runat="server" CssClass="btn" Text="Login" OnClick="btnLogin_Click" OnClientClick="return Validate()" />
							<asp:Button ID="btnCancel" runat="server" CssClass="btn cancelbtn" Text="Clear" OnClick="btnCancel_Click" /></td></tr>
				   </table>
				</div>
			</form>
		</div>
		  <h1>Tenwek License@TW/ITD/4.0.1/KE/16032021</br> Powered by ESS  vyud</h1>
	</div>
	 </div>
		
  </div>
	<div style="margin-top:-60px">
		 <div style ="text-align:right">
			 <a href="http://www.itdoseinfo.com"> <img src="Images/ebizframeRx00.jpg"></a> <%--images/itdose.jpg--%>
		<button class="md-trigger" data-modal="modal-1" id="modal1" style="display:none">Fade in &amp; Scale</button>
		</div>
	</div>
<script type="text/javascript" src="Scripts/LoginScript/html5.js"></script>
<script type="text/javascript" src="Scripts/LoginScript/respond.js"></script>
<script type="text/javascript" src="Scripts/LoginScript/jquery.min.js"></script>
<script type="text/javascript" src="Scripts/LoginScript/supersized.3.2.7.min.js"></script>
<script src="Scripts/LoginScript/modernizr.custom.js" type="text/javascript"></script>
<script src="Scripts/LoginScript/classie.js" type="text/javascript"></script>
<script src="Scripts/LoginScript/modalEffects.js" type="text/javascript"></script>
<script>var polyfilter_scriptpath = '/Scripts/LoginScript/';</script>
<script src="Scripts/LoginScript/cssParser.js"></script>
<script src="Scripts/LoginScript/css-filters-polyfill.js"></script>
<script type="text/javascript">
	jQuery(function ($) {
		$('#modal1').click();
		$.supersized({
			// Functionality
			slideshow: 1,			// Slideshow on/off
			autoplay: 1,			// Slideshow starts playing automatically
			start_slide: 1,			// Start slide (0 is random)
			stop_loop: 0,			// Pauses slideshow on last slide
			random: 0,			// Randomize slide order (Ignores start slide)
			slide_interval: 4000,		// Length between transitions
			transition: 1, 			// 0-None, 1-Fade, 2-Slide Top, 3-Slide Right, 4-Slide Bottom, 5-Slide Left, 6-Carousel Right, 7-Carousel Left
			transition_speed: 1000,		// Speed of transition
			new_window: 1,			// Image links open in new window/tab
			pause_hover: 0,			// Pause slideshow on hover
			keyboard_nav: 1,			// Keyboard navigation on/off
			performance: 1,			// 0-Normal, 1-Hybrid speed/quality, 2-Optimizes image quality, 3-Optimizes transition speed // (Only works for Firefox/IE, not Webkit)
			image_protect: 1,			// Disables image dragging and right click with Javascript

			// Size & Position						   
			min_width: 0,			// Min width allowed (in pixels)
			min_height: 0,			// Min height allowed (in pixels)
			vertical_center: 1,			// Vertically center background
			horizontal_center: 1,			// Horizontally center background
			fit_always: 0,			// Image will never exceed browser width or height (Ignores min. dimensions)
			fit_portrait: 1,			// Portrait images will not exceed browser height
			fit_landscape: 1,			// Landscape images will not exceed browser width
			// Components							
			slide_links: 'blank',	// Individual links for each slide (Options: false, 'num', 'name', 'blank')
			thumb_links: 1,			// Individual thumb links for each slide
			thumbnail_navigation: 0,			// Thumbnail navigation
			slides: [			// Slideshow Images
												{ image: 'Images/bg.jpg' },
												{ image: 'Images/bg1.jpg' },
												{ image: 'Images/bg2.jpg' },
												{ image: 'Images/bg3.jpg' },
                                                { image: 'Images/bg5.jpg' },
                                                { image: 'Images/bg6.jpg' }
                                           
			],
			// Theme Options			   
			progress_bar: 0,			// Timer for each slide							
			mouse_scrub: 0
		});
	});
</script>
</body>
</html>
