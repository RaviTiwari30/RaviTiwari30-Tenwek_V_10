<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="RecievedDepartmentDispatch.aspx.cs" Inherits="Design_Biomedicalwaste_RecievedDepartmentDispatch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <script type="text/javascript">
            $(document).ready(function () {
                BindDepartment(function () { });
                //var status = $('#chekedAll').is(':checked');
                //if (status == true) {
                //    $('.chkallCheckBox input[type=checkbox]').attr("checked", "checked");
                //}
                //else {
                //    $(".chkallCheckBox input[type=checkbox]").attr("checked", false);
                //}
            });

            var BindDepartment = function (callback) {
                $ddlDepartment = $('#ddlDepartment');
                serverCall('Services/BioMedicalwaste.asmx/BindRoleMaster', {}, function (response) {
                    $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchAble: true });
                    callback($ddlDepartment.val());
                });
            }
            function BindIsNotRecivedBagDetails() {
                debugger;
                var data = {
                    FromDate: $('#txtFromDate').val(),
                    ToDate: $('[id$=txtToDate]').val(),
                    DepartMent: $('#ddlDepartment').val(),
                    status: $('#ddlStatus').val(),
                    //IsRecivedChecked: $('input[type=radio][name=rdoIsRecieved]:checked').val(),
                    //IsRejectChecked: $('input[type=radio][name=rdoIsRejected]:checked').val(),
                }
                serverCall('Services/BioMedicalwaste.asmx/BindIsNotRecivedBagDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0) {
                        bindBagDetails(responseData);
                        $('.data').show();
                    }
                    else {
                        modelAlert('No Record Found..', function () {
                            bindBagDetails(responseData);
                            $('.data').hide();
                        });
                    }

                });
            }
            function SearchData() {
                BindIsNotRecivedBagDetails(function () { });
            }
            function bindBagDetails(data) {
                debugger;
                status = $('#ddlStatus').val();
                $('#tbBagDetails tbody').empty();

                var row = '';
                for (var i = 0; i < data.length; i++) {

                    var j = $('#tbBagDetails tbody tr').length + 1;
                    row = '<tr>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DATE + '</td>';
                    row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TIME + '</td>';
                    row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoleName + '</td>';
                    row += '<td id="tdBagame" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BagName + '</td>';

                    row += '<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                    row += '<td id="tdWeight" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Weight + '</td>';


                    row += '<td id="tddispatchedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DispatchedBy + '</td>';
                    row += '<td id="tdcollectedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CollectedBy + '</td>';
                    row += '<td id="tdremark" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Remark + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"  ><img style="cursor:pointer" src="../../Images/view.GIF" onclick="OpenModal(this,' + data[i].Id + ');" ></td>'
                    //if (status != "0") {
                    //    row += '<td class="GridViewLabItemStyle" style="text-align: center;"  ><img style="cursor:pointer" src="../../Images/view.GIF" onclick="OpenModal(this,' + data[i].Id + ');" ></td>'
                    //}
                    //else {

                    //    row += '<td class="GridViewLabItemStyle" style="text-align: center;" ><img  src="../../Images/view.GIF" onclick="OpenModal(this,' + data[i].Id + ');"  ></td>'
                    //}
                    if (data[i].IsDispatchFromHospital=="1") {
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;"> <input  type="checkbox" disabled> </td>';
                    }
                    else {
                        row += '<td class="GridViewLabItemStyle chkallCheckBox" style="text-align: center;"> <input  type="checkbox"> </td>';
                    }
                    row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                    row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Id + '</td>';
                    row += '<td id="tddispatchedById" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].dispatchedById + '</td>';
                    row += '<td id="tdwt" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].wt + '</td>';
                    row += '<td id="tdunit" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ut + '</td>';
                    row += '<td id="tdBagId" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BagId + '</td>';
                    row += '</tr>';

                    $('#tbBagDetails tbody').append(row);
                }
            }

            function SaveRecievedData() {
                debugger;
                CheckedDetail = [];
                $('#tbBagDetails > tbody  > tr').each(function () {
                    //$('#tbldepartment').not(':first').find('tr:not(:first-child)').each(function () {
                    var row = $(this);
                    if (row.find('input[type="checkbox"]').is(':checked')) {
                        CheckedDetail.push({
                            ID: row.find('[id$=tdAID]').text(),


                        });
                    }
                    return CheckedDetail;
                });
                if (CheckedDetail.length <= 0) {
                    modelAlert('Please Select At Least One CheckBox..');
                    return false;
                }

                var data = {
                    CheckedDetail: CheckedDetail,
                    type: $('#btnRecieved').val(),
                }
                serverCall('Services/BioMedicalwaste.asmx/SaveRecivedDepartmentDispatchDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        BindIsNotRecivedBagDetails();
                    });





                });
            }
            function SaveRejectData() {
                CheckedDetail = [];
                $('#tbBagDetails > tbody  > tr').each(function () {
                    //$('#tbldepartment').not(':first').find('tr:not(:first-child)').each(function () {
                    var row = $(this);
                    if (row.find('input[type="checkbox"]').is(':checked')) {
                        CheckedDetail.push({
                            ID: row.find('[id$=tdAID]').text(),


                        });
                    }
                    return CheckedDetail;
                });

                if (CheckedDetail.length <= 0) {
                    modelAlert('Please Select At Least One CheckBox..');
                    return false;
                }
                var data = {
                    CheckedDetail: CheckedDetail,
                    type: $('#btnReject').val(),
                }
                serverCall('Services/BioMedicalwaste.asmx/SaveRecivedDepartmentDispatchDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        BindIsNotRecivedBagDetails();
                    });





                });
            }
            var OpenModal = function (rowID, ctrl) {
                debugger;
                var Id = ctrl;
                var StatusId = $('#ddlStatus').val()
                    
                if (StatusId != 0) {
                    serverCall('Services/BioMedicalwaste.asmx/GetRecivedOrRejectDetails', { Id: Id }, function (response) {
                        debugger;
                        var responseData = JSON.parse(response);
                        if (responseData[0].RecievedBy != '') {
                            $('#spnHeading').text('Recieved Details');
                            $('#spnReceivedBy').text(responseData[0].RecievedBy);
                            $('#spnRecievedDate').text(responseData[0].RecievedDateTime);
                            $('#divrejectedBy').css('display', 'none')
                            $('#divrejectedate').css('display', 'none')
                        }
                        else {
                            $('#spnHeading').text('Reject Details');
                            $('#spnRejectedBy').text(responseData[0].RejectedBy);
                            $('#spnRejectedDate').text(responseData[0].RejectedDateTime);
                            $('#divrejectedBy').css('display', '')
                            $('#divrejectedate').css('display', '')
                            $('#divrecievedBy').css('display', 'none')
                            $('#divRecieveddate').css('display', 'none')
                        }

                    });
                    $('#divUpload').showModel();
                }
                else {
                    modelAlert('Detail Is Not Available..', function () {
                        
                    });
                }

            }
            function CheckedAll() {
                debugger;
                var status = $('#chekedAll').is(':checked');


                if (status == true) {
                    $('.chkallCheckBox input[type=checkbox]').attr("checked", "checked");
                }
                else {
                    $(".chkallCheckBox input[type=checkbox]").attr("checked", false);
                }
            }
        </script>

        <style>
            .unselectable {
                background-color: #ddd;
                cursor: not-allowed;
            }
        </style>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Recieve Department Dispatch</b>
            <span style="display: none" id="spnDispatchID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Dispatch From Dt</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calPurDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Dispatch To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus">
                                <option value="0">Pending</option>
                                <option value="1">Recieved</option>
                                <option value="2">Rejected</option>

                            </select>

                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSearch" value="Search" onclick="return SearchData();" />



            </div>
        </div>
        <div class="POuter_Box_Inventory data" style="display: none;">
            <div class="Purchaseheader">
                Recived Department Dispatch Details
            </div>

            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbBagDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Dispatch Date</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Time</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">From Department</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bag Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Quantity</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Weight(Unit)</th>

                                <th class="GridViewHeaderStyle" style="width: 150px;">Dispatched By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Collected By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Remark</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">View Details</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">
                                    <input type="checkbox" id="chekedAll" onclick="CheckedAll();" /></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory data" style="display: none;">
            <div class="row" style="text-align: center">
                <input type="button" id="btnRecieved" value="Received" onclick="return SaveRecievedData();" />
                <input type="button" id="btnReject" style="width: 67px;" value="Reject" onclick="return SaveRejectData();" />


            </div>
        </div>
    </div>
    <div id="divUpload" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 613px; height: 220px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divUpload" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><span id="spnHeading"></span></h4>
                    <span class="hidden" id="SpnDocumentID"></span>
                </div>
                <div class="modal-header">
                    <div class="row" id="divrecievedBy">
                        <div class="col-md-5">
                            <label class="pull-left">Recieved By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnReceivedBy" class="patientInfo"></span>
                        </div>
                    </div>
                    <div class="row" id="divRecieveddate">
                        <div class="col-md-5">
                            <label class="pull-left">Recieved Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnRecievedDate" class="patientInfo"></span>
                        </div>
                    </div>

                    <div class="row" id="divrejectedBy">
                        <div class="col-md-5">
                            <label class="pull-left">Rejected By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnRejectedBy" class="patientInfo"></span>
                        </div>
                    </div>
                    <div class="row" id="divrejectedate">
                        <div class="col-md-5">
                            <label class="pull-left">Rejected Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnRejectedDate" class="patientInfo"></span>
                        </div>

                    </div>
                </div>
                <div class="modal-footer">

                    <button type="button" data-dismiss="divUpload">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

