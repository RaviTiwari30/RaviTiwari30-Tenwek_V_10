<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DepartmentReturn.aspx.cs"
    Inherits="Design_Store_DepartmentReturn" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $('#ddlDept,#ddlItem').chosen();
        });
        function doClick(buttonName, e) {
            var key;
            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox
            if (key == 13) {
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function validatedot() {
            if ($(".GridViewStyle").find(".ItDoseTextinputNum").val() != null) {
                if (($(".GridViewStyle").find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
                    $(".GridViewStyle").find(".ItDoseTextinputNum").val('');
                    return false;
                }
            }
            return true;
        }
        var onReturnQtyChange = function (elem) {
            var checkbox = $(elem).closest('tr').find('input[type=checkbox]');
            var qty = Number(elem.value);

            var remainingquantity = $(elem).closest('tr').find('#lblAqty').text();
            if (qty > remainingquantity) {
                modelAlert("Return Quantity Can Not Greater then Available Quantity.", function () { elem.value = 0; elem.focus(); $(checkbox).prop('checked', false); });
            }
            else {
                if (qty > 0) {
                    $(checkbox).prop('checked', true);
                    //validateItemForReturn(checkbox);
                }
                else {
                    $(checkbox).prop('checked', false);
                    // addReturnAmount(function () { });
                }
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Department Return</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                                <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Dept.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" AutoPostBack="True" CssClass="requiredField" ClientIDMode="Static"
                                OnSelectedIndexChanged="ddlDept_SelectedIndexChanged" />
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlItem" runat="server" CssClass="requiredField" ClientIDMode="Static" />
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                OnClick="btnSearch_Click" CausesValidation="False" />
        </div>
    
    <asp:Panel ID="pnlInfo" runat="server">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div style="display: none;">
                <label class="labelForTag" visible="false" runat="server">
                    BarCode</label>
                <asp:TextBox ID="txtBarCode" runat="server" CssClass="ItDoseTextinputText" Width="0px"
                    Height="0px">
                </asp:TextBox>
                <asp:Button ID="btnBar" runat="server" Text="BarCode" CssClass="ItDoseButton" Width="75px"
                    OnClick="btnBar_Click" CausesValidation="False" />
            </div>

            <div class="" style="max-height: 150px; overflow: auto; text-align: center;">
                <asp:GridView ID="grdItem" Width="100%" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" ClientIDMode="Static">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch No." >
                            <ItemTemplate>
                                <asp:Label ID="lblBatch" runat="server" Text='<%#Eval("BatchNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post Date" >
                            <ItemTemplate>
                                <%#Eval("Date")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Avail. Qty." >
                            <ItemTemplate>
                                <asp:Label ID="lblAqty" ClientIDMode="Static" runat="server" Text='<%#Eval("AvailQty") %>'></asp:Label>
                                <asp:Label ID="lblMedExpiry" runat="server" Text='<%#Eval("MedExpiryDate") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Unit Cost" >
                            <ItemTemplate>
                                <asp:Label ID="lblPrice" runat="server" Text='<%#Eval("UnitPrice") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Return Qty." >
                            <ItemTemplate>
                                <asp:TextBox ID="txtReturn" ClientIDMode="Static" AutoCompleteType="Disabled"  runat="server" CssClass="ItDoseTextinputNum" Width="50px" onkeypress="return checkForSecondDecimal(this,event)"  onkeyup="onReturnQtyChange(this);validatedot();" MaxLength="8"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="Return" runat="server" TargetControlID="txtReturn" FilterMode="ValidChars" FilterType="Custom,Numbers" ValidChars="."></cc1:FilteredTextBoxExtender>
                                <asp:Label ID="lblSellPrice" runat="server" Text='<%#Eval("MRP") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblfromStockID" runat="server" Text='<%#Eval("fromStockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblStockID" runat="server" Text='<%#Eval("StockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDeptStock" runat="server" Text='' Visible="false"></asp:Label>
                                <asp:Label ID="lblIGSTPercent" runat="server" Text='<%#Eval("IGSTPercent") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCGSTPercent" runat="server" Text='<%#Eval("CGSTPercent") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSGSTPercent" runat="server" Text='<%#Eval("SGSTPercent") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHSNCode" runat="server" Text='<%#Eval("HSNCode") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblGSTType" runat="server" Text='<%#Eval("GSTType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%#Eval("SaleTaxPer") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPurTaxPer" runat="server" Text='<%#Eval("PurTaxPer") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
            <div class="POuter_Box_Inventory" align="center">
                <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton"
                    OnClick="btnAddItem_Click" CausesValidation="False" />
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlSave" runat="server">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Return Items
            </div>
            <div class="" style="max-height: 150px; overflow: auto; text-align: center;">
                <asp:GridView Width="100%" ID="grdItemDetails" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false"
                    OnRowCommand="grdItemDetails_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name" >
                            <ItemTemplate>
                                <%#Eval("ItemName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch No.">
                            <ItemTemplate>
                                <%#Eval("BatchNo")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Unit Cost">
                            <ItemTemplate>
                                <%#Eval("UnitPrice")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Return Qty.">
                            <ItemTemplate>
                                <%#Eval("RetQty")%>
                                <asp:Label ID="lblfromStockID" runat="server" Text='<%#Eval("fromStockID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblStockID" runat="server" Text='<%#Eval("StockID") %>' Visible="false"></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <label class="labelForTag">
                    Narration :</label>
                <asp:TextBox ID="txtNarration" CssClass="requiredField" runat="server" Width="250px" MaxLength="200">
                </asp:TextBox>
                <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtNarration"
                    Display="None" ErrorMessage="Specify Narration" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                    ShowSummary="False" />
            </div>
            <div class="content" style="text-align: center;">
                <asp:CheckBox ID="chkPrint" runat="server" Text="Print" Checked="true" />&nbsp;
                    <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" CssClass="ItDoseButton"
                        Text="Save" />
            </div>
        </div>
    </asp:Panel>
  </div>
</asp:Content>
