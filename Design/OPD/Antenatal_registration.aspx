<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Antenatal_registration.aspx.cs" Inherits="Design_OPD_BillRegister" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript">
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                    }
                }
            });
        }

        var patientSearchOnEnter = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) {
                var data = { PatientID: '', PName: '', LName: '', ContactNo: '', Address: '', FromDate: '', ToDate: '', PatientRegStatus: 1, isCheck: '0', AadharCardNo: '', MembershipCardNo: '', DOB: '', IsDOBChecked: '0', Relation: '', RelationName: '', IPDNO: '', panelID: '', cardNo: '' };
                if (e.target.id == 'txtBarcode') {
                    data.PatientID = e.target.value;
                }

                if (data.PatientID == '') {
                    modelAlert('Please Entet UHID !!!');
                    return;
                }

                serverCall('Antenatal_registration.aspx/getpatientdetails', { PatientID: data.PatientID }, function (response) {
                    var responseData = JSON.parse(response);
                    debugger;
                    if (responseData.length > 0) {
                        if (responseData[0].gender.toUpperCase() == 'FEMALE') {
                            $('#lbluhid').text(responseData[0].PatientID);
                            $('#lblpatientname').text(responseData[0].patientname);
                            $('#lblage').text(responseData[0].age);
                            $('#lblgender').text(responseData[0].gender);
                            $('#lblmobile').text(responseData[0].mobile);
                            $('#lblRelationName').text(responseData[0].Relation);
                            $('#lblLedgerTransactionNo').text(responseData[0].LedgerTransactionNo);
                            $('#lblTransaction_ID').text(responseData[0].TransactionID);
                            // $('#ddlRadiologist').val(responseData[0].Doctor_ID);
                            $('#lbltype').text(responseData[0].Type);
                            $('.patientdetails').show();
                        }
                        else {
                            modelAlert('This UHID belongs to Male Patient !!!')
                            $('#lbluhid').text('');
                            $('#lblpatientname').text('');
                            $('#lblage').text('');
                            $('#lblgender').text('');
                            $('#lblmobile').text('');
                            $('#lblRelationName').text('');
                            $('.patientdetails').hide();
                            $('#lblLedgerTransactionNo').text('');
                            $('#lblTransaction_ID').text('');
                            $('#lbltype').text('');
                        }
                    }
                    else {
                        modelAlert('No Record Found !!!')
                        $('#lbluhid').text('');
                        $('#lblpatientname').text('');
                        $('#lblage').text('');
                        $('#lblgender').text('');
                        $('#lblmobile').text('');
                        $('#lblRelationName').text('');
                        $('.patientdetails').hide();
                        $('#lblLedgerTransactionNo').text('');
                        $('#lblTransaction_ID').text('');
                        $('#lbltype').text('');
                    }
                });
            }
        }




        var patientSearch = function () {
            var patientID = $('#txtBarcode').val().trim();

            if (patientID == '') {
                modelAlert('Please Entet UHID !!!');
                return;
            }

            serverCall('Antenatal_registration.aspx/getpatientdetails', { PatientID: patientID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    if (responseData[0].gender.toUpperCase() == 'FEMALE') {
                        $('#lbluhid').text(responseData[0].PatientID);
                        $('#lblpatientname').text(responseData[0].patientname);
                        $('#lblage').text(responseData[0].age);
                        $('#lblgender').text(responseData[0].gender);
                        $('#lblmobile').text(responseData[0].mobile);
                        $('#lblRelationName').text(responseData[0].Relation);
                        $('#lblLedgerTransactionNo').text(responseData[0].LedgerTransactionNo);
                        $('#lblTransaction_ID').text(responseData[0].TransactionID);
                        // $('#ddlRadiologist').val(responseData[0].Doctor_ID);
                        $('#lbltype').text(responseData[0].Type);
                        $('.patientdetails').show();
                    }
                    else {
                        modelAlert('This UHID belongs to Male Patient !!!')
                        $('#lbluhid').text('');
                        $('#lblpatientname').text('');
                        $('#lblage').text('');
                        $('#lblgender').text('');
                        $('#lblmobile').text('');
                        $('#lblRelationName').text('');
                        $('.patientdetails').hide();
                        $('#lblLedgerTransactionNo').text('');
                        $('#lblTransaction_ID').text('');
                        $('#lbltype').text('');
                    }
                }
                else {
                    modelAlert('No Record Found !!!')
                    $('#lbluhid').text('');
                    $('#lblpatientname').text('');
                    $('#lblage').text('');
                    $('#lblgender').text('');
                    $('#lblmobile').text('');
                    $('#lblRelationName').text('');
                    $('.patientdetails').hide();
                    $('#lblLedgerTransactionNo').text('');
                    $('#lblTransaction_ID').text('');
                    $('#lbltype').text('');
                }
            });
        }


        var binddata = function () {
            serverCall('Antenatal_registration.aspx/getpatientdetails', { PatientID: $('#txtBarcode').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    if (responseData[0].gender.toUpperCase() == 'FEMALE') {
                        $('#lbluhid').text(responseData[0].PatientID);
                        $('#lblpatientname').text(responseData[0].patientname);
                        $('#lblage').text(responseData[0].age);
                        $('#lblgender').text(responseData[0].gender);
                        $('#lblmobile').text(responseData[0].mobile);
                        $('#lblRelationName').text(responseData[0].Relation);

                        $('#lblLedgerTransactionNo').text(responseData[0].LedgerTransactionNo);
                        $('#lblTransaction_ID').text(responseData[0].TransactionID);
                        $('#lbltype').text(responseData[0].Type);

                        $('.patientdetails').show();
                    }
                    else {
                        modelAlert('This UHID belongs to Male Patient !!!')
                        $('#lbluhid').text('');
                        $('#lblpatientname').text('');
                        $('#lblage').text('');
                        $('#lblgender').text('');
                        $('#lblmobile').text('');
                        $('#lblRelationName').text('');
                        $('.patientdetails').hide();
                        $('#lblLedgerTransactionNo').text('');
                        $('#lblTransaction_ID').text('');
                        $('#lbltype').text('');
                    }
                }
                else {
                    modelAlert('No Record Found !!!')
                    $('#lbluhid').text('');
                    $('#lblpatientname').text('');
                    $('#lblage').text('');
                    $('#lblgender').text('');
                    $('#lblmobile').text('');
                    $('#lblRelationName').text('');
                    $('.patientdetails').hide();
                    $('#lblLedgerTransactionNo').text('');
                    $('#lblTransaction_ID').text('');

                    $('#lbltype').text('');
                }
            });
        }


        var Bindregistrationpatientdetails = function () {
            var fromdate = $('#FrmDate').val();
            var todate = $('#ToDate').val();
            debugger;

            $("#tabpregnancyDetails tbody tr").remove();

            serverCall('Antenatal_registration.aspx/getregistrationpatientdetails', { fdate: fromdate, tdate: todate }, function (response) {
                var responseData = JSON.parse(response);
                var row = "";
                if (responseData.length > 0) {

                    for (var i = 0; i < responseData.length; i++) {
                        var d = i + 1;
                        row += '<tr>';
                        row += '<td class="GridViewLabItemStyle"  >' + d + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdID" style="display:none" >' + responseData[i].id + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdItemID" >' + responseData[i].PatientID + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdtabname" >' + responseData[i].patientname + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdtabdose" >' + responseData[i].age + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdtime" >' + responseData[i].gender + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tddate" >' + responseData[i].type + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="td1" ><img src="../../Images/edit.png" onclick="onupdateselect(this)" /></td>';
                        row += '</tr>';
                    }
                    $('#tabpregnancyDetails').show();
                    $('#tabpregnancyDetails tbody').append(row)


                }
            });

        }
        var updateID = "";
        var onupdateselect = function (elem) {
            $('#btnupdate').show();
            $('#btnSave').hide();
            debugger;
            var id = $(elem).closest('tr').find('#tdID').text()
            updateID = id;
            serverCall('Antenatal_registration.aspx/onupdateselect', { ID: id }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {

                 //   $('#ddlRadiologist').val(responseData[0].DoctorID);

                    //datepicker("setDate", edd);
                    $('#txtLMP').val(responseData[0].LMP);
                    //$('#txtLMP').datepicker("setDate", responseData[0].LMP);
                    //  $('#txtLMP').val(responseData[0].LMP);
                    $('#txtWeeks').val(responseData[0].WeekOFPreg);
                    $('#ddlIndication').val(responseData[0].Indication);
                    $('#ddlUSGN').val(responseData[0].USGN);

                    $('#ddlRelation').val(responseData[0].Relation);
                    $('#txtNumMalechild').val(responseData[0].NoOfMaleChild);
                    $('#txtNumFemaleChild').val(responseData[0].NoOfFemaleChild);
                    $('#txtEDD').val(responseData[0].EDD);
                    //$('#txtEDD').datepicker("setDate",responseData[0].EDD);

                    //$('#txtLMP') = $.datepicker.formatDate("dd-mm-yy", responseData[0].EDD);

                    $('#txtLMP').val(responseData[0].LMP);



                    $('#lblLedgerTransactionNo').text(responseData[0].LedgertransactionNo);
                    $('#lblTransaction_ID').text(responseData[0].TransactionID);

                    $('#lbltype').text(responseData[0].Type);

                    $('#lbluhid').text(responseData[0].PatientID);
                    $('#txtBarcode').val(responseData[0].PatientID);
                    $('#ddltrimester').val(responseData[0].Trimester);
                    $('#ddlmtp').val(responseData[0].MTP)
                    binddata();


                }
            });
        }

        var savedata = function () {
            debugger;
            if (Validate()) {

                if ($('#lblTransaction_ID').text() == '' || $('#lblLedgerTransactionNo').text() == '' || $('#lbluhid').text() == '') {
                    modelAlert('Please select any patient !!');
                    return;
                }
                var start = new Date($('#txtLMP').val()); //$('#txtLMP').datepicker('getDate');
                var end = Date.now();

                if (start > end) {
                    $('#txtWeeks').val('');
                    $('#txtEDD').val('');
                    $('#txtLMP').val('');

                    alert("Invaild LMP date !!")
                    return;
                }


                getpregnancydetail(function (data) {
                    serverCall('Antenatal_registration.aspx/Save_Pregnancy_details', data, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                window.location.reload();
                            } else {
                                modelAlert(responseData.response);
                            }
                        });
                    });
                });
            }
        }



        var update = function () {
            if (Validate()) {
                if ($('#lblTransaction_ID').text() == '' || $('#lblLedgerTransactionNo').text() == '' || $('#lbluhid').text() == '') {
                    modelAlert('Please select any patient !!');
                    return;
                }
                var start = new Date($('#txtLMP').val()); //$('#txtLMP').datepicker('getDate');
                var end = Date.now();

                if (start > end) {
                    $('#txtWeeks').val('');
                    $('#txtEDD').val('');
                    $('#txtLMP').val('');
                    alert("Invaild LMP date !!");
                    return;
                }
                getpregnancydetail(function (data) {
                    serverCall('Antenatal_registration.aspx/Update_Pregnancy_details', data, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status)
                                window.location.reload();
                        });
                    });
                });
            }
        }

        var getpregnancydetail = function (callback) {
            var data = {
                WeekOFPreg: $('#txtWeeks').val(),
                Indication: $('#ddlIndication').val(),
                USGN: $('#ddlUSGN').val(),
                Relation: $('#ddlRelation').val(),
                NoOfMaleChild: $('#txtNumMalechild').val(),
                NoOfFemaleChild: $('#txtNumFemaleChild').val(),
                TransactionID: $('#lblTransaction_ID').text(),
                LedgertransactionNo: $('#lblLedgerTransactionNo').text(),
                Investigation_ID: '',//$('#ddlInvestigation').val(),
                PatientID: $('#lbluhid').text(),
                USGTest: '',
                TYPE: $('#lbltype').text(),
                DoctorID:'', //$('#ddlRadiologist').val(),
                LMP: $('#txtLMP').val(),
                EDD: $('#txtEDD').val(),
                ID: updateID,
                Trimester: $('#ddltrimester').val(),
                MTP: $('#ddlmtp').val()
            }
            callback({ pregnancyDetails: data });
        }



        function Validate() {
          // if ($('#<%=ddlRadiologist.ClientID%>').val() == "-- Select --") {
          //     alert("Please Select Radiologist");
          //       $('#<%=ddlRadiologist.ClientID%>').focus();
          //     return false;
          // }
            if ($('#<%=ddlInvestigation.ClientID%>').val() == "-- Select --") {
                alert("Please Select Investigation");
                $('#<%=ddlInvestigation.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtWeeks.ClientID%>').val() == "") {
                alert("Please enter Weeks");
                $('#<%=txtWeeks.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtNumMalechild.ClientID%>').val() == "") {
                alert("Please enter No. of Male child");
                $('#<%=txtNumMalechild.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtNumFemaleChild.ClientID%>').val() == "") {
                alert("Please enter No. of female child");
                $('#<%=txtNumFemaleChild.ClientID%>').focus();
                return false;
            }
            return true;
        }

        var OnLMPchange = function () {
            debugger;

            var start = new Date($('#txtLMP').val());

            //  var start = $('#txtLMP').datepicker('getDate');
            var end = Date.now();
            var $weekDiff = Math.floor((end - start + 1) / (1000 * 60 * 60 * 24) / 7);

            var ONEDAY = 1000 * 60 * 60 * 24;
            var difference_ms = Math.abs(start - end);
            var days = Math.round(difference_ms / ONEDAY) + 280;

            var edd = new Date($('#txtLMP').val());
            // var edd = $('#txtLMP').datepicker('getDate');
            var edd_date = edd.setDate(edd.getDate() + 280);

            if (start > end) {
                $('#txtWeeks').val('');
                $('#txtEDD').val('');
                alert("Invaild LMP date !!");

            }
            else {
                $('#txtWeeks').val($weekDiff);
                $("#txtEDD").val(new Date(edd).format('dd-MMM-yyyy'));
                //  $("#txtEDD").datepicker("setDate", edd).datepicker({ dateFormat: 'dd-mm-yyyy' });
            }
        }

        var bindpatient = function () {
            Bindregistrationpatientdetails();
        }

        $(function () {
            //$('[id*=txtLMP]').datepicker({
            //    changeMonth: true,
            //    changeYear: true,
            //    dateFormat: 'dd-mm-yy',
            //    language: "tr"
            //});

            //$('[id*=txtEDD]').datepicker({
            //    changeMonth: true,
            //    changeYear: true,
            //    dateFormat: 'dd-mm-yy',
            //    language: "tr"
            //});

            Bindregistrationpatientdetails();
        });
    </script>
    <style type="text/css">
        .tbl tr td {
            font-weight: 100;
        }

        .blue {
            color: blue;
        }
    </style>

    <div id="Pbody_box_inventory">

        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory ">
            <center><b>Antenatal Patient registration</b></center>
            <label id="lblLedgerTransactionNo" style="display: none"></label>
            <label id="lblTransaction_ID" style="display: none"></label>
            <label id="lbldoctorid" style="display: none"></label>
            <label id="lbltype" style="display: none"></label>
 <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">UHID  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" autocomplete="off" onkeyup="patientSearchOnEnter(event)" id="txtBarcode" maxlength="20" />
                </div>
                <div class="col-md-3">
                    <%--  <label class="pull-left blue"></label>
                    <b class="pull-right">:</b>--%>
                </div>
                <div class="col-md-5">
                    <input type="button" id="Button1" class="ItDoseButton" onclick="patientSearch()" value="Search" />
                </div>

                <div class="col-md-3 patientdetails" style="display: none">
                    <label class="pull-left blue">Selected UHID  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 patientdetails" style="display: none">
                    <label id="lbluhid" class="blue"></label>
                </div>
            </div>
            <div class="row patientdetails" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left blue">Patient Name  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblpatientname" class="blue"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left blue">Age  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblage" class="blue"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left blue">Gender  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblgender" class="blue"></label>
                </div>
            </div>
            <div class="row patientdetails" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left blue">Contact No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblmobile" class="blue"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left blue">Relation Name</label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblRelationName" class="blue"></label>
                </div>
            </div>
            <%--   </div>--%>


            <%--   <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <b>Pregnancy Details</b>
                <asp:Label runat="server" ID="lblPageHeader" Font-Bold="true"></asp:Label>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>--%>
            <%--<div class="POuter_Box_Inventory">--%>

            <div class="row  patientdetails" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left ">Radiologist  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlRadiologist" runat="server" Style="width: 99%;" ClientIDMode="Static" class="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3" style="display: none">
                    <label class="pull-left blue">Investigation  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none">
                    <asp:DropDownList ID="ddlInvestigation" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left ">LMP  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtLMP" runat="server" Width="99%" ClientIDMode="Static" Onchange="OnLMPchange()"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate1" runat="server" TargetControlID="txtLMP" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
            </div>

            <div class="row patientdetails" style="display: none">

                <div class="col-md-3">
                    <label class="pull-left ">Weeks of Preg  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtWeeks" runat="server" Width="99%" ClientIDMode="Static" class="requiredField" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left ">Indication </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlIndication" runat="server" ClientIDMode="Static">
                        <asp:ListItem Text="To diagnose pregancy" Value="To diagnose pregancy"></asp:ListItem>
                        <asp:ListItem Text="Estimation of gestational age" Value="Estimation of gestational age"></asp:ListItem>
                        <asp:ListItem Text="Detection of number fetus" Value="Detection of number fetus"></asp:ListItem>

                        <asp:ListItem Text="Suspected pregnancy with IUCD in-situ" Value="Suspected pregnancy with IUCD in-situ"></asp:ListItem>
                        <asp:ListItem Text="Vaginal bleeding/leaking" Value="Vaginal bleeding/leaking"></asp:ListItem>
                        <asp:ListItem Text="F/U of cases of abortion" Value="F/U of cases of abortion"></asp:ListItem>
                        <asp:ListItem Text="Assessment of cervix" Value="Assessment of cervix"></asp:ListItem>
                        <asp:ListItem Text="Discrepancy b/w uterine size and POA" Value="Discrepancy b/w uterine size and POA"></asp:ListItem>
                        <asp:ListItem Text="Suspected adenexal or uterine pathology" Value="Suspected adenexal or uterine pathology"></asp:ListItem>
                        <asp:ListItem Text="Detection of chromosomal abn" Value="Detection of chromosomal abn"></asp:ListItem>
                        <asp:ListItem Text="Evaluate fetal presentation and position" Value="Evaluate fetal presentation and position"></asp:ListItem>
                        <asp:ListItem Text="Assessment of liquour amnii" Value="Assessment of liquour amnii"></asp:ListItem>
                        <asp:ListItem Text="Preterm labour/ PROM" Value="Preterm labour/ PROM"></asp:ListItem>
                        <asp:ListItem Text="Evaluation of placenta" Value="Evaluation of placenta"></asp:ListItem>
                        <asp:ListItem Text="Evaluation of umblical cord" Value="Evaluation of umblical cord"></asp:ListItem>
                        <asp:ListItem Text="Evaluation of previous LSCS scars" Value="Evaluation of previous LSCS scars"></asp:ListItem>

                        <asp:ListItem Text="Evaluation of fetal well being" Value="Evaluation of fetal well being"></asp:ListItem>
                        <asp:ListItem Text="duplex Doppler studies" Value="duplex Doppler studies"></asp:ListItem>
                        <asp:ListItem Text="Ultasound guided procedures" Value="Ultasound guided procedures"></asp:ListItem>
                        <asp:ListItem Text="Adjunct to interventions" Value="Adjunct to interventions"></asp:ListItem>

                        <asp:ListItem Text="Observation of intrapartum events" Value="Observation of intrapartum events"></asp:ListItem>
                        <asp:ListItem Text="Conditions complicating pregnancy" Value="Conditions complicating pregnancy"></asp:ListItem>
                        <asp:ListItem Text="Research studies in recognized institutions" Value="Research studies in recognized institutions"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left ">USG N/ABN  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlUSGN" runat="server" ClientIDMode="Static">
                        <asp:ListItem Text="FWB SEEN" Value="FWB SEEN"></asp:ListItem>
                        <asp:ListItem Text="CARD. ACT. SEEN" Value="CARD. ACT. SEEN"></asp:ListItem>
                        <asp:ListItem Text="CORD SEEN" Value="CORD SEEN"></asp:ListItem>
                        <asp:ListItem Text="IUD" Value="IUD"></asp:ListItem>
                        <asp:ListItem Text="FWB NOT SEEN" Value="FWB NOT SEEN"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row patientdetails" style="display: none">

                <div class="col-md-3">
                    <label class="pull-left ">Relation  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlRelation" runat="server" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left ">No. of Male child  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtNumMalechild" runat="server" Width="99%" ClientIDMode="Static" class="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" runat="server" TargetControlID="txtNumMalechild"
                        FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left ">No. of Female child  </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtNumFemaleChild" runat="server" Style="width: 99%;" ClientIDMode="Static" class="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtNumFemaleChild"
                        FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                </div>
            </div>

            <div class="row patientdetails" style="display: none">

                <div class="col-md-3">
                    <label class="pull-left ">Expected DD </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtEDD" runat="server" Width="99%" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEDD" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>


                <div class="col-md-3">
                    <label class="pull-left ">Trimester </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddltrimester" runat="server" clientidmode="Static">
                        <option value="I">I</option>
                        <option value="II">II</option>
                        <option value="III">III</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left ">MTP </label>
                    <b class="pull-right ">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlmtp" runat="server"  clientidmode="Static">
                        <option value="Yes">Yes</option>
                        <option value="No">No</option>
                        <option value="NA">NA</option>
                    </select>
                </div>


            </div>

            <div class="row patientdetails" style="display: none">
                <table style="width: 100%;">
                    <tr>
                        <td colspan="6">
                            <center>
                                <input type="button" id="btnSave" class="ItDoseButton" onclick="savedata()" value="Save" />
                                <input type="button" id="btnupdate" class="ItDoseButton" onclick="update()" value="Update" style="display: none" />
                                <%-- <asp:Button ID="btnSave" Text="Save" CssClass="ItDoseButton"  OnClientClick="savedata()" />--%>
                                <%-- <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="ItDoseButton" OnClick="btnUpdate_Click" OnClientClick="return Validate();" />--%>
                            </center>
                        </td>
                    </tr>
                </table>
            </div>
        </div>


        <div class="POuter_Box_Inventory  Purchaseheader">
            <b>Antenatal Patient's</b>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <%--<div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" TabIndex="1" ToolTip="Enter UHID"
                                MaxLength="20" />
                        </div>--%>
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="FrmDate" runat="server" TabIndex="11" ToolTip="Select From Date" onchange="ChkDate();"
                        ClientIDMode="Static"></asp:TextBox>


                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="FrmDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" TabIndex="12" onchange="ChkDate();"
                        ToolTip="Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <center>

                        <input type="button" id="Button2" class="ItDoseButton" onclick="bindpatient()" value="Search" />

                    </center>
                </div>
            </div>


            <div class="row">
                <div class="col-md-24">
                    <div id="tblpregnancyDetails">

                        <table class="FixedTables " cellspacing="0" rules="all" border="1" id="tabpregnancyDetails" style="width: 100%; display: none; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">UHID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Patient Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">age</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Gender</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Type</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>
    </div>





</asp:Content>
