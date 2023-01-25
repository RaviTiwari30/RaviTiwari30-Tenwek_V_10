<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CardMaster.aspx.cs" Inherits="Design_EDP_CardMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <script type="text/javascript" >
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpAddNewCard")) {
                    $find("mpAddNewCard").hide();

                }
            }
        }

        function validate() {
            if ($('#<%=ddlCardType.ClientID %>').val() == 0) {
                $('#<%=lblmsg.ClientID %>').text("Please Select Card Type");
                return false;
            }
            if ($('#<%=ddlPanelType.ClientID %>').val() == 0) {
                $('#<%=lblmsg.ClientID %>').text("Please Select Panel Type");
                return false;
            }
        }
    </script>

    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" >
            <div class="content" style="text-align: center;">
                <b ">Card Type Master</b>
                </br>
                <span style="font-size: 12pt">
                    <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 966px">
            <div class="Purchaseheader">
                Card Type Master
         &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 202px"></td>
                    <td align="right" style="width: 135px"><b>Card Type :&nbsp;</b></td>
                    <td>
                        <asp:DropDownList ID="ddlCardType" runat="server"  Width="269px"></asp:DropDownList></td>
                    <td style="width: 399px">
                        <asp:Button ID="btnNewCard" Text="New" runat="server"  Width="74px" CssClass="ItDoseButton"/></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="width: 202px"></td>
                    <td align="right" style="width: 135px"><b>Panel :&nbsp;</b></td>
                    <td>
                        <asp:DropDownList ID="ddlPanelType" runat="server" Width="270px"></asp:DropDownList></td>
                    <td style="width: 399px"></td>
                </tr>
                <tr>

                    <td colspan="5" align="center">
                        <asp:Button ID="btnSavePanel" Text="Map" runat="server" OnClientClick="return validate();" OnClick="btnSavePanel_Click" Width="70px"  CssClass="ItDoseButton"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="5">
                        <asp:GridView ID="grdResult" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdResult_SelectedIndexChanged" OnRowCommand="grdResult_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="CardName" HeaderText="Card Name" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="410px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Panel Name" HeaderText="Panel Name" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="410px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CardExpiryDays" HeaderText="Expiry Days" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="410px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="ItemID" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemID" runat="server" Text='<%#Bind("ItemID")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PanelID" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPanelID" runat="server" Text='<%#Bind("PanelID")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEditCard" runat="server" CommandName="EditCard" CommandArgument='<%#Eval("ItemID")+"#"+Eval("CardName")+"#"+Eval("CardExpiryDays")%>' Text="Edit"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%--<asp:CommandField ShowEditButton="true" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewLabItemStyle" EditText="Edit" HeaderText="Edit" />--%>
                                <asp:CommandField ShowSelectButton="True" SelectText="Select" HeaderText="Select">

                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemStyle CssClass="GridViewLabItemStyle" />

                                </asp:CommandField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlNewCard" runat="server" Style="display: none;" Width="350" CssClass="pnlItemsFilter" BorderStyle="Solid">
            <div style="text-align: center; height: 23px;">
                <span style="font-size: 12pt"><b style="font-size: small">New Card Type</b></span>
                <asp:Label ID="lblError" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label>
            </div>
            <table>
                <tr>
                    <td align="right" style="width: 151px"><b>Card Name :&nbsp;</b></td>
                    <td>
                        <asp:TextBox ID="txtCardName" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td align="right" style="width: 151px"><b>Expiry Days :&nbsp;</b></td>
                    <td>
                        <asp:TextBox ID="txtExpDays" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbe" runat="server" TargetControlID="txtExpDays" FilterType="Custom, Numbers" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <asp:Button Text="Save" ID="btnSave" runat="server" OnClick="btnSave_Click" CssClass="ItDoseButton"/>
                        <asp:Button Text="Cancel" ID="btnCancel" runat="server" CssClass="ItDoseButton"/>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpAddNewCard" runat="server" DropShadow="true" TargetControlID="btnNewCard" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlNewCard" CancelControlID="btnCancel" BehaviorID="mpAddNewCard">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlEditCard" Style="display: none;" runat="server" Width="350" CssClass="pnlItemsFilter" BorderStyle="Solid">
            <div style="text-align: center; height: 23px;">
                <span style="font-size: 12pt"><b style="font-size: small">Edit Card</b></span>
                <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label>
            </div>
            <div class="content">
                <table>
                    <tr>
                        <td align="right" style="width: 144px"><b>Card Name :&nbsp;</b></td>
                        <td>
                            <asp:Label ID="lblItemID" runat="server" Text="ItemID" Visible="false"></asp:Label>
                            <asp:TextBox ID="txtEditCardName" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 144px"><b>Expiry Days :&nbsp;</b></td>
                        <td>
                            <asp:TextBox ID="txtEditExpDays" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtEditExpDays" FilterType="Custom, Numbers" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Button Text="Save" ID="btnUpdateCard" runat="server" OnClick="btnEditCard_Click" CssClass="ItDoseButton"/>
                            <asp:Button Text="Cancel" ID="btnCancel1" runat="server" CssClass="ItDoseButton"/>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnHidden" Text="Hidden" runat="server" CssClass="ItDoseButton"/>
        </div>
        <cc1:ModalPopupExtender ID="mpEditCard" TargetControlID="btnHidden" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlEditCard" CancelControlID="btnCancel">
        </cc1:ModalPopupExtender>
</asp:Content>

