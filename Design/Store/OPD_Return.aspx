<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPD_Return.aspx.cs" Inherits="Design_Store_OPD_Return" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">


        var onReturnQtyChange = function (elem) {
            var checkbox = $(elem).closest('tr').find('input[type=checkbox]');
            var qty = Number(elem.value);
            if (qty > 0) {
                $(checkbox).prop('checked', true);
                validateItemForReturn(checkbox);
            }
            else {
                $(checkbox).prop('checked', false);
                addReturnAmount(function () { });
            }
        }



        var validateItemForReturn = function (elem) {
            var row = $(elem).closest('tr');
            var returnQuantity = row.find('[id$=txtReturnQty]').val();
            returnQuantity = precise_round(returnQuantity, 2);
            var totalAvilableQuatity = row.find('[id$=lblAvailQty]').text();
            totalAvilableQuatity = precise_round(totalAvilableQuatity, 2);
            if (returnQuantity == 0 || returnQuantity > totalAvilableQuatity) {
                elem.checked = false;
                modelAlert('Refund Quantity Invalid', function () {
                    row.find('[id$=txtReturnQty]').focus();
                    addReturnAmount(function () { });
                });
            }
            else
                addReturnAmount(function () { });

        }
        var addReturnAmount = function (callback) {
            calculateTotalReturnAmount(function (response) {
                if (response.totalBillAmount > 0) {
                    var panelId = $('[id$=lblPanelID]').text().trim();
                    var paymentModeID = 4; //parseInt($('#lblPaymentStatus').attr('PaymentModeID'));
                    $addBillAmount({ panelId: panelId, billAmount: response.totalBillAmount, disCountAmount: response.totalDiscountAmount, isReceipt: false, patientAdvanceAmount: 0, autoPaymentMode:1, refund: { status: true, refundPaymentMode: paymentModeID } }, function () { });
                }
                else
                    $clearPaymentControl(function () { });
            });
        }

        var calculateTotalReturnAmount = function (callback) {
            var totalBillAmount = 0;
            var totalDiscountAmount = 0;
            var returnItemsDetails = [];
            $('#[id$=grdItem] tr td input[type=checkbox]:checked').closest('tr').each(function () {
                var data = {
                    AgainstLedgerTnxNo: $(this).find('[id$=lblTnxNo]').text(),
                    ItemID: $(this).find('[id$=lblItemID]').text(),
                    ItemName: $(this).find('[id$=lblItemName]').text(),
                    BatchNumber: $(this).find('[id$=lblBatchNumber]').text(),
                    Expiry: $(this).find('[id$=lblExpiry]').text(),
                    MRP: $(this).find('[id$=lblMRP]').text(),
                    UnitType: $(this).find('[id$=lblUnitType]').text(),
                    SubCategoryID: $(this).find('[id$=lblSubCategory]').text(),
                    ReturnQty: $(this).find('[id$=txtReturnQty]').val(),
                    StockID: $(this).find('[id$=lblStockID]').text(),
                    grossAmt: $(this).find('[id$=lblGrossAmt]').text(),
                    discountOnTotal: $(this).find('[id$=lblDiscAmtonTotal]').text(),
                    UnitPrice: $(this).find('[id$=lblPerUnitBuyPrice]').text(),
                    IsUsable: $(this).find('[id$=lblIsUsable]').text(),
                    ToBeBilled: $(this).find('[id$=lblToBeBilled]').text(),
                    IsExpirable: $(this).find('[id$=lblIsExpirable]').text(),
                    TaxPercent: $(this).find('[id$=lblTaxPercent]').text(),
                    Type_ID: $(this).find('[id$=lblType_ID]').text(),
                    HSNCode: $(this).find('[id$=lblHSNCode]').text(),
                    IGSTPercent: $(this).find('[id$=lblIGSTPercent]').text(),
                    SGSTPercent: $(this).find('[id$=lblSGSTPercent]').text(),
                    CGSTPercent: $(this).find('[id$=lblCGSTPercent]').text(),
                    GSTType: $(this).find('[id$=lblGSTType]').text(),
                }
                data.Amount = precise_round(data.ReturnQty, 2) * precise_round(data.MRP, 2);
                var discountPercent = (precise_round(data.discountOnTotal, 2) * 100) / data.grossAmt;
                data.DiscAmt = (data.Amount * discountPercent) / 100;
                var govTax = (precise_round($('[id$=lblGovTaxPer]').text(), 2) / 100) * (data.Amount - (data.Amount * discountPercent) / 100);
                data.TaxAmt = govTax;
                totalBillAmount = totalBillAmount + precise_round(data.Amount, 2);
                totalDiscountAmount = totalDiscountAmount + precise_round(data.DiscAmt, 2);
                returnItemsDetails.push(data);
            });
            callback({ returnItemsDetails: returnItemsDetails, totalBillAmount: totalBillAmount, totalDiscountAmount: totalDiscountAmount });
        }

        //function getFloat(value) {
        //    return (Number.isNaN(parseFloat(value)) ? 0.00 : parseFloat(value));
        //}

        var getPharmacyReturnDetails = function (callback) {
            var returnDetails = {
                doctorID: $('[id$=lblDoctorID]').text().trim(),
                panelID: $('[id$=lblPanelID]').text().trim(),
                patientReturnType: $('#lblPatientReturnType').text().trim(),
                IPDNo: $('[id$=lblIPDNo]').text().trim(),
                patientType: $('[id$=lblPatientType]').text().trim(),
                patientID: $('[id$=lblMRNo]').text().trim(),
               
                IsCancel: '<%=rdbpaid.SelectedItem.Value%>',
                hashCode: $('[id$=txtHash]').val().trim(),
                ledgerno: $('[id$=lblLedgerno]').text().trim(),
                receiptno: $('[id$=lblreceiptno]').text().trim(),
                OutCustomerID: $('#lblCustomerId').text().trim()
            };
            returnDetails.returnItems = [];
            $('#[id$=grdItem] tr td input[type=checkbox]:checked').closest('tr').each(function () {
                var data = {
                    AgainstLedgerTnxNo: $(this).find('[id$=lblTnxNo]').text(),
                    ItemID: $(this).find('[id$=lblItemID]').text(),
                    ItemName: $(this).find('[id$=lblItemName]').text(),
                    BatchNumber: $(this).find('[id$=lblBatchNumber]').text(),
                    Expiry: $(this).find('[id$=lblExpiry]').text(),
                    MRP: $(this).find('[id$=lblMRP]').text(),
                    UnitType: $(this).find('[id$=lblUnitType]').text(),
                    SubCategoryID: $(this).find('[id$=lblSubCategory]').text(),
                    ReturnQty: $(this).find('[id$=txtReturnQty]').val(),
                    StockID: $(this).find('[id$=lblStockID]').text(),
                    grossAmt: $(this).find('[id$=lblGrossAmt]').text(),
                    discountOnTotal: $(this).find('[id$=lblDiscAmtonTotal]').text(),
                    IsPackage: $(this).find('[id$=lblIsPackage]').text(),
					discountPercentage: $(this).find('[id$=lblDiscountPercentage]').text(),
                    UnitPrice: $(this).find('[id$=lblPerUnitBuyPrice]').text(),
                    IsUsable: $(this).find('[id$=lblIsUsable]').text(),
                    ToBeBilled: $(this).find('[id$=lblToBeBilled]').text(),
                    IsExpirable: $(this).find('[id$=lblIsExpirable]').text(),
                    TaxPercent: $(this).find('[id$=lblTaxPercent]').text(),
                    Type_ID: $(this).find('[id$=lblType_ID]').text(),
                    HSNCode: $(this).find('[id$=lblHSNCode]').text(),
                    IGSTPercent: $(this).find('[id$=lblIGSTPercent]').text(),
                    SGSTPercent: $(this).find('[id$=lblSGSTPercent]').text(),
                    CGSTPercent: $(this).find('[id$=lblCGSTPercent]').text(),
                    GSTType: $(this).find('[id$=lblGSTType]').text(),
                    refundAgainstBillNo: $(this).find('[id$=lblRefund_Against_BillNo]').text(),
                }
                data.Amount = precise_round(data.ReturnQty, 4) * precise_round(data.MRP, 4);
                var discountPercent = Number(data.discountPercentage);//(precise_round(data.discountOnTotal, 4) * 100) / data.grossAmt;
                data.DiscAmt = precise_round((data.Amount * discountPercent) / 100, 4);
                data.taxPercent = Number($(this).find('[id$=lblSaleTaxPercent]').text());
                data.taxAmt = Number($(this).find('[id$=lblSaleTaxAmount]').text())

                returnDetails.returnItems.push(data);
            });
            callback(returnDetails);
        }


        var getPharmacyReturnPaymentDetails = function (callback) {
            getPharmacyReturnDetails(function (returnDetails) {
                $getPaymentDetails(function (payment) {
                    $PMH = {
                        PatientID: returnDetails.patientID,
                        DoctorID: returnDetails.doctorID,
                        PanelID: returnDetails.panelID,
                        HashCode: returnDetails.hashCode,
                    }

                    $LT = {
                        UniqueHash: returnDetails.hashCode,
                        DiscountOnTotal: payment.discountAmount,
                        Adjustment: payment.adjustment,
                        GrossAmount: payment.billAmount,
                        NetAmount: payment.netAmount,
                        GovTaxAmount: 0,
                        GovTaxPer: 0,
                        DiscountReason: payment.discountReason,
                        DiscountApproveBy: payment.approvedBY,
                        PanelID: returnDetails.panelID,
                        RoundOff: payment.roundOff,
                        //Refund_Against_BillNo: returnDetails.refundAgainstBill,
                        IPNo: returnDetails.IPDNo,
                        PatientType: returnDetails.patientType,
                        IsCancel: returnDetails.IsCancel,
                        Remarks: payment.paymentRemarks
                    }

                    $LTD = []
                    $(returnDetails.returnItems).each(function () {
                        $LTD.push({
                            ItemID: this.ItemID,
                            StockID: this.StockID,
                            SubCategoryID: this.SubCategoryID,
                            Rate: this.MRP,
                            Quantity: this.ReturnQty,
                            ItemName: this.ItemName,
                            BatchNumber: this.BatchNumber,
                            IsReusable: this.IsUsable,
                            ToBeBilled: this.ToBeBilled,
                            medExpiryDate: this.Expiry,
                            PurTaxPer: this.TaxPercent,
                            unitPrice: this.UnitPrice,
                            IGSTPercent: this.IGSTPercent,
                            CGSTPercent: this.CGSTPercent,
                            SGSTPercent: this.SGSTPercent,
                            HSNCode: this.HSNCode,
                            LedgerTransactionNo: this.AgainstLedgerTnxNo,
                            Type_ID: this.Type_ID,
                            GSTType: this.GSTType,
                            IsReusable: this.IsUsable,
                            TaxPercent: this.taxPercent,
                            TaxAmt: precise_round((this.taxAmt * this.ReturnQty), 4),
                            IsPackage: this.IsPackage,
                            DiscountPercentage: this.discountPercentage,
                            Refund_Against_BillNo: this.refundAgainstBillNo,
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

                    var IsCredit=$("#lblIsCredit").text();
                    var PaidAmount=$("#lblAmtPaid").text();
                    var TotalBillNetAmt = $("#lblNetAmt").text();

                    var refundamount = payment.netAmount;
                    if (IsCredit == "1") {
                        refundamount = PaidAmount;
                    }
                     
                    modelConfirmation('Are You Sure To Refund ?', '<b>Amount : ' + refundamount + '</b>', 'Yes Refund', 'No', function (response) {
                        if (response)
                            callback({ patientType: returnDetails.patientReturnType, ledgerno: returnDetails.ledgerno, receiptNo: returnDetails.receiptno, customerID: returnDetails.OutCustomerID, PMH: [$PMH], LT: [$LT], LTD: $LTD, PaymentDetail: $PaymentDetail, IsCredit: IsCredit, PaidAmount: PaidAmount, TotalBillNetAmt: TotalBillNetAmt });

                    });

                });
            });
        }

        var save = function (btnSave) {
            getPharmacyReturnPaymentDetails(function (returnDetails) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('OPD_Return.aspx/Save', returnDetails, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            window.open($responseData.responseURL);
                            location.href = 'OPD_Return.aspx';
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });
                });
            });
        }

    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Return</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <asp:TextBox ID="txtHash" runat="server" CssClass="txtHash" Style="display: none"></asp:TextBox>
            <asp:Label ID="lblOPDPharmacyReturn" runat="server" Style="display: none"></asp:Label>
            <div style="text-align: center;">
                <%--   <asp:RadioButtonList ID="rdoReturn" runat="server" style="display:none" CssClass="ItDoseRadiobuttonlist"
                    RepeatDirection="Horizontal" RepeatLayout="Flow" AutoPostBack="True"
                    OnSelectedIndexChanged="rdoReturn_SelectedIndexChanged">
                    <asp:ListItem Selected="True" Value="OPD">OPD Patient Return</asp:ListItem>
                    <asp:ListItem Value="GENERAL">WalkIn Patient Return</asp:ListItem>
                </asp:RadioButtonList>--%>
                
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Receipt No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReceiptNo" AutoCompleteType="Disabled" CssClass="requiredField" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Bill No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillNo" AutoCompleteType="Disabled" CssClass="requiredField" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Emergency No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmergencyNo" AutoCompleteType="Disabled" CssClass="requiredField" runat="server"></asp:TextBox>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">IPD No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" AutoCompleteType="Disabled" CssClass="requiredField" runat="server"></asp:TextBox>
                        </div>
                         </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>


                     <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24 textCenter">
                       <asp:Button ID="btnSearch" runat="server" CssClass="save margin-top-on-btn" Text="Search" OnClick="btnSearch_Click" />
                </div>
            </div>
