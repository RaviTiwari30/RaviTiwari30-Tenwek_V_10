<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DispatchFromHospital.aspx.cs" Inherits="Design_Biomedicalwaste_DispatchFromHospital" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript">
        $(document).ready(function () {
            Getdata();
            BindEmployee(function () { });
            bindDispatch(function () { });
            bindMedicalDispatchFromHospitalDetails(function () { });

        });
        var BindEmployee = function (callback) {
            var RoleID = 0;
            var UserId = '<%=Util.GetString(Session["ID"])%>';
            $ddlDispatch = $('#ddldispatchBy');
            serverCall('Services/BioMedicalwaste.asmx/BindEmployee', { RoleID: RoleID }, function (response) {
                $ddlDispatch.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'Name', isSearchAble: true, selectedValue: UserId });
                callback($ddlDispatch.find('option:selected').text());
            });
        }

        function BindImage(data) {
            var row = '';
            $('#divimageBind').empty();
            for (var i = 0; i < data.length; i++) {
                row += '<div class="gallery">';
                if (data[i].Quantity > 0 || data[i].Weight > 0) {
                    row += '<div> <input class="largerCheckbox" checked type="checkbox" id="chkbagid" value=' + data[i].BagID + '>';
                    row += '</div>';
                }
                else {
                    row += '<div> <input class="largerCheckbox" type="checkbox" id="chkbagid" value=' + data[i].BagID + '>';
                    row += '</div>';
                }
                // row += '<div> <input class="largerCheckbox" type="checkbox" id="chkbagid" checked="checked" value=' + data[i].ID + '><input type="hidden" id="hdnId"  value=' + data[i].ID + '>';

                row += '<div class="desc" style="color:' + data[i].BagColour + '">' + data[i].BagName + '</div>';
                row += '<img src=' + data[i].Image + ' alt="mountains" width="600" height="auto">';
                row += '<div class="desc1">';
                row += '<table id="tblbag">';
                row += '<tr>';
                row += '<td>Qty<span>:<span><input onlynumber="5" readonly  decimalPlace="0" value="' + data[i].Quantity + '"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" style="width:134px;margin-left: 23px;"  type="text" id="tdQuantity"  name="lname"><input type="hidden" id="hdnId"  value=' + data[i].Id + '><input type="hidden" id="hdnBagId"  value=' + data[i].BagID + '><input type="hidden" id="hdnBagName"  value=' + data[i].BagName + '></td>';
                row += '</tr>';
                row += '<tr>';
                row += '<td>Weight <span>:<span><input  readonly style="width:69px;" value="' + data[i].Weight + '"  type="text" id="tdweight" onlynumber="5"  decimalPlace="0"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" name="fname"><select id="ddlunit" disabled="true" style="width:62px;margin-left:3px;" > <option value="1">KG</option><option value="2">GM</option><option value="3">LTR</option><option value="4">ML</option></select></td>';
                row += '</tr>';
                row += '</table>';
                row += '</div>';
                row += '</div>';
                row += '</div>';
            }
            $('#divimageBind').append(row);
        }
       
        function ValidateDataAndSaveDispatchFromHospital() {
            debugger;

            var date = $('#txtDate').val();
            var Time = $('[id$=txtToTime]').val();
            var BagId = $('[id$=hdnBagId]').val();
            var dispatch = $('[id$=ddldispatchBy]').val();
            var vehicalNo = $('[id$=txtvehicleNo]').val();
            var collectedby = $('[id$=txtcollectedby]').val();
            var DispatchTo = $('#ddlDispatchto').val();
            var Remark = $('#txtRemark').val();
            BagType = [];
            var validate = 0;
            $('.gallery').each(function () {

                if ($(this).find('#chkbagid').is(':checked')) {
                    BagType.push({
                        Id: $(this).find('.desc1').find('#hdnId').val(),
                        BagId: $(this).find('.desc1').find('#hdnBagId').val(),
                        BagName: $(this).find('.desc1').find('#hdnBagName').val(),
                        Quantity: $(this).find('.desc1').find('#tdQuantity').val(),
                        Weight: $(this).find('.desc1').find('#tdweight').val(),
                        Unit: $(this).find('.desc1').find('#ddlunit option:selected').text(),
                    });


                }
            })
            //if (BagType.length > 0) {
            //    if (BagType[0].Quantity == 0) {
            //        var BagName = BagType[0].BagName;
            //        modelAlert('Please Enter Quantity  Of ' + BagName + ' Bag', function () {
            //            //$('#ddlWItemName').focus();
            //        });
            //        return false;
            //    }
            //    if (BagType[0].Weight == 0) {
            //        modelAlert('Please Enter Weight Of ' + BagName + ' Bag ', function () {
            //            //$('#ddlWAccessories').focus();
            //        });
            //        return false;
            //    }
            //}
            //if (data[0].SupplierID == 0) {
            //    modelAlert('Please Select Supplier', function () {
            //        $('#ddlWSupplier').focus();
            //    });
            //    return false;
            //}
            //if (String.isNullOrEmpty(data[0].PeriodValue) || data[0].PeriodValue == 0) {
            //    modelAlert('Please Enter Warranty Period', function () {
            //        $('#txtWPeriod').focus();
            //    });
            //    return false;
            //}

            if (BagType.length <= 0) {
                modelAlert('Please Select Any Bag..');
                return false;
            }

            if (dispatch == '0') {
                modelAlert('Please Select Dispatch By..');
                return false;
            }
            if (vehicalNo == '') {
                modelAlert('Please Enter Vehicle No..');
                return false;
            }

            if (collectedby == '') {
                modelAlert('Please Enter Collected By..');
                return false;
            }
            if (DispatchTo == '0' || DispatchTo == '') {
                modelAlert('Please Select DispatchTo..');
                return false;
            }
            if (Remark == '') {
                modelAlert('Please Enter Remark..');
                return false;
            }

            modelConfirmation('Are you sure ?', 'Do You Want to dispatch from hospital', 'Yes', 'No', function (status) {
                debugger;
                if (status == true) {
                    var data = {
                        Date: $('#txtDate').val(),
                        Time: $('[id$=txtToTime]').val(),

                        dispatch: $('[id$=ddldispatchBy]').val(),
                        vehicalNo: $('[id$=txtvehicleNo]').val(),
                        collectedby: $('[id$=txtcollectedby]').val(),
                        DispatchTo: $('#ddlDispatchto').val(),
                        Remark: $('#txtRemark').val(),
                        BagDetails: BagType,
                    }



                    serverCall('Services/BioMedicalwaste.asmx/SaveMedicalDispatchFromHospital', data, function (response) {

                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            bindMedicalDispatchFromHospitalDetails(function () { });
                            Clear();
                        });
                    });
                }
                else {
                    return false;
                }

            });

        }
       
        function Getdata() {
            serverCall('Services/BioMedicalwaste.asmx/BindDispatchFromDepartmentDetails', { data: '' }, function (response) {
                var responseData = JSON.parse(response);
                BindImage(responseData);

            });
        }

        var Clear = function () {
            location.reload(true);

        }

        $addNewDispatchModel = function () {
            $('#divAddDispatch').showModel();
        }


        function saveNewDispatch() {
            if ($('#txtDispatchName').val() != '') {
                var DispatchName = $('#txtDispatchName').val();
                serverCall('Services/BioMedicalwaste.asmx/DispatchInsert', { DispatchName: DispatchName }, function (response) {
                    $dispatchId = parseInt(response);
                    if ($dispatchId == 0)
                        modelAlert('Dispatch Already Exist');
                    else if ($dispatchId > 0) {
                        $('#divAddDispatch').closeModel();
                        modelAlert('Dispatch Saved Successfully');

                        $("#ddlDispatchto").append($("<option></option>").val($dispatchId).html(DispatchName)).val($dispatchId).chosen("destroy").chosen();
                    }

                });
            }
            else {
                modelAlert('Enter Dispatch Name');
            }
        }

        var bindDispatch = function (callback) {
            var $ddlDispatchto = $('#ddlDispatchto');
            serverCall('Services/BioMedicalwaste.asmx/GetDispatch', { data: '' }, function (response) {
                $ddlDispatchto.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Id', textField: 'Name', isSearchAble: true });
                callback($ddlDispatchto.val());
            });
        }

        function bindMedicalDispatchFromHospitalDetails(DepartmentId) {
            serverCall('Services/BioMedicalwaste.asmx/bindMedicalDispatchFromHospitalDetails', { data: '' }, function (response) {
                var responseData = JSON.parse(response);
                BindDetails(responseData);

            });
        }


        function BindDetails(data) {
            ;
            $('#tblHospitalDispatch tbody').empty();

            var row = '';
            for (var i = 0; i < data.length; i++) {

                var j = $('#tblHospitalDispatch tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DATE + '</td>';
                row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TIME + '</td>';
                //row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                row += '<td id="tdBagame" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BagName + '</td>';

                row += '<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                row += '<td id="tdWeight" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Weight + '</td>';


                row += '<td id="tddispatchedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DispatchedBy + '</td>';
                row += '<td id="tddispatchedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
                row += '<td id="tdcollectedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CollectedBy + '</td>';
                row += '<td id="tdremark" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Remark + '</td>';
                row += '<td id="tdremark" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].VehicleNo + '</td>';
                row += '<td id="tdremark" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Name + '</td>';


                row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Id + '</td>';
                row += '<td id="tddispatchedById" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].dispatchedById + '</td>';
                row += '<td id="tdwt" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].wt + '</td>';
                row += '<td id="tdunit" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ut + '</td>';
                row += '<td id="tdBagId" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BagId + '</td>';
                row += '</tr>';

                $('#tblHospitalDispatch tbody').append(row);
            }
        }

    </script>

    <style type="text/css">
        div.gallery {
            margin: 5px;
            border: 1px solid #ccc;
            float: left;
            width: 200px;
            height: auto;
        }

            div.gallery:hover {
                border: 1px solid #777;
            }

            div.gallery img {
                width: 100%;
                height: 132px;
            }

        div.desc {
            padding: 5px;
            text-align: center;
            font-weight: 700;
            font-size: 18px;
        }

        input.largerCheckbox {
            width: 20px;
            height: 26px;
        }

        div.desc1 {
            margin-top: 13px;
        }
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Dispatch From Hospital</b>
            <span style="display: none" id="spnBagID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" id="divimageBind">
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Dispatch Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calPurDate" TargetControlID="txtDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time" ClientIDMode="Static"
                                TabIndex="4" />
                            <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtToTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Dispatched By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:DropDownList ID="ddldispatchBy" runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Vehicle No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtvehicleNo" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Collected By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectedby" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Dispatch To </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlDispatchto" class="requiredField" data-title="Select Dispatch"></select>

                        </div>
                        <div style="padding-left: 0px;" class="col-md-1">
                            <input type="button" class="ItDoseButton" value="New" id="btnNewCity" data-title="Click to Create New Dispatch" onclick="$addNewDispatchModel()" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Remark</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemark" class="requiredField" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;" placeholder="Enter Remark here"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnsave" value="Save" onclick="return ValidateDataAndSaveDispatchFromHospital();" />

                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Biomedical Department Dispatch Details
            </div>
            <%--<div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromdate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                    </asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtFromdate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txttodate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                    </asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                    <input type="button" id="btnSearch" value="Search" onclick="return SearchData();" />

                </div>
            </div>--%>
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblHospitalDispatch" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Date</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Time</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bag Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Quantity</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Weight</th>

                                <th class="GridViewHeaderStyle" style="width: 150px;">Dispatched By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Collected By</th>

                                <th class="GridViewHeaderStyle" style="width: 150px;">Remark</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Vehicle No</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Dispatched To</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="divAddDispatch" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 320px; height: 153px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAddDispatch" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add Dispatch</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">Dispatch Name   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-14">
                            <input type="text" autocomplete="off" onlytext="30" id="txtDispatchName" class="form-control ItDoseTextinputText" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="saveNewDispatch()">Save</button>
                    <button type="button" data-dismiss="divAddDispatch">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

