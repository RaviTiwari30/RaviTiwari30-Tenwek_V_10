<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="PRAnalysis.aspx.cs" Inherits="Design_Purchase_PRAnalysis" MaintainScrollPositionOnPostback="true" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Purchase Request Analysis</b>
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
                                Request No. 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPRNo" runat="server" CssClass="ItDoseTextinputText"
                                MaxLength="20" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="lstStore" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbRequestType" runat="server" />
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
                                CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ucFromDate">
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
                                CssClass="ItDoseTextinputText"></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server"
                                Format="dd-MMM-yyyy" TargetControlID="ucToDate">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-22">
                    <div class="row" style="text-align: center;">
                         <div class="col-md-4">
                            <asp:Button ID="btnLabel4" runat="server" Width="25px" Height="25px" BackColor="LightBlue"
                                CssClass="ItDoseButton11 circle" />
                            <asp:Label ID="Label4" runat="server" Text="Pending"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="Button1" runat="server" Width="25px" Height="25px" BackColor="YellowGreen"
                                 CssClass="ItDoseButton11 circle" />
                            <asp:Label ID="Label1" runat="server" Text="Close"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="Button2" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                CssClass="ItDoseButton11 circle" />
                            <asp:Label
                                ID="Label2" runat="server" Text="Reject"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="Button3" runat="server" Width="25px" Height="25px" BackColor="Yellow"
                                 CssClass="ItDoseButton11 circle" />
                            <asp:Label
                                ID="Label3" runat="server" Text="Open"></asp:Label>
                        </div>
                        <div class="col-md-4">
                        <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                            OnClick="btnSearch_Click" /></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Result
            </div>
            <div class="">
                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="pnlgv" runat="server" Height="500px">
                            <asp:Repeater ID="rpStore" runat="server" OnItemCommand="rpStore_ItemCommand">
                                <HeaderTemplate>
                                    <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;width:100%">
                                        <tr style="text-align: center; background-color: #afeeee;">
                                            <th class="GridViewHeaderStyle" scope="col">&nbsp;</th>
                                            <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">Store</th>
                                            <th class="GridViewHeaderStyle" scope="col">Total Request</th>
                                            <th class="GridViewHeaderStyle" scope="col">Open Request</th>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr style="text-align: center; background-color: #afeeee;">
                                        <td class="GridViewItemStyle" style="width: 30px; text-align: left;">
                                            <asp:ImageButton ID="imbStore" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png" CausesValidation="false" CommandName="PStore" CommandArgument='<%# Eval("StoreID") %>' />
                                        </td>
                                        <td class="GridViewItemStyle" style="width: 30px;"><%# Container.ItemIndex+1 %></td>
                                        <td class="GridViewItemStyle" style="width: 650px; text-align: left;"><b><%# Eval("LedgerName")%></b></td>
                                        <td class="GridViewItemStyle" style="width: 100px;"><%# Eval("TotalRequest")%></td>
                                        <td class="GridViewItemStyle" style="width: 100px;"><%# Eval("OpenRequest")%></td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" style="padding-left: 15px;">
                                            <asp:Repeater ID="rpRequest" runat="server">
                                                <HeaderTemplate>
                                                    <table cellspacing="0" style="width:100%">
                                                        <tr style="text-align: center; color: #387C44; background-color: #fafad2;">
                                                            <th scope="col" style="width:30px">&nbsp;</th>
                                                            <th scope="col">Request No.</th>
                                                            <th scope="col">Narration</th>
                                                            <th scope="col">Type</th>
                                                            <th scope="col">Status</th>
                                                            <th scope="col">Date</th>
                                                            <th scope="col">Raised By</th>
                                                        </tr>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr style="text-align: center; background-color: #fafad2;">
                                                        <td>
                                                            <asp:Label ID="lblRequestNo" runat="server" Text='<%# Eval("PurchaseRequestNo") %>' Visible="false" />
                                                            <asp:ImageButton ID="imbRequest" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png" CausesValidation="false" OnClick="BindItemsForRequest" />
                                                        </td>
                                                        <td style="width: 150px;"><%# Eval("PurchaseRequestNo")%></td>
                                                        <td style="width: 350px; text-align: left;"><%# Eval("Subject")%></td>
                                                        <td style="width: 100px;"><%# Eval("Type")%></td>
                                                        <td style="width: 100px;"><%# Eval("PRStatus")%></td>
                                                        <td style="width: 125px;"><%# Eval("RequestDate")%></td>
                                                        <td style="width: 150px;"><%# Eval("Name")%></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="8" style="padding-left: 25px;">
                                                            <asp:Repeater ID="rpItems" runat="server" OnItemDataBound="rpItems_ItemDataBound">
                                                                <HeaderTemplate>
                                                                    <table cellspacing="0">
                                                                        <tr style="text-align: center; color: #ee00ee; width: 100%;">
                                                                            <th scope="col" style="width:30px">&nbsp;</th>
                                                                            <th scope="col" style="text-align: left;">Item Description</th>
                                                                            <th scope="col">Purpose</th>
                                                                            <th scope="col">InHand Qty.</th>
                                                                            <th scope="col">App.Qty.</th>
                                                                            <th scope="col">Order Qty.</th>
                                                                            <th scope="col">Rate</th>
                                                                            <th scope="col">Remn.Qty.</th>
                                                                        </tr>
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <tr id="tmp" style="text-align: center; width: 100%;" runat="server">
                                                                        <td>
                                                                            <asp:Label ID="lblRequestItem" runat="server" Text='<%# Eval("PRID") %>' Visible="false" />
                                                                            <asp:ImageButton ID="imbOrder" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png" CausesValidation="false" OnClick="BindOrderForItems" />
                                                                        </td>
                                                                        <td style="width: 400px; text-align: left;"><%# Eval("Item")%></td>
                                                                        <td style="width: 50px;"><%# Eval("Purpose")%></td>
                                                                        <td style="width: 100px;"><%# Eval("InHandQty")%></td>
                                                                        <td style="width: 100px;"><%# Eval("ApprovedQty")%></td>
                                                                        <td style="width: 100px;"><%# Eval("OrderedQty")%></td>
                                                                        <td style="width: 150px;"><%# Eval("ApproxRate")%></td>
                                                                        <td style="width: 100px;"><%# Util.GetDecimal(Eval("ApprovedQty")) - Util.GetDecimal(Eval("OrderedQty"))%></td>
                                                                        <td>
                                                                            <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("STATUS") %>'></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="8" style="padding-left: 40px;">
                                                                            <asp:Repeater ID="rpOrder" runat="server">
                                                                                <HeaderTemplate>
                                                                                    <table cellspacing="0">
                                                                                        <tr style="text-align: center; color: maroon; background-color: #fff0f5; width: 100%;">
                                                                                            <th scope="col" style="text-align: left;">Order No.</th>
                                                                                            <th scope="col">Supplier</th>
                                                                                            <th scope="col">Date</th>
                                                                                            <th scope="col">Order Qty.</th>
                                                                                        </tr>
                                                                                </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <tr style="text-align: center; background-color: #fff0f5; width: 100%;">
                                                                                        <td style="width: 150px; text-align: left;"><%# Eval("PONumber")%></td>
                                                                                        <td style="width: 450px;"><%# Eval("VendorName")%></td>
                                                                                        <td style="width: 150px;"><%# Eval("PODate")%></td>
                                                                                        <td style="width: 100px;"><%# Eval("OrderedQty")%></td>
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
                        </asp:Panel>
                    </ContentTemplate>
                    <Triggers>
                        <Ajax:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
                    </Triggers>
                </Ajax:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
