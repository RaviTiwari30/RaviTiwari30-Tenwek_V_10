<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Manpower.aspx.cs" Inherits="Design_Payroll_Manpower" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtReason.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtReason.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });

            $('#rdblist').change(function () {
                $('#<%=lblAdditionReason.ClientID%>,#<%=txtReason.ClientID%>,#<%=ucLeavingdate.ClientID%>,#<%=lblLeavingdate.ClientID%>').hide();
                if ($('#rdblist').find(':checked').val() == "Planned Addition") {
                    $('#<%=lblAdditionReason.ClientID%>,#<%=txtReason.ClientID%>').show();
                }
                if ($('#rdblist').find(':checked').val() == "Replacement") {
                    $('#<%=ucLeavingdate.ClientID%>,#<%=lblLeavingdate.ClientID%>').show();
                }

            });
            $('#txturgdate').attr('disabled', true);
            $('#chkurg').click(function () {
                if ($('#chkurg').prop('checked'))
                    $('#txturgdate').removeAttr('disabled');
                else
                    $('#txturgdate').attr('disabled', true);

            });
            bindInterViewInvolvedEmployees(function () {

            });
            hideCTC();
           
        });


        var hideCTC = function () {
            if ($('#rdPosition :checked').val() == 'Yes') {
                $('#txtMonthlyCTC').show();
            }
            else {
                $('#txtMonthlyCTC').hide();
            }
        }

        var bindInterViewInvolvedEmployees = function (callback) {
            ddlForwardto = $('#ddlForwardto');
            serverCall('Services/CommonServices.asmx/bindInterViewInvolvedEmployees', { }, function (response) {
                ddlForwardto.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'NAME', isSearchAble: true });
                callback(ddlForwardto.val())
            });
        }
        var getDeptTotalEmployee = function () {
            debugger;
            if ($('#ddlDept').val() != '0') {
                serverCall('Manpower.aspx/getDeptTotalEmployee', { DeptID: $('#ddlDept').val() }, function (response) {
                    var responseData = JSON.parse(response);
                    $('#txtEmp').val(responseData[0].TotalEmployee);
                    getDeptEmployeeList($('#ddlDept').val(), function () {

                    });
                });
            }
        }
        var getDeptEmployeeList = function (DeptID, callback) {
            ddlReportingToEmp = $('#ddlReportingToEmp');
            serverCall('Manpower.aspx/getDeptEmployeeList', { DeptID: DeptID }, function (response) {
                ddlReportingToEmp.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'NAME', isSearchAble: true });
                var r = JSON.parse(response);
                $('#txtDeptHead').val(r[0].deptheadname);
                callback(ddlReportingToEmp.val())
            });
        }

        var AddNewPurpose = function () {
            $('#divAddPurposeModal').showModel();
        }
        var saveNewPurpose = function (dtl) {
            if (!String.isNullOrEmpty(dtl.Purpose.trim())) {
                serverCall('ManPower.aspx/SaveNewReportingPurpose', { Purpose: dtl.Purpose }, function (response) {
                    var PurposeID = parseInt(response);
                    if (PurposeID == 0)
                        modelAlert('Purpose Already Exist');
                    else if (PurposeID > 0) {
                        $('#divAddPurposeModal').closeModel();
                        modelAlert('Purpose Saved Successfully');
                        $("#ddlReportingPurpose").append($("<option></option>").val(PurposeID).html(dtl.Purpose)).val(PurposeID);
                    }
                    else
                        modelAlert('Error Occurred. Please Contact to Administrator');
                });
            }
            else {
                modelAlert('Enter Purpose');
            }
        }
    </script>
    <script type="text/javascript">
        var SavePersonnelForm = function () {
            var data = {
                ReqDate: $('#ucReqDate').val(),
                ReqType: $('#rdblist :checked').val(),
                AdditionReason: $('#txtReason').val().trim(),
                LeaveDate: $('#rdblist :checked').val()=='1'? $('#ucLeavingdate').val():'0001-01-01',
                ReqDept: $('#ddlDept option:selected').text(),
                ReqDeptID: $('#ddlDept').val(),
                PositiontobeFilled: $('#ddlDesig option:selected').text(),
                PositiontobeFilledID: $('#ddlDesig').val(),
                ReqByDesig: $('#ddlDesig_Requester option:selected').text(),
                ReqByDesigID: $('#ddlDesig_Requester').val(),
                PosBudget: $('#rdPosition :checked').val(),
                MonthlyCTC:$('#txtMonthlyCTC').val(),
                JobType: $('#ddlJobType optiom:selected').text(),
                PosInfo: $('#txtPositionInformation').val().trim(),
                Vacancy: $('#txtVac').val().trim(),
                TotalEmp: $('#txtEmp').val().trim(),
                UrgentDate: $('#chkurg').prop('checked') ? $('#txturgdate').val() : '0001-01-01',
                ReportingTo: $('#ddlReportingToEmp option:selected').text(),
                ReportingPurpose: $('#ddlReportingPurpose option:selected').text(),
                DeptHead: $('#txtDeptHead').val().trim(),
                ChiefAdOfficer: $('#txtChiefOfficer').val().trim(),
                ChiefExcOficer: $('#txtExecutiveOfficer').val().trim(),
                Qualif: $('#ddlEduQual option:selected').text(),
                QualifID: $('#ddlEduQual').val(),
                Area: $('#txtAreas').val().trim(),
                Require: $('#txtrequired').val().trim(),
                MinExp: $('#ddlmin').val() + '#' + $('#ddlexp1').val(),
                MaxExp: $('#ddlmax').val() + '#' + $('#ddlexp2').val(),
                Comment: $('#txtComment').val().trim(),
                Forwardto: $('#ddlForwardto').val(),
            }
            if ((data.ReqDeptID) == "0") {
                modelAlert('Please Select Requesting Department', function () {
                    $('#ddlDept').focus();
                });
                return false;
            }
            if ((data.PositiontobeFilledID) == "0") {
                modelAlert('Please Select Position to be Filled', function () {
                    $('#ddlDesig').focus();
                });
                return false;
            }
            if ((data.ReqByDesigID) == "0") {
                modelAlert('Please Select Requesting Person Designation', function () {
                    $('#ddlDesig_Requester').focus();
                });
                return false;
            }
            if (Number(data.Vacancy) <= 0) {
                modelAlert('Please Enter Total Vacancies Required', function () {
                    $('#ddlEduQual').focus();
                });
                return false;
            }
            if ((data.QualifID) == "0") {
                modelAlert('Please Select Minimum Qualification', function () {
                    $('#txtVac').focus();
                });
                return false;
            }

            if (data.PosBudget == 'Yes' && Number(data.MonthlyCTC) <= 0) {
                modelAlert('Please Enter Monthly CTC ', function () {
                    $('#txtMonthlyCTC').focus();
                });
                return false;
            }

            serverCall('ManPower.aspx/SavePersonnelForm',{ ReqDetail : data}, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    Reprint(responseData.reqID);
                    location.href = 'ManPower.aspx';
                });
            });
           
        }

        var Reprint = function (reqID) {
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
        <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Request for Personnel Form</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align: left">
                Basic Information
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date of Request
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucReqDate" runat="server" TabIndex="1" ToolTip="Click to Select Date of Request" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucReqDate" runat="server" TargetControlID="ucReqDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-8">
                            <label class="pull-left">
                                <asp:RadioButtonList ID="rdblist" runat="server" TabIndex="2" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem>New Opening</asp:ListItem>
                                    <asp:ListItem>Replacement</asp:ListItem>
                                    <asp:ListItem Selected="True">Planned Addition</asp:ListItem>
                                </asp:RadioButtonList>
                            </label>
                        </div>
                        <div class="col-md-3">
                            <asp:Label ID="lblLeavingdate" runat="server" Text="Leaving Date" Style="display: none;" ClientIDMode="Static"></asp:Label>
                            <asp:Label ID="lblAdditionReason" runat="server" ClientIDMode="Static" class="pull-left" Text="Reason Addition"></asp:Label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReason" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="3" TextMode="MultiLine" ToolTip="Enter Reason For Requisition" ClientIDMode="Static"></asp:TextBox>
                            <asp:TextBox ID="ucLeavingdate" runat="server" TabIndex="3" ToolTip="Click to Select Date of Request" Style="display: none;" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ucucLeavingdate_CalendarExtender" runat="server" TargetControlID="ucLeavingdate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Requesting Dept</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" TabIndex="4" ToolTip="Select Department" CssClass="requiredField" ClientIDMode="Static" onchange="getDeptTotalEmployee()">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Pos. To Be Filled</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDesig" runat="server" TabIndex="5" ToolTip="Select Designation" CssClass="requiredField" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Req. Person Desg</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDesig_Requester" runat="server" TabIndex="6" ToolTip="Select Designation" CssClass="requiredField" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Position Budgeted</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:RadioButtonList ID="rdPosition" runat="server" RepeatDirection="Horizontal" TabIndex="7" ClientIDMode="Static" onchange="hideCTC();">
                                <asp:ListItem>Yes</asp:ListItem>
                                <asp:ListItem Selected="True">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtMonthlyCTC" onlyynumber="7" title="Enter Monthly CTC here" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Job Type</label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlJobType" runat="server" ToolTip="Select Employment Type" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Position Info.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPositionInformation" runat="server" AutoCompleteType="Disabled" MaxLength="100"  ClientIDMode="Static" TabIndex="9" TextMode="MultiLine" ToolTip="Enter Position Information"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">No. of Vacancies</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtVac" runat="server" AutoCompleteType="Disabled" MaxLength="10" ToolTip="Enter No. of Vacancies" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fc5" runat="server" FilterType="numbers" TargetControlID="txtVac">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Total Employees</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmp" runat="server" AutoCompleteType="Disabled" MaxLength="50" TabIndex="11" ToolTip="Enter Existing Employee in Department" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fc6" runat="server" FilterType="numbers" TargetControlID="txtEmp">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkurg" runat="server" Text="If Urgent &nbsp;" TabIndex="8" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txturgdate" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="12" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" Format="dd-MMM-yyyy" runat="server"
                                PopupButtonID="Image2" TargetControlID="txturgdate">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Reporting To</label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <%--<asp:TextBox ID="txtReporting" runat="server" AutoCompleteType="Disabled" MaxLength="50" TabIndex="13" ToolTip="Enter Reporting To"></asp:TextBox>--%>
                            <asp:DropDownList ID="ddlReportingToEmp" runat="server" TabIndex="13" ClientIDMode="Static" ToolTip="Select Reporting to Person Name"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Reporting Purpose</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <%--<asp:TextBox ID="txtPurpose" runat="server" AutoCompleteType="Disabled" MaxLength="50" TabIndex="14" ToolTip="Enter Purpose Of Reporting To" CssClass="requiredField"></asp:TextBox>--%>
                            <asp:DropDownList ID="ddlReportingPurpose" runat="server" ClientIDMode="Static" TabIndex="14" ToolTip="Select Purpose Of Reporting To"></asp:DropDownList>
                        </div>
                        <div class="col-md-1">
                            <input type="button" id="btnAddNewPurpose" title="Click here to add new Purpose" value="New" onclick="AddNewPurpose();" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Department Head</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDeptHead" runat="server" AutoCompleteType="Disabled" MaxLength="100" ClientIDMode="Static"
                                TabIndex="15"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Chief Adm Officer</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtChiefOfficer" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="16" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Chief Exc Officer</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtExecutiveOfficer" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="17" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Comment</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtComment" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="18" ClientIDMode="Static"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Position Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Min. Qualification
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <%-- <asp:TextBox ID="txtminedu" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="19" ToolTip="Enter Min. Educational Qualification" CssClass="requiredField"></asp:TextBox>--%>
                            <asp:DropDownList ID="ddlEduQual" runat="server" ClientIDMode="Static" TabIndex="19" ToolTip="Enter Min. Educational Qualification" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Responsible Area
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAreas" ClientIDMode="Static" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="20" ToolTip="Enter Responsible Area"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Pos. Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtrequired" ClientIDMode="Static" runat="server" AutoCompleteType="Disabled" MaxLength="100" TabIndex="21" ToolTip="Enter Position Remarks"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Experience Min.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlmin" runat="server" TabIndex="22" ToolTip="Select Min. Experience" Width="70px" ClientIDMode="Static">
                                <asp:ListItem Selected="True">0</asp:ListItem>
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                                <asp:ListItem>13</asp:ListItem>
                                <asp:ListItem>14</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>16</asp:ListItem>
                                <asp:ListItem>17</asp:ListItem>
                                <asp:ListItem>18</asp:ListItem>
                                <asp:ListItem>19</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>21</asp:ListItem>
                                <asp:ListItem>22</asp:ListItem>
                                <asp:ListItem>23</asp:ListItem>
                                <asp:ListItem>24</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>26</asp:ListItem>
                                <asp:ListItem>27</asp:ListItem>
                                <asp:ListItem>28</asp:ListItem>
                                <asp:ListItem>29</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlexp1" runat="server" TabIndex="23" ToolTip="Select Min. Experience" Width="100px" ClientIDMode="Static">
                                <asp:ListItem Selected="true">Month</asp:ListItem>
                                <asp:ListItem>Years</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Max.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlmax" runat="server" TabIndex="24" ToolTip="Select Max. Experience" Width="70px" ClientIDMode="Static">
                                <asp:ListItem Selected="True">0</asp:ListItem>
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                                <asp:ListItem>13</asp:ListItem>
                                <asp:ListItem>14</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>16</asp:ListItem>
                                <asp:ListItem>17</asp:ListItem>
                                <asp:ListItem>18</asp:ListItem>
                                <asp:ListItem>19</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>21</asp:ListItem>
                                <asp:ListItem>22</asp:ListItem>
                                <asp:ListItem>23</asp:ListItem>
                                <asp:ListItem>24</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>26</asp:ListItem>
                                <asp:ListItem>27</asp:ListItem>
                                <asp:ListItem>28</asp:ListItem>
                                <asp:ListItem>29</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlexp2" runat="server" TabIndex="25" ToolTip="Select Min. Experience" Width="100px" ClientIDMode="Static">
                                <asp:ListItem Selected="true">Month</asp:ListItem>
                                <asp:ListItem>Years</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Forward to
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlForwardto"></select>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" title="Click to Save Personnel Form" onclick="SavePersonnelForm()" Style="margin-top: 7px; width: 100px"  />
        </div>
    </div>

    <div id="divAddPurposeModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 320px; height: 153px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAddPurposeModal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add New Purpose</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">Purpose</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-14">
                            <input type="text" autocomplete="off" onlytext="30" id="txtPurpose" class="form-control ItDoseTextinputText" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="saveNewPurpose({Purpose:$('#txtPurpose').val()})">Save</button>
                    <button type="button" data-dismiss="divAddPurposeModal">Close</button>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
