<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MortuaryReceiptBill.aspx.cs" Inherits="Design_IPD_ReceiptBill"
    MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/Controls/wuc_IpdAdvance.ascx" TagName="PaymentControl"
    TagPrefix="uc" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">
        #divPaymentControlParent {
            border: none;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=rdbAdmitted.ClientID%>').change(function () {
                $('#grdhide,#gdhide,#hide').hide();
            });
            $paymentControlInit(function () { });
        });
        $(document).ready(function () {
            $('#<%=rdbDischarged.ClientID%>').change(function () {
                $('#grdhide,#gdhide,#hide').hide();
            });
        });
        function validateView() {
            if ($('#<%=txtCorpseNo.ClientID%>').val().trim() == "" && $('#<%=txtDepositeNo.ClientID%>').val().trim() == "" && $('#<%=txtCorpseName.ClientID%>').val().trim() == "") {
                $('#<%=lblMsg.ClientID%>').text('Please Enter any one Search Criteria');
                $('#<%=txtDepositeNo.ClientID%>').focus();
                $('#grdhide,#gdhide,#hide').hide();
                return false;
            }
        }
        var onAmountChange = function (value) { 
            if ($('#<%=lblIsRefund.ClientID%>').text().trim() == "1") {
                var AdvancePaidAmt = $('#<%=lblPaidAmt.ClientID%>').text();
                var TotalBillAmt = $('#<%=lblTotalBill_Amt.ClientID%>').text();

                var RemainAmount = parseFloat(AdvancePaidAmt) - parseFloat(TotalBillAmt);
                var currententeramt = $('#<%=txtReceiveAmount.ClientID%>').val();

                if (RemainAmount == 0.00) {
                    modelAlert('Remain Amount should be Greater Than Zero');
                    $('#<%=txtReceiveAmount.ClientID%>').val('');
                return false;
                }

            if (currententeramt > RemainAmount) {
                modelAlert('You Can not Enter Amount Greater than Remain Bill Amount');
                $('#<%=txtReceiveAmount.ClientID%>').val('');
                return false;
            }

        }



            var amount = String.isNullOrEmpty(value) ? 0 : value;
            $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '0' ? true : false;
            $autoPaymentMode = '<%=Resources.Resource.IsReceipt%>' == '0' ? false : true;
            var isrefund = $('#<%=lblIsRefund.ClientID%>').text().trim() == '1' ? true : false;
            var panelID = '<%=Util.GetInt(ViewState["Panel_ID"])%>';
            var refund = { status: isrefund, refundPaymentMode: 1 };
            $addBillAmount({
                panelId: panelID,
                billAmount: amount,
                disCountAmount: 0,
                isReceipt: $isReceipt,
                disableDiscount: true,
                autoPaymentMode: $autoPaymentMode,
                patientAdvanceAmount: 0,
                refund: refund
            }, function () { });
        }
        var save = function (btnSave) {
            getIPDAdvanceRefundPaymentDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('MortuaryReceiptBill.aspx/SaveMortuaryDetail', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            window.open($responseData.responseURL);
                            window.location.href = 'MortuaryReceiptBill.aspx';
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }
        var getIPDAdvanceRefundDetails = function (callback) {
            var data = {
                hashCodes: $('#<%=txtHash.ClientID%>').val(),
                IsRefund: $('#<%=lblIsRefund.ClientID%>').text().trim(),
                transactionNo: $('#<%=lblTransaction_ID.ClientID%>').text().trim(),
                isAdmitted: $('#<%=rdbAdmitted.ClientID %>').prop('checked'),
                hospLedger: $('#divHospitalLedger').find('input[type=radio]:checked').val().trim(),
                CorpseNo: $('#<%=lblCorpseNo.ClientID%>').text().trim(),
                FreezerNo: $('#<%=lblFreezer.ClientID%>').text().trim(),
                doctorName: $('#<%=lblDoctor.ClientID%>').text().trim(),
                CorpseName: $('#<%=lblCorpseName.ClientID%>').text().trim(),
                panelName: $('#<%=lblPanelComp.ClientID%>').text().trim(),
                paymentReceivedFrom: $('#txtPaymentReceivedFrom').val().trim()
            }
            callback(data);
        }

        var getIPDAdvanceRefundPaymentDetails = function (callback) {
            getIPDAdvanceRefundDetails(function (advanceRefundDetails) {
                $getPaymentDetails(function (payment) {
                    advanceRefundDetails.totalPaidAmount = payment.adjustment;
                    advanceRefundDetails.paymentRemarks = payment.paymentRemarks;
                    advanceRefundDetails.paymentDetail = [];
                    $(payment.paymentDetails).each(function () {
                        advanceRefundDetails.paymentDetail.push({
                            PaymentMode: this.PaymentMode,
                            PaymentModeID: this.PaymentModeID,
                            S_Amount: this.S_Amount,
                            S_Currency: this.S_Currency,
                            S_CountryID: this.S_CountryID,
                            BankName: this.BankName,
                            RefNo: this.RefNo,
                            BaceCurrency: this.BaceCurrency,
                            C_Factor: this.C_Factor,
                            Amount: this.Amount,
                            S_Notation: this.S_Notation,
                            PaymentRemarks: this.paymentRemarks,
                            swipeMachine: this.swipeMachine,
                            currencyRoundOff: payment.currencyRoundOff / payment.paymentDetails.length
                        });
                    });
                    console.log(advanceRefundDetails);
                    if (advanceRefundDetails.paymentDetail.length < 1) {
                        modelAlert('Please Select Atleast One Payment Mode');
                        return false;
                    }
                    //if (String.isNullOrEmpty(advanceRefundDetails.paymentReceivedFrom)) {
                    //    modelAlert('Please Enter Payment Received From', function () {
                    //        $('#txtPaymentReceivedFrom').focus();
                    //    });
                    //    return false;
                    //}
                    if (advanceRefundDetails.IsRefund == '1') {
                        modelConfirmation('Are You Sure To Refund ?', '<b>Amount : ' + advanceRefundDetails.totalPaidAmount + '</b>', 'Yes Refund', 'No', function (response) {
                            if (response)
                                callback(advanceRefundDetails);
                        });
                    }
                    else
                        callback(advanceRefundDetails);
                });
            });
        }

        $(function () {
            shortcut.add("Alt+S", function () {
                var btnSave = $('#btnSave');
                if (!String.isNullOrEmpty(btnSave)) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        save(btnSave);
                    }
                }
            }, addShortCutOptions);
            $('#<%=chkHospLedger.ClientID %>').change(function () {
                var id = $(this).find('input[type=radio]:checked').attr('id');
                if ($("label[for=" + id + "]").text() == "ADVANCE-COL") {
                    $('#<%=chkRefund.ClientID %>').prop("checked", false);
                    $('#<%=lblIsRefund.ClientID%>').text("0");
                }
                else if ($("label[for=" + id + "]").text() == "IPD-REFUND") {
                    $('#<%=chkRefund.ClientID %>').prop("checked", true);
                    $('#<%=lblIsRefund.ClientID%>').text("1");
                }
            });
        });
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Mortuary Receipt</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" Style="display: none"></asp:TextBox>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" style="text-align: center;">
                        <span style="font-size: 8pt; color: #54a0c0; font-family: Verdana">
                            <asp:RadioButton ID="rdbAdmitted" runat="server" Checked="True" CssClass="ItDoseLabelSp"
                                Font-Bold="True" Font-Names="Verdana" Font-Size="Small" GroupName="Same" Text="Deposited" />
                            &nbsp;
                            <asp:RadioButton ID="rdbDischarged" runat="server" Font-Bold="True" Font-Names="Verdana"
                                Font-Size="Small" GroupName="Same" Text="Released" CssClass="ItDoseLabelSp" /></span>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Deposite No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDepositeNo" runat="server" AutoCompleteType="Disabled" TabIndex="1" ToolTip="Enter Deposite No." MaxLength="15"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbeDepositeNo" runat="server" FilterType="Numbers" TargetControlID="txtDepositeNo">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Corpse Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCorpseName" runat="server" AutoCompleteType="Disabled" TabIndex="2" ToolTip="Enter Corpse Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Corpse No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCorpseNo" runat="server" AutoCompleteType="Disabled" TabIndex="3" ToolTip="Enter Corpse No."></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnView" runat="server" CssClass="ItDoseButton" OnClick="btnView_Click"
                TabIndex="4" Text="Search" OnClientClick="return validateView()" ToolTip="Click To Search Corpse Details" />
        </div>
        <div id="grdhide">
            <asp:Panel ID="pnlRecord" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Corpse Record Found&nbsp;
                    </div>
                    <div style="padding: 3px; overflow: auto; max-height: 100px; text-align: center">
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Corpse_ID" HeaderText="Corpse No">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DepositeNo" HeaderText="Deposite No">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CName" HeaderText="Name">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PatientType" HeaderText="Patient Type">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="FreezerName" HeaderText="Freezer">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Company_Name" HeaderText="Panel">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:BoundField>
                                <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPanelID" runat="server" Text='<%# Eval("Panel_ID")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAddress" runat="server" Text='<%# Eval("Address") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:CommandField ButtonType="Image" HeaderText="Select" SelectImageUrl="~/Images/Post.gif"
                                    ShowSelectButton="True">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:CommandField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
        </div>
        <div id="gdhide">
            <asp:Panel ID="pnlDetails" runat="server" Visible="false">
                <asp:Label ID="lblIPDAdvance" runat="server" Style="display: none"></asp:Label>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Receipt Details&nbsp;
                    </div>
                    <asp:Panel ID="Panel1" runat="server">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Corpse&nbsp;Name</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblCorpseName" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Deposite No.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblTransaction_ID" runat="server" Style="display: none;" ClientIDMode="Static"></asp:Label>
                                        <asp:Label ID="lblDepositeNo" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Corpse No.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblCorpseNo" runat="server" CssClass="ItDoseLabelSp pull-left" ClientIDMode="Static"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Freezer No.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblFreezer" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Doctor</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblDoctor" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Date of Deposite</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblDepositeDate" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Address</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblCAddress" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Paid Amt.</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPaidAmt" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Panel</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Bill Amt. </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblTotalBill_Amt" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                                        <asp:Label ID="lblIsRefund" runat="server" Style="display: none"></asp:Label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Bill Account </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div id="divHospitalLedger" class="col-md-14">
                                        <asp:RadioButtonList ID="chkHospLedger" runat="server" RepeatDirection="Horizontal" onclick="HospLedger();">
                                        </asp:RadioButtonList>
                                        <asp:CheckBox ID="chkRefund" runat="server" Text="Refund" class="clRefund" Style="display: none" />
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">Amount </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-3">
                                        <asp:TextBox ID="txtReceiveAmount" AutoComplete="off" onlynumber="10" onkeyup="onAmountChange(this.value)" CssClass="ItDoseTextinputNum" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="col-md-2">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <table style="width: 100%; display: none">
                            <tr>
                                <td style="text-align: left">
                                    <uc:PaymentControl ID="PaymentControl" runat="server" />
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%; display: none;">
                            <tr>
                                <td style="width: 15%; text-align: right"></td>
                                <td align="left" style="width: 18%"></td>
                                <td style="width: 15%; text-align: right">Received From :&nbsp;
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtReceivedFrom" runat="server" Width="240px"
                                        MaxLength="50"></asp:TextBox>
                                    <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                    <%--<asp:RequiredFieldValidator ID="reqRec" runat="server" ValidationGroup="save" ControlToValidate="txtReceivedFrom"
                                    SetFocusOnError="true" Display="None"></asp:RequiredFieldValidator>--%>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 15%; text-align: right"></td>
                                <td align="left" style="width: 18%"></td>
                                <td style="width: 15%; text-align: right">Remarks :&nbsp;
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtRemarks" runat="server" Width="240px"
                                        MaxLength="100"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
                <div class="POuter_Box_Inventory">
                    <div style="width: 100%" id="paymentControlDiv">
                        <UC2:PaymentControl ID="paymentControl1" runat="server" />
                    </div>
                    <div class="row" style="margin: 0px">
                        <div class="col-md-15"></div>
                        <div class="col-md-9">
                            <div class="row" style="margin-top: 0px">
                                <div class="col-md-7">
                                    <label class="pull-left">Received From  </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-17">
                                    <input type="text" id="txtPaymentReceivedFrom" autocomplete="off" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <input type="button" style="width: 100px; margin-top: 7px" id="btnSaveMorchary" class="ItDoseButton" value="Save" onclick="save(this)" />

                </div>
            </asp:Panel>
        </div>
        <asp:Panel ID="pnlAdvHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Patient Advance Detail
                </div>
                <div id="hide">
                    <asp:GridView ID="grdReceipt" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="Receipt No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblReceipt" runat="server" Text='<%# Eval("ReceiptNo") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amount Paid">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmountPaid" runat="server" Text='<%# Eval("AmountPaid") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time">
                                <ItemTemplate>
                                    <asp:Label ID="lblType" runat="server" Text='<%# Eval("Time") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Receiver">
                                <ItemTemplate>
                                    <asp:Label ID="lblType" runat="server" Text='<%# Eval("Receiver") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="170px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <%--<asp:TemplateField HeaderText="PayMode">
                        <ItemTemplate>
                            <asp:Label ID="lblPayMode" runat="server" Text='<%# Eval("IsCheque_Draft") %>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblType" runat="server" Text='<%# Eval("Type") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
