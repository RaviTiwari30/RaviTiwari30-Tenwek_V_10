<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="OnlineLab_Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9,IE=10" />
    <meta name="google-translate-customization" content="cd2d005fe46c449d-4b837e365e889343-ga8cca08800ce4b2a-20"></meta>
    <link href="../Styles/OnlineLab.css" rel="stylesheet" type="text/css" />

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <script src="../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../Scripts/WaterMark.min.js" type="text/javascript"></script>


        <script type="text/javascript">
            function disableBackButton() {
                window.history.forward()
            }
            disableBackButton();
            //window.onload = disableBackButton();
            window.onpageshow = function (evt) { if (evt.persisted) disableBackButton() }
            window.onunload = function () { void (0) }

            function fnUnloadHandler() {
                alert("Unload event.. Do something to invalidate users session..");
            }
        </script>
        <script type="text/javascript">          
            $(function () {
                $("[id*=txtUserName], [id*=txtPassword]").WaterMark();
            });          
            function check() {
                if ($.trim($("#txtUserName").val()) == "") {
                    $("#lblError").text('Please Enter User Name');
                    $("#txtUserName").focus();
                    return false;
                }
                if (($.trim($("#txtPassword").val())) == "") {
                    $("#lblError").text('Please Enter Password');
                    $("#txtPassword").focus();
                    return false;
                }
            }
            function cancel() {
                $("#txtUserName").val('');
                $("#txtPassword").val('');
                $("#lblError").text('');
            }
        </script>


        <table border="0" style="width: 100%; text-align: center; top: 0px; height: 100%; bottom: 0px; border-collapse: collapse;">
            <tbody>
                <tr>
                     <td style="background-color: red; width: 100%; height: 5px" colspan="3">

                    </td>
                </tr>
                <tr style="display:none">
                   
                        <div class="button_lang">
                            <div id="google_translate_element"></div>
                            <script type="text/javascript">
                                function googleTranslateElementInit() {
                                    new google.translate.TranslateElement({pageLanguage: 'en', includedLanguages: 'fr', layout: google.translate.TranslateElement.InlineLayout.SIMPLE}, 'google_translate_element');
                                }
                            </script>
                            <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
                        </div>

                    </td>
                </tr>
                <tr>

                    <td colspan="2" style="text-align: left;">
                        <asp:Image ID="Image1" ImageUrl="~/Images/cns_logo.jpg" runat="server" Width="150px" Height="150px" /></td>
                    <td style="text-align:right">
                        <asp:Image ID="Image3" ImageUrl="~/Images/Product_Login.png" runat="server" Width="150px" Height="150px" /></td>
                    </td>
                </tr>
                <tr>
                    <td style="background-color: red; width: 100%; height: 5px" colspan="3"></td>
                </tr>
                <tr>

                    <td style="background-color: #013772; width: 100%; height: 22px" colspan="3" align="left">
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; vertical-align: middle; width: 30%; background-color: #013772" rowspan="2">

                        <h4>
                            <span style="color: #FFFFFF">Now Get</span><br />
                            <span style="color: #FFFFFF">Online Lab Report !</span></h4>

                    </td>
                    <td rowspan="2" style="vertical-align: top;">
                        <img alt="" src="../Images/itdose-lab_07.jpg"></td>
                </tr>

                <tr>
                    <td style="width: 100%; text-align: center">
                        <table border="0" style="width: 100%;">



                            <tr>
                                <td style="text-align: left" colspan="3">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="3">


                                    <table style="width: 100%; text-align: center; border: 2px solid #013772; border-radius: 20px; box-shadow: 10px 14px 14px #888888; border-collapse: separate;">
                                        <tr>
                                            <td colspan="2">
                                                <span class="ItDoseLabelBl">Patient&nbsp;Login</span>

                                            </td>

                                        </tr>

                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblError" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label></td>

                                        </tr>
                                        <tr style="display: none">
                                            <td style="text-align: right; width: 40%;"><span class="ItDoseLabelBl">User&nbsp;Type :&nbsp;</span></td>
                                            <td style="text-align: left; width: 60%">
                                                <asp:DropDownList ID="ddlUserType" CssClass="select" TabIndex="1" runat="server" Width="186px" Style="border-color: #013772; border-radius: 5px;">
                                                    <asp:ListItem Text="Patient"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td style="text-align: right; width: 40%"><span class="ItDoseLabelBl">User&nbsp;Name :&nbsp;</span>

                                            </td>
                                            <td style="text-align: left; width: 60%">
                                                <asp:TextBox ID="txtUserName" ClientIDMode="Static" TabIndex="2" Height="20px" ToolTip="Enter User Name" Width="180px" MaxLength="20" Style="border-color: #013772; border-radius: 5px; box-shadow: 4px 4px 4px #888888;" runat="server"></asp:TextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td style="text-align: right; width: 40%"><span class="ItDoseLabelBl">Password :&nbsp;</span></td>
                                            <td style="text-align: left; width: 60%">
                                                <asp:TextBox ID="txtPassword" ClientIDMode="Static" TabIndex="3" Height="20px" ToolTip="Enter Password" Width="180px" TextMode="Password" Style="border-color: #013772; border-radius: 5px; box-shadow: 4px 4px 4px #888888;" runat="server"></asp:TextBox>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>

                                        </tr>

                                        <tr>
                                            <td style="text-align: center" colspan="2">

                                                <asp:Button ID="btnLogin" runat="server" TabIndex="4" Text="Login" CssClass="ItDoseButton"
                                                    OnClick="btnLogin_Click" OnClientClick="return check();" ToolTip="Click To Login" Style="border-color: #013772; border-radius: 5px; box-shadow: 4px 4px 4px #888888;" />
                                                &nbsp;
                                    <input type="button" class="ItDoseButton" value="Cancel" onclick="cancel()" title="Click To Cancel" style="border-color: #013772; border-radius: 5px; box-shadow: 4px 4px 4px #888888;" />

                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">&nbsp;</td>

                                        </tr>
                                    </table>

                                </td>
                                <td>&nbsp;
                                </td>
                            </tr>







                            <tr>
                                <td style="text-align: left" colspan="2">&nbsp;</td>
                                <td>&nbsp;&nbsp;</td>
                            </tr>
                        </table>



                    </td>

                </tr>
                <tr>
                    <td style="background-color: #013772" colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td style="background-color: #013772" colspan="3">
                        <span style="position: inherit; left: 200px; font-size: 14px; color: White">&nbsp;Just Enter Your UHID &amp; Lab No. And Get Your Lab Reports Any Where At Anytime !</span>
                    </td>
                </tr>
                <tr>
                    <td style="background-color: #013772" colspan="3">
                        <span style="position: inherit; left: 200px; font-size: 14px; color: White">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        </span></td>
                </tr>
                <tr>
                    <td style="background-color: #013772" colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr style="display:none">
                    <td colspan="3" style="text-align: right; vertical-align: bottom">
                        <asp:Image ID="Image2" ImageUrl="~/Images/padiyathLogo.png" runat="server" Width="200px" />
                    </td>
                </tr>
                <tr style="display:none">
                    <td colspan="3">&nbsp;</td>
                </tr>
                <tr>
                    <td style="background-color: #013772; vertical-align: bottom" colspan="3">

                        <span style="color: #FFFFFF">“Best View With Internet Explorer 9 & above with Compatibility View (Screen resolution 1366 x 768)”</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
