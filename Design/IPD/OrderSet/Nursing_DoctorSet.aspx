<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Nursing_DoctorSet.aspx.cs"
    Inherits="Design_IPD_OrderSet_Nursing_DoctorSet" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" id="styleSheet"/>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        function disable() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
        $(document).ready(function () {

            var width = window.screen.availWidth;
            var height = screen.height;

            if (screen.width > 1024) {

                $("link#styleSheet").attr("href", "../../../Styles/OrderSet_1366.css");
            }
            else if (screen.width <= 1024) {

                $("link#styleSheet").attr("href", "../../../Styles/OrderSet_1024.css");

            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <b>&nbsp;Doctor</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <table width="100%" cellpadding="0"  cellspacing="0">
                <tr>
                    <td class="style1">
                        Doctor :&nbsp;
                        <asp:DropDownList ID="ddlDoctor" runat="server" Width="400px">
                        </asp:DropDownList>
                    </td>
                    <td align="left">
                        <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="ItDoseButton" OnClick="btnAdd_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlHide" runat ="server" Visible ="true" >
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="grdDoctor" runat="server" AutoGenerateColumns="false" OnRowCommand="grdDoctor_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Doctor">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDoctor" Text='<%#Eval("Doctor") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="640px"  HorizontalAlign="Left"/>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField Visible="false" >
                                <ItemTemplate >
                                <asp:Label ID="lblDoctorID" runat="server" Text='<%#Eval("DoctorID") %>'></asp:Label>                               
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbRemove" ToolTip="Remove Doctor" runat="server" ImageUrl="~/Images/Delete.gif"
                                    CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            &nbsp;<asp:Button ID="btnSave" Text="Save" runat="server" CssClass="ItDoseButton"
                CausesValidation="False" ToolTip="Click To Save" OnClick="btnSave_Click" onClientClick="disable()" UseSubmitBehavior="false" />
        </div>
        </asp:Panel>
    </div>
    </form>
</body>
</html>
