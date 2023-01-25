<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="IncomeReport.aspx.cs" Inherits="Design_OPD_IncomeReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <script type="text/javascript">
        function CheckTransType() {
            var stat = false;

            var ctrl = document.getElementById("cblColType");
            var arrayOfCheckBoxes = ctrl.getElementsByTagName("input");

            for (var i = 0; i < arrayOfCheckBoxes.length; i++)
                if (arrayOfCheckBoxes[i].checked)
                    stat = true;

            if (stat == false) {
                alert('Select Collection Type');
            }
            else {
                _dopostback(btnPrint);
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                    <b>Income Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
               
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div>
                <table  style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td style="width: 20%; text-align: right;">
                            From Date :&nbsp;
                        </td>
                        <td style="width: 30%">
                            <asp:TextBox ID="ucFromDate" runat="server" 
                                ToolTip="Select From Date" Width="170px" TabIndex="1" ></asp:TextBox>
                            <cc1:CalendarExtender ID="ucFromDate_CalendarExtender" runat="server" TargetControlID="ucFromDate"
                                Format="dd-MMMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                       
                        <td align="right" style="width: 20%">
                            To Date :&nbsp;
                        </td>
                        <td align="left" style="width: 30%">
                            <asp:TextBox ID="ucToDate" runat="server" ToolTip="Select To Date"
                                Width="170px" TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="ucToDate_CalendarExtender" runat="server" TargetControlID="ucToDate"
                                Format="dd-MMMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                   
                    </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnPreview" runat="server" Text="Report" TabIndex="3"
                CssClass="ItDoseButton" OnClick="btnPreview_Click" ToolTip="Click to Open Report" />
            &nbsp;&nbsp;
        </div>
        </div>
</asp:Content>
