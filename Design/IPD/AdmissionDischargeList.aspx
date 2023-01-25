<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdmissionDischargeList.aspx.cs"
    Inherits="Design_IPD_AdmissionDischargeList" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <style type="text/css">
        input[type="text"], select {
            width: 100%;
        }
    </style>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
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
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');
            if (status == true)
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            else
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length))
                 $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
             else
                 $('#<%= chkAllCentre.ClientID %>').attr("checked", false);

         }
         function checkAllItem() {
             if ($('#<%= chkAllItem.ClientID %>').is(':checked'))
                $(".chkItem input[type=checkbox]").attr("checked", "checked");
            else
                $(".chkItem input[type=checkbox]").attr("checked", false);
        }
        function checkItem() {
            if (($('#<%= chkItems.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkItems.ClientID %>  input[type=checkbox]').length))
                $('#<%= chkAllItem.ClientID %>').attr("checked", "checked");
            else
                $('#<%= chkAllItem.ClientID %>').attr("checked", false);
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Admission / Discharged Patient List </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

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
                                List Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoListType" runat="server" RepeatDirection="Horizontal"
                                CssClass="ItDoseRadiobuttonlist" ToolTip="Select List Type">
                                <asp:ListItem Selected="True" Text="Admission" Value="1" />
                                <asp:ListItem Text="Discharged" Value="2" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
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
                            <asp:DropDownList ID="ddlReportType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged"
                                TabIndex="3" ToolTip="Select Report Type">
                                <asp:ListItem Text="Bed Category Wise" Value="2" />
                                <asp:ListItem Text="Consultant Wise" Value="3" />
                                <asp:ListItem Text="Date Wise" Value="4" />
                                <asp:ListItem Text="Department Wise" Value="5" />
                                <asp:ListItem Text="Floor Wise" Value="6" />
                                <asp:ListItem Text="Panel Company Wise" Value="7" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearch" onkeyup="SearchCheckbox(this,'#chkItems')" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Format
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:RadioButtonList ID="ddlReportFormat" runat="server" 
                                TabIndex="3" ToolTip="Select Report Format" RepeatDirection="Horizontal">
                                <asp:ListItem Text="PDF" Value="1" Selected="True"/>
                                <asp:ListItem Text="Excel" Value="2" />
                                
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
            <table style="width: 100%;">
                <tr>
                    <td style="width: 20%; text-align: right; vertical-align: central; border: groove;">
                        <asp:CheckBox ID="chkAllItem" ClientIDMode="Static" CssClass="AllItem" runat="server" onclick="checkAllItem();" Text="All :&nbsp;" />

                    </td>
                    <td colspan="4" style="height: 150px; border: groove; overflow-y: scroll;">
                        <div style="height: 207px; width: 100%; text-align: left;" class="scrollankur">
                            <asp:CheckBoxList ID="chkItems" runat="server" CssClass="ItDoseCheckboxlist chkItem" RepeatColumns="6" ClientIDMode="Static"
                                RepeatDirection="Horizontal" RepeatLayout="Table" onclick="checkItem();">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; border: groove">
                        <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                    </td>
                    <td colspan="4" style="border: groove">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Report" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ToolTip="Click To Open report" TabIndex="4" />
        </div>
    </div>
</asp:Content>
