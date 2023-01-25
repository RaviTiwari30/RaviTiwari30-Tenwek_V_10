<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="InternalStockTransfer.aspx.cs" Inherits="Design_Store_InternalStockTransfer" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(function () {
            $('#DateFrom').change(function () {
                ChkDate();
            });
            $('#DateTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#DateFrom').val() + '",DateTo:"' + $('#DateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#btnSearchIndent').attr('disabled', 'disabled');
                        $('#<%=btnSave.ClientID %>,#<%=btnSN.ClientID %>,#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnA.ClientID %>').attr('disabled', 'disabled');
                        $(".GridViewStyle").hide();


                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearchIndent').removeAttr('disabled');
                        $('#<%=btnSave.ClientID %>,#<%=btnA.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnRN.ClientID %>,#<%=btnSN.ClientID %>').removeAttr('disabled');
                    }
                }
            });

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
            if (($(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
                $(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val('');
                return false;
            }
            if (($(".GridViewStyle").find('tr').find('td').find(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val() != null)) {
                if (($(".GridViewStyle").find('tr').find('td').find(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
                    $(".GridViewStyle").find('tr').find('td').find(".GridViewStyle").find('tr').find('td').find(".ItDoseTextinputNum").val('');
                    return false;
                }
            }
            return true;
        }
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Issue Items To Department</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Requisition Criteria
            </div>
            <div style="text-align: center;">
                <div style="visibility: hidden">
                    <asp:RadioButton ID="rbtStorToDept" Text="To Department" AutoPostBack="True" Checked="true"
                        runat="server" CssClass="ItDoseRadiobutton" Width="150px" GroupName="a" />
                    <asp:RadioButton ID="rbtStorToPat" Text="To Patient" runat="server" CssClass="ItDoseRadiobutton"
                        Width="150px" GroupName="a" AutoPostBack="true" />
                </div>
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
                                <asp:RadioButtonList ID="rblStoreType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                                    <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                    From Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="DateFrom" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="todalcal" TargetControlID="DateFrom" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    To Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="DateTo" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="todate" TargetControlID="DateTo" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Centre From
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlFromCentre" ToolTip="Select Centre To" runat="server" TabIndex="2">
                                </asp:DropDownList>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Department From
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDepartment" runat="server" Width="">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Requisition No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIndentNoToSearch" runat="server" Width=""></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Custom, Numbers"
                                    ValidChars="." TargetControlID="txtIndentNoToSearch">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                        <div class="row">
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Sub-Group
                                </label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubGroup" runat="server" ClientIDMode="Static" ToolTip="Select SubGroup"></asp:DropDownList>
                        </div>
                    </div>
                        <div class="row" style="text-align: center;">
                            <asp:Button ID="btnSearchIndent" runat="server" Text="Search"
                                OnClick="btnSearchIndent_Click1" ClientIDMode="Static" CssClass="ItDoseButton" />
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td>
                            <asp:TextBox ID="txtIndentNo" runat="server" ReadOnly="true"
                                Visible="false"></asp:TextBox>
                        </td>
                    </tr>
                </table>

                <div class="content" style="text-align: center;">
                    <div id="colorindication" runat="server">
                        <table style="padding-left: 463px;">
                            <tr>
                                <td style="height: 22px">&nbsp;<asp:Button ID="btnSN" runat="server" Width="25px" Height="25px" BackColor="LightBlue"
                                    CssClass="ItDoseButton11 circle" OnClick="btnSN_Click"
                                    ToolTip="Click for Open Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px;">Pending
                                </td>
                                <td style="height: 22px">
                                    <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="green"
                                        CssClass="ItDoseButton11 circle" OnClick="btnRN_Click"
                                        ToolTip="Click for Close Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px;">Issued
                                </td>
                                <td style="height: 22px">&nbsp;<asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                    CssClass="ItDoseButton11 circle" OnClick="btnNA_Click"
                                    ToolTip="Click for Reject Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px;">Reject
                                </td>
                                <td style="height: 22px">&nbsp;<asp:Button ID="btnA" runat="server" Width="25px" Height="25px" BackColor="Yellow"
                                    CssClass="ItDoseButton11 circle" OnClick="btnA_Click"
                                    ToolTip="Click for Partial Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px; width: 145px;">&nbsp;Partial
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div style="text-align: center">
                <div style="height: 250px; overflow: auto;">
                    <asp:GridView ID="grdIndentSearch" runat="server" CssClass="GridViewStyle" OnRowCommand="gvGRN_RowCommand"
                        PageSize="8" AutoGenerateColumns="False" Width="100%" OnRowDataBound="grdIndentSearch_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="20px">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Requisition Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentDate" runat="server" Text='<%# Eval("dtEntry")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Requisition No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="From Centre">
                                <ItemTemplate>
                                    <asp:Label ID="lblFromCentre" runat="server" Text='<%# Eval("CentreFrom")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="From Department">
                                <ItemTemplate>
                                    <asp:Label ID="lblFromDepartment" runat="server" Text='<%# Eval("DeptFrom")%>'></asp:Label>
                                    <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Requested By">
                                <ItemTemplate>
                                    <asp:Label ID="lblRequestedBy" runat="server" Text='<%# Eval("EmpName")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Requisition Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentType" runat="server" Text='<%# Eval("Type")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View" HeaderStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                        ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("DeptFrom")+"#"+Eval("StoreID")+"#"+Eval("LedgerNumber")+"#"+Eval("CentreID")   %>'
                                        Visible='<%#Util.GetBoolean(Eval("VIEW")) %>' />
                                    <asp:Label ID="lblIsNewIndent" runat="server" Visible="false" Text='<%#Eval("NewIndent") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View&nbsp;Details">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbViews" runat="server" CausesValidation="false" CommandName="AViewDetail"
                                        ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                                    <asp:Label ID="lblStatus" runat="server" Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reprint">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbReprint" runat="server" CausesValidation="false" CommandName="AReprint"
                                        ImageUrl="~/Images/print.GIF" CommandArgument='<%# Eval("IndentNo") %>' />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="StatusNew" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:GridView>
                </div>
                <asp:Repeater ID="grdIndentDetails" OnItemCommand="grdIndentDetails_ItemCommand"
                    runat="server">
                    <HeaderTemplate>
                        <table class="GridViewStyle" style="border-collapse: collapse; width: 100%">
                            <tr style="text-align: center; background-color: #afeeee;">
                                <th class="GridViewHeaderStyle" scope="col">&nbsp;
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Item Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Requested Qty.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Issued Qty.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Rejected Qty.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Dept Available Qty.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Store Available Qty.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Pending Qty.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Narration
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Reject
                                </th>
                                <th class="GridViewHeaderStyle" scope="col">Reason
                                </th>
                                <th class="GridViewHeaderStyle" scope="col"></th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td class="GridViewItemStyle">
                                <asp:CheckBox ID="chkSelect" runat="server" />
                                <asp:Label ID="lblIndentID" runat="server" Text='<%# Eval("id") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo") %>' Visible="false"></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblRequestedQty" runat="server" Text='<%# Eval("ReqQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblIssuedQty" runat="server" Text='<%# Eval("ReceiveQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblRejectedQty" runat="server" Text='<%# Eval("RejectQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("DeptAvailQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblPendingQty" runat="server" Text='<%# Eval("PendingQty") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:Label ID="lblNarration" runat="server" Text='<%# Eval("Remarks") %>'></asp:Label>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:TextBox ID="txtReject" runat="server" CssClass="ItDoseTextinputNum" Width="50px"
                                    onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                                    MaxLength="8"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
                                    ValidChars="." TargetControlID="txtReject">
                                </cc1:FilteredTextBoxExtender>
                                <asp:TextBox ID="txtIssueingQty" runat="server" CssClass="ItDoseTextinputNum" Width="50px"
                                    Style="display: none;"></asp:TextBox>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:TextBox ID="txtReason" runat="server" CssClass="ItDoseTextinputNum" Width="100px"
                                    MaxLength="198"></asp:TextBox>
                            </td>
                            <td class="GridViewItemStyle">
                                <asp:ImageButton ID="imgMore" ImageUrl="~/Images/plus_in.gif" CommandArgument='<%# Eval("ItemID") %>'
                                    CommandName="showMore" runat="server" AlternateText="Show" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9">
                                <asp:Repeater ID="grdItem" OnItemCommand="grdItem_ItemCommand" runat="server">
                                    <HeaderTemplate>
                                        <table class="GridViewStyle" style="border-collapse: collapse; width: 100%">
                                            <tr style="text-align: center; background-color: #afeeee;">
                                                <th class="GridViewHeaderStyle" scope="col">Batch
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Expirable
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Expiry
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Unit Cost 
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Selling Price
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Avail. Qty.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Unit
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Issue Qty.
                                                </th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td class="GridViewItemStyle">
                                                <asp:Label ID="lblBatchNumber1" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle">
                                                <%#Eval("IsExpirable") %>
                                            </td>
                                            <td class="GridViewItemStyle">

                                                <%#Eval("MedExpiryDate")%>
                                             
                                            </td>
                                            <td class="GridViewItemStyle">
                                                <asp:Label ID="lblUnitPrice1" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle">
                                                <asp:Label ID="lblMRP1" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle">
                                                <asp:Label ID="lblAvailQty1" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle">
                                                <asp:Label ID="lblUnitType1" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle">
                                                <asp:TextBox ID="txtIssueQty1" runat="server" CssClass="ItDoseTextinputNum" Width="50px"
                                                    onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                                                    MaxLength="8"></asp:TextBox>
                                                <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtIssueQty1" Type="Double"
                                                    MinimumValue="0.001" MaximumValue='<%# Eval("AvailQty") %>' runat="server" ErrorMessage="*"></asp:RangeValidator>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                                    ValidChars="." TargetControlID="txtIssueQty1">
                                                </cc1:FilteredTextBoxExtender>
                                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                                    Visible="False"></asp:Label>

                                            </td>
                                        </tr>

                                        <tr style="width: 100%;">
                                            <td colspan="9">
                                                <asp:GridView ID="grdItemNew" class="grdn" runat="server" Visible="false" AutoGenerateColumns="False"
                                                    CssClass="GridViewStyle">
                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="ItemName" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblItemNamenew" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Batch" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblBatchNumbernew" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Expirable" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <%#Eval("IsExpirable")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Expiry" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">

                                                            <ItemTemplate>
                                                                <%#Eval("MedExpiryDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Unit Cost" Visible="false" HeaderStyle-Width="50px"
                                                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitPricenew" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblMRPnew" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Avail Qty" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblAvailQtynew" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Unit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitTypenew" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="IssueQty" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtIssueQtynew" runat="server" CssClass="ItDoseTextinputNum" Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
                                                                <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtIssueQtynew" Type="Double"
                                                                    MinimumValue="0.001" MaximumValue='<%# Eval("AvailQty") %>' runat="server" ErrorMessage="*"></asp:RangeValidator>
                                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                                                    ValidChars="." TargetControlID="txtIssueQtynew">
                                                                </cc1:FilteredTextBoxExtender>
                                                                <asp:Label ID="lblItemIDnew" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                                                <asp:Label ID="lblStockIDnew" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                                                                <asp:Label ID="lblSubCategorynew" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                                                    Visible="False"></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        <tr>
                                                            <td>
                                                                <label style="background-color: Red; color: #FFFFFF;">
                                                                    No Stock Available of Generic
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </EmptyDataTemplate>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                </asp:Repeater>
                                <asp:Repeater ID="grdItemGenric" OnItemCommand="grdItemGenric_ItemCommand" Visible="false"
                                    runat="server">
                                    <HeaderTemplate>
                                        <table class="GridViewStyle" style="border-collapse: collapse;">
                                            <tr style="text-align: center; background-color: #afeeee;">
                                                <th class="GridViewHeaderStyle" scope="col">Stock
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col" style="display: none">Search Generic
                                                </th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <label style="background-color: Red; color: #FFFFFF;">
                                                    No Stock Available
                                                </label>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblItemIDGenric" runat="server" Text='<%# Eval("ItemID") %>' Visible="false"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="imgMoregenric" ImageUrl="~/Images/plus_in.gif" CommandArgument='<%# Eval("ItemID") %>'
                                                    CommandName="showMore" runat="server" AlternateText="Show" Style="display: none" />
                                            </td>
                                        </tr>
                                        <tr style="width: 100%;">
                                            <td colspan="9" style="text-align: center;">
                                                <asp:GridView ID="grdItemNewgenric" runat="server" Visible="false" AutoGenerateColumns="False"
                                                    CssClass="GridViewStyle" Style="width: 100%;">
                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="ItemName" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblItemNamenewgenric" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Batch" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblBatchNumbernewgenric" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Expirable" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <%#Eval("IsExpirable")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Expiry" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <%#Eval("MedExpiryDate")%>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="UnitPrice" Visible="false" HeaderStyle-Width="50px"
                                                            ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitPricenewgenric" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblMRPnewgenric" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Avail Qty" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblAvailQtynewgenric" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Unit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUnitTypenewgenric" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="IssueQty" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                                            HeaderStyle-CssClass="GridViewHeaderStyle">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtIssueQtynewgenric" runat="server" CssClass="ItDoseTextinputNum"
                                                                    Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
                                                                <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtIssueQtynewgenric"
                                                                    Type="Double" MinimumValue="0.001" MaximumValue='<%# Eval("AvailQty") %>' runat="server"
                                                                    ErrorMessage="*"></asp:RangeValidator>
                                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                                                    ValidChars="." TargetControlID="txtIssueQtynewgenric">
                                                                </cc1:FilteredTextBoxExtender>
                                                                <asp:Label ID="lblItemIDnewgenric" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                                                <asp:Label ID="lblStockIDnewgenric" runat="server" Text='<%# Eval("StockID") %>'
                                                                    Visible="False"></asp:Label>
                                                                <asp:Label ID="lblSubCategorynewgenric" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                                                    Visible="False"></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <EmptyDataTemplate>
                                                        <tr>
                                                            <td>
                                                                <label style="background-color: Red; color: #FFFFFF;">
                                                                    No Stock Available of Generic
                                                                </label>
                                                            </td>
                                                        </tr>
                                                    </EmptyDataTemplate>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:CheckBox ID="chkPrint" runat="server" Text="Print Requisition" Checked="true" />
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click"
                    OnClientClick="RestrictDoubleEntry(this);" />
            </div>
        </div>
    </div>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 800px; height: 350px;"
        ScrollBars="Auto">
        <div>
            <table>
                <tr>
                    <td style="text-align: center;">
                        <label>
                            <strong>Requisition Detail:</strong></label>
                    </td>
                </tr>
                <tr style="width: 100%;">
                    <td style="text-align: center; vertical-align: top">
                        <asp:GridView ID="grdIndentdtl" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            Width="740px" OnRowDataBound="grdIndentdtl_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Unit Type">
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblitemIndentNo" runat="server" Text='<%#Util.GetString(Eval("IndentNo")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Item Name">
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemname" runat="server" Text='<%#Util.GetString(Eval("ItemName")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Unit Type">
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemUnitType" runat="server" Text='<%#Util.GetString(Eval("UnitType")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Requested Qty.">
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemQty" runat="server" Text='<%#Util.GetString(Eval("ReqQty")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField HeaderText="Issue Qty." DataField="SoldUnits" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-Width="90px" />
                                <asp:BoundField HeaderText="Received Qty." DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField HeaderText="Pending Qty." DataField="PendingQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField HeaderText="Rejected Qty." DataField="RejectQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Date" DataField="DATE" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-Width="90px" />


                                <asp:TemplateField Visible="false">
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>

                                        <asp:Label ID="lblname" runat="server" Text=' <%#Eval("Itemname") %>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblReqqty" runat="server" Text=' <%#Eval("Reqqty") %>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblUnittype" runat="server" Text=' <%#Eval("Unittype") %>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblIndentno" runat="server" Text=' <%#Eval("IndentNo") %>'
                                            Visible="false"></asp:Label>


                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="StatusNew" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatusNew1" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <asp:Button ID="btnCancel1" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="Panel2"
        TargetControlID="btn1" X="80" Y="100">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
    </div>
</asp:Content>
