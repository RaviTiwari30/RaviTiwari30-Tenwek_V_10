<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientEncounterHistory.aspx.cs" Inherits="Design_OPD_PatientEncounterHistory" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
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
                            <a  class="btn" onclick="$('#txtUhid').val(<#=objRow.MRNo#>);$closeOldPatientSearchModel()" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
                       
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
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Encounter History</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">

                <div class="col-md-3">UHID :</div>
                <div class="col-md-5">
                    <input type="text" id="txtUhid" />
                </div>
                <div class="col-md-3">Encounter No.:</div>
                <div class="col-md-5">
                    <input type="text" id="txtEncounterNo" />
                </div>
                 <div class="col-md-3">
                            <input id="btnOldPatient" type="button" onclick="$showOldPatientSearchModel()" value="Old Patient Search" />
                        </div>
                           
                <div class="col-md-3" style="display:none">
                    <input type="checkbox" id="chkIsEmergency" value="EMG" />
                        <label for="chkIsEmergency">Is Emergency No.</label>
                </div>
            </div>
            <div class="row">
                    <div class="col-md-3">
							   <input type="checkbox" id="chkdate" value="1" /> From Date: 
							
						</div>
						<div class="col-md-5">
								<asp:TextBox ID="txtSearchFromDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							<cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							To Date: 
							
						</div>
						<div class="col-md-5">
							  <asp:TextBox ID="txtSearchToDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select To Date" ></asp:TextBox>
							  <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>


                <div class="col-md-3">
                    <label class="pull-left">
                        Center Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" ClientIDMode="Static">
                    </asp:DropDownList>

                </div>
                    </div>

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <input type="button" id="btnSearch" value="Search" onclick="Search()" />

                </div>
            </div>
        </div>

        <div id="divHistory" style="display:none">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="col-md-24" style="text-align: center; font-weight: bolder">Details</div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row ">
                    <div class="col-md-24" id="div1" style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" id="tblDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 90px;">Encounter No.</th>
                                    <th class="GridViewHeaderStyle">Encounter Date</th>
                                    <th class="GridViewHeaderStyle">Service Head</th>
                                    <th class="GridViewHeaderStyle">Service Name</th>
                                    <th class="GridViewHeaderStyle">Panel</th>                                     
                                    <th class="GridViewHeaderStyle" style="width: 50px;">View Details</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <div id="divSummary" style="display:none">
        <div class="POuter_Box_Inventory">
            <div class="col-md-24" style="text-align: center; font-weight: bolder">Summary</div>
         <div class="col-md-1"><div style="background-color:aqua;width: 30px;height: 30px; border-radius: 50px;"></div></div>
            <div class="col-md-5" style="font-weight:bolder;margin-top: 10px;">On Call Consultation</div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <div class="row ">

                <div class="col-md-24" id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblEncounterNo" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SN.</th>


                                <th class="GridViewHeaderStyle">Patient Id</th>
                                 <th class="GridViewHeaderStyle">Centre</th>

                                <th class="GridViewHeaderStyle">Name</th>

                                <th class="GridViewHeaderStyle">Age</th>

                                <th class="GridViewHeaderStyle">Gender</th>

                                <th class="GridViewHeaderStyle">Encounter No.</th>

                                <th class="GridViewHeaderStyle">Encounter Date</th>

                                
                                <th class="GridViewHeaderStyle">Type</th>

                                <th class="GridViewHeaderStyle" style="width: 50px;">Action</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
     </div>
         
    <div  id="modalReports" class="modal fade">    
    <div class="modal-dialog"  tabindex="-1" >
            <div class="modal-content" style="width:1200px;height:600px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modalReports" area-hidden="true">&times;</button>
                    <b class="modal-title">Lab Report</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <iframe  style="width:100%;height:450px;" id="iframe1" ></iframe>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="divSearchbyDate">Close</button>
                </div>
            </div>
        </div>
        </div>


    
    <div  id="ModelAlertIpdFrame" class="modal fade">
    
    <div class="modal-dialog"  tabindex="-1" >
            <div class="modal-content" style="width:1200px;height:600px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="ModelAlertIpdFrame" area-hidden="true">&times;</button>
                    <b class="modal-title"><label id="lblMHeader">Ipd Frame</label></b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <iframe  style="width:100%;height:450px;" id="ipdiframe" ></iframe>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="ModelAlertIpdFrame">Close</button>
                </div>
            </div>
        </div>
        </div>





    </div>
            
 <a id="various2" style="display:none">Ajax</a>  

    <script type="text/javascript">

        $(document).ready(function () {

            // Search();

        });
        var OpenDivSearchModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#modalReports');
            divSearchbyDate.showModel();
        }
        var CloseDivSearchModel = function () {
            $('#modalReports').closeModel();
        }

        function showPage(id,EncounterNo) {
            var value = id;
            
            $('#iframe1').attr('src', "../Lab/ViewLabReportsWard.aspx?TID=&TransactionID=&PatientID=" + value + "&IsEdit=&PID=" + value + "&IsEdit=&LnxNo=&typeoftnx=CPOE&App_ID=&Sex&PanelID=&LabType=OPD&IsIPD=0&EncounterNo=" + EncounterNo + "&MenuID=15");
            $("#modalReports").show();
        }


        var OpenDivIpdModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#ModelAlertIpdFrame');
            divSearchbyDate.showModel();
        }
        var CloseDivIpdModel = function () {
            $('#ModelAlertIpdFrame').closeModel();
        }

        function showIpdFrame(rowID) {
             
               

             var Pid=$(rowID).closest('tr').find("#lblPatientId").text();            
             var Tid=$(rowID).closest('tr').find("#lblTid").text();
             var PanelId = $(rowID).closest('tr').find("#lblPanelId").text();
             var Sex = $(rowID).closest('tr').find("#lblSex").text();

            
            $('#ipdiframe').attr('src', "../IPD/IPFolder.aspx?App_ID=&TID="+Tid+"&BillNo=&PID="+Pid+"&LoginType=213&BillNo=&sex="+Sex+"&PanelID="+PanelId+"&DoctorID=");
           
            HideHeader();

            $("#lblMHeader").text("Ipd Frame");
            $("#ModelAlertIpdFrame").show();
        }

        function showEmgFrame(rowID) { 

            var Pid = $(rowID).closest('tr').find("#lblPatientId").text();
            var Tid = $(rowID).closest('tr').find("#lblTid").text();
            var PanelId = $(rowID).closest('tr').find("#lblPanelId").text();
            var EmgNO = $(rowID).closest('tr').find("#lblEncounterNo").text();
            var Sex = $(rowID).closest('tr').find("#lblSex").text();
            $('#ipdiframe').attr('src', "../Emergency/IPFolder.aspx?TID=" + Tid + "&PID=" + Pid + "&EMGNo=" + EmgNO + "&LTnxNo=&App_ID=");

            HideHeader();

            $("#lblMHeader").text("Emergency Frame");
            $("#ModelAlertIpdFrame").show();
        }


        function HideHeader() {          
            var $MyFrame = $("#ipdiframe");             
            $MyFrame.load(function () {
                var frameBody = $MyFrame.contents().find('body');
                 
                var $header = frameBody.find('#header');
                $header.hide();
                  
            });
        }


        function MaintbableHideShow(type) {
            if (type==0) {
                $("#divSummary").hide();
                $("#divHistory").hide();
            } else {
                $("#divSummary").show();
            }
            
        }

        function ParentTableHideShow(type) {
            if (type == 0) {
                
                $("#divHistory").hide();
            } else {
                $("#divHistory").show();
            }
        }



        function Search() {
            var uhid = $("#txtUhid").val();
            var EncounterNo = $("#txtEncounterNo").val();
            var CentreId = $("#ddlCentre").val();
            var IsEmg = 0;
            var chkDate = 0;
            if ($('#chkIsEmergency').is(":checked")) {
                IsEmg = 1;
            }
            if ($('#chkdate').is(":checked")) {
                chkDate = 1;
            }



            var fromdate = $('#<%=txtSearchFromDate.ClientID %>').val();
            var todate = $('#<%=txtSearchToDate.ClientID %>').val();
            //if ((uhid == "" || uhid == undefined || uhid == null) && (EncounterNo == "" || EncounterNo == undefined || EncounterNo == null) && (fromdate == "" || fromdate == undefined || fromdate == null) && (todate == "" || todate == undefined || todate == null)) {
            //    modelAlert("Enter Search Critera ");
            //    return false;
            //}
            if ((uhid == "" || uhid == undefined || uhid == null) && (EncounterNo == "" || EncounterNo == undefined || EncounterNo == null) && chkDate=="0") {
                modelAlert("Enter Any Search criteria. ");
                return false;
            }
            serverCall('PatientEncounterHistory.aspx/GetDataToFill', { chkDate: chkDate, IsEmg: IsEmg, PatientId: uhid, EncounterNo: EncounterNo, FromDate: fromdate, ToDate: todate, CentreId: CentreId }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tblEncounterNo tbody').empty();
                    $.each(data, function (i, item) {

                        var RowColor = "";

                        if (item.IsPhoneConsultation==1) {
                            RowColor = "style='background-color: aqua;'";
                        }


                        var rdb = '';
                        rdb += '<tr ' + RowColor + '>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle" > <lable id="lblPatientId">' + item.PatientId + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle" > <lable id="lblPatientId">' + item.CentreName + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle">' + item.NAME + '</td>';
                        rdb += '<td class="GridViewItemStyle">  ' + item.Age + ' </td>';
                        rdb += '<td class="GridViewItemStyle">' + item.Sex + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.EncounterNo + '</td>';

                        rdb += '<td class="GridViewItemStyle">' + item.EntryDate + '</td>';
                       
                        rdb += '<td class="GridViewItemStyle">' + item.Typ + '</td>';

                        if (item.Typ=="IPD") {
                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="View" data-title="Click to View" onclick="showIpdFrame(this)"/></td>';

                        }
                        else if (item.Typ == "Emergency") {
                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="View" data-title="Click to View" onclick="showEmgFrame(this)"/></td>';

                        }
                        else {
                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="View" data-title="Click to View" onclick="GetDetails(' + item.EncounterNo + ')"/></td>';

                        }
                       

                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblTid">' + item.EncounterId + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblPanelId">' + item.PanelId + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblSex">' + item.Sex + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblEncounterNo">' + item.EncounterNo + '</lable></td>';


                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblEncounterId">' + item.EncounterId + '</lable></td>';

                        rdb += '</tr> ';

                        $('#tblEncounterNo tbody').append(rdb);
                    });
                    MaintbableHideShow(1);
                    ParentTableHideShow(0);

                } else {
                    $('#tblEncounterNo tbody').empty();
                    MaintbableHideShow(0);
                    ParentTableHideShow(0);
                    modelAlert(GetData.data);
                }

            });
        }





        function GetDetails(id) {
            
            var EncounterNo = id;
            if ( (EncounterNo == "" || EncounterNo == undefined || EncounterNo == null)) {
                modelAlert("Enter Search Critera ");
                return false;
            }
            serverCall('PatientEncounterHistory.aspx/GetDataDetails', { EncounterNo: EncounterNo }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                  
                    $('#tblDetails tbody').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<tr>';
                       
                        rdb += '<td class="GridViewItemStyle" >  ' + item.EncounterNo + '</td>';

                        rdb += '<td class="GridViewItemStyle">' + item.EncounterDate + '</td>';
                        rdb += '<td class="GridViewItemStyle">  ' + item.SeviceHead + ' </td>';
                        rdb += '<td class="GridViewItemStyle">' + item.ServiceName + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.PanelName + '</td>';
                        if (item.CategoryID == 1) {
                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="View Pescription" data-title="Click to View" onclick="bindPatientHistory(' + item.PatientID + ')"/></td>';

                        }
                        else if (item.CategoryID == 3 || item.CategoryID==7) {
                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="View Report" data-title="Click to View" onclick="showPage(' + item.PatientID + ','+item.EncounterNo+')"/></td>';

                        }else {
                            
                        }
                        rdb += '</tr> ';

                        $('#tblDetails tbody').append(rdb);
                    });
                    ParentTableHideShow(1);

                } else {
                    $('#tblDetails tbody').empty();
                    ParentTableHideShow(0);
                    modelAlert(GetData.data);
                }

            });
        }



        var bindPatientHistory = function (patientID) {
 
            if (!String.isNullOrEmpty(patientID)) {
                //$("#various2").attr('href', '../CPOE/Investigation.aspx?PID=' + patientID + "&TID=" + TransactionID + "App_ID=0&LnxNo=" + LedgerTransactionNo);
                //$("#various2").fancybox({
                //    maxWidth: 1360,
                //    maxHeight: 112500,
                //    fitToView: false,
                //    width: '100%',
                //    height: '100%',
                //    autoSize: false,
                //    closeClick: false,
                //    openEffect: 'none',
                //    closeEffect: 'none',
                //    'type': 'iframe'
                //});
                //$("#various2").trigger('click');
                var href = "../CPOE/Investigation.aspx?PID=" + patientID;
                showuploadbox(href, 1400, 1360, '100%', '100%');
            }
            else {
                modelAlert('No Previous Visit History Found !!!');
            }
        }
        function showuploadbox(href, maxh, maxw, w, h) {
            $.fancybox({
                maxWidth: maxw,
                maxHeight: maxh,
                fitToView: false,
                width: w,
                href: href,
                height: h,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }



    </script>







</asp:Content>
