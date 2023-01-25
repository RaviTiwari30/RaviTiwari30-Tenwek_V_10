<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangeCurrentStock_MRP.aspx.cs" Inherits="Design_Store_ChangeCurrentStock_MRP" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#00ff00';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }

        function CheckSellingPrice(Ctrl) {
            var txtCon = Ctrl.parentNode.parentNode.getElementsByTagName("input");
            if (txtCon != '') {
              //  if (Number(txtCon[1].value) < Number(txtCon[0].value)) {
               //     alert("Selling Price Can not be less than unit price");
               //     txtCon[1].value = '';
              //  }
            }
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ddlItem").chosen();

            $("#<%=grdSellingPrice.ClientID%> input[id$='_txtNewSellingPrice']").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
        });

        function ValidateDecimalPlaces(text) {
            var DigitsAfterDecimal = 4;
            var val = $(text).val();
            var valIndex = val.indexOf(".");
            if (valIndex != -1) {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $(text).val($(text).val().substring(0, ($(text).val().length - 1)))
                    return false;
                }
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Change Stock Unit Price</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="width: 100%;">
                <tr>
                    <td style="text-align: right">Store Type :&nbsp;</td>
                    <td>
                        <asp:RadioButtonList ID="rbtnMedNonMed" runat="server" RepeatDirection="horizontal" AutoPostBack="True" OnSelectedIndexChanged="rbtnMedNonMed_SelectedIndexChanged">
                            <asp:ListItem Selected="True" Text="Medical Items" Value="1"></asp:ListItem>
                            <asp:ListItem Text="General Items" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="text-align: right">Departments :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlDpt" runat="server" Width="166px" AutoPostBack="true" OnSelectedIndexChanged="ddlDpt_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">&nbsp;Group :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlGroup" Width="166px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroup_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                    <td style="text-align: right">Item :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlItem" runat="server" Width="166px" ClientIDMode="Static"></asp:DropDownList>
                        <asp:CheckBox ID="chkSellingPrice_Zero" Text="Zero Price" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">&nbsp;</td>
                    <td style="text-align: right">&nbsp;</td>
                    <td style="text-align: right">&nbsp;</td>
                    <td style="text-align: right">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnSearch_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <asp:GridView ID="grdSellingPrice" runat="server" AutoGenerateColumns="False" OnRowDataBound="grdSellingPrice_RowDataBound" CssClass="GridViewStyle" Width="100%">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>                    
                    <asp:TemplateField HeaderText="StockID" HeaderStyle-Width="50px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblStockID" runat="server" Text='<%#Eval("StockID") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Stock Date" HeaderStyle-Width="100px" HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblStockDate" runat="server" Text='<%#Eval("StockDate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="350px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Batch Number" HeaderStyle-Width="100px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblBatchNumber" runat="server" Text='<%#Eval("BatchNumber") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>


                    
                    <asp:TemplateField HeaderText="Unit Price" HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblUnitPrice" runat="server" Text='<%#Eval("UnitPrice") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField Visible="false" HeaderText="Sell. Price" HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblSellingPrice" runat="server" Text='<%#Eval("SellingPrice") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="In Hand Qty." HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblInHandQty" runat="server" Text='<%#Eval("AvailableQty") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Expiry Date" HeaderStyle-Width="100px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblExpiryDate" runat="server" Text='<%#Eval("ExpiryDate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="New Unit. Price" HeaderStyle-Width="150px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                        <ItemTemplate>
                            <asp:TextBox ID="txtUnitPrice" Width="250px" runat="server" Text='<%#Eval("UnitPrice") %>' Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtNewSellingPrice" Width="150px" runat="server" Onblur="CheckSellingPrice(this);" MaxLength="9" onkeyup="ValidateDecimalPlaces(this);"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers" ValidChars="." TargetControlID="txtNewSellingPrice"></cc1:FilteredTextBoxExtender>
                            <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;" class="content">
                <asp:Button ID="btnSave" Visible="false" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnSave_Click" />
            </div>
        </div>
    </div>
</asp:Content>

