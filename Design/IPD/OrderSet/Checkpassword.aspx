<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Checkpassword.aspx.cs" Inherits="Design_IPD_OrderSet_Checkpassword" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<html>
<head>
    <title>Untitled Page</title>
    <link rel="Stylesheet" href="../../../Styles/PurchaseStyle.css" id="styleSheet" />
    <script src="../../../Scripts/jquery-1.7.1.min.js" type="text/javascript" ></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            var width = window.screen.availWidth;
            var height = screen.height;

        });
        function clickBTNADD() {
            var value = '<%= ViewState["value"].ToString() %>';
            if(value=="Research"){
                parent.jQuery.fancybox.close();
                window.parent.document.getElementById("txtValue").value = 2;
                //window.parent.document.getElementById("btnSave").click();
                window.parent.document.getElementById("Save").click();
            }
            else if (value == "OrderSet") {
                parent.jQuery.fancybox.close();
                window.parent.document.getElementById("txtValue").value = 1;
                window.parent.document.getElementById("btnSave").click();
            }
            else if (value == "Threshold") {
                jQuery.noConflict();
                parent.jQuery.fancybox.close();
                window.parent.document.getElementById("txtThresholdValue").value = 1;
                window.parent.PatientSearchByBarCode(<%= Request.QueryString["PID"].ToString() %>);
            }
            
        }
       
  
        function clickBTNADDUpdate() {
            parent.jQuery.fancybox.close();
            window.parent.document.getElementById("txtValue").value = 1;
            window.parent.document.getElementById("btnUpdate").click();

        }

        function validate() {
            jQuery.noConflict();
            if (jQuery.trim(jQuery("#<%=txtPassword.ClientID %>").val().length) == "0") {
                jQuery("#<%=lblMsg.ClientID %>").text('Please Enter Password');
                jQuery("#<%=txtPassword.ClientID %>").focus();
                return false;
            }
            else {
                __doPostBack('Btnsave', '');
                return true;
            }
        }
   
    </script>
</head>
<body style="padding: 0px 0px 0px 0px;width:100%">
    <form id="popup" runat="server">
        <div id="Pbody_box_inventory" style="width:464px">
            <div class="POuter_Box_Inventory" style="text-align: center;width:460px">
                <b>Check Password</b><br />
               
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
               
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;width:460px">
                <table  style="width: 100%;">
                    <tr style="font-size: 10pt">
                        <td style="width: 20%" align="right">User&nbsp;Name :&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left;">
                            <asp:Label ID="lblUsername" runat="server"></asp:Label>
                        </td>
                        <td style="width: 20%; display: none;" align="right">&nbsp;
                        </td>
                        <td style="width: 20%; display: none; text-align: left;">
                            <asp:Button ID="butadd" runat="server" Text="Add this" CssClass="ItDoseButton" Style="display: none;" />
                        </td>
                    </tr>
                    <tr style="font-size: 10pt">
                        <td style="width: 20%" align="right">Password :&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left;">
                            <asp:TextBox ID="txtPassword" runat="server" ToolTip="Enter Password" Width="154px" TabIndex="1"
                                TextMode="Password" MaxLength="20">
                            </asp:TextBox>
                        </td>
                        <td style="width: 20%; display: none;" align="right">&nbsp;
                        </td>
                        <td style="width: 20%; text-align: left; display: none;"></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;width:460px">
                <asp:Button ID="Btnsave" OnClientClick="return validate();" runat="server" OnClick="Btnsave_Click" Text="Save" TabIndex="2" ToolTip="Click To Save" CssClass="ItDoseButton" />
            </div>
        </div>
    </form>
</body>
</html>
