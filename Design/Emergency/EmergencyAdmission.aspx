<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EmergencyAdmission.aspx.cs" Inherits="Design_Emergency_EmergencyAdmission" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="OldPatientSearchControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCAdmissionBedDetails.ascx" TagName="AdmissionDetailsControl" TagPrefix="UC2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="sc1" runat="server"></asp:ScriptManager>
    <script type="text/javascript">

        $(document).ready(function () {
            $bindMandatory(function () {
                $getHashCode(function () {
                    $onEmergencyPageInit(function () {
                        $patientControlInit(function () {
                            $panelControlInit(function () {
                                var patientID = $.trim('<%=Util.GetString(Request.QueryString["PID"])%>');
                                var transactionID = $.trim('<%=Util.GetString(Request.QueryString["TID"])%>');
                                var roleid = '<%=Session["RoleID"]%>';
                                if ( roleid == "64") {
                                    $('#btnregistrationcharges').css("display","none");
                                }
                            });
                        });
                    });
                });
            });
            $('#btnTransferPatient').show();
            
            setInterval(blinker, 1000);
            var TransferRequestID = $.trim('<%=Util.GetString(Request.QueryString["TransferRequestID"])%>');
            if (!String.isNullOrEmpty(TransferRequestID)) {
                $('#txtPFirstName').val($.trim('<%=Util.GetString(Request.QueryString["PName"])%>'));
                $('#txtMobile').val($.trim('<%=Util.GetString(Request.QueryString["MobileNo"])%>'));

                $('#txtAge').val($.trim('<%=Util.GetString(Request.QueryString["Age"])%>'));
                $('#ddlAge').val($.trim('<%=Util.GetString(Request.QueryString["Type"])%>'));

            }
            else {
                generateName();
            }
        });
        function generateName()
        {
           

            $.ajax({
                type: "POST",
                data: JSON.stringify({  }),
                url: "./EmergencyAdmission.aspx/GenerateName1",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    $("#txtPFirstName").val("EMR_"+result.d);
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    }

            });
           }
        function blinker()
        {
            $('#btnTransferPatient').fadeOut(500).addClass('.label label-important');
            $('#btnTransferPatient').fadeIn(500).addClass('.label label-important');
        }

        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                $('#spnHashCode').text(response);
                callback(true);
            });
        };

        var $bindMandatory = function (callback) {
            var manadatory = [
               { control: '#ddlTitle', isRequired: true, erroMessage: 'Enter Title', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
				//{ control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                { control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#ddlMarried', erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: false, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },
              //  { control: '#txtIDProofNo', isRequired: true, erroMessage: 'Enter NIC No.', tabIndex: 4, isSearchAble: false },
                 //{ control: '#txtAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },
                 { control: '#txtParmanentAddress', isRequired: false, erroMessage: 'Enter Physical Address', tabIndex: 5, isSearchAble: false },
                //{ control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                { control: '#ddlCountry', isRequired: false, erroMessage: 'Please Select Country', tabIndex: 6, isSearchAble: true },
                   { control: '#ddlState', isRequired: false, erroMessage: 'Please Select State', tabIndex: 6, isSearchAble: true },
                { control: '#ddlDistrict', isRequired: false, erroMessage: 'Please Select DIstrict', tabIndex: 7, isSearchAble: true },
                { control: '#ddlCity', isRequired: false, erroMessage: 'Please Select City', tabIndex: 8, isSearchAble: true },
				{ control: '#ddlDoctor', isRequired: false, erroMessage: 'Please Select Doctor', tabIndex: 9, isSearchAble: true },
                { control: '#ddlRoomType', isRequired: true, erroMessage: 'Please Select Room Type', tabIndex: 10, isSearchAble: false },
                { control: '#ddlRoomNo', isRequired: true, erroMessage: 'Please Select Room NO', tabIndex: 11, isSearchAble: false },
            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                if (item.isSearchAble)
                    $(item.control + '_chosen a').addClass(item.isRequired ? 'requiredField' : '').attr('tabindex', item.tabIndex);
                $(manadatory[0].control).focus();
            });
            callback(true);
        }

        var $getEmergencyAdmissionDetails = function (callback) {
            var hashCode = $('#spnHashCode').text();
            var roomType = $('#ddlRoomType').val();
            var roomNo = $('#ddlRoomNo').val();
            var triagingCode = $('#ddlTriaging').val();

            var admissionDate = $('#txtAdmissionDate').val();
            var admissionHour= $('#txtAdmissionTimeHour').val();
            var admissionMinute = $('#txtAdmissionTimeMinute').val();
            var admissionTimeMeridiem = $('#ddlAdmissionTimeMeridiem').val();

             var admissionTime = admissionHour + ':' + admissionMinute + ' ' + admissionTimeMeridiem;

            var inValidElem = null;
            /*
            $('#Pbody_box_inventory .requiredField').each(function (index, elem) {
                if (String.isNullOrEmpty(elem.value) || elem.value == '0') {
                    inValidElem = elem;
                    if (this.attributes["errorMessage"] != null) {
                        modelAlert(this.attributes['errorMessage'].value, function () {
                            inValidElem.focus();

                        });

                        return false;
                    }
                }
            });*/
            if (String.isNullOrEmpty(inValidElem)) {
          
                $getPatientDetails(function (patientDetails) {
                   

                        $PM = patientDetails.defaultPatientMaster;
                        $PMH = {
                            patient_type: patientDetails.PatientType.text,
                            PanelID: patientDetails.PanelID,
                            DoctorID: patientDetails.Doctor.value,
                            ReferedBy: patientDetails.ReferedBy,
                            ProId: patientDetails.PROID,
                            Type: 'OPD',
                            ParentID: patientDetails.ParentID,
                            HashCode: hashCode,
                            ScheduleChargeID: 0,
                            PolicyNo: patientDetails.panelDetails.policyNo,
                            PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                            ExpiryDate: patientDetails.panelDetails.expireDate,
                            EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                            CardNo: patientDetails.panelDetails.cardNo,
                            CardHolderName: patientDetails.panelDetails.nameOnCard,
                            //DependentRelation: patientDetails.panelDetails.cardHolderRelation,
                            RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                            KinRelation: patientDetails.Relation.text,
                            KinName: patientDetails.RelationName,
                            KinPhone: patientDetails.RelationPhoneNo,
                            patientTypeID: patientDetails.PatientType.value,
                            TypeOfReference: patientDetails.typeOfReference.text,
                            Source: 'Emergency',
                            Admission_Type: 'Emergency',
                            ReferralTypeID: patientDetails.ReferralTypeID
                        }
                        var data = {
                            PM: [$PM],
                            PMH: [$PMH],
                            patientDocuments: patientDetails.patientDocuments,
                            roomType: roomType,
                            roomNo: roomNo,
                            triagingCode: triagingCode,
                            admissionDate: admissionDate,
                            admissionTime: admissionTime
                        };
                       
                    callback(data);
                });

            }
        }

        var $saveAdmissionDetails = function (btnSave) {
            $getEmergencyAdmissionDetails(function (admissionDetails) {
                $getMultiPanelPatientDetail(function (MultiPanel) {
                    $MultiPanel = [];
                    $(MultiPanel.ppatientDetails).each(function () {
                        $MultiPanel.push({
                            PPanelID: this.PPanelID,
                            PPanelGroupID: this.PPanelGroupID,
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

                    //if ($MultiPanel.length < 1) {
                    //    modelAlert('Please Add Panel Details');
                    //    $('#btnAddMutiPanel').focus();
                    //    return false;
                    //}

                    

                    admissionDetails.MultiPanel = $MultiPanel;
                    var PatientTransferID = 0
                    if ($.trim('<%=Util.GetString(Request.QueryString["TransferRequestID"])%>') != "") {
                        PatientTransferID = $.trim('<%=Util.GetString(Request.QueryString["TransferRequestID"])%>');
                        admissionDetails.TransferRequestID = PatientTransferID;
                    }
                    else { admissionDetails.TransferRequestID = PatientTransferID; }
                    
                    //var data = {
                    //    PM: [admissionDetails.PM],
                    //    PMH:[admissionDetails.PMH],
                    //    patientDocuments: [admissionDetails.panelDetails],
                    //    roomType: admissionDetails.roomType,
                    //    roomNo: admissionDetails.roomNo,
                    //    triagingCode: admissionDetails.triagingCode,
                    //    MultiPanel: $MultiPanel

                    //};r
                    if($("#txtPFirstName").val()=="")
                    {
                        modelAlert("Enter First Name .");
                        return false;
                    }
                    if ($('#ddlRoomType').val() == "" || $('#ddlRoomType').val() == "0" || $('#ddlRoomType').val() == undefined || $('#ddlRoomType').val() == null) {
                        modelAlert("Please Select Room Type.");
                        return false;
                    }
                    if ($('#ddlRoomNo').val() == "" || $('#ddlRoomNo').val() == "0" || $('#ddlRoomNo').val() == undefined || $('#ddlRoomNo').val() == null) {
                        modelAlert("Please Select Room No.");
                        return false;
                    }

                    $(btnSave).attr('disabled', true).val('Submitting...');
                    serverCall('Services/EmergencyAdmission.asmx/SaveEmergencyAdmission', admissionDetails, function (response) {
                        var $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            modelAlert($responseData.response, function () {
                                window.open('../../Design/Emergency/EmergencyAdmissionPrintOut.aspx?TID=' + $responseData.TID + '&PID=' + $responseData.PID + '');
                                window.location.reload();
                            });
                        }
                        else {
                            modelAlert($responseData.response, function () {
                                $(btnSave).removeAttr('disabled').val('Save');
                            });
                        }
                    });
                });
            });
        }

        var onSaveAdmissionDetaills = function (btnSave) {
            var transactionID = $.trim('<%=Util.GetString(Request.QueryString["TID"])%>');
            if (String.isNullOrEmpty(transactionID))
                $saveAdmissionDetails(btnSave);

        }




        var disableDemographicChanges = function (callback) {
            callback($('#PatientDetails').find('input,select,button,textarea,.chosen-container').not('#ddlDoctor,#ddlDoctor_chosen input').prop('disabled', true).trigger("chosen:updated"));
        }




        $onEmergencyPageInit = function (callback) {
            debugger;
           // $bindEmergencyDocDept(function () {
                $bindEmergencyDoctor(function () {
                    $bindEmergencyRoomType(function () {
                      //  bindTriagingCodes(function () {
                            callback();
                      //  });
                    });
                });
            //});
        }




        var bindTriagingCodes = function (callback) {
            serverCall('Services/EmergencyAdmission.asmx/GetTriagingCodes', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlTriaging = $('#ddlTriaging');
                debugger;
                ddlTriaging.append($(new Option).val(0).text('Select'));
                for (var i = 0; i < responseData.length; i++) {
                    ddlTriaging.append($(new Option).val(responseData[i].ID).text(responseData[i].CodeType).css('background-color', responseData[i].ColorCode));
                }
                callback();
            });
        }


        var $bindEmergencyDocDept = function (callback) {
            $('#ddlDepartment').chosen('destroy').val('0').attr('disabled', 'disabled');
            callback(true);
        }
        var $bindEmergencyDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindEmergencyDoctor', {}, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }



        $bindEmergencyRoomType = function (callback) {
            $ddlRoomType = $('#ddlRoomType');
            serverCall('EmergencyAdmission.aspx/bindEmergencyRoomType', {}, function (response) {
                var responseData = [];
                if (!String.isNullOrEmpty(response))
                    responseData = JSON.parse(response);

                $ddlRoomType.bindDropDown({ data: responseData, defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', });
                callback($ddlRoomType.val());

            });
        }
        var $bindRoomBed = function (roomType, callback) {
            $ddlRoomNo = $('#ddlRoomNo');
            getCurrentDate(function (CurDate) {
                serverCall('../IPD/Services/IPDAdmission.asmx/bindRoomBed', { caseType: roomType, IsDisIntimated: '0', type: $("#lblAdvanceRoomBooking").length, bookingDate: CurDate }, function (response) {

                    var responseData = [];
                    if (!String.isNullOrEmpty(response))
                        responseData = JSON.parse(response);

                    $ddlRoomNo.bindDropDown({ data: responseData, defaultValue: 'Select', valueField: 'RoomID', textField: 'Name' });
                    $('#ddlRoomBilling').val(roomType.trim());
                    callback($ddlRoomNo.val());

                });
            });
        }
        var getCurrentDate = function (callback) {
            serverCall('EmergencyAdmission.aspx/getCurrentDate', {}, function (response) {
                callback(response);
            });
        }
        $(function () {
            shortcut.add('Alt+S', function () {
                var btnSave = $('#btnSave');
                if (btnSave.length > 0) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        onSaveAdmissionDetaills(btnSave[0]);
                    }
                }
            }, addShortCutOptions);
        });


    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b><span id="lblHeader" style="font-weight: bold;">Emergency Admission</span></b>
            <span style="display: none" id="spnHashCode"></span>
        </div>
        <UC1:OldPatientSearchControl ID="patientInfo" runat="server" />
        <div class="POuter_Box_Inventory">
            <%-- <UC2:AdmissionDetailsControl ID="admissionDetails" runat="server" />--%>
            <div class="row">
                <div class="col-md-21">
                    <div class="col-md-3">
                        <label class="pull-left">Room Type </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlRoomType" onchange="$bindRoomBed(this.value,function(){})" title="Select Room Type"></select>
                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">Room/BedNo     </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlRoomNo" title="Select Bed No."></select>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">DateTime  </label>
                        <b class="pull-right">:</b>
                     </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtAdmissionDate" runat="server" ReadOnly="true" autocomplete="off" ClientIDMode="Static" ToolTip="Select Admission Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExteAdmissionDate" TargetControlID="txtAdmissionDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                    </div>
                     <div class="col-md-1">
                        <asp:TextBox ID="txtAdmissionTimeHour" onlynumber="2" max-value="12" runat="server" ClientIDMode="Static" ToolTip="Enter Hour" MaxLength="2"></asp:TextBox>                        
                    </div>
                    <div class="col-md-1">
                         <asp:TextBox ID="txtAdmissionTimeMinute" onlynumber="2" max-value="59" runat="server" ClientIDMode="Static" ToolTip="Enter Minutes" MaxLength="2"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <asp:DropDownList ID="ddlAdmissionTimeMeridiem" runat="server" ClientIDMode="Static" ToolTip="Select Admission Time Meridiem">
                            <asp:ListItem Value="AM">AM</asp:ListItem>
                            <asp:ListItem Value="PM">PM</asp:ListItem>
                        </asp:DropDownList>
                    </div>                   
                </div>
            </div>
            <div class="row">
              <div class="col-md-21">               
                   <div class="col-md-3" style="display:none">
                        <label class="pull-left">Triaging Codes</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" style="display:none">
                        <select id="ddlTriaging" title="Select Triaging Codes."></select>
                    </div>
              </div>
        </div>
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <input type="hidden" value="EmergencyAdmission" id="txtPage" />
            <input type="button" id="btnSave" onclick="onSaveAdmissionDetaills($('#btnSave'))" class="save margin-top-on-btn" value="Save" />
        </div>
    </div>
</asp:Content>

