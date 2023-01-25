<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDFileMovementStatus.aspx.cs" Inherits="Design_IPD_IPDFileMovementStatus" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>File Status</title>
</head>
<style type="text/css">
    .customTextArea {
        height: 22px;
        max-height: 22px;
        text-transform: uppercase;
        max-width: 214px;
        max-height: 70px;
    }
</style>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>IPD File Movement Status</b>
                <span id="spnFileID" style="display:none"></span>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-14">
                        <div class="Purchaseheader">
                            File Send 
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtSendDate" runat="server" ReadOnly="true" autocomplete="off" data-title="Enter Date" placeholder="DD-MM-YYYY" ClientIDMode="Static" ToolTip="Select Date" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" TargetControlID="txtSendDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">Time</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                    TabIndex="4" />
                                <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtTime" AcceptAMPM="true">
                                </cc1:MaskedEditExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Taken By</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <input type="text" id="txtSendTakenBy" class="send"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Department</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <input type="text" id="txtDepartment" class="send" style="display:none"/>
                                <asp:DropDownList ID="ddlDepartment" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Remarks</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <textarea id="txtSendRemarks" class="customTextArea send" data-title="Enter Send Remarks"></textarea>
                            </div>
                        </div>
                        <div class="row" style="text-align:center">
                            <input type="button" id="btnSend" onclick="Send()" value="Send"  class="send"/>
                        </div>
                    </div>
                    <div class="col-md-10">
                          <div class="Purchaseheader">
                            File Recieve 
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Taken By</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <input type="text" id="txtReciveTakenBy" class="recieve" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Remarks</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <textarea id="txtRecieveRemarks" class="customTextArea recieve" data-title="Enter Receive Remarks"></textarea>
                            </div>
                        </div>
                         <div class="row" style="text-align:center">
                            <input type="button" id="btnRecieve" onclick="Send()" value="Recieve"  class="recieve"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbAccessList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">FileSendDate</th>                          
                                <th class="GridViewHeaderStyle" style="width: 80px;">FileSendTime</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">FileSendBy</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">FileTakenBy</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">FileTakenDepartment</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">SendRemarks</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">FileRecieveBy</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">FileBringBy</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">FileReciveDateTime</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">RecieveRemarks</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">CancelBy</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">CancelRemarks</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">CancelDateTime</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">fileStatus</th>
                                <th class="GridViewHeaderStyle" style="width: 10px;"></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
            </div>
         </div>
        <script type="text/javascript">
            var Send = function () {
                data = {
                    date: $('#txtSendDate').val(),
                    time: $('#txtTime').val(),
                    takenby: $('#txtSendTakenBy').val(),
                    takendept: $('#ddlDepartment').val(),
                    sendremarks: $('#txtSendRemarks').val(),
                    TransactionID:'<%=Util.GetString(Request.QueryString["TransactionID"])%>',
                    PatientID: '<%=Util.GetString(Request.QueryString["PatientId"])%>',
                    fileID: $('#spnFileID').text(),
                    recievetakenby: $('#txtReciveTakenBy').val(),
                    recieveremarks: $('#txtRecieveRemarks').val(),
                }
                if (data.fileID == '0') {
                    if (String.isNullOrEmpty(data.takenby)) {
                        modelAlert('Please Enter Taken By User Name');
                        return false;
                    }
                } else {
                    if (String.isNullOrEmpty(data.recievetakenby)) {
                        modelAlert('Please Enter Who bring the File ...User Name');
                        return false;
                    }
                }

                serverCall('IPDFileMovementStatus.aspx/Send', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();

                    });
                });
            }
            var getDetail = function () {
                serverCall('IPDFileMovementStatus.aspx/getDetail', { TransactionID: '<%=Util.GetString(Request.QueryString["TransactionID"])%>' }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.IsSend >= 1) {
                        $('.send').prop('disabled', true);
                        $('.recieve').prop('disabled', false);
                        $('#spnFileID').text(responseData.FileID);
                    } else {
                        $('#spnFileID').text(responseData.FileID);
                        $('.recieve').prop('disabled', true);
                        $('.send').prop('disabled', false);
                    }
                    bindTable(responseData.response);

                });
            }
            $(document).ready(function () {
                getDetail();
                department(function () { });
            });

      
                department = function (callback) {
                    $ddlDepartment = $('#ddlDepartment');
                    serverCall('IPDFileMovementStatus.aspx/bindDepartment', {}, function (response) {
                        if (!String.isNullOrEmpty(response)) {
                            $ddlDepartment.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', isSearchAble: true ,selectedValue:<%=Session["RoleID"].ToString()%>});
                            callback($ddlDepartment.val());
                        }
                        else {
                            $ddlDepartment.empty();
                            callback($ddlDepartment.val());
                        }
                    });
                };
          
            var bindTable = function (data) {
                $('#tbAccessList tbody').empty();
                for (var i = 0; i < data.length; i++) {
                    var j = $('#tbAccessList tbody tr').length + 1;
                    var row = '<tr>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileSendDate + '</td>';
                    row += '<td id="tdAUnit" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileSendTime + '</td>';
                    row += '<td id="tdACode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileSendBy + '</td>';
                    row += '<td id="tdARemarks" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileTakenBy + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileTakenDepartment + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SendRemarks + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileRecieveBy + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileBringby + '</td>';
                    row += '<td id="tdACode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FileReciveDateTime + '</td>';
                    row += '<td id="tdARemarks" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RecieveRemarks + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CancelBy + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CancelRemarks + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CancelDateTime + '</td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].fileStatus + '</td>';
                    if (data[i].fileStatus != "Recieved") {
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/delete.gif" onclick="canceldata(this);" style="cursor: pointer;" title="Click To Cancel" /></td>';
                    } else
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                    row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].FileID + '</td>';
                    row += '</tr>';
                    $('#tbAccessList tbody').append(row);
                }
            }
            var canceldata = function (rowID) {
                var row = $(rowID).closest('tr');
                var ID = row.find('#tdAID').text();
                $('#divCloseJob').show();
                $('#divCloseJob #spnReqID').text(ID);
            }
            var SaveJobCloseRemarks = function (ID,Remarks) {
                serverCall('IPDFileMovementStatus.aspx/CancelReq', { reqID: ID, Remarks: Remarks }, function (response) {
                    var responseData = JSON.parse(response);
                    getDetail();
                    $('#divCloseJob').hide();
                });
            }
        </script>
            <div id="divCloseJob" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 320px; height: 180px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divCloseJob" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Cancel Remarks</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <span id="spnReqID" style="display: none"></span>
                            <textarea id="txtJobCloseRemarks" class="requiredField" style="height: 105px; text-transform: uppercase; margin: 0px; width: 351px; max-width: 292px; max-height: 70px;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveJobCloseRemarks({reqID:$('#spnReqID').text(),Remarks:$('#txtJobCloseRemarks').val().trim()})">Save</button>
                    <button type="button" data-dismiss="divCloseJob">Close</button>
                </div>
            </div>
        </div>
    </div>

    </form>
</body>
</html>
