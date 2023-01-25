<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="POAnalysis.aspx.cs" Inherits="Design_Purchase_POAnalysis" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });

            $('#ucToDate').change(function () {
                ChkDate();
            });

        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        return;

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function hidelabel() {
            $('#<%=lblMsg.ClientID %>').text('');
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm1" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Purchase Order Analysis</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPONo" runat="server" MaxLength="20"
                                Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Supplier Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="lstVendor" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbRequestType" runat="server" Width="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbStatus" runat="server" Width="">
                                <asp:ListItem Value="5">-------------</asp:ListItem>
                                <asp:ListItem Value="0">Pending</asp:ListItem>
                                <asp:ListItem Value="1">Reject</asp:ListItem>
                                <asp:ListItem Value="2">Open</asp:ListItem>
                                <asp:ListItem Value="3">Close</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"
                                Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucFromDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"
                                Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ucToDate">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3"></div>
                    <div class="col-md-8">
                        <asp:RadioButtonList ID="chkStore" runat="server" RepeatDirection="Horizontal">
                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-5">
                        <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Result
            </div>
            <div class="" style="text-align: left;">
                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="pnlgv" runat="server" Height="500px" ScrollBars="Vertical">
                            <asp:Repeater ID="rpVendor" runat="server" OnItemCommand="rpVendor_ItemCommand">
                                <HeaderTemplate>
                                    <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;width:100%">
                                        <tr style="text-align: center; background-color: #afeeee;">
                                            <th class="GridViewHeaderStyle" scope="col">&nbsp;
                                            </th>
                                            <th class="GridViewHeaderStyle" scope="col">S.No.
                                            </th>
                                            <th class="GridViewHeaderStyle" scope="col">Supplier
                                            </th>
                                            <th class="GridViewHeaderStyle" scope="col">Total Orders
                                            </th>
                                            <th class="GridViewHeaderStyle" scope="col">Open Orders
                                            </th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr style="text-align: center; background-color: #afeeee;">
                                        <td class="GridViewItemStyle" style="width: 30px; text-align: left;">
                                            <asp:ImageButton ID="imbVendor" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                CausesValidation="false" CommandName="PVendor" CommandArgument='<%# Eval("VendorID") %>' />
                                        </td>
                                        <td class="GridViewItemStyle" style="width: 30px;">
                                            <%# Container.ItemIndex+1 %>
                                        </td>
                                        <td class="GridViewItemStyle" style="width: 650px; text-align: left;">
                                            <b>
                                                <%# Eval("VendorName")%>
                                            </b>
                                        </td>
                                        <td class="GridViewItemStyle" style="width: 100px;">
                                            <%# Eval("TotalOrder")%>
                                        </td>
                                        <td class="GridViewItemStyle" style="width: 100px;">
                                            <%# Eval("OpenOrder")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" style="padding-left: 15px;">
                                            <asp:Repeater ID="rpOrder" runat="server">
                                                <HeaderTemplate>
                                                    <table cellspacing="0" style="width:100%">
                                                        <tr style="text-align: center; color: #387C44; background-color: #fafad2;">
                                                            <th scope="col" style="width:30px">&nbsp;
                                                            </th>
                                                            <th scope="col">Order No.
                                                            </th>
                                                            <th scope="col">Subject
                                                            </th>
                                                            <th scope="col">Gross Amt.
                                                            </th>
                                                            <th scope="col">Type
                                                            </th>
                                                            <th scope="col">Status
                                                            </th>
                                                            <th scope="col">Order Date
                                                            </th>
                                                            <th scope="col">Valid Date
                                                            </th>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr style="text-align: center; background-color: #fafad2;">
                                                        <td>
                                                            <asp:Label ID="lblOrderNo" runat="server" Text='<%# Eval("PurchaseOrderNo") %>' Visible="false" />
                                                            <asp:ImageButton ID="imbOrder" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                                CausesValidation="false" OnClick="BindItemsForPO" />
                                                        </td>
                                                        <td style="width: 150px;">
                                                            <%# Eval("PurchaseOrderNo")%>
                                                        </td>
                                                        <td style="width: 300px; text-align: left;">
                                                            <%# Eval("Subject")%>
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <%# Eval("GrossTotal")%>
                                                        </td>
                                                        <td style="width: 75px;">
                                                            <%# Eval("Type")%>
                                                        </td>
                                                        <td style="width: 75px;">
                                                            <%# Eval("PoStatus")%>
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <%# Eval("PoDate")%>
                                                        </td>
                                                        <td style="width: 100px;">
                                                            <%# Eval("VDate")%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="8" style="padding-left: 25px;">
                                                            <asp:Repeater ID="rpItems" runat="server" OnItemDataBound="rpItems_ItemDataBound">
                                                                <HeaderTemplate>
                                                                    <table cellspacing="0" style="width:100%">
                                                                        <tr style="text-align: center; color: #ee00ee; background-color: #f0fff0; width: 100%;">
                                                                            <th scope="col"  style="width:30px">&nbsp;
                                                                            </th>
                                                                            <th scope="col" style="text-align: left;">Item Description
                                                                            </th>
                                                                            <th scope="col">Free
                                                                            </th>
                                                                            <th scope="col">Ord.Qty.
                                                                            </th>
                                                                            <th scope="col">Price
                                                                            </th>
                                                                            <th scope="col">Rec.Qty.
                                                                            </th>
                                                                            <th scope="col">Request
                                                                            </th>
                                                                            <th scope="col">Rem.Qty.
                                                                            </th> <th scope="col">Reject Reason
                                                                            </th>
                                                                        </tr>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                 <%--   <tr id="tmp" style="text-align: center; background-color: <%# ((Util.GetDecimal(Eval("ApprovedQty")) - Util.GetDecimal(Eval("RecievedQty"))) > 0) ? "#7fff00" : "#f0fff0" %>; width: 100%;">--%>
                                                                 <tr id="tmp" style="text-align: center; width: 100%;" runat="server">
                                                                    <td>
                                                                            <asp:Label ID="lblRequestItem" runat="server" Text='<%# Eval("PurchaseOrderDetailID") %>'
                                                                                Visible="false" />
                                                                            <asp:ImageButton ID="imbReceive" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                                                CausesValidation="false" OnClick="BindGRNForItems" />
                                                                        </td>
                                                                        <td style="width: 400px; text-align: left;">
                                                                            <%# Eval("Item")%>
                                                                        </td>
                                                                        <td style="width: 50px;">
                                                                            <%# Eval("Free")%>
                                                                        </td>
                                                                        <td style="width: 75px;">
                                                                            <%# Eval("ApprovedQty")%>
                                                                        </td>
                                                                        <td style="width: 125px;">
                                                                            <%# Eval("BuyPrice")%>
                                                                        </td>
                                                                        <td style="width: 75px;">
                                                                            <%# Eval("RecievedQty")%>
                                                                        </td>
                                                                        <td style="width: 150px;">
                                                                            <%# Eval("PRNumber")%>
                                                                        </td>
                                                                        <td style="width: 75px;">
                                                                            <%# Util.GetDecimal(Eval("ApprovedQty")) - Util.GetDecimal(Eval("RecievedQty"))%>
                                                                        </td>
                                                                        <td style="width: 150px;">
                                                                            <%# Eval("CancelReason")%>
                                                                        </td>
                                                                              <td>
                                                                           <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("STATUS") %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="7" style="padding-left: 40px;">
                                                                            <asp:Repeater ID="rpReceive" runat="server">
                                                                                <HeaderTemplate>
                                                                                    <table cellspacing="0" style="width:100%">
                                                                                        <tr style="text-align: center; color: maroon; background-color: #fff0f5; width: 100%;">
                                                                                            <th scope="col">GRN No.
                                                                                            </th>
                                                                                            <th scope="col">Date
                                                                                            </th>
                                                                                            <th scope="col">Batch No.
                                                                                            </th>
                                                                                            <th scope="col">Purchase Price
                                                                                            </th>
                                                                                            <th scope="col">Selling Price
                                                                                            </th>
                                                                                            <th scope="col">Rec. Qty.
                                                                                            </th>
                                                                                        </tr>
                                                                                </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <tr style="text-align: center; background-color: #fff0f5; width: 100%;">
                                                                                        <td style="width: 250px;">
                                                                                            <%# Eval("LedgerTransactionNo")%>
                                                                                        </td>
                                                                                        <td style="width: 150px;">
                                                                                            <%# Eval("RDate")%>
                                                                                        </td>
                                                                                        <td style="width: 250px;">
                                                                                            <%# Eval("BatchNumber")%>
                                                                                        </td>
                                                                                          <td style="width: 150px;">
                                                                                            <%# Eval("unitprice")%>
                                                                                        </td>
                                                                                        <td style="width: 150px;">
                                                                                            <%# Eval("MRP")%>
                                                                                        </td>
                                                                                        <td style="width: 150px;">
                                                                                            <%# Eval("Qty")%>
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
                                                        </td>
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
                        </asp:Panel>
                    </ContentTemplate>
                    <Triggers>
                        <Ajax:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                    </Triggers>
                </Ajax:UpdatePanel>
            </div>
        </div>
    </div>
    <div>
    </div>
</asp:Content>
