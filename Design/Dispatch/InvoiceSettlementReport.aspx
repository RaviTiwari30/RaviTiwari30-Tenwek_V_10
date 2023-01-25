<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="InvoiceSettlementReport.aspx.cs" Inherits="Design_Dispatch_InvoiceSettlementReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });

        }

    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Invoice Settlement Report</b>
            <br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                From Settlement Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFromDate_CalendarExtender" runat="server" TargetControlID="txtFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Settlement Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtToDate_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Invoice No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtInvoiceNo" ClientIDMode="Static" runat="server" MaxLength="30"></asp:TextBox>
                        </div>
                        <div class="col-md-1"></div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" ClientIDMode="Static" runat="server" CssClass="save margin-top-on-btn" Text="Search" OnClick="btnReport_Click" />

             <asp:CheckBox runat="server" ID="chkExtractToExcel" Text="Export To Excel Also." CssClass="pull-right" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <asp:GridView ID="grdSearch" runat="server" Width="100%"  AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdSearch_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Invoice No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblInvoiceNo" runat="server" Text='<%# Bind("InvoiceNo") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>


                               <asp:TemplateField HeaderText="Invoice Amount">
                                <ItemTemplate>
                                    <asp:Label ID="lblInvoiceAmount" runat="server" Text='<%# Bind("InvoiceAmount") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>






                            <asp:TemplateField HeaderText="Invoice Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblInvoiceDate" runat="server" Text='<%# Bind("InvoiceDate") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Received Amt.">
                                <ItemTemplate>
                                    <asp:Label ID="lblReceivedAmount" runat="server" Text='<%# Bind("ReceivedAmount") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TDS Amt." Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblTDSAmount" runat="server" Text='<%# Bind("TDSAmount") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="WriteOff Amt." Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblWriteOffAmount" runat="server" Text='<%# Bind("WriteOff") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Deducation Amt." Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblDeducationAmt" runat="server" Text='<%# Bind("DeducationAmt") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblTYPE" runat="server" Text='<%# Bind("PatientType") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>

                              <asp:TemplateField HeaderText="Panel Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblPanel" runat="server" Text='<%# Bind("PanelName") %>'></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Print">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="Print" ImageUrl="~/Images/print.gif" ToolTip="Print" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

