<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Nursing_DVTProphylaxisPopUp.aspx.cs"
    Inherits="Design_IPD_OrderSet_Nursing_DVTProphylaxisPopUp" %>

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
    <script type="text/javascript" >
        function disable() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory_orderSet" >
        <div class="POuter_Box_Inventory_orderSet" style="text-align: center">
            <b>
                <asp:Label ID="lblHeader" runat="server"></asp:Label></b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <asp:Panel ID="pnlSpine" runat="server" Visible="false">
            <div class="POuter_Box_Inventory_orderSet" >
                <div style="text-align: center">
                    <asp:Label ID="lblPopupurl" runat="server" Style="display: none"></asp:Label>
                    <asp:Repeater ID="grdMedicine" runat="server" OnItemDataBound="grdmedicine_databound"
                        OnItemCommand="grdmedicine_ItemCommand">
                        <HeaderTemplate>
                            <table border="0" width="100%" style="border-collapse: collapse; border-bottom: #888 0px week;
                                border-left: #888 1px solid; border-right: #888 1px solid;">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr id="tr" runat="server">
                                <td style="width: 8%; border-width: thin; text-align: left; border-top-color: #000000;
                                    border-top-style: solid; border-right-style: solid; border-left-style: solid;">
                                    <asp:Label ID="lblID" Visible="false" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                    <asp:Label ID="lblGroup" Visible="false" runat="server" Text='<%#Eval("Groups") %>'></asp:Label>
                                    <asp:Label ID="lblGroupID" Visible="false" runat="server" Text='<%#Eval("GroupID") %>'></asp:Label>
                                </td>
                                <td style="border-width: thin; width: 100%; text-align: left; border-top-color: #000000;
                                    border-top-style: solid; border-right-style: solid; border-left-style: solid;">
                                    <asp:Label ID="lblSubGroup" Visible="false" runat="server" Text='<%#Eval("SubGroup") %>'></asp:Label>
                                    <asp:Label ID="lblSubGroupDisplay" Font-Bold="true" runat="server" Text='<%#Eval("SubGroup") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="border-left-style: solid; border-right-style: solid; border-width: thin;
                                    border-color: #000000">
                                    <%--<a href="<%# DataBinder.Eval(Container, "DataItem.popupurl")%>?GroupID=<%# Eval("GroupID")%>&ID=<%# Eval("ID")%>" target="_blank" 
                                title="<%# DataBinder.Eval(Container, "DataItem.popupurl")%>"  visible='<%#Util.GetBoolean( Eval("IsPopup"))%>'></a>
                                    --%>
                                    <%--<asp:ImageButton ID="Image1" ImageUrl="../../Images/view.gif" runat="server" CommandName="view" 
                                 visible='<%#Util.GetBoolean( Eval("IsPopup"))%>' CausesValidation="false" CommandArgument='<%# Eval("GroupID")+"#"+Eval("popupurl")+"#"+Eval("ID")%>' />
                                    --%>
                                    <a class="fancybox" href="<%# DataBinder.Eval(Container, "DataItem.popupurl")%>?GroupID=<%# Eval("GroupID")%>&ID=<%# Eval("ID")%>&TID=<%#Eval("TID") %>&RelationalID=<%#Eval("RelationalID")%>&Categoryid=<%#Eval("Categoryid") %>">
                                        <asp:ImageButton ID="Image1" ImageUrl="../../../Images/view.gif" runat="server" Visible='<%#Util.GetBoolean( Eval("IsPopup"))%>' /></a>
                                    <asp:CheckBox ID="chk" Visible='<%#Util.GetBoolean( Eval("CheckBox"))%>' Checked='<%#Util.GetBoolean(Eval("Chk"))%>'
                                        runat="server" />
                                </td>
                                <td align="left" bgcolor="#ffffff">
                                    <asp:Label ID="lblItem" runat="server" Text='<%#Eval("Items") %>'></asp:Label>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
            </asp:Panel>
            <div class="POuter_Box_Inventory_orderSet" style=" text-align: center">
                <asp:TextBox ID="txtValue" runat="server" Text="0" Style="display: none"></asp:TextBox>
                <asp:Button ID="btnSave" CssClass="ItDoseButton" OnClick="btnSave_Click" runat="server"
                    Text="Save" class="save" OnClientClick="disable();" Visible="false" UseSubmitBehavior="false" />
            </div>
    </div>
    </form>
</body>
</html>
