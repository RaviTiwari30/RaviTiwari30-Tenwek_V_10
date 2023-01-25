<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ManpowerSearch.aspx.cs" Inherits="Design_Payroll_ManpowerSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <script type="text/javascript">
        $(function () {
            $('#txtrequestDateFrom').change(function () {
                ChkDate();
            });
            $('#txtrequestDateTo').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtrequestDateFrom').val() + '",DateTo:"' + $('#txtrequestDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date');
                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        var CanReject = 0;
        var CanFinalise = 0;
        var EmpID = '<%=Session["ID"].ToString()%>';
        $(document).ready(function () {
            bindDepartment(function () {
                getUserAuthorisation(function () {

                });
            });
        });

        var bindDepartment = function (callback) {
            ddlDepartment = $('#ddlDepartment');
            serverCall('Services/CommonServices.asmx/BindDepartment', {}, function (response) {
                ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Dept_ID', textField: 'Dept_Name', isSearchAble: true });
                callback(ddlDepartment.val());
            });
        }

        var getUserAuthorisation = function () {
            serverCall('Services/CommonServices.asmx/getUserAuthorisation', {}, function (response) {
                responseData = jQuery.parseJSON(response);
                CanReject = responseData[0].CanRejectPersonnelForm;
                CanFinalise = responseData[0].CanFilanisePersonnelForm;
            });
        }

        var SearchRequest = function (status) {
            var data = {
                FromDate: $('#txtrequestDateFrom').val(),
                ToDate: $('#txtrequestDateTo').val(),
                DeptName: $('#ddlDepartment').val() != '0' ? $('#ddlDepartment option:selected').text() : '',
                status: status
            }
            serverCall('Services/PayrollServices.asmx/SearchPersonnelRequest', data, function (response) {
                ResultData = jQuery.parseJSON(response);
                if (ResultData.length > 0) {
                    var output = $('#tb_Search').parseTemplate(ResultData);
                    $('#divOutPut').html(output);
                    $('#divOutPut').show();
                    MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                }
                else {
                    modelAlert('No Record Found', function () {
                        $('#divOutPut').html('');
                    });
                }
            });
        }

        var RejectReq = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnRejectReqID').text($(row).find('#tdID').text());
            $('#divReject').showModel();
        }
        var SaveReject = function (rejectdetail) {
            if (!String.isNullOrEmpty(rejectdetail.Remarks)) {
                serverCall('Services/PayrollServices.asmx/RejectPersonnelRequest', { reqID: rejectdetail.reqID, remarks: rejectdetail.Remarks }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        $('#divReject').closeModel();
                        SearchRequest(0);
                    });
                });
            }
            else
                modelAlert('Please Enter Reject Remarks');
        }

        var SetApprovalForward = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnFReqID').text($(row).find('#tdID').text());
            bindForwardtoEmp(function () {

            });
            $('#divApprovalForward').showModel();
        }

        var bindForwardtoEmp = function (callback) {
            ddlForwardto = $('#ddlForwardto');
            serverCall('Services/CommonServices.asmx/bindInterViewInvolvedEmployees', {}, function (response) {
                ddlForwardto.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'NAME', isSearchAble: true });
                callback(ddlForwardto.val())
            });
        }

        var SaveApprovalForward = function (FAppdetail) {
            if (FAppdetail.Forwardedto !== '0') {
                if (!String.isNullOrEmpty(FAppdetail.Remarks)) {
                    serverCall('Services/PayrollServices.asmx/SaveApprovalForwardRequestApproval', { reqID: FAppdetail.reqID, ForwardtoEmpID: FAppdetail.Forwardedto, remarks: FAppdetail.Remarks }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            modelAlert(responseData.response, function () {
                                $('#divApprovalForward').closeModel();
                                SearchRequest(0);
                            });
                        }
                        else
                            modelAlert(responseData.response, function () { });
                    });
                }
                else
                    modelAlert('Please Enter Approval & Forward Remarks');
            }
            else
                modelAlert('Please Select Forwarded to Employee');
        }

        var SetFinalise = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnFinReqID').text($(row).find('#tdID').text());
            $('#divFinalise').showModel();
        }

        var SaveFinalise = function (dtl) {
            if (!String.isNullOrEmpty(dtl.Remarks)) {
                serverCall('Services/PayrollServices.asmx/SaveFinalise', { reqID: dtl.reqID, remarks: dtl.Remarks }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        $('#divFinalise').closeModel();
                        SearchRequest(0);
                    });
                });
            }
            else
                modelAlert('Please Enter Finalise Remarks');
        }

        var ViewDetail = function (rowID) {
            row = $(rowID).closest('tr');
            var rowID = $(row).find('#tdID').text();
            serverCall('Services/PayrollServices.asmx/ViewPersonnelFormProcessDetail', { reqID: rowID }, function (response) {
                ResultData = jQuery.parseJSON(response);
                if (ResultData.length > 0) {
                    var output = $('#tb_dtl').parseTemplate(ResultData);
                    $('#divDtlOutPut').html(output);
                    $('#divDtlOutPut').show();
                    $('#divDetail').showModel();
                    $('#spnDtlDept').text(ResultData[0].Department);
                    $('#spnDtlDesg').text(ResultData[0].Designation);
                    $('#spnDtlReqDate').text(ResultData[0].RequstDate);
                    $('#spnReqBy').text(ResultData[0].RaisedBy);
                }
                else
                    modelAlert('No Detail found');
            });
        }


        var Reprint = function (rowID) {
            row = $(rowID).closest('tr');
            var reqID = $(row).find('#tdID').text();
            serverCall('Services/PayrollServices.asmx/ReprintPersonnelForm', { reqID: reqID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response);
            });
        }



    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Request for Personnel Form Search </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
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
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtrequestDateFrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calrequestDateFrom" runat="server" TargetControlID="txtrequestDateFrom"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtrequestDateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calrequestDateTo" runat="server" TargetControlID="txtrequestDateTo"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDepartment" title="Select Requesting Department "></select>
                        </div>
                    </div>
                    <div class="row">
                        <div style="text-align: center">
                            <input type="button" id="btnSearch" value="Search" onclick="SearchRequest(0);" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        	<div class="POuter_Box_Inventory">
			   <div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-5"></div>
                        <div style="text-align:center;display:none" class="col-md-5">
							<button type="button" onclick="SearchRequest(1)" title="Click To Search Only Forwarded Personnel Form Request" style="width:25px;height:25px;margin-left:5px;float:left;background-color: yellow;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Forwarded</b> 
						</div>
						<div style="text-align:center" class="col-md-5">
							<button type="button" onclick="SearchRequest(2)" title="Click To SearchOnly Finalise Personnel Form Request" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #90ee90;"  class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Finalised</b> 
						</div>
                        <div style="text-align:center" class="col-md-5">
							<button type="button" onclick="SearchRequest(3)" title="Click To Search Only Rejected Personnel Form Request" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #f38246;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Rejected</b> 
						</div>
						<div class="col-md-4"></div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="row">
                <div id="divOutPut" style="max-height: 450px;"></div>
            </div>
        </div>
    </div>

    <script type="text/html" id="tb_Search">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_SearchData" style="width: 100%; border-collapse: collapse; overflow-x: auto;">
            <tr id="trHeader">
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">SrNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px">RequestDate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">ReqFrom</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">ReqFor</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px">ReqType</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">ReqReason</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">Vacancy</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;display:none">Forward</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px">Finalise</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">Reject</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">Details</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">Print</th>
            </tr>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
          
        #>
                <tr
                    <#if(objRow.Status=="Forward"){#>
					style="background-color:yellow"
				    <#}if(objRow.Status =="Finalise"){#>
					    style="background-color:#90EE90"
				    <#}if(objRow.Status =="Reject"){#>
					    style="background-color:#f38246"
				    <#}#>
                    >
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width: 200px; display: none"><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="td11" style="width: 100px;"><#=objRow.RequestDate#></td>
                    <td class="GridViewLabItemStyle" id="td2" style="width: 100px;"><#=objRow.ReqFrom#></td>
                    <td class="GridViewLabItemStyle" id="td3" style="width: 150px;"><#=objRow.ReqFor#></td>
                    <td class="GridViewLabItemStyle" id="td4" style="width: 200px;"><#=objRow.ReqType#></td>
                    <td class="GridViewLabItemStyle" id="td5" style="width: 100px;"><#=objRow.ReqReason#></td>
                    <td class="GridViewLabItemStyle" id="td6" style="width: 50px;"><#=objRow.VacNo#></td>
                    <td class="GridViewLabItemStyle" id="td7" style="width: 112px; text-align: center; display:none">
                        <input type="button" id="btnApproveForward" value="Approve & Forward" onclick="SetApprovalForward(this)" 
                             <#if(objRow.Status=="Finalise" || objRow.Status =="Reject"){#>disabled="disabled" <#}#>    />
                    </td>
                     <td class="GridViewLabItemStyle" id="td8" style="width: 112px; text-align: center;">
                        <input type="button" id="btnFinalise" value="Finalise" onclick="SetFinalise(this)" 
                        <#if(CanFinalise==0 || (objRow.Status=="Finalise" || objRow.Status =="Reject")){#>disabled="disabled" <#}#>   />
                     </td>
                    <td class="GridViewLabItemStyle" id="td9"style="width: 82px; text-align: center;">
                        <input type="button" id="btnReject" value="Reject" onclick="RejectReq(this);" 
                            <#if(CanReject==0 || (objRow.Status =="Reject")){#>disabled="disabled" <#}#>  />
                    </td>
                    <td class="GridViewLabItemStyle" id="td1" style="width: 200px; display: none"><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;">
                        <img id="immgView" data-title="Click To View All Detail" src="../../Images/view.GIF" onclick="ViewDetail(this);" />
                    </td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;">
                        <img id="imgPrint" data-title="Click To Print Personnel Form" src="../../Images/print.gif" onclick="Reprint(this);" title="Click To Print Personnel Form" /></td>
                </tr>
            <#}#>      
        </table>
    </script>

    <script type="text/html" id="tb_dtl">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_dtlData" style="width: 100%; border-collapse: collapse; overflow-x: auto;">
            <tr id="tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">SrNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Request Status</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 120px">Forwarded By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">Forwarded To</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">Remarks</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Date Time</th>
            </tr>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
          
        #>
                <tr>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td12" style="width: 100px;"><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle" id="td13" style="width: 100px;"><#=objRow.ForwardedBy#></td>
                    <td class="GridViewLabItemStyle" id="td14" style="width: 150px;"><#=objRow.ForwardedTo#></td>
                    <td class="GridViewLabItemStyle" id="td15" style="width: 200px;"><#=objRow.ForwardRemarks#></td>
                    <td class="GridViewLabItemStyle" id="td10" style="width: 200px;"><#=objRow.DateTIme#></td>
                </tr>
            <#}#>      
        </table>
    </script>


    <div id="divReject" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 320px; height: 180px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divReject" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Reject Remarks</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <span id="spnRejectReqID" style="display:none"></span>
                            <textarea id="txtRejectRemarks" class="requiredField" style="height: 105px; text-transform: uppercase; margin: 0px; width: 351px; max-width: 292px; max-height: 70px;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveReject({reqID:$('#spnRejectReqID').text(),Remarks:$('#txtRejectRemarks').val()})">Save</button>
                    <button type="button" data-dismiss="divReject">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div id="divApprovalForward" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 320px; height: 210px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divApprovalForward" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Approval and Forward Remarks</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
                            <label class="pull-left">Forward to</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-16">
                             <select id="ddlForwardto" class="requiredField" ></select>
                         </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <span id="spnFReqID" style="display:none"></span>
                            <textarea id="txtFRemarks" class="requiredField" style="height: 105px; text-transform: uppercase; margin: 0px; width: 351px; max-width: 284px; max-height: 70px;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveApprovalForward({reqID:$('#spnFReqID').text(),Forwardedto:$('#ddlForwardto').val(),Remarks:$('#txtFRemarks').val()})">Save</button>
                    <button type="button" data-dismiss="divApprovalForward">Close</button>
                </div>
            </div>
        </div>
    </div>


      <div id="divFinalise" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 320px; height: 180px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divFinalise" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Finalise Remarks</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <span id="spnFinReqID" style="display:none"></span>
                            <textarea id="txtFinalise" class="requiredField" style="height: 105px; text-transform: uppercase; margin: 0px; width: 351px; max-width: 292px; max-height: 70px;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveFinalise({reqID:$('#spnFinReqID').text(),Remarks:$('#txtFinalise').val()})">Save</button>
                    <button type="button" data-dismiss="divFinalise">Close</button>
                </div>
            </div>
        </div>
    </div>

      <div id="divDetail" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 810px; height: 380px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divDetail" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Personnel Form Process Detail</h4>
                    <span id="spndtlReqID" style="display:none"></span>
                </div>
                <div class="modal-header">
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                          <div class="col-md-8">
                              <span id="spnDtlDept" class="patientInfo"></span>
                          </div>
                        <div class="col-md-4">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnDtlDesg" class="patientInfo"></span>
                        </div>
                        </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Request Date</label>
                            <b class="pull-right">:</b>
                        </div>
                    <div class="col-md-8">
                        <span id="spnDtlReqDate" class="patientInfo"></span>
                    </div>
                        <div class="col-md-4">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-8">
                            <span id="spnReqBy" class="patientInfo"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-body" style="height:205px">
                    <div class="row">
                        <div id="divDtlOutPut" style="max-height: 194px; overflow-x: auto;"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveFinalise({reqID:$('#spnFinReqID').text(),Remarks:$('#txtFinalise').val()})">Save</button>
                    <button type="button" data-dismiss="divDetail">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
