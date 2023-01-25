<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorDepartmentWiseVitialSignMandtory.aspx.cs" Inherits="Design_CPOE_DoctorDepartmentWiseVitialSignMandtory" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

     <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />

    <script type="text/javascript">

        $(document).ready(function(){
            $bindPrequestDepartment(function () { });
        });
        var $bindPrequestDepartment = function (callback) {
            serverCall('../Common/CommonService.asmx/BindPrequestDeparmtnet', {}, function (response) {
                var $ddlDoctorDepartment = $('#ddlDoctorDepartment');
                $ddlDoctorDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'id', textField: 'NAME', isSearchAble: true });
                callback(true);
            });
        }
        VitalSignList = function ()
        {
            serverCall('../CPOE/services/Cpoe_CommonServices.asmx/SearchVitialSignList', { Department: $('#ddlDoctorDepartment').val() }, function (response) {
                responseData = JSON.parse(response);
                bindDeptwiseVitial(responseData)
            });
        }

        var bindDeptwiseVitial = function (data) {
            getGridSetting(function (s) {
                var $container = document.getElementById('divDeptWiseVitialList');
                $container.innerHTML = '';
                s.data = data;
                hTables = new Handsontable($container, s);
                hTables.render();
                hTables.addHook('beforeChange', function (changes, source) {
                    
                    if (source === 'loadData' || source === 'internal' || changes.length > 1) {
                        return;
                    }
                    var row = changes[0][0];
                    var prop = changes[0][1];
                    var value = changes[0][3];

                    if (prop === 'Rack') {
                        var rack = racksDetails.master.filter(function (i) { if (i.Name == value) { return i } });
                        var shelfsByRackID = shelfDetails.master.filter(function (i) { if (i.RackID == rack[0].ID) { return i; } });
                        var shelfs = [];
                        $.map(shelfsByRackID, function (i) { shelfs.push(i.ShelfName) });
                        this.setCellMeta(row, this.propToCol('Shelf'), 'source', shelfs);
                    }
                    hTables.render();
                });
                if (responseData.length > 0)
                    $('.searchResults').show();
                else
                    $('.searchResults').hide();

            });
        }

        var onValidateCellData = function (isValid, value, row, prop, source) {
            //var btnSave= $('#btnSave');
            //if (!isValid)
            //    $(btnSave).prop('disabled',false);
            //else
            //    $(btnSave).prop('disabled',true);
        }
        var getGridSetting = function (callback) {
            var s = {
                data: responseData,
                rowHeaders: true,
                contextMenu: false,
                filters: true,
                height: 350,
                stretchH: 'all',
                afterValidate: onValidateCellData,
                contextMenu: { callback: function (key, selection, clickEvent) { }, items: { 'row_above': {}, 'row_below': {}, 'remove_row': {} } },
                colHeaders: ['Department', 'Vitial Name',  'IsMandtory'],
                columns: [{ data: "DepartmentName", type: 'text', readOnly: true },
                          { data: "VitialSign", type: 'text', readOnly: true },
						 
						  {
						      data: 'IsMandtory',
						      type: 'dropdown',
						      source: ['N', 'Y'],
						      allowInvalid: false
						  }
                ]}
            callback(s);
        }

        getVitialSignMappedList = function (callback) {
            var data = [];
            $(hTables.getData()).each(function () {
                //var loyalityCategoryID = this.LoyalityCategoryID;
               // var s = loyalityCategerys.master.filter(function (i) { if (i.Name == loyalityCategoryID) { return i; } });
                //var LoyalityCategoryID = s.length > 0 ? s[0].ID : 0;
                data.push({
                    Department: $.trim(this.DepartmentName),
                    VitialSign: $.trim(this.VitialSign),
                    VitialID: Number(this.VitialID),
                    DepartmentID: Number(this.DepartmentID),
                    Ismandtory: this.IsMandtory,
                    CentreID:Number(this.CentreID)
                });
            });
            callback(data);
        }

        var saveVitialSignMapped = function (btnsave)
        {
            getVitialSignMappedList(function (data) {

                $(btnSave).attr('disabled', true).val('Submitting...');
                
                serverCall('../CPOE/services/Cpoe_CommonServices.asmx/SaveDeptWiseVitilMandtory', { VitialSign: data }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status){
                        modelAlert($responseData.response, function () {
                            window.location.reload();
                        });
                    }
                    else {
                        modelAlert($responseData.response, function () {
                            $(btnSave).removeAttr('disabled').val('Save');
                        });
                    }

                    });
                });
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b><span id="lblHeader" style="font-weight: bold;">Set A Doctor Wise Vital Sign Mandtory</span></b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Doctor Department wise Vitial Sign Mandtory</div>
            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">Doctor Department</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <select id="ddlDoctorDepartment"></select>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">
                <div class="col-md-24">
                    <input type="button" id="btnSearch" value="Search" title="Please Click To Search" onclick="VitalSignList()" />
                </div>
            </div>
            </div>

        <div class="POuter_Box_Inventory searchResults">
            <div class="row">
                <div class="col-md-24">
                    <div id="divDeptWiseVitialList"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory searchResults" style="text-align: center; display: none">
            <div class="row">
                <div class="col-md-24">
                    <input type="button" value="Save" class=" save margin-top-on-btn" onclick="saveVitialSignMapped(this);" id="btnSave" />

                </div>

            </div>
            </div>
    </div>

</asp:Content>
