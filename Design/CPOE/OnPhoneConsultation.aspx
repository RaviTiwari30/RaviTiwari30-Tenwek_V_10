<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OnPhoneConsultation.aspx.cs" Inherits="Design_CPOE_OnPhoneConsultation" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>On Phone Consultation</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    UHID :
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtUhid" class="required" />
                </div>

                <div class="col-md-5">
                    <input type="button" id="btnSearch" value="Search" onclick="SearchData()" />
                </div>
                <div class="col-md-3">
                            <input id="btnOldPatient" type="button" onclick="$showOldPatientSearchModel()" value="Old Patient Search" />
                        </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory">



            <div class="row" style="display: none" id="divPatientData">
                <div class="Purchaseheader">
                    <label id="lblPatientHeader">Patient Data</label>
                </div>
                <div id="divList" style="max-height: 400px;">
                    <table class="FixedHeader" id="tblPatientData" cellspacing="0" rules="all" border="1" style="display: none; width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>

                                <th class="GridViewHeaderStyle">UHID</th>
                                <th class="GridViewHeaderStyle">PatientName</th>
                                <th class="GridViewHeaderStyle">Age</th>
                                <th class="GridViewHeaderStyle">Sex</th>
                                <th class="GridViewHeaderStyle">Mobile Number</th>
                                <th class="GridViewHeaderStyle">Panel</th>
                                <th class="GridViewHeaderStyle">Open Encounter</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>


        </div>

    </div>

    <script type="text/javascript">
        function SearchData() {
            var Uhid = $("#txtUhid").val();

            if (Uhid == "") {
                modelAlert("Please Enter UHID.");
                return false;
            }

            serverCall('OnPhoneConsultation.aspx/PhoneConsultation', { PID: Uhid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindPatientData(responseData.response);
                    $('#divPatientData').show();
                }
                else {

                    modelAlert(responseData.response);
                }
            });




        }



        function bindPatientData(data) {
            $('#tblPatientData tbody').empty();

            for (var i = 0; i < data.length > 0; i++) {
                var j = i + 1;

                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdUHID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PatientID + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PatName + '</td>';
                row += '<td id="tdAge" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Age + '</td>';
                row += '<td id="tdSex" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Sex + '</td>';
                row += '<td id="tdMobile" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Mobile + '</td>';
                row += '<td id="tdPanel" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Panel + '</td>';
                row += '<td id="tdOpenCounter" class="GridViewLabItemStyle" style="text-align: center;"><input type="button" value="Open" onclick=OpneEncounter("' + data[i].PatientID + '") /></td>';
                $('#tblPatientData tbody').append(row);
            }

            HideShowTabel();
        }

        function HideShowTabel() {

            var length = $('#tblPatientData tbody tr').length;
            if (length > 0) {
                $('#tblPatientData').show();
            } else {
                $('#tblPatientData').hide();
            }
        }

        function OpneEncounter(Uhid) {
           
            if (Uhid == "") {
                modelAlert("Please Select A  UHID.");
                return false;
            } 
            serverCall('OnPhoneConsultation.aspx/PhoneConsultationSave', { PID: Uhid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    window.open(responseData.response);
                }
                else {

                    modelAlert(responseData.response);
                }
            });
        }

    </script>
 
     <script type="text/javascript">
         var $showOldPatientSearchModel = function () {
             $('#oldPatientModel').showModel();
         }

         var $closeOldPatientSearchModel = function () {
             $('#oldPatientModel').hideModel();
             $('#divSearchModelPatientSearchResults').html('');
         }
  </script>
    <div id="oldPatientModel" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeOldPatientSearchModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Old Patient Search</h4>
            </div>
            <div class="modal-body">
                 <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  UHID    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">

                          <input type="text" id="txtSearchModelMrNO" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Family No.  </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                          <input type="text" id="txtFamilyNo" />
                     </div>
                 </div>
                  <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  First Name    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <input type="text" id="txtSearchModelFirstName" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Last Name   </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <input type="text" id="txtSearchModelLastName" />
                     </div>
                 </div>

                  <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  Contact No.   </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                         <input type="text" id="txtSerachModelContactNo" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Address    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                         <input type="text" id="txtSearchModelAddress" />
                     </div>
                 </div>
                 <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  From Date    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                           <cc1:calendarextender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> To Date    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                          <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                          <cc1:calendarextender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                 </div>


                <div style="text-align:center" class="row">
                       <button type="button"  onclick="$searchOldPatientDetail()">Search</button>
                </div>
                <div style="height:200px"  class="row">
                    <div id="divSearchModelPatientSearchResults" class="col-md-24">


                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:orange" class="circle"></button><b style="float:left;margin-top:5px;margin-left:5px">Admited Patients</b>   
                <button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
            </div>
        </div>
    </div>
