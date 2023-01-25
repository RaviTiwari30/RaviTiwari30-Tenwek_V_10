<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="RequestDetails.aspx.cs" Inherits="Design_Purchase_RequestDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >

        $(function () {
            $('#EntryDate1').change(function () {
                ChkDate();

            });

            $('#EntryDate2').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#EntryDate1').val() + '",DateTo:"' + $('#EntryDate2').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }


    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Purchase Request Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
           




                <table style="width: 106%">
                    <tr>
                        <td style="width: 9%; text-align: right;">Store :&nbsp;</td>
                        <td style="width: 25%">
                            <asp:DropDownList ID="ddlStore" runat="server"
                                Width="170px">
                                <asp:ListItem Selected="True" Text="Medical" Value="STO00001" />
                                <asp:ListItem Text="General" Value="STO00002" />
                            </asp:DropDownList></td>
                        <td style="width: 13%; text-align: right;">Status :&nbsp;</td>
                        <td style="width: 25%">
                            <asp:DropDownList ID="ddlStatus" runat="server"
                                 Width="170px">
                                <asp:ListItem Value="5">All</asp:ListItem>
                                <asp:ListItem Value="0">Pending</asp:ListItem>
                                <asp:ListItem Value="1">Reject</asp:ListItem>
                                <asp:ListItem Value="2">Open</asp:ListItem>
                                <asp:ListItem Value="3">Close</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 9%; text-align: right;">From Date :&nbsp;</td>
                        <td style="width: 25%">
                            <asp:TextBox ID="EntryDate1"
                                runat="server" Width="170px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                            </cc1:CalendarExtender>
                            &nbsp;</td>
                        <td style="width: 13%; text-align: right;">To Date :&nbsp;</td>
                        <td style="width: 25%">
                            <asp:TextBox ID="EntryDate2" runat="server" Width="170px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate2">
                            </cc1:CalendarExtender>
                            &nbsp;</td>
                    </tr>
                </table>
          
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                OnClick="btnSearch_Click" />
        </div>
    </div>
</asp:Content>
