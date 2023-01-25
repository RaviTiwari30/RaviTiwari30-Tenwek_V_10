<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorReferReport.aspx.cs" Inherits="Design_IPD_DoctorReferReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conetent1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <style type="text/css">
        input[type="text"], select {
            width:100%;
        }
    </style>
    <script type="text/javascript">
        $(function () {
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
        $(function () {
            checkAllCentre();
            chkIPDNo();
        });
        function checkAllCentre() {
            if ($('#<%= chkAllCentre.ClientID %>').is(':checked')) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }

        function chkIPDNo() {
            if ($("#rblReportType input[type=radio]:checked").val() == "2")
                $("#txtIPDNo").val('').removeAttr('disabled');
            else
                $("#txtIPDNo").val('').attr('disabled', 'disabled');
        }
    </script>
    <cc1:ToolkitScriptManager ID="sc" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Refer Doctor Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" Checked="true" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="6" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblReportType" ClientIDMode="Static" onclick="chkIPDNo()" TabIndex="1" runat="server" RepeatDirection="Horizontal" RepeatColumns="3" RepeatLayout="Table">
                                <asp:ListItem Text="OPD" Value="1"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Both" Value="3" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" ClientIDMode="Static" ToolTip="Select To Date"
                                TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Refer Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReferDoctor" runat="server" TabIndex="3"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static"
                                TabIndex="4" MaxLength="10"></asp:TextBox>
                            
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"
                                TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"
                                TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                ToolTip="Click To Open Report " ClientIDMode="Static" TabIndex="7" />
        </div>
    </div>
</asp:Content>