</div>
    <script type="text/javascript">
        var _PageSize = 9;
        var _PageNo = 0;
        var $searchOldPatientDetail = function () {
            var data = {
                PatientID: $('#txtSearchModelMrNO').val(),
                PName: $('#txtSearchModelFirstName').val(),
                LName: $('#txtSearchModelLastName').val(),
                ContactNo: $('#txtSerachModelContactNo').val(),
                Address: $('#txtSearchModelAddress').val(),
                FromDate: $('#txtSearchModelFromDate').val(),
                ToDate: $('#txtSerachModelToDate').val(),
                PatientRegStatus: 1,
                isCheck: '0',
                AadharCardNo: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: '0',
                Relation: '0',
                RelationName: '',
                IPDNO: '',
                panelID: '',
                cardNo: '',
                IDProof: '',
                visitID: '',
                emailID: '',
                patientType: '2',
                FamilyNo: $("#txtFamilyNo").val()
            }
            serverCall('../Common/CommonService.asmx/oldPatientSearch', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    OldPatient = JSON.parse(response);
                    if (OldPatient != null) {
                        _PageCount = OldPatient.length / _PageSize;
                        showPage1(0);
                    }
                    else {
                        $('#divSearchModelPatientSearchResults').html('');
                    }
                }
                else
                    $('#divSearchModelPatientSearchResults').html('');

            });
        }
        var $searchPatient = function (data, IPDDetails, callback) {
            var IPDAdmissionDetails = IPDDetails.split('#');
            var IPDTransactionID = IPDAdmissionDetails[0];
            var IPDAdmissionRoomType = IPDAdmissionDetails[1];
            if (!String.isNullOrEmpty(IPDTransactionID)) {
                modelConfirmation('<span style="color: red;">Patient is Already Admited !</span>', '<span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + IPDAdmissionRoomType + '</span>', '', 'Close', function (response) {
                    $getPatientDetails(data.PatientID, function (response) {
                        callback(response);
                    });
                });
            }
            else {
                $getPatientDetails(data.PatientID, function (response) {
                    callback(response);
                });
            }
        }
        function showPage1(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#divSearchModelPatientSearchResults').html(outputPatient);
        }

    </script>
    <script id="tb_OldPatient" type="text/html">
    <table  id="tablePatient" cellspacing="0" rules="all" border="1" 
    style="width:876px;border-collapse :collapse;">
        <thead>
        <tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
            <th class="GridViewHeaderStyle" scope="col" >Title</th>
            <th class="GridViewHeaderStyle" scope="col" >First Name</th>
            <th class="GridViewHeaderStyle" scope="col" >L.Name</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Age</th>
            <th class="GridViewHeaderStyle" scope="col" >Sex</th>
            <th class="GridViewHeaderStyle" scope="col" >Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Address</th>
            <th class="GridViewHeaderStyle" scope="col" >Contact&nbsp;No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Card No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Valid To</th>                          
    
        </tr>
            </thead>
        <tbody>
        <#     
             
              var dataLength=OldPatient.length;
        if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {           
       var objRow = OldPatient[j];
        #>
                        <tr id="<#=j+1#>" 
                            style='cursor:pointer;<#=objRow.IPDDetails!=''?'background-color:orange':'' #>' 
                             <%--<#if(objRow.PatientRegStatus =="2"){#>
                        style="background-color:coral;cursor:pointer;"
                         
                        <#}
                         else {#>
                        style="cursor:pointer;"
                        <#}
                        #>--%>
                            >                            
                        <td class="GridViewLabItemStyle">
                       <%--<a  class="btn" onclick="$searchPatient({PatientID:$.trim($(this).closest('tr').find('#tdPatientID').text()),PatientRegStatus:1},$(this).find('#spnIPDDetails').text(),function(response){$bindPatientDetails(response,function(){ searchDefaultIndentPrescriptions(response,function(){   getPatientIndents(function () { }, 0); }); })});" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
                       --%>
                            <a  class="btn" onclick="$('#txtUhid').val(<#=objRow.MRNo#>);$('#btnSearch').trigger('click');$closeOldPatientSearchModel()" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
                       
                               Select
                           <span style="display:none" id="spnIPDDetails"><#=objRow.IPDDetails#></span>
                       </a>    </td>                                                    
                        <td  class="GridViewLabItemStyle" id="tdTitle"  ><#=objRow.Title#></td>
                        <td class="GridViewLabItemStyle" id="tdPFirstName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PFirstName#></td>
                        <td class="GridViewLabItemStyle" id="tdPLastName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientID"  ><#=objRow.MRNo#></td>
                        <td class="GridViewLabItemStyle" id="tdAge" ><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle" id="tdDate" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Date#></td>
                        <td class="GridViewLabItemStyle" id="tdHouseNo" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.SubHouseNo#></td>
                        <td class="GridViewLabItemStyle" id="tdContactNo" ><#=objRow.ContactNo#></td>  
                        <td class="GridViewLabItemStyle" id="tdCardNo" ><#=objRow.MemberShipCardNo#></td>   
                        <td class="GridViewLabItemStyle" id="tdValidTo" ><#=objRow.MemberShipValidTo#></td>                      
                        
                        <td class="GridViewLabItemStyle" id="tdPatientRegStatus" style="width:80px;display:none"><#=objRow.PatientRegStatus#></td>                         
                        </tr>            
        <#}        
        #>
            </tbody>      
     </table>  
     <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
       <tr>
   <# if(_PageCount>1) {
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
   }
#>
     </tr>     
     </table>  
    </script>
   
    
    
</asp:Content>
