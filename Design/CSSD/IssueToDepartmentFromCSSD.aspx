<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IssueToDepartmentFromCssd.aspx.cs" Inherits="Design_CSSD_IssueToDepartmentFromCssd"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" language="javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function disableButton() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        function validateReject() {
            if (typeof (Page_Validators) == "undefined") return;
            var Reason = document.getElementById("<%=reqReason.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopupReject.ClientID%>");
            ValidatorValidate(Reason);
            if (!Reason.isvalid) {
                LblName.innerText = Reason.errormessage;
                return false;
            }
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpeRejection")) {
                    $find("mpeRejection").hide();
                    $("#<%=txtCancelReason.ClientID %>").val('');
                }
            }
        }
        function clearRejection() {
            $("#<%=txtCancelReason.ClientID %>").val('');
        }
        $(document).ready(function () {
            var MaxLength = 250;
            $("#<% =txtCancelReason.ClientID %> %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtCancelReason.ClientID%>').bind("keypress", function (e) {
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
        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                ///__doPostBack('ListBox1','')
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
        function MoveUpAndDownValue(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
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
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Department Issue (Medical Items)</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Issue Items
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" ToolTip="Select Department" TabIndex="1" runat="server" CssClass="requiredField">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Items
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                ID="txtSearch" AutoCompleteType="Disabled" onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                runat="server" CssClass="ItDoseTextinputText" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:ListBox ID="ListBox1" TabIndex="4" runat="server" CssClass="ItDoseDropdownbox"
                                Width="520px" Height="100px"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtTransferQty" runat="server" AutoCompleteType="Disabled" MaxLength="3"
                                Width="50px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterType="Numbers" TargetControlID="txtTransferQty">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                                ValidationGroup="r" />
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Item Details&nbsp; <span style="color: #FF99FF">(Set Items)</span> <span style="color: #FF9999">(Non Set Items)</span>
                </div>
                <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Width="100%"
                    TabIndex="8" OnRowDataBound="grdItem_RowDataBound" OnRowCommand="grdItem_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="Server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
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
                        <asp:TemplateField HeaderText="Expiry Date" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="From Dept.">
                            <ItemTemplate>
                                <%#Eval("FromDept")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch Name">
                            <ItemTemplate>
                                <%#Eval("BatchName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Boiler Name">
                            <ItemTemplate>
                                <%#Eval("BoilerName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
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
                        <asp:TemplateField HeaderText="Avail Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Issue Qty.">
                            <ItemTemplate>
                                <asp:TextBox ID="txtIssueQty" runat="server" CssClass="ItDoseTextinputNum" MaxLength="3" Width="50px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers"
                                    TargetControlID="txtIssueQty">
                                </cc1:FilteredTextBoxExtender>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblTax" runat="server" Text='<%# Eval("Tax") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMedExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'
                                    Visible="false"></asp:Label>
                                <asp:Label ID="lblIsSet" runat="server" Text='<%# Eval("IsSet") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblTnxID" runat="server" Text='<%# Eval("TnxID") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSetStockID" runat="server" Text='<%# Eval("SetStockID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblCtStockid" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblId" runat="server" Text='<%# Eval("ID") %>' Visible="False"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cancel Sterilize">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID")+"#"+Eval("StockID")+"#"+Eval("ItemID")+"#"+Eval("IsSet")+"#"+Eval("SetStockID") %>'
                                    CommandName="imbRemove" ImageUrl="../../Images/Delete.gif" ToolTip="Click To Remove" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="55px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <div style="text-align: center;">
                    <asp:Button ID="btnAddItem" runat="server" CssClass="ItDoseButton" OnClick="btnAddItem_Click"
                        TabIndex="10" Text="Add Item" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Item Details
                </div>
                <div style="text-align: center; height: 150px; overflow: scroll;">
                    <asp:GridView ID="grdItemDetails" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Width="100%"
                        OnRowCommand="grdItemDetails_RowCommand" TabIndex="11" OnRowDataBound="grdItemDetails_RowDataBound">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name">
                                <ItemTemplate>
                                    <%# Eval("ItemName") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="StockID">
                                <ItemTemplate>
                                    <%# Eval("StockID") %>
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
                            <asp:TemplateField HeaderText="Qty.">
                                <ItemTemplate>
                                    <%# Eval("IssueQty")%>
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
                            <asp:TemplateField HeaderText="Is Set">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsSetNew" runat="server" Text='<%# Eval("IsSet") %>' Visible="true"></asp:Label>
                                    <asp:Label ID="lblSetStockIDNew" runat="server" Text='<%# Eval("SetStockID") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lbl" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
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
                </div>
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Requisition No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIndent" MaxLength="10" runat="server" ></asp:TextBox>
                        </div>
                         <div class="col-md-10">
                        <asp:Button ID="btnSave" OnClientClick="disableButton()" runat="server" Text="Save" CssClass="ItDoseButton"
                            OnClick="btnSave_Click" ValidationGroup="a" />
                             </div>
                    </div>
                </div>
		<div class="col-md-1"></div>
            </div>
            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
        </div>
        <asp:Panel ID="pnlRejection" runat="server" CssClass="pnlItemsFilter" Style="display: none;"
            Width="480px" Height="170px">
            <div class="Purchaseheader" id="Div1" runat="server">
                Cancel Sterilize &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; Press esc to close
            </div>
            <table>
                <tr>
                    <td align="center" colspan="2">
                        <asp:Label ID="lblmsgpopupReject" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td valign="top">Reason :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtCancelReason" runat="server" Width="370px" ValidationGroup="Reject"
                            MaxLength="50" ToolTip="Enter Reject Reason" TabIndex="1" TextMode="MultiLine"
                            Height="80px" />
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <br />
                        <asp:RequiredFieldValidator ID="reqReason" runat="server" ControlToValidate="txtCancelReason"
                            Display="None" ErrorMessage="Please Enter Reason" SetFocusOnError="True" ValidationGroup="Reject"></asp:RequiredFieldValidator>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <asp:Button ID="btnOKRejection" runat="server" Text="Reject" CssClass="ItDoseButton"
                            ValidationGroup="Reject" OnClientClick="return validateReject();" OnClick="btnOKRejection_Click"
                            TabIndex="2" ToolTip="Click to Reject" />
                        &nbsp; &nbsp;&nbsp;
                    <asp:Button ID="btnCancelRejection" runat="server" Text="Cancel" CausesValidation="false"
                        CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Cancel" />
                        <asp:Label ID="lblId" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblStockid" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblItemid" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblIsset" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblSetStockID" runat="server" Visible="false"></asp:Label>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeRejection" runat="server" CancelControlID="btnCancelRejection"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlRejection" BehaviorID="mpeRejection" PopupDragHandleControlID="dragHandle"
            OnCancelScript="clearRejection();" />
    </div>
</asp:Content>
