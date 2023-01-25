<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OT_TAT.aspx.cs" Inherits="Design_OT_OT_TAT" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
<%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>OT TAT</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />&nbsp;              
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-11">
                        <asp:GridView ID="gvOTTATType" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S/No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Select">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" ClientIDMode="Static" Checked='<%#  Util.GetBoolean(Eval("IsSelected")) %>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Type">
                                    <ItemTemplate>
                                        <asp:Label ID="lblType" runat="server" Text='<%# Eval("TATTypeName")%>' ClientIDMode="Static"></asp:Label>
                                        <asp:Label ID="lblTypeID" runat="server" Style="display: none;" Text='<%# Eval("ID") %>' ClientIDMode="Static"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                 <asp:TemplateField HeaderText="Date" >
                                    <ItemTemplate>
                                        
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Time">
                                    <ItemTemplate>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle"  Width="200px"/>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                               
                                 <asp:TemplateField HeaderText="Employee Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmpName" runat="server" Text='<%# Eval("EmpName")%>' ClientIDMode="Static"></asp:Label>
                                        </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="col-md-13">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Staff Type 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-11">
                                <select id="ddlType" onchange="bindStaff(function () {})"></select>
                            </div>
                            <div class="col-md-9" style="text-align: right; display:none; ">
                                <input type="button" onclick="openTypeCreatePopup();" style="width: 200px;" value="Create & De-Active(Selected) Type" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Staff 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-11">
                                <select id="ddlStaffName"></select>
                            </div>
                            <div class="col-md-9" style="text-align: right">
                                <input type="button" id="btnStaffName" onclick="openStaffCreatePopup();" style="width: 200px; display: none;" value="Create & De-Active(Selected) Staff" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Time IN
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtInTime" runat="server" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtInTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtInTime"
                                    ControlExtender="MaskedEditExtender2" ForeColor="Red" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save"></cc1:MaskedEditValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    OUT 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtOUTTime" runat="server" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtOUTTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtOUTTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" ForeColor="Red" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save"></cc1:MaskedEditValidator>

                            </div>
                            <div class="col-md-9" style="text-align: left">
                                <input type="button" id="btnAdd" onclick="addOperation();" value="Add" />
                            </div>
                        </div>
                        <div class="row">
                            <div id="divTATStaffTiming" style="width: 100%; max-height: 200px; overflow-y: auto">
                                <table id="tblSelectedStaff" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr id="IssueItemHeader">
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;">S.No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">Staff Type</th>
                                            <th class="GridViewHeaderStyle" scope="col">Staff Person Name</th>
                                            <th class="GridViewHeaderStyle" scope="col">IN Time</th>
                                            <th class="GridViewHeaderStyle" scope="col">OUT Time</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                            <th class="GridViewHeaderStyle" scope="col"></th>
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
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-11">
                    </div>
                    <div class="col-md-2">
                        <input type="button" class="ItDoseButton" title="Click to Save" value="Save" id="btnSave" onclick="saveOTTAT()" />
                    </div>
                    <div class="col-md-11">
                    </div>
                </div>
            </div>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblTypeId" Style="display: none"></asp:Label>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblStaffID" Style="display: none"></asp:Label>
            <div id="dvCreateAndUpdateType" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 60%;">
                        <div class="modal-header">
                            <button type="button" class="close" onclick="closeCreateAndUpdateTypeModel()" aria-hidden="true">×</button>
                            <h4 class="modal-title"><span id="spnHeaderLabel">Create New Type</span> </h4>
                        </div>
                        <div style="max-height: 200px; overflow: auto;" class="modal-body">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-5">
                                    <label class="pull-left">
                                        Type Name 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-17">
                                    <input type="text" id="txtTypeName" maxlength="100" />
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" id="btnSaveType" onclick="onSaveType(1)">Save</button>
                            <button type="button" id="btnDeleteType" onclick="onDeleteType()">De-Active</button>
                            <button type="button" onclick="closeCreateAndUpdateTypeModel()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="dvCreateAndUpdateStaff" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 60%;">
                        <div class="modal-header">
                            <button type="button" class="close" onclick="closeCreateAndUpdateStaffModel()" aria-hidden="true">×</button>
                            <h4 class="modal-title"><span id="Span1">Create New Type</span> </h4>
                        </div>
                        <div style="max-height: 200px; overflow: auto;" class="modal-body">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-5">
                                    <label class="pull-left">
                                        Staff Name 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-17">
                                    <input type="text" id="txtStaffName" maxlength="100" />
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" id="btnSaveStaff" onclick="onSaveStaff(1)">Save</button>
                            <button type="button" id="btnDeleteStaff" onclick="onDeleteStaff()">De-Active</button>
                            <button type="button" onclick="closeCreateAndUpdateStaffModel()">Close</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                $(".txtEmployeeID").hide();
                bindType(function () {
                    bindStaff(function () {
                        bindSavedStaff(function () {
                        });
                    });
                });
            });
            var bindType = function (callback) {
                var $ddlType = $('#ddlType');
                serverCall('OT_TAT.aspx/BindType', {}, function (response) {
                    $ddlType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'StaffTypeName', isSearchAble: true });
                    callback($ddlType.val());
                });
            }
            var bindStaff = function (callback) {
                var $ddlStaffName = $('#ddlStaffName');
                var TypeID = 0;
                var IsMainDoctor = 1;
                if (Number($('#ddlType').val()) != 0) {
                    TypeID = Number($('#ddlType').val().split('#')[0]);
                    IsMainDoctor = Number($('#ddlType').val().split('#')[1]);
                }
                if (IsMainDoctor == 0)
                    $("#btnStaffName").show();
                else
                    $("#btnStaffName").hide();

                serverCall('OT_TAT.aspx/BindStaff', { typeId: TypeID, isMainDoctor: IsMainDoctor }, function (response) {
                    $ddlStaffName.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                    callback($ddlStaffName.val());

                });
            }

            var onDeleteType = function () {
                modelConfirmation('Are You Sure ?', 'To Delete the Selected Type', 'Yes', 'No', function (res) {
                    if (res) {
                        onSaveType(2);
                    }
                });
            }

            var onSaveType = function (type) {
                if ($("#txtTypeName").val() == "") {
                    $("#txtTypeName").focus();
                    return;
                }

                data = {
                    type: type,
                    typeID: $("#lblTypeId").text(),
                    typeName: $("#txtTypeName").val()
                }
                serverCall('OT_TAT.aspx/SaveType', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            bindType(function () {
                                bindStaff(function () {
                                });
                            });
                            $('#dvCreateAndUpdateType').hideModel();
                        });
                    }
                    else
                        modelAlert(responseData.response);
                });
            }

            var closeCreateAndUpdateTypeModel = function () {
                $('#dvCreateAndUpdateType').closeModel();
            }
            var closeCreateAndUpdateStaffModel = function () {
                $('#dvCreateAndUpdateStaff').closeModel();
            }

            var openTypeCreatePopup = function () {
                if ($("#ddlType").val() != "0") {
                    $("#lblTypeId").text($("#ddlType").val().split('#')[0]);
                    $("#btnSaveType").hide();
                    $("#btnDeleteType").show();
                    $("#txtTypeName").val($("#ddlType option:selected").text()).attr("disabled", true);
                    $("#spnHeaderLabel").text("De-Active Selected Type");
                }
                else {
                    $("#lblTypeId").text("");
                    $("#btnSaveType").show();
                    $("#btnDeleteType").hide();
                    $("#txtTypeName").val("").attr("disabled", false);
                    $("#spnHeaderLabel").text("Create New Type");
                }
                $('#dvCreateAndUpdateType').showModel();
            }

            var closeCreateAndUpdateTypeModel = function () {
                $('#dvCreateAndUpdateType').closeModel();
            }

            var onDeleteStaff = function () {
                modelConfirmation('Are You Sure ?', 'To De-Active the Selected Staff', 'Yes', 'No', function (res) {
                    if (res) {
                        onSaveStaff(2);
                    }
                });
            }

            var onSaveStaff = function (type) {
                if ($("#txtStaffName").val() == "") {
                    $("#txtStaffName").focus();
                    return;
                }

                data = {
                    type: type,
                    typeID: $("#lblTypeId").text(),
                    staffName: $("#txtStaffName").val(),
                    staffID: $("#lblStaffID").text()
                }
                serverCall('OT_TAT.aspx/SaveStaff', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            bindStaff(function () {
                                $('#dvCreateAndUpdateStaff').hideModel();
                            });
                        });
                    }
                    else
                        modelAlert(responseData.response);
                });
            }
            var closeCreateAndUpdateStaffModel = function () {
                $('#dvCreateAndUpdateStaff').closeModel();
            }
            var openStaffCreatePopup = function () {
                $("#lblMsg").text("");

                if ($("#ddlType").val() == "0") {
                    $("#lblMsg").text("Please Select Type");
                    $("#ddlType").focus();
                    return;
                }
                $("#lblTypeId").text($("#ddlType").val().split('#')[0]);
                if ($("#ddlStaffName").val() != "0") {
                    $("#lblStaffID").text($("#ddlStaffName").val());
                    $("#btnSaveStaff").hide();
                    $("#btnDeleteStaff").show();
                    $("#txtStaffName").val($("#ddlStaffName option:selected").text()).attr("disabled", true);
                    $("#spnHeaderLabelStaff").text("De-Acive Selected Staff");
                }
                else {
                    $("#lblStaffID").text("");
                    $("#btnSaveStaff").show();
                    $("#btnDeleteStaff").hide();
                    $("#txtStaffName").val("").attr("disabled", false);
                    $("#spnHeaderLabelStaff").text("Create New Staff");
                }
                $('#dvCreateAndUpdateStaff').showModel();
            }

            var bindSavedStaff = function () {
                serverCall('OT_TAT.aspx/bindSavedStaff', { OTBookingID: Number('<%=Util.GetInt(ViewState["OTBookingID"])%>') }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0) {
                        for (j = 0; j < responseData.length; j++) {
                            addNewRow(responseData[j].StaffTypeID, responseData[j].StaffTypeName, responseData[j].StaffID, responseData[j].StaffName, responseData[j].StartTime, responseData[j].EndTme, function () { });
                        }
                    }
                });
            }

            var checktime = function (callback) {
                var data = {
                    StartTime: $('#txtInTime').val(),
                    EndTime: $('#txtOUTTime').val()
                };

                serverCall('OT_TAT.aspx/CompareTime', data, function (response) {
                    responseData = JSON.parse(response);
                    if (responseData == false) {
                        modelAlert("OUT Time can not be less than IN Time!", function () {
                            $('#txtOUTTime').focus();
                            callback(responseData);
                        });
                    }
                    else {
                        callback(responseData);
                    }
                });
            }

            var addOperation = function () {
                checktime(function (response) {
                    if (response) {
                        $("#lblMsg").text("");
                        var typeID = Number($("#ddlType").val().split('#')[0]);
                        var typeName = $("#ddlType option:selected").text();
                        var staffID = $("#ddlStaffName").val();
                        var staffName = $("#ddlStaffName option:selected").text();
                        var InTime = $("#txtInTime").val();
                        var OutTime = $("#txtOUTTime").val();


                        if (typeID == "0") {
                            $("#lblMsg").text("Please Select Type");
                            $("#ddlType").focus();
                            return;
                        }
                        if (staffID == "0") {
                            $("#lblMsg").text("Please Select Staff");
                            $("#ddlStaffName").focus();
                            return;
                        }

                        //if (InTime == "") {
                        //    $("#lblMsg").text("Please Enter In Time");
                        //    $("#txtInTime").focus();
                        //    return;
                        //}
                        //if (OutTime == "") {
                        //    $("#lblMsg").text("Please Enter Out Time");
                        //    $("#txtOUTTime").focus();
                        //    return;
                        //}

                        var alreadyAddedStaff = $('#tr_' + staffID).length > 0 ? true : false;
                        if (alreadyAddedStaff) {
                            modelAlert('Same Staff Already Added', function () {
                                $("#btnAdd").focus();
                            });
                            return;
                        }

                        addNewRow(typeID, typeName, staffID, staffName, InTime, OutTime, function () { });
                        $("#ddlType").focus();
                    }
                });
            }
            var addNewRow = function (typeID, typeName, staffID, staffName, InTime, OutTime, callback) {
                var table = $('#tblSelectedStaff tbody');
                var newRow = $('<tr>').attr('id', 'tr_' + staffID);
                newRow.html(
                                  '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center;display:none;">' + (table.find('tr').length + 1) +
                                  '</td><td class="GridViewLabItemStyle" id="tdtypeName">' + typeName +
                                  '</td><td class="GridViewLabItemStyle" id="tdstaffName">' + staffName +
                                  '</td><td class="GridViewLabItemStyle" id="tdInTime" style="width:67px">' + InTime +
                                  '</td><td class="GridViewLabItemStyle" id="tdOutTime" style="width:67px">' + OutTime +
                                  '</td><td class="GridViewLabItemStyle" id="tdstaffTypeID" style="display:none;" >' + typeID +
                                  '</td><td class="GridViewLabItemStyle" id="tdstaffID" style="display:none;" >' + staffID +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgRemove"><img id="imgRmv" class="btn" src="../../Images/Delete.gif" onclick="removeRow(this);" style="cursor:pointer;" title="Click To Remove"/></td>'
                                  );
                table.append(newRow);
                callback(true);
            }
            var removeRow = function (elem) {
                $(elem).parent().parent().remove();
            }
            var saveOTTAT = function () {
                modelConfirmation('Are You Sure ?', 'Please Verify All Details.', 'Yes', 'No', function (res) {
                    if (res) {
                        getItems(function (TATDetails) {
                            if (TATDetails.length == 0) {
                                modelAlert("Please Select Atleast One Row !!");
                                return false;
                            }

                            var validateBlankTime = TATDetails.filter(function (i) { return i.inTime == "" || i.inTime == "__:__ AM" || i.inTime == "__:__ PM" });
                            if (validateBlankTime.length > 0) {
                                modelAlert("Some Selected Rows have No Time !!");
                                return false;
                            }
                            data = {
                                tatDetailsData: TATDetails,
                                otBookingID: Number('<%=Util.GetInt(ViewState["OTBookingID"])%>')

                            }
                            serverCall('OT_TAT.aspx/SaveTAT', data, function (response) {
                                var responseData = JSON.parse(response);
                                if (responseData.status) {
                                    modelAlert(responseData.response, function () {
                                        window.location.reload();
                                    });
                                }
                                else
                                    modelAlert(responseData.response);
                            });
                        });
                    }
                });
            }

            var getItems = function (callback) {
                var TATData = [];
                $('#tblSelectedStaff tbody tr').each(function () {
                    var InTime=$(this).find('#tdInTime').text();
                    var OutTime= $(this).find('#tdOutTime').text()
                    if ($(this).find('#tdInTime').text() == '' || $(this).find('#tdInTime').text() == "" || $(this).find('#tdInTime').text()==null) {
                        InTime = '<%=DateTime.Now.TimeOfDay%>';
                    }

                    if ($(this).find('#tdOutTime').text() == '' || $(this).find('#tdOutTime').text() == "" || $(this).find('#tdOutTime').text() == null) {
                       
                        OutTime = '<%=DateTime.Now.TimeOfDay%>';
                    }

                    TATData.push({
                        tatTypeID: 3,
                        staffTypeID: Number($(this).find('#tdstaffTypeID').text()),
                        staffID: $(this).find('#tdstaffID').text(),
                        staffName: $(this).find('#tdstaffName').text(),
                        inTime: InTime,
                        outTime: OutTime
                    });
                });

                $('#gvOTTATType tbody tr').not(':first').each(function () {
                    if ($(this).find('#chkSelect').is(':checked')) {
                        TATData.push({
                            tatTypeID: Number($(this).find('#lblTypeID').text()),
                            staffTypeID: 0,
                            staffID: "",
                            staffName: "",
                            inTime: $(this).find('.txtTime').val(),
                            outTime: $(this).find('.txtTime').val(),
                            OtStartDate: $(this).find('.txtUcDate').val(),
                            EmployeeID: $(this).find('.txtEmployeeID').val()
                        });
                    }
                });

                callback(TATData);
            }
        </script>
    </form>
</body>
</html>
