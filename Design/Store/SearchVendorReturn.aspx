<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchVendorReturn.aspx.cs" Inherits="Design_Finance_SearchVendorReturn" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
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
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch,#<%=btnReport.ClientID %>').prop('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch,#<%=btnReport.ClientID %>').removeProp('disabled');
                    }
                }
            });

        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Suppiler Return Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Document No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIndentNo" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Entry No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEntryNo" runat="server" Width="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseTextinputText" Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseTextinputText" Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Suppiler
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="lstVendor" runat="server" Width="" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div>
                <div style="text-align: center;">
                    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" ClientIDMode="Static" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
     <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnReport_Click" />
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div style="text-align: center;">
                <asp:Panel ID="pnlgv" runat="server" Height="400px" Width="100%" ScrollBars="Vertical">
                    <asp:GridView ID="grdVendorReturn" runat="server" AutoGenerateColumns="False" Width="100%" CssClass="GridViewStyle" OnRowCommand="grdVendorReturn_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="LedgerName" HeaderText="Suppiler Name" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="300px" HorizontalAlign="center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ItemName" HeaderText="Item" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="250px" HorizontalAlign="center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Qty" HeaderText="Return Qty" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="UnitPrice" HeaderText="Net Cost" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="75px" />
                            </asp:BoundField>
                             <asp:BoundField DataField="TotalAmountCoset" HeaderText="Total Amount Cost" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="75px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="IndentNo" HeaderText="Doc.No" Visible="false" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="50px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="salesno" HeaderText="Return No" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemStyle Width="75px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Print" HeaderStyle-CssClass="GridViewHeaderStyle"
                            ItemStyle-CssClass="GridViewLabItemStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPrint" runat="server" 
                                    CausesValidation="false" CommandName="Print" ImageUrl="~/Images/print.gif"
                                    CommandArgument='<%#Eval("salesno")%> ' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
