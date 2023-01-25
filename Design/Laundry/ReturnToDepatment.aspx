<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ReturnToDepatment.aspx.cs" Inherits="Design_Laundry_ReturnToDepatment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript"  src="../../Scripts/Message.js" >
        function disableButton() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        function ClosePopUp() {
            $find('mpeRequestDetail').hide();
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
            <b>&nbsp;Send Item To Laundry</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Return Items
            </div>
            <table style="width: 70%">
                <tr>
                    <td style="width: 20%; text-align: right">
                        <asp:Label ID="lblDept" runat="server" Text="Department :&nbsp;"></asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:DropDownList ID="ddlDept" CssClass="requiredField" ToolTip="Select Department" TabIndex="1" runat="server"
                            Width="180px">
                        </asp:DropDownList>
                        
                    </td>
                    <td style="width: 10%"></td>
                    <td style="width: 20%">
                        <asp:Button ID="btnOldRequest" runat="server" Text="Check Old Request" CssClass="ItDoseButton" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">Items :&nbsp;
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                            ID="txtSearch" AutoCompleteType="Disabled" onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                            runat="server" Width="400px" CssClass="ItDoseTextinputText" />
                    </td>
                    <td style="width: 10%">&nbsp;
                    </td>
                    <td style="width: 20%">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%">&nbsp;
                    </td>
                    <td style="width: 25%" rowspan="2">
                        <asp:ListBox ID="ListBox1" TabIndex="4" runat="server" CssClass="ItDoseDropdownbox"
                            Width="520px" Height="100px"></asp:ListBox>
                        &nbsp;
                    </td>
                    <td style="width: 10%">&nbsp;
                    </td>
                    <td style="width: 20%">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%">&nbsp;
                    </td>
                    <td style="width: 15%">&nbsp;
                    </td>
                    <td style="width: 28%">&nbsp;
                    </td>
                </tr>
                <tr style="display: none">
                    <td style="width: 22%; text-align: right">Transfer&nbsp;Qty.&nbsp;:&nbsp;
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="txtTransferQty" runat="server" AutoCompleteType="Disabled" MaxLength="3"
                            Width="50px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterType="Numbers" TargetControlID="txtTransferQty">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 12%">&nbsp;
                    </td>
                    <td style="width: 30%">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                            ValidationGroup="r" />
                    </td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Details
            </div>

            <div style="text-align: center">
                <asp:GridView ID="grdItem"  Width="100%"  runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
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
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Avail.&nbsp;Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
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
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Comment">
                            <ItemTemplate>
                                <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" 
                                    ></asp:TextBox>
                                  </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiryDate" runat="server" Text='<%# Eval("ExpiryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Issue Qty." Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtIssueQty" runat="server" CssClass="ItDoseTextinputNum" MaxLength="3"
                                    Width="50px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers"
                                    TargetControlID="txtIssueQty">
                                </cc1:FilteredTextBoxExtender>
                                <asp:Label ID="lblStockId" runat="server" Text='<%# Eval("StockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblFromStockID" runat="server" Text='<%# Eval("FromStockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMedExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>' Visible="False"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <br />
                &nbsp;<asp:Button ID="btnAddItem" runat="server" CssClass="ItDoseButton" OnClick="btnAddItem_Click"
                    TabIndex="10" Text="Add Item" Visible="false" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Details
            </div>
            <div class="content" style="text-align: center">
                <asp:GridView ID="grdItemDetails" runat="server" Width="100%" AutoGenerateColumns="false" CssClass="GridViewStyle"
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
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Batch">
                            <ItemTemplate>
                                <%# Eval("BatchNumber") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>



                        <asp:TemplateField HeaderText="In Hand Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblAvail" runat="server" Text='<%# Eval("Qty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Return Qty.">
                            <ItemTemplate>
                                <%# Eval("ReturnQty")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Comment">
                            <ItemTemplate>
                                <%# Eval("Comment")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
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
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
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
            <asp:Button ID="btnSave" runat="server" Text="save" OnClick="btnSave_Click" 
                UseSubmitBehavior="false" CssClass="save margin-top-on-btn" Visible="false" />
        </div>
    </div>
    <cc1:ModalPopupExtender ID="mpeRequestDetail" BehaviorID="mpeRequestDetail" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        TargetControlID="btnOldRequest" CancelControlID="btnClose" PopupControlID="pnlRequestDetail" />
    <asp:Panel ID="pnlRequestDetail" runat="server" Style="display: none;">
        <div style="margin: 0px; background-color: #eaf3fd; border: solid 1px Green; display: inline-block; padding: 1px 1px 1px 1px; margin: 0px 10px 3px 10px; width: 800px;">
            <div class="Purchaseheader">
                <table width="793px">
                    <tr>
                        <td style="text-align: left;">
                            <b>Laundry Request Detail</b>
                        </td>
                        <td style="text-align: right;">
                            <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="ClosePopUp()" />to close</span></em>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="width: 797px; text-align: center;">
                <b>
                    <asp:Label ID="spnLowError" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label></b>&nbsp;                
            </div>
            <div class="POuter_Box_Inventory" style="min-height: 200px; padding: 10px; width: 777px;">
                <asp:GridView ID="grdRequestDetail" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField HeaderText="ItemName" DataField="ItemName" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" ItemStyle-Width="150px" />
                        <asp:BoundField HeaderText="Send Qty" DataField="Send Qty" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField HeaderText="Send By" DataField="Send By" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField HeaderText="Send Date" DataField="Send Date" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField HeaderText="Washing Qty" DataField="WashingQty" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField HeaderText="Dryer Qty" DataField="DryerQty" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField HeaderText="Ironing Qty" DataField="IroningQty" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField HeaderText="Completed" DataField="Completed" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                    </Columns>
                </asp:GridView>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 797px;">
                <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="ItDoseButton" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
