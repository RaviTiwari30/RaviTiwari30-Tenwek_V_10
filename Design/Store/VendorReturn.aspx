<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorReturn.aspx.cs" Inherits="Design_Store_VendorReturn"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#ddlVendor,#ddlItem').chosen();
        });
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
        function doClick(buttonName, e) {

            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
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
            if (($("#<%=grdItem.ClientID %>").find("input[type=text][id*=txtReturn]").val().charAt(0) == ".")) {
                $("#<%=grdItem.ClientID %>").find("input[type=text][id*=txtReturn]").val('');
                return false;
            }
           
        }
        function RestrictDoubleEntry(btn) {
            var con = 0;
            if ($.trim($("#txtNarration").val()) == "") {
                $("#lblMsg").text('Please Enter Narration');
                $("#txtNarration").focus();
                con = 1;
                return false;
            }
            if (con == 0) {
                btn.disabled = true;
                btn.value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Supplier Return</b><br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
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
                        <div class="col-md-2">
                            <label class="pull-left">
                                Supplier
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlVendor" runat="server" CssClass="requiredField" AutoPostBack="True" Width="" ClientIDMode="Static"
                                OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged" />
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlItem" CssClass="requiredField" runat="server" Width="" ClientIDMode="Static" />
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                             <asp:RadioButtonList runat="server" ID="rblReturnOn" RepeatDirection="Horizontal"  OnSelectedIndexChanged="rblReturnOn_SelectedIndexChanged" AutoPostBack="true"  >
                                    <asp:ListItem Value="0" Selected="True" >Purchase Price</asp:ListItem>
                                    <asp:ListItem Value="1">MRP</asp:ListItem>
                                 <asp:ListItem Value="2"> Request</asp:ListItem>
                                </asp:RadioButtonList>
                        </div>
                         <div class="col-md-2">
                            <label class="pull-left">
                               ItemType 
                            </label>
                            <b class="pull-right">: </b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList runat="server" ID="rbExpired" RepeatDirection="Horizontal"  >
                                    <asp:ListItem Value="0"  >Expired</asp:ListItem>
                                    <asp:ListItem Value="1" Selected="True">Not Expired</asp:ListItem>
                                </asp:RadioButtonList>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                              By Supplier
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:RadioButtonList runat="server" ID="rbSupplier" RepeatDirection="Horizontal" OnSelectedIndexChanged="rbSupplier_SelectedIndexChanged" AutoPostBack="true"  >
                                    <asp:ListItem Value="0"  >Yes</asp:ListItem>
                                    <asp:ListItem Value="1" Selected="True">No</asp:ListItem>
                                </asp:RadioButtonList>
                        </div>
                       <div class="col-md-2">
                            <input class="label label-important" type="button"  id="btnPendingDrafts" runat="server" onclick="$getDrafts(this)" value="Pending Draft`s" />
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
                <div class="" style="max-height: 150px; overflow: auto;">
                    <div style="display: none;">
                        <label class="labelForTag">
                            BarCode :</label>
                        <asp:TextBox ID="txtBar" runat="server" CssClass="ItDoseTextinputText" Width="75px">
                        </asp:TextBox>
                        <asp:Button ID="btnBar" runat="server" CssClass="ItDoseButton" Text="BarCode" Width="75px"
                            OnClick="btnBar_Click" CausesValidation="False" />
                    </div>
                    <asp:GridView ID="grdItem" Width="100%" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" ClientIDMode="Static">
                        <Columns>
                            <asp:TemplateField  HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="server" ClientIDMode="Static" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="GRN No." HeaderStyle-Width="200px">
                                <ItemTemplate>
                                    <asp:Label ID="lblgrn" runat="server" Text='<%#Eval("BillNO") %>' ></asp:Label>
                                    <asp:Label ID="lblGRN_NO" runat="server" Text='<%#Eval("LedgerTransactionNo") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Invoice No." HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:Label ID="lblInvoice_NO" runat="server" Text='<%#Eval("InvoiceNo") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="250px">
                                <ItemTemplate>
                                    <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Batch No." HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:Label ID="lblBatch" runat="server" Text='<%#Eval("BatchNumber") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Expriy" HeaderStyle-Width="80px">
                                <ItemTemplate>
                                    <%#Eval("MedExpiryDate")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Avail. Qty." HeaderStyle-Width="70px">
                                <ItemTemplate>
                                    <asp:Label ID="lblAqty" runat="server" ClientIDMode="Static" Text='<%#Eval("AvailQty", "{0:f2}") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Unit Cost" HeaderStyle-Width="70px">
                                <ItemTemplate>
                                    <asp:Label ID="lblPrice" runat="server" Text='<%#Eval("UnitPrice", "{0:f2}") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                               <asp:TemplateField HeaderText="New Batch No" HeaderStyle-Width="110px">
                                <ItemTemplate>
                            <asp:TextBox ID="txtNewBatchNo" runat="server" Width="100px"    MaxLength="8"></asp:TextBox>                                  
                              </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="Dis(%)" HeaderStyle-Width="50px">
                                <ItemTemplate>
                            <asp:TextBox ID="txtDis" runat="server" Width="50px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="2"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="Dis" runat="server" TargetControlID="txtDis" FilterMode="ValidChars" FilterType="Custom,Numbers" ValidChars="."></cc1:FilteredTextBoxExtender>
                              </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Return Qty." HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReturn" AutoCompleteType="Disabled" runat="server"  CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="onReturnQtyChange(this);validatedot();" MaxLength="8" ClientIDMode="Static" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="Return" runat="server" TargetControlID="txtReturn" FilterMode="ValidChars" FilterType="Custom,Numbers" ValidChars="."></cc1:FilteredTextBoxExtender>
                                    <asp:Label ID="lblMRP" runat="server" Text='<%#Eval("MRP") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblStockID" runat="server" Text='<%#Eval("StockID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSubCategory" runat="server" Text='<%#Eval("SubCategoryID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblMedExp" runat="server" Text='<%#Eval("MedExpiryDate") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblisExpirable" runat="server" Text='<%#Eval("IsExpirable") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblPurTaxPer" runat="server" Text='<%#Eval("PurTaxPer") %>' Visible="false"></asp:Label>
                                     <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%#Eval("SaleTaxPer") %>' Visible="false"></asp:Label>
                                    <%--     GST Changes--%>
                                    <asp:Label ID="lblIGSTPercent" runat="server" Text='<%#Eval("IGSTPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCGSTPercent" runat="server" Text='<%#Eval("CGSTPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSGSTPercent" runat="server" Text='<%#Eval("SGSTPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblGSTType" runat="server" Text='<%#Eval("GSTType") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblHSNCode" runat="server" Text='<%#Eval("HSNCode") %>' Visible="false"></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center">
                <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton" OnClick="btnAddItem_Click" CausesValidation="False" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlSave" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Return Items
                </div>
                <div class="" style="max-height: 150px; overflow: auto; text-align: center;">
                    <asp:GridView ID="grdItemDetails" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false"
                        OnRowCommand="grdItemDetails_RowCommand" Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Invoice No">
                                <ItemTemplate>
                                    <%#Eval("InvoiceNo")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name">
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
                                                        <asp:TemplateField HeaderText="New BatchNo.">
                                <ItemTemplate>
                                    <%#Eval("NewBatchNo")%>
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
                                    <asp:Label ID="lblStockID" runat="server" Text='<%#Eval("StockID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="GST(%)">
                                <ItemTemplate>
                                    <asp:Label ID="lblPurVATPer" runat="server" Text='<%#Eval("PurTaxPer") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="IGST(%)" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblIGSTPer" runat="server" Text='<%#Eval("IGSTPercent") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="CGST(%)" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblCGSTPer" runat="server" Text='<%#Eval("CGSTPercent") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="SGST(%)" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblSGSTPer" runat="server" Text='<%#Eval("SGSTPercent") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="GSTType" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblGSTType" runat="server" Text='<%#Eval("GSTType") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Dis(%)" HeaderStyle-Width="80px">
                                <ItemTemplate>
                                    <%#Eval("DiscountPer")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                                <asp:TemplateField HeaderText="Discount Amount" HeaderStyle-Width="80px">
                                <ItemTemplate>
                                    <%#Eval("DiscountAmt")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Return Amount">
                                <ItemTemplate>
                                    <%#Eval("Amount")%>
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
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Total Return Amount
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:Label ID="lblTotal" runat="server" Font-Bold="True"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Narration
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNarration" runat="server" CssClass="requiredField"  AutoCompleteType="Disabled"
                                    MaxLength="200" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Requisition No./Gate No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIndentNo" runat="server"
                                    Width="" MaxLength="100"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory"  style="text-align:center">
                <asp:Button ID="btnSaveAsDraft" runat="server"   OnClick="btnSaveAsDraft_Click" CssClass="ItDoseButton" Text="Save as Draft"  />
                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" CssClass="ItDoseButton" Text="Save" OnClientClick="return RestrictDoubleEntry(this);" />
            </div>
        </asp:Panel>
        <asp:Panel ID="PanelDrafts" runat="server" style="display:none;" >
            <div class="POuter_Box_Inventory" id="dvDraftsHistory">
                <div class="Purchaseheader">
                    Drafts Record
                </div>
                <div id="dvDraftsHistoryDetail" style="overflow: auto;">
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Total Amount
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:Label ID="lblDraftsTotal" runat="server" Font-Bold="True"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Narration
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDraftsNarration" runat="server" CssClass="requiredField" Width=""
                                    MaxLength="200" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">
                                    Requisition No./Gate No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDraftsGateNo" runat="server"
                                    Width="" MaxLength="100"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div id="divSave" class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" style="width: 100px; margin-top: 7px" id="btnDraft" class="ItDoseButton" value="Save" onclick="save(this)" />
            </div>
        </asp:Panel>
    </div>
    <div id="divDraftsSearch" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 900px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeDraft()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Pending Drafts</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">To Date    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div style="text-align: center" class="row">
                        <button type="button" onclick="$searchOldDraftDetail()">Search</button>
                    </div>
                    <div style="height: 200px" class="row">
                        <div id="divSearchModelDraftSearchResults" class="col-md-24">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$closeDraft()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" >
        var $getDrafts = function () {
            $('#divDraftsSearch').showModel();
        }
        var $closeDraft = function () {
            $('#divDraftsSearch').hideModel();
        }
        var _PageSize = 9;
        var _PageNo = 0;
        var $searchOldDraftDetail = function () {
            var data = {
                FromDate: $('#txtSearchModelFromDate').val(),
                ToDate: $('#txtSerachModelToDate').val()
            }
            serverCall('VendorReturn.aspx/getDrafts', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    drafts = JSON.parse(response);
                    if (drafts != null) {
                        _PageCount = drafts.length / _PageSize;
                        showPage(0);
                    }
                    else {
                        $('#divSearchModelDraftSearchResults').html('');
                    }
                }
                else
                    $('#divSearchModelDraftSearchResults').html('');
            });
        }
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputdrafts = $('#tb_OldDrafts').parseTemplate(drafts);
            $('#divSearchModelDraftSearchResults').html(outputdrafts);
        }
        var selectRecord = function (eve) {
            var row = $(eve).closest("tr");
            var data = JSON.parse($(row).find("#tdData").text());
            getSelectedRowDetails(data.RequestNo);
        }
        function getSelectedRowDetails(RequestNo) {
            serverCall('VendorReturn.aspx/getDraftsDetail', { RequestNo: RequestNo }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var htmlOutPut = $("#scriptDraftHistory").parseTemplate(responseData);
                    $("#dvDraftsHistoryDetail").html(htmlOutPut);
                    $("#<%=pnlInfo.ClientID %>").hide();
                    $("#<%=pnlSave.ClientID %>").hide();
                    $("#<%=PanelDrafts.ClientID %>").show();
                    $("#dvDraftsHistory,#dvDraftsHistoryDetail").show();
                    $('#divDraftsSearch').hideModel();
                    calculateTotal(function (total) {
                        callback(true);
                    });
                }
            });
        }
        var save = function () {
            getDetail(function (data) {
                serverCall('VendorReturn.aspx/SaveDraftsData', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            window.open("VendorReturnReport.aspx?NRGP=" + responseData.SalesNo)
                            window.location.reload();
                        }
                    });
                });
            })
        }
        var getDetail = function (callback) {
            Details = [];
            var table = $('#tbList tbody tr input[type=checkbox]:checked');
            $(table).closest('tr').each(function (i, e) {
                var data = JSON.parse($(e).find("#tdData1").text());
                Details.push({
                    StoreType: data.StoreType,
                    InvoiceNo: data.InvoiceNo,
                    GRN_NO: data.GRN_NO,
                    RequestNo: data.RequestNo,
                    LedgerNumber: data.Vender_ID,
                    StockID: data.StockID,
                    DepartmentID: data.DeptID,
                    ItemID: data.ItemID,
                    NewBatchNo: data.NewBatchNo,
                    BatchNo: data.BatchNo,
                    SubCategory: data.SubCategory,
                    IsExpirable: data.IsExpirable,
                    GSTType: data.GSTType,
                    HSNCode: data.HSNCode,
                    UnitPrice: parseFloat($(e).find("#txtUnitPrice").val()),
                    RetQty: data.RetQty,
                    PurTaxPer: data.PurTaxPer,
                    MRP: data.MRP,
                    SaleTaxPer: data.SaleTaxPer,
                    IGSTPercent: data.IGSTPercent,
                    CGSTPercent: data.CGSTPercent,
                    SGSTPercent: data.SGSTPercent,
                    DiscountPer: data.DiscountPer,
                    DiscountAmt: data.DiscountAmt,
                    medExpiryDate: data.medExpiryDate,
                    Narration: $("#<%=txtDraftsNarration.ClientID%>").val(),
                    IndentNo: $("#<%=txtDraftsGateNo.ClientID%>").val(),
                    NewAmount: parseFloat($(e).find("#tdNetAmount").text())
                });
            });
            if (Details.length <= 0) {
                modelAlert('Please Select Any Record');
                return false;
            }
            if ($.trim($("#<%=txtDraftsNarration.ClientID%>").val()) == "") {
                modelAlert('Please Enter Narration');
                $("#<%=txtNarration.ClientID%>").focus();
             return false;
         }
            callback({ Details: Details });
        }
     var onUnitCostChange = function (elem, callback) {
         var row = $(elem).closest('tr');
         var UnitCost = isNaN(parseFloat(elem.value)) ? 0 : elem.value;
         var quantity = parseFloat(row.find('#tdRetQty').text());
         var grossAmount = precise_round((parseFloat(quantity) * parseFloat(UnitCost)), 4);
         var dicountAmount = Number(row.find('#tdDiscountAmt').text());
         var netAmount = precise_round((grossAmount - dicountAmount), 4);
         row.find('#tdNetAmount').text(netAmount);
         calculateTotal(function (total) {
             callback(true);
         });
     }
     var calculateTotal = function (callback) {
         var totalAmount = 0;
         $('#tbList tbody tr').each(function () {
             totalAmount += Number($(this).find('#tdNetAmount').text());
         });
         $("#<%=lblDraftsTotal.ClientID%>").text(totalAmount);
     }
        function cancelPendingDrafts(eve) {
            var row = $(eve).closest("tr");
            var data = JSON.parse($(row).find("#tdData").text());
            modelConfirmation('Confirmation !', 'Do you want to delete ?', 'Delete', 'Cancel', function (status) {
                if (status) {
                    serverCall('VendorReturn.aspx/cancelPendingDrafts', { RequestNo: data.RequestNo }, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status) {
                                $searchOldDraftDetail();
                            }
                        });
                    });
                }
            });
        }
     function cancelRecord(eve) {
         var row = $(eve).closest("tr");
         var data = JSON.parse($(row).find("#tdData1").text());
         modelConfirmation('Confirmation !', 'Do you want to delete ?', 'Delete', 'Cancel', function (status) {
             if (status) {
                 serverCall('VendorReturn.aspx/cancelRecord', { pid: data.Id, RequestNo: data.RequestNo }, function (response) {
                     var $responseData = JSON.parse(response);
                     modelAlert($responseData.response, function () {
                         if ($responseData.status) {
                             getSelectedRowDetails(data.RequestNo);
                         }
                     });
                 });
             }
         });
     }
    </script>
    <script id="tb_OldDrafts" type="text/html">
    <table  id="tablePendingDrafts" cellspacing="0" rules="all" border="1" 
    style="width:876px;border-collapse :collapse;">
        <thead>
            <tr id="Header">
                <th class="GridViewHeaderStyle" scope="col">Select</th>
                <th class="GridViewHeaderStyle" scope="col">RequestNo</th>
                <th class="GridViewHeaderStyle" scope="col">Vendor Name</th>
                <th class="GridViewHeaderStyle" scope="col">Item Name</th>
                <th class="GridViewHeaderStyle" scope="col">QTY</th>
                <th class="GridViewHeaderStyle" scope="col">Amount</th>
                <th class="GridViewHeaderStyle" scope="col">Date</th>
                <th class="GridViewHeaderStyle" scope="col"></th>
            </tr>
            </thead>
        <tbody>
        <#     
              var dataLength=drafts.length;
        if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {           
       var objRow = drafts[j];
        #>
                        <tr  id="<#=j+1#>" style='cursor:pointer;'>                                                      
                        <td class="GridViewLabItemStyle">
                       <a  class="btn" onclick="selectRecord(this);" style="cursor:pointer;padding:0px;font-weight:bold; " >
                       <img src="../../Images/Post.gif"  alt="Select" />
                       </a>   
                        </td>                                                    
                        <td  class="GridViewLabItemStyle" id="tdRequestNo"  ><#=objRow.RequestNo#></td>
                        <td class="GridViewLabItemStyle" id="tdLedgerName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.LedgerName#></td>
                        <td  class="GridViewLabItemStyle" id="tdItemName"  ><#=objRow.ItemName#></td>
                        <td  class="GridViewLabItemStyle" id="tdQTY"  ><#=objRow.QTY#></td>
                        <td  class="GridViewLabItemStyle" id="tdAmount"  ><#=objRow.Amount#></td>
                        <td  class="GridViewLabItemStyle" id="tdEntryDate"  ><#=objRow.EntryDate#></td>
                               <td class="GridViewLabItemStyle" id="td1" style="width:30px;text-align:center;">
                    <#if(objRow.Id!=''){#>
                        <img id="img1" src="../../Images/Delete.gif" style="cursor:pointer;" title="Click To Cancel " onclick="cancelPendingDrafts(this);"/>
                    <#}#>
                </td> 
                       <td class="GridViewLabItemStyle tdData" id="tdData" style="display:none"><#=JSON.stringify(objRow) #></td> 
                        </tr>            
        <#}        
        #>
        </tbody>      
     </table>  
     <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
       <tr>
   <# if(_PageCount>1) {
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
   }
