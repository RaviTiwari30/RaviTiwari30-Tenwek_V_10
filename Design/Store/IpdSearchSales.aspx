<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IpdSearchSales.aspx.cs" Inherits="Design_Store_IpdSearchSales"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
    <script type="text/javascript" >

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
    <script type="text/javascript" >
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

    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>IPD Patient Search Sales</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRegNo" runat="server" Width="" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">IPD No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="10" CssClass="ItDoseTextinputText" Width="" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="2" Width="" AutoCompleteType="Disabled"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlType" Width="" runat="server" TabIndex="3">
                                    <asp:ListItem Text="All" Value="All">
                                    </asp:ListItem>
                                    <asp:ListItem Text="Issue" Value="Sales">
                                    </asp:ListItem>
                                    <asp:ListItem Text="Return" Value="Patient-Return">
                                    </asp:ListItem>
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" Width="" TabIndex="4" ToolTip="Select Panel"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">User</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUser" runat="server" Width="" TabIndex="5" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="7" ToolTip="Click o Select From Date" Width="" CssClass="ItDoseTextinputText" />
                                <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtToDate" runat="server" CssClass="ItDoseTextinputText" ClientIDMode="Static"  Width=""
                                    TabIndex="8" ToolTip="Click To Select To Date" />
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                                    Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Item</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlItem" runat="server" Width="" TabIndex="6"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server"
                OnClick="btnSearch_Click" TabIndex="9" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div>
                <asp:GridView ID="grdCash" runat="server" CssClass="GridViewStyle" OnRowDataBound="grdCash_RowDataBound"
                    AutoGenerateColumns="False" ToolTip="Double Click to Print" Width="100%">
                    <Columns>
                         <asp:TemplateField HeaderText="Label">
                            <ItemTemplate>

                                <img src="../../Images/print.gif" alt="Print" style="cursor: pointer; <%#Eval("CanPrintLable").ToString()=="0"? "display:none;": ""%>" title="Click To Print Label" id="btnimgPrint" onclick="BindPopUp(this);" />
                                <asp:Label ID="lblLedgerTransactionNo" Style="display: none" runat="server" Text='<%# Eval("LedgerTransactionNo") %>'></asp:Label>
                                 <asp:Label ID="lblIndentNo" Style="display: none" runat="server" Text='<%# Eval("IndentNo") %>'></asp:Label>

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

                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemTemplate>
                                <%# Eval("TransactionID")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <%# Eval("PatientID")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Bill No.">
                            <ItemTemplate>
                                <%# Eval("BillNo")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <%# Eval("PName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Age">
                            <ItemTemplate>
                                <%# Eval("Age")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <%# Eval("TypeOfTnx")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Dispenser">
                            <ItemTemplate>
                                <%# Eval("Dispenser")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bill Amount">
                            <ItemTemplate>
                                <b><%# Eval("GrossAmount")%>    </b>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                        </asp:TemplateField>
                        <asp:TemplateField  Visible="false">
                            <ItemTemplate>
                                <b><%# Eval("LedgerTransactionNo")%>    </b>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                        </asp:TemplateField>
                         <asp:TemplateField  Visible="false">
                            <ItemTemplate>
                                <b><%# Eval("DeptLedgerNo")%>    </b>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                        </asp:TemplateField>
                        
                    </Columns>
                </asp:GridView>
            </div>
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
    </div>
     <script type="text/javascript">
         function BindPopUp(LedgerTnxNo) {
            var LedgertransactionNo = $(LedgerTnxNo).closest('tr').find("span[id*=lblLedgerTransactionNo]").text();
             var IndentNo = $(LedgerTnxNo).closest('tr').find("span[id*=lblIndentNo]").text();
             // $find("mpePrint").show();

             var NewID = LedgertransactionNo + "#" + IndentNo;

             BindIPDPopUp(NewID);
             showLabelPrintPopup(function () { });
         }
    </script>
</asp:Content>
