<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CanteenSearchSales.aspx.cs" Inherits="Design_Kitchen_CanteenSearchSales" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/searchableDroplist.js"></script>
    <script type="text/javascript">
        var _oldColor;

        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#387C44';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }

        function ShowPO(PONo) {
            window.open(PONo);
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.searchable').searchable();
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
                        modelAlert('To date can not be less than from date!');
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
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true" EnableScriptLocalization="true"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Search Sales</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <table style="text-align: center; width: 100%">
                <tr>
                    <td>
                        <asp:RadioButtonList ID="rblCon" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" onclick="chkType()" align="center">
                            <asp:ListItem Text="Bill" Selected="True"  Value="1"></asp:ListItem>
                            <asp:ListItem Text="Receipt" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 13%"></td>
                    <td style="width: 31%"></td>
                    <td style="width: 16%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                </tr>
                <tr style="display: none;">
                    <td style="width: 13%; text-align: right;">MR No. :&nbsp;</td>
                    <td style="width: 31%">
                        <asp:TextBox ID="txtRegNo" runat="server" Width="250px" TabIndex="1"> </asp:TextBox>
                    </td>
                    <td style="width: 16%; text-align: right;">Name :&nbsp;</td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtName" runat="server" TabIndex="2" Width="250px" AutoCompleteType="Disabled"> </asp:TextBox>
                    </td>
                    <td style="width: 20%">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 13%; text-align: right;">Type :&nbsp;</td>
                    <td style="width: 31%">
                        <asp:DropDownList ID="ddlType" Width="250px" runat="server" TabIndex="3">
                            <asp:ListItem Text="All" Value="All"></asp:ListItem>
                            <asp:ListItem Text="Issue" Value="Canteen-Issue"></asp:ListItem>
                            <asp:ListItem Text="Return" Value="Canteen-Return"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="width: 16%; text-align: right; display: none;">Panel :&nbsp;</td>
                    <td style="width: 20%; display: none;">
                        <asp:DropDownList ID="ddlPanel" runat="server" Width="250px" TabIndex="4"></asp:DropDownList>
                    </td>
                    <td style="width: 20%">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 13%; text-align: right;">User :&nbsp;</td>
                    <td style="width: 31%">
                        <asp:DropDownList ID="ddlUser" runat="server" Width="250px" TabIndex="5"   />
                    </td>
                    <td style="width: 16%; text-align: right;">Item :&nbsp;</td>
                    <td style="width: 20%">
                        <asp:DropDownList ID="ddlItem" runat="server" Width="250px" TabIndex="6"  ></asp:DropDownList>
                    </td>
                    <td style="width: 20%">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 13%; text-align: right;">Bill No. :&nbsp;</td>
                    <td style="width: 31%">
                        <asp:TextBox ID="txtBillNo" runat="server" Width="250px" TabIndex="7"></asp:TextBox>
                    </td>
                    <td style="width: 16%; text-align: right;">Receipt No. :&nbsp;</td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtReceiptNo" runat="server" Width="250px" TabIndex="8"></asp:TextBox>
                    </td>
                    <td style="width: 20%">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 13%; text-align: right;">From Date :&nbsp;</td>
                    <td style="width: 31%">
                        <asp:TextBox ID="txtFromDate" runat="server" Width="250px" ClientIDMode="Static" TabIndex="9" ToolTip="Click o Select From Date" />
                        <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 16%; text-align: right;">To Date :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="10" ToolTip="Click To Select To Date" Width="250px" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%">&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 13%;text-align:right">Time :&nbsp;</td>
                    <td style="width: 31%"> <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="250px" ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" 
                                TargetControlID="txtFromTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator></td>
                    <td style="width: 16%;text-align:right">Time :&nbsp;</td>
                    <td style="width: 40%" colspan="2">
                         <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="250px" ToolTip="Enter Time"
                                            TabIndex="4" />
                                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                            TargetControlID="txtToTime" AcceptAMPM="true">
                                        </cc1:MaskedEditExtender>
                                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        <asp:RadioButtonList ID="rblSearch" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Style="display: none;">
                            <asp:ListItem Text="ALL" Value="ALL"></asp:ListItem>
                            <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                            <asp:ListItem Text="WalkIn" Value="Walk" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 100%; text-align: center">
                <tr>
                    <td style="width: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #afeeee;"></td>
                    <td style="text-align: left; width: 110px">Canteen-Issue</td>
                    <td style="width: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #fafad2;"></td>
                    <td style="text-align: left; width: 120px">Canteen-Return</td>
                    <td style="width: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;"></td>
                    <td style="text-align: left; width: 102px;">Settlement</td>
                    <td style="width: 60px;">
                        <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" OnClick="btnSearch_Click" TabIndex="9" />
                    </td>
                    <td style="width: 60px;">
                        <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" />
                    </td>
                    <td style="width: 60px;"></td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div>
                <asp:GridView ID="grdCash" runat="server" CssClass="GridViewStyle" OnRowDataBound="grdCash_RowDataBound" AutoGenerateColumns="False" ToolTip="Double Click to Print">
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
                        <asp:TemplateField HeaderText="Label" Visible="false">
                            <ItemTemplate>
                                <img src="../../Images/print.gif" alt="Print" style="cursor: pointer" title="Click To Print Label" id="btnimgPrint" onclick="BindPopUp(this);" />
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
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Receipt No.">
                            <ItemTemplate>
                                <%# Eval("ReceiptNo")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bill No.">
                            <ItemTemplate>
                                <%# Eval("BillNo")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MR No." Visible="false">
                            <ItemTemplate>
                                <%# Eval("Patient_ID")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <%# Eval("PName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Age" Visible="false">
                            <ItemTemplate>
                                <%# Eval("Age")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <%# Eval("TypeOfTnx")%>
                                <asp:Label ID="lblItemname" ClientIDMode="Static" Style="display: none" runat="server" Text='<%# Eval("itemname") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
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
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <asp:Panel ID="pnlAddGroup" runat="server" CssClass="pnlItemsFilter" Style="display: none;" Width="300px">
            <div class="Purchaseheader" id="dragHandle" runat="server">
                Select Report Type
            </div>
            <div>
                <asp:Panel ID="PnlAddItem" runat="server">
                    <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist">
                        <asp:ListItem Value="1" Selected="True">Item Wise</asp:ListItem>
                        <asp:ListItem Text="Detail" Value="2" />
                    </asp:RadioButtonList>
                </asp:Panel>
            </div>
            <div class="filterOpDiv">
                <asp:Button ID="btnReportDetail" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReportDetail_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
            DropShadow="true" TargetControlID="btnReport" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlAddGroup" PopupDragHandleControlID="dragHandle">
        </cc1:ModalPopupExtender>
        <cc1:ModalPopupExtender ID="meLabel" runat="server" CancelControlID="btnCancelLabel" PopupControlID="pnlLabel"
            TargetControlID="btnhide" BehaviorID="mpePrint" DropShadow="true" BackgroundCssClass="filterPupupBackground" X="200" Y="100">
        </cc1:ModalPopupExtender>
    </div>
    <asp:Panel runat="server" ID="pnlLabel" Width="820px" Height="400px" Style="display: none" CssClass="pnlVendorItemsFilter" ScrollBars="Auto">
        <uc2:wuc_PrintPharmacyLabel ID="PrintLabel" runat="server" />
        <asp:Button ID="btnhide" runat="server" Style="display: none" />
    </asp:Panel>
    <script type="text/javascript">
        function BindPopUp(LedgerTnxNo) {
            var LedgertransactionNo = $(LedgerTnxNo).closest('tr').find("span[id*=lblLedgerTransactionNo]").text();
            $find("mpePrint").show();
            BindOPDPopUp(LedgertransactionNo);
        }
    </script>
</asp:Content>
