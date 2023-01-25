<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchPurchaseRequest.aspx.cs"
    Inherits="Design_Purchase_SearchPurchaseRequest" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#cc99cc';
        }
        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPR(PRNo) {
            window.open('PRReport.aspx?PRNumber=' + PRNo);
        }

        $(document).ready(function () {
            $('select').chosen();
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
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>,#<%=btnSN.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnA.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=GridView1.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>,#<%=btnSN.ClientID %>').removeAttr('disabled');
                        $('#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>').removeAttr('disabled');
                        $('#<%=btnA.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Request Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPRNo" runat="server" TabIndex="1" MaxLength="20"
                                ToolTip="Enter Request No." />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Raised User
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbEmployee" TabIndex="2" ToolTip="Select Raised User" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbRequestType" TabIndex="3" runat="server" ToolTip="Select Request Type" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbStatus" runat="server" TabIndex="4" ToolTip="Select Status">
                                <asp:ListItem Value="5">All</asp:ListItem>
                                <asp:ListItem Value="0">Pending Approval</asp:ListItem>
                                <asp:ListItem Value="1">Rejected</asp:ListItem>
                                <asp:ListItem Value="2">Approved</asp:ListItem>
                                <asp:ListItem Value="3">Grn Done</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbPurchase" runat="server" TabIndex="5" ToolTip="Select Store" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              <asp:CheckBox ID="chkitem" runat="server" OnCheckedChanged="chkitem_CheckedChanged" AutoPostBack="true" />  Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="lstItem" runat="server" TabIndex="6" ToolTip="Select Item" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="EntryDate1" runat="server" TabIndex="7" ToolTip="Click To Select From Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="EntryDate2" runat="server" TabIndex="8" ToolTip="Click To Select To Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate2">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkPartial" Text="Partial Only" runat="server" Style="display: none;" />
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtSubject" runat="server" Style="display: none;" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">

            <div style="text-align: center; width: 100%">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="9" Text="Search" OnClick="btnSearch_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" Style="display: none" />
                <div id="colorindication" runat="server">
                    <table style="padding-left: 270px; width: 80%">
                        <tr>
                            <td style="height: 22px">&nbsp;<asp:Button ID="btnSN" runat="server" Width="25px" Height="25px" BackColor="LightBlue"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Pending Approval Purchase Request"
                                Style="cursor: pointer;" OnClick="btnSN_Click" />
                            </td>
                            <td style="text-align: left; height: 22px;">Pending Approval
                            </td>
                            <td style="height: 22px">
                                <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="YellowGreen"
                                    CssClass="ItDoseButton11 circle" ToolTip="Click for Approved Purchase Request"
                                    Style="cursor: pointer;" OnClick="btnRN_Click" />
                            </td>
                            <td style="text-align: left; height: 22px;">Approved
                            </td>
                            <td style="height: 22px">&nbsp;<asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Reject Purchase Request"
                                Style="cursor: pointer;" OnClick="btnNA_Click" />
                            </td>
                            <td style="text-align: left; height: 22px;">Rejected
                            </td>
                            <td style="height: 22px">&nbsp;<asp:Button ID="btnA" runat="server" Width="25px" Height="25px" BackColor="Yellow"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Partial Purchase Request"
                                Style="cursor: pointer;" OnClick="btnA_Click" />
                            </td>
                            <td style="text-align: left; height: 22px; width: 145px;">&nbsp;GRN Done
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="" style="text-align: center;">
                <asp:Panel ID="pnlgv" runat="server">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowDataBound="GridView1_RowDataBound" ToolTip="Please Double click for Request detail"
                        OnRowCommand="GridView1_RowCommand" Width="100%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="PurchaseRequestNo" HeaderText="PR No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="LedgerName" HeaderText="Store">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Subject" HeaderText="Remarks">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="Type">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="status" HeaderText="Status">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Partial" HeaderStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:Label ID="lblPartialSTATUS" Text='<%#Eval("PartialSTATUS") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="RaisedDate" HeaderText="Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Raised user">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="View" HeaderStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                        ImageUrl="~/Images/view.gif" CommandArgument='<%# Eval("PurchaseRequestNo")  %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
    <asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" BorderStyle="None" Height="280px"
        Width="893px" Style="display: none; margin-left: 138px">
        <div class="POuter_Box_Inventory" style="border-style: solid; border-color: inherit; border-width: 1px; height: 278px; overflow-y: scroll; font-size: 7pt; width: 890px;">
            <div class="Purchaseheader">
                Search Results
            </div>
            <table style="width: 89%; height: 260px; border-collapse: collapse">
                <tr>
                    <td style="text-align: center">
                        <strong><span style="font-size: 10pt">Purchase Request Detail </span></strong>
                        <asp:Label ID="lblNotRej" Text="NotRejected" runat="server" ForeColor="Black" BackColor="#99FFCC"
                            Font-Size="XX-Small"></asp:Label>
                        <asp:Label ID="lblRejected" Text="Rejected" runat="server" ForeColor="White" BackColor="#FF99CC"
                            Font-Size="XX-Small"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100%; text-align: center;">
                        <asp:GridView ID="grdItem" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowDataBound="grdItem_RowDataBound" Width="867px">
                            <Columns>
                                <asp:BoundField DataField="PurchaseRequestNo" HeaderText="PR No.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ItemName" HeaderText="Item Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="InHandQty" HeaderText="Available&nbsp;Qty.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ApprovedQty" HeaderText="Quantity">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ApproxRate" HeaderText="Last Rate" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="discount" HeaderText="Discount" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="LedgerName" HeaderText="Last Supplier Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="RaisedUser" HeaderText="Raised User">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Status" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" Text='<%#Eval("PRDStatus") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <asp:Button ID="btnNo" runat="server" CssClass="ItDoseButton" Text="Close" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <asp:Button ID="Button1" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton" />
    <cc1:ModalPopupExtender ID="mdlView" runat="server" CancelControlID="btnNo" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" X="80" Y="120">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlAddGroup" runat="server" CssClass="pnlItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="dragHandle" runat="server">
            Select Report Type
        </div>
        <div class="">
            <asp:Panel ID="PnlAddItem" runat="server">
                <asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal"
                    CssClass="ItDoseRadiobuttonlist">
                    <asp:ListItem Selected="True" Text="PDF" Value="1" />
                    <asp:ListItem Text="Excel" Value="2" />
                </asp:RadioButtonList>
                <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal"
                    CssClass="ItDoseRadiobuttonlist">
                    <asp:ListItem Selected="True" Text="Summary" Value="1" />
                    <asp:ListItem Text="Detail" Value="2" />
                </asp:RadioButtonList>
            </asp:Panel>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnReportDetail" runat="server" CssClass="ItDoseButton" Text="Report"
                OnClick="btnReportDetail_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnReport" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddGroup" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
</asp:Content>
