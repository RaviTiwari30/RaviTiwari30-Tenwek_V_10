<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="TransportPayment.aspx.cs" Inherits="Design_Transport_TransportPayment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%--<%@ Register Src="~/Design/Controls/wuc_PaymentDetailsJSON.ascx" TagName="wuc_PaymentControl"
    TagPrefix="uc" %>--%>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">


        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function checkNumericDecimal(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            //if (sender.value == "1") {
            //    sender.value = sender.value.substring(0, sender.value.length - 1);
            //}
        }

        $(document).ready(function () {
            $paymentControlInit(function () { });
            $('.numbersOnly').keyup(function () {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });
            bindHashCode(); LoadItemDetail(); bindDoctor(); bindPanel();

            $("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>');
            $('#txtTokenNo').val('');
            $('#TokenSearchOutput,#div_content').hide();
            $('#TokenSearchOutput').empty();
            $("#imgSearchToken").click(function () {
                TokenDetail();
                $('#Div_ReadingDetail').empty();
                $('#Div_ReadingDetail,#div_content').hide();

            });
            $("#rblType input[type='radio']").change(function () {
                bindVehicleReading();
                clearControl();
                $clearPaymentControl(function () { });

            });
            $("#btnAddToken").bind("click", function () {
                $("#spnErrorMsg").text('');
                AddTokenToPaymentTable();
            });
        });

        function bindHashCode() {
            $.ajax({
                url: "../Common/CommonService.asmx/bindHashCode",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $('#txtHash').val(result.d);
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindDoctor() {
            jQuery("#ddlDoctor option").remove();
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindDoctor",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    doctor = jQuery.parseJSON(result.d);
                    jQuery("#ddlDoctor").append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < doctor.length; i++) {
                        jQuery("#ddlDoctor").append(jQuery("<option></option>").val(doctor[i].DoctorID).html(doctor[i].Name));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function TokenDetail() {
            $("#spnErrorMsg").text('');
            $('#TokenSearchOutput').empty();
            $.ajax({
                type: "POST",
                url: "../Transport/Services/Transport.asmx/TokenDetail",
                data: '{TokenNo:"' + $("#txtTokenNo").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    TokenContent = $.parseJSON(response.d);
                    if (TokenContent != 0) {
                        var output = $('#tb_Token').parseTemplate(TokenContent);
                        $('#TokenSearchOutput').html(output);
                        $('#TokenSearchOutput').show();
                    }
                    else {
                        $("#spnErrorMsg").text('Record Not Found');
                        //DisplayMsg('MM04', 'spnErrorMsg');
                        $('#TokenSearchOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    // DisplayMsg('MM05', 'spnErrorMsg');
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

    </script>
        
     <script id="tb_Token" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:auto;border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Token No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Vehicle Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Model No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none; ">Payment Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px; text-align:left;">P Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px; display:none;">Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; text-align:left;">Contact No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px; text-align:left;">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px; text-align:left; display:none;">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;  display:none;">VehicleID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;  display:none;">Last Reading</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;  display:none;">DriverID</th>
          
             <th class="GridViewHeaderStyle" scope="col" style="width:20px;"></th>
		</tr>
        <#       
        var dataLength=TokenContent.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = TokenContent[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                          
    
                    <td class="GridViewLabItemStyle"  style="width:100px;" id="tdTokenNo"><#=objRow.TokenNo#></td>
                        <td class="GridViewLabItemStyle"  style="width:130px;" id="tdVehicle"><#=objRow.VehicleName#></td>
                          <td class="GridViewLabItemStyle"  style="width:80px;" id="tdModelNo"><#=objRow.ModelNo#></td>
                        <td class="GridViewLabItemStyle"  style="width:70px;" id="tdPatientID"><#=objRow.MRNo#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px; text-align:left; display:none;" id="tdPatientType"><#=objRow.PType#></td>
                        <td class="GridViewLabItemStyle"  style="width:180px; text-align:left;" id="tdPName"><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px; display:none;" id="tdAge"><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle"  style="width:50px; display:none;" id="tdGender"><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px; text-align:left;" id="tdContactNo"><#=objRow.Mobile#></td>
                        <td class="GridViewLabItemStyle"  style="width:90px; text-align:left;" id="tdCity"><#=objRow.City#></td>
                        <td class="GridViewLabItemStyle"  style="width:200px; text-align:left; display:none;" id="tdAddress"><#=objRow.Address#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px;display:none;" id="tdVehicleID"><#=objRow.VehicleID#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px;display:none;" id="tdLastReading"><#=objRow.LastReading#></td>
                        <td class="GridViewLabItemStyle"  style="width:80px;display:none;" id="tdDriverID"><#=objRow.DriverID#></td>
                        <td class="GridViewLabItemStyle"  style="width:20px;">
                             <input type="button"  value="Edit" class="ItDoseButton" onclick="ShowTokenDetail(this)" />
                        </td>
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

    <script type="text/javascript">
        function ShowTokenDetail(rowID) {
            clearControl();
            $("#spnErrorMsg").text('');
            $("#div_content").show();
            $('#SpnTokenNo').text($(rowID).closest('tr').find('#tdTokenNo').text());
            $('#SpnPatientID').text($(rowID).closest('tr').find('#tdPatientID').text());
            $('#SpnPatientType').text($(rowID).closest('tr').find('#tdPatientType').text());
            $('#SpnPName').text($(rowID).closest('tr').find('#tdPName').text());
            $('#SpnAge').text($(rowID).closest('tr').find('#tdAge').text());
            $('#SpnSex').text($(rowID).closest('tr').find('#tdGender').text());
            $('#SpnContactNo').text($(rowID).closest('tr').find('#tdContactNo').text());
            $('#SpnCity').text($(rowID).closest('tr').find('#tdCity').text());
            $('#SpnAddress').text($(rowID).closest('tr').find('#tdAddress').text());
            $('#SpnLastReading').text($(rowID).closest('tr').find('#tdLastReading').text());
            $('#SpnVehicleID').text($(rowID).closest('tr').find('#tdVehicleID').text());
            $('#SpnDriverID').text($(rowID).closest('tr').find('#tdDriverID').text());
            $('#ddlDoctor').val('532');

            bindVehicleReading();
        }

        function bindVehicleReading() {
            $('#PnlReadingDetail').hide();
            $("#lblErrormsg").text('');
            var VehicleID = $('#SpnVehicleID').text();
            $.ajax({
                url: "../Transport/Services/Transport.asmx/GetVehicleReadingNew",
                data: '{VehicleID:"' + VehicleID + '",ReadingTypeID:"' + $("#rblType").find("input:radio:checked").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    ReadingDetail = $.parseJSON(result.d);
                    if (ReadingDetail != null) {
                        var ReadingDetailOutPut = $('#ReadingDetail').parseTemplate(ReadingDetail);
                        $('#Div_ReadingDetail').html(ReadingDetailOutPut);
                        $('#Div_ReadingDetail,#ReadingDetail,#tb_ReadingDetailSearch,#PnlReadingDetail').show();

                        if ($('#Div_ReadingDetail table tr').length > 2) {
                            $('#div_Add').show();
                        }
                        else {
                            $('#div_Add').hide();
                        }
                    }
                    else {
                        $('#Div_ReadingDetail,#Div_ReadingDetail,#tb_ReadingDetailSearch,#PnlReadingDetail,#div_Add').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function AddTokenToPaymentTable() {
            $clearPaymentControl(function () { });
            var totalAmount = 0, ChkCount = 0;
            $('#Div_ReadingDetail table tr').each(function (index, row) {
                if ($(row).find('#rdoSelect').prop('checked')) {
                    var ReadingTypeID = $(this).closest('tr').find("#tdReadingTypeID").html()
                    if (ReadingTypeID == 1) {

                        if ($(this).closest('tr').find("#txtKM").val() == "") {
                            modelAlert('Please Enter Rate', function () {
                                $(this).closest('tr').find("#txtKM").focus();
                            });
                            return;
                        }

                        var amount = parseFloat($(this).closest('tr').find("#tdRatePerKM").html()) * parseFloat($(this).closest('tr').find("#txtKM").val());
                        totalAmount = totalAmount + amount;
                    }
                    else if (ReadingTypeID == 2) {
                        var amount = parseFloat($(this).closest('tr').find("#td1RangeAmount").html());
                        totalAmount = totalAmount + amount;
                    }
                    ChkCount += 1;
                }

            });

            if (ChkCount == 0) {
                modelAlert('Please Select Any One Reading Type');
                return;
            }

            $("select[id*=ddlPanelCompany],#txtBarcode").attr('disabled', true);
            if (($('#tbSelected tr:not(#LabHeader)').length == 0)) {
                $("#txtBarcode").removeAttr('disabled');
                if ($('#txtPID').val() == "")
                    $('#ddlPanelCompany,#txtBarcode').attr('disabled', false);
            }
            $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
            $autoPaymentMode = '<%=Resources.Resource.IsReceipt%>' == '1' ? false : true;

            if ($isReceipt) {
                $isReceipt = billAmount > 0 ? true : false;
                $autoPaymentMode = billAmount > 0 ? false : true;
            }

            var totalBillAmount = Number(totalAmount);
            if (totalBillAmount > 0) {
                $addBillAmount({
                    panelId: 1,
                    billAmount: totalBillAmount,
                    disCountAmount: 0,
                    isReceipt: $isReceipt,
                    patientAdvanceAmount: 0,
                    autoPaymentMode: $autoPaymentMode,
                    minimumPayableAmount: 0,
                    disableDiscount: true,
                    panelAdvanceAmount: 0,
                    disableCredit: false,
                    refund: { status: false }
                }, function () { });
            }
            else {
                $clearPaymentControl(function () { });
            }




            $('#Div_ReadingDetail,#ReadingDetail,#tb_ReadingDetailSearch,#PnlReadingDetail,#pnlNewPatient,#div_content,#TokenSearchOutput').show();
            if ($('#Div_ReadingDetail table tr').length > 2)
                $('#div_Add').show();
            else
                $('#div_Add').hide();



        }


        function bindPanel() {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindPanel",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    panel = jQuery.parseJSON(result.d);
                    for (i = 0; i < panel.length; i++) {
                        jQuery("#ddlPanelCompany").append(jQuery("<option></option>").val(panel[i].PanelID + "#" + panel[i].ReferenceCodeOPD).html(panel[i].Company_Name));
                        jQuery("#ddlParentPanel").append(jQuery("<option></option>").val(panel[i].PanelID).html(panel[i].Company_Name));

                    }
                    jQuery("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>');
                    jQuery("#ddlParentPanel").val('<%=Resources.Resource.DefaultPanelID %>');

                },
                error: function (xhr, status) {
                }
            });
        }
        function clearControl() {
            $('#btnAddToken').removeAttr('disabled');
            $("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>');

         }



         function LoadItemDetail() {
             var Rate
             $.ajax({
                 url: "Services/Transport.asmx/LoadAmbulanceChargesDetail",
                 data: '{ItemID:"' + '<%=Resources.Resource.TransportItemID%>' + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        $('#SpnAmbulanceCharges').text(data[0].ItemID);
                    }
                }
            });
         }


        var saveTransport = function () {
            getTranssportDetail(function (data) {
                $('#btnSave').attr('disabled', true).val('Submitting...');
                serverCall('Services/Transport.asmx/saveTransport', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + responseData.LedgerTransactionNo + '&IsBill=' + responseData.IsBill + '&Duplicate=0&Type=OPD');
                            window.location.reload();
                        }
                        else {
                            $('#btnSave').removeAttr('disabled').val('Save');
                        }
                    });
                    
                });
            });
        }

        var getTranssportDetail = function (callback) {
            $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
            var CurrentMeterReading = 0, ReadingTypeID = 0, VRM_ID = 0;
            if ($("#ddlDoctor").prop('selectedIndex') == 0) {
                modelAlert('Please Select Doctor', function () {
                    $('#ddlDoctor').focus();
                });
                return false;
            }

            $('#Div_ReadingDetail table tr').each(function (index, row) {
                if ($(row).find('#rdoSelect').prop('checked')) {
                    CurrentMeterReading = Number($(this).closest('tr').find("#txtMeterReading").val()).toFixed(2);
                    ReadingTypeID = $(this).closest('tr').find("#tdReadingTypeID").html();
                    VRM_ID = $(this).closest('tr').find("#tdVRM_ID").html();
                }
            });


            if (CurrentMeterReading <= parseFloat($('#SpnLastReading').text()) && CurrentMeterReading != "0.00") {
                modelAlert('Meter Reading can not be less than from Last Reading');
                return false;
            }

            dataPM={
                PatientID:$('#SpnPatientID').text() == ""?"":$('#SpnPatientID').text(),
                IsNewPatient:$('#SpnPatientID').text() == ""?0:1,
                OldPatientID:"",
                Title : "Mr.",
                PFirstName : $('#SpnPName').text(),
                PLastName : "",
                PName : $('#SpnPName').text(),
                Age : $('#SpnAge').text(),
                Gender : $('#SpnSex').text(),
                MaritalStatus : "",
                Mobile : $('#SpnContactNo').text(),
                Email : "",
                Relation : "",
                RelationName : "",
                House_No : $('#SpnAddress').text(),
                Country : "",
                District : "",
                City : "",
                Taluka : "",
                CountryID : "14",
                DistrictID : "34",
                CityID : "3874",
                TalukaID : 0,
                Place : "",
                LandMark : "",
                Occupation : "",
                Pincode : "",
                AdharCardNo : "",
                HospPatientType : "",
                State : "",
                StateID : "34",
                PatientType : '1',
                PatientIDProofs : [],   
            }
            
            $getPaymentDetails(function (payment){
                    dataPMH={
                        PanelID : $("#ddlPanelCompany").val().split('#')[0],
                        Type :"OPD",
                        DoctorID :$("#ddlDoctor").val(),
                        Purpose :"",
                        ParentID :$("#ddlPanelCompany").val().split('#')[0],
                        ScheduleChargeID :1,
                        ReferralNo :"",
                        ClaimID :"",
                        HashCode : $("#txtHash").val(),
                        KinRelation: "Self",
                        patientTypeID: "1",
                        patient_type: "SELF",
                        PatientPaybleAmt: payment.patientPayableAmount,
                        PanelPaybleAmt: payment.panelPayableAmount,
                        PatientPaidAmt: payment.patientPaidAmount,
                        PanelPaidAmt: payment.panelPaidAmount,
                    }
                    dataLT={
                        PanelID:$("#ddlPanelCompany").val().split('#')[0],
                        UniqueHash : $("#txtHash").val(),
                        IPNo : $.trim($("#txtIPD").val()),
                        NetAmount : payment.netAmount,
                        GrossAmount : payment.billAmount,
                        DiscountReason : payment.discountReason,
                        DiscountApproveBy : payment.approvedBY,
                        DiscountOnTotal: payment.discountAmount,
                        Adjustment: payment.adjustment,
                        GrossAmount: payment.billAmount,
                        NetAmount: payment.netAmount,
                        GovTaxAmount: 0,
                        GovTaxPer: 0,
                        DiscountReason: payment.discountReason,
                        Adjustment: $isReceipt ? payment.adjustment : '0',
                    }
                    dataLTD = [];
                    $('#Div_ReadingDetail table tr').each(function (index, row) {
                        if ($(row).find('#rdoSelect').prop('checked')) {
                            var ReadingTypeID = $(this).closest('tr').find("#tdReadingTypeID").html();
                            var Rate = 0; var Quantity = 0;
                            if (ReadingTypeID == 1) {
                                Rate = $.trim(parseFloat($(this).closest('tr').find("#tdRatePerKM").html()));
                                Quantity = $.trim(parseFloat($(this).closest('tr').find("#txtKM").val()));
                            }
                            else if (ReadingTypeID == 2) {
                                Rate = $.trim(parseFloat($(this).closest('tr').find("#td1RangeAmount").html()));
                                Quantity = "1";
                            }
                            dataLTD.push({
                                IsAdvance : $.trim($('#SpnAmbulanceCharges').text().split('#')[8]),
                                ItemID: $('#SpnAmbulanceCharges').text().split('#')[0],
                                Rate: Rate,
                                Quantity:Quantity,
                                DiscAmt: payment.discountAmount,
                                DiscountPercentage: payment.discountPercent,
                                Amount: ((Rate * Quantity) - (payment.discountAmount)),
                                SubCategoryID : $.trim($('#SpnAmbulanceCharges').text().split('#')[1]),
                                ItemName : $.trim("AMBULANCE CHARGES"),
                                DiscountReason: payment.discountReason,
                                DoctorID : $("#ddlDoctor").val(),
                                Type        : $.trim($('#SpnAmbulanceCharges').text().split('#')[2]),
                                Type_ID     : $.trim($('#SpnAmbulanceCharges').text().split('#')[3]),
                                TnxTypeID   : $.trim($('#SpnAmbulanceCharges').text().split('#')[5]),
                                sampleType  : $.trim($('#SpnAmbulanceCharges').text().split('#')[4]),
                            });
                        }
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
                    callback({ PM: [dataPM], PMH: [dataPMH], LT: [dataLT], LTD: dataLTD, PaymentDetail: $PaymentDetail, TokenNo: $('#SpnTokenNo').text(), PatientID: $('#SpnPatientID').text(), Patient_Type: $('#SpnPatientType').text(), PName: $('#SpnPName').text(), Age: $('#SpnAge').text(), Sex: $('#SpnSex').text(), ContactNo: $('#SpnContactNo').text(), City: $('#SpnCity').text(), Address: $('#SpnAddress').text(), VehicleID: $('#SpnVehicleID').text(), DriverID: $('#SpnDriverID').text(), LastReading: $('#SpnLastReading').text(), MeterReading: CurrentMeterReading, ReadingTypeID: ReadingTypeID, VRM_ID: VRM_ID });
                });
        }

    

    </script>


     <script type="text/html" id="ReadingDetail">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse:collapse;" id="tb_KMBasisSearch">
                    <tr id="ReadingDetail_Header21">
                                    <th class="GridViewHeaderStyle" scope="col" style="width:100%; text-align:left" colspan="9">Reading Detail</th>                    
                     </tr>
                    <tr id="ReadingDetail_Header22">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left; display:none;"></th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">VRM ID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">Vehicle ID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align:left">Vehicle Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">ReadingTypeID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:left">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align:left">From(KM)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align:left">To(KM)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:left">Amount</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Reading Type</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20px; text-align:left"></th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align:left">KM</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align:left; display:none;">Last Reading</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align:left">Meter(Reading)</th>                                
                    </tr>

            <#
                var dataLength=ReadingDetail.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=ReadingDetail[j];
            #>
                    <tr>                      
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center; display:none"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdVRM_ID"  style="width:50px;text-align:center;display:none;"><#=objRow.VRM_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicle_ID"  style="width:50px;text-align:center;display:none;" ><#=objRow.VehicleID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicleName"  style="width:200px; text-align:left;" ><#=objRow.VehicleName#></td>
					    <td class="GridViewLabItemStyle" id="tdReadingTypeID"  style="width:50px;text-align:center;display:none;" ><#=objRow.ReadingTypeID#></td>
                        <td class="GridViewLabItemStyle" id="tdRatePerKM" style="width:60px;text-align:center; "><#=objRow.RatePerKM#></td>    
                        <td class="GridViewLabItemStyle" id="td1RangeFrom" style="width:60px;text-align:center; "><#=objRow.RangeFrom#></td>  
                        <td class="GridViewLabItemStyle" id="td1RangeTo" style="width:60px;text-align:center; "><#=objRow.RangeTo#></td> 
                        <td class="GridViewLabItemStyle" id="td1RangeAmount" style="width:60px;text-align:center; "><#=objRow.RangeAmount#></td>  
                        <td class="GridViewLabItemStyle" id="tdReadingType" style="width:100px; text-align:left; "><#=objRow.ReadingType#></td>                        
                      
                          <#  if(objRow.ReadingTypeID =='1')
                        {#>
                         <td class="GridViewLabItemStyle" id="td4" style="width:20px; text-align:left; ">
                    <input id="rdoSelect" type="radio" name="rdochk" checked="checked" />
                        </td> 
                     <#}
                        else if(objRow.ReadingTypeID =='2')
                        {#>
					     <td class="GridViewLabItemStyle" id="td5" style="width:20px; text-align:left; ">
                    <input id="rdoSelect" type="radio" name="rdochk" />
                        </td> 
                       <#}#>


                      <#  if(objRow.ReadingTypeID =='1')
                        {#>
                        <td class="GridViewLabItemStyle" id="tdKM" style="width:40px; text-align:left; ">
                    <input type="text" id="txtKM" maxlength="4" style="width:30px" class="ItDoseTextinputNum" onkeypress="return checkNumericDecimal(event,this);" />
                        </td>
                     <#}
                        else if(objRow.ReadingTypeID =='2')
                        {#>
					   <td class="GridViewLabItemStyle" id="td2" style="width:40px; text-align:left; ">        
                           <span>--</span>           
                        </td>
                       <#}#>       
                        
                           <td class="GridViewLabItemStyle" id="td1" style="width:100px; text-align:left;display:none; "><#=objRow.LastReading#></td>

                       <td class="GridViewLabItemStyle" id="tdMeterReading" style="width:100px; text-align:left; ">
                                <input type="text" id="txtMeterReading" maxlength="6" style="width:70px" class="ItDoseTextinputNum" onkeypress="return checkNumericDecimal(event,this);" />
                           </td>                               
                    </tr>                           
            <#    
                }                
            #>
        </table>
    </script>
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
    <%--    Transport START--%>
    <asp:Panel ID="pnlNewPatient" runat="server">      <%-- style="display:none;"--%>

   <div id="Pbody_box_inventory">
      
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Transport Payment</b><br />
               <span id="spnErrorMsg" class="ItDoseLblError"></span>
             <input type ="text" id="txtHash" style="display:none" />
                 <span id="SpnAmbulanceCharges" style="display:none" ></span>
               <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>           
        </div>
                                           
        <div class="POuter_Box_Inventory" style="width:100%;text-align:center;">
             <div class="Purchaseheader">
               Transport Payment
            </div>

              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            Token No
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21" style="text-align:left;">
                           <input type="text" id="txtTokenNo" style="width: 150px;" maxlength="20" title="Enter Token No" class="ItDoseTextinputText" />   
                            <img id="imgSearchToken" alt="" src="../../Images/view.gif" style="cursor:pointer"  />
                        </div>                                                                                              
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
  
              
           <div class="Purchaseheader">Search Result</div>     
           <div id="TokenSearchOutput" style="max-height: 100px; overflow-x: auto; overflow:scroll;"></div>


           <div id="div_content" style="max-height: 600px; width:100%; overflow-x: auto; display:none;">
            <div class="Purchaseheader">
                Patient Detail
                    </div>     
               
                   
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            Patient Name                          
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="SpnTokenNo" style="display:none;"></span>  
                            <span id="SpnPatientID" style="display:none;"></span>  
                             <span id="SpnPatientType" style="display:none;"></span>
                            <span id="SpnPName" ></span>  
                        </div>                        
                        <div class="col-md-3">                          
                             Age/Sex
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> 
                            <span id="SpnAge" ></span>/<span id="SpnSex" ></span>  
                               <select id="ddlPanelCompany" title="Select Panel" style="width:225px; display:none;" tabindex="29" ></select> 
                        </div>
                        <div class="col-md-3">                           
                           Contact No                  
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                            
                            <span id="SpnContactNo" ></span>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>    
               

                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            City                        
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="SpnCity"></span>  <span id="SpnVehicleID" style="display:none;"></span>   <span id="SpnDriverID"  style="display:none;"></span>     
                        </div>                        
                        <div class="col-md-3">                          
                            Address
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13"> 
                            <span id="SpnAddress" style="width:600px;" ></span>     
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>    
               
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            Reading Type                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="KM Basis" Value="1" Selected="True" />
                                <asp:ListItem Text="Range Basis" Value="2" />
                        </asp:RadioButtonList>
                        </div>                        
                        <div class="col-md-3">                          
                             Last Reading
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> 
                             <span id="SpnLastReading" style="width:100px;" ></span><strong>&nbsp;KM</strong>  
                        </div>
                        <div class="col-md-3">                           
                           Doctor                
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                            
                           <select id="ddlDoctor" title="Select Doctor" style="width:180px" tabindex="31"   class="requiredField"  ></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>    
                      
        <div id="Div_ReadingDetail" style="max-height: 200px; width:100%; overflow-y:auto;overflow-x: hidden;"></div>

        <div id="div_Add"  style="text-align: center; width:100%; display:none; ">
            <input type="button" id="btnAddToken" value="Add" class="ItDoseButton" />&nbsp
                    

        <div style="width: 100%" id="paymentControlDiv">
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="saveTransport()" />
        </div>


        </div>  

     

     </div>     
             
                              
        </div>               
         
         
          
       </div>

    </asp:Panel> 

<%--    Transport END--%>

     <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
     
</asp:Content>
