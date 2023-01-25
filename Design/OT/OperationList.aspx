<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OperationList.aspx.cs" Inherits="Design_OT_OperationList" Title="OT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtfromdate').change(function () {
                ChkDate();
            });

            $('#txttodate').change(function () {
                ChkDate();
            });

        });


        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromdate').val() + '",DateTo:"' + $('#txttodate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblmsg').text('To date can not be less than from date!');
                      
                    }
                    else {
                        $('#lblmsg').text('');
                        $('#btnsubmit').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Opeartion List    
            <br />
            <asp:Label ID="lblmsg" runat="server" ForeColor="red"></asp:Label></b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <br />
            </div>

            <table style="width: 100%">

                <tr>
                    <td style="text-align: right;width:20%">From Date Time :&nbsp; </td>
                    <td style="text-align: left;width:30%">
                        <asp:TextBox ID="txtfromdate" runat="server" ClientIDMode="Static" Width="170px"></asp:TextBox>&nbsp;
                        <cc1:CalendarExtender ID="todalcal" TargetControlID="txtfromdate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                         <asp:TextBox ID="txtFromTime" runat="server" MaxLength="5" Width="80px" ToolTip="Enter Time"
                                        TabIndex="2" Visible="false" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtFromTime" AcceptAMPM="true">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    
                    <td style="text-align: right;width:20%">To Date Time :&nbsp;</td>
                    <td style="text-align: left;width:30%">&nbsp;<asp:TextBox ID="txttodate" runat="server" ClientIDMode="Static" Width="170px"></asp:TextBox>&nbsp;
                        <cc1:CalendarExtender ID="calToDate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                          <asp:TextBox ID="txtToTime" runat="server" MaxLength="5" Width="80px" ToolTip="Enter Time"
                                        TabIndex="4" visible="false" />
                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtToTime" AcceptAMPM="true">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                   
                </tr>



            </table>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnsubmit" runat="server" Text="Submit" OnClick="btnsubmit_Click" CssClass="ItDoseButton" />
        </div>
    </div>

</asp:Content>

