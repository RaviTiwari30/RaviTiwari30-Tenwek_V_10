<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Patient_Statics.aspx.cs" Inherits="Design_OPD_Patient_Statics" MasterPageFile="~/DefaultHome.master"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        $(function () {
            $('#txtfromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();

            });

        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });

        }
 
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient census Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: right; width: 234px;">
                        From Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 119px;">
                        <asp:TextBox ID="txtfromDate" runat="server" ToolTip="Select From Date" Width="129px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right" colspan="2">
                        To Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 447px;">
                        <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="129px"
                            TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 234px;">
                    </td>
                    <td style="text-align: left; width: 119px;">
                        &nbsp;
                    </td>
                    <td style="text-align: right" colspan="2">
                        &nbsp;
                    </td>
                    <td style="text-align: left; width: 447px;">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" Text="Report"
                ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Open Report" />
        </div>
       <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                   Result
                </div>
                <div style="text-align: center;">
                    <table border="0"  style="width: 100%">
                        <tr>
                            <td  style="text-align:center" colspan="4">
                                <asp:GridView ID="grdstats" runat="server" AutoGenerateColumns="true" BorderStyle="Solid" CssClass="GridViewStyle">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle"/>
                                     <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px"  />
                                     

                                </asp:GridView>
                            </td>
                      
                    </table>
                </div>
            </div>
 </div>
</asp:Content>
