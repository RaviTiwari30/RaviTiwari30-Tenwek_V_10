<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Form_L.aspx.cs" Inherits="Design_Lab_Form_L" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">

        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();

            });

            $('#ToDate').change(function () {
                ChkDate();

            });
            chkSelectAll();
        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');

                    }
                }
            });
        }
      
        function chkSelectAll() {
            var status = $('#<%= chkDisease.ClientID %>').is(':checked');
            if (status == true) {
                $('.chkAll input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAll input[type=checkbox]").attr("checked", false);
            }
        }
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
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Laboratory Surveillance Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                SearSearch Criteria
            </div>
            <div class="content">
                <div>
                    <table style="width: 100%">
                        <tr>
                            <td align="right" style="width:20%">Type :&nbsp;</td>
                            <td style="width:30%">
                           <asp:RadioButtonList ID="rdoType" runat="server" RepeatDirection="Horizontal">
                               <asp:ListItem Value="OPD">OPD</asp:ListItem>
                               <asp:ListItem Value="IPD">IPD</asp:ListItem>
                               <asp:ListItem Value="ALL">ALL</asp:ListItem>
                           </asp:RadioButtonList></td>
                            <td align="right">&nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right" style="width:20%">From Date :&nbsp;
                            </td>
                            <td style="width:30%">
                                <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" Width="170px" TabIndex="7"
                                    ToolTip="Select From Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                                </cc1:CalendarExtender>
                            </td>
                            <td align="right" style="width:20%">To Date :&nbsp;
                            </td>
                            <td style="width:30%">
                                <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="144px" TabIndex="7"
                                    ToolTip="Select From Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ToDate">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><asp:CheckBox  ID="chkDisease" runat="server" Text="Disease" ClientIDMode="Static" onclick="chkSelectAll()" Checked="true" />&nbsp;</td>
                            <td colspan="3">
                               <asp:CheckBoxList ID="chkDiseaseList" CssClass="chkAll" runat="server" RepeatDirection="Horizontal" RepeatColumns="4" ClientIDMode="Static"></asp:CheckBoxList></td>
                            <td align="right">&nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                          <tr>
                            <td align="right">  <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" /></td>
                            <td colspan="3">
                               <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList></td>
                            <td align="right">&nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                    </table>
                </div>
                <div style="text-align: center">
                    <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>


