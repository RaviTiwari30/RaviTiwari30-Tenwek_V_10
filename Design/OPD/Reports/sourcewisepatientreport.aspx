<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="sourcewisepatientreport.aspx.cs" Inherits="Design_OPD_sourcewisepatientreport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conetent1" runat="server">
    <script type="text/javascript" >
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
    <cc1:ToolkitScriptManager ID="sc" runat="server" >
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
                <b>Source Wise Patient Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria</div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td  style="text-align:right;width:20%">
                        From Date :&nbsp;
                    </td>
                    <td  style="width: 30%;text-align:left" >
                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" 
                            TabIndex="5" Width="170px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align:right;width:20%" >
                        To Date :&nbsp;
                    </td>
                    <td  style="text-align:left;width:30%">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"
                            TabIndex="6" Width="170px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                 <tr>
                    <td  style="text-align:right;width:20%">
                        Patient Source :&nbsp;
                    </td>
                    <td  style="width: 30%;text-align:left" >
                         <asp:DropDownList ID="ddlsource" runat="server" Width="170px" TabIndex="3"></asp:DropDownList>
                    </td>
                     <td style="text-align: right; width: 20%;">
                        Report Type :&nbsp;</td>
                    <td style="text-align: left; width: 80%;" colspan="3">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="0">PDF</asp:ListItem>
                            <asp:ListItem Value="1">Excel</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                 <tr >
                     <td  style="text-align:right;width:20%">
                         <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" Checked="true" /></td>
                     <td  style="width: 80%;text-align:left"  colspan="3">
                         <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                          </asp:CheckBoxList>
                     </td>
                 </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                ToolTip="Click To Open Report " ClientIDMode="Static" TabIndex="7" />
        </div>
    </div>
</asp:Content>
