<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewOnlineReport.aspx.cs" Inherits="OnlineLab_ViewOnlineReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9,IE=10" />
    <meta name="google-translate-customization" content="cd2d005fe46c449d-4b837e365e889343-ga8cca08800ce4b2a-20"></meta>
    <title></title>
      <script type="text/javascript" >
          function disableBackButton() {
              window.history.forward()
          }
          disableBackButton();
          //window.onload = disableBackButton();
          window.onpageshow = function (evt) { if (evt.persisted) disableBackButton() }
          window.onunload = function () { void (0) }
</script>
     

</head>
<body >
   
    <form id="form1" runat="server">
        <table border="0" style="width: 100%; text-align: center; top: 0px; height: 100%; bottom: 0px; border-collapse:collapse" >
            <tbody>
                 <tr>
                     <td style="background-color: red; width: 100%; height: 5px" colspan="2">

                    </td>
                </tr>
                <tr style="display:none">
                    <td style="background-color: #013772; text-align: right; vertical-align: middle; height: 25px;" colspan="2">
                         <div class="button_lang">
                            <div id="google_translate_element"></div>
                            <script type="text/javascript">
                                function googleTranslateElementInit() {
                                    new google.translate.TranslateElement({ pageLanguage: 'en', includedLanguages: 'fr', layout: google.translate.TranslateElement.InlineLayout.SIMPLE }, 'google_translate_element');
                                }
                            </script>
                            <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
                        </div>
                    </td>
                  
                </tr>
                <tr>
                    <td colspan="2" style="text-align:right">
                                                <asp:LinkButton ID="lbLogOut"  OnClick="lbLogOut_Click" runat="server" Text="LogOut" Font-Bold="true"  ToolTip="Click To LogOut" BackColor="WhiteSmoke" style="border-radius: 10px; border:none" ></asp:LinkButton>

                    </td>
                </tr>
                
                <tr>

                    <td style="text-align: left;">
                        <asp:Image ID="Image1" ImageUrl="~/Images/cns_logo.jpg" runat="server" Width="150px" Height="150px" /></td>
                    <td style="text-align:right">
                        <asp:Image ID="Image3" ImageUrl="~/Images/Product_Login.png" runat="server" Width="150px" Height="150px" /></td>
                    </td>

                </tr>
                <tr>
                    <td style="background-color: red; height: 5px" colspan="2"></td>
                </tr>
                <tr>
                    <td style="background-color: #013772;height: 22px" colspan="2">&nbsp;</td>
                </tr>


                <tr>
                    <td colspan="2" style="width: 100%;">
                        <iframe id="LabReport" scrolling="no"   style="width: 100%; height: 500px; border: solid 1px; border-color: #013772; text-align: center; background-repeat: no-repeat; background-position: center;" src="../Design/Lab/ViewLabReports.aspx?PID=<%=PID%>&LedgerTransactionNo=<%=LedgerTransactionNo%>&LabType=OPD&TID=<%=TID%>&OnLineLab=1"></iframe>
                    </td>
                </tr>
                <tr style="display:none">
                    <td colspan="2" style="text-align: right; vertical-align: bottom">
                        <asp:Image ID="Image2" ImageUrl="~/Images/padiyathLogo.png" runat="server" Width="200px" />
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