#>
     </tr>     
     </table>  
    </script>
    <script type="text/html" id="scriptDraftHistory">
        <table cellspacing="0" rules="all" id="tbList" border="1" style="border-collapse:collapse;width:100%" >
            <thead>
            <tr id="Tr1">   
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">#</th>                
                <th class="GridViewHeaderStyle" scope="col" >Invoice No	</th>
                <th class="GridViewHeaderStyle" scope="col" >Item Name	</th>
                <th class="GridViewHeaderStyle" scope="col" >Batch No.	</th>
                <th class="GridViewHeaderStyle" scope="col" >New BatchNo.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;" >Return Cost</th>
                <th class="GridViewHeaderStyle" scope="col" >Return Qty.	</th>
                <th class="GridViewHeaderStyle" scope="col" >GST(%)	</th>
                <th class="GridViewHeaderStyle" scope="col" >Dis(%)	</th>
                <th class="GridViewHeaderStyle" scope="col" >Discount Amount</th>
                <th class="GridViewHeaderStyle" scope="col" >Amount</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;"></th>     
             </tr>
                </thead>
            <tbody>
            <#       
		    var dataLength=responseData.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow; 
            var strStyle="";            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = responseData[j];
		    #>
            <tr id="Tr2" class="<#=strStyle#>">                
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#> <input type="checkbox" /></td>                                      
                <td class="GridViewLabItemStyle" id="td3" style="text-align:left;"><#=objRow.InvoiceNo #></td>    
				<td class="GridViewLabItemStyle" id="td4" style="text-align:left;"><#=objRow.ItemName#></td> 
                <td class="GridViewLabItemStyle" id="td5" style="text-align:center;"><#=objRow.BatchNo #></td>
                <td class="GridViewLabItemStyle" id="td6" style="text-align:center;"><#=objRow.NewBatchNo #></td>
                <td class="GridViewLabItemStyle" id="td12" style="text-align:center;width:100px;" ><input type="text" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off"  id="txtUnitPrice" maxlength="9" onkeyup="onUnitCostChange(this,function(){});"    style="" value='<#=objRow.UnitPrice #>' /> </td>
                <td class="GridViewLabItemStyle" id="tdRetQty" style="text-align:center;"><#=objRow.RetQty #></td>
                <td class="GridViewLabItemStyle" id="td2" style="text-align:center;"><#=objRow.PurTaxPer #></td>
                <td class="GridViewLabItemStyle" id="td8" style="text-align:center;"><#=objRow.DiscountPer #></td>
                <td class="GridViewLabItemStyle" id="tdDiscountAmt" style="text-align:center;"><#=objRow.DiscountAmt #></td>
                <td class="GridViewLabItemStyle" id="tdNetAmount" style="text-align:center;">0</td>
                 <td class="GridViewLabItemStyle tdData" id="tdData1" style="display:none"><#=JSON.stringify(objRow) #></td>
                 <td class="GridViewLabItemStyle" id="td10" style="width:30px;text-align:center;">
                    <#if(objRow.Id!=''){#>
                        <img id="img2" src="../../Images/Delete.gif" style="cursor:pointer;" title="Click To Cancel " onclick="cancelRecord(this);"/>
                    <#}#>
                </td> 
            </tr>              
		    <#}        
		    #>  
                </tbody>                  
        </table>
    </script>
</asp:Content>
