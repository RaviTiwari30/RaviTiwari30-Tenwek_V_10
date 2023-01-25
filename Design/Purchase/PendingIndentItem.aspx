<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PendingIndentItem.aspx.cs" Inherits="Design_Purchase_PendingIndentItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#FromDate').change(function () {
                ChkDate();
            });
            $('#ToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FromDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
        $(document).ready(function () {
            $('#txtPODate').change(function () {
                ChkDate1();
            });
            $('#txtValidDate').change(function () {
                ChkDate1();
            });
            $('#txtDeliveryDate').change(function () {
                ChkDate2();
            });
        });
        function ChkDate1() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtPODate').val() + '",DateTo:"' + $('#txtValidDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#<%=lblMsg.ClientID%>").text('PO date can not be Greater than Valid date!');
                        $("#<%=lblMsg.ClientID%>").focus();
                        $("#<%=btnSave.ClientID%>").attr('disabled', 'disabled');
                    }
                    else {
                        $("#<%=lblMsg.ClientID%>").text('');
                        $("#<%=btnSave.ClientID%>").removeAttr('disabled');
                        ChkDate2();
                    }
                }
            });

        }
        function ChkDate2() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtPODate').val() + '",DateTo:"' + $('#txtDeliveryDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#<%=lblMsg.ClientID%>").text('PO date can not be Greater than Delivery date!');
                        $("#<%=lblMsg.ClientID%>").focus();
                        $("#<%=btnSave.ClientID%>").attr('disabled', 'disabled');
                    }
                    else {
                        $("#<%=lblMsg.ClientID%>").text('');
                        $("#<%=btnSave.ClientID%>").removeAttr('disabled');
                    }
                }
            });
        }
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Pending Requisition </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" meta:resourcekey="lblMsgResource1" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Items
            </div>

            <table style="width: 100%; border-collapse: collapse">
                <tr >
                    <td style="width: 123px; text-align: right;">Store Type :&nbsp;</td>
                    <td style="text-align: left">
                                <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="btnSearch_Click" AutoPostBack="true" >
                                    <asp:ListItem Value="STO00001" Selected="True">Medical Store</asp:ListItem>
                                    <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                                </asp:RadioButtonList>
                    </td>
                    <td style="width: 123px; text-align: right;">&nbsp;</td>
                    <td style="width: 230px">&nbsp;</td>
                </tr>
                <tr style="display: none;">
                    <td style="width: 123px; text-align: right;">Select Vendor :&nbsp;</td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlVendor" runat="server" Width="200px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 123px; text-align: right;"></td>
                    <td style="width: 230px"></td>
                </tr>
                <tr>
                    <td style="width: 123px; text-align: right;">Department :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlDepartment" runat="server" Width="200px">
                        </asp:DropDownList></td>
                    <td style="width: 123px; text-align: right;"></td>
                    <td style="width: 35%;"></td>
                </tr>
                <tr>
                    <td style="width: 123px; text-align: right;">From Date :&nbsp;</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="FromDate" runat="server" Width="90px" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="FromDate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 123px; text-align: right;">To Date :&nbsp;</td>
                    <td style="width: 35%; height: 20px; text-align: left;">
                        <asp:TextBox ID="ToDate" runat="server" Width="90px" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" TargetControlID="ToDate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
            </table>
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Pending Requisition
            </div>
            <div>
                <div class="content">
                    <asp:Panel ID="Panel1" runat="server" ScrollBars="vertical" Height="270px" Width="105%">
                        <asp:GridView ID="GrdIndent" AutoGenerateColumns="false" runat="server" CssClass="GridViewStyle" OnRowDataBound="GrdIndent_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="15px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition No." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Dept. From" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("DeptFrom")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("ItemName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition Qty." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("ReqQty")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Dept. Qty." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("AvailQty")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Store Qty." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("GenStock")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Vendor" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("VendorName")%>
                                        <asp:Label ID="lblVendorID" runat="server" Text='<%#Eval("VendorID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("Rate")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition Date" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("IndentDate")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Requisition RaiseBy" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("IndentRaiseBy")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PO Qty." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPOQty" runat="server" Width="50px"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-Width="40px" HeaderText="Check" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemStyle VerticalAlign="Middle" />
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkPO" runat="server" Text="" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Purchase Order Information
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="display: none">
                    <td>Freight :
                    </td>
                    <td>
                        <asp:TextBox ID="txtFreight" runat="server" Width="75px" CssClass="ItDoseTextinputNum" />
                    </td>
                    <td>R/o Amt.(+ -)&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtRoundOff" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                            Width="75px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                            TargetControlID="txtRoundOff" FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>Scheme&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtScheme" runat="server" CssClass="ItDoseTextinputNum" Text="0" Width="75px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                            TargetControlID="txtScheme" FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>Bill Amount&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtInvoiceAmount" runat="server" Width="75px" CssClass="ItDoseTextinputNum"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtInvoiceAmount" FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                        <asp:TextBox ID="lbl" runat="server" meta:resourcekey="lblResource1"></asp:TextBox>
                    </td>
                </tr>
                <tr style="display: none">
                    <td>Excise On Bill&nbsp :
                    </td>
                    <td>
                        <asp:TextBox ID="txtExciseOnBill" Width="75px" Text="0" CssClass="ItDoseTextinputNum" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server"
                            TargetControlID="txtExciseOnBill" FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        PO Date :
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtPODate" runat="server" Width="80px" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtPODate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right">
                       Valid Date:
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtValidDate" runat="server" Width="80px" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtValidDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right">
                       Type:
                    </td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlPOType" runat="server" OnSelectedIndexChanged="ddlPOType_SelectedIndexChanged" />

                    </td>
                    <td style="text-align: right">Delivery Date :
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtDeliveryDate" runat="server" Width="80px" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender3" TargetControlID="txtDeliveryDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
            </table>

            <div>
                <table>
                    <tr>
                        <td style="width: 93px; text-align: right">Remarks :</td>
                        <td></td>
                        <td>
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="ItDoseTextinputText" TextMode="MultiLine" Width="300px" />
                            <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText" ValidationGroup="Save" Width="300px" style="display:none;" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" FilterType="Custom, Numbers" TargetControlID="txtFreight" ValidChars="."></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <asp:Label ID="lblchktxt" runat="server" Text="Print:"></asp:Label>
            <asp:CheckBox ID="chkPrintImg" Checked="true" runat="server" />
            <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="RestrictDoubleEntry(this);" />
        </div>
    </div>
</asp:Content>
