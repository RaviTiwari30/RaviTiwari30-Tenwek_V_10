<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ReturnToDepatment.aspx.cs" Inherits="Design_CSSD_ReturnToDepatment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        function disableButton() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        function MoveUpAndDownText(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;
                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }
            }
        }
        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>(CSSD) Issue Medical Items</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Return Items
            </div>
            <table cellpadding="0px" cellspacing="0px" style="width: 70%">
                <tr>
                    <td style="width: 20%; text-align: right">
                        <asp:Label ID="lblDept" runat="server" Text="Department :&nbsp;"></asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:DropDownList ID="ddlDept" ToolTip="Select Department" TabIndex="1" runat="server"
                            Width="180px">
                        </asp:DropDownList>
                        <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                    <td style="width: 10%">
                    </td>
                    <td style="width: 20%">
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        Items :&nbsp;
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                            ID="txtSearch" AutoCompleteType="Disabled" onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                            runat="server" Width="400px" CssClass="ItDoseTextinputText" />
                    </td>
                    <td style="width: 10%">
                        &nbsp;
                    </td>
                    <td style="width: 20%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%">
                        &nbsp;
                    </td>
                    <td style="width: 25%" rowspan="2">
                        <asp:ListBox ID="ListBox1" TabIndex="4" runat="server" CssClass="ItDoseDropdownbox"
                            Width="520px" Height="100px"></asp:ListBox>
                        &nbsp;
                    </td>
                    <td style="width: 10%">
                        &nbsp;
                    </td>
                    <td style="width: 20%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%">
                        &nbsp;
                    </td>
                    <td style="width: 15%">
                        &nbsp;
                    </td>
                    <td style="width: 28%">
                        &nbsp;
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="width: 22%; text-align: right">
                        Transfer&nbsp;Qty.&nbsp;:&nbsp;
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="txtTransferQty" runat="server" AutoCompleteType="Disabled" MaxLength="3"
                            Width="50px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterType="Numbers" TargetControlID="txtTransferQty">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 12%">
                        &nbsp;
                    </td>
                    <td style="width: 30%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                            ValidationGroup="r" />
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Details
            </div>
            <div class="content" style="text-align: center">
                <asp:GridView ID="grdSetItems" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdSetItem_RowCommand" 
                    onrowdatabound="grdSetItems_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Set Name">
                            <ItemTemplate>
                                <asp:Label ID="lblSetId" runat="server" Text='<%# Eval("SetID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSetName" runat="server" Text='<%# Eval("SetName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                <asp:Label ID="lblItemID" Visible="false" runat="server" Text='<%#Eval("ItemID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="350px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity">
                            <ItemTemplate>
                                <asp:Label ID="lblQty" runat="server" Text='<%#Eval("Quantity") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Stock Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblStockQty" runat="server" Text='<%#Eval("StockQty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Return Qty.">
                            <ItemTemplate>
                                <asp:TextBox ID="txtReturnQty" Width="40px" Text='<%#Eval("ReturnQty") %>' CssClass="ItDoseTextinputNum"
                                    AutoCompleteType="Disabled" runat="server"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbReturnQty" runat="server" FilterType="Numbers"
                                    TargetControlID="txtReturnQty">
                                </cc1:FilteredTextBoxExtender>
                                <asp:Label ID="lblReturnQty" Visible="false" Width="40px" Text='<%#Eval("ReturnQty") %>'
                                    runat="server"></asp:Label>
                                <asp:Label ID="lblBatchNumber" Visible="false" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                <asp:Label ID="lblAvailQty" Visible="false" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                                <asp:Label ID="lblFromStockID" runat="server" Text='<%# Eval("FromStockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMedExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblSetStockID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblIsSet" runat="server" Text='<%# Eval("IsSet") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblStockId" runat="server" Text='<%# Eval("StockID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View" Visible="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false"
                                    CommandArgument='<%# Eval("SetID")+"#"+Eval("ItemID")%>' CommandName="Add" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div style="text-align: center">
               <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    TabIndex="8" OnRowDataBound="grdItem_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="Server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CostPrice" Visible="false">
                            <ItemTemplate>
                                <%#Eval("UnitPrice")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MRP" Visible="false">
                            <ItemTemplate>
                                <%#Eval("MRP")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Avail.&nbsp;Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Return&nbsp;Qty.">
                            <ItemTemplate>
                                <asp:TextBox ID="txtReturnQty" runat="server" CssClass="ItDoseTextinputNum" MaxLength="3"
                                    Width="60px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers"
                                    TargetControlID="txtReturnQty">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiryDate" runat="server" Text='<%# Eval("ExpiryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Issue Qty." Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtIssueQty" runat="server" CssClass="ItDoseTextinputNum" MaxLength="3"
                                    Width="50px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers"
                                    TargetControlID="txtIssueQty">
                                </cc1:FilteredTextBoxExtender>
                                <asp:Label ID="lblFromStockID" runat="server" Text='<%# Eval("FromStockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblStockId" runat="server" Text='<%# Eval("StockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSetStockID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMedExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblIsSet" runat="server" Text='<%# Eval("IsSet") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <br />
                &nbsp;<asp:Button ID="btnAddItem" runat="server" CssClass="ItDoseButton" OnClick="btnAddItem_Click"
                    TabIndex="10" Text="Add Item"  Visible="false"/>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Details
            </div>
            <div class="content" style="text-align: center">
                <asp:GridView ID="grdItemDetails" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdItemDetails_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <%# Eval("ItemName") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rate" Visible="false">
                            <ItemTemplate>
                                <%# Math.Round(Util.GetDouble(Eval("MRP")),2) %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch">
                            <ItemTemplate>
                                <%# Eval("BatchNumber") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc (%)" Visible="false">
                            <ItemTemplate>
                                <%# Eval("Discount")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc" Visible="false">
                            <ItemTemplate>
                                <%# Math.Round(Util.GetDouble(Eval("DiscountAmt")),2) %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax (%)" Visible="false">
                            <ItemTemplate>
                                <%#Eval("Tax")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="In Hand Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblAvail" runat="server" Text='<%# Eval("Qty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText=" Amount" Visible="false">
                            <ItemTemplate>
                                <%# Math.Round(Util.GetDouble(Eval("GrossAmount")),2) %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Return Qty.">
                            <ItemTemplate>
                                <%# Eval("ReturnQty")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Consume Qty." Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtConsumeQty" runat="server" CssClass="ItDoseTextinputNum" MaxLength="3"
                                    Width="50px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers"
                                    TargetControlID="txtConsumeQty">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="95px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Is Set" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblIsSetNew" runat="server" Text='<%# Eval("IsSet") %>' Visible="true"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText=" Remove">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                    CommandName="imbRemove" ImageUrl="../../Images/Delete.gif" ToolTip="Click To Remove" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="55px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                &nbsp;
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="save" OnClick="btnSave_Click" OnClientClick="return disableButton()"
                UseSubmitBehavior="false" CssClass="ItDoseButton" Visible="false" />
        </div>
    </div>
</asp:Content>
