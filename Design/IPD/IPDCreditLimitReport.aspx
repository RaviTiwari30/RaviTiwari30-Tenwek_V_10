<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDCreditLimitReport.aspx.cs" Inherits="Design_IPD_IPDCreditLimitReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript" >
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
                        $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
         $(function () {
             checkAllCentre();
         });
        function checkAllCentre() {
            
            if ($('#<%= chkAllCentre.ClientID %>').is(':checked')) 
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
          </script>
     <div id="Pbody_box_inventory">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>IPD(Cash) Credit Limit Report </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>                                           
             <table style="width:100%;">
                   <tr>
                    <td style="text-align:right;width:20%">
                        <asp:CheckBox ID="chkAllCentre" Checked="true" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                    </td>
                    <td colspan="4">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align:right" >
                        From Admission Date :&nbsp;
                    </td>
                    <td style="width: 30%">
                        <asp:TextBox ID="txtFromDate" runat="server"  Width="170px" ClientIDMode="Static" ToolTip="Click To Select From Date"
                            TabIndex="1"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align:right" >
                        To Admission Date :&nbsp;
                    </td>
                    <td style="width: 30%">
                        <asp:TextBox ID="txtToDate" runat="server" Width="170px"  ClientIDMode="Static" ToolTip="Click To Select To Date"
                            TabIndex="2"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                   
                </tr>

                 </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click"
                CssClass="ItDoseButton" ToolTip="Click To Open Report" TabIndex="4" />
        </div>
            </div>
</asp:Content>

