<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorChargesDetails.aspx.cs" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_DocAccount_DoctorChargesDetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {
            //$('#ddlDoctor').chosen();
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').prop('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeProp('disabled');
                    }
                }
            });

        }

    </script>
    <cc1:ToolkitScriptManager ID="ToolScript" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Doctor Collection Details</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Share Details
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
                            <asp:TextBox ID="txtFromDate" runat="server"
                                ToolTip="Click To Select From  Date" TabIndex="1"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFromDate_calenderex" runat="server"
                                TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server"
                                ToolTip="Click To Select From  Date" TabIndex="1"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtTodate_Calender" runat="server"
                                TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type:
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtActive" runat="server" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="rbtActive_SelectedIndexChanged"
                                RepeatDirection="Horizontal" Width="193px">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">In-Active</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rbdReportType" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Text="Detailed" Value="D"></asp:ListItem>
                                <asp:ListItem Text="Summarised" Value="S"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" Width="225px" runat="server" ClientIDMode="Static" />
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
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" runat="server" Text="Report" ToolTip="Click to Open Doctor Report" CssClass="ItDoseButton" Width="65px"
                                OnClick="btnSearch_Click" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
