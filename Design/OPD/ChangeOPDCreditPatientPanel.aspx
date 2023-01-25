<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangeOPDCreditPatientPanel.aspx.cs" Inherits="Design_OPD_ChangeOPDCreditPatientPanel" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            bindPanel();
            $paymentControlInit(function () { });
            $("#txtFromDate").change(function () {
                ChkDate();
            });

            $("#txtToDate").change(function () {
                ChkDate();
            });

            $("#btnSearch").click(function () {
                $("#divSearch,#divBillDetail,#divUpdate,#divCommand,#paymentControlDiv").hide();
                $("#divItemDetail,#divPatient").empty();
                $("#lblErrorMsg").text("");
                $("#btnSearch").val("Searching...").attr("disabled", false);
                $.ajax({
                    url: "ChangeOPDCreditPatientPanel.aspx/Search",
                    data: '{Barcode:"' + $.trim($('#txtBarcode').val()) + '",billNo:"' + $.trim($("#txtBillNo").val()) + '",mrNo:"' + $.trim($('#txtMRNo').val()) + '",fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        patientDetail = $.parseJSON(result.d);
                        if (result.d != "0" && patientDetail != null) {
                            var htmlOutput = $("#scrptSearch").parseTemplate(patientDetail);
                            $("#divPatient").html(htmlOutput);
                            $("#divPatient,#divSearch").show();
                        }
                        else {
                            $("#divPatient").html("");
                            $("#divPatient,#divSearch").hide();
                            modelAlert('Record Not Found');
                        }
                        $("#btnSearch").val("Search").attr("disabled", false);
                    },
                    error: function (xhr, status) {
                        $("#btnSearch").val("Search").attr("disabled", false);
                    }
                });
            });

            $("#ddlPanelCompany").change(function () {
                if ($(this).val() != "0") {
                    bindBillDetails();
                    var diffAmt = $.trim($("#sndDiffAmtActual").text());
                    if (parseFloat(diffAmt) > 0)
                        onAmountChange($.trim($("#sndDiffAmtActual").text()), true);
                    else
                        onAmountChange($.trim($("#sndDiffAmtActual").text()), false);
                }
            });

            $("#btnUpdate").click(function () {
            
                var flag = false;

                var policyNo = "";
                var expiryDate = "";

                if ($("#ddlPanelCompany").val() == "0") {
                    $("#lblErrorMsg").text("Please Select Proposed Panel");
                    $("#ddlPanelCompany").focus();
                    flag = true;
           }

                $("#tblItems tr").not(":first").each(function () {
                    var row = $(this).closest("tr");
                    if (parseFloat(row.find("#tdProRate").text()) == 0) {
                        flag = true;
                        return false;
                    }
                });

                if (flag) {
                    $("#lblErrorMsg").text("Rate is Not Set Under this Panel. Please Contact EDP to Set Rate");
                }


                if (flag) {
                    $("#btnUpdate").val("Update").attr("disabled", false);
                    return;
                }

               
                var userID = $("#lblUserID").text();
                var resultBill = new Array();
                $("#tblItems tr").not(":first").each(function () {
                    var dataObj = {};
                    dataObj.PatientID = $("#spnMRNo").text();
                    dataObj.TransactionID = $("#spnTransactionID").text();
                    dataObj.OldPanelID = $("#spnPanelID").text();
                    dataObj.PolicyNo = $.trim($("#txtPolicy").val());
                    dataObj.ExpiryDate = $("#txtExpiryDate").val();;
                    dataObj.StaffID = $.trim($("#txtStaffID").val());
                    dataObj.CardNo = $.trim($("#txtCardNo").val());
                    dataObj.CardHolder = $.trim($("#txtCardHolderName").val());
                    if ($("#ddlHolderRelation").val() != "0") {
                        dataObj.CardHolderRelation = $("#ddlHolderRelation").val();
                    }
                    else {
                        dataObj.CardHolderRelation = "";
                    }
                    dataObj.OldAmount = $("#spnCurrentAmt").text().split(":")[1];
                    dataObj.NewAmount = $("#spnProposedAmt").text().split(":")[1];
                    dataObj.AmtDiff = $("#SpnDiffAmt").text().split(":")[1];


                    dataObj.BillNo = $("#spnBillNo").text();
                    dataObj.LedgerTnxNo = $("#spnLedgerTnxNo").text();
                    dataObj.PanelID = $("#ddlPanelCompany").val().split("#")[0];
                    dataObj.ScheduleChargeID = $(this).find("#tdScheduleChargeID").text();
                    dataObj.ItemID = $(this).find("#tdItemID").text();
                    dataObj.Rate = $(this).find("#tdProRate").text();
                    dataObj.Quantity = $(this).find("#tdQty").text();
                    dataObj.DiscAmt = $(this).find("#tdProDiscAmt").text();
                    dataObj.TypeOfTnx = $("#spnTypeOfTnx").text();
                    dataObj.LedgerTnxID = $(this).find("#tdLedgerTnxID").text();
                    resultBill.push(dataObj);
                });

                var PaidAmt = 0;
                var PaymentDetail = new Array();
                $getPaymentDetails(function (payment) {
                    $(payment.paymentDetails).each(function () {
                        PaidAmt = PaidAmt + this.S_Amount;
                        var objPayment = {};
                        objPayment.PaymentMode = this.PaymentMode;
                        objPayment.PaymentModeID = this.PaymentModeID;
                        objPayment.S_Amount = this.S_Amount;
                        objPayment.S_Currency = this.S_Currency;
                        objPayment.S_CountryID = this.S_CountryID;
                        objPayment.BankName = this.BankName;
                        objPayment.RefNo = this.RefNo;
                        objPayment.BaceCurrency = this.BaceCurrency;
                        objPayment.C_Factor = this.C_Factor;
                        objPayment.Amount = this.Amount;
                        objPayment.S_Notation = this.S_Notation;
                        objPayment.PaymentRemarks = this.paymentRemarks;
                        objPayment.swipeMachine = this.swipeMachine;
                        objPayment.currencyRoundOff = payment.currencyRoundOff / payment.paymentDetails.length;
                        PaymentDetail.push(objPayment);
                    });
                    if (PaymentDetail.length < 1) {
                        modelAlert('Please Select Atleast One Payment Mode');
                        return false;
                    }
                    $("#btnUpdate").val("Submitting...").attr("disabled", true);
                    var ReceiptAmt = 0;
                    var ReceiptAmtwithRound = PaidAmt;

                    ReceiptAmt = Math.round(PaidAmt).toFixed(0);
                    var RecRoundOff = ReceiptAmtwithRound - ReceiptAmt;
                    $.ajax({
                        url: "ChangeOPDCreditPatientPanel.aspx/UpdatePanel",
                        data: JSON.stringify({ dataBill: resultBill, userID: userID, PaymentData: PaymentDetail, ReceiptAmt: ReceiptAmt, RecRoundOff: RecRoundOff }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        async: false,
                        dataType: "json",
                        success: function (result) {
                            ReturnType = jQuery.parseJSON(result.d);
                            if (ReturnType.status) {
                                modelAlert(ReturnType.response, function () {
                                    if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                                        window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + ReturnType.LedgerTransacTionNo + '&IsBill=' + ReturnType.IsBillGenerate + '&ReceiptNo=' + ReturnType.RecNo + '&IsOPDTariffChange=1&Duplicate=0');
                                    else
                                        window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + ReturnType.LedgerTransacTionNo + '&IsBill=' + ReturnType.IsBillGenerate + '&ReceiptNo=' + ReturnType.RecNo + '&IsOPDTariffChange=1&Duplicate=0');
                                    window.location.reload();
                                    // clearControls();
                                });

                            }
                            else {
                                modelAlert('Record Not Updated');
                            }
                            $("#btnUpdate").val("Update").attr("disabled", false);
                        },
                        error: function (xhr, status) {
                            $("#btnUpdate").val("Update").attr("disabled", false);
                        }
                    });

                });

            });
        });

        function editDetails(img) {
            var row = $(img).closest("tr");
            var ledgerTnxNo = $(row).find("#tdLedgerTransactionNo").text();

            $("#spnMRNo").text($(row).find("#tdMRNo").text());
            $("#spnName").text($(row).find("#tdName").text());
            $("#spnBillNo").text($(row).find("#tdBillNo").text());
            $("#spnBillDate").text($(row).find("#tdBillDate").text());
            $("#spnPanel").text($(row).find("#tdPanel").text());
            $("#spnPanelID").text($(row).find("#tdPanelID").text());
            $("#spnLedgerTnxNo").text(ledgerTnxNo);
            $("#spnTransactionID").text($(row).find("#tdTransactionID").text());
            $("#spnTypeOfTnx").text($(row).find("#tdTypeOfTnx").text());
            $("#spnBalanceAmt").text($(row).find("#tdBalanceAmt").text());
            $("#ddlPanelCompany option").filter(function () { return $(this).text().toUpperCase() == $("#spnPanel").text().toUpperCase(); }).attr("selected", true);

            $("#txtExpiryDate").val("");

            bindBillDetails();
        }

        function bindBillDetails() {
            $.ajax({
                url: "ChangeOPDCreditPatientPanel.aspx/SearchBillDetails",
                data: '{ledgerTnxNo:"' + $("#spnLedgerTnxNo").text() + '",panelID:"' + $("#ddlPanelCompany").val().split("#")[0] + '",referenceCodeOPD:"' + $("#ddlPanelCompany").val().split("#")[1] + '",typeOfTnx:"' + $("#spnTypeOfTnx").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    billDetail = $.parseJSON(result.d);
                    if (result.d != "0" && billDetail != null) {
                        var htmlOutput = $("#scrptItemDetail").parseTemplate(patientDetail);
                        $("#divItemDetail").html(htmlOutput);
                        $("#divBillDetail,#divItemDetail,#divUpdate,#divCommand").show();
                        $("#divSearch,#divPatient").hide();
                        $("#divPatient").empty();
                        var currentAmt = 0.0;
                        var proposedAmt = 0.0;
                        var diffAmt = 0.0;

                        $("#tblItems tr").not(":first").each(function () {
                            currentAmt += parseFloat($(this).closest("tr").find("#tdExAmt").text());
                            proposedAmt += parseFloat($(this).closest("tr").find("#tdProAmt").text());
                            diffAmt += parseFloat($(this).closest("tr").find("#tdDiffAmt").text());
                        });

                        $("#spnCurrentAmt").text("Current Gross Total : " + Math.round(currentAmt).toFixed(2));
                        $("#spnProposedAmt").text("Proposed Gross Total : " + Math.round(proposedAmt).toFixed(2));
                        $("#SpnDiffAmt").text("Total Gross Diff Amt : " + Math.round(diffAmt).toFixed(2));
                        $("#sndDiffAmtActual").text(Math.round(billDetail[0].Adjustment).toFixed(2));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindPanel() {
            var ddlPanel = $("#ddlPanelCompany");
            $("#ddlPanelCompany option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/bindPanel",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    panel = jQuery.parseJSON(result.d);
                    if (panel != null) {
                        $("#ddlPanelCompany").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < panel.length; i++) {
                                $("#ddlPanelCompany").append($("<option></option>").val(panel[i].PanelID + "#" + panel[i].ReferenceCodeOPD + "#" + panel[i].applyCreditLimit).html(panel[i].Company_Name));
                            }
                        $("#ddlPanelCompany").chosen({ width: '100%' });
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function clearControls() {
            $("#ddlPanelCompany").val('0');
            $("#txtExpiryDate,#txtBillNo,#txtBarcode,#txtMRNo,").val('');
            $("#txtPolicy").val('');
            $("#txtStaffID").val('');
            $("#txtCardNo").val('');
            $("#txtCardHolderName").val('');
            $("#ddlHolderRelation").val('0');
            $("#divSearch,#divBillDetail,#divUpdate,#divCommand,#paymentControlDiv").hide();
            $("#divItemDetail,#divPatient").empty();
        }

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
                        $("#lblErrorMsg").text("To date can not be less than from date!");
                        $("#btnSearch").attr("disabled", "disabled");
                    }
                    else {
                        $("#lblErrorMsg").text("");
                        $("#btnSearch").removeAttr("disabled");
                    }
                }
            });
        }

        function getDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $("#txtExpiryDate").val(data);
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(document).on("keydown", function (e) {
            if ((e.which == 13) && (e.target.id != "btnSearch") && (e.target.id != "btnUpdate")) {
                e.preventDefault();
            }
        });
    </script>

    <script type="text/javascript">
        function onAmountChange(value, RefundStatus) {
            var amount = String.isNullOrEmpty(value) ? 0 : value;
            var panelID = "";
            if (RefundStatus) {
              panelID = $("#spnPanelID").text();
            }
            else {
                panelID = jQuery("#<%=ddlPanelCompany.ClientID%>").val().split('#')[0];
            }
            amount = Math.round(amount);
            if (true) {
                $("#paymentControlDiv").show();
                $addBillAmount({
                    panelId: panelID,
                    billAmount: amount,
                    disCountAmount: 0,
                    isReceipt: true,
                    disableDiscount: true,
                    patientAdvanceAmount: 0,
                    disableCredit: false,
                    refund: { status: true }
                }, function () { });
            }
            else {
                $("#paymentControlDiv").hide();
            }
        }
    </script>
    <div id="Pbody_box_inventory"> <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Tariff Change</b>
            <br />
           <asp:Label ID="lblErrorMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            <asp:Label ID="lblUserID" runat="server" ClientIDMode="Static" style="display:none;" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Criteria</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>Barcode </b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtBarcode" runat="server" ClientIDMode="Static"  TabIndex="1" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" ClientIDMode="Static" ToolTip="Enter UHID" TabIndex="2" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Bill No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="txtBillNo" runat="server" ClientIDMode="Static" ToolTip="Enter Bill No." TabIndex="3" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select Date" TabIndex="4" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select Date" TabIndex="5" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-8">
                        </div>
                        <div style="text-align: center" class="col-md-8">
                            <input type="button" id="btnSearch" value="Search" class="ItDoseButton" tabindex="5" title="Click To Search" />
                        </div>
                        <div class="col-md-8"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
       
      <div class="POuter_Box_Inventory" id="divSearch" style="display:none;height:400px;overflow:auto">
             <div class="Purchaseheader">Bill Details</div>
          <div class="row">
            <div id="divPatient" class="col-md-24" style="overflow:auto;max-height:410px" >
                </div>
            </div>
        </div>
        
         <div id="divBillDetail" class="POuter_Box_Inventory" style="display:none;" >
            <div class="Purchaseheader">Bill Details</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">UHID </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <span id="spnMRNo" class="ItDoseLabelSp"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <span id="spnName" class="ItDoseLabelSp"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Bill No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <span id="spnBillNo" class="ItDoseLabelSp"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Bill Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <span id="spnBillDate" class="ItDoseLabelSp"></span> </div>
                        <div class="col-md-3">
                            <label class="pull-left">Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <span id="spnTypeOfTnx" class="ItDoseLabelSp"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Balance Amount </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <span id="spnBalanceAmt" class="ItDoseLabelSp"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Current Panel  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPanel" class="ItDoseLabelSp"></span>
                        <span id="spnPanelID" style="display:none;"></span>                        
                        <span id="spnLedgerTnxNo" style="display:none;"></span>
                        <span id="spnTransactionID" style="display:none;"></span>
                        <span id="spnPolicyNo" style="display:none;"></span>
                        <span id="spnExpiryDate" style="display:none;"></span></div>
                        <div class="col-md-3">
                            <label class="pull-left">Proposed Panel </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                           <asp:DropDownList ID="ddlPanelCompany" runat="server" ClientIDMode="Static" ToolTip="Select Panel">
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            
                        </div>
                    </div>
                   
                    <div class="row">
                            <span id="spnCurrentAmt" class="ItDoseLblSpBl" style="font-size:10pt;"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span id="spnProposedAmt" class="ItDoseLblSpBl" style="font-size:10pt;"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span id="SpnDiffAmt" class="ItDoseLblSpBl" style="font-size:10pt;"></span>
                        <span id="sndDiffAmtActual" class="ItDoseLblSpBl" style="font-size:10pt; display:none;"></span>
                    </div>
                  </div>
                <div class="col-md-1"></div>
            </div>

             <div class="row">
                            <div id="divItemDetail" class="col-md-24" style="overflow:auto;max-height:410px"> </div>
                  </div>
        </div>

        <div id="divUpdate" class="POuter_Box_Inventory" style="display:none;">
            <div class="Purchaseheader">
                Update Panel Details
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Expiry Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtExpiryDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" ></asp:TextBox>
                        <cc1:CalendarExtender ID="calExpiryDate" runat="server" TargetControlID="txtExpiryDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Policy No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtPolicy" runat="server" ClientIDMode="Static" ToolTip="Enter Policy No"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Staff ID </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="txtStaffID" runat="server" ClientIDMode="Static" ToolTip="Enter Staff ID"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Card No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtCardNo" runat="server" ClientIDMode="Static" ToolTip="Enter Card No"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Card Holder Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtCardHolderName" runat="server" ClientIDMode="Static" ToolTip="Enter Card Holder Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Holder Relation </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlHolderRelation" runat="server" ClientIDMode="Static" ToolTip="Select Relation With Card Holder">
                       </asp:DropDownList> 
                        </div>
                    </div>
                  </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div id="paymentControlDiv" style="text-align:center;display:none;">
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>
        <div id="divCommand" class="POuter_Box_Inventory" style="text-align:center;display:none;" >
            <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" tabindex="" title="Click To Update" />
        </div>
    </div>

    <script type="text/html" id="scrptSearch">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:130px;">UHID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Age/Gender</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Bill No.</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Panel</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">BillDate</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Bill Amt</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">LedgerTransactionNo</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">PanelID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">TransactionID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">PolicyNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">ExpiryDate</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">Paid Amt.</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Select</th>                    
             </tr>
            <#       
		    var dataLength=patientDetail.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = patientDetail[j];               
		    #>
            <tr>                               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td> 
                <td class="GridViewLabItemStyle" id="tdTypeOfTnx" style="width:100px;text-align:center;"><#=objRow.TypeOfTnx#></td>                        
                <td class="GridViewLabItemStyle" id="tdMRNo" style="width:130px;text-align:center;"><#=objRow.PatientID#></td>    
				<td class="GridViewLabItemStyle" id="tdName" style="width:150px;text-align:left; "><#=objRow.PName#></td>
				<td class="GridViewLabItemStyle" id="tdAge" style="width:50px;text-align:center;"><#=objRow.AgeGender#></td>  
                <td class="GridViewLabItemStyle" id="tdBillNo" style="width:120px;text-align:center;"><#=objRow.BillNo#></td>                 
                <td class="GridViewLabItemStyle" id="tdPanel" style="width:100px;text-align:left;"><#=objRow.Company_Name#></td>
                <td class="GridViewLabItemStyle" id="tdBillDate" style="width:80px;text-align:center;"><#=objRow.BillDate#></td> 
                <td class="GridViewLabItemStyle" id="tdAmount" style="width:50px;text-align:right;"><#=objRow.NetAmount#></td> 
                <td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="width:50px;display:none;"><#=objRow.LedgerTransactionNo#></td>               
                <td class="GridViewLabItemStyle" id="tdPanelID" style="width:50px;display:none;"><#=objRow.PanelID#></td>
                <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:50px;display:none;"><#=objRow.TransactionID#></td>               
                <td class="GridViewLabItemStyle" id="tdPolicyNo" style="width:50px;display:none;"><#=objRow.PolicyNo#></td>               
                <td class="GridViewLabItemStyle" id="tdExpiryDate" style="width:50px;display:none;"><#=objRow.ExpiryDate#></td>   
                 <td class="GridViewLabItemStyle" id="tdBalanceAmt" style="width:50px;display:none;"><#=objRow.BalanceAmt#></td>              
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;">
                    <img id="img1" src="../../Images/post.GIF" style="cursor:pointer;" title="Click To View" onclick="editDetails(this);"/>
                </td>                       
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>


    <script type="text/html" id="scrptItemDetail">
        <table id="tblItems"  cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;width:100%;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:350px;">ItemName</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Qty</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">CurRate</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">CurDiscAmt</th>               
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">CurAmt</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">ProRate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">ProDiscAmt</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">ProAmt</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">AmtDiff</th>   
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">ItemID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">ScheduleChargeID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">LedgerTnxID</th>                         
             </tr>
            <#       
		    var dataLength=billDetail.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = billDetail[j];               
		    #>
            <tr>                               
                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                        
                <td class="GridViewLabItemStyle" id="tdItemName" style="width:350px;text-align:left; "><#=objRow.ItemName#></td>
                <td class="GridViewLabItemStyle" id="tdQty" style="width:80px;text-align:center;"><#=objRow.Quantity#></td>     
				<td class="GridViewLabItemStyle" id="tdExRate" style="width:80px;text-align:right;"><#=objRow.ExistingRate.toFixed(2)#></td>
                <td class="GridViewLabItemStyle" id="tdExDiscAmt" style="width:80px;text-align:right;"><#=objRow.ExistingDiscAmt.toFixed(2)#></td>				 
                <td class="GridViewLabItemStyle" id="tdExAmt" style="width:80px;text-align:right;"><#=objRow.ExistingAmount.toFixed(2)#></td>  
                <td class="GridViewLabItemStyle" id="tdProRate" style="width:80px;text-align:right;"><#=objRow.ProposedRate.toFixed(2)#></td> 
                <td class="GridViewLabItemStyle" id="tdProDiscAmt" style="width:80px;text-align:right;"><#=objRow.ProposedDiscAmt.toFixed(2)#></td> 
                <td class="GridViewLabItemStyle" id="tdProAmt" style="width:80px;text-align:right;"><#=objRow.ProposedAmount.toFixed(2)#></td> 
                <td class="GridViewLabItemStyle" id="tdDiffAmt" style="width:80px;text-align:right;"><#=objRow.AmtDiff.toFixed(2)#></td> 
                <td class="GridViewLabItemStyle" id="tdItemID" style="width:80px;display:none;"><#=objRow.ItemID#></td>  
                <td class="GridViewLabItemStyle" id="tdScheduleChargeID" style="width:80px;display:none;"><#=objRow.ScheduleChargeID#></td>                      
                <td class="GridViewLabItemStyle" id="tdLedgerTnxID" style="width:80px;display:none;"><#=objRow.LedgerTnxID#></td>                                    
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>    
</asp:Content>