<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDPatientActivityEntryPrintOut.aspx.cs" Inherits="Design_IPD_IPDPatientActivityEntryPrintOut" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
        <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
            <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
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

    </script>
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>IPD Activity PrintOut</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <table style="width: 100%; border-collapse: collapse">

                <tr>
                    <td style="text-align: right; width: 20%">From Date :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"
                            TabIndex="3" Width="110px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right; width: 20%">To Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"
                            TabIndex="4" Width="110px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>

                </tr>

            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                ToolTip="Click To Open Report " ClientIDMode="Static" TabIndex="5" />
        </div>

    </div>

    </form>
</body>
</html>