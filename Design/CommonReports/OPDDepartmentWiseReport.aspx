<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDDepartmentWiseReport.aspx.cs" Inherits="Design_OPD_OPDDepartmentWiseReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
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
                        $('#<%=btnPDFReport.ClientID %>,#<%=btnExcelReport.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnPDFReport.ClientID %>,#<%=btnExcelReport.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }
        $(function () {
            checkAllCentre();
            $("[id*=chkSubGroups]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlSubGroups] input").attr("checked", "checked");
                } else {
                    $("[id*=chlSubGroups] input").removeAttr("checked");
                }
            });
            $("[id*=chlSubGroups] input").bind("click", function () {
                if ($("[id*=chlSubGroups] input:checked").length == $("[id*=chlSubGroups] input").length) {
                    $("[id*=chlSubGroups]").attr("checked", "checked");
                } else {
                    $("[id*=chkSubGroups]").removeAttr("checked");
                }
            });
        });
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
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
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>OPD Department Wise Report</b><br />
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
                                From Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select From Date" />
                            <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select to Date" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGroups" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroups_SelectedIndexChanged"
                                TabIndex="3" ToolTip="Select Item Groups">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal" TabIndex="4">
                                <asp:ListItem Value="0" Selected="True">Dept. Wise Summary</asp:ListItem>
                                <asp:ListItem Value="1">Dept. Wise Detail</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" TabIndex="5" RepeatColumns="5" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Department List
            </div>
            <table style="width: 100%; text-align: left; border-collapse: collapse">
                <tr>
                    <td style="text-align: left; width: 10%; border: groove">
                        <asp:CheckBox ID="chkSubGroups" runat="server" Text="Department" AutoPostBack="false" />
                    </td>
                    <td colspan="4" style="width: 100%; border: groove">
                        <div style="height: 240px; width: 100%; text-align: left; overflow:auto" >
                            <asp:CheckBoxList ID="chlSubGroups" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" ClientIDMode="Static"
                                TabIndex="5">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnPDFReport" runat="server" Text="PDF Report" CssClass="ItDoseButton"
                OnClick="btnPDFReport_Click" ToolTip="Click to Open PDF Report " TabIndex="6" CommandName="PDF" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     <asp:Button ID="btnExcelReport" runat="server" Text="Excel Report" CssClass="ItDoseButton"
                         OnClick="btnPDFReport_Click" ToolTip="Click to Open Excel Report " TabIndex="7" CommandName="Excel" />


        </div>
    </div>
</asp:Content>

