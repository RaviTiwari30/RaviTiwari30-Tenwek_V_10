<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="OPD_PatientIssueDetails.aspx.cs" Inherits="Design_Store_OPD_PatientIssueDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <script type = "text/javascript">
     $(document).ready(function () {
         $('#DateFrom').change(function () {
             ChkDate();
         });
         $('#DateTo').change(function () {
             ChkDate();
         });
     });
     

     function ChkDate() {

         $.ajax({

             url: "../common/CommonService.asmx/CompareDate",
             data: '{DateFrom:"' + $('#DateFrom').val() + '",DateTo:"' + $('#DateTo').val() + '"}',
             type: "POST",
             async: true,
             dataType: "json",
             contentType: "application/json; charset=utf-8",
             success: function (mydata) {
                 var data = mydata.d;
                 if (data == false) {
                     $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                     $('#<%=btnSearchByName.ClientID %>').attr('disabled', 'disabled');

                 }
                 else {
                     $('#<%=lblMsg.ClientID %>').text('');
                     $('#<%=btnSearchByName.ClientID %>').removeAttr('disabled');

                 }
             }
         });
     }

     </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div>
                <div style="text-align: center;">
                    <b>Patient Medical Issue Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="height: 90px">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div>
                <table style="width:100%;border-collapse:collapse" >
                    <tr>
                        <td style="width: 20%;text-align:right" >
                            UHID :&nbsp;
                        </td>
                        <td style="width: 20%; text-align:left;"> 
                            <asp:TextBox ID="txtMRNo" runat="server"  
                                Width="149px"></asp:TextBox>
                        </td>
                        <td style="width: 20%;text-align:right" >
                            Patient Name :&nbsp;
                        </td>
                        <td style="width: 20%; text-align:left;">
                            <asp:TextBox ID="txtName" runat="server"  
                                Width="149px"></asp:TextBox>
                        </td>
                        <td style="width: 20%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%;text-align:right" >
                            From Date :&nbsp;
                        </td>
                        <td style="width: 20%;text-align:left;" >
                            <asp:TextBox ID="DateFrom" runat="server" ClientIDMode="Static" Width="149px" 
                                ></asp:TextBox>
                            <cc1:CalendarExtender ID="frmdate" TargetControlID="DateFrom" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 20%;text-align:right" >
                            To Date :&nbsp;
                        </td>
                        <td style="width: 20%;text-align:left">
                            <asp:TextBox ID="DateTo" runat="server" ClientIDMode="Static" Width="149px" 
                                ></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="DateTo" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearchByName" runat="server" OnClick="btnSearchByName_Click" Text="Report" CssClass="ItDoseButton" />&nbsp;
        </div>
    </div>
</asp:Content>
