<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPD_Refund.aspx.cs" Inherits="Design_OPD_OPD_Refund" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="Content1">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        var validateItemForRefund = function (elem) {
            addRemoveRegstrationCharges();
            var row = $(elem).closest('tr');
            var refundQuantity = row.find('[id$=txtQuantity]').val();
            var totalQuatity = row.find('[id$=lblQuantity]').text();
            var itemID = row.find('[id$=lblItemID]').text().trim();
            var configID = row.find('[id$=lblConfigID]').text().trim();
            var ledgerTransactionNo = $('[id$=lblCRNumber]').attr('LedgerTransactionNo').trim();
            var ledgerTnxID = row.find('[id$=lblLedgerTnxID]').text().trim();
            totalQuatity = parseFloat(totalQuatity);
            refundQuantity = parseFloat(String.isNullOrEmpty(refundQuantity) ? 0 : refundQuantity);
            if (refundQuantity == 0 || refundQuantity > totalQuatity) {
                elem.checked = false;
                modelAlert('Refund Quantity Invalid', function () {
                    row.find('[id$=txtQuantity]').focus();
                    addRefundAmount(function () { });
                });
            }
            else {
               
                var data = {
                    itemID: itemID,
                    ledgerTransactionNo: ledgerTransactionNo,
                    configID: parseInt(configID),
                    ledgerTnxID: ledgerTnxID
                }

                validateRefund(data, function (response) {
                    if (response.status)
                        addRefundAmount(function () { });
                    else {
                        elem.checked = false;
                        modelAlert('Refund Not Possiable On This Item', function () {
                            addRefundAmount(function () { });
                        });
                    }
                });

                //checkIsSampleCollected(itemID, ledgerTransactionNo, function (response) {
                //    if (!response)
                //        addRefundAmount(function () { });
                //    else {
                //        elem.checked = false;
                //        modelAlert('Refund Not Possiable On This Item', function () {
                //            addRefundAmount(function () { });
                //        });
                //    }
                //});
            }
        }


        var validateRefund = function (itemDetails, callback) {
            if (itemDetails.configID == 3) {
                checkIsSampleCollected(itemDetails.itemID, itemDetails.ledgerTransactionNo, function (response) {
                    callback({ status: !response });
                });
            }
            else if (itemDetails.configID == 5) {
                if (location.search != '') {
                    callback({ status: true });
                }
                else {
                    checkAppointmentConsulted(itemDetails.ledgerTnxID, function (response) {
                        callback({ status: !response });
                    });
                }
            }
            else {
                callback({ status: true });
            }
        }


        var addRefundAmount = function (callback) {
            calculateTotalRefundAmount(function (refund) {
                if (refund.totalAmount > 0) {
                    var panelID = parseInt($('[id$=lblDoctor]').attr('Panel_ID'));
                    var paymentModeID = parseInt($('[id$=lblDoctor]').attr('PaymentModeID'));
                    $addBillAmount({ panelId: panelID, billAmount: refund.totalAmount, disCountAmount: refund.discountAmount, isReceipt: true, patientAdvanceAmount: 0, refund: { status: true, refundPaymentMode: paymentModeID } }, function () { });
                }
                else
                    $clearPaymentControl(function () { });
            });
        }


        var calculateTotalRefundAmount = function (callback) {
            var totalAmount = 0;
            var discountAmount = 0;
            $('#[id$=grdItemRate] tr td input[type=checkbox]:checked').closest('tr').each(function () {
                var refundQuantity = parseFloat($(this).find('[id$=txtQuantity]').val());
                if (refundQuantity > 0) {
                    var rate = parseFloat($(this).find('[id$=txtRate]').val());
                    discountAmount += parseFloat($(this).find('[id$=txtDisc]').val());
                    totalAmount += parseFloat(refundQuantity * rate);
                    //discountAmount += (totalAmount * discountPercent / 100);

                }
            });
            callback({ totalAmount: totalAmount, discountAmount: discountAmount });
        }

        var checkIsSampleCollected = function (itemID, ledgerTransactionNo, callback) {
            serverCall('OPD_Refund.aspx/IsSampleCollected', { itemID: itemID, ledgerTransactionNo: ledgerTransactionNo }, function (response) {
                callback(response);
            });
        }



        var checkAppointmentConsulted = function (ledgerTnxID, callback) {
            serverCall('OPD_Refund.aspx/IsConsulted', { ledgerTnxID: ledgerTnxID }, function (response) {
                callback(response);
            });
        }

        var getRefundDetails = function (callback) {
            var refundDetails = {};
            refundDetails.patientID = $('[id$=lblCRNumber]').text().trim();
            refundDetails.doctorID = $('[id$=lblDoctor]').attr('Doctor_ID').trim();
            refundDetails.panelID = $('[id$=lblDoctor]').attr('Panel_ID').trim();
            refundDetails.IPDNo = $('[id$=lblIPDNo]').text();
            refundDetails.transactionID = $('[id$=lblCRNumber]').attr('Transaction_ID').trim();
            refundDetails.ledgerTransactionNo = $('[id$=lblCRNumber]').attr('LedgerTransactionNo').trim();
            refundDetails.scheduleChargeID = $('[id$=lblCRNumber]').attr('ScheduleChargeID').trim();
            refundDetails.receiptNo = $('[id$=lblCRNumber]').attr('ReceiptNo').trim();
            refundDetails.refundAgainstBill = $('#lblRefundAgainstBill').text().trim();
            refundDetails.patientType = $('[id$=lblPatientType]').text().trim();
            refundDetails.currentAge = $('[id$=lblDOB]').text().trim();
            refundDetails.hashCode = $('[id$=txtHash]').val().trim();
            refundDetails.refundReason = $('#txtRefundReason').val().trim();
            refundDetails.ApprovedBY = $('#ddlControlApprovedBY').val().trim();
            refundDetails.refundItems = [];
            $('#[id$=grdItemRate] tr td input[type=checkbox]:checked').closest('tr').each(function () {
                refundDetails.refundItems.push({
                    itemID: $(this).find('[id$=lblItemID]').text(),
                    subCategoryID: $(this).find('[id$=lblSubCategoryID]').text(),
                    itemName: $(this).find('[id$=lblItemName]').text(),
                    rate: $(this).find('[id$=txtRate]').val(),
                    quantity: $(this).find('[id$=txtQuantity]').val(),
                    discountPercentage: $(this).find('[id$=lblDisPer]').text(),
                    discAmt: $(this).find('[id$=txtDisc]').val(),
                    totalDiscAmt: $(this).find('[id$=txtDisc]').val(),
                    amount: $(this).find('[id$=lblAmt]').text(),
                    netItemAmt: $(this).find('[id$=lblAmt]').text(),
                    configID: $(this).find('[id$=lblConfigID]').text(),
                    tnxTypeID: $(this).find('[id$=lblTnxTypeID]').text(),
                    typeOfTnx: $(this).find('[id$=lblTypeOfTnx]').text(),
                    transactionTypeID: $(this).find('[id$=lblTransactionTypeID]').text(),
                    ledgerTnxID: $(this).find('[id$=lblLedgerTnxID]').text()
                });
            });
            if (refundDetails.refundItems.length < 1) {
                modelAlert('Please Select Refund Items');
                return false;
            }
            callback(refundDetails);
        }



        var getRefundPaymentDetails = function (callback) {
            getRefundDetails(function (refundDetails) {
                $getPaymentDetails(function (payment) {
                    $PMH = {
                        PatientID: refundDetails.patientID,
                        DoctorID: refundDetails.doctorID,
                        PanelID: refundDetails.panelID,
                        HashCode: refundDetails.hashCode,
                        ScheduleChargeID: refundDetails.scheduleChargeID
                    }
                    $LT = {
                        UniqueHash: refundDetails.hashCode,
                        TypeOfTnx: refundDetails.refundItems[0].typeOfTnx,
                        DiscountOnTotal: payment.discountAmount,
                        Adjustment: payment.adjustment,
                        GrossAmount: payment.billAmount,
                        NetAmount: payment.netAmount,
                        GovTaxAmount: 0,
                        GovTaxPer: 0,
                        DiscountReason: payment.discountReason,
                        DiscountApproveBy: refundDetails.ApprovedBY,
                        PanelID: refundDetails.panelID,
                        TransactionID: refundDetails.transactionID,
                        PatientID: refundDetails.patientID,
                        TransactionType_ID: refundDetails.refundItems[0].transactionTypeID,
                        RoundOff: payment.roundOff,
                        Refund_Against_BillNo: refundDetails.refundAgainstBill,
                        IPNo: refundDetails.IPDNo,
                        PatientType: refundDetails.patientType,
                        CurrentAge: refundDetails.currentAge,
                    }
                    $LTD = []
                    $(refundDetails.refundItems).each(function () {
                        $LTD.push({
                            ItemID: this.itemID,
                            SubCategoryID: this.subCategoryID,
                            ItemName: this.itemName,
                            Rate: this.rate,
                            Quantity: this.quantity,
                            DiscountPercentage: this.discountPercentage,
                            DiscAmt: this.discAmt,
                            TotalDiscAmt: this.totalDiscAmt,
                            Amount: this.amount,
                            NetItemAmt: this.netItemAmt,
                            ConfigID: this.configID,
                            TnxTypeID: this.tnxTypeID,
                            TypeOfTnx: this.typeOfTnx,
                            TransactionTypeID: this.transactionTypeID,
                            LedgerTnxID: this.ledgerTnxID,
                            DoctorID: refundDetails.doctorID,
                            LedgerTransactionNo:refundDetails.ledgerTransactionNo
                        });
                    });
                    $PaymentDetail = [];
                    $(payment.paymentDetails).each(function () {
                        $PaymentDetail.push({
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
                            PaymentRemarks: payment.paymentRemarks,
                            swipeMachine: this.swipeMachine,
                            currencyRoundOff: payment.currencyRoundOff / payment.paymentDetails.length
                        });
                    });
                    if ($PaymentDetail.length < 1) {
                        modelAlert('Please Select Atleast One Payment Mode');
                        return false;
                    }
                    if (refundDetails.ApprovedBY== "0") {
                        modelAlert('Please Select Approved By', function () {
                            $('#ddlControlApprovedBY').focus();
                        });
                        return false;
                    }
                    if (String.isNullOrEmpty(refundDetails.refundReason)) {
                        modelAlert('Please Enter Refund Reason', function () {
                            $('#txtRefundReason').focus();
                        });
                        return false;
                    }

                    if ($LT.Adjustment != $LT.NetAmount) {
                        modelAlert('Please Enter Full Amount', function () { });
                        return false;
                    }



                    modelConfirmation('Are You Sure To Refund ?', '<b>Amount : ' + payment.adjustment + '</b>', 'Yes Refund', 'No', function (response) {
                        if (response)
                            callback({ PMH: [$PMH], LT: [$LT], LTD: $LTD, PaymentDetail: $PaymentDetail, oldLedgerTransactionNo: refundDetails.ledgerTransactionNo, oldReceiptNo: refundDetails.receiptNo, refundReason: refundDetails.refundReason });

                    });
                });
            });
        }


        var save = function (btnSave) {
            getRefundPaymentDetails(function (refundDetails) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('OPD_Refund.aspx/SaveRefund', refundDetails, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                                if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0") {
                                    if ($responseData.isReceipt)
                                        window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&Duplicate=0');
                                    else
                                        window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=1&Duplicate=0');
                                } else {
                                    if ($responseData.isReceipt)
                                        window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=0&Duplicate=0&Type=OPD');
                                    else
                                        window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=1&Duplicate=0&Type=OPD');
                                }
                            if (location.search.split('&').length > 1){
                                $PID = location.search.split('&')[1].split('=')[1];
                                location.href = 'BookDirectAppointment.aspx?PID=' + $PID;
                            }
                            else
                                location.href = 'OPD_Refund.aspx';
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });
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
        });


        var validateRegistrationItem = function () {
            $RegItemId = '<%=Resources.Resource.RegistrationItemID%>';
            $('#[id$=grdItemRate] tr').each(function () {
                $itemId = $(this).find('[id$=lblItemID]').text();
                //if ($RegItemId == $itemId)
                //    $(this).find('input[type=checkbox],[id$=txtQuantity]').attr('disabled', 'disabled');

            });

        }
        var addRemoveRegstrationCharges = function () {
            var i = 0;
            var j = 0;
            $RegItemId = '<%=Resources.Resource.RegistrationItemID%>';
            $('#[id$=grdItemRate] tr').each(function () {
                $itemId = $(this).find('[id$=lblItemID]').text();
                if ($RegItemId != $itemId) {
                    i++;
                    if ($(this).find('input[type=checkbox]').prop('checked'))
                        j++;
                    }
            });
            $('#[id$=grdItemRate] tr').each(function () {
                $itemId = $(this).find('[id$=lblItemID]').text();
                if ($RegItemId == $itemId) {
                    if ((i-1) == j)
                        $(this).find('input[type=checkbox]').attr('checked', 'checked');
                    else
                        $(this).find('input[type=checkbox]').removeAttr('checked');

                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Receipt Refund</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server"></asp:TextBox>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Patient Details</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Receipt No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtRecipt" TabIndex="1" runat="server" CssClass="requiredField" AutoCompleteType="Disabled" OnTextChanged="txtBarCode_TextChanged"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="fteRec" FilterMode="InvalidChars" TargetControlID="txtRecipt" InvalidChars="'" runat="server"></cc1:FilteredTextBoxExtender>
                    </div>
                    <div style="display:none" class="col-md-3">
                        <label class="pull-left">
                            Bill No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div style="display:none" class="col-md-5">
                        <asp:TextBox ID="txtBillNo" TabIndex="1" runat="server" CssClass="requiredField" AutoCompleteType="Disabled" OnTextChanged="txtBarCode_TextChanged"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" FilterMode="InvalidChars" TargetControlID="txtBillNo" InvalidChars="'" runat="server"></cc1:FilteredTextBoxExtender>
                    </div>

                    <div class="col-md-1">
                        <asp:Label ID="lblOPDRefund" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblRefundAgainstBill" runat="server" ClientIDMode="Static" style="display:none" ></asp:Label>
                        <asp:TextBox ID="txtBarcode" runat="server" AutoCompleteType="Disabled" OnTextChanged="txtBarCode_TextChanged" TabIndex="1" Width="200px" Visible="false"></asp:TextBox>
                        <asp:Button ID="btnSearch" TabIndex="3" OnClick="btnSearch_Click" runat="server" CssClass="ItDoseButton" Text="Search"></asp:Button>
                    </div>
                    <%-- <div class="col-md-2">
                        <b class="pull-right">:</b>
                        <label class="pull-right">
                            <b>Note</b>
                        </label>
                    </div>
                    <div style="color: red" class="col-md-13">
                        OPD Package And Appointment Receipt is No Refundable only Cancellation is Possible
                    </div>--%>
                </div>
            </div>
        </div>
        <div id="divToggle" runat="server" visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Details
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">UHID</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblCRNumber" CssClass="ItDoseLabelSp pull-left" runat="server"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Patient Name </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblName" CssClass="ItDoseLabelSp pull-left" runat="server"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Age</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblDOB" CssClass="ItDoseLabelSp pull-left" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Amount</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblAmount" CssClass="ItDoseLabelSp pull-left" runat="server"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Doctor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblDoctor" CssClass="ItDoseLabelSp pull-left" runat="server"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">IPD No. </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblPatientType" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblIPDNo" CssClass="ItDoseLabelSp pull-left" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <br />
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Prescribed Items
                </div>
                <asp:GridView ID="grdItemRate" Width="100%" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowDataBound="grdItemRate_RowDataBound" TabIndex="7">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="ItemName" HeaderText="Investigation">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Date" HeaderText="Date">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Quantity">
                            <ItemTemplate>
                                <asp:TextBox AccessKey="q" ID="txtQuantity" runat="server" Width="65px" Text='<%# Eval("Quantity") %>' onlynumber="10" onkeyup="addRefundAmount(function () { });" max-value='<%# Eval("Quantity") %>' CssClass="ItDoseTextinputNum" TabIndex="7" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtQuantity" />
                                <asp:RequiredFieldValidator ID="rq1" runat="server" Display="None" Text="*" ErrorMessage="Specify Quantity" SetFocusOnError="true" ControlToValidate="txtQuantity" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rate">
                            <ItemTemplate>
                                <asp:TextBox ID="txtRate" ClientIDMode="Static" runat="server" Text='<%# Eval("Rate") %>' Width="70px" CssClass="ItDoseTextinputNum" AccessKey="r" TabIndex="8" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom,Numbers" ValidChars="." TargetControlID="txtRate" />
                                <asp:RequiredFieldValidator ID="rq2" runat="server" Display="None" Text="*" ErrorMessage="Specify Rate" SetFocusOnError="true" ControlToValidate="txtRate" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc.">
                            <ItemTemplate>
                                <asp:TextBox ID="txtDisc" runat="server" Text='<%# Eval("DiscAmt") %>' Width="70px" ReadOnly="true" CssClass="ItDoseTextinputNum"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax" Visible="false">
                            <ItemTemplate>
                                <asp:TextBox ID="txtAmt" runat="server" Text='<%# Eval("Amount") %>' Width="70px" ReadOnly="true" CssClass="ItDoseTextinputNum"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Label ID="lblAmt" runat="server" Text='<%# Eval("Amount") %>' Style="display: none"></asp:Label>
                                <asp:CheckBox ID="chkItem" runat="server" onclick="validateItemForRefund(this);" /> <%--Enabled='<%# Util.GetBoolean(Eval("IsRefund")) %>' />--%>
                                <asp:Label runat="server" ID="lblLedgerTnxID" Text='<%# Eval("LedgerTnxID") %>' Style="display: none" />
                                <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("Quantity") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblTypeOfTnx" runat="server" Text='<%# Eval("TypeOfTnx") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblTransactionTypeID" runat="server" Text='<%# Eval("TransactionTypeID") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblDisPer" runat="server" Text='<%# Eval("DiscountPercentage") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblGovTaxPercentage" runat="server" Text='<%# Eval("GovTaxPer") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblDiscounApproveBy" runat="server" Text='<%# Eval("DiscountApproveBy") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblDiscountReson" runat="server" Text='<%# Eval("DiscountReason") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblTnxTypeID" runat="server" Text='<%# Eval("TnxTypeID") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblConfigID" runat="server" Text='<%# Eval("ConfigID") %>' Style="display: none"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div id="divPaymentControlParent" runat="server" class="POuter_Box_Inventory">
                <div id="divPaymentUserControl" runat="server"></div>
                <div class="row" style="margin: 0px">
                    <div class="col-md-15"></div>
                    <div class="col-md-9">
                        <div class="row" style="margin-top: 0px">
                            <div class="col-md-7">
                                <label class="pull-left">
                                    Refund  Reason
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-17">
                                <input type="text" id="txtRefundReason" class="requiredField" autocomplete="off" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div id="divSave" runat="server" class="POuter_Box_Inventory" style="text-align: center">
                <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" onclick="save(this);" />
            </div>
        </div>
    </div>

    <style type="text/css">
        #divPaymentControlParent {
            border: none;
        }
    </style>

</asp:Content>
