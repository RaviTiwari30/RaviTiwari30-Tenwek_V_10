<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectPatientReg.aspx.cs" Inherits="Design_OPD_DirectPatientReg" %>

<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="wuc_OldPatientSearch" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            var RegistrationChargesApplicable = '<%=Resources.Resource.RegistrationChargesApplicable %>';
            if (RegistrationChargesApplicable == '1')
                $('#divPaymentControlParent').show();  //
            else
                $('#divPaymentControlParent').hide();
            $getHashCode(function () {
                $bindMandatory(function () {
                    $patientControlInit(function () {
                        $panelControlInit(function () {
                            if (RegistrationChargesApplicable == '1') {
                                $paymentControlInit(function () {
                                    $bindRegistrationCharges(function () {
                                        initPayment(function () { });
                                    });
                                });
                            }
                        });
                    });
                });
            });

            $('#txtPID').change(function () {
                $('#btnUpdate').val('Update');
                $('#pageHeader').text('Edit Patient Details');
                if ($.isFunction(window['$clearPaymentControl']))
                    $clearPaymentControl(function () { });
                $('#paymentControlDiv').hide();
                $('.editRemarksDetails').show();
            });
			
			  var TransferRequestID = $.trim('<%=Util.GetString(Request.QueryString["TransferRequestID"])%>');
            if (!String.isNullOrEmpty(TransferRequestID)) {
                $('#txtPFirstName').val($.trim('<%=Util.GetString(Request.QueryString["PName"])%>'));
              $('#txtMobile').val($.trim('<%=Util.GetString(Request.QueryString["MobileNo"])%>'));

          }
         
        });



        var onPanelControlPanelChange = function () {
            initPayment(function () { });
        }


        var initPayment = function () {
            if ('<%=Resources.Resource.RegistrationChargesApplicable%>' == '1') {
                $getRegistrationCharges(function (registrationDetails) {
                    var registrationCharge = registrationDetails.registrationCharge;
                    var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';
                    $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;

                    $autoPaymentMode = '<%=Resources.Resource.IsReceipt%>' == '1' ? false : true;

                    getPatientBasicDetails(function (patientDetails) {
                        if (Number(patientDetails.panelID) == 1)
                            $autoPaymentMode = true;

                        $addBillAmount({
                            panelId: patientDetails.panelID,
                            billAmount: registrationCharge,
                            disCountAmount: 0,
                            isReceipt: $isReceipt,
                            patientAdvanceAmount: 0,
                            minimumPayableAmount: registrationCharge,
                            panelAdvanceAmount: patientDetails.panelAdvanceAmount,
                            disableDiscount: IsDiscountAuthorization == '0' ? true : false,
                            autoPaymentMode: $autoPaymentMode,
                            refund: { status: false }
                        }, function () { });
                    });
                });
            }
        }



        var getSticker = function (patientID, callback) {
            serverCall('Services/PatientRegistration.asmx/PrintSticker', { PatientID: patientID }, function (response) {
                if (String.isNullOrEmpty(response))
                    modelAlert('Error While Retrieving Sticker Data', function () {
                        callback({ status: false })
                    });
                else
                    callback({ status: true, data: response })
            });
        }

        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                $('#spnHashCode').text(response);
                callback(true);
            });
        }


        var $bindMandatory = function (callback) {
            var manadatory = [
                { control: '#ddlTitle', isRequired: true, erroMessage: 'Enter Title', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: true, erroMessage: 'Enter Second Name', tabIndex: 3, isSearchAble: false },
                { control: '#txtPMiddleName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
				// { control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
               { control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 4, isSearchAble: false },
               //{ control: '#ddlMarried', erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 5, isSearchAble: false },
                { control: '#ddlMarried', isRequired: false, erroMessage: 'Select Marital Status', tabIndex: 5, isSearchAble: false },
                //{ control: '#txtIDProofNo', isRequired: true, erroMessage: 'Enter National ID No.', tabIndex: 4, isSearchAble: false },
               //  { control: '#txtAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 6, isSearchAble: false },
                 { control: '#txtParmanentAddress', isRequired: true, erroMessage: 'Enter PhysicalAddress', tabIndex: 6, isSearchAble: false },
                //{ control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                { control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 7, isSearchAble: true },
                { control: '#ddlState', isRequired: true, erroMessage: 'Please Select State', tabIndex: 8, isSearchAble: true },
                { control: '#ddlDistrict', isRequired: true, erroMessage: 'Please Select DIstrict', tabIndex: 9, isSearchAble: true },                
                { control: '#ddlCity', isRequired: true, erroMessage: 'Please Select City', tabIndex: 10, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: false, erroMessage: 'Please Select Doctor', tabIndex: 11, isSearchAble: true },
                { control: '#ddlAppointmentType', isRequired: false, erroMessage: 'Please Select Visit Type', tabIndex: 12, isSearchAble: false },
                { control: '#ddlTypeOfApp', isRequired: false, erroMessage: 'Please Select Type of AppointMent', tabIndex: 13, isSearchAble: false },
                //{ control: '#ddlPurposeofVisit',isRequired:true, erroMessage: 'Please Select Purpose OF Visit', tabIndex: 9, isSearchAble: false },
                { control: '#txtAppointmentOn', isRequired: false, erroMessage: 'Please Enter AppointMent Date', tabIndex: 14, isSearchAble: false },
                { control: '#txtAppointmentTime', isRequired: false, erroMessage: 'Please Enter AppointMent Time', tabIndex: 15, isSearchAble: false },
                { control: '#txtAppointmentCharges', isRequired: false, erroMessage: 'Please Enter AppointMent Charges', tabIndex: 16, isSearchAble: false },
				{ control: '#ddlTaluka', isRequired: true, erroMessage: 'Please Select Village', tabIndex: 10, isSearchAble: true }
            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                $(manadatory[0].control).focus();
            });
            callback(true);
        }

        var getUpdatedDetails = function (callback) {
            $getPatientDetails(function (patientDetails) {
                
                    if (!String.isNullOrEmpty(patientDetails.PatientID)) {
                        $PM = patientDetails.defaultPatientMaster;
                        var updateReasonRemarks = $.trim($('#txtEditReasonRemarks').val());
                        
                      
                        if (String.isNullOrEmpty(updateReasonRemarks)) {
                            modelAlert('Please Enter Update Reason.');
                            return false;
                        }
                       

                        callback({ PM: $PM, updateReasonRemarks: updateReasonRemarks });
                    }
                    else
                        modelAlert('Please Select Patient');
                });
       
        }


        var getPatientRegistrationDetails = function (callback) {
            var hashCode = $('#spnHashCode').text();
            $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
            var DoctorIDSelf = '<%=Resources.Resource.DoctorID_Self%>'
            $getPatientDetails(function (patientDetails) {
                $getMultiPanelPatientDetail(function(MultiPanel){
                $getPaymentDetails(function (payment) {
                    $getRegistrationCharges(function (registrationDetails) {

                        $PM = patientDetails.defaultPatientMaster;
                        $PMH = {
                            DoctorID: DoctorIDSelf,
                            HashCode: hashCode,
                            PanelID: patientDetails.PanelID,
                            ParentID: patientDetails.ParentID,
                            Purpose: '',
                            ReferedBy: patientDetails.ReferedBy,
                            ScheduleChargeID: registrationDetails.ScheduleChargeID,
                            Type: 'OPD',
                            patient_type: patientDetails.PatientType.text,
                            PolicyNo: patientDetails.panelDetails.policyNo,
                            PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                            ExpiryDate: patientDetails.panelDetails.expireDate,
                            EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                            CardNo: patientDetails.panelDetails.cardNo,
                            //DependentRelation: patientDetails.panelDetails.cardHolderRelation,
                            CardHolderName: patientDetails.panelDetails.nameOnCard,
                            RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                            KinRelation: patientDetails.Relation.text,
                            KinName: patientDetails.RelationName,
                            KinPhone: patientDetails.RelationPhoneNo,
                            patientTypeID: patientDetails.PatientType.value,
                            CorporatePanelID: patientDetails.CorporatePanelID, //
                            PatientPaybleAmt : payment.patientPayableAmount,
                            PanelPaybleAmt : payment.panelPayableAmount,
                            PatientPaidAmt : payment.patientPaidAmount,
                            PanelPaidAmt : payment.panelPaidAmount,
                        }

                        $LT = {
                            PanelID: patientDetails.PanelID,
                            NetAmount: payment.netAmount,
                            GrossAmount: payment.billAmount,
                            DiscountReason: payment.discountReason,
                            DiscountApproveBy: payment.approvedBY,
                            DiscountOnTotal: payment.discountAmount,
                            RoundOff: payment.roundOff,
                            GovTaxPer: 0,
                            GovTaxAmount: 0,
                            IPNo: '',//for do latar
                            Adjustment: $isReceipt ? payment.adjustment : 0,
                            UniqueHash: hashCode,
                        }
                      
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
                                PaymentRemarks: this.paymentRemarks,
                                swipeMachine: this.swipeMachine,
                                currencyRoundOff: payment.currencyRoundOff / payment.paymentDetails.length
                            });
                        });
                        

                     

                        $MultiPanel = [];
                        
                        $(MultiPanel.ppatientDetails).each(function () {
                            $MultiPanel.push({
                                PPanelID: this.PPanelID,
                                PPanelGroupID:this.PPanelGroupID,
                                PParentPanelID: this.PParentPanelID,
                                PPanelCorporateID: this.PPanelCorporateID,
                                PPolicyNo: this.PPolicyNo,
                                PCardNo: this.PCardNo,
                                PCardHolderName: this.PCardHolderName,
                                PExpiryDate: this.PExpiryDate,
                                PCardHolderRelation: this.PCardHolderRelation,
                                PApprovalAmount: this.PApprovalAmount,
                                PApprovalRemarks: this.PApprovalRemarks,
                                IsDefaultPanel: this.IsDefaultPanel

                                
                            });
                        });
                        if ($PaymentDetail.length < 1 && '<%=Resources.Resource.IsReceipt %>' == '1' && '<%=Resources.Resource.RegistrationChargesApplicable%>' == '1') {
                            modelAlert('Please Select Payment Details');
                            return false;
                        }
                        if ($MultiPanel.length < 1)
                        {
                            modelAlert('Please Add Panel Details');
                            $('#btnAddMutiPanel').focus();
                            return false;
                        }

                        var isdefaultpanelcount = 0;
                        $(MultiPanel.ppatientDetails).each(function () {
                            if (this.IsDefaultPanel == 1)
                            { isdefaultpanelcount = 1; }
                        });
                        if (isdefaultpanelcount == 0)
                        {
                            modelAlert('Please Select Any Panel for Your Default Panel');
                            return false;
                        }
                        if ('<%=Resources.Resource.RegistrationChargesApplicable%>' == '1') {
                            var panelPaidAmountrow = 0;
                            _divPaymentControlParent.find('#divPaymentDetails #tdPaymentModeID').each(function () {
                                if (Number($(this).text()) == 8)
                                    panelPaidAmountrow += Number($(this).closest('tr').find('#tdBaseCurrencyAmount').text());
                            });
                            var $totalPaidAmountpatient = $LT.Adjustment - panelPaidAmountrow;
                            if ($PaymentDetail[0].PaymentModeID != 4) {
                                if ($PMH.PatientPaybleAmt > 0) {
                                    if ($PMH.PatientPaybleAmt > $PMH.PatientPaidAmt) {
                                        modelAlert('Partial Payment Not Allow.', function () { });
                                        return false;
                                    }
                                }
                                else if (($totalPaidAmountpatient + panelPaidAmountrow) < $LT.NetAmount) {
                                    modelAlert('Partial Payment Not Allow.', function () { });
                                    return false;
                                }
                            }
                            if ($PMH.PatientPaybleAmt > 0) {
                                if ($totalPaidAmountpatient > $PMH.PatientPaybleAmt) {
                                    modelAlert('Can Not Collect More Than The Patient Payable Amount.', function () { });
                                    return false;
                                }
                            }
                        }
                        
                        var PatientTransferID=0
                        if($.trim('<%=Util.GetString(Request.QueryString["TransferRequestID"])%>') != ""){PatientTransferID=$.trim('<%=Util.GetString(Request.QueryString["TransferRequestID"])%>') ;}

                        callback({ PM: [$PM], PMH: [$PMH], LT: [$LT], PaymentDetail: $PaymentDetail, patientDocuments: patientDetails.patientDocuments, MultiPanel: $MultiPanel,TransferRequestID:PatientTransferID });
                    });
                });
                });
            })
        }

        var update = function (btnSave) {
            getUpdatedDetails(function (patientDetails) {
                $getMultiPanelPatientDetail(function(MultiPanel){
                    var $MultiPanel = [];
                        $(MultiPanel.ppatientDetails).each(function () {
                            $MultiPanel.push({
                                PPanelID: this.PPanelID,
                                PPanelGroupID:this.PPanelGroupID,
                                PParentPanelID: this.PParentPanelID,
                                PPanelCorporateID: this.PPanelCorporateID,
                                PPolicyNo: this.PPolicyNo,
                                PCardNo: this.PCardNo,
                                PCardHolderName: this.PCardHolderName,
                                PExpiryDate: this.PExpiryDate,
                                PCardHolderRelation: this.PCardHolderRelation,
                                PApprovalAmount: this.PApprovalAmount,
                                PApprovalRemarks: this.PApprovalRemarks,
                                IsDefaultPanel: this.IsDefaultPanel
                            });
                        });
                     if ($MultiPanel.length < 1)
                        {
                            modelAlert('Please Add Panel Details');
                            $('#btnAddMutiPanel').focus();
                            return false;
                        }

                var data = {
                    Data: [patientDetails.PM],
                    EmergencyNotify: '',
                    EmergencyAddress: '',
                    EmergencyAddressPhoneNo: '',
                    EmergencyRelationShip: '',
                    MultiPanels: $MultiPanel,
                    updateReasonRemarks: patientDetails.updateReasonRemarks

                }
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/PatientRegistration.asmx/UpdateRegistration', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            if ('<%=Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0]%>' == '1') {
                                modelConfirmation('Confirmation', 'Do You Want To Print Sticker', 'Print Stricker', 'Close', function (response) {
                                    if (response) {
                                        getSticker(patientDetails.PatientID, function (response) {
                                            if (response.status)
                                                window.location = 'barcode://?cmd=' + response.data + '&test=1&source=Barcode_Source_Registration';

                                            window.location.reload();
                                        });
                                    }
                                    else
                                        window.location.reload();
                                });
                            }
                            else
                                window.location.reload();
                        }
                        else {
                            $(btnSave).removeAttr('disabled').val('Update');
                        }
                    });
                });
            });
                });
        }

        var saveRegistration = function (btnSave) {
        getPatientRegistrationDetails(function (data) {
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('Services/PatientRegistration.asmx/SaveReg', data, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status) {
                        if (!String.isNullOrEmpty($responseData.LedgerTransactionNo))
                            if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                                window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0');
                            else
                            {
                                window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0&Type=OPD');//OPD
                            }
                        modelConfirmation('Confirmation!!!', 'Book Consultation', 'Yes', 'No', function (response) {
                            if (response) {
                                location.href = '/Tenwek/design/OPD/Lab_PrescriptionOPD.aspx?PatientID=' + $responseData.PatientID;
                                
                            }

                            else { window.location.reload(); }
                        });
                    

                        
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });
                });
            });
        }


        var saveUpdateRegistration = function (elem) {
            getPatientBasicDetails(function (basicDetails) {
                if (String.isNullOrEmpty(basicDetails.patientID))
                    saveRegistration(elem);
                else
                    update(elem);

            });
        }



    </script>

    <script type="text/javascript">
        $(function () {
            shortcut.add('Alt+S', function () {
                var btnUpdate = $('#btnUpdate');
                if (btnUpdate.length > 0) {
                    if (!btnUpdate.is(":disabled") && btnUpdate.is(":visible")) {
                        saveUpdateRegistration(btnUpdate[0]);
                    }
                }
            }, addShortCutOptions);
        });
    </script>

    <style type="text/css">
        .doctorDetailsRow {
            display: none;
        }
    </style>



    <div id="Pbody_box_inventory" style="text-align: left;">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b id="pageHeader">Patient Registration</b><br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <span id="spnEditPatientDetail" class="ItDoseLblError"></span>
        </div>
        <uc1:wuc_OldPatientSearch ID="PatientInfo" runat="server" />

        <%--<%if (Resources.Resource.IsReceipt == "0")
          { %>
       
          <%}else{ %>
        <div id="paymentControlDiv" style=" text-align: center;">
            <uc2:PaymentControl ID="paymentControl1" runat="server" />
        </div>
        <%} %>--%>

         <div id="paymentControlDiv" style="text-align: center;">
            <uc2:PaymentControl ID="paymentControlNew" runat="server" />
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center; display: none">
            <div class="Purchaseheader">Emergency Detail</div>
            <table style="border-collapse: collapse; width: 100%">
                <tr>
                    <td style="text-align: right" class="auto-style2">Emergency Notify :&nbsp;
                    </td>
                    <td style="text-align: left; width: 35%">
                        <asp:TextBox ID="txtEmergencynotify" runat="server" TabIndex="20"
                            MaxLength="50" AutoCompleteType="Disabled" ToolTip="Enter Emergency Notify Name " ClientIDMode="Static" Width="183px"></asp:TextBox>
                    </td>
                    <td style="text-align: right;" class="auto-style3">Relationship :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:DropDownList ID="ddlRelationShip" runat="server" TabIndex="21" ToolTip="Select Relationsihip"
                            Width="225px" ClientIDMode="Static">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; vertical-align: top" rowspan="2" class="auto-style2">Emergency&nbsp;Address&nbsp;:&nbsp;
                    </td>
                    <td style="text-align: left" rowspan="2" class="auto-style1">
                        <asp:TextBox ID="txtEmergencyAddress" runat="server" TextMode="MultiLine" Width="266px"
                            TabIndex="22" Height="29px" MaxLength="50" AutoCompleteType="Disabled" ToolTip="Enter Emergency Contact Address" ClientIDMode="Static"></asp:TextBox>
                    </td>
                    <td style="text-align: right; vertical-align: top" class="auto-style3">Emergency&nbsp;Contact&nbsp;No.&nbsp;:&nbsp;
                    </td>
                    <td style="width: 32%; text-align: left; vertical-align: top">
                        <asp:TextBox ID="txtEmergencyAddressPhoneNo" runat="server" MaxLength="15" TabIndex="23"
                            ToolTip="Enter Emergency Contact No." Width="144px" ClientIDMode="Static"></asp:TextBox>

                        <cc1:FilteredTextBoxExtender ID="ftbPhoneNo" runat="server" FilterType="Numbers"
                            TargetControlID="txtEmergencyAddressPhoneNo">
                        </cc1:FilteredTextBoxExtender>
                    </td>

                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory editRemarksDetails" style="display:none">
            <div class="Purchaseheader billingDetails" onclick="togglePatientDetailSection(this)" style="cursor:pointer">
                  Edit Remark
        </div>
            <div class="row">

                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left" title="Emergency First Name">Remark/Reason</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea cols="" rows="" class="required" id="txtEditReasonRemarks"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-md-3"></div>

            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <span style="display: none" id="spnHashCode"></span>
            <input type="button" style="margin-top: 7px" tabindex="16" value="Save" title="Click To Update" id="btnUpdate" class="ItDoseButton save" onclick="saveUpdateRegistration(this)" />
        </div>
    </div>
</asp:Content>

