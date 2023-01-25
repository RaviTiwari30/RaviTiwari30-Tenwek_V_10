<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchSales.aspx.cs" Inherits="Design_Store_SearchSales"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#387C44';
        }
        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(ledTxnID) {
            //window.open(PONo);
            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + ledTxnID + '&IsBill=0&Duplicate=1&Type=PHY');
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
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
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function clickAll(id) {
            $("#<%=grdCash.ClientID %>").find("input[id*=chkSelect]").attr("checked", id.checked);
        }
        $(function () {
            chkType();
        });
        function chkType() {
            var rblValue = $('#<%=rblCon.ClientID %> input[type=radio]:checked').val();
            if (rblValue == "1") {
                $('#<%=txtBillNo.ClientID %>').attr('disabled', false);
                $('#<%=txtReceiptNo.ClientID %>').val('').attr('disabled', true);
            }
            else {


                $('#<%=txtBillNo.ClientID %>').val('').attr('disabled', true);
                $('#<%=txtReceiptNo.ClientID %>').attr('disabled', false);
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Search Sales</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <table style="text-align: center; width: 100%">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rblCon" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" onclick="chkType()">
                            <asp:ListItem Text="Bill"  Value="1"></asp:ListItem>
                            <asp:ListItem Text="Receipt" Selected="True" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRegNo" runat="server" Width=""
                                TabIndex="1"> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" TabIndex="2"
                                Width="" AutoCompleteType="Disabled"> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlType" Width="" runat="server" TabIndex="3">
                                <asp:ListItem Text="All" Value="All">
                                </asp:ListItem>
                                <asp:ListItem Text="Issue" Value="Pharmacy-Issue">
                                </asp:ListItem>
                                <asp:ListItem Text="Return" Value="Pharmacy-Return">
                                </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" Width="" TabIndex="4">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                User
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUser" runat="server" Width="" TabIndex="5" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlItem" runat="server" Width="" TabIndex="6">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillNo" runat="server" Width="" TabIndex="7"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Receipt No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReceiptNo" runat="server" Width="" TabIndex="8"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Mobile No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMobile" MaxLength="12" onlyNumber="13" runat="server" Width="" TabIndex="7"></asp:TextBox>
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
                            <asp:TextBox ID="txtFromDate" runat="server" Width="" ClientIDMode="Static" TabIndex="9" ToolTip="Click o Select From Date" />
                            <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"
                                TabIndex="10" ToolTip="Click To Select To Date" Width="" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:RadioButtonList ID="rblSearch" runat="server" RepeatColumns="3" RepeatDirection="Horizontal">
                            <asp:ListItem Text="ALL" Selected="True" Value="ALL"></asp:ListItem>
                            <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                            <asp:ListItem Text="WalkIn" Value="Walk"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10"></div>
                         <div class="col-md-3">
                              <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server"
                            OnClick="btnSearch_Click" TabIndex="9" />
                         </div>
                         <div class="col-md-3">
                              <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" />
                         </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-6">
                        </div>
                         <div class="col-md-4">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #afeeee;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Pharmacy-Issue</b> 
                        </div>
                         <div class="col-md-4">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #fafad2;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Pharmacy-Return</b> 
                        </div>
                         <div class="col-md-4">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: pink;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Settlement</b> 
                        </div>
                         <div class="col-md-4">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: rgb(14 184 66 / 53%);"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Label Print</b> 
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdCash" runat="server" CssClass="GridViewStyle" OnRowDataBound="grdCash_RowDataBound"
                    AutoGenerateColumns="False" ToolTip="Double Click to Print" Width="100%">
                    <Columns>
                        <asp:TemplateField Visible="false">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkAll" runat="server" onClick="clickAll(this);" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Label">
                            <ItemTemplate>

                                <img src="../../Images/print.gif" alt="Print" style="cursor: pointer; <%#Eval("CanPrintLable").ToString()=="0"? "display:none;": ""%>" title="Click To Print Label" id="btnimgPrint" onclick="BindPopUp(this);" />
                                <asp:Label ID="lblLedgerTransactionNo" Style="display: none" runat="server" Text='<%# Eval("LedgerTransactionNo") %>'></asp:Label>

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <%# Eval("Date")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Receipt No.">
                            <ItemTemplate>
                                <asp:Label ID="lblReceiptNo" runat="server" Text='<%# Eval("ReceiptNo") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bill No.">
                            <ItemTemplate>
                                <%# Eval("BillNo")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Payment">
                            <ItemTemplate>
                                <%# Eval("PaymentStatus")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <%# Eval("PatientID")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <%# Eval("PName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="230px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Age">
                            <ItemTemplate>
                                <%# Eval("Age")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>

                          <asp:TemplateField HeaderText="Panel">
                            <ItemTemplate>
                                <%# Eval("Panel")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <%# Eval("TypeOfTnx")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Net Amount">
                            <ItemTemplate>
                                <b>
                                    <%# Eval("NetAmount")%>
                                </b>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="65px" />
                        </asp:TemplateField>
                        <asp:TemplateField Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblLedgertnxno" runat="server" Text='<%# Eval("LedgerTransactionNo") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblTypeOfTnxCon" runat="server" Text='<%# Eval("TypeOfTnxCon") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransactionID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="IsLabelPrint" Visible="false">
                            <ItemTemplate>
                                <%# Eval("IsLablePrint")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            
        </div>

         <uc2:wuc_PrintPharmacyLabel ID="PrintLabel" runat="server" />

        <asp:Panel ID="pnlAddGroup" runat="server" CssClass="pnlItemsFilter" Style="display: none;"
            Width="300px">
            <div class="Purchaseheader" id="dragHandle" runat="server">
                Select Report Type
            </div>
            <div>
                <asp:Panel ID="PnlAddItem" runat="server">
                    <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal"
                        CssClass="ItDoseRadiobuttonlist">
                        <asp:ListItem Value="1" Selected="True">Item Wise</asp:ListItem>
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
       <%-- <cc1:ModalPopupExtender ID="meLabel" runat="server" CancelControlID="btnCancelLabel" PopupControlID="pnlLabel"
            TargetControlID="btnhide" BehaviorID="mpePrint" DropShadow="true" BackgroundCssClass="filterPupupBackground" X="200" Y="100">
        </cc1:ModalPopupExtender>--%>
    
    
    </div>
   <%-- <asp:Panel runat="server" ID="pnlLabel" Width="820px" Height="400px" Style="display: none" CssClass="pnlVendorItemsFilter" ScrollBars="Auto">
        <uc2:wuc_PrintPharmacyLabel ID="PrintLabel" runat="server" />
        <asp:Button ID="btnhide" runat="server" Style="display: none" />
    </asp:Panel>--%>
    <script type="text/javascript">
        function BindPopUp(LedgerTnxNo) {
            var LedgertransactionNo = $(LedgerTnxNo).closest('tr').find("span[id*=lblLedgerTransactionNo]").text();
           // $find("mpePrint").show();
            BindOPDPopUp(LedgertransactionNo);
            showLabelPrintPopup(function () { });
        }
    </script>
</asp:Content>
