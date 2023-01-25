<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DuplicateReceipt.aspx.cs"
    Inherits="Design_OPD_DuplicateReceipt" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="content1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnView').attr('disabled', 'disabled');
                        $('#<%=GridView1.ClientID %>').hide();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnView').removeAttr('disabled');
                    }
                }
            });

        }
        function validatespace() {
            var card = $('#<%=txtPatientName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtPatientName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                return true;
            }

        }
        $(function () {
            chkType();
            $('input[type=text]').keyup(function () {
                if (event.keyCode == 13)
                    $('#btnView').click();
            });
        });
        function chkType() {


            var rblValue = $('#<%=rblCon.ClientID %> input[type=radio]:checked').val();
            if (rblValue == "1") {
                //$("#txtReceiptNo").val('').attr('disabled', 'disabled');
                $("#txtBillNo").val('').removeAttr('disabled');
            }
            else {
                $("#txtReceiptNo").val('').removeAttr('disabled');
                //$("#txtBillNo").val('').attr('disabled', 'disabled');
            }
        }
        
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Receipt Re-Print</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            <table style="text-align: center; width: 100%;">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>


                        <asp:RadioButtonList ID="rblCon"  runat="server" RepeatColumns="2" OnSelectedIndexChanged="btnView_Click" AutoPostBack="true" RepeatDirection="Horizontal" onclick="chkType()">
                            <asp:ListItem Text="Bill"  Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Receipt" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Receipt No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReceiptNo" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter Receipt No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillNo" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Enter Bill No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRegNo" AutoCompleteType="Disabled" runat="server" TabIndex="4" ToolTip="Enter UHID"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server"
                                TabIndex="3" ToolTip="Enter Patient Name" AutoCompleteType="Disabled"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date"
                                ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server"  ClientIDMode="Static" TabIndex="6"
                            ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnView" runat="server" CssClass="ItDoseButton"
                TabIndex="7" Text="Search" OnClick="btnView_Click" ClientIDMode="Static"
                ToolTip="Click To Search" /> &nbsp;&nbsp;
              <asp:Button ID="btnPrintCombined" runat="server" CssClass="ItDoseButton" Visible="false"
                TabIndex="7" Text="Print Combined Bill" OnClick="btnPrintCombined_Click" ClientIDMode="Static"
                ToolTip="Click To Search" />

        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Details Found
                </div>
                <div style="overflow: auto; padding: 3px; height: 340px;">
                    <asp:GridView ID="GridView1" Width="100%" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" ShowFooter="true"
                        AllowPaging="False" OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDataBound="GridView1_RowDataBound" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>

                             <asp:BoundField DataField="Type" HeaderText="Type">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            </asp:BoundField>

                             <asp:TemplateField HeaderText="UHID">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="PName" HeaderText="Patient Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:BoundField>

                             <asp:TemplateField HeaderText="Panel">
                                <ItemTemplate>
                                    <asp:Label ID="lblPanelName" runat="server" Text='<%# Eval("PanelName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="Address" HeaderText="Address">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                            </asp:BoundField>

                            <asp:TemplateField HeaderText="Receipt No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblReceiptNo" runat="server" Text='<%# Eval("ReceiptNo") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bill No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblBillNo" runat="server" Text='<%# Eval("BillNo") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:BoundField DataField="Date" HeaderText="Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AmountPaid" HeaderText="Bill Amount">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Print">
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="rbtformat" runat="server" Enabled='<%# Util.GetBoolean(Util.GetString(Eval("ConfigID")) == "5" ? "True" : "False")%>'
                                        RepeatDirection="Horizontal" RepeatColumns="2">
                                        <asp:ListItem Selected="True" Value="0"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="OPD Card"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                               <asp:TemplateField HeaderText="Original">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkAllowedOriginalPrint" runat="server" Enabled='<%# Util.GetBoolean(Eval("IsAllowedOriginalPrint")) %>'  />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>

                            <asp:CommandField HeaderText="Print" ShowSelectButton="True" ButtonType="Image" SelectImageUrl="~//Images/Post.gif">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="30px" HorizontalAlign="Center" />
                            </asp:CommandField>

                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblPaymentMode" runat="server" Text='<%# Eval("PaymentMode") %>' Visible="False"></asp:Label>
                                    <asp:Label ID="lblTID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                                    <asp:Label ID="lblPID" runat="server" Text='<%# Eval("depositor") %>'></asp:Label>
                                    <asp:Label ID="lblTypeofTnx" runat="server" Text='<%# Eval("TypeOfTnx") %>'></asp:Label>
                                    <asp:Label ID="lblLedgerNoCr" runat="server" Text='<%# Eval("LedgerNoCr") %>'></asp:Label>
                                    <asp:Label ID="lblDoctorID" runat="server" Text='<%# Eval("DoctorID") %>'></asp:Label>
                                    <asp:Label ID="lblLedgerTransactionNo" runat="server" Text='<%# Eval("LedgerTransactionNo") %>'></asp:Label>

                                    <asp:Label ID="lblCombinedID" runat="server" Text='<%# Eval("CombinedID") %>'></asp:Label>

                                </ItemTemplate>
                            </asp:TemplateField>

                                <asp:TemplateField HeaderText="Combined">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkCombinedPrint" runat="server" Enabled='<%# Util.GetBoolean(Eval("IsCombinedPrint")) %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
