<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="DoctorRelatedOPDReport.aspx.cs" Inherits="Design_OPD_DoctorRelatedOPDReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <script type="text/javascript">
          $(function () {
              $('.multiselect').multipleSelect({
                  filter: true, keepOpen: false, width: 100
              });
              $('.multiselectitems').multipleSelect({
                  selectAll: false,
                  filter: true, keepOpen: false, width: 100
              });
              $(".multiselect,.multiselectitems").width('100%');
              $bindCenter(function () {                 
              });
              bindDoctor('All', function () {
              });
              FiledsEnableDisable($('#ddlReportType').val());
              chkIPDNo();
          });
          function show() {
              if ($("#<%=rdoAppType.ClientID %> input[type=radio]:checked").val() == '1') {
                          $('#tdPatientType').show();
                          $('#tdVisitType').show();
                      }
                      else {
                          $('#tdPatientType').hide();
                          $('#tdVisitType').hide();
                      }
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
                        modelAlert('To Date can not be less than From Date');
                        $("#PtReportButtonDiv").hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $("#PtReportButtonDiv").show();
                    }
                }
            });
          }

          function chkIPDNo() {
              if ($("#rdoPtntType input[type=radio]:checked").val() == "2")
                  $("#txtIPDNo").val('').removeAttr('disabled');
              else
                  $("#txtIPDNo").val('').attr('disabled', 'disabled');
          }

          function Getmultiselectvalue(controlvalue) {
              var DepartmentID = "";
              var input = "";
              var SelectedLaength = $(controlvalue).multipleSelect("getSelects").join().split(',').length;
              if (SelectedLaength > 1)
                  DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
              else {
                  if ($(controlvalue).val() != null) {
                      DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
                  }
              }
              return DepartmentID;
          }

          $.fn.listbox = function (params) {
              try {
                  var elem = this.empty();
                  if (params.defaultValue != null || params.defaultValue != '')
                      $.each(params.data, function (index, data) {
                          var dataAttr = {};
                          var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data', JSON.stringify(dataAttr));
                          $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
                          elem.append(option);

                      });
                  if (params.selectedValue != null || params.selectedValue != '' || params.selectedValue != undefined)
                      $(elem).val(params.selectedValue);


                  if (params.isSearchAble || params.isSearchable) {
                      $(elem).multipleSelect({
                          includeSelectAllOption: true,
                          filter: true, keepOpen: false
                      });
                  }
              } catch (e) {
                  console.error(e.stack);
              }
          };

          $bindCenter = function (callBack) {
              var empid = '<%=ViewState["UserID"].ToString()%>';
              serverCall('../../Design/Store/Services/CommonService.asmx/BindCenter', { EmployeeID: empid }, function (response) {
                      if (response != "") {
                          var $lstcenter = $('#lstcenter');
                          $lstcenter.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                      }
                      else {
                          modelAlert('No Record Found');
                      }
                      callBack(true);
                  });
          }

          var bindDoctor = function (department, callback) {              
              var $ddlDoctor = $('#ddlDoctor');
              serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {                 
                  $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                  callback($ddlDoctor.val());
              });
          }

          var FiledsEnableDisable = function (el) {
              if ($(el).val() == "SELECT") {
                  $('#ddlDoctor').prop("disabled", true);
                  $("#ddlDoctorGroup").prop("disabled", true);

                  $("#ddlVisitType").prop("disabled", true);
                  $('#ddlStatus').attr('disabled', 'disabled');                 
                  $('.clsAppType').hide();

                  $('#ddlReferDoctor').attr('disabled', 'disabled');
                  $('#ddlProName').attr('disabled', 'disabled');                  
                  $('.clsAmtType').hide();

                  $('#txtMRNo').attr('disabled', 'disabled');                  
                  $('.clsPtntType').hide();
                 
                  $('.clsISPkgCheck').hide();                  
                  $('.clsReportType').hide();
                  
                  $("#PtReportButtonDiv").hide();
              }
              else if ($(el).val() == "APPSTR") {

                  $('#ddlDoctor').prop('disabled', false).chosen("destroy").chosen();
                  $("#ddlDoctorGroup").prop("disabled", true);

                  $("#ddlVisitType").removeAttr('disabled', 'disabled');
                  $('#ddlStatus').removeAttr('disabled', 'disabled');                 
                  $('.clsAppType').hide();

                  $('#ddlReferDoctor').attr('disabled', 'disabled');
                  $('#ddlProName').attr('disabled', 'disabled');
                  $('.clsAmtType').hide();

                  $('#txtMRNo').attr('disabled', 'disabled');                 
                  $('.clsPtntType').hide();

                  $('.clsISPkgCheck').hide();
                  $('.clsReportType').show();

                  $("#PtReportButtonDiv").show();
              }

              else if ($(el).val() == "DAPPDRPT") {
                  $('#ddlDoctor').prop('disabled', false).chosen("destroy").chosen();
                  $("#ddlDoctorGroup").removeAttr('disabled', 'disabled');

                  $("#ddlVisitType").removeAttr('disabled', 'disabled');
                  $('#ddlStatus').removeAttr('disabled', 'disabled');
                  $('.clsAppType').show();

                  $('#ddlReferDoctor').attr('disabled', 'disabled');
                  $('#ddlProName').attr('disabled', 'disabled');
                  $('.clsAmtType').hide();

                  $('#txtMRNo').attr('disabled', 'disabled');                 
                  $('.clsPtntType').hide();

                  $('.clsISPkgCheck').show();
                  $('.clsReportType').hide();

                  $("#PtReportButtonDiv").show();
                 
              }
              else if ($(el).val() == "DAPPSRPT") {
                  $('#ddlDoctor').prop("disabled", true).chosen("destroy").chosen();
                  $("#ddlDoctorGroup").removeAttr('disabled', 'disabled');

                  $("#ddlVisitType").prop("disabled", true);
                  $('#ddlStatus').attr('disabled', 'disabled');
                  $('.clsAppType').hide();

                  $('#ddlReferDoctor').attr('disabled', 'disabled');
                  $('#ddlProName').attr('disabled', 'disabled');
                  $('.clsAmtType').hide();

                  $('#txtMRNo').attr('disabled', 'disabled');                 
                  $('.clsPtntType').hide();

                  $('.clsISPkgCheck').show();
                  $('.clsReportType').hide();

                  $("#PtReportButtonDiv").show();
              }

              else if ($(el).val() == "BSSRPT") {
                  $('#ddlDoctor').prop("disabled", true).chosen("destroy").chosen();
                  $("#ddlDoctorGroup").prop("disabled", true);

                  $("#ddlVisitType").prop("disabled", true);
                  $('#ddlStatus').attr('disabled', 'disabled');
                  $('.clsAppType').hide();

                  $('#ddlReferDoctor').attr('disabled', 'disabled');
                  $('#ddlProName').attr('disabled', 'disabled');
                  $('.clsAmtType').show();

                  $('#txtMRNo').attr('disabled', 'disabled');                 
                  $('.clsPtntType').hide();

                  $('.clsISPkgCheck').hide();
                  $('.clsReportType').hide();

                  $("#PtReportButtonDiv").show();
              }
              else if ($(el).val() == "DRFFR") {
                  $('#ddlDoctor').prop("disabled", true).chosen("destroy").chosen();
                  $("#ddlDoctorGroup").prop("disabled", true);

                  $("#ddlVisitType").prop("disabled", true);
                  $('#ddlStatus').attr('disabled', 'disabled');
                  $('.clsAppType').hide();

                  $('#ddlReferDoctor').removeAttr('disabled', 'disabled');
                  $('#ddlProName').attr('disabled', 'disabled');
                  $('.clsAmtType').hide();

                  $('#txtMRNo').removeAttr('disabled', 'disabled');                 
                  $('.clsPtntType').show();

                  $('.clsISPkgCheck').hide();
                  $('.clsReportType').hide();

                  $("#PtReportButtonDiv").show();
              }

              else if ($(el).val() == "PROR") {
                  $('#ddlDoctor').prop("disabled", true).chosen("destroy").chosen();
                  $("#ddlDoctorGroup").prop("disabled", true);

                  $("#ddlVisitType").prop("disabled", true);
                  $('#ddlStatus').attr('disabled', 'disabled');
                  $('.clsAppType').hide();

                  $('#ddlReferDoctor').attr('disabled', 'disabled');
                  $('#ddlProName').removeAttr('disabled', 'disabled');
                  $('.clsAmtType').hide();

                  $('#txtMRNo').removeAttr('disabled', 'disabled');
                  $('#txtIPDNo').removeAttr('disabled', 'disabled');
              
                  $('.clsPtntType').hide();

                  $('.clsISPkgCheck').hide();
                  $('.clsReportType').hide();

                  $("#PtReportButtonDiv").show();
              }
          }


          $GetReport = function () {
              $Center = Getmultiselectvalue($('#lstcenter'));
              if ($Center == "") {                  
                      modelAlert('Please select Center.');                     
                      return false;                  
              }
              $ReportType = $('#ddlReportType').val();
              $fromDate = $('#txtFromDate').val();
              $toDate = $('#txtToDate').val();              
              $Doctor = $('#ddlDoctor').val();
              $DoctorGroup = $('#ddlDoctorGroup').val();
              $PatientType = $('#ddlVisitType').val();
              $AppStatus = $('#ddlStatus').val();
              $ReferDoctor = $('#ddlReferDoctor').val();
              $ProName = $('#ddlProName').val();
              $PID = $.trim($('#txtMRNo').val());
              $IPDNo = $.trim($('#txtIPDNo').val());
              $rdoAppType = $('#<%=rdoAppType.ClientID %> input[type=radio]:checked').val(); 
              $rdoVisitType = $('#<%=rdoVisitType.ClientID %> input[type=radio]:checked').val();
              $rdoAmtType = $('#<%=rdoAmtType.ClientID %> input[type=radio]:checked').val();
              $rdoPatientType = $('#<%=rdoPtntType.ClientID %> input[type=radio]:checked').val();
              $rdoReportType = $('#<%=rdoReportType.ClientID %> input[type=radio]:checked').val();             
              $isPackage = $("#chkPackageCondition").is(":checked");            
              $.ajax({
                  url: 'DoctorRelatedOPDReport.aspx/GetReportData',
                  data: '{ReportType:"' + $ReportType + '",fromDate:"' + $fromDate + '",toDate:"' + $toDate + '",Center: "' + $Center + '",Doctor:"' + $Doctor + '",DoctorGroup:"' + $DoctorGroup + '",PatientType:"' + $PatientType + '",AppStatus:"' + $AppStatus + '",ReferDoctor:"' + $ReferDoctor + '",ProName:"' + $ProName + '",PID:"' + $PID + '",IPDNo: "' + $IPDNo + '", rdoAppType: "' + $rdoAppType + '",rdoVisitType: "' + $rdoVisitType + '", rdoAmtType: "' + $rdoAmtType + '", rdoPatientType: "' + $rdoPatientType + '",rdoReportType: "' + $rdoReportType + '",isPackage: "' + $isPackage + '" }',
                  type: 'Post',
                  contentType: 'application/json; charset=utf-8',
                  dataType: 'json',
                  success: function (result) {
                      if (result.d == '1') {
                          window.open('../../Design/common/Commonreport.aspx');
                      }
                      else if (result.d == '2') {
                          window.open('../../Design/common/ExportToExcel.aspx');
                      }
                      else {
                          modelAlert('Record Not Found.');
                      }
                  },
                  error: function (xhr, status) {
                      window.status = status + "\r\n" + xhr.responseText;
                  }

              });

          }

     </script>

     <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Doctors Related OPD Reports</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlReportType" onchange="FiledsEnableDisable(this)">                                
                               <%-- <optgroup label="Doctor wise Report">--%>
                                    <option value="SELECT"> ---Select Report--- </option>  
                                    <option value="APPSTR">&#9755; Appointment Status Report </option>                           
                                    <option value="DAPPDRPT">&#9755; Doctors App. Details Report</option>
                                    <option value="DAPPSRPT">&#9755; Doctors App. Summary Report</option>
                                    <option value="BSSRPT">&#9755; Doctors OPD Business Report</option>
			                        <option value="DRFFR">&#9755; Doctors Refferal Patient Report</option>
							        <option value="PROR">&#9755; PRO Refferal Patient Report</option> 
                               <%-- </optgroup>  --%>                      
                            </select>
                        </div>                       
                        <div class="col-md-3">
                            <label class="pull-left">                                
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" onchange="ChkDate();" TabIndex="3"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExteFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" onchange="ChkDate();" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtenderToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                            Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:ListBox ID="lstcenter" CssClass="multiselect" SelectionMode="Multiple" placeholder="Select Center" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor" ClientIDMode="Static"></select>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Doctor Group</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlDoctorGroup" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">Patient Type</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:DropDownList ID="ddlVisitType" runat="server" ClientIDMode="Static">
                            <asp:ListItem>All</asp:ListItem>
                            <asp:ListItem>Old Patient</asp:ListItem>
                            <asp:ListItem>New Patient</asp:ListItem>
                        </asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">App Status</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server" ClientIDMode="Static">
                            <asp:ListItem>All</asp:ListItem>
                            <asp:ListItem>Confirmed</asp:ListItem>
                            <asp:ListItem>ReScheduled</asp:ListItem>
                            <asp:ListItem>Canceled</asp:ListItem>
                            <asp:ListItem>Pending</asp:ListItem>
                            <asp:ListItem>App Time Expired</asp:ListItem>
                        </asp:DropDownList>
                        </div>

                        <div class="clsAppType">
                         <div class="col-md-3">
                            <label class="pull-left">App. Type</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoAppType" runat="server" ClientIDMode="Static" onchange="show()" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">App. Detail</asp:ListItem>
                                <asp:ListItem Value="1">Patient Type</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                       </div>
                    </div>
                    <div class="row">
                        <div style="display: none;" id="tdPatientType" class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div style="display: none;" id="tdVisitType" class="col-md-12">
                            <asp:RadioButtonList ID="rdoVisitType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                                <asp:ListItem Value="1">Review Patient</asp:ListItem>
                                <asp:ListItem Value="2">New Patient</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        </div>
                      <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">Referal Doctor</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:DropDownList ID="ddlReferDoctor" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Referal Pro</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlProName" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="clsAmtType">
                             <div class="col-md-3">
                                <label class="pull-left">Amount Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoAmtType" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Gross Amt." Selected="True" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Net Amt." Value="2"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                       </div>
                    </div>
                     <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" ClientIDMode="Static" ToolTip="Select To Date" ></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">IPD No.</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static"  MaxLength="10"></asp:TextBox>
                        </div>
                         <div class="clsPtntType">
                             <div class="col-md-3">
                                <label class="pull-left">Patient Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoPtntType" ClientIDMode="Static" onclick="chkIPDNo()" TabIndex="1" runat="server" RepeatDirection="Horizontal" RepeatColumns="3" RepeatLayout="Table">
                                    <asp:ListItem Text="OPD" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Both" Value="3" Selected="True"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-8"></div>
                         <div class="col-md-3"></div>
                        <div class="clsISPkgCheck">
                            <div class="col-md-5">
                                <asp:CheckBox ID="chkPackageCondition" runat="server" Text="Include Package" Clientidmode="Static"  Visible="true" />
                            </div>
                        </div>
                        <div class="clsReportType">
                             <div class="col-md-3">
                                <label class="pull-left">Report Type</label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-5">
                                <asp:RadioButtonList ID="rdoReportType" runat="server" ClientIDMode="Static"  RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="0">Excel</asp:ListItem>
                                <asp:ListItem Value="1">PDF</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
         <div id="PtReportButtonDiv" class="POuter_Box_Inventory" style="text-align: center">            
             <input type="button" class="ItDoseButton" id="btnReport" value="Report" runat="server" clientidmode="Static" title="Click to Open Report"  onclick="$GetReport()" />
        </div>
     </div>
 </asp:Content>