</div>

        <asp:Panel ID="pnlInfo" runat="server">
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
                                <asp:Label ID="lblMRNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Patient Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:Label ID="lblLedgerno" runat="server" Style="display: none"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Contact No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblContactNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Net Amt.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblNetAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                                <asp:Label ID="lblCustomerId" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp" Style="display: none"></asp:Label>
                                <asp:Label ID="lblRefund_Against_BillNo" runat="server" CssClass="ItDoseLabelSp"  style="display:none" ></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Age</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblAge" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Amount Paid :</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:Label ID="lblIsCredit" runat="server" CssClass="ItDoseLabelSp" Style="display: none" Text="0" ClientIDMode="Static"> </asp:Label>
                               
                                <asp:Label ID="lblAmtPaid" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                                <asp:Label ID="lblreceiptno" runat="server" Style="display: none"></asp:Label>
                                <asp:Label ID="lblDoctorID" runat="server" CssClass="ItDoseLabelSp" Style="display: none"></asp:Label>
                                <asp:Label ID="lblPanelID" runat="server" CssClass="ItDoseLabelSp" Style="display: none"></asp:Label>
                                <asp:Label ID="lblPatientReturnType" ClientIDMode="Static" runat="server" CssClass="ItDoseLabelSp" Style="display: none"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Address</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblAddress" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Balance</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblBalAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:Label ID="lblAppBy" runat="server" CssClass="ItDoseLabel" Visible="false"></asp:Label>
                                <asp:Label ID="lblDiscReason" runat="server" CssClass="ItDoseLabel" Visible="false"></asp:Label>
                                <asp:Label ID="lblGovTaxAmt" runat="server" Visible="false" CssClass="ItDoseLabel"></asp:Label>
                                <asp:Label ID="lblGovTaxPer" runat="server" Style="display: none" CssClass="ItDoseLabel"></asp:Label>
                                <asp:Label ID="lblPatientType" runat="server"  Style="display: none" ClientIDMode="Static" CssClass="ItDoseLabel"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Payment Status :</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblPaymentStatus" ClientIDMode="Static" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:RadioButtonList ID="rdbpaid" Visible="false" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobutton">
                                    <asp:ListItem Text="Paid" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Unpaid" Value="2"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">IPD No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblIPDNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:GridView ID="grdItem" TabIndex="3" runat="server" Width="100%" CssClass="GridViewStyle" AutoGenerateColumns="False">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField
                                HeaderText="Bill No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblBillNo" runat="server" Text='<%# Eval("BillNo") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Item Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Batch">
                                <ItemTemplate>
                                    <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Expiry">
                                <ItemTemplate>
                                    <%#Eval("MedExpiryDate")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField
                                HeaderText="MRP">
                                <ItemTemplate>
                                    <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Avail Qty.">
                                <ItemTemplate>
                                    <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvlQty") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Unit">
                                <ItemTemplate>
                                    <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="100px" HeaderText="Return Qty.">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReturnQty" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField" onlynumber="10" decimalplace="4" onkeyup="onReturnQtyChange(this)" max-value='<%# Eval("AvlQty") %>'></asp:TextBox>
                                    <asp:Label ID="lblTnxNo" runat="server" Text='<%# Eval("LedgerTransactionNo") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblExpiry" runat="server" Text='<%# Eval("MedExpiryDate") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblGrossAmt" runat="server" Text='<%# Eval("GrossAmount") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblDiscAmtonTotal" runat="server" Text='<%# Eval("DiscountOnTotal") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblIsPackage" runat="server" Text='<%# Eval("IsPackage") %>' Style="display: none"></asp:Label>
									 <asp:Label ID="lblDiscountPercentage" runat="server" Text='<%# Eval("DiscountPercentage") %>' style="display:none"></asp:Label>
                                    <asp:Label ID="lblPerUnitBuyPrice" runat="server" Text='<%# Eval("PerUnitBuyPrice") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblIsUsable" runat="server" Text='<%# Eval("IsUsable") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblToBeBilled" runat="server" Text='<%# Eval("ToBeBilled") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblType_ID" runat="server" Text='<%# Eval("Type_ID") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblServiceItemID" runat="server" Text='<%# Eval("ServiceItemID") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblTaxPercent" runat="server" Text='<%# Eval("TaxPercent") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblIGSTPercent" runat="server" Text='<%# Eval("IGSTPercent") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblSGSTPercent" runat="server" Text='<%# Eval("SGSTPercent") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblCGSTPercent" runat="server" Text='<%# Eval("CGSTPercent") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblGSTType" runat="server" Text='<%# Eval("GSTType") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblSaleTaxPercent" runat="server" Text='<%# Eval("SaleTaxPercent") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblSaleTaxAmount" runat="server" Text='<%# Eval("SaleTaxAmount") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblRefund_Against_BillNo" runat="server" Text='<%# Eval("BillNo") %>'  style="display:none" ></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" onclick="validateItemForReturn(this)" runat="Server" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
        <div id="divPaymentControlParent" runat="server" style="display: none" class="POuter_Box_Inventory">
            <div id="divPaymentUserControl" runat="server"></div>
            <%--<div class="row" style="margin: 0px">
                    <div class="col-md-15"></div>
                    <div class="col-md-9">
                        <div class="row" style="margin-top: 0px">
                            <div class="col-md-7">
                                <label class="pull-left">
                                    Return  Reason
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-17">
                                <input type="text" id="txtRefundReason" class="requiredField" autocomplete="off" />
                            </div>
                        </div>
                    </div>
                </div>--%>
        </div>
        <div id="divSave" style="display: none; text-align: center" runat="server" class="POuter_Box_Inventory">
            <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" onclick="save(this);" />
        </div>
    </div>


    <style type="text/css">
        #divPaymentControlParent {
            border: none;
        }
    </style>
</asp:Content>
