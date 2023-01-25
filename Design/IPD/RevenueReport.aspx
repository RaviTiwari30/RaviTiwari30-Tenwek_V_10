<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="RevenueReport.aspx.cs" Inherits="Reports_IPD_RevenueReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

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
                        $('#btnBinSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnBinSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScripManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content">
                <div style="text-align: center">
                    <b>Revenue Report</b><br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblTypeName" runat="server" Text="Doctor Name "></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" runat="server"></asp:DropDownList>
                            <asp:DropDownList ID="ddlDepartment" runat="server" Visible="false"></asp:DropDownList>
                            <asp:DropDownList ID="ddlWard" runat="server" Visible="false"></asp:DropDownList>
                            <asp:DropDownList ID="ddlCategory" runat="server" Visible="false" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                View Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBoxList ID="chkOPDIPD" runat="server" RepeatColumns="2">
                                <asp:ListItem Selected="True">IPD</asp:ListItem>
                                <asp:ListItem Selected="True">OPD</asp:ListItem>
                            </asp:CheckBoxList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGroups" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroups_SelectedIndexChanged" CssClass="inertextbox3">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:RadioButtonList ID="rbtnWise" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" RepeatColumns="4" OnSelectedIndexChanged="rbtnWise_SelectedIndexChanged">
                                <asp:ListItem Text="Doctor Wise" Value="1" Selected="True" />
                                <asp:ListItem Value="2" Text="Doctor Department WIse" />
                                <asp:ListItem Value="4" Text="Category wise" />
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rbtViewType" runat="server" RepeatDirection="Horizontal" RepeatColumns="2" Visible="false">
                                <asp:ListItem Text="Summary Report" Value="1" Selected="True" />
                                <asp:ListItem Value="2" Text="Summary Break-UpReport" />
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatColumns="1" Visible="false">
                                <asp:ListItem Value="2" Selected="True">Revenue Generated</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkSubGroups" runat="server" Text="Sub Groups"
                                CssClass="ItDoseCheckbox" OnCheckedChanged="chkSubGroups_CheckedChanged" AutoPostBack="true" />
                        </div>
                        <div class="col-md-21">
                                <asp:CheckBoxList ID="chlSubGroups" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist">
                                </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Specify From Date " ControlToValidate="txtFromDate" Display="None" SetFocusOnError="True">*</asp:RequiredFieldValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Specify To Date" ControlToValidate="txtToDate" Display="None" SetFocusOnError="True">*</asp:RequiredFieldValidator><asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="Please Fix following Errors :"
                                ShowMessageBox="True" ShowSummary="False" />
                            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>
</asp:Content>
