<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AttendnessInsert.aspx.cs" Inherits="Design_Payroll_AttendnessInsert" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
               
            });

            $('#DateTo').change(function () {
                ChkDate();

            });

        });
        function ChkDate() {
            var fromDate = "";
            if ($("#<%=txtFromDate.ClientID%>").is(':visible'))
                 fromDate = $("#<%=txtFromDate.ClientID%>").val();
             else
                fromDate = $("#<%=DateFrom.ClientID%>").val();
           
             $.ajax({
                 url: "../common/CommonService.asmx/CompareDate",
                 data: '{DateFrom:"' + fromDate + '",DateTo:"' + $('#DateTo').val() + '"}',
                 type: "POST",
                 async: true,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (mydata) {
                     var data = mydata.d;
                     if (data == false) {
                         $("#<%=lblmsg.ClientID %>").text('To date can not be less than from date!');
                         $('#btnInsert').attr('disabled', 'disabled');

                     }
                     else {
                         $("#<%=lblmsg.ClientID %>").text('');
                         $('#btnInsert').removeAttr('disabled');
                         $('#DateFrom').val($('#txtFromDate').val());
                     }
                 }
             });

         }

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
                <b>Employee Attendance </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Attendance Details
            </div>
           
                <table style="text-align: center; border-collapse:collapse;margin-left:180px">
                    <tr>
                        <td style="text-align:center">From Date :&nbsp;
                        </td>
                        <td>
                          <asp:TextBox ID="txtFromDate" Visible="false" ClientIDMode="Static" runat="server" Width="100px" ToolTip="Click To Select From Date"></asp:TextBox>
                             <cc1:CalendarExtender ID="calFrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="DateFrom" ClientIDMode="Static" runat="server"></asp:TextBox>
                           
                            <asp:Label ID="lblFromDate" ClientIDMode="Static" Font-Bold="true" runat="server"></asp:Label>
                        </td>
                        <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; To Date :&nbsp;
                        </td>
                        <td>
                            
                            <asp:TextBox ID="DateTo" ClientIDMode="Static" runat="server" Width="100px" ToolTip="Click to Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="DateTo" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td colspan='4'>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan='4'>
                            <asp:Button ID="btnInsert" ClientIDMode="Static" runat="server" Text="Make Attendance" CssClass="ItDoseButton"
                                OnClick="btnInsert_Click" TabIndex="1" ToolTip="Click to Make Attendance" />
                        </td>
                    </tr>
                </table>
           
        </div>
    </div>
</asp:Content>