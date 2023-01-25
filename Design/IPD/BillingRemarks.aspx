<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillingRemarks.aspx.cs" Inherits="Design_IPD_BillingRemarks" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../../Scripts/Message.js"   type ="text/javascript"></script>

    <script type="text/javascript" >
        $(document).ready(function () {
            var MaxLength = 300;
            $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtRemarks.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
        var characterLimit = 300;
        $(document).ready(function () {
            $("#lblremaingCharacters").html(characterLimit);
            $("#<%=txtRemarks.ClientID %>").bind("keyup", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
        });
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                $("#divmessage").html("Maximum text length allowed is :" + charlimit);
            }
            else
                $("#divmessage").html("");
        }
        function BillRemarks(btn) {
            if ($("#<%=txtRemarks.ClientID %>").val() == '') {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Billing Remarks');
                $("#<%=txtRemarks.ClientID %>").focus();
                return false;
            }

            else {
                $("#<%=lblMsg.ClientID %>").text('');

            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnBillRemarks', '');
        }
    </script>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Billing Remarks</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Admission Remarks
            </div>
            <div class="content" style="text-align: left">
                <table style="width: 100%" cellpadding="0" cellspacing="0">
                    <tr>
                        <td  style="width: 15%; text-align: right;">
                            Admission Remarks :
                        </td>
                        <td colspan="3" valign="top" align="left">
                            <asp:Label ID="txtAdRemark" runat="server" Height="50px" Width="486px" Style="margin-left: 0px"></asp:Label>
                            <br />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Billing Remarks
            </div>
            <table style="width: 100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="width: 15%; text-align: right;" valign="top">
                        Billing Remarks :
                    </td>
                    <td colspan="3" valign="top" align="left">
                        <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine" Height="94px" Width="497px"
                            Style="margin-left: 0px" onkeyup="javascript:ValidateCharactercount(300,this);" TabIndex="1" ToolTip="Enter Billing Remarks"></asp:TextBox>
                        <asp:Label ID="lblV1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <asp:RequiredFieldValidator ID="reqRemarks" runat="server" Display="None" ErrorMessage="Please Enter Billing Remarks"
                            ControlToValidate="txtRemarks" ValidationGroup="save"></asp:RequiredFieldValidator>
                        Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>
                        <br />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="divmessage" style="color: Red;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnBillRemarks" runat="server" CssClass="ItDoseButton" Text="Save Remarks"
                OnClick="btnBillRemarks_Click" OnClientClick="return BillRemarks(this);" ValidationGroup="save"  TabIndex="2" ToolTip="Click to Save Billing Remarks"/>
        </div>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align:  left">
                <asp:Label ID="lblRemark" runat="server"></asp:Label>
                <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="save" runat="server"
                    ShowMessageBox="True" ShowSummary="False" />
            </div>
        </asp:Panel>
    </div>
    </form>
</body>
</html>
