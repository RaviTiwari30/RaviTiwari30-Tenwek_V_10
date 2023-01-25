<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ReprintIPDInvestigation.aspx.cs" Inherits="Design_IPD_ReprintIPDInvestigation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conetent1" runat="server">
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
    <cc1:ToolkitScriptManager ID="sc" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>IPD Investigation Bill Reprint</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <table style="width: 100%; border-collapse: collapse">

                <tr>
                    <td style="text-align: right; width: 20%">IPD No. :&nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static"
                            TabIndex="1" Width="110px" MaxLength="10"></asp:TextBox>
                       
                    </td>
                    <td style="text-align: right; width: 20%">Lab No. :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                         <asp:TextBox ID="txtLabNo" runat="server" Width="110px" MaxLength="10" ToolTip="Enter Lab No."
                                TabIndex="2" /> 
                                <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" TargetControlID="txtLabNo" FilterType="Numbers"
                                 runat="server"></cc1:FilteredTextBoxExtender>
                       
                    </td>

                </tr>

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
        <div class="POuter_Box_Inventory" style="text-align: center">

            <asp:GridView ID="grdReprintInv" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnSelectedIndexChanged="grdReprintInv_SelectedIndexChanged" Width="100%">
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Pname" HeaderText="Patient Name" HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-Width="180px" ItemStyle-HorizontalAlign="Left" />
                    <asp:TemplateField HeaderText="UHID" HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-Width="100px">
                        <ItemTemplate>
                            <asp:Label ID="lblPatientID" runat="server" Text='<%# Util.GetString(Eval("PatientID")) %>'></asp:Label>
                            <asp:Label ID="lblLedgerTransactionNo" runat="server" Text='<%# Util.GetString(Eval("LedgerTransactionNo")) %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="IPDNo" HeaderText="IPD No." HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60px" />
                    <asp:BoundField DataField="ContactNo" HeaderText="Contact No." HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center"/>
                    <asp:BoundField DataField="Amount" HeaderText="Total Amt." HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="80px"/>
                    <asp:BoundField DataField="LabNo" HeaderText="Lab No." HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px"/>
                    
                      <asp:BoundField DataField="Name" HeaderText="Entry By" HeaderStyle-CssClass="GridViewHeaderStyle"
                        ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="180px"/>

                    <asp:CommandField SelectText="Reprint" HeaderText="Reprint" SelectImageUrl="~/Images/print.gif" ButtonType="Image" ItemStyle-Width="40px"
                        ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Center"
                        ItemStyle-CssClass="GridViewItemStyle" />
                </Columns>
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
            </asp:GridView>
        </div>

    </div>
</asp:Content>


