<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BioMedicalDepartmentDispatch.aspx.cs" Inherits="Design_Biomedicalwaste_BioMedicalDepartmentDispatch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <script type="text/javascript">
            $(document).ready(function () {
                debugger;
                BindEmployee(function () { });
               
                $("#ddldispatch option[value='EMP001']").attr("selected", true);
                
                //$("#ddldispatch").val(UserName);
                Getdata();
                bindbagDetails(function () { });
            });
            var Count = 0;
            var BindEmployee = function (callback) {
                var RoleID = '<%=Util.GetString(Session["RoleID"])%>';
                var UserId = '<%=Util.GetString(Session["ID"])%>';
                $ddlDispatch = $('#ddldispatch');
                serverCall('Services/BioMedicalwaste.asmx/BindEmployee', { RoleID: RoleID }, function (response) {
                    $ddlDispatch.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'Name', isSearchAble: true, selectedValue: UserId });
                    //callback($ddlDispatch.find('option:selected').text());
                    callback($ddlDispatch.val('EMP001'));
                });
            }
            function Getdata() {
                debugger;
                var DepartmentId = '<%=Util.GetString(Session["RoleID"])%>';
                serverCall('Services/BioMedicalwaste.asmx/BindBagDepartmentWise', { DepartmentId: DepartmentId }, function (response) {
                    var responseData = JSON.parse(response);
                    BindImage(responseData);
                    if (responseData.length == 0) {
                        Count++;
                    }


                });
            }

            function BindImage(data) {
                var row = '';
                $('#divimageBind').empty();
                for (var i = 0; i < data.length; i++) {
                    row += '<div class="gallery">';
                    row += '<div class="desc" style="color:' + data[i].BagColour + '">' + data[i].BagName + '</div>';
                    row += '<img src=' + data[i].Image + ' onclick="GetDetails(' + data[i].ID + ');" alt="mountains" width="600" height="auto">';
                    row += '<div class="desc1">';
                    row += '<table id="tblbag">';
                    row += '<tr>';
                    row += '<td>Qty<span>:<span><input onlynumber="5"  decimalPlace="0"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" style="width:134px;margin-left: 23px;"  type="text" id="tdQuantity"  name="lname"><input type="hidden" id="hdnId"  value=' + data[i].ID + '></td>';
                    row += '</tr>';
                    row += '<tr>';
                    row += '<td>Weight <span>:<span><input  style="width:69px;" type="text" id="tdweight" onlynumber="5"  decimalPlace="0"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" name="fname"><select id="ddlunit" style="width:62px;margin-left:3px;" > <option value="1">KG</option><option value="2">GM</option><option value="3">LTR</option><option value="4">ML</option></select></td>';
                    row += '</tr>';
                    row += '</table>';
                    row += '</div>';
                    row += '</div>';
                }
                $('#divimageBind').append(row);
            }
            function ValidateDataAndSave() {
                if (Count == "0") {
                    var date = $('#txtDate').val();
                    var Time = $('[id$=txtToTime]').val();
                    var dispatch = $('#ddldispatch').val();
                    var collectedby = $('#txtcollectedby').val();
                    var Remark = $('#txtRemark').val();
                    BagType = [];
                    var validate = 0;
                    $('.desc1').each(function (index, row) {
                        var tble = $(row).find($('#tblbag tbody'));
                        var row = $(this);
                        $(tble).each(function (i, e) {
                            if (Number($(row).find('#tdQuantity').val()) > 0 || Number($(row).find('#tdweight').val()) > 0) {
                                BagType.push({
                                    BagId: $(row).find('#hdnId').val(),
                                    Quantity: $(row).find('#tdQuantity').val(),
                                    Weight: $(row).find('#tdweight').val(),
                                    Unit: $(row).find('#ddlunit option:selected').text(),

                                });
                            }
                        });


                    });
                    if (BagType.length <= 0) {
                        modelAlert('Please Details For Any Bag..');
                        return false;
                    }

                    if (dispatch == '0') {
                        modelAlert('Please Select Dispatch By..');
                        return false;
                    }
                    if (collectedby == '') {
                        modelAlert('Please Enter Collected By..');
                        return false;
                    }
                    if (Remark == '') {
                        modelAlert('Please Enter Remark..');
                        return false;
                    }
                    var data = {
                        Date: $('#txtDate').val(),
                        Time: $('[id$=txtToTime]').val(),
                        Bag: BagType,
                        dispatch: $('#ddldispatch').val(),
                        collectedby: $('#txtcollectedby').val(),
                        Remark: $('#txtRemark').val(),
                        Id: $('#spnBagID').text(),
                        RoleId: '<%=Util.GetString(Session["RoleID"])%>',


                    }
                    serverCall('Services/BioMedicalwaste.asmx/SaveMedicalDepartmentDispatch', data, function (response) {

                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            bindbagDetails(function () { });
                            Clear();
                        });
                    });
                }
                else {
                    modelAlert('Please Map Bag With Department First..', function () {
                        return false;
                    });
                }
            }



            var Clear = function () {
                $('#ddldispatch').val('');
                $('#txtcollectedby').val('');
                $('.desc1').each(function (index, row) {
                    var tble = $(row).find($('#tblbag tbody'));
                    var row = $(this);
                    $(tble).each(function (i, e) {
                        $(row).find('input[type=text]').val('');
                        $(row).find("#ddlunit")[0].selectedIndex = 0;
                        $(row).find(':selected').val('0').trigger("chosen:updated");
                        
                    });


                });
                $('#txtRemark').val('');

            }
            function bindbagDetails() {

                var data = {
                    FromDate: $('#txtFromdate').val(),
                    ToDate: $('[id$=txttodate]').val(),
                    RoleId: '<%=Util.GetString(Session["RoleID"])%>',
                    status: $('[id$=ddlStatus]').val(),
                }
                serverCall('Services/BioMedicalwaste.asmx/bindBagDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0) {
                        bindBagDetails(responseData);
                    }
                    else {

                        bindBagDetails(responseData);

                    }

                });
            }
            function bindBagDetails(data) {
                ;
                $('#tbBagDetails tbody').empty();

                var row = '';
                for (var i = 0; i < data.length; i++) {

                    var j = $('#tbBagDetails tbody tr').length + 1;
                    row = '<tr style="background-color:' + data[i].RowColor + '">';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DATE + '</td>';
                    row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TIME + '</td>';
                    row += '<td id="tdBagame" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BagName + '</td>';

                    row += '<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                    row += '<td id="tdWeight" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Weight + '</td>';


                    row += '<td id="tddispatchedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DispatchedBy + '</td>';
                    row += '<td id="tdcollectedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CollectedBy + '</td>';
                    row += '<td id="tdremark" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Remark + '</td>';
                    if (data[i].IsRecived == "1") {
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                    }
                    else {
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditBag(this);" style="cursor: pointer;" title="Click To Edit" /></td>';

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

            var EditBag = function (rowID) {

                var row = $(rowID).closest('tr');
                $('#txtDate').val(row.find('#tdDate').text());
                $('#spnBagID').text(row.find('#tdAID').text());
                $('#txtToTime').val(row.find('#tdTime').text());
                $('#txtcollectedby').val(row.find('#tdcollectedBy').text());
                $("#ddldispatch").val(row.find('#tddispatchedById').text()).trigger("chosen:updated");
                //$('#ddldispatch').val(row.find('#tddispatchedBy').text());
                $('#txtRemark').val(row.find('#tdremark').text());
                var quantity = row.find('#tdQuantity').text();
                var weight = row.find('#tdwt').text();
                var unit = row.find('#tdunit').text();
                var bId = row.find('#tdBagId').text();


                $('.desc1').each(function (index, row) {
                    var tble = $(row).find($('#tblbag tbody'));
                    var row = $(this);
                    $(tble).each(function (i, e) {
                        $(row).find('input[type=text]').val('');
                        $(row).find("#ddlunit")[0].selectedIndex = 0;
                        //$(row).find(':selected').val('0').trigger("chosen:updated");
                        if ($(row).find('#hdnId').val() == bId) {

                            $(row).find('#tdQuantity').val(quantity);
                            $(row).find('#tdweight').val(weight);
                            $(row).find('#ddlunit option:selected').text(unit).trigger("chosen:updated");

                        }
                    });


                });

                $('[id$=btnsave]').val('Update');

            }
            function SearchDataByDepartmentWise() {
                var FromDate = $('#txtFromdate').val();
                var ToDate = $('[id$=txttodate]').val();
                if (FromDate == '') {
                    modelAlert('Please Enter From Date..');
                    return false;
                }
                if (ToDate == '') {
                    modelAlert('Please Enter To Date..');
                    return false;
                }
                bindbagDetails(function () { });
            }

            function ChkDate() {
                $.ajax({
                    url: "../common/CommonService.asmx/CompareDate",
                    data: '{DateFrom:"' + $('#txtFromdate').val() + '",DateTo:"' + $('#txttodate').val() + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = mydata.d;
                        if (data == false) {
                            modelAlert('To date can not be less than from date!', function () {
                                return false;
                            });
                            //$('#lblMsg').text('To date can not be less than from date!');
                            //$('#btnPreview').attr('disabled', 'disabled');
                        }
                        else {
                            //$('#lblMsg').text('');
                            //$('#btnPreview').removeAttr('disabled');
                        }
                    }
                });

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

            .unselectable {
                background-color: #ddd;
                cursor: not-allowed;
            }
        </style>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Biomedical Department Dispatch</b>
            <span style="display: none" id="spnBagID"></span>
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
                            <label class="pull-left">Date</label>
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
                    </div>
                    <div class="row" id="divimageBind">
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Dispatched By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:DropDownList ID="ddldispatch" runat="server" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Collected By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectedby" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remark</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemark" class="requiredField" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;" placeholder="Enter Description here"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnsave" value="Save" onclick="return ValidateDataAndSave();" />

                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>
      <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Biomedical Department Dispatch Details
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromdate" onchange="ChkDate();" AutoComplete="off" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender4" TargetControlID="txtFromdate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txttodate" onchange="ChkDate();" AutoComplete="off" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender5" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus">
                                <option value="0">All</option>
                                <option value="1">Dispatched</option>
                                <option value="2">Recieved</option>

                            </select>

                        </div>

                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>

            <div class="row"></div>
            <div class="row">
                <div class="col-md-11">
                </div>
                <div class="col-md-2">
                    <input type="button" id="Button1" value="Search" onclick="return SearchDataByDepartmentWise();" />
                </div>
                <div class="col-md-11">
                </div>
            </div>
            <div class="row"></div>




            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-8"></div>
                        <div style="text-align: center" class="col-md-5">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #FF99CC;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Dispatched</b>
                        </div>

                        <div style="text-align: center" class="col-md-5">
                            <button type="button" onclick="Search(2)" title="Click To Search Only Below Threshold Limit Patient" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90ee90;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Recieved</b>
                        </div>
                        <div class="col-md-5"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbBagDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Date</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Time</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bag Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Quantity</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Weight(Unit)</th>

                                <th class="GridViewHeaderStyle" style="width: 150px;">Dispatched By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Collected By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Remark</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

