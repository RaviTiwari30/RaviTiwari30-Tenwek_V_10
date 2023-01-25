<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPDSearch.aspx.cs" Inherits="Design_CPOE_OPDSearch"MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <style type="text/css">
        .hover {
            background-color: LightBlue;
            cursor: pointer;
            color: blue;
        }

        .GridViewLabItemStyle {
            padding-left: 0px;
        }

        .pageCustomButton {
            box-shadow: none !important;
        }

            .pageCustomButton:active {
                background-color: #018EFF;
                box-shadow: 0 3px #666;
                transform: none !important;
            }
        .callUncall {
            width:46px !important;
        }
    </style>
    <script type="text/javascript">
        function ShowPatient(tnxNo) {
            window.open('PatientReport.aspx?TID=' + tnxNo);
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            searchAppointments();
            jQuery('#<%=ddlDoctor.ClientID%>,#<%=ddlDepartmentlist.ClientID%>').chosen();
             
            var ID = '<%=HttpContext.Current.Session["ID"]%>';
            if (ID=='LSHHI1240') {
                BindStatus(1);
            } else {
                BindStatus(0);
            }

            
        });
        var OpenDivSearchModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#modalReports');
            divSearchbyDate.showModel();
        }
        var CloseDivSearchModel = function () {
            $('#modalReports').closeModel();
        }

        function showPage(id) {
            var value = $(id).siblings('input').val();
            //alert(value);
            
            //$('#iframe1').attr('src', "../Lab/ViewLabReportsWard.aspx?TID=69&TransactionID=69&PatientID=" + value + "&IsEdit=&PID=" + value + "&IsEdit=&LnxNo=78&typeoftnx=CPOE&App_ID=13&Sex&PanelID=1&LabType=OPD&IsIPD=0&MenuID=15");
            $('#iframe1').attr('src', "../Lab/ViewLabReportsWard.aspx?TID=&TransactionID=&PatientID=" + value + "&IsEdit=&PID=" + value + "&IsEdit=&LnxNo=78&typeoftnx=CPOE&App_ID=13&Sex&PanelID=1&LabType=OPD&IsIPD=0&MenuID=15");
            $("#modalReports").show();
        }



        var reseizeIframe = function (elem,isAlreadyViewedPatient) {
            $modelBlockUI();
            var iframe = document.getElementById("iframePatient");
            var row = $(elem).closest('tr');
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {
                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('.patientName').text();
                    contentDocument.getElementById('lblDoctorName').innerHTML = row.find('.patientDoctorName').text();
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('.patientID').text();
                    contentDocument.getElementById('lblPanel').innerHTML = row.find('.patientPanelName').text();
                    contentDocument.getElementById('lblGender').innerHTML = row.find('.patientSex').text();
                    contentDocument.getElementById('lblAge').innerHTML = row.find('.patientAge').text();
                    contentDocument.getElementById('lblAppointmentDate').innerHTML = row.find('.patientAppointmentDate').text() + '/' + row.find('.patientAppointmentNo').text();
                    contentDocument.getElementById('lblAppointmentID').innerHTML = row.find('.patientAppointmentID').text();
                    contentDocument.getElementById('lblPurposeOfVisit').innerHTML = row.find('.PurposeOfVisit').text();
                    $modelUnBlockUI();
                }
                catch (e) {
                    $modelUnBlockUI();
                }

            };
        }
        var closeIframe = function () {
            var iframe = document.getElementById("iframePatient");
            iframe.style.width = '0%';
            iframe.style.height = '0%';
            iframe.style.display = 'none';
            iframe.contentWindow.document.write('');
        }

    </script>
    <script type="text/javascript">
        var searchAppointments = function (callback) {
            if ($('#lblMsg').text() == "You are not a doctor. Kindly contact to IT Department.") {
                modelAlert("Kindly Contact To IT Department.", function () { });
                return;
            }
            $('#btnSearch').attr('disabled', true);
            var data = {
                MRNo: $.trim($('#txtRegNo').val()),
                PName: $.trim($('#txtPName').val()),
                AppNo: $.trim($('#txtAppNo').val()),
                DoctorID: $.trim($('#ddlDoctor').val()),
                status: $.trim($('#ddlStatus').val()),
                fromDate: $.trim($('#fromDate').val()),
                toDate: $.trim($('#ToDate').val()),
                DocDepartment: $.trim($('#ddlDepartmentlist').val()),
                AppStatus: 0
            }
            serverCall('Services/Cpoe_CommonServices.asmx/cpoeSearch', data, function (resposne) {
                var responseData = JSON.parse(resposne);
                console.log(responseData);
                cpoe = responseData.pendingAppointmentList;
                cpoeconfirmed = responseData.viewedAppointmentList;
                cpoeEmergency = responseData.emergencyAppointmentList;
                cpoeEmergrncyViewed = responseData.emergencyViewedAppointmentList;
                

                $('#divPendingAppointmentList').html($('#tb_PendingAppointmentList').parseTemplate(cpoe)).slimScroll({height: '100%',width: '100%',color: 'black'}).customFixedHeader()
                $('#divViewedAppointmentList').html($('#tb_ViewedAppointmentList').parseTemplate(cpoeconfirmed)).slimScroll({height: '100%',width: '100%',color: 'black'}).customFixedHeader();
                $('#divEmergencyAppointmentList').html($('#tb_EmergencyAppointmentLists').parseTemplate(cpoeEmergency)).slimScroll({ height: '100%', width: '100%', color: 'black' }).customFixedHeader();
                $('#divEmergencyViewedAppointmentList').html($('#tb_emergencyViwedAppointmentList').parseTemplate(cpoeEmergrncyViewed)).slimScroll({ height: '100%', width: '100%', color: 'black' }).customFixedHeader();
                $('#lblTotalEmergencyAppointmentPending').text('Total:' + (cpoeEmergency.length + cpoeEmergrncyViewed.length));
                $('#lblTotalAppointmentPending').text('Total:' + (cpoe.length + cpoeconfirmed.length));

                $('#btnSearch').removeAttr("disabled");
                MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                showHideParentDiv();
            });
        }


        

        var soundObject = null;
        function PlaySound() {
            if (soundObject != null) {
                document.body.removeChild(soundObject);
                soundObject.removed = true;
                soundObject = null;
            }
            soundObject = document.createElement("embed");
            soundObject.setAttribute("src", "../DoctorScreen/Sound/INTone.wav");
            soundObject.setAttribute("hidden", true);
            soundObject.setAttribute("autostart", true);
            document.body.appendChild(soundObject);
        }
        var UpdateCall = function (elem, appointmentID, DoctorID) {
            var data = {
                App_ID: $.trim(appointmentID),
                DoctorID: $.trim(DoctorID)
            }
            serverCall('../DoctorScreen/Service/SearchAppointment.asmx/UpdateCall', data, function (response) {
                var responseData = $.trim(response);
                if (responseData == '1') {
                    $(elem).hide();
                    $(elem).parent().find('#Button3,#Button1,#Button19').show();
                    $(elem).closest('td').next().find('.pageCustomButton').attr('disabled', false);
                    PlaySound();
                }
                else {
                    modelAlert("Previous Patient Already Called");
                }
            });
        }

        var UpdateUncall = function (elem,appointmentID) {
            var data = {
                App_ID: $.trim(appointmentID)
            }
            serverCall('../DoctorScreen/Service/SearchAppointment.asmx/UpdateUncall', data, function (response) {
                var responseData = Number(response);
                if (responseData == 1) {
                    $(elem).hide();
                    $(elem).parent().find('#Button4,#Button2,#Button13,#Button20').show();
                    $(elem).closest('td').next().find('.pageCustomButton').attr('disabled', true);
                }
                else 
                    modelAlert("Patient Not Uncall");
            });
        }



        var UpdateOut = function (appointmentID, DoctorID) {
            var data = {
                App_ID: $.trim(appointmentID),
                DoctorID: $.trim(DoctorID)
            }
            serverCall('../DoctorScreen/Service/SearchAppointment.asmx/UpdateOut', data, function (response) {
                var responseData = $.trim(response);
                if (responseData == '1') {
                    searchAppointments(function () {
                        modelAlert("Patient OUT Successfully");
                    });
                }
                else
                    modelAlert("Patient Not Out");
            });
        }
        function UpdateIn(appointmentID) {
        }
        var showHideParentDiv = function () {
            var emergencyListCount = $('#divEmergencyAppointmentList').find('table tbody tr').length;
            if (emergencyListCount > 0)
                $('.emergencyVisits').show();
            var pendingListCount = $('#divPendingAppointmentList').find('table tbody tr').length;
            if (pendingListCount > 0)
                $('.pendingVisits').show();
            var viewedListCount = $('#divViewedAppointmentList').find('table tbody tr').length;
            if (viewedListCount > 0)
                $('.viwedVisits').show();

            var emergencyViewedListCount = $('#divEmergencyViewedAppointmentList').find('table tbody tr').length;
            if (emergencyViewedListCount>0)
                $('.emergencyViwedVisits').show();


            if (emergencyListCount < 1)
                $('#divPendingAppointmentList').height('350px');

            if(emergencyViewedListCount<1)
                $('#divViewedAppointmentList').height('350px');


        }


        function BindStatus(Typ) {
            if (Typ==1) {
                $("#ddlStatus").val(2);
            } else {
                $("#ddlStatus").val(0);
                
            }

        }

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Search Patient Consultation</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="txtRegNo" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Enter UHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="txtPName" runat="server"  TabIndex="2" ClientIDMode="Static"   ToolTip="Enter Patient Name" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            App. No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="txtAppNo" runat="server"  TabIndex="3" ClientIDMode="Static"   ToolTip="Enter  App. No." />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtAppNo"
                            ValidChars="0987654321">
                        </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:DropDownList ID="ddlDoctor" runat="server" Width="100%" ClientIDMode="Static"   TabIndex="4" ToolTip="Select  Doctor Name" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:DropDownList ID="ddlStatus" runat="server" TabIndex="7" ClientIDMode="Static"   ToolTip="Select Status">
                            <asp:ListItem Selected="True" Value="0">Pending</asp:ListItem>
                            <asp:ListItem Value="1">Closed</asp:ListItem>
                            <asp:ListItem Value="2">All</asp:ListItem>
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:DropDownList ID="ddlDepartmentlist" ClientIDMode="Static" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            From App Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="fromDate" runat="server" ToolTip="Select From Date"  ClientIDMode="Static"   TabIndex="8" ></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="fromDate" Format="dd-MMM-yyyy"
                            ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            To App Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="ToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static" TabIndex="9"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtAppointmentDate0_CalendarExtender" runat="server" TargetControlID="ToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-8">
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Search" tabindex="10" id="btnSearch" onclick="searchAppointments()" class="ItDoseButton" />
                        </div>
                         <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
                <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2"></div>
                        <div class="col-md-4" style="display:none">
                            <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:coral; cursor: default;" class="circle" ></button>
                            
                              <b style="margin-top:5px;margin-left:5px;float:left">Emergency</b>
                        </div>
                        <div class="col-md-6" style="display:none">
                           <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:transparent; cursor: default; border:1px solid black"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Pending Temp Status</b> 
                        </div>
                        <div class="col-md-4">
                           <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:pink; cursor: default;" class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Viewed & IN</b> 
                        </div>
                        <div class="col-md-4">
                           <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:green; cursor: default;" class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Refer</b> 
                        </div>
                         <div class="col-md-4">
                                <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:yellow; cursor: default;" class="circle"></button>
                                <b style="margin-top:5px;margin-left:5px;float:left">Hold</b>
                         </div>
                    </div>
                </div>
            </div>
            </div>
        <div class="POuter_Box_Inventory" style="height:380px;">
            <div class="row">
                <div class="col-md-12">
                     <div id="emergencyList" style="display:none"  class="Purchaseheader emergencyVisits">Emergency Appointment Patient List <label class="pull-right" id="lblTotalEmergencyAppointmentPending"></label></div>
                     <div style="height:150px;overflow:auto;display:none" class="emergencyVisits" id="divEmergencyAppointmentList">

                    </div>

                     <div id="pendingList" style="display:none"  class="Purchaseheader pendingVisits">Pending Appointment Patient List <label class="pull-right" id="lblTotalAppointmentPending"></label> </div>
                    <div style="max-height:380px;overflow:auto;display:none" class="pendingVisits" id="divPendingAppointmentList">

                    </div>
                </div>
                <div class="col-md-12">
                    <div id="divEmergencyViwedAppointmentList" style="display:none"  class="Purchaseheader emergencyViwedVisits">Emergency Done Appointment Patient List</div>
                     <div style="height:150px;overflow:auto;display:none" class="emergencyViwedVisits" id="divEmergencyViewedAppointmentList">

                    </div>


                     <div id="doneList" style="display:none" class="Purchaseheader viwedVisits"> Done Appointment Patient List</div>
                     <div style="max-height:380px;overflow:auto;display:none" class="viwedVisits" id="divViewedAppointmentList">

                     </div>
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
</div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>



    <script id="tb_PendingAppointmentList" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOPD" style="width:100%;border-collapse: collapse;">
            <thead>
            <tr id="Header">
                <th class="GridViewHeaderStyle" style="display:none" scope="col" >S/N</th>
                <th class="GridViewHeaderStyle" scope="col" >AppNo.</th>
                <th class="GridViewHeaderStyle" scope="col" >Shortcuts</th>  
                <th class="GridViewHeaderStyle" scope="col" style="display:none">AssignBy</th>                
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Age</th>
                <th class="GridViewHeaderStyle" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Visit Type</th>
                <th class="GridViewHeaderStyle" scope="col" >Doctor</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Status</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">AppID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">LedgertransactionNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">TransactionID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">IsDone</th>
                <th class="GridViewHeaderStyle" scope="col" ></th>
                <th class="GridViewHeaderStyle" scope="col" ></th>
            </tr>
           </thead>
            <tbody>
        <#       
        var dataLength=cpoe.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = cpoe[j];
        #>
                    <tr id="<#=j+1#>" 
                        <#if(objRow.IsEmergency=="1"){#>
                        style="background-color:coral"
                         <#}
                        else if(objRow.Hold =="1"){#>
                        style="background-color:Yellow"
                         <#}
                        else if(objRow.P_In =="1" || objRow.IsCall =="1"){#>
                        style="background-color:Pink"                        
                         <#} 
                          else if(objRow.TemperatureRoom =="0"){#>
                        style="background-color:transparent"
                        <#} 
                          else if(objRow.AppID !=""){#>
                        style="background-color:green"
                        <#}  
                        
                        #>                                                                                             

                        >   
                         
                    <td class="GridViewLabItemStyle" style="display:none" ><#=j+1#></td> 
                    <td class="GridViewLabItemStyle patientAppointmentNo" style="text-align:center" id="tdAppNo"  ><#=objRow.AppNo #></td> 
                    <td class="GridViewLabItemStyle " id="tdshortcut"  > 
                          <a target="pagecontent"   id='AShortcut'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../OPD/FlowSheetViewOpd.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;PType=OPD', 1050, 1050, '73%', '90%');" style="color:yellow;" >FlowSheets</a><br />
                
                    </td>
                        <td class="GridViewLabItemStyle " id="td49" style="display:none"  ><#=objRow.Assign#></td>
                    <td class="GridViewLabItemStyle patientID" id="tdPatientID"  ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle patientName customTooltip trimText" style="max-width:131px" data-title="<#=objRow.Pname#>" id="tdPatientName"
                    <#if(objRow.PatientType=="VIP"){#>style="background-color:orange"<#}
                         else if(objRow.PatientType=="Warning Alert"){#>style="background-color:orange"<#}#>
                        
                        ><#=objRow.Pname#>
                    </td>
                    <td class="GridViewLabItemStyle customTooltip" id="tdAge" data-title="<#=objRow.Age#>/<#=objRow.Sex #>"><#=objRow.Age.replace('MONTH(S)','M(S)') #>/<#=objRow.Gender #></td>
                    <td class="GridViewLabItemStyle patientAppointmentDate"  id="tdAppointmentDate" ><#=objRow.AppointmentDate#></td>
                    <td class="GridViewLabItemStyle patientDoctorName customTooltip trimText" data-title="<#=objRow.DName#>"   style="max-width:100px"  id="tdDName" ><#=objRow.DName#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus" style="display:none"><#=objRow.Status#></td>
                    
                    <td class="GridViewLabItemStyle patientAge" id="td16" style="display:none"><#=objRow.Age#></td>  
                    <td class="GridViewLabItemStyle patientSex" id="td17" style="display:none"><#=objRow.Sex#></td> 
                    <td class="GridViewLabItemStyle patientPanelName" id="td18" style="display:none"><#=objRow.PanelName#></td> 
                    <td class="GridViewLabItemStyle" id="tdVisitType" style="display:none;" ><#=objRow.SubName#></td>
                    <td class="GridViewLabItemStyle patientAppointmentID" id="tdAppID" style="display:none"><#=objRow.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="tdLedgerTnxNo" style="display:none"><#=objRow.LedgerTnxNo#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID"  style="display:none" ><#=objRow.TransactionID#></td>                                                           
                    <td class="GridViewLabItemStyle" id="tdIsDone"  style="display:none" ><#=objRow.IsDone#></td>
                     <td class="GridViewLabItemStyle PurposeOfVisit" id="tdPurposeOfVisit"  style="display:none" ><#=objRow.PurposeOfVisit#></td>                       

                <#if(objRow.P_Out==0){#>

        <%-- Patient Call Start--%>
                        <#if(objRow.IsCall==1) { #>
                                <# if(objRow.P_In==1) {#>                                    
                                      <# if(objRow.IsView==1) {#>  
                                            <td style="text-align: center;" class="GridViewLabItemStyle">
                                                <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button13" onclick="UpdateUncall(this,'<#=objRow.App_ID#>');" disabled="disabled"/>
                                            </td>                                    
                                     <#}else{#>
                                            <td style="text-align: center;" class="GridViewLabItemStyle" >
                                            <input type="button" value="Uncall" class="pageCustomButton callUncall" id="btnUncall" onclick="UpdateUncall(this,'<#=objRow.App_ID#>');" disabled="disabled"/>
                                            
                                <#if(objRow.CanCall==1) { #>
                                                 <input type="button" value="Call" class="pageCustomButton callUncall" id="btncall" onclick="UpdateCall(this, '<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" style="display:none;"/> 
                                           
                                <#} #> 
  </td>
                                     <#}#>
                                <#}else{#>
                                    <td style="text-align: center;" class="GridViewLabItemStyle" >
                                        <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button1" onclick="UpdateUncall(this,'<#=objRow.App_ID#>');" />
                                       
                                <#if(objRow.CanCall==1) { #>
                                         <input type="button" value="Call" class="pageCustomButton callUncall" id="Button2" onclick="UpdateCall(this, '<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" style="display:none;"/>
                                    
                                <#} #> 

                                    </td>
                                <#}#>
                        <#} else {#>
                            <td style="text-align: center;" class="GridViewLabItemStyle" >
                                <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button3" onclick="UpdateUncall(this,'<#=objRow.App_ID#>');" style="display:none;"/>
                               
                                <#if(objRow.CanCall==1) { #>
                                <input type="button" value="Call" class="pageCustomButton callUncall" id="Button4" onclick="UpdateCall(this, '<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" />
                           
                                <#} #>
                                  </td>
                        <#} #>
            <%-- Patient Call End--%>


            <%-- Patient In Start--%>
                     <#if(objRow.IsCall==1) { #>
                             <#if(objRow.Hold==0){#>
                                    <#if(objRow.P_In==1){#>
                                                <#if(objRow.IsView==1){#> 
                                                       <td style="text-align: center;" class="GridViewLabItemStyle" >
                                                         <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                                                             <input type="button" class="pageCustomButton" value="In" id="Button11" onclick="UpdateIn('<#=objRow.App_ID#>');"/>
                                                         </a>
                                                       </td>
                                                <#}else{#>
                                                    <td class="GridViewLabItemStyle" ></td>
                                                <#}#> 
                                    <#}else{#>
                                          <td style="text-align: center;" class="GridViewLabItemStyle" >
                                            <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                                                <input type="button" class="pageCustomButton" value="In" id="Button5" onclick="UpdateIn('<#=objRow.App_ID#>');"/>
                                            </a>
                                         </td>
                                    <#}#> 
                            <#}else{#>
                                 <td style="text-align: center;" class="GridViewLabItemStyle" >
                                            <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                                                <input type="button" class="pageCustomButton" value="In" id="Button12" onclick="UpdateIn('<#=objRow.App_ID#>');"/>
                                            </a>
                                 </td>
                            <#}#> 
                   <#}else{#>
                        <td style="text-align: center;" class="GridViewLabItemStyle" >
                             <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                            <input type="button" value="In" id="Button15" class="pageCustomButton" onclick="UpdateIn('<#=objRow.App_ID#>');" disabled="disabled"/>
                                  </a>
                        </td>
                   <#}#> 

             <%-- Patient In End--%>

             <%-- Patient Out Start--%>
                        <#if(objRow.P_Out==1){#> 
                               <#if(objRow.Hold==1){#> 
                                    <td class="GridViewLabItemStyle" >
                                        <input type="button" value="Out" id="Button9" onclick="UpdateOut('<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" disabled="disabled"/>
                                        <input type="button" value="Hold" id="Button10" onclick="UnHold('<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" disable="disable"/>
                                    </td>
                                <#} else{#>

                                    <td class="GridViewLabItemStyle" >
                                        <input type="button" value="Out" id="Button7" onclick="UpdateOut('<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" disabled="disabled"/>
                                        <input type="button" value="Uncall" id="Button8" onclick="UpdateUncall(this,'<#=objRow.App_ID#>');" disable="disable"/>
                                    </td>
                               <#} #>    
                        <#} #> 
                        <#} else{#>  
                            <td class="GridViewLabItemStyle" ></td>
                            <td class="GridViewLabItemStyle" ></td>
                        <#} #>     
             <%-- Patient Out End--%>    
                    </tr>   
        <#}#>   
            </tbody>    
     </table>    
    </script>



    <script id="tb_EmergencyAppointmentLists" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%;border-collapse: collapse;">
            <thead>
            <tr id="Tr3">
                <th class="GridViewHeaderStyle" scope="col" style="display:none" >S/N</th>
                <th class="GridViewHeaderStyle" scope="col" >No.</th>
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Age/Sex</th>
                <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Visit Type</th>
                <th class="GridViewHeaderStyle" scope="col" >Doctor</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Status</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">AppID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">LedgertransactionNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">TransactionID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">IsDone</th>
                <th class="GridViewHeaderStyle" scope="col" ></th>
                <th class="GridViewHeaderStyle" scope="col" ></th>
            </tr>
           </thead>
            <tbody>
        <#       
        var dataLength=cpoeEmergency.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = cpoeEmergency[j];
        #>
                    <tr id="Tr4" style="background-color:coral">   
                         
                    <td class="GridViewLabItemStyle" style="display:none;text-align:center" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle patientAppointmentNo" style="text-align:center" id="td7"  ><#=objRow.AppNo #></td>
                    <td class="GridViewLabItemStyle patientID" id="td20"  ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle patientName customTooltip trimText" data-title="<#=objRow.Pname#>" id="td21" style="max-width:131px" ><#=objRow.Pname#>
                      
                    </td>
                    <td class="GridViewLabItemStyle customTooltip" id="td22" data-title="<#=objRow.Age#>/<#=objRow.Sex #>"><#=objRow.Age.replace('MONTH(S)','M(S)') #>/<#=objRow.Gender #></td>
                    <td class="GridViewLabItemStyle patientAppointmentDate"  id="td23" ><#=objRow.AppointmentDate#></td>
                    <td class="GridViewLabItemStyle patientDoctorName customTooltip trimText" data-title="<#=objRow.DName#>"   style="max-width:100px"  id="td24" ><#=objRow.DName#></td>
                    <td class="GridViewLabItemStyle" id="td25" style="display:none"><#=objRow.Status#></td>
                    
                    <td class="GridViewLabItemStyle patientAge" id="td26" style="display:none"><#=objRow.Age#></td>  
                    <td class="GridViewLabItemStyle patientSex" id="td27" style="display:none"><#=objRow.Sex#></td> 
                    <td class="GridViewLabItemStyle patientPanelName" id="td28" style="display:none"><#=objRow.PanelName#></td> 
                    <td class="GridViewLabItemStyle" id="td29" style="display:none;" ><#=objRow.SubName#></td>
                    <td class="GridViewLabItemStyle patientAppointmentID" id="td30" style="display:none"><#=objRow.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="td31" style="display:none"><#=objRow.LedgerTnxNo#></td>
                    <td class="GridViewLabItemStyle" id="td32"  style="display:none" ><#=objRow.TransactionID#></td>                                                           
                    <td class="GridViewLabItemStyle" id="td33"  style="display:none" ><#=objRow.IsDone#></td>                          

                <#if(objRow.P_Out==0){#>

        <%-- Patient Call Start--%>
                        <#if(objRow.IsCall==1) { #>
                                <# if(objRow.P_In==1) {#>                                    
                                      <# if(objRow.IsView==1) {#>  
                                            <td style="text-align: center;" class="GridViewLabItemStyle">
                                                <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button6" onclick="UpdateUncall(this, '<#=objRow.App_ID#>');" disabled="disabled"/>
                                            </td>                                    
                                     <#}else{#>
                                            <td style="text-align: center;" class="GridViewLabItemStyle" >
                                            <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button14" onclick="UpdateUncall(this, '<#=objRow.App_ID#>');" disabled="disabled"/>
                                            <input type="button" value="Call" class="pageCustomButton callUncall" id="Button16" onclick="UpdateCall(this, '<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" style="display:none;"/> 
                                            </td>
                                     <#}#>
                                <#}else{#>
                                    <td style="text-align: center;" class="GridViewLabItemStyle" >
                                        <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button17" onclick="UpdateUncall(this, '<#=objRow.App_ID#>');" />
                                        <input type="button" value="Call" class="pageCustomButton callUncall" id="Button18" onclick="UpdateCall(this, '<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" style="display:none;"/>
                                    </td>
                                <#}#>
                        <#} else {#>
                            <td style="text-align: center;" class="GridViewLabItemStyle" >
                                <input type="button" value="Uncall" class="pageCustomButton callUncall" id="Button19" onclick="UpdateUncall(this, '<#=objRow.App_ID#>');" style="display:none;"/>
                                <input type="button" value="Call" class="pageCustomButton callUncall" id="Button20" onclick="UpdateCall(this, '<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" />
                            </td>
                        <#} #>
            <%-- Patient Call End--%>


            <%-- Patient In Start--%>
                     <#if(objRow.IsCall==1) { #>
                             <#if(objRow.Hold==0){#>
                                    <#if(objRow.P_In==1){#>
                                                <#if(objRow.IsView==1){#> 
                                                       <td style="text-align: center;" class="GridViewLabItemStyle" >
                                                         <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                                                             <input type="button" class="pageCustomButton" value="In" id="Button21" onclick="UpdateIn('<#=objRow.App_ID#>');"/>
                                                         </a>
                                                       </td>
                                                <#}else{#>
                                                    <td class="GridViewLabItemStyle" ></td>
                                                <#}#> 
                                    <#}else{#>
                                          <td style="text-align: center;" class="GridViewLabItemStyle" >
                                            <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                                                <input type="button" class="pageCustomButton" value="In" id="Button22" onclick="UpdateIn('<#=objRow.App_ID#>');"/>
                                            </a>
                                         </td>
                                    <#}#> 
                            <#}else{#>
                                 <td style="text-align: center;" class="GridViewLabItemStyle" >
                                            <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                                                <input type="button" class="pageCustomButton" value="In" id="Button23" onclick="UpdateIn('<#=objRow.App_ID#>');"/>
                                            </a>
                                 </td>
                            <#}#> 
                   <#}else{#>
                        <td style="text-align: center;" class="GridViewLabItemStyle" >
                             <a target="iframePatient" onclick="reseizeIframe(this,0);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRow.DoctorID#>&amp;isViwedPatient=0">
                            <input type="button" value="In" id="Button24" class="pageCustomButton" onclick="UpdateIn('<#=objRow.App_ID#>');" disabled="disabled"/>
                                  </a>
                        </td>
                   <#}#> 

             <%-- Patient In End--%>

             <%-- Patient Out Start--%>
                        <#if(objRow.P_Out==1){#> 
                               <#if(objRow.Hold==1){#> 
                                    <td class="GridViewLabItemStyle" >
                                        <input type="button" value="Out" id="Button25" onclick="UpdateOut('<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" disabled="disabled"/>
                                        <input type="button" value="Hold" id="Button26" onclick="UnHold('<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" disable="disable"/>
                                    </td>
                                <#} else{#>

                                    <td class="GridViewLabItemStyle" >
                                        <input type="button" value="Out" id="Button27" onclick="UpdateOut('<#=objRow.App_ID#>', '<#=objRow.DoctorID#>');" disabled="disabled"/>
                                        <input type="button" value="Uncall" id="Button28" onclick="UpdateUncall(this, '<#=objRow.App_ID#>');" disable="disable"/>
                                    </td>
                               <#} #>    
                        <#} #> 
                        <#} else{#>  
                            <td class="GridViewLabItemStyle" ></td>
                            <td class="GridViewLabItemStyle" ></td>
                        <#} #>     
             <%-- Patient Out End--%>    
                    </tr>   
        <#}#>   
            </tbody>    
     </table>    
    </script>



    <script id="tb_ViewedAppointmentList" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOPDConfirmed" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="display:none" >S/N</th>
                <th class="GridViewHeaderStyle" scope="col" >No.</th>
                <th class="GridViewHeaderStyle" scope="col" ></th>
                <th class="GridViewHeaderStyle" scope="col" >Shortcuts</th> 
                <th class="GridViewHeaderStyle" scope="col" >Assignby</th> 
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Age</th>
                <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Date</th>
                
                <th class="GridViewHeaderStyle" scope="col" >View Inv.</th>
                
                <th class="GridViewHeaderStyle" scope="col" >Doctor</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Visit Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Status</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">AppID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">LedgertransactionNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">TransactionID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">IsDone</th>
                
            </tr>
                </thead><tbody>
        <#       
        var dataLengthConfirmed=cpoeconfirmed.length;
        window.status="Total Records Found :"+ dataLengthConfirmed;
        var objRowConfirmed;   
        var status;
        for(var j=0;j<dataLengthConfirmed;j++)
        {       
        objRowConfirmed = cpoeconfirmed[j];
        #>
                    <tr id="Tr2" 
                        <#if(objRowConfirmed.IsEmergency=="1"){#>
                        style="background-color:coral"
                         <#}#>
                        >   
                         
                    <td class="GridViewLabItemStyle" style="display:none;text-align:center" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle patientAppointmentNo" style="text-align:center"  id="td1"  ><#=objRowConfirmed.AppNo #></td>
                         <td style="text-align:center" class="GridViewLabItemStyle" >
                       <a target="iframePatient" onclick="reseizeIframe(this,1);" href="CPOEFolder.aspx?TID=<#=objRowConfirmed.TransactionID#>&amp;LnxNo=<#=objRowConfirmed.LedgerTnxNo#>&amp;IsDone=<#=objRowConfirmed.IsDone#>&amp;PatientID=<#=objRowConfirmed.PatientID#>&amp;App_ID=<#=objRowConfirmed.App_ID#>&amp;PanelID=<#=objRowConfirmed.PanelID#>&amp;PatientCreationtblid=&amp;&notettypeID=&amp;DoctorID=<#=objRowConfirmed.DoctorID#>&amp;isViwedPatient=1"><img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>                          
                    </td>
                        <td class="GridViewLabItemStyle " style="text-align:center"  id="td50"  >
                                <a target="pagecontent"   id='A1'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRowConfirmed.PatientID#>','../OPD/FlowSheetViewOpd.aspx?PatientId=<#=objRowConfirmed.PatientID#>&amp;TransactionId=<#=objRowConfirmed.TransactionID#>&amp;PType=OPD', 1050, 1050, '73%', '90%');" style="color:yellow;" >FlowSheets</a><br />
                
                        </td>
                      
                    <td class="GridViewLabItemStyle" id="td51"  ><#=objRowConfirmed.Assign#></td>      
                    <td class="GridViewLabItemStyle patientID" id="td2"  ><#=objRowConfirmed.PatientID#></td>
                    <td class="GridViewLabItemStyle patientName customTooltip trimText" data-title="<#=objRowConfirmed.Pname#>" style="max-width:131px" id="td3" ><#=objRowConfirmed.Pname#></td>
                   <%-- <td class="GridViewLabItemStyle " id="td4" ><#=objRowConfirmed.Age#> <#=objRowConfirmed.Sex#></td>--%>
                    <td class="GridViewLabItemStyle customTooltip" id="td19" data-title="<#=objRowConfirmed.Age#>/<#=objRowConfirmed.Sex #>"><#=objRowConfirmed.Age.replace('MONTH(S)','M(S)') #>/<#=objRowConfirmed.Gender #></td>
                    <td class="GridViewLabItemStyle patientAppointmentDate" id="td5" ><#=objRowConfirmed.AppointmentDate#>
                 <%--       <#if(objRowConfirmed.labResultCount>0){#>
                              <span style="float:right" class="icon icon-color icon-pdf"></span>
                        <#}#>--%>

                    </td>
                   <%-- <td class="GridViewLabItemStyle patientDoctorName" id="td7" ><#=objRowConfirmed.DName#></td>--%>
                    <td class="GridViewLabItemStyle patientDoctorName" id="td7" >
                        <input type="hidden" value="<#=objRowConfirmed.PatientID#>" /><#if(objRowConfirmed.labResultCount>0){#>
                        <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" onclick="showPage(this);"  /><#}#></td>
                    <td class="GridViewLabItemStyle patientDoctorName customTooltip trimText" data-title="<#=objRowConfirmed.DName#>"   style="max-width:100px"  id="td4" ><#=objRowConfirmed.DName#></td>
                    <td class="GridViewLabItemStyle" id="td6" style="display:none;" ><#=objRowConfirmed.SubName#></td>
                    <td class="GridViewLabItemStyle" id="td8" style="display:none"><#=objRowConfirmed.Status#></td>
                    <td class="GridViewLabItemStyle patientAge" id="td13" style="display:none"><#=objRowConfirmed.Age#></td>  
                    <td class="GridViewLabItemStyle patientSex" id="td14" style="display:none"><#=objRowConfirmed.Sex#></td> 
                    <td class="GridViewLabItemStyle patientPanelName" id="td15" style="display:none"><#=objRowConfirmed.PanelName#></td>                            
                    <td class="GridViewLabItemStyle patientAppointmentID" id="td9" style="display:none"><#=objRowConfirmed.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="td10" style="display:none"><#=objRowConfirmed.LedgerTnxNo#></td>
                    <td class="GridViewLabItemStyle" id="td11"  style="display:none" ><#=objRowConfirmed.TransactionID#></td>                                                           
                    <td class="GridViewLabItemStyle" id="td12"  style="display:none" ><#=objRowConfirmed.IsDone#></td>                               
                   
                    </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>

    <script id="tb_emergencyViwedAppointmentList" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table2" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="Tr5">
                <th class="GridViewHeaderStyle" scope="col" style="display:none" >S/N</th>
                <th class="GridViewHeaderStyle" scope="col" >No.</th>
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Age/Sex</th>
                <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Doctor</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Visit Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">Status</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">AppID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">LedgertransactionNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">TransactionID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display: none">IsDone</th>
                <th class="GridViewHeaderStyle" scope="col" ></th>
            </tr>
                </thead><tbody>
        <#       
        var dataLengthConfirmed=cpoeEmergrncyViewed.length;
        window.status="Total Records Found :"+ dataLengthConfirmed;
        var objRowConfirmed;   
        var status;
        for(var j=0;j<dataLengthConfirmed;j++)
        {       
        objRowConfirmed = cpoeEmergrncyViewed[j];
        #>
                    <tr id="Tr6" style="background-color:coral" >   
                         
                    <td class="GridViewLabItemStyle" style="display:none;text-align:center" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle patientAppointmentNo" style="text-align:center"  id="td34"  ><#=objRowConfirmed.AppNo #></td>
                    <td class="GridViewLabItemStyle patientID" id="td35"  ><#=objRowConfirmed.PatientID#></td>
                    <td class="GridViewLabItemStyle patientName customTooltip trimText" data-title="<#=objRowConfirmed.Pname#>" style="max-width:131px" id="td36" ><#=objRowConfirmed.Pname#></td>
                   <%-- <td class="GridViewLabItemStyle " id="td4" ><#=objRowConfirmed.Age#> <#=objRowConfirmed.Sex#></td>--%>
                    <td class="GridViewLabItemStyle customTooltip" id="td37" data-title="<#=objRowConfirmed.Age#>/<#=objRowConfirmed.Sex #>"><#=objRowConfirmed.Age.replace('MONTH(S)','M(S)') #>/<#=objRowConfirmed.Gender #></td>
                    <td class="GridViewLabItemStyle patientAppointmentDate" id="td38" ><#=objRowConfirmed.AppointmentDate#>

                         <#if(objRowConfirmed.labResultCount>0){#>
                              <span style="float:right" class="icon icon-color icon-pdf"></span>
                        <#}#>
                    </td>
                   <%-- <td class="GridViewLabItemStyle patientDoctorName" id="td7" ><#=objRowConfirmed.DName#></td>--%>
                    <td class="GridViewLabItemStyle patientDoctorName customTooltip trimText" data-title="<#=objRowConfirmed.DName#>"   style="max-width:100px"  id="td39" ><#=objRowConfirmed.DName#></td>
                    <td class="GridViewLabItemStyle" id="td40" style="display:none;" ><#=objRowConfirmed.SubName#></td>
                    <td class="GridViewLabItemStyle" id="td41" style="display:none"><#=objRowConfirmed.Status#></td>
                    <td class="GridViewLabItemStyle patientAge" id="td42" style="display:none"><#=objRowConfirmed.Age#></td>  
                    <td class="GridViewLabItemStyle patientSex" id="td43" style="display:none"><#=objRowConfirmed.Sex#></td> 
                    <td class="GridViewLabItemStyle patientPanelName" id="td44" style="display:none"><#=objRowConfirmed.PanelName#></td>                            
                    <td class="GridViewLabItemStyle patientAppointmentID" id="td45" style="display:none"><#=objRowConfirmed.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="td46" style="display:none"><#=objRowConfirmed.LedgerTnxNo#></td>
                    <td class="GridViewLabItemStyle" id="td47"  style="display:none" ><#=objRowConfirmed.TransactionID#></td>                                                           
                    <td class="GridViewLabItemStyle" id="td48"  style="display:none" ><#=objRowConfirmed.IsDone#></td>                               
                    <td style="text-align:center" class="GridViewLabItemStyle" >
                       <a target="iframePatient" onclick="reseizeIframe(this,1);" href="CPOEFolder.aspx?TID=<#=objRowConfirmed.TransactionID#>&amp;LnxNo=<#=objRowConfirmed.LedgerTnxNo#>&amp;IsDone=<#=objRowConfirmed.IsDone#>&amp;PatientID=<#=objRowConfirmed.PatientID#>&amp;App_ID=<#=objRowConfirmed.App_ID#>&amp;PanelID=<#=objRowConfirmed.PanelID#>&amp;DoctorID=<#=objRowConfirmed.DoctorID#>&amp;isViwedPatient=1"><img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>                          
                    </td>
                    </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>


    <script type="text/javascript">
  function showuploadbox(obj, href, maxh, maxw, w, h, obj) {

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
