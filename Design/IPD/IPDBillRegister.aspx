<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDBillRegister.aspx.cs" Inherits="Design_IPD_IPDBillRegister" MasterPageFile="~/DefaultHome.master" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/CheckboxSearch.js" type="text/javascript"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            checkAllCentre();
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

        function checkAllCentre() {
            if ($('#<%= chkAllCentre.ClientID %>').is(':checked')) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%=chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
        function checkAllCustomField() {
            if ($('#<%= chkcustomfieldApply.ClientID %>').is(':checked')) {
                $('.customfieldApply input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".customfieldApply input[type=checkbox]").attr("checked", false);
            }
        }
        function ChkDateCon() {
            if ($('#<%= ChkDate.ClientID %>').is(':checked'))
                $('#<%=txtFromDate.ClientID%>,#<%=txtToDate.ClientID%>').attr("disabled", false);
            else
                $('#<%=txtFromDate.ClientID%>,#<%=txtToDate.ClientID%>').attr("disabled", true);
        }
    </script>
    <Ajax:ScriptManager ID="ScripManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">


            <b>Bill Register</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


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
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtType"
                                runat="server" RepeatDirection="Horizontal" AutoPostBack="True"
                                OnSelectedIndexChanged="rbtType_SelectedIndexChanged">
                                <asp:ListItem Text="Summarised" Value="1" Selected="True" />
                                <asp:ListItem Text="Detail" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                View Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="rdoReportType" runat="server"
                                RepeatDirection="Horizontal" Width="359px">
                                <asp:ListItem Selected="True" Text="Total Bills" Value="1" />
                                <asp:ListItem Text="OutStanding" Value="2" />
                                <asp:ListItem Value="3">Refundable</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rbtSubCateoryType" runat="server" RepeatDirection="Horizontal" Visible="False">
                                <asp:ListItem Text="MainGroupWise" Value="2" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="SubGroupWise" Value="1"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div id="trreportgroup" runat="server" class="col-md-13">
                            <label class="pull-left">
                                Report&nbsp;Group&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>:</B>&nbsp;&nbsp;&nbsp;&nbsp; 
                            </label>
                            <asp:RadioButtonList ID="rdbReportType" runat="server"
                                RepeatDirection="Horizontal" Width="356px">
                                <asp:ListItem Selected="True" Text="Bill wise" Value="1" />
                                <asp:ListItem Text="Panel wise" Value="2" />
                                <asp:ListItem Value="3">Panel with Doctor wise</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rbtSummaryBy" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Patientwise" Value="1" Selected="True" style="display: none"></asp:ListItem>
                                <asp:ListItem Text="BillDatewise" Value="2" style="display: none"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="ChkDate" runat="server" Checked="true" ClientIDMode="Static" onclick="ChkDateCon()" />From Date
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

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" Checked="true" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table"
                                CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" >
                Additional Search Criteria
            </div>
            <div style="text-align: center">
                <table>
                    <tr>
                        <td style="text-align: right; width: 50%">Search By Panel Name :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" Width="225px" onkeyup="SearchCheckbox(this,'#chkPanel');"></asp:TextBox>
                        </td>
                        <td></td>
                    </tr>
                </table>
                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table style="text-align: left; width: 100%; border-collapse: collapse">
                            <tr>
                                <td style="text-align: left; width: 8%; border-left-style: solid; border-left-color: inherit; border-left-width: medium; border-right-style: none; border-right-color: inherit; border-right-width: medium; border-top-style: solid; border-top-color: inherit; border-top-width: medium; border-bottom-style: solid; border-bottom-color: inherit; border-bottom-width: medium;">
                                    <asp:CheckBox ID="chkCompAll" runat="server" Text="Panel" AutoPostBack="True" OnCheckedChanged="chkCompAll_CheckedChanged" /></td>
                                <td colspan="4" style="border: solid">
                                    <div style="overflow: scroll; height: 200px; width: 100%; text-align: left;">
                                        <asp:CheckBoxList ID="chkPanel" runat="server" Font-Size="8pt" RepeatColumns="6" RepeatDirection="Horizontal" Font-Names="Verdana" ClientIDMode="Static">
                                        </asp:CheckBoxList>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </Ajax:UpdatePanel>
            </div>
            <div style="text-align: center;display:none" >
                <table>
                    <tr>
                        <td style="text-align: right; width: 50%">Search By Doctor Name:&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtSearch1" runat="server" ClientIDMode="Static" Width="225px" onkeyup="SearchCheckbox(this,'#chkDoctor');"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <Ajax:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <table style="text-align: left; width: 100%; border-collapse: collapse">
                            <tr>
                                <td style="text-align: left; width: 8%; border-left-style: solid; border-left-color: inherit; border-left-width: medium; border-right-style: none; border-right-color: inherit; border-right-width: medium; border-top-style: solid; border-top-color: inherit; border-top-width: medium; border-bottom-style: solid; border-bottom-color: inherit; border-bottom-width: medium;">
                                    <asp:CheckBox ID="chkDocAll" runat="server" Text="Doctor" AutoPostBack="True" OnCheckedChanged="chkDocAll_CheckedChanged" /></td>
                                <td colspan="4" style="border: solid">
                                    <div style="overflow: scroll; height: 200px; width: 100%; text-align: left;" class="border">
                                        <asp:CheckBoxList ID="chkDoctor" runat="server" Font-Size="8pt" RepeatColumns="6" RepeatDirection="Horizontal" Font-Names="Verdana" ClientIDMode="Static">
                                        </asp:CheckBoxList>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </Ajax:UpdatePanel>

            </div>
            <div id="divcustomfield" runat="server">
                <div class="Purchaseheader">
                    Coustom Report Fields Apply<asp:CheckBox ID="chkcustomfieldApply" runat="server" onclick="checkAllCustomField()" ClientIDMode="Static" />
                </div>
                <table style="overflow: scroll; height: 100px; width: 100%">
                    <tr>
                        <td style="text-align: left">
                            <asp:CheckBoxList ID="chkfieldlist" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" RepeatColumns="7" CssClass="customfieldApply">
                                <asp:ListItem Value="CentreID" Selected="True">PanelGroup</asp:ListItem>
                                <asp:ListItem Value="CentreName">CentreName</asp:ListItem>
                                <asp:ListItem Value="BillNo" Selected="True">BillNo</asp:ListItem>
                                <asp:ListItem Value="BillDate">BillDate</asp:ListItem>
                                <asp:ListItem Value="MRNo">MRNo</asp:ListItem>
                                <asp:ListItem Value="PName" Selected="True">PName</asp:ListItem>
                                <asp:ListItem Value="IPDNo" Selected="True">IPDNo</asp:ListItem>
                                <asp:ListItem Value="DateOfAdmit" Selected="True">DateOfAdmit</asp:ListItem>
                                <asp:ListItem Value="DateOfDischarge" Selected="True">DateOfDischarge</asp:ListItem>
                                <asp:ListItem Value="Room">Room</asp:ListItem>
                                <asp:ListItem Value="DoctorName">DoctorName</asp:ListItem>
                                <asp:ListItem Value="GrossBillAmt" Selected="True">GrossBillAmt</asp:ListItem>
                                <asp:ListItem Value="ServiceTaxAmt">ServiceTaxAmt</asp:ListItem>
                                <asp:ListItem Value="RoundOff">RoundOff</asp:ListItem>
                                <asp:ListItem Value="TotalDiscount" Selected="True">TotalDiscount</asp:ListItem>
                                <asp:ListItem Value="NetBillAmount" Selected="True">NetBillAmount</asp:ListItem>
                                <asp:ListItem Value="PatientCopay" Selected="True">PatientCopay</asp:ListItem>
                                <asp:ListItem Value="NonPayableAmt" Selected="True">NonPayableAmt</asp:ListItem>
                                <asp:ListItem Value="Deposit_AsOn_BillDate">Deposit_AsOn_BillDate</asp:ListItem>
                                <asp:ListItem Value="Refund_AsOn_BillDate">Refund_AsOn_BillDate</asp:ListItem>
                                <asp:ListItem Value="ReceiveAmt_AsOn_BillDate" Selected="True">ReceiveAmt_AsOn_BillDate</asp:ListItem>
                                <asp:ListItem Value="OutStanding_AsOnBillDate" Selected="True">OutStanding_AsOnBillDate</asp:ListItem>
                                <asp:ListItem Value="Deposit_After_BillDate">Deposit_After_BillDate</asp:ListItem>
                                <asp:ListItem Value="Refund_After_BillDate">Refund_After_BillDate</asp:ListItem>
                                <asp:ListItem Value="AdjustmentAmt">AdjustmentAmt</asp:ListItem>
                                <asp:ListItem Value="TDS">TDS</asp:ListItem>
                                <asp:ListItem Value="DeductionAcceptable">DeductionAcceptable</asp:ListItem>
                                <asp:ListItem Value="DeductionNonAcceptable">DeductionNonAcceptable</asp:ListItem>
                                <asp:ListItem Value="WriteOff">WriteOff</asp:ListItem>
                                <asp:ListItem Value="CreditAmt">CreditAmt</asp:ListItem>
                                <asp:ListItem Value="DebitAmt">DebitAmt</asp:ListItem>
                                <asp:ListItem Value="ServiceTaxSurChgAmt">ServiceTaxSurChgAmt</asp:ListItem>
                                <asp:ListItem Value="OutStanding_AsOnDate">OutStanding_AsOnDate</asp:ListItem>
                                <asp:ListItem Value="DiscountOnBillReason">DiscountOnBillReason</asp:ListItem>
                                <asp:ListItem Value="ApprovalBy">ApprovalBy</asp:ListItem>
                                <asp:ListItem Value="Panel" Selected="True">Panel</asp:ListItem>
                                <asp:ListItem Value="PanelApprovedAmt">PanelApprovedAmt</asp:ListItem>
                                <asp:ListItem Value="PolicyNo">PolicyNo</asp:ListItem>
                                <asp:ListItem Value="ClaimNo">ClaimNo</asp:ListItem>
                                <asp:ListItem Value="CardNo">CardNo</asp:ListItem>
                                <asp:ListItem Value="CardHolderName"></asp:ListItem>
                                <asp:ListItem Value="RelationWith_holder">RelationWith_holder</asp:ListItem>
                                <asp:ListItem Value="FileNo">FileNo</asp:ListItem>
                                <asp:ListItem Value="PanelAppRemarks">PanelAppRemarks</asp:ListItem>
                                <asp:ListItem Value="PanelApprovalDate">PanelApprovalDate</asp:ListItem>
                                <asp:ListItem Value="BillGeneratedBy">BillGeneratedBy</asp:ListItem>
                                <asp:ListItem Value="BillingStatus">BillingStatus</asp:ListItem>
                                <asp:ListItem Value="ReceiveAmt_After_BillDate">ReceiveAmt_After_BillDate</asp:ListItem>
                            </asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="vertical-align: middle; text-align: center">
            &nbsp;<asp:Button ID="btnBinSearch" runat="server" Text="Report" ClientIDMode="Static" CssClass="ItDoseButton" OnClick="btnBinSearch_Click" OnClientClick="return chkCon()" />
        </div>
        <script type="text/javascript">
            function chkCon() {

                if ($('.customfieldApply input[type=checkbox]:checked').length == "0") {
                    alert('Please Check Coustom Report Fields Apply');
                    return false;
                }
            }
        </script>
    </div>






</asp:Content>
