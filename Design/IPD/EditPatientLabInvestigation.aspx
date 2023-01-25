<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EditPatientLabInvestigation.aspx.cs" Inherits="Design_IPD_EditPatientLabInvestigation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
  
    
    <script type="text/javascript" src="../../Scripts/jquery.timepicker.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.timepicker.min.js"></script>
    <link rel="stylesheet" href="../../Styles/jquery.timepicker.css" />
    <link rel="stylesheet" href="../../Styles/jquery.timepicker.min.css" />

    <script type="text/javascript">
        $(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#tb_grdItem table").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:toolkitscriptmanager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:toolkitscriptmanager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Edit Lab Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
            
                    <td style="text-align:right;width:20%">
                       Department :&nbsp; 
                    </td>
                  
                    <td style="text-align:right;width:30%">
                        <asp:RadioButtonList ID="rbtnDepartment"  runat="server" RepeatDirection="Horizontal"  onclick="show();" ClientIDMode="Static">
                            <asp:ListItem Selected="True" Value="0">OPD</asp:ListItem>
                            <asp:ListItem Value="1">IPD</asp:ListItem>
                        </asp:RadioButtonList> 
                    </td>
                  
                    <td> &nbsp;</td>
                    <td></td>
                    <td style="text-align:right; width: 494px;">Lab&nbsp;No.&nbsp;:&nbsp;</td>
                    <td><asp:TextBox ID="txtLabNo" runat="server"  ClientIDMode="Static" Width="100px"></asp:TextBox></td>

                    <td style="width: 20%;text-align:right">
                         <asp:Label ID="lblIPDNo" Text="IPD No. :&nbsp;" runat="server" ClientIDMode="Static"  style="display:none"></asp:Label>
                        </td>
                        <td  style="width: 30%;text-align:left">
                            <asp:TextBox ID="txtCRNo" runat="server" Width="100px" MaxLength="10" ClientIDMode="Static"  ToolTip="Enter IPD No."
                                TabIndex="2" style="display:none"/>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtCRNo" TargetControlID="txtCRNo" FilterType="Numbers" runat="server"></cc1:FilteredTextBoxExtender>
                        </td>
                    
                </tr>
               
                <tr>
                    <td style="text-align:right">From&nbsp;Date&nbsp;:&nbsp;</td>
                    <td style="text-align: left; width: 234px;">
                        &nbsp;<asp:TextBox ID="txtfromDate" runat="server" ToolTip="Select From Date" Width="100px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                       <cc1:calendarextender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:calendarextender>
                    </td>
                    <td style="text-align: left; width: 119px;">
                        &nbsp;</td>
                    <td></td>
                    <td style="text-align: right; width:494px;">
                        To&nbsp;Date&nbsp;:&nbsp;
                    </td>
                    <td style="text-align: left; width: 447px;">
                        <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="100px"
                            TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                       <cc1:calendarextender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:calendarextender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 234px;">
                    </td>
                    <td style="text-align: left; width: 119px;">
                        &nbsp;
                    </td>
                    <td style="text-align: right" colspan="2">
                        &nbsp;
                    </td>
                    <td style="text-align: left; width: 494px;">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
      
       <div class="POuter_Box_Inventory" style="text-align:center">
            
            <input type="button" onclick="searchTest()" value ="Search" id="btnSearch" class="ItDoseButton" />
        </div>
          <div class="POuter_Box_Inventory" style="text-align:center; ">
        <div class="Purchaseheader">Search Result</div>
         <div id="ItemOutput">
            </div>
             </div>
            <div class="POuter_Box_Inventory" style=" width:970px; text-align:center">
        <input id="btnOutUpdate" type="button" value="Update" class="ItDoseButton" title="Click to Update" style="display:none;"/>
        </div>
      
            </div>  
    <script type="text/javascript">
      
        function searchTest() {
            $("#lblMsg").text('');
            var check = $("#rbtnDepartment input[type=radio]:checked").val();
            if (check == "1" && ($("#txtCRNo").val() == "")) {
                $("#lblMsg").text('Please Enter IPD No.');
                $("#txtCRNo").focus();
                return;
            }
            $.ajax({
                url: "EditPatientLabInvestigation.aspx/SearchTest",
                data: '{from:"' + $("#txtfromDate").val() + '",to:"' + $("#txtToDate").val() + '",LabNo:"' + $("#txtLabNo").val() + '",dept:"' + check + '",IPDNO:"' + $("#txtCRNo").val() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    
                    if (result.d != "1") {
                        tabledata = JSON.parse(result.d);
                        if ((tabledata != "") && (tabledata != null)) {
                            var output = $('#tb_Item').parseTemplate(tabledata);
                            $('#ItemOutput').html(output);
                            $('#ItemOutput,#btnOutUpdate,#ItemOutPutHeader').show();
                            
                            BindDate();
                            BindTime();
                            
                        }
                    }
                    else {
                        $('#ItemOutput').html('');
                        $('#ItemOutput,#btnOutUpdate,#ItemOutPutHeader').hide();
                        alert("Record not found");
                    }
                },

                error: function (result) {
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                    
                }
            });
        }

     

    </script>
        <script type="text/javascript">
            function show() {
                if ($("#<%=rbtnDepartment.ClientID %> input[type=radio]:checked").val() == '0') {
                    $("#<%=txtCRNo.ClientID %>").val('').hide();
                    $("#<%=lblIPDNo.ClientID %>").hide();
                    $(".shat").hide();
                }
                else if ($("#<%=rbtnDepartment.ClientID %> input[type=radio]:checked").val() == '1') {
                    $("#<%=txtCRNo.ClientID %>").val('').show();
                    $("#<%=lblIPDNo.ClientID %>,.shat").show();
                }
                $('#ItemOutput').html('');
                $('#ItemOutput,#btnOutUpdate,#ItemOutPutHeader').hide();
            }
           
        </script>

    <script id="tb_Item" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdItem"
	style="width:950px;border-collapse:collapse;">
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 15px;">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 15px;">Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;display:none">Lab No.</th>
           <%-- <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Req. Date--%>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Sample Date
                <input type="checkbox" class="chkReqDate"  onclick="chkAllReqDate()"/>
            </th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Req. Time--%>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Sample Time
                <input type="checkbox" class="chkReqTime"  onclick="chkAllReqTime()"/>
            </th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Sample Date--%>
             <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Report Date
                <input type="checkbox" class="chkSampleDate"  onclick="chkAllSampleDate()"/>
            </th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Sample Time--%>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Report Time
                <input type="checkbox" class="chkSampleTime"  onclick="chkAllSampleTime()"/>
            </th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Reporting Date--%>
             <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Approve Date
                 <input type="checkbox" class="chkReportingDate"  onclick="chkAllReportingDate()"/>
            </th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Reporting Time--%>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Approve Time
                <input type="checkbox" class="chkReportingTime"  onclick="chkAllReportingTime()"/>
            </th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;display:none">DateOfAdmit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;display:none">TimeOfAdmit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;display:none">DateOfDischarge</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;display:none">TimeOfDischarge</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 30px;"><input type="checkbox" onclick='ckhall();' id="checkAll" />Select</th>
                
            </tr>
         <tr id="NewHeader" >
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:15px;">
            <th class="GridViewHeaderStyle" scope="col" style="width:15px;">
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">           
                <input type="text" readonly="readonly" style="display:none;width:90px" class="headerReqDate"    onkeyup="fillAllReqDate(this.value)"/>
            </th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">
                <input type="text"   style="display:none;width:70px" class="headerReqTime"   onkeyup="fillAllReqTime(this.value)"/>
            </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;">
                <input type="text" readonly="readonly" style="display:none;width:90px" class="headerSampleDate" onkeyup="fillAllSampleDate(this.value)"   />

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;">
                 <input type="text" style="display:none;width:70px" class="headerSampleTime" onkeyup="fillAllSampleTime(this.value)"  />

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;">
                  <input type="text" readonly="readonly" style="display:none;width:90px" class="headerReportingDate" onkeyup="fillAllReportingDate(this.value)" />

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;">
                  <input type="text" style="display:none;width:70px" class="headerReportingTime" onkeyup="fillAllReportingTime(this.value)"  />

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">

                 </th>
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;">

                 </th>
                </tr>
            <#       
		var dataLength=tabledata.length;
		window.status="Total Records Found :"+ dataLength;        
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = tabledata[j];
		#>
            <tr id="<#=j+1#>" >             
               <td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdPatientID"><#=objRow.PatientID#></td>
                <td class="GridViewLabItemStyle" id="tdPname"><#=objRow.Pname#></td>
                <td class="GridViewLabItemStyle" id="tdTestName"><#=objRow.Name#></td>
                <td class="GridViewLabItemStyle" id="tdLedgertransactionNo" style="width:50px;text-align:center;display:none;" ><#=objRow.LabNo#></td>                  
                <td class="GridViewLabItemStyle" id="tdInvestigation_Id"  style="width:50px;text-align:center;display:none;" ><#=objRow.Investigation_Id#></td>    
                               
                <td class="GridViewLabItemStyle" id="tdSampleDate"  style="width:50px;text-align:center" >
                    <input style="width:90px;" class="SampleDate"  type="text" value="<#=objRow.SampleDate#>" id="txtSampleDate"/></td>
                <td class="GridViewLabItemStyle" id="tdSampleTime"  style="width:50px;text-align:center" >
                    <input style="width:70px;" class="SampleTime" type="text" onkeypress="javascript:return isNumber (event)" value="<#=objRow.SampleTime#>" id="txtSampleTime"/></td>
               
                <td class="GridViewLabItemStyle" id="tdResultEnteredDate"  style="width:50px;text-align:center" >
                    <input style="width:90px;" class="ResultEnteredDate" type="text"  value="<#=objRow.ResultEnteredDate#>" id="txtResultEnteredDate"/></td>
                <td class="GridViewLabItemStyle" id="tdResultEnteredTime"  style="width:50px;text-align:center" >
                    <input style="width:70px;" class="ResultEnteredTime" type="text" onkeypress="javascript:return isNumber (event)" value="<#=objRow.ResultEnteredTime#>" id="txtResultEnteredTime"/></td>
               
                <td class="GridViewLabItemStyle" id="tdApprovedDate"  style="width:50px;text-align:center" >
                    <input style="width:90px;" class="ApprovedDate"  type="text"  value="<#=objRow.ApprovedDate#>" id="txtApprovedDate"/></td>
                <td class="GridViewLabItemStyle" id="tdApprovedTime"  style="width:50px;text-align:center" >
                    <input style="width:70px;" class="ApprovedTime" type="text" onkeypress="javascript:return isNumber (event)" value="<#=objRow.ApprovedTime#>" id="txtApprovedTime"/></td>
               
                 <td class="GridViewLabItemStyle" id="tdDateOfAdmit" style="display:none">
                     <input  type="text" value="<#=objRow.DateOfAdmit#>" style="width:90px;" 
         class="txtDateOfAdmit" id="txtDateOfAdmit"/></td>                                                                                                              
                 <td class="GridViewLabItemStyle" id="tdTimeOfAdmit" style="display:none">
                      <input  type="text" value="<#=objRow.TimeOfAdmit#>" style="width:90px;" 
         class="txtTimeOfAdmit" id="txtTimeOfAdmit"/> </td>
                   
                 <td class="GridViewLabItemStyle" id="tdDateOfDischarge" style="display:none">
                     <input  type="text" value="<#=objRow.DateOfDischarge#>" style="width:90px;" 
         class="txtDateOfDischarge" id="txtDateOfDischarge"/>
                      </td>
                   
                 <td class="GridViewLabItemStyle" id="tdTimeOfDischarge" style="display:none">
                     <input  type="text" value="<#=objRow.TimeOfDischarge#>" style="width:90px;" 
         class="txtTimeOfDischarge" id="txtTimeOfDischarge"/> </td>


                <td class="GridViewLabItemStyle" id="tdItemEdit" style="width:10px;text-align:center;">
                    <input type="checkbox"  class="chksel" id="chkItem" /></td>
                <td style="display:none" id="tdLedgertnxID">
                    <#=objRow.LedgertnxID#>
                </td>
             </tr>
        <#}#>
        </table>
         </script>
    <script type="text/javascript">
        function ckhall() {
            if ($("#checkAll").attr('checked')) {
                $(".chksel").attr('checked', 'checked');
            }
            else {
                $(".chksel").attr('checked', false);
            }

        }


        </script>

       

    <script type="text/javascript">
        function BindDate() {
            var Today = "";
            $.ajax({
                url: "../Common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    Today = mydata.d;
                }
            });            
            $('#tb_grdItem tr').each(function () {
                $(this).closest('tr').find('input[id^="txtSampleDate"]').attr('readonly', 'readonly');
                $(this).closest('tr').find('input[id^="txtResultEnteredDate"]').attr('readonly', 'readonly');
                $(this).closest('tr').find('input[id^="txtApprovedDate"]').attr('readonly', 'readonly');
            });

            $('#tb_grdItem tr').each(function () {
               var DateOfDischarge = $(this).closest('tr').find('#txtDateOfDischarge').val();
                var DateOfAdmit = $(this).closest('tr').find('#txtDateOfAdmit').val();
                if (DateOfDischarge == "")
                    DateOfDischarge = Today;
                $(this).closest('tr').find('#txtSampleDate').datepicker({
                    changeYear: true,
                    dateFormat: 'dd-M-yy',
                    changeMonth: true,
                    buttonImageOnly: true,
                    maxDate: DateOfDischarge,
                    minDate: DateOfAdmit,
                    onSelect: function (dateText, inst) {
                        $("#txtSampleDate").val(dateText);
                    }
                });
                $(this).closest('tr').find('#txtResultEnteredDate').datepicker({
                    changeYear: true,
                    dateFormat: 'dd-M-yy',
                    changeMonth: true,
                    buttonImageOnly: true,
                    maxDate: DateOfDischarge,
                    minDate: DateOfAdmit,
                    onSelect: function (dateText, inst) {
                        $("#txtResultEnteredDate").val(dateText);
                    }
                });
                $(this).closest('tr').find('#txtApprovedDate').datepicker({
                    changeYear: true,
                    dateFormat: 'dd-M-yy',
                    changeMonth: true,
                    buttonImageOnly: true,
                    maxDate: DateOfDischarge,
                    minDate: DateOfAdmit,
                    onSelect: function (dateText, inst) {
                        $("#txtApprovedDate").val(dateText);
                    }
                });

            });

              
        }
    </script>

        <script type="text/javascript">
            var Today = "";
            function BindTime() {              
                $.ajax({
                    url: "../Common/CommonService.asmx/getTime",
                    data: '{}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        Today = mydata.d;
                    }
                });



                $('#tb_grdItem tr').each(function () {
                    $(this).closest('tr').find('input[id^="txtSampleTime"]').timepicker({
                        changeHour: true,
                        timeFormat: 'hh:mm p',
                        changeMinute: true,
                        interval: 5,
                        ampm: true,
                        onSelect: function (dateText, inst) {
                            $("#txtSampleTime").val(dateText);
                        }
                    });
                });

                $('#tb_grdItem tr').each(function () {
                    $(this).closest('tr').find('input[id^="txtResultEnteredTime"]').timepicker({
                        changeHour: true,
                        timeFormat: 'hh:mm p',
                        changeMinute: true,
                        interval: 5,
                        ampm: true,
                        onSelect: function (dateText, inst) {
                            $("#txtSampleTime").val(dateText);
                        }
                    });
                });

                $('#tb_grdItem tr').each(function () {
                    $(this).closest('tr').find('input[id^="txtApprovedTime"]').timepicker({
                        changeHour: true,
                        timeFormat: 'hh:mm p',
                        changeMinute: true,
                        interval: 5,
                        ampm: true,
                        onSelect: function (dateText, inst) {
                            $("#txtSampleTime").val(dateText);
                        }
                    });
                });
            }
        </script>

      <script type="text/javascript">
          $('#btnOutUpdate').click(function () {
              $("#lblMsg").text('');
              //$('#tb_grdItem tr').each(function () {
              //    if ((id != "Header") && (id != "NewHeader") && ($(this).closest('tr').find('#chkItem').is(':checked'))) {

              //        var sampleDate = $(this).closest('tr').find('#txtSampleDate').val();
              //        var sampleTime = $(this).closest('tr').find('#txtSampleTime').val();
              //        var resultEnteredDate = $(this).closest('tr').find('#txtResultEnteredDate').val();
              //        var resultEnteredTime = $(this).closest('tr').find('#txtResultEnteredTime').val();
              //        var approvedDate = $(this).closest('tr').find('#txtApprovedDate').val();
              //        var approvedTime = $(this).closest('tr').find('#txtApprovedTime').val();
              //        var dateOfAdmit = $(this).closest('tr').find('#txtDateOfAdmit').val();
              //        var timeOfAdmit = $(this).closest('tr').find('#txtTimeOfAdmit').val();
              //        var dateOfDischarge = $(this).closest('tr').find('#txtDateOfDischarge').val();
              //        var timeOfDischarge = $(this).closest('tr').find('#txtTimeOfDischarge').val();
              //        var begT = new Date(sampleDate + " " + sampleTime);
              //        var endT = new Date(dteString + " " + $('#EndTime').val());

              //    }

              //});
              var result = new Array();
              var chkcount = 0;
              $('#tb_grdItem tr').each(function () {
                  var id = $(this).attr("id");
                  var $rowid = $(this).closest("tr");
                  if ((id != "Header") && (id != "NewHeader") &&($(this).closest('tr').find('#chkItem').is(':checked')))  {
                      var objMed = new Object();
                      objMed.Investigation_Id = $(this).closest('tr').find('#tdInvestigation_Id').text();
                      objMed.LedgertransactionNo = $(this).closest('tr').find('#tdLedgertransactionNo').text();
                      objMed.SampleDate = $(this).closest('tr').find('#txtSampleDate').val();
                      objMed.SampleTime = $(this).closest('tr').find('#txtSampleTime').val();
                      objMed.ResultEnteredDate = $(this).closest('tr').find('#txtResultEnteredDate').val();
                      objMed.ResultEnteredTime = $(this).closest('tr').find('#txtResultEnteredTime').val();
                      objMed.ApprovedDate = $(this).closest('tr').find('#txtApprovedDate').val();
                      objMed.ApprovedTime = $(this).closest('tr').find('#txtApprovedTime').val();
                      objMed.dateOfAdmit = $(this).closest('tr').find('#txtDateOfAdmit').val();
                      objMed.timeOfAdmit = $(this).closest('tr').find('#txtTimeOfAdmit').val();
                      objMed.dateOfDischarge = $(this).closest('tr').find('#txtDateOfDischarge').val();
                      objMed.timeOfDischarge = $(this).closest('tr').find('#txtTimeOfDischarge').val();
                      objMed.sNo = $(this).closest('tr').find('#tdSNo').text();
                      objMed.LedgertnxID = $(this).closest('tr').find('#tdLedgertnxID').text();
                      result.push(objMed);
                      
                      chkcount++;
                  }
                  
                  
              });
              if (chkcount == "0") {
                  return;
              }
              var check1 = $("#rbtnDepartment :checked").val();

              $.ajax({
                  url: "EditPatientLabInvestigation.aspx/UpdateTiming",
                  data: JSON.stringify({ dataMed: result, dept: check1 }),
                  type: "Post",
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  success: function (result) {
                      
                      if (result.d == "1") {
                          $('#ItemOutput,#btnOutUpdate,#ItemOutPutHeader').hide();
                          alert("Record Update Successfully");
                          $("#lblMsg").text('Record Saved Successfully');
                      }                    
                      else if (result.d == "2") {
                          alert("Record Not Update");
                      }
                      else {
                          grdItem = jQuery.parseJSON(result.d);
                          for (i = 0; i < grdItem.length; i++) {
                              $('#tb_grdItem tr').each(function () {
                                  var id = $(this).attr("id");
                                  var $rowid = $(this).closest("tr");
                                  if ((id != "Header") && (id != "NewHeader") && ($(this).closest('tr').find('#chkItem').is(':checked'))) {
                                      if (grdItem[i].sNo == $(this).closest('tr').find('#tdSNo').text()) {
                                          var titleText = grdItem[i].Title;;
                                          $(this).closest('tr').css("background-color", "#FF0000");
                                          $("#lblMsg").text('Please Enter Valid Date Time');
                                      }
                                  }
                                  else {
                                      $(this).closest('tr').css("background-color", "transparent");
                                  }

                              });
                          }

                      }
                      
                  },
                  error: function (result) {
                      $("#lblMsg").text('Error occurred, Please contact administrator');

                  }
              });
          });

          function fillAllReqDate(rowID) {
              var DateOfDischarge = $('.txtDateOfDischarge').val();
              var DateOfAdmit = $('.txtDateOfAdmit').val();
              if (DateOfDischarge == "")
                  DateOfDischarge = getCurrentDate();
              $('.headerReqDate').datepicker({
                  changeYear: true,
                  dateFormat: 'dd-M-yy',
                  changeMonth: true,
                  buttonImageOnly: true,
                  maxDate: DateOfDischarge,
                  minDate: DateOfAdmit,
                  onSelect: function (dateText, inst) {
                      $('.SampleDate').val(dateText);
                  }
              });

          }

          function chkAllReqDate() {
              if ($(".chkReqDate").is(':checked')) {
                  $(".headerReqDate").show();
                  fillAllReqDate(this);
              }
              else {
                  $(".headerReqDate").val('').hide();
              }
          }
          function getCurrentDate() {
              var currentdate = "";
              $.ajax({
                  url: "../Common/CommonService.asmx/getDate",
                  data: '{}',
                  type: "POST",
                  async: false,
                  dataType: "json",
                  contentType: "application/json; charset=utf-8",
                  success: function (mydata) {
                      currentdate= mydata.d;
                  }
              });
              return currentdate;
          }
          function chkAllSampleDate() {
              if ($(".chkSampleDate").is(':checked')) {
                  $(".headerSampleDate").show();
                  fillAllSampleDate(this);
              }
              else {
                  $(".headerSampleDate").val('').hide();
              }
          }
          function fillAllSampleDate(rowID) {
              var DateOfDischarge = $('.txtDateOfDischarge').val();
              var DateOfAdmit = $('.txtDateOfAdmit').val();
              if (DateOfDischarge == "")
                  DateOfDischarge = getCurrentDate();
              $('.headerSampleDate').datepicker({
                  changeYear: true,
                  dateFormat: 'dd-M-yy',
                  changeMonth: true,
                  buttonImageOnly: true,
                  maxDate: DateOfDischarge,
                  minDate: DateOfAdmit,
                  onSelect: function (dateText, inst) {
                      $('.ResultEnteredDate').val(dateText);
                  }
              });
          }

          function chkAllReportingDate() {
              if ($(".chkReportingDate").is(':checked')) {
                  $(".headerReportingDate").show();
                  fillAllReportingDate(this);
              }
              else {
                  $(".headerReportingDate").val('').hide();
              }
          }

          function fillAllReportingDate() {
              var DateOfDischarge = $('.txtDateOfDischarge').val();
              var DateOfAdmit = $('.txtDateOfAdmit').val();
              if (DateOfDischarge == "")
                  DateOfDischarge = getCurrentDate();
              $('.headerReportingDate').datepicker({
                  changeYear: true,
                  dateFormat: 'dd-M-yy',
                  changeMonth: true,
                  buttonImageOnly: true,
                  maxDate: DateOfDischarge,
                  minDate: DateOfAdmit,
                  onSelect: function (dateText, inst) {
                      $('.ApprovedDate').val(dateText);
                  }
              });
          }

          function chkAllReqTime() {
              if ($(".chkReqTime").is(':checked')) {
                  $(".headerReqTime").show();
              }
              else {
                  $(".headerReqTime").val('').hide();
              }
          }

          function fillAllReqTime(rowID) {
              $(".SampleTime").val(rowID);
          }


          function chkAllSampleTime() {
              if ($(".chkSampleTime").is(':checked')) {
                  $(".headerSampleTime").show();
              }
              else {
                  $(".headerSampleTime").val('').hide();
              }
          }

          function fillAllSampleTime(rowID) {
              $(".ResultEnteredTime").val(rowID);
          }
          function chkAllReportingTime() {
              if ($(".chkReportingTime").is(':checked')) {
                  $(".headerReportingTime").show();
              }
              else {
                  $(".headerReportingTime").val('').hide();
              }
          }

          function fillAllReportingTime(rowID) {
              $(".ApprovedTime").val(rowID);
          }

          function isNumber(rowID) {

          }
    </script>
</asp:Content>

