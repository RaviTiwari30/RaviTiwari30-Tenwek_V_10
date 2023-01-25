<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillFreezed.aspx.cs" Inherits="Design_IPD_BillFreezed" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
</head>
<body>
       <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript">
        function confirm_Bill(btn) {
            modelConfirmation('Bill Freezed','Please note that once saved no changes can be done', 'YES', 'NO', function (response) {
                if (response) {
                    btn.disabled = true;
                     __doPostBack('btnSave', '');
                    return true;
                }
            });
            return false;
        }
    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" runat="server">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <b>Bill Freezed</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="MainDiv" runat="server">
                <table style="width: 100%">
                    <tr>
                        <td colspan="4" style="text-align: center">
                            <asp:Button ID="btnSave" UseSubmitBehavior="false" Text="Bill Freezed" OnClick="btnSave_Click" ClientIDMode="Static" CssClass="ItDoseButton" OnClientClick="return confirm_Bill(this)" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>

