<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientRoomShiftReport.aspx.cs" Inherits="Design_IPD_PatientRoomShiftReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" >
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

              if (status == true) {
                  $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
              }
              else {
                  $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
              }

          }
          function checkMain() {

              if (($('#<%= chkCentre.ClientID %> input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %> input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %> input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %> input[type=checkbox]').attr("checked", false);
            }
        }
    </script>
   
    <div id="Pbody_box_inventory">
     <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Admission / Discharged Patient List </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div> 
            <table width="100%">
                <tr>
                    <td style="width: 20%" align="right">
                        From Date :&nbsp;
                    </td>
                    <td style="width: 30%"> 
                        <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date" Width="170px"
                            TabIndex="1"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%" align="right">
                        To Date :&nbsp;
                    </td>
                    <td style="width: 30%">
                        <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" Width="170px"
                            TabIndex="2"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%">
                    </td>
                </tr>
                 <tr>
                    <td style="text-align: right; vertical-align:top;"><asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" Text="All Centre" onclick="checkAllCentre();" /></td>
                    <td style="text-align: left" colspan="3">
                        <asp:CheckBoxList ID="chkCentre" ClientIDMode="Static" onclick="checkMain()" RepeatLayout="Table" CssClass="chkAllCentreCheck" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Report" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ToolTip="Click To Open report" TabIndex="4" />
        </div>
    </div>
</asp:Content>
